<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Get-AtwsData 
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
        [Parameter(
          Mandatory = $True,
          Position = 0
        )]
        [String]
        $Entity,
          
        [Parameter(
          Mandatory = $True,
          ValueFromRemainingArguments = $true,
          Position = 1
        )]
        [String[]]
        $Filter
    )
    
    If ($Filter.Count -eq 1 -and $Filter -match ' ')
    {
      $Filter = $Filter.Split(' ')
    }
    [Array]$Query = @($Entity) + $Filter
    [xml]$QueryXml = New-AtwsQuery @Query
    
    If (-not($global:atws.Url))
    {
        
        Throw [ApplicationException] 'Not connected to Autotask WebAPI. Run Connect-AutotaskWebAPI first.'
    }
    
    $result = @()
    
    # Native XML is rather tedious...
    $field = $QueryXml.CreateElement('field')
    $expression = $QueryXml.CreateElement('expression')
    $expression.SetAttribute('op','greaterthan')
    $expression.InnerText = 0
    $field.InnerText = 'id'
    [void]$field.AppendChild($expression)
    
    # Insert looping construct into query
    [void]$QueryXml.queryxml.query.AppendChild($field)
    
    Do 
    {
    
        $lastquery = $atws.query($QueryXml.InnerXml)

        If ($lastquery.Errors.Count -gt 0)
        {
            Foreach ($AtwsError in $lastquery.Errors)
            {
                Write-Error $AtwsError.Message
            }
            Return
        }
        $result += $lastquery.EntityResults
        $UpperBound = $lastquery.EntityResults[$lastquery.EntityResults.GetUpperBound(0)].id
        $expression.InnerText = $UpperBound
    }
    Until ($lastquery.EntityResults.Count -lt 500)
    
    $result

}