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
    Describe 'Copy-PSObject' {

        Context 'Collection of custom objects' {
            $object = @()
            $object += New-Object -TypeName PSObject -Property @{
                name  = 'Object 1'
                value = 1234
            }
            $object += New-Object -TypeName PSObject -Property @{
                name  = 'Object 2'
                value = 4321
            }

            $newObject = Copy-PSObject -InputObject $object

            It 'should be identical as objects' {
                Compare-PSObject -ReferenceObject $object -DifferenceObject $newObject | Should -Be $true
            }

            It 'should be identical by property' {
                $newObject[0].name  | Should -Be 'Object 1'
                $newObject[0].value | Should -Be 1234
                $newObject[1].name | Should -Be 'Object 2'
                $newObject[1].value | Should -Be 4321
            }

            $newObject[0].value = 5678
            $newObject[1].name = 'Object 3'
            It 'should be different as objects' {
                Compare-PSObject -ReferenceObject $object -DifferenceObject $newObject | Should -Be $false
            }
            It 'should be different by property' {
                $newObject[0].name | Should -Be $object[0].name
                $newObject[0].value | Should -Not -Be $object[0].value
                $newObject[1].name | Should -Not -Be $object[1].name
                $newObject[1].value | Should -Be $object[1].value
            }

        }
    }
}