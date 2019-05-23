<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md  for license information.

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
      [String[]]
      .OUTPUTS
      [String[]]
      .EXAMPLE
      Update-AtwsFilter -FilterString <String[]>
      Parses an Atws filterstring or -array and makes sure it conforms to the format needed by core functions. 
      .NOTES
      NAME: Update-AtwsFilter
      
  #>
  [cmdletbinding()]
  Param
  (
    [Parameter(
      Mandatory = $True,
      ValueFromPipeline = $True
    )]
    [String[]]
    $FilterString
  )

  Begin {
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
  }

  Process {
      # $Filter is usually passed as a flat string. Convert it to an array.
      If ($FilterString.Count -eq 1 -and $FilterString -match ' ' )
      { 
        # First, make sure it is a single string and replace parenthesis with our special operator
        $FilterString = $FilterString -join ' ' -replace '\(',' -begin ' -replace '\)', ' -end '
    
        # Removing double possible spaces we may have introduced
        Do {$FilterString = $FilterString -replace '  ',' '}
        While ($FilterString -match '  ')

        # Split back in to array, respecting quotes
        $Words = $FilterString.Trim().Split(' ')
        [String[]]$FilterString = @()
        $Temp = @()
        Foreach ($Word in $Words)
        {
          If ($Temp.Count -eq 0 -and $Word -match '^[\"\'']')
          {
            $Temp += $Word.TrimStart('"''')
          }
          ElseIf ($Temp.Count -gt 0 -and $Word -match "[\'\""]$")
          {
            $Temp += $Word.TrimEnd("'""")
            $FilterString += $Temp -join ' '
            $Temp = @()
          }
          ElseIf ($Temp.Count -gt 0)
          {
            $Temp += $Word
          }
          Else
          {
            $FilterString += $Word
          }
        }
      }
      
      Write-Debug ('{0}: Checking query for variables that have survived as string' -F $MyInvocation.MyCommand.Name)
      
      $NewFilter = @()
      Foreach ($Word in $FilterString)
      {
        $Value = $Word
        # Is it a variable name?
        If ($Word -match '^\$\{?(\w+:)?(\w+)\}?(\.\w[\.\w]+)?$')
        {
          # If present, first group is SCOPE. In the context of this function, the only possible scope
          # is Global; Script = the module, local is internal to this function.
          $Scope = 'Global' # or numbered scope 2
        
          # The variable name MUST be present
          $VariableName = $Matches[2]

          # A property tail CAN be present
          $PropertyTail = $Matches[3]
        
          # Check that the variable exists
          $Variable = Try
          { Get-Variable -Name $VariableName -Scope $Scope -ValueOnly -ErrorAction Stop }
          Catch
          {
            Write-Error ('{0}: Could not find any variable called ${1}. Is it misspelled or has it not been set yet?' -f $MyInvocation.MyCommand.Name, $VariableName)
            # Force stop of calling script, because this will completely break the query
            Return
          }

          # Test if the variable "Variable" has been set
          If (Test-Path Variable:Variable) {
            Write-Debug ('{0}: Substituting {1} for its value' -F $MyInvocation.MyCommand.Name, $Word)
            If ($PropertyTail) {
              # Add properties back 
              $Expression = '$Variable{0}' -F $PropertyTail
  
              # Invoke-Expression is considered risky from an SQL injection kind of perspective. But by only
              # permitting a .dot separated string of [a-zA-Z0-9_] we are PROBABLY safe...
              $Value = Invoke-Expression -Command $Expression
            }
            Else {
              $Value = $Variable
            }
            If ($Null -eq $Value) {
              Write-Error ('{0}: Could not find any variable called {1}. Is it misspelled or has it not been set yet?' -F $MyInvocation.MyCommand.Name, $Expression)
              # Force stop of calling script, because this will completely break the query
              Return
            }
            Else { 
              # Normalize dates. Important to avoid QueryXML problems
              If ($Value.GetType().Name -eq 'DateTime')
              {
                [String]$Value = ConvertTo-AtwsDate -ParameterName $NewFilter[-2] -DateTime $Value
              }
            }
          }
        }
        $NewFilter += $Value
      }
 
  }

  End {
    Return $NewFilter
  }
}