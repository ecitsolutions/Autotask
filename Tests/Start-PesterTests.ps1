<#

        .COPYRIGHT
        Copyright (c) Hugo Klemmestad. All rights reserved. Licensed under the MIT license.
        See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.

        .SYNOPSIS
        Start the test set
        .DESCRIPTION
        In this, the topmost Pester script I collect necessary parameters and pass them on to the tests that need them.
        .INPUTS
        Nothing. This function only takes parameters.
        .OUTPUTS
        Nothing.

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


Import-Module -Name Pester

# Move to the folder with your module code and tests

$TestsFolder = Split-Path -Parent -Path $MyInvocation.MyCommand.Path

Set-Location  $TestsFolder 

# Name the module
$moduleName = 'Autotask'

# Store its path
$rootPath = Split-Path -Parent $TestsFolder

# Run the structure test

$pesterConfig = [PesterConfiguration]::Default
$pesterConfig.Run.Path = "$TestsFolder\Autotask.Module.Validation.Tests.ps1"

foreach ($tag in 'Manifest', 'Functions') {
    $pesterConfig.Filter.Tag = $tag
    $TestResult = Invoke-Pester -Configuration $pesterConfig
        Parameters = @{
            Credential            = $Credential
            ApiTrackingIdentifier = $ApiTrackingIdentifier
            ModuleName            = $moduleName
            RootPath              = $rootPath 
        }


    If ($TestResult.PassedCount -ne $TestResult.PassedCount) { Throw 'Manifest did not validate, execution stopped' }
}

# Test module import
Invoke-Pester -Script @{
    Path       = "$TestsFolder\Autotask.Module.Import.Tests.ps1"
    Parameters = @{
        Credential            = $Credential
        ApiTrackingIdentifier = $ApiTrackingIdentifier
        ModuleName            = $moduleName
        RootPath              = $rootPath 
    }
}

# Test Datetime handling
Invoke-Pester -Script @{
    Path       = "$TestsFolder\Autotask.Module.DateTime.Tests.ps1"
    Parameters = @{
        Credential            = $Credential
        ApiTrackingIdentifier = $ApiTrackingIdentifier
        ModuleName            = $moduleName
        RootPath              = $rootPath 
    }
}

# Test private functions
Invoke-Pester -Script @{
    Path       = "$TestsFolder\Private\*.Tests.ps1"
    Parameters = @{
        Credential            = $Credential
        ApiTrackingIdentifier = $ApiTrackingIdentifier
        ModuleName            = $moduleName
        RootPath              = $rootPath 
    }
}  #-Name 'Compare-PSObject'


# Verify that we still pass all issues
Invoke-Pester -Script @{
    Path       = "$TestsFolder\Autotask.Module.Issues.Tests.ps1"
    Parameters = @{
        Credential            = $Credential
        ApiTrackingIdentifier = $ApiTrackingIdentifier
        ModuleName            = $moduleName
        RootPath              = $rootPath 
    }
}  #-Name 'Issue #1'
