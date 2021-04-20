

BeforeAll {
    Import-Module Pester  -ErrorAction Stop
    $PesterModule = Get-Module -Name Pester
    
    $moduleName = 'Autotask'
    $RootPath = $(Split-Path -Parent -Path (Split-Path -Parent -Path $PSCommandPath))
    $modulePath = '{0}\{1}' -F $RootPath, $ModuleName
    $SandBoxDomain = '@ECITSOLUTIONSSB12032021.NO'
    $RunGUID = New-Guid

    #Region Vars
    if (-not $Global:Credential -or -not $Global:TI) {
        Write-Warning "Running pester tests based on Pester config."
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
 
    if ($profile) {
        # Use $profile if it exsist
        $AtwsModuleConfigurationPath = $(Join-Path -Path $(Split-Path -Parent $profile) -ChildPath AtwsConfig.clixml)
    }
    elseIf ($env:TEMP) {
        # Use $temp. The file will most likely never be used if not on desktop anyway
        $AtwsModuleConfigurationPath = $(Join-Path -Path $env:TEMP -ChildPath AtwsConfig.clixml)
    }
    elseIf ($env:TMPDIR) {
        # Use $temp. The file will most likely never be used if not on desktop anyway
        $AtwsModuleConfigurationPath = $(Join-Path -Path $env:TMPDIR -ChildPath AtwsConfig.clixml)
    }
    else {
        # Use $temp. The file will most likely never be used if not on desktop anyway
        $AtwsModuleConfigurationPath = $(Join-Path -Path $env:PWD -ChildPath AtwsConfig.clixml)
    }

    #EndRegion

    $PesterConfigPath = Join-Path (Split-Path -Path $profile -Parent) -ChildPath 'AtwsPesterConfig.clixml'
    if (Test-Path $PesterConfigPath) {
        Remove-Item $PesterConfigPath
    }

    Import-Module $modulePath -Force -ErrorAction Stop
    $loadedModule = Get-Module $moduleName
    
    $PesterModuleConfig = Get-AtwsModuleConfiguration -Name Sandbox
    Connect-AtwsWebAPI -ProfileName Sandbox

    #Modifies default config to be sandbox
    $DefaultModuleConfig = Get-AtwsModuleConfiguration -Name Default
    Save-AtwsModuleConfiguration -Configuration $PesterModuleConfig -Name Default
}

AfterAll{
    #Reverts default config back to prod
    Save-AtwsModuleConfiguration -Configuration $DefaultModuleConfig -Name Default
}

<#
    Todos / Tests to add.
    TODO: New-AtwsAttachment. Mime errors, psversion tester in module scope.
    TODO: Tests for picklist id as parameter values
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
    Context "Legacy connection works" {
        It "Should not throw" {
            { Connect-AtwsWebAPI -Credential $Global:SandboxCredential -ApiTrackingIdentifier $Global:TI } | Should -not -Throw
        }
        It "Does return useful value and type" {
            Connect-AtwsWebAPI -Credential $Global:SandboxCredential -ApiTrackingIdentifier $Global:TI
            $Req = Get-AtwsAccount -id 0
            $Req | Should -BeOfType [Autotask.Account]
            $Req.AccountName.Length | Should -BeGreaterThan 5
        }
    }
}

Describe "Get-, Set-, New-, Save-, and Remove-AtwsModuleConfiguration Tests" {
    # Clean up
    AfterAll {
        if (Test-Path $PesterConfigPath) {
            Remove-Item $PesterConfigPath
        }
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
            ($ModuleConfig.psobject.Properties).Name | Should -HaveCount 12
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
        }

        It "Get-AtwsModuleConfiguration works when indexing two different paths." {
            $Config = Get-AtwsModuleConfiguration -Path $PesterConfigPath -Name PesterTempConfig
            { Test-AtwsModuleConfiguration -Configuration $Config } | Should -Be $true
        }

        It "Querying autotask account returns correct temp profile connection expected result." {
            Connect-AtwsWebAPI -ProfilePath $PesterConfigPath -ProfileName 'PesterTempConfig'
            $Acc = Get-AtwsAccount -id 0
            $Acc | Should -BeOfType [Autotask.Account]
            $Acc.AccountName | Should -BeExactly 'ECIT Solutions AS Sandbox'
        }

        It "Set-AtwsModuleConfiguration changes connectionObject" {
            $Conn = Get-AtwsConnectionObject -Confirm:$false
            $oldErrorlimit = $Conn.Configuration.ErrorLimit
            
            Set-AtwsModuleConfiguration -ErrorLimit ($Conn.Configuration.ErrorLimit + 1 )
            
            $Conn.Configuration.ErrorLimit | Should -BeGreaterThan $oldErrorlimit
        }
        
        # It "Get-AtwsModuleConfig with -Name value not currently existing, will promt for credentials." {
        #     # It asks user for credentials. Check on parameterSet?
        # }
    }

    Context "Trying to throw." {
        It "Throws when using profileName that does not exist" {
            { Connect-AtwsWebAPI -ProfileName 'jkhlaghdfgbsdfgjkhbkjhdsbfg' } | Should -Throw
        }

        #TODO: Should this throw now?
        # It "Throws when using a path that does not exist" {
        #     { Connect-AtwsWebAPI -ProfilePath $PesterConfigPath } | Should -Throw
        # }
    }

    Context "Default profile" {
        It "Retrieves our accountName with default profile" {
            { $Null = Get-AtwsAccount -id 0 } | Should -Not -Throw
            # Get-AtwsAccount -id 0 | Select-Object -ExpandProperty AccountName | Should -BeExactly 'ECIT Solutions AS Sandbox'
        }
    }
}

Describe "Connect using connection object" {

    It "Should not throw." {
        $Config = New-AtwsModuleConfiguration -Credential $Global:SandboxCredential -SecureTrackingIdentifier $Global:SecureTI -ErrorLimit 20
        { Connect-AtwsWebAPI -AtwsModuleConfiguration $Config } | Should -Not -Throw
        $Acc = Get-AtwsAccount -id 0
        $Acc | Should -BeOfType [Autotask.Account]
        $Acc.AccountName | Should -BeExactly 'ECIT Solutions AS Sandbox'
    }
}

Describe "Auto connect works on most get commands." {
    BeforeAll {
        Import-Module $modulePath -Force -ErrorAction Stop
        $loadedModule = Get-Module $moduleName
        $GetCmdLets = 'Get-AtwsAccount', 'Get-AtwsAccountLocation', 'Get-AtwsAccountNote', 'Get-AtwsAccountPhysicalLocation', 'Get-AtwsAccountTeam', 'Get-AtwsAccountToDo', 'Get-AtwsActionType', 'Get-AtwsAdditionalInvoiceFieldValue', 'Get-AtwsAllocationCode', 'Get-AtwsAppointment', 'Get-AtwsAttachmentInfo', 'Get-AtwsBillingItem', 'Get-AtwsBillingItemApprovalLevel', 'Get-AtwsBusinessDivision', 'Get-AtwsBusinessDivisionSubdivision', 'Get-AtwsBusinessDivisionSubdivisionResource', 'Get-AtwsBusinessLocation', 'Get-AtwsBusinessSubdivision', 'Get-AtwsChangeOrderCost'
    }
    Context "Get-Commands should be able to autoconnect without cmdlet throwing" -ForEach $GetCmdLets {
        It "(<_>) does not throw when calling command with id 0" {
            $loadedModule.ExportedCommands.Keys | Should -Contain $_
            { &$_ -id 0 } | Should -Not -Throw
        }
    }
}

Describe "Returned Autotask error messages are exceptions" {
    Context "Be sure we get an exception, not write error/host" {
        It "Throws" {
            { Get-AtwsInventoryLocation -id 0 } | Should -Throw
        }
    }
}

Describe "UserDefinedField tests" {
    Context "UDF Properties are expanded from its array." {
        It "Has properties with name like '#'" {
            
            $Products = Get-AtwsInstalledProduct -Type Firewall
            $Products[0].psobject.Properties.where{ $_.Name -match '#' }.Count | Should -BeGreaterThan 40
        }
    }

    Context "Can update 500+ UDF values" {
        BeforeAll{
            Import-Module $modulePath -Force -ErrorAction Stop
            $loadedModule = Get-Module $moduleName

            # Disable UDF and picklist expansion - saves a lot of time!
            Set-AtwsModuleConfiguration -PickListExpansion Disabled -UdfExpansion Disabled

            $Devices = Get-AtwsInstalledProduct -Type Server -Active $true
        }
        It "Should get a big number of devices" {
            $Devices.Count | Should -BeGreaterThan 900

            { Set-AtwsInstalledProduct -InputObject $Devices -UserDefinedFields @{Name = 'Sist logget inn'; Value = $RunGUID } } | Should -Not -Throw
            # TODO: UseCase: now restore old data. Should be able to run Set-AtwsInstalledProduct -InputObject $Devices right? Maybe Not. Group updating on old values are needed.
        }

        It "Values are updated and returnable with correct new values" {
            # Enable UDF expansion, need it for group-object
            Set-AtwsModuleConfiguration -UdfExpansion Inline
            $Req = Get-AtwsInstalledProduct -Type Server -Active $true
            $NewValues = $Req | Group-Object '#Sist logget inn' | Select-Object -ExpandProperty Name
            $NewValues | Should -HaveCount 1
            $NewValues | Should -BeExactly $RunGUID
        }

        It "Reverts back to previous values" -Foreach ($Devices | Group-Object '#Sist logget inn') {
            { Set-AtwsInstalledProduct -InputObject $_.Group -UserDefinedFields @{Name = 'Sist logget inn' ; Value = $_.Name } } | Should -Not -Throw
        }
    }
}

Describe "SQL Query nested too deep error" {
    BeforeEach{
        Import-Module $modulePath -Force -ErrorAction Stop
        $loadedModule = Get-Module $moduleName

        # Disable UDF and picklist expansion
        Set-AtwsModuleConfiguration -PickListExpansion Disabled -UdfExpansion Disabled -DateConversion Disabled
    }
    Context "Does not throw when inputting 1000 ids to cmdlets" {
        
        BeforeAll {
            $Products = Get-AtwsInstalledProduct -Type Server -Active $true
        }

        It "Should get 800+ objects" {
            $Products.Count | Should -BeGreaterThan 800
        }

        It "Should accept 800+ Ids as input and return the correct number of objects" { 
            # This should work even if there are multiple parameters and the ID parameter is not the first or last
            $Req = Get-AtwsInstalledProduct -Type Server -id $Products.id -Active $true
            $Req.count | Should -Be $Products.count
        }
    }
}

Describe "Parameter value can be LabelID and LabelTekst" {
    Context "LabelID and LabelText can be sent to ticket" {
        
        It "ItName" {
            { New-AtwsTicket -IssueType Network/Firewall/AP -AccountID 0 -Priority Medium -Status New -Title 'Pester Test Slett meg' -QueueID 'DevOps | Development | Utvikling' } | Should -Not -Throw
            { New-AtwsTicket -IssueType 24 -AccountID 0 -Priority Medium -Status New -Title 'Pester Test Slett meg' -QueueID 'DevOps | Development | Utvikling' } | Should -Not -Throw
        }
    }
}

Describe "Static Function tests" {
    Context "New-AtwsAttachment" {
        It "is exported" {
            $loadedmodule.ExportedCommands.ContainsKey('New-AtwsAttachment') | Should -Be $true
            $loadedmodule.ExportedCommands.ContainsKey('Get-AtwsAttachment') | Should -Be $true
            $loadedmodule.ExportedCommands.ContainsKey('Remove-AtwsAttachment') | Should -Be $true
        }
        It "Creating new does not throw" {
            $Ticket = New-AtwsTicket -IssueType 24 -AccountID 0 -Priority Medium -Status New -Title 'Pester Test Slett meg' -QueueID 'DevOps | Development | Utvikling'
            $Data = @{Name='hello';Value='world'}
            $p = (Join-Path (Split-Path $AtwsModuleConfigurationPath -Parent) -ChildPath "$RunGUID`_tempdata.exlx")
            $Data | Export-Excel $p
            $Return = New-AtwsAttachment -TicketID $Ticket.id -Path $p
            $Return | Should -Not -BeNullOrEmpty

        }
        It "Can Get without throwing, also returns multiple attachments if applicable." {
            $Ticket = New-AtwsTicket -IssueType 24 -AccountID 0 -Priority Medium -Status New -Title 'Pester Test Slett meg' -QueueID 'DevOps | Development | Utvikling'
            $Data = @{Name = 'hello'; Value = 'world' }
            $p = (Join-Path (Split-Path $AtwsModuleConfigurationPath -Parent) -ChildPath "$RunGUID`_tempdata.exlx")
            $Data | Export-Excel $p
            $Return = New-AtwsAttachment -TicketID $Ticket.id -Path $p
            $Return = New-AtwsAttachment -TicketID $Ticket.id -Path $p
            $Return | Should -Not -BeNullOrEmpty
            Get-AtwsAttachment -TicketID $Ticket.id
        }
        It "Can remove created attachment" {
            $Ticket = New-AtwsTicket -IssueType 24 -AccountID 0 -Priority Medium -Status New -Title 'Pester Test Slett meg' -QueueID 'DevOps | Development | Utvikling'
            $Attachments = Get-AtwsAttachment -TicketID $Ticket.id
            { Remove-AtwsAttachment -id $Attachments.Info[0].id } | Should -Not -Throw
        }
    }
}

Describe "InvoiceInfo function tests" {
    Context "Invoice Info tests" {
        It "Get-AtwsInvoiceInfo does value" {
            $Invoice = Get-AtwsInvoice -BatchID 1

            $InvoiceInfo = Get-AtwsInvoiceInfo -InvoiceId $Invoice[0].id
            $InvoiceInfo | Should -Not -BeNullOrEmpty
        }
    }
}

Describe "Threshold and usage info" {
    Context "Get-AtwsThresholdAndUsageInfo" {
        It "Does not throw" {
            { Get-AtwsThresholdAndUsageInfo } | Should -Not -Throw
        }
    }
}

#Region ########### TESTS THAT FAILS ################
# There are no failing tests atm.
#EndRegion
#TODO: InModuleScope tests for the module?