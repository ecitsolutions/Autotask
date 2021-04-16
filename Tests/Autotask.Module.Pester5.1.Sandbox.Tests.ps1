

BeforeAll {
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
}
<#
    TOdos
    TODO: New-AtwsAttachment. Mime errors, psversion tester in module scope.
#>

Describe "Pester 5.1 Module Requirement" {
    Context "Pester module is installed" {
        It "It exports cmdlets" {
            $PesterModule.ExportedCommands.count | Should -BeGreaterThan 10
        }
        It "It is Loaded" {
            $PesterModule.Name | Should -Be 'Pester'
        }
    }
}

Describe "Autotask immediate import tests" {
    Context "Autotask module is importable with commands" {
        BeforeAll {
            Import-Module $modulePath -Force -ErrorAction Stop
            $loadedModule = Get-Module $moduleName
        }

        It "Is exported with expected Name" {
            $loadedModule.Name | Should -Be $moduleName
        }
        It "Has a great amount of cmdLets exported" {
            $loadedModule.ExportedCommands.count | Should -BeGreaterThan 400
        }
        It "Should have all ModuleConfiguration CMDLets" {
            $loadedModule.ExportedCommands.ContainsKey('Save-AtwsModuleConfiguration') | Should -Be $true
            $loadedModule.ExportedCommands.ContainsKey('Set-AtwsModuleConfiguration') | Should -Be $true
            $loadedModule.ExportedCommands.ContainsKey('Get-AtwsModuleConfiguration') | Should -Be $true
            $loadedModule.ExportedCommands.ContainsKey('New-AtwsModuleConfiguration') | Should -Be $true
        }
    }
}

Describe "Autotask module connects ok when passing credential parameters (legacy connection)" {
    BeforeEach {
        Import-Module $modulePath -Force -ErrorAction Stop
        $loadedModule = Get-Module $moduleName
    }
    Context "Legacy connection works" {
        It "Should not throw" {
            { Connect-AtwsWebAPI -Credential $Global:Credential -ApiTrackingIdentifier $Global:TI } | Should -not -Throw
        }
        It "Does return useful value and type" {
            Connect-AtwsWebAPI -Credential $Global:Credential -ApiTrackingIdentifier $Global:TI
            $Req = Get-AtwsAccount -id 0
            $Req | Should -BeOfType [Autotask.Account]
            $Req.AccountName.Length | Should -BeGreaterThan 5
        }
    }
}

Describe "Get-, Set-, New-, Save-, and Remove-AtwsModuleConfiguration Tests" {
    BeforeEach {
        Import-Module $modulePath -Force -ErrorAction Stop
        $loadedModule = Get-Module $moduleName
    }
    Context "New-, Save-, and import and test default config" {

        It "Get-AtwsModuleConfiguration should return config even if we are not connected." {
            { Get-AtwsModuleConfiguration -Name Default } | Should -Not -Throw
            { Get-AtwsModuleConfiguration } | Should -Not -Throw
            Get-AtwsModuleConfiguration | Should -Not -BeNullOrEmpty
            Get-AtwsModuleConfiguration -Name Default | Should -Not -BeNullOrEmpty
        }

        It "New-AtwsModuleConfiguration should work config even if we are not connected." {
            { New-AtwsModuleConfiguration -Credential $Global:SandboxCredential -SecureTrackingIdentifier $Global:SecureTI -ErrorLimit 20 } | Should -Not -Throw
            $ModuleConfig = New-AtwsModuleConfiguration -Credential $Global:SandboxCredential -SecureTrackingIdentifier $Global:SecureTI -ErrorLimit 20 
            $ModuleConfig | Should -Not -BeNullOrEmpty
            ($ModuleConfig.psobject.Properties).Name | Should -HaveCount 9
        }

        It "New-AtwsModuleConfiguration is able to save to default config filepath." {
            $ModuleConfig = New-AtwsModuleConfiguration -Credential $Global:SandboxCredential -SecureTrackingIdentifier $Global:SecureTI -ErrorLimit 20 
            $ModuleConfig | Should -Not -BeNullOrEmpty
            { Save-AtwsModuleConfiguration -Configuration $ModuleConfig -Name 'PesterTempConfig' } | Should -Not -Throw
            $settings = Import-Clixml -Path $(Join-Path (Split-Path -Path $profile -Parent) -ChildPath 'AtwsConfig.clixml')
            $settings.Keys | Should -Contain 'PesterTempConfig'
        }

        It "New Profile is a valid atwsconfiguration" {
            $Config = Get-AtwsModuleConfiguration -Name 'PesterTempConfig'
            #Imports function to test moduleconfiguration.
            . (Join-Path $loadedModule.ModuleBase -ChildPath 'private\Test-AtwsModuleConfiguration.ps1')
            $result = Test-AtwsModuleConfiguration -Configuration $Config
            $result | Should -Be $true
        }

        It "Remove-AtwsModuleConfiguration is able to delete configuration." {
            $settings = Import-Clixml -Path $(Join-Path (Split-Path -Path $profile -Parent) -ChildPath 'AtwsConfig.clixml')
            $OldProfiles = $settings.Keys
            { Remove-AtwsModuleConfiguration -Name 'PesterTempConfig' -Confirm:$false } | Should -Not -Throw
            $settings = Import-Clixml -Path $(Join-Path (Split-Path -Path $profile -Parent) -ChildPath 'AtwsConfig.clixml')
            $OldProfiles.where{ $_ -notin $settings.Keys } | Should -Be 'PesterTempConfig'
        }

        It "New-AtwsModuleConfiguration creates new config profile file in user directory if -Path is any other than default." {
            $ModuleConfig = New-AtwsModuleConfiguration -Credential $Global:SandboxCredential -SecureTrackingIdentifier $Global:SecureTI -ErrorLimit 20 
            $ModuleConfig | Should -Not -BeNullOrEmpty
            Save-AtwsModuleConfiguration -Configuration $ModuleConfig -Path $PesterConfigPath -Name 'PesterTempConfig'
            $PesterConfigPath | Should -Exist
            $settings = Import-Clixml -Path $PesterConfigPath
            $settings.Keys | Should -Contain 'PesterTempConfig'
            Remove-AtwsModuleConfiguration -Path $PesterConfigPath -Name Default -Confirm:$false -ErrorAction SilentlyContinue
            Remove-AtwsModuleConfiguration -Path $PesterConfigPath -Name Pester -Confirm:$false -ErrorAction SilentlyContinue
        }

        It "Get-AtwsModuleConfiguration works when indexing two different paths." {
            $Config = Get-AtwsModuleConfiguration -Path $PesterConfigPath -Name PesterTempConfig
            { Test-AtwsModuleConfiguration -Configuration $Config } | Should -Be $true
        }

        It "Querying autotask account returns correct temp profile connection expected result." {
            Connect-AtwsWebAPI -AtwsModuleConfigurationPath $PesterConfigPath -AtwsModuleConfigurationName 'PesterTempConfig'
            $Acc = Get-AtwsAccount -id 0
            $Acc | Should -BeOfType [Autotask.Account]
            $Acc.AccountName | Should -BeExactly 'ECIT Solutions AS Sandbox'
        }

        It "Set-AtwsModuleConfiguration changes connectionObject" {
            $Conn = Get-AtwsConnectionObject -Confirm:$false
            
            Set-AtwsModuleConfiguration -ErrorLimit ($Conn.Configuration.ErrorLimit + 1 )

            $NewConn = Get-AtwsConnectionObject -Confirm:$false
            
            $NewConn.Configuration.ErrorLimit | Should -BeGreaterThan $Conn.Configuration.ErrorLimit
        }
        
        # It "Get-AtwsModuleConfig with -Name value not currently existing, will promt for credentials." {
        #     # It asks user for credentials. Check on parameterSet?
        # }
    }

    Context "If whole test was run, restore config file" {
        BeforeEach {
            if (Test-Path $PesterConfigPath) {
                Remove-Item $PesterConfigPath
            }
        }
        It "is true" {
            $true | Should -Be $true
        }
    }

    Context "Trying to throw." {
        It "Throws when using profileName that does not exist" {
            { Connect-AtwsWebAPI -ProfileName 'jkhlaghdfgbsdfgjkhbkjhdsbfg' } | Should -Throw
        }

        It "Throws when using a path that does not exist" {
            { Connect-AtwsWebAPI -ProfileName 'jkhlaghdfgbsdfgjkhbkjhdsbfg' -AtwsModuleConfigurationPath $PesterConfigPath } | Should -Throw
        }
    }

    Context "Default profile" {
        It "Retrieves our accountName with default profile" {
            { $Null = Get-AtwsAccount -id 0 } | Should -Not -Throw
            Get-AtwsAccount -id 0 | Select-Object -ExpandProperty AccountName | Should -BeExactly 'ECIT CLOUD'
        }
    }
}

Describe "UserDefinedField tests" {
    BeforeEach {
        Import-Module $modulePath -Force -ErrorAction Stop
        $loadedModule = Get-Module $moduleName
    }
    Context "this needs to be addressed" {
        It "Should not throw." {
            $Config = New-AtwsModuleConfiguration -Credential $Global:SandboxCredential -SecureTrackingIdentifier $Global:SecureTI -ErrorLimit 20
            { Connect-AtwsWebAPI -AtwsModuleConfiguration $Config } | Should -Not -Throw
        }
    }
}

#Region ########### TESTS THAT FAILS ################

Describe "UserDefinedField tests" {
    BeforeEach{
        Import-Module $modulePath -Force -ErrorAction Stop
        $loadedModule = Get-Module $moduleName
    }
    Context "UDF Properties are expanded from its hastable." {
        It "Has properties with name like '#'" {
            $Config = New-AtwsModuleConfiguration -Credential $Global:SandboxCredential -SecureTrackingIdentifier $Global:SecureTI -ErrorLimit 20
            
            Connect-AtwsWebAPI -AtwsModuleConfigurationName Pester

            $Products = Get-AtwsInstalledProduct -Type Firewall
            $cont = $false
            $Products[0].psobject.Properties.name.ForEach{
                if ($_ -match '#') {
                    $cont = $true
                }
            }
            $cont | Should -Be $true

        }
    }

    Context "Can update 500+ UDF values" {
        BeforeEach{
            Import-Module $modulePath -Force -ErrorAction Stop
            $loadedModule = Get-Module $moduleName
        }
        It "Should get a big number of devices" {
            $Devices = Get-AtwsInstalledProduct -Type Server -Active $true
            $Devices.Count | Should -BeGreaterThan 600

            { Set-AtwsInstalledProduct -InputObject $Devices -UserDefinedFields @{Name = 'Sist logget inn'; Value = 'Pester UDF test var her.' } } | Should -Not -Throw
            
            { Set-AtwsInstalledProduct -InputObject $Devices } | Should -Not -Throw

            $AfterModifications = Get-AtwsInstalledProduct -id $Devices.id

            # TODO: UseCase: now restore old data. Should be able to run Set-AtwsInstalledProduct -InputObject $Devices right?
        }
    }
}

Describe "Know Issues in 1.6.14" {
    BeforeEach{
        Import-Module $modulePath -Force -ErrorAction Stop
        $loadedModule = Get-Module $moduleName
    }
    Context "SQL Query nested too deep error" {
        
        It "Does not throw when inputting 1000 ids to cmdlets" {
            
            $Products = { Get-AtwsInstalledProduct -Type Workstation -Active $true } | Should -Not -Throw -PassThru
            $Products = Get-AtwsInstalledProduct -Type Workstation -Active $true
            $Products.Count | Should -BeGreaterThan 4000
            
            { $Req = Get-AtwsInstalledProduct -id $Products.id[0..1550] } | Should -Not -Throw
        }
    }
}

#EndRegion

#TODO: InModuleScope tests for the module?