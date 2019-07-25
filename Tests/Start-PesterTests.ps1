# Pester

Import-Module Pester



# Move to the folder with your module code and tests

$TestsFolder = Split-Path -Parent $MyInvocation.MyCommand.Path

Set-Location  $TestsFolder 



# Run the structure test

foreach ($tag in 'Manifest', 'Functions') { 

  $TestResult = Invoke-Pester "$TestsFolder\Autotask.Module.Validation.Tests.ps1" -Show Fails -Tag $tag -PassThru

  If ($TestResult.PassedCount -ne $TestResult.PassedCount) {

    Throw "Manifest did not validate, execution stopped"

  }

}
# Test module import
Invoke-Pester "$TestsFolder\Autotask.Module.Import.Tests.ps1" 

# Verify that we still pass all issues
Invoke-Pester "$TestsFolder\Autotask.Module.Issues.Tests.ps1" 