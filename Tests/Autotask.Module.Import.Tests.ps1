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
    Mandatory = $true,
    ParameterSetName = 'Default'
  )]
  [ValidateNotNullOrEmpty()]    
  [pscredential]
  $Credential,
    
  [Parameter(
    Mandatory = $true,
    ParameterSetName = 'Default'
  )]
  [String]
  $ApiTrackingIdentifier
)

$ModuleName = 'Autotask'

$ModulePath = '{0}\{1}' -F $(Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)), $ModuleName


Describe 'Import module without any parameters' -Tag 'Import-Module' {

  Import-Module $ModulePath -Force

  $LoadedModule = Get-Module $ModuleName

  It 'should be loaded' {

    $LoadedModule.Name | Should -Be $ModuleName

  }

  It 'should export only 1 command' {

    $LoadedModule.ExportedCommands.Count | Should -Be 1

  }

  It 'should export only Connect-AtwsWebAPI' {

    $LoadedModule.ExportedCommands['Connect-AtwsWebApi'].Name | Should -Be 'Connect-AtwsWebApi'

  }

}

Describe 'Import module with Credentials' -Tag 'Import-Module', 'Authentication' {

  Context 'Straight import with credential and api tracking id' {

    Import-Module $ModulePath -Force -ArgumentList $Credential, $ApiTrackingIdentifier

    $LoadedModule = Get-Module $ModuleName

    It 'should be loaded' {

      $LoadedModule.Name | Should -Be $ModuleName

    }

    It 'should export hundreds of commands' {

      $LoadedModule.ExportedCommands.Count | Should -BeGreaterThan 300

    }

    It 'Get-AtwsAccount should have parameters with picklists' {

      $LoadedModule.ExportedCommands['Get-AtwsAccount'].Parameters.Accounttype.Attributes.ValidValues.Count | Should -BeGreaterThan 1

    }

  }
}


Describe 'Import module with Connect-AtwsWebApi' -Tag 'Import-Module', 'Authentication' {

  Import-Module $ModulePath -Force

  Context 'Straight import with credential and api tracking id' {

    Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $ApiTrackingIdentifier

    $LoadedModule = Get-Module $ModuleName

    It 'should be loaded' {

      $LoadedModule.Name | Should -Be $ModuleName

    }

    It 'should export hundreds of commands' {

      $LoadedModule.ExportedCommands.Count | Should -BeGreaterThan 300

    }

    It 'Get-AtwsAccount should have parameters with picklists' {

      $LoadedModule.ExportedCommands['Get-AtwsAccount'].Parameters.Accounttype.Attributes.ValidValues.Count | Should -BeGreaterThan 1

    }

  }

  Context 'Import with -NoDiskCache' {

    Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $ApiTrackingIdentifier -NoDiskCache

    $LoadedModule = Get-Module $ModuleName

    It 'should be loaded' {

      $LoadedModule.Name | Should -Be $ModuleName

    }

    It 'should export hundreds of commands' {

      $LoadedModule.ExportedCommands.Count | Should -BeGreaterThan 300

    }

    It 'Get-AtwsAccount should NOT have parameters with picklists' {

      $LoadedModule.ExportedCommands['Get-AtwsAccount'].Parameters.Accounttype.Attributes.ValidValues.Count | Should -Be 0

    }

  }


}