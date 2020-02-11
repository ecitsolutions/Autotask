<#

.COPYRIGHT
Copyright (c) ECIT Solutions AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.

#>
Function Import-AtwsDiskCache {
     <#
            .SYNOPSIS

            .DESCRIPTION

            .INPUTS

            .OUTPUTS

            .EXAMPLE

            .NOTES
            NAME: 
            .LINK

    #>
    [CmdLetBinding()]
  
    Param()

    begin {
        Write-Verbose -Message ('{0}: trying to determine correct location for dynamic module cache.' -F $MyInvocation.MyCommand.Name)    
    
        # Get the current module name
        $myModule = (Get-Command -Name $MyInvocation.MyCommand.Name).Module
    
        $cacheFile = 'AutotaskFieldInfoCache.xml'
    
        $centralCache = '{0}\Private\{1}' -F $myModule.ModuleBase, $cacheFile

        Write-Verbose -Message ('{0}: Module cache location is {1}' -F $MyInvocation.MyCommand.Name, $centralCache)  
        
        # On Windows we store the cache in the WindowsPowerhell folder in My documents
        # On macOS and Linux we use a dot-folder in the users $HOME folder as is customary
        if ([Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([Runtime.InteropServices.OSPlatform]::Windows)) {  
            $dynamicCache = '{0}\WindowsPowershell\Cache' -f $([environment]::GetFolderPath('MyDocuments'))
        }
        else {
            $dynamicCache = '{0}\.atwsCache' -f $([environment]::GetFolderPath('MyDocuments'))
        }

        # Use different directory for beta versions
        if ($My['IsBeta']) { 
            $PersonalCacheDir = '{0}\{1}\Beta' -f $dynamicCache, $Script:Atws.CI
        }
        else {
            $PersonalCacheDir = '{0}\{1}\Dynamic' -f $dynamicCache, $Script:Atws.CI
        }

        # Save the cache path to the module information
        $My['DynamicCache'] = $PersonalCacheDir  
        
        $PersonalCache = '{0}\{1}' -F $PersonalCacheDir, $CacheFile
        Write-Verbose -Message ('{0}: Personal cache location is {1}.' -F $MyInvocation.MyCommand.Name, $PersonalCache)   
  
    }
  
    process {
        # Do not check for existence of personal cache if asked to load module without it
        # This function should not be called from a context where this is necessary, but
        # better be on the safe side
        if ($script:atws.Configuration.UseDiskCache) { 
            if (-not (Test-Path $personalCache)) {
                Write-Verbose -Message ('{0}: There is no personal cache. Creating from central location.' -F $MyInvocation.MyCommand.Name)
      
                # Create Personalcache directory if it doesn't exist
                if (-not (Test-Path $personalCacheDir)) {
                    New-Item -Path $personalCacheDir -ItemType Directory
                }
      
                # Copy the cache
                Copy-Item -Path $centralCache -Destination $personalCache -Force
           
            }
    
            # This should work now!
            if (Test-Path $personalCache) {
                Write-Verbose -Message ('{0}: Reading cache from disk.' -F $MyInvocation.MyCommand.Name)
      
                $Script:Cache = Import-Clixml -Path $personalCache
  
            }
            else {
                Throw [System.Exception] "Coult not create a cache file."
            }
      
            # Nested testing to make sure the structure is OK
            $cacheOK = $false
            if ($Script:Cache -is [Hashtable]) {
                if ($Script:Cache.ContainsKey('00')) {
                    if ($Script:Cache['00'] -is [PSCustomObject]) {
                        if ([bool]($Script:Cache['00'].PSobject.Properties.name -match "FieldInfoCache")) {
                            if ($Script:Cache['00'].FieldInfoCache.Count -gt 0) {
                                $cacheOK = $true
                            }
                        }
                    }
                }
            }
      
            if (-not $cacheOK) {
                Write-Warning ('{0}: Personal disk cache is broken! Deleting cache and trying again!' -F $MyInvocation.MyCommand.Name)
                $null = Remove-Item -Path $personalCache -Force -ErrorAction SilentlyContinue
        
                Import-AtwsDiskCache
        
                # Do not process rest of script
                return
            }
        }
        else {
            Write-Verbose -Message ('{0}: Running with -NoDiskCache. Initializing memory-only cache with data supplied with module ({1}).' -F $MyInvocation.MyCommand.Name, $centralCache)
            
            # Initialize memory only cache from module directory
            $Script:Cache = Import-Clixml -Path $centralCache      
        }
    
        # We must be connected to know the customer identity number
        if ($script:Atws.CI) {
            # If the current connection is for a new Autotask tenant, copy the blank 
            # cache from the included pre-cache
            if (-not ($Script:Cache.ContainsKey($Script:Atws.CI))) {
                Write-Debug -Message ('{0}: Cache does not contain information about Autotask tenant {1}. Initializing.' -F $MyInvocation.MyCommand.Name, $Script:Atws.CI )
                
                # Create a cache object to store API version along with the cache
                $Script:Cache[$Script:Atws.CI] = New-Object -TypeName PSObject -Property @{
                    ApiVersion    = $Script:Cache['00'].ApiVersion
                    ModuleVersion = [Version]$My.ModuleVersion
                }
                # Use Add-Member on the Hashtable, or the propertyvalue will be set to typename only
                # Copy the hashtable to a new object. We do NOT want a referenced copy!
                $newHashTable = Copy-PSObject -InputObject $Script:Cache['00'].FieldInfoCache
                Add-Member -InputObject $Script:Cache[$Script:Atws.CI] -MemberType NoteProperty -Name FieldInfoCache -Value $newHashTable

            }

            # Initialize the $Script:FieldInfoCache shorthand 
            $Script:FieldInfoCache = $Script:Cache[$Script:Atws.CI].FieldInfoCache
      
      
            # If the API version has been changed at the Autotask end we unfortunately have to reload all
            # entities from scratch
            $currentApiVersion = $Script:Atws.GetWsdlVersion($script:atws.IntegrationsValue)
            if ($Script:Cache[$Script:Atws.CI].ApiVersion -ne $currentApiVersion -or [Version]$My.ModuleVersion -ne $Script:Cache[$Script:Atws.CI].ModuleVersion) {
        
                # Write-Warning to inform user that an update of static functions is due
                if ($Script:Cache[$Script:Atws.CI].ApiVersion -ne $currentApiVersion) { 
                    Write-Warning ('{0}: API version has been updated. You need to run "Update-AtwsFunctions -FunctionSet static" with writepermissions to the module directory or update the module.' -F $MyInvocation.MyCommand.Name) 
                }
        
                # Call the import-everything function
                Update-AtwsDiskCache
        
            }
      
        }
        else {
            Write-Debug -Message ('{0}: No connection to Autotask or running with -NoDiskCache. Loading using module supplied data for Get-AtwsFieldInfo.' -F $MyInvocation.MyCommand.Name )
          
            # Initialize the $Script:FieldInfoCache shorthand for base entity info
            $Script:FieldInfoCache = $Script:Cache['00'].FieldInfoCache
        }
    }
  
    end {
        Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)    
    }
}
