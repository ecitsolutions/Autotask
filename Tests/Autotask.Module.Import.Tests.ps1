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


Describe -Name 'Import module without any parameters' -Tag 'Import-Module' -Fixture {
    Import-Module $ModulePath -Force

    $LoadedModule = Get-Module $ModuleName

    It -Name 'should be loaded' -Test {
        $LoadedModule.Name | Should -Be $ModuleName
    }

    It -Name 'should export only 1 command' -Test {
        $LoadedModule.ExportedCommands.Count | Should -Be 1
    }

    It -Name 'should export only Connect-AtwsWebAPI' -Test {
        $LoadedModule.ExportedCommands['Connect-AtwsWebApi'].Name | Should -Be 'Connect-AtwsWebApi'
    }
}

Describe -Name 'Import module with Credentials' -Tag 'Import-Module', 'Authentication' -Fixture {
    Context -Name 'Straight import with credential and api tracking id' -Fixture {
        Import-Module $ModulePath -Force -ArgumentList $Credential, $ApiTrackingIdentifier

        $LoadedModule = Get-Module $ModuleName

        It -Name 'should be loaded' -Test {
            $LoadedModule.Name | Should -Be $ModuleName
        }

        It -Name 'should export hundreds of commands' -Test {
            $LoadedModule.ExportedCommands.Count | Should -BeGreaterThan 300
        }

        It -Name 'Get-AtwsAccount should have parameters with picklists' -Test {
            $LoadedModule.ExportedCommands['Get-AtwsAccount'].Parameters.Accounttype.Attributes.ValidValues.Count | Should -BeGreaterThan 1
        }
    }
}


Describe -Name 'Import module with Connect-AtwsWebApi' -Tag 'Import-Module', 'Authentication' -Fixture {
    Import-Module $ModulePath -Force

    Context -Name 'Straight import with credential and api tracking id' -Fixture {
        Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $ApiTrackingIdentifier

        $LoadedModule = Get-Module $ModuleName

        It -Name 'should be loaded' -Test {
            $LoadedModule.Name | Should -Be $ModuleName
        }

        It -Name 'should export hundreds of commands' -Test {
            $LoadedModule.ExportedCommands.Count | Should -BeGreaterThan 300
        }

        It -Name 'Get-AtwsAccount should have parameters with picklists' -Test {
            $LoadedModule.ExportedCommands['Get-AtwsAccount'].Parameters.Accounttype.Attributes.ValidValues.Count | Should -BeGreaterThan 1
        }
    }

    Context -Name 'Import with -NoDiskCache' -Fixture {
        Import-Module $ModulePath -Force    

        Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $ApiTrackingIdentifier -NoDiskCache

        $LoadedModule = Get-Module $ModuleName

        It -Name 'should be loaded' -Test {
            $LoadedModule.Name | Should -Be $ModuleName
        }

        It -Name 'should export hundreds of commands' -Test {
            $LoadedModule.ExportedCommands.Count | Should -BeGreaterThan 300
        }

        It -Name 'Get-AtwsAccount should NOT have parameters with picklists' -Test {
            $LoadedModule.ExportedCommands['Get-AtwsAccount'].Parameters.Accounttype.Attributes.ValidValues.Count | Should -Be 0
        }
    }
}