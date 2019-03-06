<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>

Function Get-FieldInfo {
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
      Get-FieldInfo -Entity Account
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
    $Entity,
    
    [Int]
    $ProgressParentId
  )
    
  Begin { 
  
    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
    # Check if we are connected before trying anything
    If (-not($Script:Atws)) {
      Throw [ApplicationException] 'Not connected to Autotask WebAPI. Re-import module with valid credentials.'
    }
    
    # Has cache been loaded?
    If (-not($script:Cache)) {
      # Load it.
      Import-AtwsDiskCache
    }
    
    # If the current connection is for a new Autotask tenant, copy the blank 
    # cache from the included pre-cache
    If (-not ($Script:Cache.ContainsKey($Script:Atws.CI))) {
      # Create a cache object to store API version along with the cache
      $Script:Cache[$Script:Atws.CI] = New-Object -TypeName PSObject -Property @{
        ApiVersion = $Script:Cache['00'].ApiVersion
      }
      # Use Add-Member on the Hashtable, or the propertyvalue will be set to typename only
      # Clone the hashtable. We do NOT want a referenced copy!
      Add-Member -InputObject $Script:Cache[$Script:Atws.CI] -MemberType NoteProperty -Name FieldInfoCache -Value $Script:Cache['00'].FieldInfoCache.Clone()

    }
      
    # Initialize the short-hand variable reference for the fieldInfocache
    $Script:FieldInfoCache = $Script:Cache[$Script:Atws.CI].FieldInfoCache

    Write-Verbose -Message ('{0}: Loaded detailed Fieldinfo from diskcache' -F $MyInvocation.MyCommand.Name) 

    $CacheExpiry = (Get-Date).AddMinutes(-15)
  }
  
  Process { 
        
    If ($All.IsPresent) {
    
      # If the API version has been changed at the Autotask end we unfortunately have to load all
      # entities from scratch
      $CurrentApiVersion = $Script:Atws.GetWsdlVersion()
      If (-not ($Script:Cache[$Script:Atws.CI].ApiVersion -eq $CurrentApiVersion)) {
        
        # Prepare parameters for @splatting
        $ProgressParameters = @{
          Activity = ('New API version {0} has been published, old version is {1}. recreating diskcache.' -F $CurrentApiVersion, $Script:Cache[$Script:Atws.CI].ApiVersion)
          Id = 9
        }

        # Add parentid if supplied
        If ($ProgressParentId) {
          $ProgressParameters['ParentId'] = $ProgressParentId
        }
                 
        $script:FieldInfoCache = @{}
        $Entities = $Script:Atws.getEntityInfo()
        
        Foreach ($Object in $Entities) { 
    
          Write-Verbose -Message ('{0}: Importing detailed information about Entity {1}' -F $MyInvocation.MyCommand.Name, $Object.Name) 

          # Calculating progress percentage and displaying it
          $Index = $Entities.IndexOf($Object) + 1
          $PercentComplete = $Index / $Entities.Count * 100
          $Status = 'Entity {0}/{1} ({2:n0}%)' -F $Index, $Entities.Count, $PercentComplete
          $CurrentOperation = "GetFieldInfo('{0}')" -F $Object.Name
      
          Write-Progress -Status $Status -PercentComplete $PercentComplete -CurrentOperation $CurrentOperation @ProgressParameters
          
          $Caption = $MyInvocation.MyCommand.Name
          $VerboseDescrition = '{0}: Retreiving detailed field information about entity {1}' -F $Caption, $Object.Name
          $VerboseWarning = '{0}: About to post a SOAP query to Autotask Web API for detailed field info for entity {1}. Do you want to continue?' -F $Caption, $Object.Name
          
          If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
            # Retrieving FieldInfo for current Entity
            $FieldInfo = $Script:Atws.GetFieldInfo($Object.Name)
            
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
        
        # Mark chache as dirty == dump to disk
        $CacheDirty = $True
        
      }
      # At this point we have a cache, but we do not know if it is fresh. We only need to check
      # entities with picklists
      Else { 

        # Prepare parameters for @splatting
        $ProgressParameters = @{
          Activity = 'All entities has been requested. Updating picklists.'
          Id = 9
        }

        # Add parentid if supplied
        If ($ProgressParentId) {
          $ProgressParameters['ParentId'] = $ProgressParentId
        }
      
        $Entities = $script:FieldInfoCache.GetEnumerator().Where{$_.Value.HasPicklist}
      
        Foreach ($Object in $Entities) {
      
          Write-Verbose -Message ('{0}: Importing detailed information about Entity {1}' -F $MyInvocation.MyCommand.Name, $Object.Key) 

          # Calculating progress percentage and displaying it
          $Index = $Entities.IndexOf($Object) + 1
          $PercentComplete = $Index / $Entities.Count * 100
          $Status = 'Entity {0}/{1} ({2:n0}%)' -F $Index, $Entities.Count, $PercentComplete
          $CurrentOperation = "GetFieldInfo('{0}')" -F $Object.Key
      
          Write-Progress -Status $Status -PercentComplete $PercentComplete -CurrentOperation $CurrentOperation @ProgressParameters
        
          # Is the Cache too old? I.E. older than 15 minutes?
          If($Object.RetrievalTime -lt $CacheExpiry) {
          
            # Force a refresh by calling this function
            $null = Get-FieldInfo -Entity $Object.Key
            
          }
        }
      }
      # Return the current FieldInfoCache
      $Result = $script:FieldInfoCache
      
    }
    ElseIf ($script:FieldInfoCache[$Entity].HasPicklist -and $script:FieldInfoCache[$Entity].RetrievalTime -lt $CacheExpiry) { 
      $Caption = $MyInvocation.MyCommand.Name
      $VerboseDescrition = '{0}: About to get built-in fields for {1}s' -F $Caption, $Entity
      $VerboseWarning = '{0}: About to get built-in fields for {1}s. Do you want to continue?' -F $Caption, $Entity

      If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
        $Result = $Script:atws.GetFieldInfo($Entity)
      }
   
    
      If ($Result.Errors.Count -gt 0) {
        Foreach ($AtwsError in $Result.Errors) {
          Write-Error $AtwsError.Message
        }
        Return
      }
      
      # No errors
      # Test if value has changed
      If (Compare-PSObject -ReferenceObject $script:FieldInfoCache[$Entity].FieldInfo -DifferenceObject $Result) { 
     
        # No errors
        Write-Verbose ('{0}: Save or update cache for entity {1}' -F $MyInvocation.MyCommand.Name, $Entity)
        $script:FieldInfoCache[$Entity].FieldInfo = $Result
        $script:FieldInfoCache[$Entity].RetrievalTime = Get-Date
      
        # Mark chache as dirty == dump to disk
        $CacheDirty = $True
      }
           
    }
    # Not -All and Entity either does not have any picklists or picklist has been requested within the last 15 minutes
    Else {
      Write-Verbose ('{0}: Returning fieldinfo for entity {1} from cache' -F $MyInvocation.MyCommand.Name, $Entity)      
      $Result = $script:FieldInfoCache[$Entity].FieldInfo
    }
  }  
  End {
    If ($CacheDirty) { 
      Export-AtwsDiskCache
    }
    
       
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
            
    Return $Result
  }
    
    
}
