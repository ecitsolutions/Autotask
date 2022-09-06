<#

    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

#>
Function Update-AtwsRamCache {
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
            Update-AtwsDiskCache
            Gets all valid built-in fields and user defined fields for the Account entity.
  #>
	
    [cmdletbinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Low'
    )]
    Param
    ()
  
    Begin {
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
        # Check if we are connected before trying anything
        if (-not($Script:Atws)) {
            Throw [ApplicationException] 'Not connected to Autotask WebAPI. Connect with Connect-AtwsWebAPI. For help use "get-help Connect-AtwsWebAPI".'
        }
    
        # Has cache been loaded?
        if ($Script:FieldInfoCache.Count -eq 0) {
            # Load it.
            Initialize-AtwsRamCache
        }
        # Load current API version from API
        $CurrentApiVersion = $Script:Atws.GetWsdlVersion($Script:Atws.IntegrationsValue)
        $CacheApiVersion = $Script:FieldInfoCache.ApiVersion.Tostring()

        # Define all known entities that support UDFs (not available programatically from the API)
        $supportsUdf = @('Account', 'AccountLocation', 'Contact', 'Contract', 'InstalledProduct', 'Opportunity', 'Product', 'Project', 'SalesOrder', 'Task', 'Ticket')
    }

    Process { 
        # Prepare parameters for @splatting
        $Activity = 'Online API version {0}, Cache API version {1}. Current Module version {2}, cache module version {3}. Recreating diskcache.'
        $ProgressParameters = @{
            Activity = ( $Activity -F $CurrentApiVersion, $CacheApiVersion, $CurrentModuleVersion, $CacheModuleVersion)
            Id       = 9
        }
    
        $Entities = $Script:Atws.GetEntityInfo($Script:Atws.IntegrationsValue)
        
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: Retreiving detailed field information about {1} entities. This will take a while. Go grab some coffee.' -F $caption, $Entities.count
        $verboseWarning = '{0}: About to post {1} SOAP queries to Autotask Web API for detailed field info for {1} entities. This will take a while. Do you want to continue?' -F $caption, $Entities.count
          
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
            
            # Prepare a hashtable
            $script:FieldInfoCache = @{
                ApiVersion = $CurrentApiVersion
            }

            # Loop through entities and get fresh info from API
            foreach ($object in $Entities) { 
    
                Write-Verbose -Message ('{0}: Importing detailed information about Entity {1}' -F $MyInvocation.MyCommand.Name, $object.Name) 


                # to hashtables, one with picklists (for RAM), 1 for disk
                # otherwise variable pass by reference may interfere
                $entityinfo = @{}
                $baseentity = @{}

                # Calculating progress percentage and displaying it
                $Index = $Entities.IndexOf($object) + 1
                $PercentComplete = $Index / $Entities.Count * 100
                $Status = 'Entity {0}/{1} ({2:n0}%)' -F $Index, $Entities.Count, $PercentComplete
                $CurrentOperation = "GetFieldInfo('{0}')" -F $object.Name
      
                Write-AtwsProgress -Status $Status -PercentComplete $PercentComplete -CurrentOperation $CurrentOperation @ProgressParameters
                
                # Create hashtable of entityinfo. Speeds up lookup
                foreach ($property in $object.psobject.properties) {
                    $entityinfo[$property.Name] = $property.Value
                    $baseentity[$property.Name] = $property.Value
                }

                # Extra check for fields that should support UDFs, but where there may no have been defined
                # any yet. Any object that has UDFs defined will already have this property set to $true
                if ($object.name -in $supportsUdf) {
                    $entityinfo['HasUserDefinedFields'] = $true
                }

                $Script:FieldInfoCache[$object.Name] = $entityinfo

                # Lookup FieldInfo from API
                Update-AtwsEntity -Entity $object.Name
            }

            # Get a copy of cache that can be used as a basis for a tenant independent cache file
            # First create a temporary file
            $tempFile = New-TemporaryFile

            # Export fieldcache to temp file
            $Script:FieldInfoCache | Export-Clixml -Path $tempFile.FullName

            # Read cache back as new object to avoid pass by reference
            $base = Import-Clixml -Path $tempFile.FullName

            # Remove temp file
            Remove-Item $tempFile -Force
            
            # Clean out any picklists and UDF values from base
            foreach ($entry in $base.GetEnumerator()) {
                if ($entry.Value.HasUserDefinedFields) {
                    $base[$entry.Key]['UDFinfo'] = $null
                }
                if($entry.Value.HasPicklist) {
                    foreach ($field in $entry.Value.FieldInfo.GetEnumerator()) {
                        if ($field.Value.IsPickList) {
                            $base[$entry.Key]['FieldInfo'][$field.Name].PicklistValues = $null
                        }
                    }
                }
            }

            if ($CurrentOperation) { 
                Write-AtwsProgress @progressParameters -PercentComplete 100 -Completed
            }
       
        }
    }
  
    End { 
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: Overwriting existing module info cache with updated data.' -F $caption
        $verboseWarning = '{0}: About to overwrite existing module info cache with updated data. This cannot be undone. Do you want to continue?' -F $caption
          
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
            # Save updated base info for connection to new tenants.      
            $BaseEntityInfoPath = '{0}\Private\AutotaskFieldInfoCache.xml' -F $MyInvocation.MyCommand.Module.ModuleBase
            $Base | Export-Clixml -Path $BaseEntityInfoPath -Force
    
            Write-Verbose -Message ('{0}: Updated central module fieldinfocache.' -F $MyInvocation.MyCommand.Name)
        }
    }
}