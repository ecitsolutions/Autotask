Function Get-AtwsCacheInfo
{
  [CmdLetBinding()]
  
  Param
  (
    [String]
    $Prefix = 'Atws'
  )

  Begin
  {
    Write-Verbose -Message ('{0}: Trying to determine correct location for dynamic module cache.' -F $MyInvocation.MyCommand.Name)    
    
    $ModuleAutotask = Get-Module -Name Autotask
    $ModuleVersionFileName = 'ModuleVersionInfo.xml'
    $ModuleVersionInfo = New-Object -TypeName PSObject -Property @{
      APIversion = $AtwsConnection[$Prefix].GetWsdlVersion()
      ModuleVersion = $ModuleAutotask.Version.ToString()
      CI = ($AtwsConnection[$Prefix].getZoneInfo($AtwsConnection[$Prefix].Credentials.UserName)).CI
    }
    If ($ModuleAutotask.ModuleBase -like "$Env:ProgramFiles*")
    { 
      $ModuleBase = Split-Path $ModuleAutotask.ModuleBase -Parent
    }
    Else
    {
      $ModuleBase = '{0}\WindowsPowerShell\Modules\{1}' -F $Env:ProgramFiles, $ModuleAutotask.Name
    }

    $CentralCache = '{0}\Autotask.{1}\{2}' -F $ModuleBase, $Prefix, $ModuleVersionFileName

    Write-Verbose -Message ('{0}: Machine cache location is {1}. Loaded module version is {2} and API version is {3}.' -F $MyInvocation.MyCommand.Name, $CentralCache, $ModuleVersionInfo.ModuleVersion, $ModuleVersionInfo.APIversion)    
    
    $PersonalModules = '{0}\WindowsPowershell\Modules' -f $([environment]::GetFolderPath('MyDocuments'))
    $PersonalCache = '{0}\{1}\Autotask.{2}\{3}' -F $PersonalModules, $ModuleAutotask.Name, $Prefix, $ModuleVersionFileName
    
    Write-Verbose -Message ('{0}: Personal cache location is {1}. Loaded module version is {2} and API version is {3}.' -F $MyInvocation.MyCommand.Name, $CentralCache, $ModuleVersionInfo.ModuleVersion, $ModuleVersionInfo.APIversion)   
    
    $CacheDirty = $True
  }
  
  Process
  {
  
    If (Test-Path $PersonalCache)
    {
      Write-Verbose -Message ('{0}: A personal cache already exists for prefix {1}' -F $MyInvocation.MyCommand.Name, $Prefix)
      
      $CurrentVersionInfo = Import-Clixml -Path $PersonalCache
      $CachePath = $PersonalCache 
      If ($CurrentVersionInfo.APIversion -eq $ModuleVersionInfo.APIversion `
      -and $CurrentVersionInfo.ModuleVersion -eq $ModuleVersionInfo.ModuleVersion`
      -and $CurrentVersionInfo.CI -eq $ModuleVersionInfo.CI)
      {
        Write-Verbose -Message ('{0}: Personal cache is clean. Loading from personal cache.' -F $MyInvocation.MyCommand.Name)
                
        $CacheDirty = $False
      }
      Else
      {
        Write-Verbose -Message ('{0}: Personal cache exists, but is not up to date. Recreating cache.' -F $MyInvocation.MyCommand.Name)
      }
  
    }
    ElseIf (Test-Path $CentralCache)
    {
      Write-Verbose -Message ('{0}: There is no personal cache. Checking central cache location.' -F $MyInvocation.MyCommand.Name)
            
      $CurrentVersionInfo = Import-Clixml -Path $CentralCache
      Try 
      { 
        [io.file]::OpenWrite($CentralCache).close()
        $CentralPathWritable = $True
      }
      Catch 
      { 
        $CentralPathWritable = $False
      }

      If ($CurrentVersionInfo.APIversion -eq $ModuleVersionInfo.APIversion `
        -and $CurrentVersionInfo.ModuleVersion -eq $ModuleVersionInfo.ModuleVersion`
        -and $CurrentVersionInfo.CI -eq $ModuleVersionInfo.CI)
      {
        Write-Verbose -Message ('{0}: Central cache is clean. Loading from central cache.' -F $MyInvocation.MyCommand.Name)
                
        $CacheDirty = $False
        $CachePath = $CentralCache
        
      }
      ElseIf ($CentralPathWritable)
      {
        Write-Verbose -Message ('{0}: Central cache exists, but is not up to date. It is writable for current user. Recreating cache.' -F $MyInvocation.MyCommand.Name)
                
        $CachePath = $CentralCache
      }
      Else
      {
        Write-Verbose -Message ('{0}: Central cache exists, but is not up to date. It is NOT writable for current user. Using personal cache.' -F $MyInvocation.MyCommand.Name)
        Write-Warning -Message ('{0}: Central cache exists in location {1}, but is not up to date. It is NOT writable for current user. Using personal cache {1}.' -F $MyInvocation.MyCommand.Name, $CentralCache, $PersonalCache)
        $CachePath = $PersonalCache  
      }
  
    }
    Else
    {
      Write-Verbose -Message ('{0}: No cache exists, checking if a central cache location is writable.' -F $MyInvocation.MyCommand.Name)
            
      Try 
      { 
        $CacheDir = Split-Path $CentralCache -Parent
        $Null = New-Item -Path $CacheDir -ItemType Directory -Force -ErrorAction Stop
        $CachePath = $CentralCache
        
        Write-Verbose -Message ('{0}: A central cache location for all users will be created in {1}' -F $MyInvocation.MyCommand.Name, $CacheDir)
                
      }
      Catch 
      { 
        Write-Verbose -Message ('{0}: A personal cache location for current user will be created along {1}' -F $MyInvocation.MyCommand.Name, $PersonalCache)
                
        $CachePath = $PersonalCache
      }
      Finally
      {
        $CacheDirty = $True
      }
    }

    $CacheDir = Split-Path $CachePath -Parent
    If (-not (Test-Path $CacheDir))
    {
      $Null = New-Item -Path $CacheDir -ItemType Directory -Force -ErrorAction Stop
    }
  }
  
  End
  {
  

    $CacheInfo = New-Object -TypeName PSObject -Property @{
      CachePath = $CachePath
      CacheDir = $CacheDir
      CacheDirty = $CacheDirty
      ModuleVersion = $ModuleAutotask.Version.ToString()
      APIversion = $AtwsConnection[$Prefix].GetWsdlVersion()      
    }

    Return $CacheInfo
  }
}
