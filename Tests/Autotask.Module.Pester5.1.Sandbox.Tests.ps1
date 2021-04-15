

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
    TODO: New-AtwsAttachment. Mime errors, psversion tester
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
    Context "New-, Save-, and import and test default config" {
        BeforeEach {
            Import-Module $modulePath -Force -ErrorAction Stop
            $loadedModule = Get-Module $moduleName
        }

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
            $settings = Import-Clixml -Path $PesterConfigPath
            $settings.Keys | Should -Contain 'PesterTempConfig'
            Remove-AtwsModuleConfiguration -Path $PesterConfigPath -Name Default -Confirm:$false -ErrorAction SilentlyContinue
            Remove-AtwsModuleConfiguration -Path $PesterConfigPath -Name Pester -Confirm:$false -ErrorAction SilentlyContinue
        }

        It "Get-AtwsModuleConfiguration works when indexing two different paths." {
            $Config = Get-AtwsModuleConfiguration -Path $PesterConfigPath -Name PesterTempConfig
            { Test-AtwsModuleConfiguration -Configuration $Config } | Should -Be $true
        }

        # It "Get-AtwsModuleConfig with -Name value not currently existing, will promt for credentials." {
        #     # It asks user for credentials. Check on parameterSet?
        # }
        
    }

    # Context "Multiple Configs" {
    #     BeforeEach{
    #         $Path = $(Join-Path -Path $(Split-Path -Parent $profile) -ChildPath AtwsPesterConfig.clixml)
    #         $Settings = Import-Clixml -Path $Path
    #         $OldSettings = $Settings.psobject.Copy()
    #         $OldCliXMLFiles = Get-ChildItem -Path $(Split-Path -Parent $profile) -Filter '*.clixml'

    #         Import-Module $modulePath -Force -ErrorAction Stop
    #         $loadedModule = Get-Module $moduleName
    #     }
    #     It "BeforeEach validation" {
    #         $Path | Should -Exist
    #         $Settings.Default | Should -Not -BeNullOrEmpty
    #     }
    #     It "Contains same amount of Profiles" {
    #         $OldSettings.Keys.Count | Should -BeExactly $OldSettings.Keys.Count
    #     }
    #     It "Does not throw to add another settings" {
    #         $NewSettings = $OldSettings.psobject.Copy()
    #         $OldSettings.Keys.Count | Should -Be 1
    #         $NewSettings.Keys.Count | Should -Be 1

    #         { Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $TI } | Should -Not -Throw

    #         #Increases Error Limit with one from default.
    #         # {Set-AtwsModuleConfiguration -ErrorLimit ($OldSettings.Default.ErrorLimit + 1)} | Should -Not -Throw
            
    #         #Changes username to sandbox
    #         $NewSettings = @{}
    #         $NewSettings.UserName = 'bautomation@ECITSOLUTIONSSB12032021.NO'
    #         $NewSettings.SecurePassword = $Settings.Default.SecurePassword
    #         $NewSettings.SecureTrackingIdentifier = $Settings.Default.SecureTrackingIdentifier
    #         $NewSettings.ConvertPicklistIdToLabel = $Settings.Default.ConvertPicklistIdToLabel
    #         $NewSettings.Prefix = $Settings.Default.Prefix
    #         $NewSettings.RefreshCache = $Settings.Default.RefreshCache
    #         $NewSettings.DebugPref = $Settings.Default.DebugPref
    #         $NewSettings.VerbosePref = $Settings.Default.VerbosePref
    #         $NewSettings.ErrorLimit = $Settings.Default.ErrorLimit
    #         $NewConfig = @{}
    #         $NewConfig.Pester = $NewSettings
            
    #         #Imports function to test moduleconfiguration.
    #         . (Join-Path $loadedModule.ModuleBase -ChildPath 'private\Test-AtwsModuleConfiguration.ps1')

    #         { Test-AtwsModuleConfiguration -Configuration $NewConfig } | Should -Not -Throw
    #         { Set-AtwsModuleConfiguration -Username 'bautomation@ECITSOLUTIONSSB12032021.NO' } | Should -Not -Throw
    #         #Creates new profile, Sandbox
    #         { Save-AtwsModuleConfiguration -Name 'Pester' } | Should -Not -Throw
    #     }
    #     It "Hastable contains saved configName" {
    #         $Settings = Import-Clixml -Path $Path
    #         $Settings.Pester | Should -Not -BeNullOrEmpty
    #         # $Settings.Pester.ErrorLimit | Should -Be ($Settings.Default.ErrorLimit + 1)
    #     }
    #     It "FileCount has not increased after profile creation." {
    #         $NewCliXMLFiles = Get-ChildItem -Path $(Split-Path -Parent $profile) -Filter '*.clixml'
    #         $OldCliXMLFiles.Count | Should -Be $NewCliXMLFiles.Count
    #     }

    #     It "NewProfile is valid config" {
    #         #Imports function to test moduleconfiguration.
    #         . (Join-Path $loadedModule.ModuleBase -ChildPath 'private\Test-AtwsModuleConfiguration.ps1')

    #         $Settings = Import-Clixml -Path $Path
    #         { Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $TI } | Should -Not -Throw
    #         { Test-AtwsModuleConfiguration $Settings.Pester } | Should -Not -Throw
    #     }

    #     It "Removes Created test profile" {
    #         $NewSettings = Import-Clixml -Path $Path
    #         $Settings = @{}
    #         $NewSettings.GetEnumerator() | Where-Object { $_.Key -ne 'Pester' } | ForEach-Object {
    #             $Settings.$($_.Key) = $_.Value
    #         }
    #         $Settings | Export-Clixml -Path $Path
    #     }
    # }
}

Describe "Connect to Autotask using stored profiles" {
    BeforeAll {
        $Path = $(Join-Path -Path $(Split-Path -Parent $profile) -ChildPath AtwsPesterConfig.clixml)
        $File = Get-Content -Path $Path -ErrorAction SilentlyContinue

        Import-Module $modulePath -Force -ErrorAction Stop
        $loadedModule = Get-Module $moduleName
    }
    Context "Default profile" {
        BeforeEach {
            $Path = $(Join-Path -Path $(Split-Path -Parent $profile) -ChildPath AtwsPesterConfig.clixml)
            $File = Get-Content -Path $Path -ErrorAction SilentlyContinue

            Import-Module $modulePath -Force -ErrorAction Stop
            $loadedModule = Get-Module $moduleName
        }
        It "Retrieves our accountName with default profile" {
            { $Null = Get-AtwsAccount -id 0 } | Should -Not -Throw
            Get-AtwsAccount -id 0 | Select-Object -ExpandProperty AccountName | Should -BeExactly 'ECIT CLOUD'
        }
    }

    Context "Throws when using profileName that does not exist." {
        It "Retrieves our SandBox AccountName" {
            { Connect-AtwsWebAPI -ProfileName Pester } | Should -Throw
        }
    }

    Context "Throws when using profileName that does not exist." {
        It "Throws when using wrong profileName" {
            { Connect-AtwsWebAPI -ProfileName 'hjkdfgjkhebygabkjh' } | Should -Throw
        }
    }

    Context "Creates missing Pester profile." {
        It "Does not throw whilst creating" {
            Connect-AtwsWebAPI -ProfileName Default
            { Set-AtwsModuleConfiguration -Username 'bautomation@ECITSOLUTIONSSB12032021.NO' -ErrorLimit 20 } | Should -Not -Throw
            Set-AtwsModuleConfiguration -Username 'bautomation@ECITSOLUTIONSSB12032021.NO' -ErrorLimit 20
            { Save-AtwsModuleConfiguration -Name Pester } | Should -Not -Throw
        }
        It "Exists in file after creation" {
            $Path = $(Join-Path -Path $(Split-Path -Parent $profile) -ChildPath AtwsPesterConfig.clixml)
            $Imp = Import-Clixml $Path -ErrorAction SilentlyContinue
            $Imp.ContainsKey('Pester') | Should -Be $true
        }
    }

    Context "With the new profile, it connects successfully." {
        It "Does not throw" {
            { Connect-AtwsWebAPI -ProfileName Pester } | Should -Not -Throw
            Connect-AtwsWebAPI -ProfileName Pester
        }
        It "Returns correct name" {
            Get-AtwsAccount -id 0 | Select-Object -ExpandProperty AccountName | Should -BeExactly 'ECIT Solutions AS Sandbox'
        }
    }
    
    # Just a block, acting as a script block to restore
    Context "If whole test was run, restore config file" {
        BeforeEach {
            $items = Split-Path $profile -Parent | Get-ChildItem -Filter '*pester**.clixml' | Sort-Object LastAccessTime -Descending
            $BeforeContent = Get-Content $items[0].FullName
            if ($items) {
                $items.Delete()
            }
            $Path = Join-Path (Split-Path -Path $profile -Parent) -ChildPath 'AtwsPesterConfig.clixml'
            Set-Content $Path -Value $BeforeContent
        }
        It "is true" {
            $true | Should -Be $true
        }
    }
}

Context "Test bulking of UDF assets with Pester profile" {
    It "ItName" {
        Assertion
    }
}