<#

    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

#>

Function Write-AtwsProgress {
    <#
      .SYNOPSIS
      This function emulates a very simple Write-Progress when running under VSCode, otherwise it just calls
      Write-Progress.
      .DESCRIPTION
      This function emulates a very simple Write-Progress when running under VSCode, otherwise it just calls
      Write-Progress. 
      .INPUTS
      Nothing, only parameters.
      .OUTPUTS
      Text or calls Write-Progress
      .NOTES
      NAME: Write-AtwsProgress
      
  #>
    [cmdletbinding()]
    Param
    (
        [string]$Activity,
        [string]$Status,
        [int]$Id,
        [int]$PercentComplete,
        [int]$SecondsRemaining,
        [string]$CurrentOperation,
        [int]$ParentID,
        [switch]$Completed,
        [int]$SourceId
    )

    begin {
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {
            $DebugPreference = 'Continue'
        }

        # Progress bar length in characters
        $size = 40
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    }

    process {
        if ($env:TERM_PROGRAM -eq 'vscode') {
            # Running in VSCode. Do our own stuff.
            $i = [Math]::Round($PercentComplete / (100/ $size))
            $Message = "`r{0}: [{2}] {1} % Complete" -f $Activity, $PercentComplete, (''.PadLeft($i, '*') + ''.PadLeft($size - $i, '-'))

            # When using -NoNewLine this will be overwritten by -Verbose and/or -Debug
            Write-Host $Message -ForegroundColor Green -NoNewline
            
            # Repeat message if -Verbose is on
            Write-Verbose $Message
        }
        else {
            # Write-Progress should be supported. Pass all parameters to Write-Progress
            Write-Progress @PSBoundParameters
        }
        Write-Verbose ('{0}: Converting datetime to {1}' -F $MyInvocation.MyCommand.Name, $value)
        
    }

    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    }
}