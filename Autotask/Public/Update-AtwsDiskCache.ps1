<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md  for license information.

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
      SupportsShouldProcess = $True,
      ConfirmImpact = 'Medium'
  )]
  Param
  (
  )
  
  Begin
  {
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
    # Check if we are connected before trying anything
    If (-not($Script:Atws)) {
      Throw [ApplicationException] 'Not connected to Autotask WebAPI. Re-import module with valid credentials.'
    }
    
    # Has cache been loaded?
    If (-not($script:Cache)) {
      # Load it.
      Import-AtwsDiskCache
    }
    # Load current API version from API
    $CurrentApiVersion = $Script:Atws.GetWsdlVersion()
  }

  Process 
  { 
    # Prepare parameters for @splatting
    $ProgressParameters = @{
      Activity = ('API version {0}. Downloading detailed information about all entities and all fields. Recreating diskcache.' -F $CurrentApiVersion)
      Id = 9
    }
    
    $Entities = $Script:Atws.getEntityInfo()
        
    $Caption = $MyInvocation.MyCommand.Name
    $VerboseDescrition = '{0}: Retreiving detailed field information about {1} entities. This will take a while. Go grab some coffee.' -F $Caption, $Entities.count
    $VerboseWarning = '{0}: About to post {1} SOAP queries to Autotask Web API for detailed field info for {1} entities. This will take a while. Do you want to continue?' -F $Caption, $Entities.count
          
    If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
                 
      $script:FieldInfoCache = @{}

      Foreach ($Object in $Entities) { 
    
        Write-Verbose -Message ('{0}: Importing detailed information about Entity {1}' -F $MyInvocation.MyCommand.Name, $Object.Name) 

        # Calculating progress percentage and displaying it
        $Index = $Entities.IndexOf($Object) + 1
        $PercentComplete = $Index / $Entities.Count * 100
        $Status = 'Entity {0}/{1} ({2:n0}%)' -F $Index, $Entities.Count, $PercentComplete
        $CurrentOperation = "GetFieldInfo('{0}')" -F $Object.Name
      
        Write-Progress -Status $Status -PercentComplete $PercentComplete -CurrentOperation $CurrentOperation @ProgressParameters
 
        # Retrieving FieldInfo for current Entity
        $FieldInfo = $Script:Atws.GetFieldInfo($Object.Name)
            
        # Check if entity has picklists
        $HasPickList = $False
        If ($FieldInfo.Where({$_.IsPicklist})) {
          $HasPickList = $True
        }
                       
        # Create Cache entry
        $CacheEntry = New-Object -TypeName PSObject -Property @{
          HasPickList   = $HasPickList
          RetrievalTime = Get-Date
        }
            
        # Check if entity has userdefined fields
        If ($Object.HasUserDefinedFields) {
          $UDF = $Script:Atws.GetUDFInfo($Object.Name)
          Add-Member -InputObject $CacheEntry -MemberType NoteProperty -Name UDFInfo -Value $UDF -Force
        }
                        
        # Add complext objects as properties
        Add-Member -InputObject $CacheEntry -MemberType NoteProperty -Name EntityInfo -Value $Object -Force
        Add-Member -InputObject $CacheEntry -MemberType NoteProperty -Name FieldInfo -Value $FieldInfo -Force
            
        $Script:FieldInfoCache[$Object.Name] = $CacheEntry

      }
        
      # Add cache to $Cache object and save to disk
      $Script:Cache[$Script:Atws.CI] = New-Object -TypeName PSObject -Property @{
        ApiVersion = $CurrentApiVersion
      }
      # Use Add-member to store complete object, not its typename
      Add-Member -InputObject $Script:Cache[$Script:Atws.CI] -MemberType NoteProperty -Name FieldInfoCache -Value $FieldInfoCache 
    
      # Add new base reference
      $Script:Cache['00'] =New-Object -TypeName PSObject -Property @{
        ApiVersion = $CurrentApiVersion
      }
    
      # Clone current fieldinfo cache to new object
      $Base = Copy-PSObject -InputObject $FieldInfoCache
        
      # Clean Instance specific info from Base
      Foreach ($Object in $Base.GetEnumerator().Where({$_.Value.HasPickList -or $_.Value.EntityInfo.HasUserDefinedFields}))
      {
        Foreach ($PickList in $Object.Value.FieldInfo.Where({$_.IsPickList}))
        {
          $PickList.PicklistValues = $Null
        }
          
        If ($Object.Value.EntityInfo.HasUserDefinedFields)
        {
          $Object.Value.UDFInfo = $Null
        }
      }
        
      # Use Add-member to store complete object, not its typename
      Add-Member -InputObject $Script:Cache['00'] -MemberType NoteProperty -Name FieldInfoCache -Value $Base 
    }
  }
  
  End 
  { 
    $Caption = $MyInvocation.MyCommand.Name
    $VerboseDescrition = '{0}: Overwriting existing disk cache with updated data.' -F $Caption
    $VerboseWarning = '{0}: About to overwrite existing disk cache with updated data. This cannot be undone. Do you want to continue?' -F $Caption
          
    If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
      # Write updated cache to disk
      Export-AtwsDiskCache
    }
  }
}