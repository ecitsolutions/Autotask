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
     
    # Get the current module name
    $MyModule = (Get-Command -Name $MyInvocation.MyCommand.Name).Module
    
    $CacheFile = 'AutotaskFieldInfoCache.xml'
    
    $CentralCache = '{0}\Private\{1}' -F $MyModule.ModuleBase, $CacheFile

  }
  
  Process
  {
               
    $Caption = $MyInvocation.MyCommand.Name
    $VerboseDescrition = '{0}: Saving updated cache info to {1}' -F $Caption, $CentralCache
    $VerboseWarning = '{0}: About to save updated cache info to {1}. Do you want to continue?' -F $Caption, $CentralCache
          
    If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
            
      $Script:Cache | Export-Clixml -Path $CentralCache -Encoding UTF8 -Force
    
    }
  }
  
  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)    
  }
}
