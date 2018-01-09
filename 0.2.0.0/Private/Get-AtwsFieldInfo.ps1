<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Get-AtwsFieldInfo
{
  <#
      .SYNOPSIS
      This function connects to the Autotask Web Services API.
      .DESCRIPTION
      The function takes a credential object and uses it to authenticate and connect to the Autotask
      Web Services API
      .INPUTS
      A PSCredential object. Required. It will prompt for credentials if the object is not provided.
      .OUTPUTS
      A webserviceproxy object is created.
      .EXAMPLE
      Connect-AutotaskWebAPI
      Prompts for a username and password and authenticates to Autotask
      .EXAMPLE
      Connect-AutotaskWebAPI
      .NOTES
      NAME: Connect-AutotaskWebAPI
      .LINK
      Get-AtwsData
      New-AtwsQuery
  #>
	
  [cmdletbinding()]
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
    $VerboseDescrition = '{0}: About to modify {1} {2}(s). This action cannot be undone.' -F $Caption, $Entity.Count, $Entity[0].GetType().name
    $VerboseWarning = '{0}: About to modify {1} {2}(s). This action cannot be undone. Do you want to continue?' -F $Caption, $Entity.Count, $Entity[0].GetType().Name

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

  }
  
  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

    Return $Result
  }
    
    
}
