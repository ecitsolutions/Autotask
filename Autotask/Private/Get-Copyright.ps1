<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-Copyright {
    <#
        .SYNOPSIS
            This function returns the copyright text for the module.
        .DESCRIPTION
            This function returns the copyright text for the module.
        .INPUTS
            Nothing.
        .OUTPUTS
            Text.
        .EXAMPLE
            Get-Copyright
            Returns the copyright text for the module.
        .NOTES
            NAME: Get-Copyright 

  #>
    [CmdletBinding()]
    Param()
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

    # Copyright text as here-string
    @"
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
"@
}