<#

    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

#>

Function Update-AtwsFilter {
    <#
      .SYNOPSIS
      This function parses an Atws filterstring or -array and makes sure it conforms to the format needed by 
      core functions.
      .DESCRIPTION
      All Get- are used to make it possible to generate a correctly formatted QueryXML that does what the user
      expects. To make this easier we use an approximation of the default operators in PowerShell, so that it is
      as easy as possible for new users that are experienced in PowerShell, but not in QueryXML to use the module.
      To make variable expansion possible the function should be dot-sourced from the entity wrapper functions. 
      .INPUTS
      [string[]]
      .OUTPUTS
      [string[]]
      .EXAMPLE
      Update-AtwsFilter -Filterstring <string[]>
      Parses an Atws filterstring or -array and makes sure it conforms to the format needed by core functions. 
      .NOTES
      NAME: Update-AtwsFilter
      
  #>
    [cmdletbinding()]
    Param
    (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [string[]]
        $Filterstring
    )

    begin {
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
        Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    }

    process {
        # $Filter is usually passed as a flat string. Convert it to an array.
        if ($Filterstring.Count -eq 1 -and $Filterstring -match ' ' ) { 
            # First, make sure it is a single string and replace parenthesis with our special operator
            $Filterstring = $Filterstring -join ' ' -replace '\(', ' -begin ' -replace '\)', ' -end '
    
            # Removing double possible spaces we may have introduced
            Do { $Filterstring = $Filterstring -replace '  ', ' ' }
            While ($Filterstring -match '  ')

            # Split back in to array, respecting quotes
            $Words = $Filterstring.Trim().Split(' ')
            [string[]]$Filterstring = @()
            $Temp = @()
            foreach ($Word in $Words) {
                if ($Word -match '^[\"\'']' -and $Word -match "[\'\""]$") {
                    $Filterstring += $Word.Trim('"''')
                }
                elseif ($Temp.Count -eq 0 -and $Word -match '^[\"\'']') {
                    $Temp += $Word.TrimStart('"''')
                }
                elseif ($Temp.Count -gt 0 -and $Word -match "[\'\""]$") {
                    $Temp += $Word.TrimEnd("'""")
                    $Filterstring += $Temp -join ' '
                    $Temp = @()
                }
                elseif ($Temp.Count -gt 0) {
                    $Temp += $Word
                }
                else {
                    $Filterstring += $Word
                }
            }
        }
      
        Write-Debug ('{0}: Checking query for variables that have survived as string' -F $MyInvocation.MyCommand.Name)
      
        $NewFilter = [Collections.ArrayList]::new()
        foreach ($Word in $Filterstring) {
            $value = $Word
            # Is it a variable name?
            if ($Word -match '^\$\{?(\w+:)?(\w+)\}?(\.\w[\.\w]+)?$') {
                # If present, first group is SCOPE. In the context of this function, the only possible scope
                # is Global; Script = the module, local is internal to this function.
                $Scope = 'Global' # or numbered scope 2
        
                # The variable name MUST be present
                $VariableName = $Matches[2]

                # A property tail CAN be present
                $PropertyTail = $Matches[3]
        
                # Check that the variable exists
                $Variable = try
                { Get-Variable -Name $VariableName -Scope $Scope -ValueOnly -ErrorAction Stop }
                catch {
                    Write-Error ('{0}: Could not find any variable called ${1}. Is it misspelled or has it not been set yet?' -f $MyInvocation.MyCommand.Name, $VariableName)
                    # Force stop of calling script, because this will completely break the query
                    Return
                }

                # Test if the variable "Variable" has been set
                if (Test-Path Variable:Variable) {
                    Write-Debug ('{0}: Substituting {1} for its value' -F $MyInvocation.MyCommand.Name, $Word)
                    if ($PropertyTail) {
                        # Add properties back 
                        $Expression = '$Variable{0}' -F $PropertyTail
  
                        # Invoke-Expression is considered risky from an SQL injection kind of perspective. But by only
                        # permitting a .dot separated string of [a-zA-Z0-9_] we are PROBABLY safe...
                        $value = Invoke-Expression -Command $Expression
                    }
                    else {
                        # $value must be removed or it will retain the type of the first value
                        Remove-Variable -Name value -Force
                        $value = $Variable
                    }
                    if ($null -eq $value) {
                        Write-Error ('{0}: Could not find any variable called {1}. Is it misspelled or has it not been set yet?' -F $MyInvocation.MyCommand.Name, $Expression)
                        # Force stop of calling script, because this will completely break the query
                        Return
                    }
                    else { 
                        # Normalize dates. Important to avoid QueryXML problems
                        if ($value.GetType().Name -eq 'DateTime') {
                            [string]$value = ConvertTo-AtwsDate -DateTime $value
                        }
                    }
                }
            }
            [void]$NewFilter.add($value)
        }
 
    }

    end {
        Return $NewFilter
    }
}