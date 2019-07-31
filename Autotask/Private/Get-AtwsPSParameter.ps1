
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsPSParameter {
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
    [CmdLetBinding()]
    [Outputtype([string])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [string[]]$Alias,
    
        [Parameter(Mandatory = $true)]
        [string]$type,
    
        [switch]$Mandatory,

        [Alias('Remaining')]
        [switch]$ValueFromRemainingArguments,

        [Alias('setName')]
        [string[]]$ParametersetName,

        [Alias('Pipeline')]
        [switch]$valueFromPipeline,

        [Alias('NotNull')]
        [switch]$ValidateNotNullOrEmpty,

        [string[]]$ValidateSet,

        [Alias('Length')]
        [int]$ValidateLength,

        [string]$Comment,

        [switch]$Array,
        
        [switch]$nullable


          
    )
  
    begin { 
        if ($Comment)
        { [string]$text = "# {0}`n" -F $Comment }
        else
        { [string]$text = '' }
    }

    process { 
        foreach ($setName in $parametersetName) { 
            # Make an array of properties that goes inside the Parameter clause
            $paramProperties = @()
        
            # Hardcoded filter against requiring parameters for 'Input_Object'
            if ($Mandatory.IsPresent -and $setName -in 'By_parameters', 'Filter') {
                $paramProperties += "      Mandatory = `$true"  
            }
            if ($valueFromRemainingArguments.IsPresent) {
                $paramProperties += "      ValueFromRemainingArguments = `$true" 
            } 
            if ($parametersetName) {
                $paramProperties += "      ParametersetName = '$setName'" 
            }
            if ($valueFromPipeline.IsPresent) {
                $paramProperties += "      ValueFromPipeline = `$true" 
            }

            # Create the [Parameter()] clause
            if ($paramProperties.Count -gt 0) {
                $text += "    [Parameter(`n"
                $text += $paramProperties -join ",`n"
                $text += "`n    )]`n"
            }
        }
        # Add any aliases
        if ($Alias.Count -gt 0) {
            $text += "    [Alias('{0}')]`n" -F $($Alias -join "','")
        }
        # Add validate not null if present
        if ($ValidateNotNullOrEmpty.IsPresent) {
            $text += "    [ValidateNotNullOrEmpty()]`n" 
        }

        # Add validate length if present
        if ($ValidateLength -gt 0) {
            $text += "    [ValidateLength(0,$ValidateLength)]`n" 
        }
        
        # Add Validateset if present
        if ($ValidateSet.Count -gt 0) { 
            # Fix quote characters for labels
            $labels = foreach ($Label in  $ValidateSet) {
                if ($Label -match ("['{0}]" -F [Char]8217)) {
                    '"{0}"' -F $Label
                }
                else {
                    "'{0}'" -F $Label
                }
            }          
            $text += "    [ValidateSet($($labels -join ', '))]`n" 
        }

        # Add the correct variable type for the parameter
        $type = switch ($type) {
            'Integer' {
                'Int'
            }
            'Short' {
                'Int16'
            }
            default {
                $type
            }
        }
        if ($nullable.IsPresent) {
            $type = "Nullable[$type]"
        }
        $text += "    [$type"
        if ($Array.IsPresent) {
            $text += '[]'
        }
        $text += "]`n`    `$$Name"
    }

    end { 
        Return $text
    }
}
