<#
        .COPYRIGHT
        Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
        See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.

        .SYNOPSIS
        Test the function of the same name as the test file.
        .DESCRIPTION
        Runs Pester tests against the function by the same name as the test file.
#>

[cmdletbinding(
    SupportsShouldProcess = $True,
    ConfirmImpact = 'Low',
    DefaultParameterSetName = 'Default'
)]

Param
(
    [Parameter(
        Mandatory = $True,
        ParameterSetName = 'Default'
    )]
    [ValidateNotNullOrEmpty()]    
    [pscredential]
    $Credential,
    
    [Parameter(
        Mandatory = $True,
        ParameterSetName = 'Default'
    )]
    [String]
    $ApiTrackingIdentifier,

    [Parameter(
        Mandatory = $false,
        ParameterSetName = 'Default'
    )]
    [String]
    $ModuleName = 'Autotask',

    [Parameter(
        Mandatory = $false,
        ParameterSetName = 'Default'
    )]
    [ValidateSCript( {
            Test-Path $_
        })]
    [String]
    $RootPath = $(Split-Path -Parent -Path (Split-Path -Parent -Path $MyInvocation.MyCommand.Path))
)

$modulePath = '{0}\{1}' -F $RootPath, $ModuleName

$loadedModule = Get-Module -Name $ModuleName
If (-not ($loadedModule)) { 
    # Import the module. Issues that need their own load version will have to do so in their context
    Import-Module $modulePath -Force -ArgumentList $Credential, $ApiTrackingIdentifier
}

# this is a private function 
InModuleScope Autotask { 
    Describe 'ConvertTo-AtwsDate' {

        # The date as [DateTime]
        $date = Get-Date '2019.08.06'
        
        # The date as a sortable date [string] with UTC offset appended                           
        $this = $date.ToString('yyyy-MM-ddTHH:mm:ss.ffffz')

        It 'should be this' {
            ConvertTo-AtwsDate -DateTime $Date | Should -Be $this
        }
    }
}