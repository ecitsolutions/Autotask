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
    $Entity,
    [Parameter(
        ParameterSetName = 'get_All'
    )]
    [Parameter(
        ParameterSetName = 'by_Entity'
    )]
    [String]
    $Connection = 'Atws'
  )
    
  Begin { 
    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
    # This will be replaced when this function is imported in the dynamic module
    $Prefix = '#Prefix'

    # This looks stupid in the static text file, but if the line above has been changed dynamically,
    # then this makes a lot of sense.
    If ($Prefix -ne '#Prefix') {
      $Connection = $Prefix
    }
    
    If (-not($global:AtwsConnection[$Connection].Url)) {
      Throw [ApplicationException] 'Not connected to Autotask WebAPI. Run Connect-AutotaskWebAPI first.'
    }
    Else {
      $Atws = $global:AtwsConnection[$Connection]
    }
    
    # Has cache been loaded?
    If (-not($script:FieldInfoCache)) {

      # Do we even have a cache?
      $CacheInfo = Get-AtwsCacheInfo -Prefix $Prefix

      # The file and path will have been created by Get-AtwsCacheInfo, so now 
      # we can read it.
      $Script:Cache = Import-Clixml -Path $CacheInfo.CachePath

      # If either the module version or API version has changed the cache is dirty
      # and must be recreated. And if this is the first time we read the cache
      # for this connection prefix it is empty
      If ($CacheInfo.CacheDirty -or -not ($Cache.FieldInfoCache)) {
        
        
        $script:FieldInfoCache = @{}
        $Entities = $Atws.getEntityInfo()
        Foreach ($Entity in $Entities) {
          FieldInfoCache[$Entity.Name] = New-Object -TypeName PSObject -Property @{
            EntityInfo    = $Entity
            RetrievalTime = Get-Date
          }
        }
      }
    }
    
    $CacheExpiry = (Get-Date).AddMinutes(-15)
  }
  
  Process { 
    
    If (-not $script:FieldInfoCache.ContainsKey($Entity) -or $script:FieldInfoCache[$Entity].RetrievalTime -lt $CacheExpiry) { 
      $Caption = 'Set-Atws{0}' -F $Entity
      $VerboseDescrition = '{0}: About to get built-in fields and userdefined fields for {1}s' -F $Caption, $Entity
      $VerboseWarning = '{0}: About to get built-in fields and userdefined fields for {1}s. Do you want to continue?' -F $Caption, $Entity

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
      Write-Verbose ('{0}: Save or update cache for entity {1}' -F $MyInvocation.MyCommand.Name, $Entity)
      $script:FieldInfoCache[$Entity] = New-Object -TypeName PSObject -Property @{
        RetrievalTime = Get-Date
        FieldInfo     = $Result  
      }
      
      # No errors
      Write-Verbose ('{0}: Save or update cache for entity {1}' -F $MyInvocation.MyCommand.Name, $Entity)
      $script:FieldInfoCache[$Entity] = New-Object -TypeName PSObject -Property @{
        RetrievalTime = Get-Date
        FieldInfo     = $Result  
      }
            
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
