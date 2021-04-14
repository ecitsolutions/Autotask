

BeforeAll {
    Import-Module Pester -RequiredVersion 5.1.0 -ErrorAction Stop
    $PesterModule = Get-Module -Name Pester
    
    $moduleName = 'Autotask'
    $RootPath = 'C:\Git\Autotask'
    $modulePath = '{0}\{1}' -F $RootPath, $ModuleName

    if (-not $Global:Credential -or -not $Global:TI) {
        [pscredential]$Global:Credential = Get-Credential -UserName 'bautomation@ECITSOLUTIONS.no'
        $Global:TI = Read-Host -Prompt 'API TrackingIdentifier'
    }
    
    $Path = Join-Path (Split-Path -Path $profile -Parent) -ChildPath 'AtwsConfig.clixml'
    if (Test-Path $Path ) {
        $Path | rm
    }
}
<#
    TOdos
    TODO: New-AtwsAttachment. Mime errors, psversion tester
#>

Describe "Pester 5.1 Module Requirement" {
    Context "Pester module is installed" {
        # BeforeAll {
        #     Import-Module Pester -RequiredVersion 5.1.0 -ErrorAction Stop
        # }

        It "It exports cmdlets" {
            $PesterModule.ExportedCommands.count | Should -BeGreaterThan 10
        }

        It "It is Loaded" {
            $PesterModule.Name | Should -Be 'Pester'
        }
    }
}

Describe "Autotask module is importable" {
    Context "Autotask module is importable" {
        BeforeAll{
            Import-Module $modulePath -Force -ErrorAction Stop
            $loadedModule = Get-Module $moduleName
        }

        It "Is exported with expected Name" {
            $loadedModule.Name | Should -Be $moduleName
        }
        It "Has a great amount of cmdLets exported" {
            $loadedModule.ExportedCommands.count | Should -BeGreaterThan 400
        }
        It "Should have beta 003 cmdlets" {
            $loadedModule.ExportedCommands.ContainsKey('Save-AtwsModuleConfiguration') | Should -Be $true
            $loadedModule.ExportedCommands.ContainsKey('Set-AtwsModuleConfiguration') | Should -Be $true
        }
    }
}

Describe "Module connects properly" {
    Context "Config File does not exist" {
        BeforeAll{
            $Path = $(Join-Path -Path $(Split-Path -Parent $global:profile) -ChildPath AtwsConfig.clixml)
        }
        It "Config File Should Not Exist. Delete or remove for this test context." {
            $Path | Should -Not -Exist
        }
    }
    Context "Connects ok with Parameters ParameterSet" {
        BeforeEach{
            Import-Module $modulePath -Force -ErrorAction Stop
            $loadedModule = Get-Module $moduleName
        }
        It "Does not throw" {
            {Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $TI} | Should -not -Throw
        }
    }
    Context "Connects ok without any parameters and config file." {
        BeforeEach{
            Import-Module $modulePath -Force -ErrorAction Stop
            $loadedModule = Get-Module $moduleName

            
            $Path = $(Join-Path -Path $(Split-Path -Parent $global:profile) -ChildPath AtwsConfig.clixml)
            
            Mock Get-Item { Throw [System.Management.Automation.ItemNotFoundException]::new('Item Not Found Mock') }
            Mock Get-Content { Throw [System.Management.Automation.ItemNotFoundException]::new('Item Not Found Mock') }
        }
        It "Connect-AtwsWebAPI does not throw" {
            # Write-Host "input not working credentials / TI" -ForegroundColor Red
            { Connect-AtwsWebAPI } | Should -Throw
        }
        It "Get-Item Does Throw" {
            { Get-Item -Path $Path } | Should -Throw
        }
    }
}

Describe "Save-AtwsModuleConfig" {
    Context "Save, import and test default config" {
        BeforeEach{
            $Path = $(Join-Path -Path $(Split-Path -Parent $profile) -ChildPath AtwsConfig.clixml)
            $File = Get-Content -Path $Path -ErrorAction SilentlyContinue

            Import-Module $modulePath -Force -ErrorAction Stop
            $loadedModule = Get-Module $moduleName
        }
        It "Does not throw" {
            { Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $TI } | Should -Not -Throw
            { Save-AtwsModuleConfiguration } | Should -Not -Throw
        }
        It "Path resolves to existing item" {
            $Path | Should -Exist
        }
        It "Default - ContentIsImportable" {
            {Get-Content -Path $Path} | Should -Not -Throw
            { Import-Clixml -Path $Path } | Should -Not -Throw
        }
        It "Default - is a valid Configuration" {
            $Settings = Import-Clixml -Path $Path
            $Settings | Should -Not -BeNullOrEmpty
            Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $TI
            
            #Imports function to test moduleconfiguration.
            . (Join-Path $loadedModule.ModuleBase -ChildPath 'private\Test-AtwsModuleConfiguration.ps1')
            
            { Test-AtwsModuleConfiguration -Configuration $Settings.Default } | Should -Not -Throw
            $result = Test-AtwsModuleConfiguration -Configuration $Settings.Default
            $result | Should -Be $true
        }
    }
    Context "Multiple Configs" {
        BeforeEach{
            $Path = $(Join-Path -Path $(Split-Path -Parent $profile) -ChildPath AtwsConfig.clixml)
            $Settings = Import-Clixml -Path $Path
            $OldSettings = $Settings.psobject.Copy()
            $OldCliXMLFiles = Get-ChildItem -Path $(Split-Path -Parent $profile) -Filter '*.clixml'

            Import-Module $modulePath -Force -ErrorAction Stop
            $loadedModule = Get-Module $moduleName
        }
        It "BeforeEach validation" {
            $Path | Should -Exist
            $Settings.Default | Should -Not -BeNullOrEmpty
        }
        It "Contains same amount of Profiles" {
            $OldSettings.Keys.Count | Should -BeExactly $OldSettings.Keys.Count
        }
        It "Does not throw to add another settings" {
            $NewSettings = $OldSettings.psobject.Copy()
            $OldSettings.Keys.Count | Should -Be 1
            $NewSettings.Keys.Count | Should -Be 1

            { Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $TI } | Should -Not -Throw

            #Increases Error Limit with one from default.
            # {Set-AtwsModuleConfiguration -ErrorLimit ($OldSettings.Default.ErrorLimit + 1)} | Should -Not -Throw
            
            #Changes username to sandbox
            $NewSettings = @{}
            $NewSettings.UserName = 'bautomation@ECITSOLUTIONSSB12032021.NO'
            $NewSettings.SecurePassword = $Settings.Default.SecurePassword
            $NewSettings.SecureTrackingIdentifier = $Settings.Default.SecureTrackingIdentifier
            $NewSettings.ConvertPicklistIdToLabel = $Settings.Default.ConvertPicklistIdToLabel
            $NewSettings.Prefix = $Settings.Default.Prefix
            $NewSettings.RefreshCache = $Settings.Default.RefreshCache
            $NewSettings.DebugPref = $Settings.Default.DebugPref
            $NewSettings.VerbosePref = $Settings.Default.VerbosePref
            $NewSettings.ErrorLimit = $Settings.Default.ErrorLimit
            $NewConfig = @{}
            $NewConfig.SandboxTests = $NewSettings
            
            #Imports function to test moduleconfiguration.
            . (Join-Path $loadedModule.ModuleBase -ChildPath 'private\Test-AtwsModuleConfiguration.ps1')

            { Test-AtwsModuleConfiguration -Configuration $NewConfig } | Should -Not -Throw
            { Set-AtwsModuleConfiguration -Username 'bautomation@ECITSOLUTIONSSB12032021.NO' } | Should -Not -Throw
            #Creates new profile, Sandbox
            { Save-AtwsModuleConfiguration -Name 'SandboxTests' } | Should -Not -Throw
        }
        It "Hastable contains saved configName" {
            $Settings = Import-Clixml -Path $Path
            $Settings.SandboxTests | Should -Not -BeNullOrEmpty
            $Settings.SandboxTests.ErrorLimit | Should -Be ($Settings.Default.ErrorLimit + 1)
        }
        It "FileCount has not increased after profile creation." {
            $NewCliXMLFiles = Get-ChildItem -Path $(Split-Path -Parent $profile) -Filter '*.clixml'
            $OldCliXMLFiles.Count | Should -Be $NewCliXMLFiles.Count
        }

        It "NewProfile is valid config" {
            #Imports function to test moduleconfiguration.
            . (Join-Path $loadedModule.ModuleBase -ChildPath 'private\Test-AtwsModuleConfiguration.ps1')

            $Settings = Import-Clixml -Path $Path
            { Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $TI } | Should -Not -Throw
            { Test-AtwsModuleConfiguration $Settings.SandboxTests } | Should -Not -Throw
        }

        It "Removes Created test profile" {
            $NewSettings = Import-Clixml -Path $Path
            $Settings = @{}
            $NewSettings.GetEnumerator() | Where-Object { $_.Key -ne 'SandboxTests' } | ForEach-Object {
                $Settings.$($_.Key) = $_.Value
            }
            $Settings | Export-Clixml -Path $Path
        }
    }
}