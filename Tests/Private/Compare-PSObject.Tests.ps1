<#
        .COPYRIGHT
        Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
        See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

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
    Describe 'Compare-PSObject' {
        Context 'Simple collections' { 
            # Objects to compare
            $reference = @('a', 'b', 'c')
            $difference = @('a', 'b', 'c')
            It 'three strings, same order should be identical' {
                Compare-PSObject -ReferenceObject $reference -DifferenceObject $difference | Should -Be $true
            }
        
            $difference = @('c', 'b', 'a')
            It 'three strings, reverse order should be different' {
                Compare-PSObject -ReferenceObject $reference -DifferenceObject $difference | Should -Be $false
            }

            $difference = @('a', 'b')
            It 'three against two strings should be different' {
                Compare-PSObject -ReferenceObject $reference -DifferenceObject $difference | Should -Be $false
            }

            $difference = @('a', 'b', 'c', 'd')
            It 'three against four strings should be different' {
                Compare-PSObject -ReferenceObject $reference -DifferenceObject $difference | Should -Be $false
            }
        }

        Context 'Custom objects' {
            $reference = @()
            $reference += New-Object -TypeName PSObject -Property @{
                name  = 'Object 1'
                value = 1234
            }
            $reference += New-Object -TypeName PSObject -Property @{
                name  = 'Object 2'
                value = 4321
            }

            $difference = @()
            $difference += New-Object -TypeName PSObject -Property @{
                name  = 'Object 1'
                value = 1234
            }
            $difference += New-Object -TypeName PSObject -Property @{
                name  = 'Object 2'
                value = 4321
            }

            It 'two objects, same order should be identical' {
                Compare-PSObject -ReferenceObject $reference -DifferenceObject $difference | Should -Be $true
            }

            $difference = @()
            $difference += New-Object -TypeName PSObject -Property @{
                name  = 'Object 2'
                value = 4321
            }
            $difference += New-Object -TypeName PSObject -Property @{
                name  = 'Object 1'
                value = 1234
            }
            It 'two objects, reverse order should be different' {
                Compare-PSObject -ReferenceObject $reference -DifferenceObject $difference | Should -Be $false
            }
        }
    }
}