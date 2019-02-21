<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>

Function Get-AtwsFieldInfo {
  <#
      .SYNOPSIS
      This function gets valid fields for an Autotask Entity
      .DESCRIPTION
      This function gets valid fields for an Autotask Entity
      .INPUTS
      None.
      .OUTPUTS
      [Autotask.Field[]]
      .EXAMPLE
      Get-AtwsFieldInfo -Entity Account
      Gets all valid built-in fields and user defined fields for the Account entity.
  #>
	
  [cmdletbinding(
      SupportsShouldProcess = $True,
      ConfirmImpact = 'Low'
  )]
  Param
  (
    [Parameter(
        ParameterSetName = 'get_All'
    )]
    [Switch]
    $All,
    
    [Parameter(
        Mandatory = $True,
        Position = 0,
        ParameterSetName = 'by_Entity'
    )]
    [String]
    $Entity
  )
    
  Begin { 
  
    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
    # Has cache been loaded?
    If (-not($script:Cache)) {
      # Load it.
      $CachePath = Import-AtwsDiskCache
    }
    
    # If we have a connection we can update the cache.If not, serve data just from cache.
    If ($Script:Atws) {
    
   
      # If the current connection is for a new Autotask tenant, copy the blank 
      # cache from the included pre-cache
      If (-not ($Script:Cache.ContainsKey($Script:Atws.CI))) {
        # Clone the hashtable. We do NOT want a referenced copy!
        $Script:Cache[$Script:Atws.CI] = $Script:Cache['00'].Clone()
      }
      
      # Initialize the short-hand variable reference for the fieldInfocache
      $Script:FieldInfoCache = $Script:Cache[$Script:Atws.CI].FieldInfoCache

      # If the API version has been changed at the Autotask we unfortunately have to load all
      # entities from scratch
      $CurrentApiVersion = $Script:Atws.GetWsdlVersion()
      If (-not ($Script:Cache[$Script:Atws.CI].ApiVersion -eq $CurrentApiVersion)) {
              
        $Activity = 'New API version {0} has been published, old version is {1}. recreating diskcache.' -F $CurrentApiVersion, $Script:Cache[$Script:Atws.CI].ApiVersion
        
        $script:FieldInfoCache = @{}
        $Entities = $Atws.getEntityInfo()
        
        Foreach ($Object in $Entities) { 
    
          Write-Verbose -Message ('{0}: Importing detailed information about Entity {1}' -F $MyInvocation.MyCommand.Name, $Object.Name) 

          # Calculating progress percentage and displaying it
          $Index = $Entities.IndexOf($Object) + 1
          $PercentComplete = $Index / $Entities.Count * 100
          $Status = 'Entity {0}/{1} ({2:n0}%)' -F $Index, $Entities.Count, $PercentComplete
          $CurrentOperation = "GetFieldInfo('{0}')" -F $Object.Name
      
          Write-Progress -Activity $Activity -Status $Status -PercentComplete $PercentComplete -CurrentOperation $CurrentOperation
          
          $Caption = $MyInvocation.MyCommand.Name
          $VerboseDescrition = '{0}: Retreiving detailed field information about entity {1}' -F $Caption, $Object.Name
          $VerboseWarning = '{0}: About to post a SOAP query to Autotask Web API for detailed field info for entity {1}. Do you want to continue?' -F $Caption, $Object.Name
          
          If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
            # Retrieving FieldInfo for current Entity
            $FieldInfo = $Atws.GetFieldInfo($Object.Name)
            
            # Check if entity has picklists
            $HasPickList = $False
            If ($FieldInfo.Where({$_.IsPicklist})) {
              $HasPickList = $True
            }
            
            # Create Cache entry
            $CacheEntry = New-Object -TypeName PSObject -Property @{
              HasPickList   = $HasPickList
              RetrievalTime = Get-Date
            }
            # Add complext objects as properties
            Add-Member -InputObject $CacheEntry -MemberType NoteProperty -Name EntityInfo -Value $Object -Force
            Add-Member -InputObject $CacheEntry -MemberType NoteProperty -Name FieldInfo -Value $FieldInfo -Force
            
            $Script:FieldInfoCache[$Object.Name] = $CacheEntry
          }
        }
        
        # Add cache to $Cache object and save to disk
        $Script:Cache[$Script:Atws.CI].FieldInfoCache = $FieldInfoCache 
        
        $Caption = $MyInvocation.MyCommand.Name
        $VerboseDescrition = '{0}: Saving updated cache info to {1}' -F $Caption, $CachePath
        $VerboseWarning = '{0}: About to save updated cache info to {1}. Do you want to continue?' -F $Caption, $CachePath
          
        If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
            
          $Script:Cache | Export-Clixml -Path $CachePath -Force
    
        }
        
      } 
      # We just loaded the cache from disk and the version was up to date
      Else {
        
        Write-Verbose -Message ('{0}: Loaded detailed Fieldinfo from diskcache {1}' -F $MyInvocation.MyCommand.Name, $CachePath) 
              
      }
    }
    # We do not have any connection to Autotas, yet. We have to use the cache without picklists
    Else {
      Write-Verbose -Message ('{0}: Connection not available, using default entitylist from {1}' -F $MyInvocation.MyCommand.Name, $CachePath) 
      $Script:FieldInfoCache = $Script:Cache['00'].FieldInfoCache
            
    }
    $CacheExpiry = (Get-Date).AddMinutes(-15)
  }
  
  Process { 
    
    If ($All.IsPresent) {

    # If we have a connection we can update the cache.If not, serve data just from cache.
      If ($Script:Atws) {
    
        # At this point we have a cache, but we do not know if it is fresh. We only need to check
        # entities with picklists
      
        $Activity = 'All entities has been requested. Updating picklists.'
      
        $Entities = $script:FieldInfoCache.GetEnumerator().Where{$_.Value.HasPicklist}
      
        Foreach ($Object in $Entities) {
      
          Write-Verbose -Message ('{0}: Importing detailed information about Entity {1}' -F $MyInvocation.MyCommand.Name, $Object.Key) 

          # Calculating progress percentage and displaying it
          $Index = $Entities.IndexOf($Object) + 1
          $PercentComplete = $Index / $Entities.Count * 100
          $Status = 'Entity {0}/{1} ({2:n0}%)' -F $Index, $Entities.Count, $PercentComplete
          $CurrentOperation = "GetFieldInfo('{0}')" -F $Object.Key
      
          Write-Progress -Activity $Activity -Status $Status -PercentComplete $PercentComplete -CurrentOperation $CurrentOperation
        
          # Is the Cache too old? I.E. older than 15 minutes?
          If($CacheEntry.RetrievalTime -lt $CacheExpiry) {
          
            # Force a refresh by calling this function
            $null = Get-AtwsFieldInfo -Entity $CacheEntry.Key
          }
        
        }
      }
      
      # Return the current FieldInfoCache
      $Result = $script:FieldInfoCache
      
    }
    ElseIf (($Script:Atws) -and $script:FieldInfoCache[$Entity].RetrievalTime -lt $CacheExpiry) { 
      $Caption = $MyInvocation.MyCommand.Name
      $VerboseDescrition = '{0}: About to get built-in fields for {1}s' -F $Caption, $Entity
      $VerboseWarning = '{0}: About to get built-in fields for {1}s. Do you want to continue?' -F $Caption, $Entity

      If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
        $Result = $atws.GetFieldInfo($Entity)
      }
   
    
      If ($Result.Errors.Count -gt 0) {
        Foreach ($AtwsError in $Result.Errors) {
          Write-Error $AtwsError.Message
        }
        Return
      }
      
      # No errors
      # Test if value has changed
     
      # No errors
      Write-Verbose ('{0}: Save or update cache for entity {1}' -F $MyInvocation.MyCommand.Name, $Entity)
      $script:FieldInfoCache[$Entity].FieldInfo = $Result
      $script:FieldInfoCache[$Entity].RetrievalTime = Get-Date
           
    }
  
    Else {
      Write-Verbose ('{0}: Returning fieldinfo for entity {1} from cache' -F $MyInvocation.MyCommand.Name, $Entity)      
      $Result = $script:FieldInfoCache[$Entity].FieldInfo
    }
  }  
  End {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

    Return $Result
  }
    
    
}
