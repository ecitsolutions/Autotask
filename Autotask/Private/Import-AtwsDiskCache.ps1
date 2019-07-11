Function Import-AtwsDiskCache
{
  [CmdLetBinding()]
  
  Param()

  Begin
  {
    Write-Verbose -Message ('{0}: Trying to determine correct location for dynamic module cache.' -F $MyInvocation.MyCommand.Name)    
    
    # Get the current module name
    $MyModule = (Get-Command -Name $MyInvocation.MyCommand.Name).Module
    
    $CacheFile = 'AutotaskFieldInfoCache.xml'
    
    $CentralCache = '{0}\Private\{1}' -F $MyModule.ModuleBase, $CacheFile

    Write-Verbose -Message ('{0}: Module cache location is {1}' -F $MyInvocation.MyCommand.Name, $CentralCache)    
    
    $PersonalCacheDir = '{0}\WindowsPowershell\Cache' -f $([environment]::GetFolderPath('MyDocuments'))
    $PersonalCache = '{0}\{1}' -F $PersonalCacheDir, $CacheFile
    
    $UpdateCache = $False
    
    Write-Verbose -Message ('{0}: Personal cache location is {1}.' -F $MyInvocation.MyCommand.Name, $PersonalCache)   
  }
  
  Process
  {
    # Do not check for existence of personal cache if asked to load module without it
    If ($Script:UseDiskCache)
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
      
      # Nested testing to make sure the structure is OK
      $CacheOK = $False
      If ($Script:Cache -is [Hashtable]) {
        If ($Script:Cache.ContainsKey('00')) {
          If ($Script:Cache['00'] -is [PSCustomObject]) {
            If ([bool]($Script:Cache['00'].PSobject.Properties.name -match "FieldInfoCache")) {
              If ($Script:Cache['00'].FieldInfoCache.Count -gt 0) {
                $CacheOK = $True
              }
            }
          }
        }
      }
      
      If (-not $CacheOK) {
        Write-Warning ('{0}: Personal disk cache is broken! Deleting cache and trying again!' -F $MyInvocation.MyCommand.Name)
        $Null = Remove-Item -Path $PersonalCache -Force -ErrorAction SilentlyContinue
        
        Import-AtwsDiskCache
        
        # Do not process rest of script
        Return
      }
    }
    Else
    {
      Write-Verbose -Message ('{0}: Running with -NoDiskCache. Initializing memory-only cache with data supplied with module ({1}).' -F $MyInvocation.MyCommand.Name, $CentralCache)
            
      # Initialize memory only cache from module directory
      $Script:Cache = Import-Clixml -Path $CentralCache      
    }
    
    # We must be connected to know the customer identity number
    If ($Script:Atws -and $Script:UseDiskCache) {
      # If the current connection is for a new Autotask tenant, copy the blank 
      # cache from the included pre-cache
      If (-not ($Script:Cache.ContainsKey($Script:Atws.CI))) {
        Write-Debug -Message ('{0}: Cache does not contain information about Autotask tenant {1}. Initializing.' -F $MyInvocation.MyCommand.Name,$Script:Atws.CI )
                
        # Create a cache object to store API version along with the cache
        $Script:Cache[$Script:Atws.CI] = New-Object -TypeName PSObject -Property @{
          ApiVersion = $Script:Cache['00'].ApiVersion
          ModuleVersion = [Version]$My.ModuleVersion
        }
        # Use Add-Member on the Hashtable, or the propertyvalue will be set to typename only
        # Copy the hashtable to a new object. We do NOT want a referenced copy!
        $NewHashTable = Copy-PSObject -InputObject $Script:Cache['00'].FieldInfoCache
        Add-Member -InputObject $Script:Cache[$Script:Atws.CI] -MemberType NoteProperty -Name FieldInfoCache -Value $NewHashTable

      }

      # Initialize the $Script:FieldInfoCache shorthand 
      $Script:FieldInfoCache = $Script:Cache[$Script:Atws.CI].FieldInfoCache
      
      
      # If the API version has been changed at the Autotask end we unfortunately have to reload all
      # entities from scratch
      $CurrentApiVersion = $Script:Atws.GetWsdlVersion()
      If ($Script:Cache[$Script:Atws.CI].ApiVersion -ne $CurrentApiVersion -or [Version]$My.ModuleVersion -ne $Script:Cache[$Script:Atws.CI].ModuleVersion -or $UpdateCache) {
        
        # Write-Warning to inform user that an update of static functions is due
        If ($Script:Cache[$Script:Atws.CI].ApiVersion -ne $CurrentApiVersion) { 
          Write-Warning ('{0}: API version has been updated. You need to run "Update-AtwsFunctions -FunctionSet static" with writepermissions to the module directory or update the module.' -F $MyInvocation.MyCommand.Name) 
        }
        
        # Call the import-everything function
        Update-AtwsDiskCache
        
      }
      
    }
    Else {
      Write-Debug -Message ('{0}: No connection to Autotask or running with -NoDiskCache. Loading using module supplied data for Get-AtwsFieldInfo.' -F $MyInvocation.MyCommand.Name )
          
      # Initialize the $Script:FieldInfoCache shorthand for base entity info
      $Script:FieldInfoCache = $Script:Cache['00'].FieldInfoCache
    }
  }
  
  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)    
  }
}
