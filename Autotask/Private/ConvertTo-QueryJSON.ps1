<#

    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

function ConvertTo-QueryJSON {
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
    
    begin { 
        # List of allowed operators in queries
        $operators = @{
            '-and' = 'and'
            '-or'  = 'or'
        }

        # List of all allowed condition in QueryXML
        $filterOperators = @{
            '-eq'         = 'eq'
            '-ne'         = 'noteq'
            '-gt'         = 'gt'
            '-lt'         = 'lt'
            '-ge'         = 'gte'
            '-le'         = 'lte'
            '-beginswith' = 'beginsWith'
            '-endswith'   = 'endsWith'
            '-contains'   = 'contains'
            '-isnotnull'  = 'exist'
            '-isnull'     = 'notExist'
            '-in'         = 'in'
            '-notin'      = 'notIn'
        }

        $NoValueNeeded = @('-isnotnull', '-isnull')
  
        $udf = $false
    }

    process { 
        # $text = 'IsActive -eq true -and -begin lastname -eq smith -or lastname -eq jones -or -begin firstname -eq chris -and lastname -eq brady -end -end'
        # $Filter = @('id', '-ge', 0)
        # IsActive -eq true -and ( lastname -eq smith -or lastname -eq jones -or ( firstname -eq chris -and lastname -eq brady ) )
        # Operator

        # Check for query passed as single string



        # An array to hold filter expressions until they can be added to a filter or group
        $index = 0
        $stack = @{
            $index = [pscustomobject]@{
                'op' = 'and'
                'items' = @()
            }
        }
    

        # Create an index pointer that starts on the second element
        # of the querytext array, the first is entity

        for ($i = 0; $i -lt $QueryText.Count; $i++) {
            switch ($QueryText[$i]) {
                # Check for operator
                { $operators.Keys -contains $_ } {
                    # Element is an operator. 
                    $operator = $operators[$_]

                    # FIX: evaluate operator against logic
                    $stack[$index].op = $operator
                    Break
                }
                # Start a nested condition
                '-begin' {
                    # Create a sub-element 
                    $index++
                    $stack[$index] = [pscustomobject]@{
                        'op'    = 'and'
                        'items' = @()
                    }
                    Break
                }
                # End a nested condition
                '-end' {
        
                    if ($index -gt 0) { 
                        $index-- 
                        $stack[$index].items += $stack[$index + 1]
                    }
                    Break
                }
                # Next value is an UDF name
                '-udf' {
                    $udf = $true
                    Break
                }
                # Check for a condition
                { $filterOperators.Keys -contains $_ } {
                    # Element is a condition. Create a filter expression
                    $filterExpression = [pscustomobject]@{
                        "op"    = $filterOperators[$_]
                        "field" = $field
                        "udf"   = $udf
                        "value" = ""
                    }

                    # Not all conditions need a value. 
                    if ($NoValueNeeded -notcontains $_) {
                        # Increase pointer and add next element as 
                        # Value to expression
                        $i++
                        $filterExpression.value = $QueryText[$i]
                    }

                    # Add to current item list
                    $stack[$index].items += $filterExpression

                    Break
                }
                # Everything that aren't an operator or a condition is treated
                # as a field.
                default {
                    $field = $QueryText[$i]
                }
            }
        }
    }
    end { 
        if ($stack[0].items.count -gt 1) {
            $filter = [pscustomobject]@{
                'filter' = @($stack[0])
            }
        }
        else {
            $filter = [pscustomobject]@{
                'filter' = $stack[0].items
            }
        }

        Return $(ConvertTo-Json -Depth 99 $filter )
    }
}
