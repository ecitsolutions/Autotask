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
    
  }
  
  Process
  { 
    $Caption = 'Set-Atws{0}' -F $Entity[0].GetType().Name
    $VerboseDescrition = '{0}: About to get built-in fields and userdefined fields for {1}s' -F $Caption, $Entity[0].GetType().name
    $VerboseWarning = '{0}: About to get built-in fields and userdefined fields for {1}s. Do you want to continue?' -F $Caption, $Entity[0].GetType().Name

    If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption))
    { 
      $Result = $atws.GetFieldInfo($Entity)
      <#
      If ($Result.Count -gt 0)
      { 
        $UDFResult = $atws.GetUDFInfo($Entity)
        If ($UDFResult.Count -gt 0)
        {
          Foreach ($UDF in $UDFResult)
          {
            $UDF.Name = 'UDF_{0}' -F ([URI]::EscapeDataString($UDF.Name) -replace '%','_')
          }
          $Result += $UDFResult
        }
      }#>
    }
    
    If ($Result.Errors.Count -gt 0)
    {
      Foreach ($AtwsError in $Result.Errors)
      {
        Write-Error $AtwsError.Message
      }
      Return
    }

  }
  
  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

    Return $Result
  }
    
    
}
