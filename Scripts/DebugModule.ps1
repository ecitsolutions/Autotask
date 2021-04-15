<#

    Just a script so we have a workbench we can invoke to debug session.
    This is basically a workflow of what we need to write tests for as well.
#>


Import-Module Pester -RequiredVersion 5.1.0 -ErrorAction Stop
$PesterModule = Get-Module -Name Pester
    
$moduleName = 'Autotask'
$RootPath = 'C:\Git\Autotask'
$modulePath = '{0}\{1}' -F $RootPath, $ModuleName
$SandBoxDomain = '@ECITSOLUTIONSSB12032021.NO'

if (-not $Global:Credential -or -not $Global:TI) {
    Write-Warning "Running pester tests based on defaultconfig."
    $P = Join-Path (Split-Path -Path $profile -Parent) -ChildPath 'AtwsConfig.clixml'
    $Settings = Import-Clixml -Path $P -ErrorAction Stop
    try {
        $Global:Credential = [pscredential]::new($Settings.Default.Username, $Settings.Default.SecurePassword)
        $SBUname = $Settings.Default.Username.Split('@')[0] + $SandBoxDomain
        $Global:SandboxCredential = [pscredential]::new($SBUname, $Settings.Default.SecurePassword)
        $Global:SecureTI = $Settings.Default.SecureTrackingIdentifier
    
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Global:SecureTI)
        $Global:TI = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($BSTR)
    }
    catch {
        $message = "Cannot read default moduleconfig file for pester tests. set this up before running pester test."
        throw (New-Object System.Configuration.Provider.ProviderException $message)
    }
}
    
$PesterConfigPath = Join-Path (Split-Path -Path $profile -Parent) -ChildPath 'AtwsPesterConfig.clixml'
if (Test-Path $PesterConfigPath) {
    Remove-Item $PesterConfigPath
}

Import-Module $modulePath -Force -ErrorAction Stop
$loadedModule = Get-Module $moduleName

Connect-AtwsWebAPI -AtwsModuleConfigurationName Sandbox


#Error 1:
$Config = New-AtwsModuleConfiguration -Credential $Global:SandboxCredential -SecureTrackingIdentifier $Global:SecureTI -ErrorLimit 20
Connect-AtwsWebAPI -AtwsModuleConfiguration $Config

#Error 2:
$Config = New-AtwsModuleConfiguration -Credential $Global:SandboxCredential -SecureTrackingIdentifier $Global:SecureTI -ErrorLimit 20
            
Connect-AtwsWebAPI -AtwsModuleConfigurationName Pester

$Products = Get-AtwsInstalledProduct -Type Firewall
$cont = $false
$Products[0].psobject.Properties.name.ForEach{
    if ($_ -match '#') {
        $cont = $true
    }
}
if (-not $Cont) {
    Write-Error "fix this"
}

#Error 3:
$Devices = Get-AtwsInstalledProduct -Type Server -Active $true
$Devices.Count | Should -BeGreaterThan 600

$Req1 = Set-AtwsInstalledProduct -InputObject $Devices -UserDefinedFields @{Name = 'Sist logget inn'; Value = 'Pester UDF test var her.' } -PassThru

# TODO: UseCase: now restore old data. Should be able to run Set-AtwsInstalledProduct -InputObject $Devices right?
$Req2 = Set-AtwsInstalledProduct -InputObject $Devices -PassThru

$AfterModifications = Get-AtwsInstalledProduct -id $Devices.id


