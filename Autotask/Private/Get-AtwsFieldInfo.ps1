<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>

Function Get-AtwsFieldInfo
{
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
        Mandatory = $True,
        Position = 0
    )]
    [String]
    $Entity,

    [String]
    $Connection = 'Atws'
  )
    
  Begin
  { 
    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
        
    If (-not($global:AtwsConnection[$Connection].Url))
    {
      Throw [ApplicationException] 'Not connected to Autotask WebAPI. Run Connect-AutotaskWebAPI first.'
    }
    Else
    {
      $Atws = $global:AtwsConnection[$Connection]
    }
    
    If (-not($script:FieldInfoCache))
    {
      $script:FieldInfoCache = @{}
    }
    
    $CacheExpiry = (Get-Date).AddMinutes(-15)
  }
  
  Process
  { 
    
    If (-not $script:FieldInfoCache.ContainsKey($Entity) -or $script:FieldInfoCache[$Entity].RetrievalTime -lt $CacheExpiry) { 
      $Caption = 'Set-Atws{0}' -F $Entity
      $VerboseDescrition = '{0}: About to get built-in fields and userdefined fields for {1}s' -F $Caption, $Entity
      $VerboseWarning = '{0}: About to get built-in fields and userdefined fields for {1}s. Do you want to continue?' -F $Caption, $Entity

      If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption))
      { 
        $Result = $atws.GetFieldInfo($Entity)
      }
   
    
      If ($Result.Errors.Count -gt 0)
      {
        Foreach ($AtwsError in $Result.Errors)
        {
          Write-Error $AtwsError.Message
        }
        Return
      }
      
      # No errors
      Write-Verbose ('{0}: Save or update cache for entity {1}' -F $MyInvocation.MyCommand.Name, $Entity)
      $script:FieldInfoCache[$Entity] = New-Object -TypeName PSObject -Property @{
        RetrievalTime = Get-Date
        FieldInfo = $Result  
      }
            
    }
  
    Else
    {
      Write-Verbose ('{0}: Returning fieldinfo for entity {1} from cache' -F $MyInvocation.MyCommand.Name, $Entity)      
      $Result = $script:FieldInfoCache[$Entity].FieldInfo
    }
  }  
  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

    Return $Result
  }
    
    
}
