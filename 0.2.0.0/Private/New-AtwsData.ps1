<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function New-AtwsData 
{
  [cmdletbinding(
    SupportsShouldProcess = $True,
    ConfirmImpact = 'High'
  )]
  param
  (
    [Parameter(
        Mandatory = $True,
        Position = 0
    )]
    [Autotask.Entity]
    $Entity
  )
   
  Begin
  { 
    If (-not($global:atws.Url))
    {
        
      Throw [ApplicationException] 'Not connected to Autotask WebAPI. Run Connect-AutotaskWebAPI first.'
    }
  }
    
  Process
  { 
    Write-Verbose ('{0}: Creating a new object of type Autotask.{1}' -F $MyInvocation.MyCommand.Name, $Entity) 

    $Caption = 'New-Atws{0}' -F $Entity.GetType().Name    
    $VerboseDescrition = '{0}: About to create an Autotask.{1}. This action cannot be undone (but the object can usually be deleted).' -F $Caption, $Entity.GetType().Name
    $VerboseWarning = '{0}: About to create an Autotask.{1}. This action cannot be undone (but the object can usually be deleted). Do you want to continue?' -F $Caption, $Entity.GetType().Name

    If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption))
    { 
      $Result = $Atws.Create($Entity)
    }

    If ($Result.Errors.Count -eq 0)
    {
      Return $Result
    }
    Else
    {
      Foreach ($AtwsError in $Result.Errors)
      {
        Write-Error $AtwsError.Message
      }
    }
  }
  End 
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name) 
  }
}