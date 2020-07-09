<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Initialize-AtwsRamCache {
    <#
            .SYNOPSIS
                This function reads the cachefile into memory.
            .DESCRIPTION
                This function determines the correct path to a cache file and imports it.
                Then it creates a shadow cache for the current Autotask tenant.
            .INPUTS
                Nothing.
            .OUTPUTS
                Nothing, but the cache property of the SOAP Client object is filled.
            .EXAMPLE
                Initialize-AtwsRamCache
                Loads the cache from disk
            .NOTES
                NAME: Initialize-AtwsRamCache
            .LINK
    #>
    [CmdLetBinding()]
  
    Param()

    begin {
        Write-Verbose -Message ('{0}: trying to determine correct location for dynamic module cache.' -F $MyInvocation.MyCommand.Name)    
    
        # Get the current module name
        $myModule = (Get-Command -Name $MyInvocation.MyCommand.Name).Module
    
        $cacheFile = 'AutotaskFieldInfoCache.xml'
    
        # Use join-path to be platform agnostic on slashes in paths
        $centralCache = Join-Path $(Join-Path $myModule.ModuleBase 'Private') $cacheFile

        Write-Verbose -Message ('{0}: Module cache location is {1}' -F $MyInvocation.MyCommand.Name, $centralCache)  
        
    }
  
    process {
        # Keeping old cache code. Will use it to clean up from earlier module versions

        Write-Verbose -Message ('{0}: Initializing memory-only cache with data supplied with module ({1}).' -F $MyInvocation.MyCommand.Name, $centralCache)
        
        # Initialize memory only cache from module directory
        $Script:WebServiceCache = Import-Clixml -Path $centralCache 

        # Initialize the $Script:FieldInfoCache shorthand 
        $Script:FieldInfoCache = $Script:WebServiceCache.FieldInfoCache    

        # We must be connected to know the customer identity number
        if ($Script:Atws.CI) {
            # If the API version has been changed at the Autotask end we unfortunately have to reload all
            # entities from scratch
            $currentApiVersion = $Script:Atws.GetWsdlVersion($Script:Atws.IntegrationsValue)
            if ($Script:WebServiceCache.ApiVersion -ne $currentApiVersion -or [Version]$My.ModuleVersion -ne $Script:WebServiceCache.ModuleVersion) {
        
                # Call the import-everything function
                Update-AtwsRamCache
        
            }
        }
    }
  
    end {
        Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)    
    }
}
