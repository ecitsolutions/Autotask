<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

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


Import-Module Pester



# Move to the folder with your module code and tests

$TestsFolder = Split-Path -Parent $MyInvocation.MyCommand.Path

Set-Location  $TestsFolder 



# Run the structure test

foreach ($tag in 'Manifest'<#, 'Functions'#>) { 

  $TestResult = Invoke-Pester "$TestsFolder\Autotask.Module.Validation.Tests.ps1" -Show Fails -Tag $tag -PassThru

  If ($TestResult.PassedCount -ne $TestResult.PassedCount) {

    Throw "Manifest did not validate, execution stopped"

  }

}
# Test module import
Invoke-Pester -Script @{ 
  Path       = "$TestsFolder\Autotask.Module.Import.Tests.ps1"; 
  Parameters = @{ Credential = $Credential; ApiTrackingIdentifier = $ApiTrackingIdentifier } 
}

# Verify that we still pass all issues
Invoke-Pester -Script @{ 
  Path       = "$TestsFolder\Autotask.Module.Issues.Tests.ps1"; 
  Parameters = @{ Credential = $Credential; ApiTrackingIdentifier = $ApiTrackingIdentifier } 
} # -Name 'Issue #1'
