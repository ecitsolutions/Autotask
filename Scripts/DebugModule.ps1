<#

    Just a script so we have a workbench we can invoke to debug session.
    This is basically a workflow of what we need to write tests for as well.
#>

$moduleName = 'Autotask'
$RootPath = 'C:\Git\Autotask'
$modulePath = '{0}\{1}' -F $RootPath, $ModuleName

# if (-not $Global:Credential -or -not $Global:TI) {
#     [pscredential]$Global:Credential = Get-Credential -UserName 'bautomation@ECITSOLUTIONS.no'
#     $Global:TI = Read-Host -Prompt 'API TrackingIdentifier'
# }

Import-Module $modulePath -Force -ErrorAction Stop
$loadedModule = Get-Module $moduleName

$Path = Join-Path (Split-Path -Path $profile -Parent) -ChildPath 'AtwsConfig.clixml'
if (Test-Path $Path ) {
    "We have an existing configuration:"
    $Settings = Import-Clixml -Path $Path
    $Settings.values
}


#Region Connect to the module using saved moduleconfiguration.
Write-Warning '#Region Connect to the module using saved moduleconfiguration.'
# "Connecting by passing parameters to Connect-AtwsWebAPI"
# Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $TI
# Get-AtwsAccount -id 0 | Select-Object accountname

"Connecting by using default config"
# Connect-AtwsWebAPI #-AtwsModuleConfigurationPath C:\Users\bjorn\Documents\PowerShell\AtwsConfig.clixml
Get-AtwsAccount -id 0 | Select-Object accountname
#EndRegion
Write-Warning '#EndRegion'


#Region Save new module configuration and connect using it
#TODO: Problem, Function is not exported.
# Get-AtwsModuleConfiguration -Name Default
Set-AtwsModuleConfiguration -Username 'bautomation@ECITSOLUTIONSSB12032021.NO' -Name 'SandBox' -ErrorLimit 20
Save-AtwsModuleConfiguration -Name ''
Get-AtwsModuleConfiguration -Name 'SandBox'
Get-AtwsModuleConfiguration -Name Default | Set-AtwsModuleConfiguration -ErrorLimit 19 
Save-AtwsModuleConfiguration -Name SandBox


Connect-AtwsWebAPI -AtwsModuleConfigurationName SandBox
Get-AtwsAccount -id 0 | Select-Object accountname


#Now we need to check that Build-AtwsModule does not mess anything up., ergo run same tests afer build

<#
    Instructions on how to set up module configurations.
    1. The first time connecting you will be asked for credentials, since no existing moduleconfiguration will exist.
#>
