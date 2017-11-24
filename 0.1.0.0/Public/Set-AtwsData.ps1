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
      Autot
      .OUTPUTS
      Autotask.Entity[]. One or more Autotask entities to update.
      .EXAMPLE
      Set-AtwsData -Entity $Entity
      Passes all Autotask entities in $Entity to the Autotask webservices API
      .NOTES
      NAME: Set-AtwsData
      .LINK
      Get-AtwsData
  #>
 
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory = $True)]
        [Autotask.Entity[]]
        $Entity
    )
    
    
    
    If (-not($global:atws.Url))
    {
        
        Throw [ApplicationException] 'Not connected to Autotask WebAPI. Run Connect-AutotaskWebAPI first.'
    }
    

    $Result = $atws.update($Entity)
    
    
    If ($Result.Errors.Count -eq 0)
    {
      Return $Result
    }
    Else
    {
      Foreach ($AtwsError in $Result.Errors)
      {
        Write-Error $AtwsError
      }
    }

}

