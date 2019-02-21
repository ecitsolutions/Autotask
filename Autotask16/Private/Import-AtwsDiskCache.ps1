Function Import-AtwsDiskCache
{
  [CmdLetBinding()]
  
  Param()

  Begin
  {
    Write-Verbose -Message ('{0}: Trying to determine correct location for dynamic module cache.' -F $MyInvocation.MyCommand.Name)    
    
    # Get the current module name
    $MyModule = (Get-Command -Name $MyInvocation.MyCommand.Name).Module
    
    $CacheFile = 'FieldInfoCache.xml'
    
    $ModuleBase = Split-Path $MyModule.ModuleBase -Parent
    
    $CentralCache = '{0}\{1}\{2}' -F $ModuleBase, $MyModule.Name, $CacheFile

    Write-Verbose -Message ('{0}: Module cache location is {1}' -F $MyInvocation.MyCommand.Name, $CentralCache)    
    
    $PersonalCacheDir = '{0}\WindowsPowershell\Cache' -f $([environment]::GetFolderPath('MyDocuments'))
    $PersonalCache = '{0}\{1}' -F $PersonalCacheDir, $CacheFile
    
    
    Write-Verbose -Message ('{0}: Personal cache location is {1}.' -F $MyInvocation.MyCommand.Name, $PersonalCache)   
  }
  
  Process
  {
    If (-not (Test-Path $PersonalCache))
    {
      Write-Verbose -Message ('{0}: There is no personal cache. Creating from central location.' -F $MyInvocation.MyCommand.Name)
      
      # Create Personalcache directory if it doesn't exist
      If (-not (Test-Path $PersonalCacheDir)) {
        New-Item -Path $PersonalCacheDir -ItemType Directory
      }
      
      # Copy the cache
      Copy-Item -Path $CentralCache -Destination $PersonalCache -Force
           
    }
    
    # This should work now!
    If (Test-Path $PersonalCache)
    {
      Write-Verbose -Message ('{0}: Reading cache from disk.' -F $MyInvocation.MyCommand.Name)
      
      $Script:Cache = Import-Clixml -Path $PersonalCache
  
    }
    Else {
      Throw [System.Exception] "Coult not create a cache file."
    }

  }
  
  End
  {
    Return $PersonalCache
  }
}
