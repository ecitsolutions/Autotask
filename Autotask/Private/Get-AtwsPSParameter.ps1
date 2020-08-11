
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsPSParameter {
    <#
        .SYNOPSIS
            This function creates a Powershell parameter definition as text.
        .DESCRIPTION
            Based on parameter values this function creates Powershell code as
            text that can be converted to a scriptblock and executed.
        .INPUTS
            Multiple parameters representing the various parameter options.
        .OUTPUTS
            Text
        .EXAMPLE
            Get-AtwsPSParameter -Name 'Filter' -SetName 'Filter' -Type 'string' -Mandatory -Remaining -NotNull  -Array -Comment $Comment
            Returns as text:

            # <value of $comment>
            [Parameter(
                Mandatory = $true,
                ValueFromRemainingArguments = $true,
                ParametersetName = 'Filter'
            )]
            [ValidateNotNullOrEmpty()]
            [string[]]
            $Filter
        .NOTES
            NAME: Get-AtwsPSParameter
        .LINK

  #>
    [CmdLetBinding()]
    [Outputtype([string])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [string]$EntityName,

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

        [switch]$isPicklist,

        [string]$PickListParentValueField,

        [Alias('Length')]
        [int]$ValidateLength,

        [string]$Comment,

        [switch]$Array,
        
        [switch]$nullable

    )
  
    begin { 
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
        
        if ($Comment)
        { [string]$text = "# {0}`n" -F $Comment }
        else
        { [string]$text = '' }

        # Set up regex and replacement variables for curly single quote
        $pattern = [Char]8217
        $replacement = [Char]8217, [Char]8217 -join ''
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
        
        # Add picklists expander if present
        if ($isPicklist.IsPresent) { 
            # for nested picklist. Which is Ticket issue -> subissue only...
            if ($PickListParentValueField) {
                $text += @"
    [ArgumentCompleter( {
        param(`$Cmd, `$Param, `$Word, `$Ast, `$FakeBound)
        if (`$fakeBound.$PickListParentValueField) {
            `$parentvalue = `$fakeBound.$PickListParentValueField
            if ([int]`$parentValue -eq `$parentValue) {
                `$parentPicklist = Get-AtwsPicklistValue -Entity $EntityName -Field $PickListParentValueField
                `$parentValue = `$parentPicklist[`$parentValue]
            }      
            `$picklists = Get-AtwsPicklistValue -Entity $EntityName -FieldName $FieldName
            `$picklists[`$parentValue]['byLabel'].Keys
        }
        else {
            Get-AtwsPicklistValue -Entity $EntityName -FieldName $FieldName -Label
        }
    })]`n
"@
            }
            else { 
                # Add dynamic intellisense help 
                $text += "    [ArgumentCompleter({`n      param(`$Cmd, `$Param, `$Word, `$Ast, `$FakeBound)`n      Get-AtwsPicklistValue -Entity $EntityName -FieldName $Name -Label`n    })]`n"
            }
            # Validate that label exists
            $text += "    [ValidateScript({`n      `$set = Get-AtwsPicklistValue -Entity $EntityName -FieldName $Name -Label`n      if (`$_ -in `$set) { return `$true}`n      else {`n        Write-Warning ('{0} is not one of {1}' -f `$_, (`$set -join ', '))`n        Return `$false`n      }`n    })]`n"
        }
        # Add Validateset if present
        elseIf ($ValidateSet.Count -gt 0) { 
            # Fix quote characters for labels
            $labels = foreach ($Label in  $ValidateSet) {
                # Use literal string with escaped literal quotes, both straight and curly
                "'{0}'" -F $($Label -replace "'", "''" -replace $pattern, $replacement) 
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
