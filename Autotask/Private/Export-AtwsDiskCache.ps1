Function Export-AtwsDiskCache
{
  [CmdLetBinding()]
  
  Param()

  Begin
  {
    If (-not ($Script:Cache)) {
      Write-Error -Message 'The diskcache has not been imported yet. Noting to save.'
      Return
    }
     
    $CacheFile = 'AutotaskFieldInfoCache.xml'
    $PersonalCacheDir = '{0}\WindowsPowershell\Cache' -f $([environment]::GetFolderPath('MyDocuments'))
    $PersonalCache = '{0}\{1}' -F $PersonalCacheDir, $CacheFile

    Write-Verbose -Message ('{0}: Personal cache location is {1}.' -F $MyInvocation.MyCommand.Name, $PersonalCache)   
  }
  
  Process
  {
    # This REALLY should be there, but better safe than sorry
    # Create Personalcache directory if it doesn't exist
    If (-not (Test-Path $PersonalCacheDir)) {
      
      $Caption = $MyInvocation.MyCommand.Name
      $VerboseDescrition = '{0}: Creating a new personal cache dir {1}' -F $Caption, $PersonalCacheDir
      $VerboseWarning = '{0}: About to create a new personal cache dir {1}. Do you want to continue?' -F $Caption, $PersonalCacheDir
          
      If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
        New-Item -Path $PersonalCacheDir -ItemType Directory
      }
    
    }
               
    $Caption = $MyInvocation.MyCommand.Name
    $VerboseDescrition = '{0}: Saving updated cache info to {1}' -F $Caption, $PersonalCache
    $VerboseWarning = '{0}: About to save updated cache info to {1}. Do you want to continue?' -F $Caption, $PersonalCache
          
    If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
            
      $Script:Cache | Export-Clixml -Path $PersonalCache -Force
    
    }
  }
  
  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)    
  }
}
