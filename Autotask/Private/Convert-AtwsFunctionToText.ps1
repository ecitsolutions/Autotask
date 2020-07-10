<#

.COPYRIGHT
Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.

#>
Function Convert-AtwsFunctionToText {
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
        $textFrame = "#Requires -Version {0}`n{2}`nFunction {3}`n{{`n{4}`n  [CmdLetBinding(SupportsShouldProcess = `$true, DefaultParameterSetName='{5}', ConfirmImpact='{6}')]`n  Param`n  (`n{7}`n  )`n{8}`n}}"
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
