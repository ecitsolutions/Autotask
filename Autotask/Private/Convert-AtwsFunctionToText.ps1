<#

.COPYRIGHT
Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.

#>
Function Convert-AtwsFunctionToText {
     <#
      .SYNOPSIS
        This function generates a scriptblock as text from a custom, structured object created 
        by other functions in this module
      .DESCRIPTION
        This function assembles the various parts of a function into a single text scriptblock.
        It is not generic. It is internal to this module.
      .INPUTS
        [PSObject]
      .OUTPUTS
        [String]
  #>
    [CmdLetBinding()]
    Param
    (   
        [Parameter(Mandatory = $true)]
        [PSObject]
        $AtwsFunction
    )

    begin { 
 
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
        
       # Value to insert in #Requires tag on top of every script file
        $requiredVersion = '5.0'

        # The textframe with placeholders for all dynamic elements
        $textFrame = "#Requires -Version {0}`n{1}`nFunction {2}`n{{`n{3}`n  [CmdLetBinding(SupportsShouldProcess = `$true, DefaultParameterSetName='{4}', ConfirmImpact='{5}')]`n  Param`n  (`n{6}`n  )`n{7}`n}}"
    }
  
    process {
        # Generate the function text from $textframe with all placeholders replaced with the correct variable
        $functionText = $textFrame -F
        $requiredVersion,
        $AtwsFunction.Copyright,
        $AtwsFunction.FunctionName,
        $AtwsFunction.HelpText,
        $AtwsFunction.DefaultParameterSetName,
        $AtwsFunction.ConfirmImpact,
        $($AtwsFunction.Parameters -join ",`n`n"),
        $AtwsFunction.Definition
    }
  
    end {
        # return the function text
        Return $functionText
    }
  
}
