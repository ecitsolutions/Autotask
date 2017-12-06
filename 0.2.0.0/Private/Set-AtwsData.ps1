<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Set-AtwsData 
{
  <#
      .SYNOPSIS
      This function updates one or more Autotask entities with new or modified properties.
      .DESCRIPTION
      This function updates one or more Autotask entities with new or modified properties
      .INPUTS
      Autotask.Entity[]. One or more Autotask entities to update
      .OUTPUTS
      Autotask.Entity[]. The updated entities are re-downloaded from the API.
      .EXAMPLE
      Set-AtwsData -Entity $Entity
      Passes all Autotask entities in $Entity to the Autotask webservices API
      .NOTES
      NAME: Set-AtwsData
      .LINK
      Get-AtwsData
      New-AtwsData
      Remove-AtwsData
  #>
 
  [cmdletbinding(
    SupportsShouldProcess = $True,
    ConfirmImpact = 'Medium'
  )]
  param
  (
    [Parameter(
        Mandatory = $True,
        ValueFromPipeline = $True
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.Entity[]]
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
    Write-Verbose ('{0}: Updating Autotask {1} with id {2}' -F $MyInvocation.MyCommand.Name, $Entity[0].GetType().Name, $($Entity.id -join ', '))


    $Caption = 'Set-Atws{0}' -F $Entity[0].GetType().Name
    $VerboseDescrition = '{0}: About to modify {1} {2}(s). This action cannot be undone.' -F $Caption, $Entity.Count, $Entity[0].GetType().name
    $VerboseWarning = '{0}: About to modify {1} {2}(s). This action cannot be undone. Do you want to continue?' -F $Caption, $Entity.Count, $Entity[0].GetType().Name

    If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption))
    { 
      $Result = $atws.update($Entity)
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

