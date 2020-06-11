<#
        .COPYRIGHT
        Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
        See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.

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
    $RootPath =  $(Split-Path -Parent -Path (Split-Path -Parent -Path $MyInvocation.MyCommand.Path))
)

$modulePath = '{0}\{1}' -F $RootPath, $ModuleName

# Remove any loaded modules before trying to load it again
Remove-Module -Name $ModuleName -Force -ErrorAction SilentlyContinue

Describe -Name 'Import module without any parameters' -Tag 'Import-Module' -Fixture {
    Import-Module $modulePath -Force

    $loadedModule = Get-Module $moduleName

    It -Name 'should be loaded' -Test {
        $loadedModule.Name | Should -Be $moduleName
    }

    It -Name 'should export only 1 command' -Test {
        $loadedModule.ExportedCommands.Count | Should -Be 1
    }

    It -Name 'should export only Connect-AtwsWebAPI' -Test {
        $loadedModule.ExportedCommands['Connect-AtwsWebApi'].Name | Should -Be 'Connect-AtwsWebApi'
    }
}



Describe -Name 'Import module with Credentials' -Tag 'Import-Module', 'Authentication' -Fixture {

    # Remove any loaded modules before trying to load it again
    Remove-Module -Name $ModuleName -Force -ErrorAction SilentlyContinue

    Context -Name 'Straight import with credential and api tracking id' -Fixture {
        Import-Module $modulePath -Force -ArgumentList $Credential, $ApiTrackingIdentifier

        $loadedModule = Get-Module $moduleName

        It -Name 'should be loaded' -Test {
            $loadedModule.Name | Should -Be $moduleName
        }

        It -Name 'should export hundreds of commands' -Test {
            $loadedModule.ExportedCommands.Count | Should -BeGreaterThan 300
        }

        It -Name 'Get-AtwsAccount should have parameters with picklists' -Test {
            $loadedModule.ExportedCommands['Get-AtwsAccount'].Parameters.Accounttype.Attributes.ValidValues.Count | Should -BeGreaterThan 1
        }
    }
}


Describe -Name 'Import module with Connect-AtwsWebApi' -Tag 'Import-Module', 'Authentication' -Fixture {
    
    # Remove any loaded modules before trying to load it again
    Remove-Module -Name $ModuleName -Force -ErrorAction SilentlyContinue
    
    Context -Name 'Import with -NoDiskCache' -Fixture {

        Import-Module $modulePath -Force    

        Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $ApiTrackingIdentifier -NoDiskCache

        $loadedModule = Get-Module $moduleName

        It -Name 'should be loaded' -Test {
            $loadedModule.Name | Should -Be $moduleName
        }

        It -Name 'should export hundreds of commands' -Test {
            $loadedModule.ExportedCommands.Count | Should -BeGreaterThan 300
        }

        It -Name 'Get-AtwsAccount should NOT have parameters with picklists' -Test {
            $loadedModule.ExportedCommands['Get-AtwsAccount'].Parameters.Accounttype.Attributes.ValidValues.Count | Should -Be 0
        }
    }
 
    # Remove any loaded modules before trying to load it again
    Remove-Module -Name $ModuleName -Force -ErrorAction SilentlyContinue
    
    # This one starts with a module loaded without options - already tested
    Import-Module $modulePath -Force

    Context -Name 'Straight import with credential and api tracking id' -Fixture {
        Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $ApiTrackingIdentifier

        $loadedModule = Get-Module $moduleName

        It -Name 'should be loaded' -Test {
            $loadedModule.Name | Should -Be $moduleName
        }

        It -Name 'should export hundreds of commands' -Test {
            $loadedModule.ExportedCommands.Count | Should -BeGreaterThan 300
        }

        It -Name 'Get-AtwsAccount should have parameters with picklists' -Test {
            $loadedModule.ExportedCommands['Get-AtwsAccount'].Parameters.Accounttype.Attributes.ValidValues.Count | Should -BeGreaterThan 1
        }
    }
    
}