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
    
    If (-not($Script:Atws.Url)) {
      Throw [ApplicationException] 'Not connected to Autotask WebAPI. Run Connect-AutotaskWebAPI first.'
    }
        
    # Has cache been loaded?
    If (-not($script:FieldInfoCache)) {

      # Do we even have a cache?
      $CacheInfo = Get-AtwsCacheInfo

      # The file and path will have been created by Get-AtwsCacheInfo, so now 
      # we can read it.
      $Script:Cache = Import-Clixml -Path $CacheInfo.CachePath

      # If either the module version or API version has changed the cache is dirty
      # and must be recreated. And if this is the first time we read the cache
      # for this connection prefix it is empty
      If ($CacheInfo.CacheDirty -or -not ($Cache.FieldInfoCache)) {
        
        $Activity = 'Initializing diskcache'
        
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
        Add-Member -InputObject $Script:Cache -MemberType NoteProperty -Name FieldInfoCache -Value $FieldInfoCache -Force
        
        $Caption = $MyInvocation.MyCommand.Name
        $VerboseDescrition = '{0}: Saving updated cache info to {1}' -F $Caption, $CacheInfo.CachePath
        $VerboseWarning = '{0}: About to save updated cache info to {1}. Do you want to continue?' -F $Caption, $CacheInfo.CachePath
          
        If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
          $Script:Cache.ModuleVersion = 
          $Script:Cache | Export-Clixml -Path $CacheInfo.CachePath -Force
          $CacheInfo.CacheDirty = $False
        }
        
      } 
      # We just loaded the cache from disk
      Else {
        
        Write-Verbose -Message ('{0}: Loading detailed Fieldinfo from diskcache {1}' -F $MyInvocation.MyCommand.Name, $CacheInfo.CachePath) 
              
        $Script:FieldInfoCache = $Script:Cache.FieldInfoCache
      }
    }
    
    $CacheExpiry = (Get-Date).AddMinutes(-15)
  }
  
  Process { 
    
    If ($All.IsPresent) {
    
      # At this point we have a cache, but we do not know if it is fresh. We only need to check
      # entities with picklists
      Foreach ($CacheEntry in $script:FieldInfoCache.GetEnumerator().Where{$_.Value.HasPicklist}) {
        
        # Is the Cache too old? I.E. older than 15 minutes?
        If($CacheEntry.RetrievalTime -lt $CacheExpiry) {
          
          # Force a refresh by calling this function
          $null = Get-AtwsFieldInfo -Entity $CacheEntry.Key
        }
        
      }
      
      # When the loop is done the cache should be fresh
      $Result = $script:FieldInfoCache
      
    }
    ElseIf (-not $script:FieldInfoCache.ContainsKey($Entity) -or $script:FieldInfoCache[$Entity].RetrievalTime -lt $CacheExpiry) { 
      $Caption = 'Set-Atws{0}' -F $Entity
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
