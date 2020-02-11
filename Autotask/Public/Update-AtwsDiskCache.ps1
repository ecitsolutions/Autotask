<#

    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

#>
Function Update-AtwsDiskCache {
    <#
      .SYNOPSIS
      This function reads all entities with detailed fieldinfo and writes everything to disk.
      .DESCRIPTION
      This function reads all entities with detailed fieldinfo and writes everything to disk.
      .INPUTS
      None.
      .OUTPUTS
      Nothing (writes data to disk)
      .EXAMPLE
      Import-AtwsAPIVersionToCache
      Gets all valid built-in fields and user defined fields for the Account entity.
  #>
	
    [cmdletbinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    Param
    (
    )
  
    Begin {
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
        # Check if we are connected before trying anything
        if (-not($Script:Atws)) {
            Throw [ApplicationException] 'Not connected to Autotask WebAPI. Re-import module with valid credentials.'
        }
    
        # Has cache been loaded?
        if (-not($script:Cache)) {
            # Load it.
            Import-AtwsDiskCache
        }
        # Load current API version from API
        $CurrentApiVersion = $Script:Atws.GetWsdlVersion($script:atws.IntegrationsValue)
        $CurrentModuleVersion = $My.ModuleVersion
        $CacheApiVersion = $script:Cache[$Script:Atws.CI].ApiVersion.Tostring()
        $CacheModuleVersion = $script:Cache[$Script:Atws.CI].ModuleVersion.Tostring()
    }

    Process { 
        # Prepare parameters for @splatting
        $Activity = 'Online API version {0}, Cache API version {1}. Current Module version {2}, cache module version {3}. Recreating diskcache.'
        $ProgressParameters = @{
            Activity = ( $Activity -F $CurrentApiVersion, $CacheApiVersion, $CurrentModuleVersion, $CacheModuleVersion)
            Id       = 9
        }
    
        $Entities = $Script:Atws.GetEntityInfo($script:atws.IntegrationsValue)
        
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: Retreiving detailed field information about {1} entities. This will take a while. Go grab some coffee.' -F $caption, $Entities.count
        $verboseWarning = '{0}: About to post {1} SOAP queries to Autotask Web API for detailed field info for {1} entities. This will take a while. Do you want to continue?' -F $caption, $Entities.count
          
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
                 
            $script:FieldInfoCache = @{ }

            foreach ($object in $Entities) { 
    
                Write-Verbose -Message ('{0}: Importing detailed information about Entity {1}' -F $MyInvocation.MyCommand.Name, $object.Name) 

                # Calculating progress percentage and displaying it
                $Index = $Entities.IndexOf($object) + 1
                $PercentComplete = $Index / $Entities.Count * 100
                $Status = 'Entity {0}/{1} ({2:n0}%)' -F $Index, $Entities.Count, $PercentComplete
                $CurrentOperation = "GetFieldInfo('{0}')" -F $object.Name
      
                Write-Progress -Status $Status -PercentComplete $PercentComplete -CurrentOperation $CurrentOperation @ProgressParameters
 
                # Retrieving FieldInfo for current Entity
                $fieldInfo = $Script:Atws.GetFieldInfo($script:atws.IntegrationsValue, $object.Name)
            
                # Check if entity has picklists
                $HasPickList = $false
                if ($fieldInfo.Where( { $_.IsPicklist })) {
                    $HasPickList = $true
                }
                       
                # Create Cache entry
                $CacheEntry = New-Object -TypeName PSObject -Property @{
                    HasPickList   = $HasPickList
                    RetrievalTime = Get-Date
                }
            
                # Check if entity has userdefined fields
                if ($object.HasUserDefinedFields) {
                    $UDF = $Script:Atws.GetUDFInfo($object.Name)
                    Add-Member -InputObject $CacheEntry -MemberType NoteProperty -Name UDFInfo -Value $UDF -Force
                }
                        
                # Add complext objects as properties
                Add-Member -InputObject $CacheEntry -MemberType NoteProperty -Name EntityInfo -Value $object -Force
                Add-Member -InputObject $CacheEntry -MemberType NoteProperty -Name FieldInfo -Value $fieldInfo -Force
            
                $Script:FieldInfoCache[$object.Name] = $CacheEntry

            }
        
            # Add cache to $Cache object and save to disk
            $Script:Cache[$Script:Atws.CI] = New-Object -TypeName PSObject -Property @{
                ApiVersion    = $CurrentApiVersion
                ModuleVersion = [Version]$My.ModuleVersion
            }
            # Use Add-member to store complete object, not its typename
            Add-Member -InputObject $Script:Cache[$Script:Atws.CI] -MemberType NoteProperty -Name FieldInfoCache -Value $fieldInfoCache 
    
            # Add new base reference
            $Script:Cache['00'] = New-Object -TypeName PSObject -Property @{
                ApiVersion    = $CurrentApiVersion
                ModuleVersion = [Version]$My.ModuleVersion
            }
    
            # Clone current fieldinfo cache to new object
            $Base = Copy-PSObject -InputObject $fieldInfoCache
        
            # Clean Instance specific info from Base
            foreach ($object in $Base.GetEnumerator().Where( { $_.Value.HasPickList -or $_.Value.EntityInfo.HasUserDefinedFields })) {
                foreach ($PickList in $object.Value.FieldInfo.Where( { $_.IsPickList })) {
                    $PickList.PicklistValues = $null
                }
          
                if ($object.Value.EntityInfo.HasUserDefinedFields) {
                    $object.Value.UDFInfo = $null
                }
            }
        
            # Use Add-member to store complete object, not its typename
            Add-Member -InputObject $Script:Cache['00'] -MemberType NoteProperty -Name FieldInfoCache -Value $Base 
        }
    }
  
    End { 
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: Overwriting existing disk cache with updated data.' -F $caption
        $verboseWarning = '{0}: About to overwrite existing disk cache with updated data. This cannot be undone. Do you want to continue?' -F $caption
          
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
            # Write updated cache to disk
            Export-AtwsDiskCache
        }
    }
}