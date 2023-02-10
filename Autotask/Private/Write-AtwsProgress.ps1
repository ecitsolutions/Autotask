<#

    .COPYRIGHT
    Copyright (c) Hugo Klemmestad. All rights reserved. Licensed under the MIT license.
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
        $size = 30
        Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    }

    process {
        if ($env:TERM_PROGRAM -eq 'vscode' -and $PSVersionTable.PSVersion.Major -le 8) {
            # Running in VSCode. Do our own stuff.
            $i = [Math]::Round($PercentComplete / (100 / $size))
            $string = $CurrentOperation.substring(0, [System.Math]::Min(39, $CurrentOperation.Length))
            $Message = "`r[{2}] {1,3} % - {0,-39}" -f $string, $PercentComplete, (''.PadLeft($i, '#') + ''.PadLeft($size - $i, '-'))

            # When using -NoNewLine this will be overwritten by -Verbose and/or -Debug
            Write-Host $Message -ForegroundColor Green -NoNewline
            
            if ($Completed.IsPresent) {
                # End the line. Looks better.
                Write-Host "`n"
            }
            
            # Repeat message if -Verbose is on
            Write-Verbose $Message
        }
        else {
            # Write-Progress should be supported. Pass all parameters to Write-Progress
            Write-Progress @PSBoundParameters
        }
        
    }

    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    }
}
