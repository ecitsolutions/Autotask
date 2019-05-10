Function Import-AtwsDiskCache
{
  [CmdLetBinding()]
  
  Param()

  Begin
  {
    Write-Verbose -Message ('{0}: Loading static entity cache.' -F $MyInvocation.MyCommand.Name)    
    
    # Get the current module name
    $MyModule = (Get-Command -Name $MyInvocation.MyCommand.Name).Module
    
    $CacheFile = 'AutotaskFieldInfoCache.xml'
    
    $CentralCache = '{0}\Private\{1}' -F $MyModule.ModuleBase, $CacheFile
  }
  
  Process
  { 
    Write-Debug -Message ('{0}: Reading cache from {1}' -F $MyInvocation.MyCommand.Name, $CentralCache)    
     
    $Script:Cache = Import-Clixml -Path $CentralCache
    $Script:FieldInfoCache = $Script:Cache.FieldInfoCache
  }
  
  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)    
  }
}
