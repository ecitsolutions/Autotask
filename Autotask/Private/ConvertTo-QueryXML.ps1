<#

    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

function ConvertTo-QueryXML {
     <#
      .SYNOPSIS

      .DESCRIPTION

      .INPUTS

      .OUTPUTS

      .EXAMPLE

      .NOTES
      NAME: 
      .LINK

  #>
    [cmdletbinding()]
    param(    
        [Parameter(
            Mandatory = $true,
            ValueFromRemainingArguments = $true
        )]
        [string[]]
        $QueryText,
        
        [switch]
        $QuerystringOnly = $false

    )
    

    # List of allowed operator in QueryXML
    $Operator = @{
        '-and'   = 'and'
        '-or'    = 'or'
        '-begin' = 'begin'
        '-end'   = 'end'
    }

    # List of all allowed condition in QueryXML
    $ConditionOperator = @{
        '-eq'         = 'Equals'
        '-ne'         = 'NotEqual'
        '-gt'         = 'GreaterThan'
        '-lt'         = 'LessThan'
        '-ge'         = 'GreaterThanorEquals'
        '-le'         = 'LessThanOrEquals'
        '-beginswith' = 'BeginsWith'
        '-endswith'   = 'EndsWith'
        '-contains'   = 'Contains'
        '-isnotnull'  = 'IsNotNull'
        '-isnull'     = 'IsNull'
        '-isthisday'  = 'IsThisDay'
        '-like'       = 'Like'
        '-notlike'    = 'NotLike'
        '-soundslike' = 'SoundsLike'
    }

    $NoValueNeeded = @('-isnotnull', '-isnull')
  
    $UDF = $false

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
    for ($i = 1; $i -lt $QueryText.Count; $i++) {
        switch ($QueryText[$i]) {
            # Check for operator
            { $Operator.Keys -contains $_ } {
                # Element is an operator. Add a condition tag with
                # attribute 'operator' set to the value of element
                $Condition = $xml.CreateElement('condition')
                if ($_ -eq '-begin') {
                    # Add nested condition
                    $null = $Node.AppendChild($Condition)
                    $Node = $Condition
                    $Condition = $xml.CreateElement('condition')
                }
                if ('-or', '-and' -contains $_)
                { $Condition.SetAttribute('operator', $Operator[$_]) }
                   
                # Append condition to current $Node
                $null = $Node.AppendChild($Condition)

                # Set condition tag as current $Node. Next field tag
                # should be nested inside the condition tag.
                $Node = $Condition
                Break
            }
            # End a nested condition
            '-end' {
                $Node = $Node.ParentNode
                Break
            }
            # Next value is an UDF name
            '-udf' {
                $UDF = $true
                Break
            }
            # Check for a condition
            { $ConditionOperator.Keys -contains $_ } {
                # Element is a condition. Add an expression tag with
                # attribute 'op' set to the value of element
                $Expression = $xml.CreateElement('expression')
                $Expression.SetAttribute('op', $ConditionOperator[$_])

                # Append condition to current $Node
                $null = $Node.AppendChild($Expression)

                # Not all condition need a value. 
                if ($NoValueNeeded -notcontains $_) {
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
                if ($Node.Name -eq 'condition')
                { $Node = $Node.ParentNode }
                Break
            }
            # Everything that aren't an operator or a condition is treated
            # as a field.
            default {
                # Create a field tag, fill it with element
                # and add it to current Node
                $field = $xml.CreateElement('field')
                $field.InnerText = $QueryText[$i]

                if ($UDF) {
                    $field.SetAttribute('udf', 'true')
                    $UDF = $false
                }
                $null = $Node.AppendChild($field)

                # The field tag is now the current Node
                $Node = $field
            }
        }
    }
    

    Return $($queryxml.OuterXml)
}
