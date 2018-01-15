<#
    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Show-AtwsEntity
{
  <#
      .SYNOPSIS
      This function queries the Autotask Web API for entities matching a specified type and filter.
      .DESCRIPTION
      This function queries the Autotask Web API for entities matching a specified type and filter.
      Valid operators: 
      -and, -or

      Valid comparison operators:
      -eq, -ne, -lt, -le, -gt, -ge, -isnull, -isnotnull, -isthisday

      Valid text comparison operators:
      -contains, -like, -notlike, -beginswith, -endswith, -soundslike
         
      Special operators to nest conditions: 
      -begin, -end

      .INPUTS
      Nothing.
      .OUTPUTS
      Autotask.Entity[]. One or more Autotask entities returned from Autotask Web API.
      .EXAMPLE
      Get-AtwsData -Entity Ticket -Filter {id -gt 0}
      Gets all tickets with an id greater than 0 from Autotask Web API
      .NOTES
      NAME: Get-AtwsData
      .LINK
      Set-AtwsData
      New-AtwsData
      Remove-AtwsData
  #>
  
  [cmdletbinding(
      SupportsShouldProcess = $True,
      ConfirmImpact = 'Low'
  )]
  param
  (
    [Parameter(
        Mandatory = $True,
        ValueFromPipeLine = $True,
        Position = 0
    )]
    [ValidateNotNullOrEmpty()]
    [PSObject]
    $Entity,
    
    [String]
    $Connection = 'Atws'
  )
  Begin
  { 
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
  
    Write-Verbose ('{0}: Checking entity type' -F $MyInvocation.MyCommand.Name)
    $EntityType = $Entity.GetType()
    If ($EntityType.FullName -notmatch '^Autotask')
    {
      Throw [System.ApplicationException] "Object is not an Autotask object. No information can be retrieved."
      Return
    }
    $AutotaskEntity = $Atws.GetEntityInfo() | Where-Object {$_.Name -eq $EntityType.Name}
    $Fields = Get-AtwsFieldInfo -Entity $EntityType.Name
  
    Write-Verbose ('{0}: Mashing parameters into an array of strings.' -F $MyInvocation.MyCommand.Name)
    
    [Array]$Query = @($Entity) + $Filter
  
    Write-Verbose ('{0}: Converting query string into QueryXml. String as array looks like: {1}' -F $MyInvocation.MyCommand.Name, $($Query -join ', '))
    [xml]$QueryXml = New-AtwsQuery @Query
    
    $Caption = 'Get-Atws{0}' -F $Entity
    $VerboseDescrition = '{0}: About to run a query for Autotask.{1} using Filter {{{2}}}' -F $Caption, $Entity, ($Filter -join ' ')
    $VerboseWarning = '{0}: About to run a query for Autotask.{1} using Filter {{{2}}}. Do you want to continue?' -F $Caption, $Entity, ($Filter -join ' ')
  

    If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption))
    { 
      $result = @()
    
      Write-Verbose ('{0}: Adding looping construct to query to handle more than 500 results.' -F $MyInvocation.MyCommand.Name)
    
      # Native XML is rather tedious...
      $field = $QueryXml.CreateElement('field')
      $expression = $QueryXml.CreateElement('expression')
      $expression.SetAttribute('op','greaterthan')
      $expression.InnerText = 0
      $field.InnerText = 'id'
      [void]$field.AppendChild($expression)
    
      $FirstPass = $True
    
      
      Do 
      {
        Write-Verbose ('{0}: Passing QueryXML to Autotask API' -F $MyInvocation.MyCommand.Name)
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
        If ($FirstPass)
        {
          # Insert looping construct into query
          [void]$QueryXml.queryxml.query.AppendChild($field)
          $FirstPass = $False        
        }
      }
      Until ($lastquery.EntityResults.Count -lt 500)
      
      
    }
  }
  
  End
  { 
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    Return $result
  }
  
}