<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Export-AtwsDiskCache {
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
        if (-not ($Script:Cache)) {
            Write-Error -Message 'The diskcache has not been imported yet. Noting to save.'
            Return
        }
     
        $CacheFile = 'AutotaskFieldInfoCache.xml'
        if ([Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([Runtime.InteropServices.OSPlatform]::Windows)) {  
            $PersonalCacheDir = '{0}\WindowsPowershell\Cache' -f $([environment]::GetFolderPath('MyDocuments'))
        }
        else {
            $PersonalCacheDir = '{0}\.atwsCache' -f $([environment]::GetFolderPath('MyDocuments'))
        }
        $PersonalCache = '{0}\{1}' -F $PersonalCacheDir, $CacheFile

        Write-Verbose -Message ('{0}: Personal cache location is {1}.' -F $MyInvocation.MyCommand.Name, $PersonalCache)   
    }
  
    process {
        # If the module variable UseDiskCache is $false or does not exist, this function does nothing...
    
        if ($Script:UseDiskCache) { 
            # This REALLY should be there, but better safe than sorry
            # Create Personalcache directory if it doesn't exist
            if (-not (Test-Path $PersonalCacheDir)) {
      
                $caption = $MyInvocation.MyCommand.Name
                $verboseDescription = '{0}: Creating a new personal cache dir {1}' -F $caption, $PersonalCacheDir
                $verboseWarning = '{0}: About to create a new personal cache dir {1}. Do you want to continue?' -F $caption, $PersonalCacheDir
          
                if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
                    New-Item -Path $PersonalCacheDir -ItemType Directory
                }
    
            }
               
            $caption = $MyInvocation.MyCommand.Name
            $verboseDescription = '{0}: Saving updated cache info to {1}' -F $caption, $PersonalCache
            $verboseWarning = '{0}: About to save updated cache info to {1}. Do you want to continue?' -F $caption, $PersonalCache
          
            if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
            
                $Script:Cache | Export-Clixml -Path $PersonalCache -Force
    
            }
        }
    }
  
    end {
        Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)    
    }
}
