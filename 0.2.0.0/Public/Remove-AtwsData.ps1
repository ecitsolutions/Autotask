<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Remove-AtwsData 
{
  <#
      .SYNOPSIS
      This function updates one or more Autotask entities with new or modified properties.
      .DESCRIPTION
      This function updates one or more Autotask entities with new or modified properties
      .INPUTS
      Autotask.Entity[]. One or more Autotask entities to delete.
      .OUTPUTS
      Nothing.
      .EXAMPLE
      Remove-AtwsData -Entity $Entity
      Passes all Autotask entities in $Entity to the Autotask webservices API and deletes them.
      .NOTES
      NAME: Remove-AtwsData
      .LINK
      Get-AtwsData
      New-AtwsData
      Set-AtwsData
  #>
 
  [cmdletbinding(
      SupportsShouldProcess = $True,
      ConfirmImpact = 'High'
  )]
  param
  (
    [Parameter(Mandatory = $True,
    ValueFromPipeline = $True)]
    [ValidateNotNullOrEmpty()]
    [PSObject[]]
    $Entity
  )
    
  Begin
  { 
    If (-not($global:atws.Url))
    {
      Throw [ApplicationException] 'Not connected to Autotask WebAPI. Run Connect-AutotaskWebAPI first.'
    }
    Write-Verbose ('{0}: Start of Function' -F $MyInvocation.MyCommand.Name)
    
  }
  
  Process
  {   
    $Caption = 'Remove-Atws{0}' -F $Entity[0].GetType().Name
    $VerboseDescrition = '{0}: About to remove {1} {2}(s). This action cannot be undone.' -F $Caption, $Entity.Count, $Entity[0].GetType().Name
    $VerboseWarning = '{0}: About to remove {1} {2}(s). This action cannot be undone. Do you want to continue?' -F $Caption, $Entity.Count, $Entity[0].GetType().Name

    Write-Verbose ('{0}: Running ShouldProcess with WhatifPreference {1} and ConfirmPreference {2}' -F $MyInvocation.MyCommand.Name, $WhatIfPreference, $ConfirmPreference)
    If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption))
    { 
      Write-Verbose ('{0}: Deleting {1} [Autotask.{2}] object(s) with Id {3}' -F $MyInvocation.MyCommand.Name, $Entity.Count, $Entity[0].GetType().Name, ($Entity.Id -join ','))        
      
      $Result = $atws.delete($Entity)
      
      If ($Result.Errors.Count -gt 0)
      {
        Foreach ($AtwsError in $LastResult.Errors)
        {
          Write-Error -Message $AtwsError.Message
        }
      }    
    }
  }
  
  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)    
  }
}

