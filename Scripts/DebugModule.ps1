<#

    Just a script so we have a workbench we can invoke to debug session.
    This is basically a workflow of what we need to write tests for as well.
#>

Import-Module Pester -RequiredVersion 5.1.0 -ErrorAction Stop
$PesterModule = Get-Module -Name Pester
    
$moduleName = 'Autotask'
$RootPath = 'C:\Git\Autotask'
$modulePath = '{0}\{1}' -F $RootPath, $ModuleName

if (-not $Global:Credential -or -not $Global:TI) {
    [pscredential]$Global:Credential = Get-Credential -UserName 'bautomation@ECITSOLUTIONS.no'
    $Global:TI = Read-Host -Prompt 'API TrackingIdentifier'
}

Import-Module $modulePath -Force -ErrorAction Stop
$loadedModule = Get-Module $moduleName

$Path = Join-Path (Split-Path -Path $profile -Parent) -ChildPath 'AtwsConfig.clixml'
if (Test-Path $Path ) {
    "We have an existing configuration:"
    $Settings = Import-Clixml -Path $Path
    $Settings
}

"Connecting by passing parameters to Connect-AtwsWebAPI"
Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $TI
Get-AtwsAccount -id 0 | Select-Object accountname

"Connecting by using default config"
Connect-AtwsWebAPI #-AtwsModuleConfigurationPath C:\Users\bjorn\Documents\PowerShell\AtwsConfig.clixml
Get-AtwsAccount -id 0 | Select-Object accountname


Set-AtwsModuleConfiguration -Username 'bautomation@ECITSOLUTIONS.NO'

Get-AtwsAccount -id 0 | Select-Object accountname
