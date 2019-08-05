<#
        .COPYRIGHT
        Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
        See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

        .SYNOPSIS
        Test if the module can be imported without error
        .DESCRIPTION
        Test the various ways this module can be imported. Requires valid Autotask credentials and an Api Tracking identifier.
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
    $ApiTrackingIdentifier
)

$ModuleName = 'Autotask'

$ModulePath = '{0}\{1}' -F $(Split-Path -Parent -Path (Split-Path -Parent -Path $MyInvocation.MyCommand.Path)), $ModuleName


describe -Name 'Import module without any parameters' -Tag 'Import-Module' -Fixture {
    Import-Module $ModulePath -Force

    $loadedModule = Get-Module $ModuleName

    it -Name 'should be loaded' -Test {
        $loadedModule.Name | Should -Be $ModuleName
    }

    it -Name 'should export only 1 command' -Test {
        $loadedModule.ExportedCommands.Count | Should -Be 1
    }

    it -Name 'should export only Connect-AtwsWebAPI' -Test {
        $loadedModule.ExportedCommands['Connect-AtwsWebApi'].Name | Should -Be 'Connect-AtwsWebApi'
    }
}

describe -Name 'Import module with Credentials' -Tag 'Import-Module', 'Authentication' -Fixture {
    context -Name 'Straight import with credential and api tracking id' -Fixture {
        Import-Module $ModulePath -Force -ArgumentList $Credential, $ApiTrackingIdentifier

        $loadedModule = Get-Module $ModuleName

        it -Name 'should be loaded' -Test {
            $loadedModule.Name | Should -Be $ModuleName
        }

        it -Name 'should export hundreds of commands' -Test {
            $loadedModule.ExportedCommands.Count | Should -BeGreaterThan 300
        }

        it -Name 'Get-AtwsAccount should have parameters with picklists' -Test {
            $loadedModule.ExportedCommands['Get-AtwsAccount'].Parameters.Accounttype.Attributes.ValidValues.Count | Should -BeGreaterThan 1
        }
    }
}


describe -Name 'Import module with Connect-AtwsWebApi' -Tag 'Import-Module', 'Authentication' -Fixture {
    Import-Module $ModulePath -Force

    context -Name 'Straight import with credential and api tracking id' -Fixture {
        Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $ApiTrackingIdentifier

        $loadedModule = Get-Module $ModuleName

        it -Name 'should be loaded' -Test {
            $loadedModule.Name | Should -Be $ModuleName
        }

        it -Name 'should export hundreds of commands' -Test {
            $loadedModule.ExportedCommands.Count | Should -BeGreaterThan 300
        }

        it -Name 'Get-AtwsAccount should have parameters with picklists' -Test {
            $loadedModule.ExportedCommands['Get-AtwsAccount'].Parameters.Accounttype.Attributes.ValidValues.Count | Should -BeGreaterThan 1
        }
    }

    context -Name 'Import with -NoDiskCache' -Fixture {
        Import-Module $ModulePath -Force    

        Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $ApiTrackingIdentifier -NoDiskCache

        $loadedModule = Get-Module $ModuleName

        it -Name 'should be loaded' -Test {
            $loadedModule.Name | Should -Be $ModuleName
        }

        it -Name 'should export hundreds of commands' -Test {
            $loadedModule.ExportedCommands.Count | Should -BeGreaterThan 300
        }

        it -Name 'Get-AtwsAccount should NOT have parameters with picklists' -Test {
            $loadedModule.ExportedCommands['Get-AtwsAccount'].Parameters.Accounttype.Attributes.ValidValues.Count | Should -Be 0
        }
    }
}