<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

function ConvertTo-QueryXML 
{
  [cmdletbinding()]
  param(
    [switch]$UDF,
        
    [Parameter(Mandatory = $true,ValueFromRemainingArguments = $true)]
    [String[]]$QueryText,
        
    [Switch]
    $QueryStringOnly = $false

  )
    

  # List of allowed operator in QueryXML
  $Operator = @{
    '-and' = 'and'
    '-or'  = 'or'
    '-begin' = 'begin'
    '-end' = 'end'
  }

  # List of all allowed condition in QueryXML
  $ConditionOperator = @{
    '-eq'       = 'Equals'
    '-ne'       = 'NotEqual'
    '-gt'       = 'GreaterThan'
    '-lt'       = 'LessThan'
    '-ge'       = 'GreaterThanorEquals'
    '-le'       = 'LessThanOrEquals'
    '-beginswith' = 'BeginsWith'
    '-endswith' = 'EndsWith'
    '-contains' = 'Contains'
    '-isnotnull' = 'IsNotNull'
    '-isnull'   = 'IsNull'
    '-isthisday' = 'IsThisDay'
    '-like'     = 'Like'
    '-notlike'  = 'NotLike'
    '-soundslike' = 'SoundsLike'
  }

  $NoValueNeeded = @('-isnotnull', '-isnull', '-isthisday')
    
  # Create an XML document object. Only used to create XML elements.
  $xml = New-Object -TypeName XML
    
  # Create base element and add a single Entity definition to it.
  $queryxml = $xml.CreateElement('queryxml')
  $entityxml = $xml.CreateElement('entity')
  $null = $queryxml.AppendChild($entityxml)

  # Entity is the first element of the querytext
  $entityxml.InnerText = $QueryText[0]

  # Create an XML element for the query tag.
  # It will contain all condition.
  $Query = $xml.CreateElement('query')
  $null = $queryxml.AppendChild($Query)

  # Set generic pointer $Node to the query tag
  $Node = $Query

  # Create an index pointer that starts on the second element
  # of the querytext array
  For ($i = 1; $i -lt $QueryText.Count; $i++)
  {
    Switch ($QueryText[$i])
    {
      # Check for operator
      {$Operator.Keys -contains $_}
      {
        # Element is an operator. Add a condition tag with
        # attribute 'operator' set to the value of element
        $Condition = $xml.CreateElement('condition')
        If ($_ -eq '-begin')
        {
          # Add nested condition
          $null = $Node.AppendChild($Condition)
          $Node = $Condition
          $Condition = $xml.CreateElement('condition')
        }
        If ('-or', '-and' -contains $_)
        {$Condition.SetAttribute('operator', $Operator[$_])}
                   
        # Append condition to current $Node
        $null = $Node.AppendChild($Condition)

        # Set condition tag as current $Node. Next field tag
        # should be nested inside the condition tag.
        $Node = $Condition
        Break
      }
      # End a nested condition
      '-end'
      {
        $Node = $Node.ParentNode
        Break
      }
      # Check for a condition
      {$ConditionOperator.Keys -contains $_} 
      {
        # Element is a condition. Add an expression tag with
        # attribute 'op' set to the value of element
        $Expression = $xml.CreateElement('expression')
        $Expression.SetAttribute('op', $ConditionOperator[$_])

        # Append condition to current $Node
        $null = $Node.AppendChild($Expression)

        # Not all condition need a value. 
        If ($NoValueNeeded -notcontains $_)
        {
          # Increase pointer and add next element as 
          # Value to expression
          $i++
          $Expression.InnerText = $QueryText[$i]
        }

        # An expression closes a field tag. The next
        # element refers to the next level up.
        $Node = $Node.ParentNode

        # If the parentnode is a conditiontag we need
        # to go one more step up
        If ($Node.Name -eq 'condition')
        {$Node = $Node.ParentNode}
        Break
      }
      # Everything that aren't an operator or a condition is treated
      # as a field.
      default
      {
        # Create a field tag, fill it with element
        # and add it to current Node
        $Field = $xml.CreateElement('field')
        $Field.InnerText = $QueryText[$i]
        $null = $Node.AppendChild($Field)

        # If UDF is set we must add an attribute to the field
        # tag. But only once!
        If ($UDF)
        {
          $Field.SetAttribute('udf', 'true')
          # Only the first field can be UDF
          $UDF = $false
        }

        # The field tag is now the current Node
        $Node = $Field
      }
    }
  }
    

  Return $($queryxml.OuterXml)
}
