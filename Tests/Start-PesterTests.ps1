# Pester

Import-Module Pester



# Move to the folder with your module code and tests

$TestsFolder = Split-Path -Parent $MyInvocation.MyCommand.Path

Set-Location  $TestsFolder 



# Run the structure tests

#Invoke-Pester "$TestsFolder\Autotask.Module.Tests.ps1" 
Invoke-Pester "$TestsFolder\Get-AtwsAccount.Tests.ps1" 

