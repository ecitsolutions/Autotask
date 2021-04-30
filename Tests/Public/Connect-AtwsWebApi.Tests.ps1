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

BeforeAll { 
    $modulePath = '{0}\{1}' -F $RootPath, $ModuleName

    # Remove any loaded modules before trying to load it again
    Remove-Module -Name $ModuleName -Force -ErrorAction SilentlyContinue

}

Describe -Name 'Import module without any parameters' -Tag 'Import-Module' -Fixture {

    BeforeAll { 
        Import-Module $modulePath -Force
        $loadedModule = Get-Module $moduleName
    }

    It -Name 'should be loaded' -Test {
        $loadedModule.Name | Should -Be $moduleName
    }

    It -Name 'should export all commands' -Test {
        $loadedModule.ExportedCommands.Count | Should -BeGreaterThan 400
    }

    It -Name 'Get-AtwsAccount should have parameters with picklists' -Test {
        $loadedModule.ExportedCommands['Get-AtwsAccount'].Parameters.Accounttype.Attributes.TypeId.Name | Should -Contain 'ArgumentCompleterAttribute'
    }
}

Describe -Name 'Connect using explicit credentials' -Tag 'Connect-AtwsWebApi' -Fixture {

    BeforeAll { 
        # Call the connect command
        Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $ApiTrackingIdentifier

        # Get an account object to verify the connection
        $account = Get-AtwsAccount -id 0
    }

    It -Name 'should return a single account' -Test {
        $account.count | Should -Be 1
    }

    It -Name 'should be account with id 0' -Test {
        $account.id | Should -Be 0
    }

}

Describe -Name 'Connect using named configuration profile' -Tag 'Connect-AtwsWebApi' -Fixture {

    BeforeAll { 
        # Call the connect command
        Connect-AtwsWebAPI -name Pester

        # Get an account object to verify the connection
        $account = Get-AtwsAccount -id 0
    }

    It -Name 'should return a single account' -Test {
        $account.count | Should -Be 1
    }

    It -Name 'should be account with id 0' -Test {
        $account.id | Should -Be 0
    }

    It -Name 'should be a connection to a sandbox' -Test {
        $account.accountname | Should -Match "*Sandbox"
    }

}

# Remove any loaded modules before trying to load it again
Remove-Module -Name $ModuleName -Force -ErrorAction SilentlyContinue

Describe -Name 'Import module with Credentials' -Tag 'Import-Module', 'Authentication' -Fixture {

    Context -Name 'Straight import with credential and api tracking id' -Fixture {

        BeforeAll { 
            Import-Module $modulePath -Force -ArgumentList $Credential, $ApiTrackingIdentifier

            $loadedModule = Get-Module $moduleName
        }

        It -Name 'should be loaded' -Test {
            $loadedModule.Name | Should -Be $moduleName
        }

        It -Name 'should export hundreds of commands' -Test {
            $loadedModule.ExportedCommands.Count | Should -BeGreaterThan 400
        }

        It -Name 'Get-AtwsAccount should have parameters with picklists' -Test {
            $loadedModule.ExportedCommands['Get-AtwsAccount'].Parameters.Accounttype.Attributes.TypeId.Name | Should -Contain 'ArgumentCompleterAttribute'
        }
    }
}
    
    # Remove any loaded modules before trying to load it again
    Remove-Module -Name $ModuleName -Force -ErrorAction SilentlyContinue

Describe -Name 'Import module with Connect-AtwsWebApi' -Tag 'Import-Module', 'Authentication' -Fixture {

    BeforeAll { 
        # This one starts with a module loaded without options - already tested
        Import-Module $modulePath -Force
        Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $ApiTrackingIdentifier

        $loadedModule = Get-Module $moduleName
    }

    Context -Name 'Straight import with credential and api tracking id' -Fixture {

        It -Name 'should be loaded' -Test {
            $loadedModule.Name | Should -Be $moduleName
        }

        It -Name 'should export hundreds of commands' -Test {
            $loadedModule.ExportedCommands.Count | Should -BeGreaterThan 300
        }

        It -Name 'Get-AtwsAccount should have parameters with picklists' -Test {
            $loadedModule.ExportedCommands['Get-AtwsAccount'].Parameters.Accounttype.Attributes.TypeId.Name | Should -Contain 'ArgumentCompleterAttribute'
       }
    }
    
}