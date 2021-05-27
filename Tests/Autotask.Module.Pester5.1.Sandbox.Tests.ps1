

BeforeAll {
    Import-Module Pester  -ErrorAction Stop
    $PesterModule = Get-Module -Name Pester
    
    $moduleName = 'Autotask'
    $RootPath = $(Split-Path -Parent -Path (Split-Path -Parent -Path $PSCommandPath))
    $modulePath = '{0}\{1}' -F $RootPath, $ModuleName
    $RunGUID = New-Guid

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

    # Load module 
    Import-Module $modulePath -Force -ErrorAction Stop
    $loadedModule = Get-Module $moduleName

    $PesterModuleConfig = Get-AtwsModuleConfiguration -Name Sandbox
    Connect-AtwsWebAPI -ProfileName Sandbox

    #Region Vars
    if (-not $TI -or -not $SandboxCredential) {
        Write-Warning "Running pester tests based on Pester config."
        try {
            $SandboxCredential = [pscredential]::new($PesterModuleConfig.Username, $PesterModuleConfig.SecurePassword)
            $SecureTI = $PesterModuleConfig.SecureTrackingIdentifier
    
            $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureTI)
            $TI = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($BSTR)
        }
        catch {
            $message = "Cannot read default Sandbox config from configfile for pester tests. set this up before running pester test."
            throw (New-Object System.Configuration.Provider.ProviderException $message)
        }
    }

    #EndRegion

    $PesterConfigPath = Join-Path (Split-Path -Path $profile -Parent) -ChildPath 'AtwsPesterConfig.clixml'
    if (Test-Path $PesterConfigPath) {
        Remove-Item $PesterConfigPath
    }

    #Modifies default config to be sandbox
    $DefaultModuleConfig = Get-AtwsModuleConfiguration -Name Default
    Save-AtwsModuleConfiguration -Configuration $PesterModuleConfig -Name Default
}

AfterAll {
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
            { Connect-AtwsWebAPI -Credential $SandboxCredential -ApiTrackingIdentifier $TI } | Should -Not -Throw
        }
        It "Does return useful value and type" {
            Connect-AtwsWebAPI -Credential $SandboxCredential -ApiTrackingIdentifier $TI
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
            { New-AtwsModuleConfiguration -Credential $SandboxCredential -SecureTrackingIdentifier $SecureTI -ErrorLimit 20 } | Should -Not -Throw
            $ModuleConfig = New-AtwsModuleConfiguration -Credential $SandboxCredential -SecureTrackingIdentifier $SecureTI -ErrorLimit 20 
            $ModuleConfig | Should -Not -BeNullOrEmpty
            ($ModuleConfig.psobject.Properties).Name | Should -HaveCount 12
        }

        It "New-AtwsModuleConfiguration is able to save to default config filepath." {
            $ModuleConfig = New-AtwsModuleConfiguration -Credential $SandboxCredential -SecureTrackingIdentifier $SecureTI -ErrorLimit 20 
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
            $ModuleConfig = New-AtwsModuleConfiguration -Credential $SandboxCredential -SecureTrackingIdentifier $SecureTI -ErrorLimit 20 
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
        $Config = New-AtwsModuleConfiguration -Credential $SandboxCredential -SecureTrackingIdentifier $SecureTI -ErrorLimit 20
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
    Context "Get-Commands should be able to autoconnect without cmdlet throwing" -Foreach $GetCmdLets {
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
        BeforeAll {
            Import-Module $modulePath -Force -ErrorAction Stop
            $loadedModule = Get-Module $moduleName

            # Disable UDF and picklist expansion - saves a lot of time!
            $CurrentConfig = Get-AtwsModuleConfiguration
            Set-AtwsModuleConfiguration -PickListExpansion Disabled -UdfExpansion Disabled

            $Devices = Get-AtwsInstalledProduct -Type Server -Active $true
        }
        AfterAll {
            $CurrentConfig | Set-AtwsModuleConfiguration
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

        It "Reverts back to previous values" -ForEach ($Devices | Group-Object '#Sist logget inn') {
            { Set-AtwsInstalledProduct -InputObject $_.Group -UserDefinedFields @{Name = 'Sist logget inn' ; Value = $_.Name } } | Should -Not -Throw
        }
    }
}

Describe "SQL Query nested too deep error" {
    BeforeAll {
        $CurrentConfig = Get-AtwsModuleConfiguration
    }
    BeforeEach {
        Import-Module $modulePath -Force -ErrorAction Stop
        $loadedModule = Get-Module $moduleName

        # Disable UDF and picklist expansion on in memory config
        Set-AtwsModuleConfiguration -PickListExpansion Disabled -UdfExpansion Disabled -DateConversion Disabled
    }

    AfterAll {
        $CurrentConfig | Set-AtwsModuleConfiguration
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
        
        It "Creating 2 tickets by parameters, one with text label and one with integer id of picklist" {
            { New-AtwsTicket -IssueType Network/Firewall/AP -AccountID 0 -Priority Medium -Status New -Title 'Pester Test Slett meg' -QueueID 'DevOps | Development | Utvikling' } | Should -Not -Throw
            { New-AtwsTicket -IssueType 24 -AccountID 0 -Priority Medium -Status New -Title 'Pester Test Slett meg' -QueueID 'DevOps | Development | Utvikling' } | Should -Not -Throw
        }

        It "Creating a ticket only using picklist ids, no text labels" {
            $ticket_params = @{
                QueueID          = 30273836 #'Operations - Alert Management'
                AccountID        = 29684055
                Title            = "Meraki enheter uten riktig produktkode $((Get-Date).tostring('dd.MM HH:mm'))"
                Description      = ""
                TicketCategory   = 3 #'Standard'
                TicketType       = 5 #'Alert'
                Status           = 1 #'New'
                Priority         = 2 #'Medium'
                ContractID       = '30390790'
                AllocationCodeID = '29682801' #Samme som Work Type i GUI
            }
    
            { $ticket = New-AtwsTicket @ticket_params } | Should -Not -Throw

        }
    }
}

Describe "Static Function tests" {
    Context "New-AtwsAttachment" {
        BeforeAll {
            $Ticket = New-AtwsTicket -IssueType 24 -AccountID 0 -Priority Medium -Status New -Title 'Pester Test Slett meg' -QueueID 'DevOps | Development | Utvikling'
            $p = (Join-Path (Split-Path $AtwsModuleConfigurationPath -Parent) -ChildPath "$RunGUID`_tempdata.xlsx")
        }
        AfterAll {
            Remove-Item -Path $p -Force
        }
        It "is exported" {
            $loadedmodule.ExportedCommands.ContainsKey('New-AtwsAttachment') | Should -Be $true
            $loadedmodule.ExportedCommands.ContainsKey('Get-AtwsAttachment') | Should -Be $true
            $loadedmodule.ExportedCommands.ContainsKey('Remove-AtwsAttachment') | Should -Be $true
        }
        It "Creating new does not throw" {
            $Data = @{Name = 'hello'; Value = 'world' }
            $p = (Join-Path (Split-Path $AtwsModuleConfigurationPath -Parent) -ChildPath "$RunGUID`_tempdata.xlsx")
            $Data | Export-Excel $p
            $Return = New-AtwsAttachment -TicketID $Ticket.id -Path $p
            $Return | Should -Not -BeNullOrEmpty

        }
        It "Can Get without throwing, also returns multiple attachments if applicable." {
            $Data = @{Name = 'hello'; Value = 'world' }
            $Data | Export-Excel $p
            $Return = New-AtwsAttachment -TicketID $Ticket.id -Path $p
            $Return = New-AtwsAttachment -TicketID $Ticket.id -Path $p
            $Return | Should -Not -BeNullOrEmpty
            Get-AtwsAttachment -TicketID $Ticket.id
        }
        It "Can remove created attachment" {
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

Describe "DateTime tests" {

    BeforeAll {
        # Make sure dateconversion is on
        Set-AtwsModuleConfiguration -DateConversion Local
    }

    Context 'RoundTrip - A date returned by the API is encoded correctly when used in a query' {

        It 'should be an account' {
            $account0 = Get-AtwsAccount -id 0
            $account = Get-AtwsAccount -id 0 -CreateDate $account0.CreateDate 
            
            $account | Should -BeOfType Autotask.Account
        }

    } # context 'Module Setup'

    Context 'DateTime' {
        BeforeAll { 
            $resource = Get-AtwsResource -UserType 'Full Access (system)' | Select-Object -First 1 # There should be at least 1
            $startDate = Get-Date 2030.01.01 -Hour 8
            $endDate = Get-Date 2030.12.31 -Hour 16
            $newEndDate = Get-Date 2030.12.01 -Hour 16
            $todoParams = @{
                AccountId            = 0 # Use system account
                AssignedToResourceId = $resource.id
                StartDateTime        = $startDate
                EndDateTime          = $endDate
                ActionType           = 'Quick Note'
            }
        
            $todo = New-AtwsAccountToDo @todoParams
        }

        AfterAll {
            # Clean up
            $todo | Remove-AtwsAccountToDo
        } 

        It 'should have the same dates in the return object as specified' {
            $todo.StartDateTime | Should -Be $startDate
            $todo.EndDateTime | Should -Be $endDate
        }
        
        It 'should only change a modified date' {
            $newTodo = Set-AtwsAccountToDo -InputObject $todo -EndDateTime $newEndDate -PassThru
            $newTodo.StartDateTime | Should -Be $startDate
            $newTodo.EndDateTime | Should -Be $newEndDate
        }
        
        It 'should get an object filtered with the same date as original was created' {
            $getTodo = Get-AtwsAccountToDo -StartDateTime $startDate -id $todo.id
            $getTodo | Should -BeOfType Autotask.AccountTodo
        } 
        
    }

    Context "Test dateconversion code on all options" {
        
        BeforeAll {
            if ($IsWindows) {
                $timezoneid = 'Turkey Standard Time'
            }
            else {
                $timezoneid = 'Europe/Istanbul'
            }
        }

        It "Dateconversion = disabled" {
            Set-AtwsModuleConfiguration -DateConversion Disabled
            $Products = Get-AtwsInstalledProduct -Type Server -Active $true -AccountID 0 | Select-Object -First 30
            $Products.Count | Should -Be 30
            { Set-AtwsInstalledProduct -InputObject $Products -Type Server } | Should -not -Throw
        }

        It "Dateconversion = local" {
            Set-AtwsModuleConfiguration -DateConversion Local
            $Products = Get-AtwsInstalledProduct -Type Server -Active $true -AccountID 0 | Select-Object -First 30
            $Products.Count | Should -Be 30
            { Set-AtwsInstalledProduct -InputObject $Products -Type Server } | Should -Not -Throw
        }

        It "Dateconversion = UTC" {
            Set-AtwsModuleConfiguration -DateConversion UTC
            $Products = Get-AtwsInstalledProduct -Type Server -Active $true -AccountID 0 | Select-Object -First 30
            $Products.Count | Should -Be 30
            { Set-AtwsInstalledProduct -InputObject $Products -Type Server } | Should -Not -Throw
        }

        It "Dateconversion = Europe/Istanbul" {
            Set-AtwsModuleConfiguration -DateConversion $timezoneid
            $Products = Get-AtwsInstalledProduct -Type Server -Active $true -AccountID 0 | Select-Object -First 30
            $Products.Count | Should -Be 30
            { Set-AtwsInstalledProduct -InputObject $Products } | Should -Not -Throw
        }

    }
    
}

Describe "GitHub issues regression tests" {

    Context 'Issue #1: Account where a certain field (int) is empty' {
        BeforeAll { 
            $account = Get-AtwsAccount -id 0
        }

        It 'should exist an Account with id 0' {
            $account | Should -BeOfType Autotask.Account
        }
        
        It 'should not throw an exception when using -IsNull' { 
            { $null = Get-AtwsAccount -id 0 -IsNull KeyAccountIcon } | Should -Not -Throw
        }
        
        It 'should NOT return anything with -IsNull KeyAccountIcon' {
            $accountWithPicklistNull = Get-AtwsAccount -id 0 -IsNull KeyAccountIcon
            $accountWithPicklistNull | Should -BeNullOrEmpty
        }

        It 'should throw an exception when using $null with a validateset parameter' { 
            { $null = Get-AtwsAccount -id 0 -KeyAccountIcon $null } | Should -Throw
        }
        
        It 'should NOT throw an exception when using $null with an integer parameter' { 
            { $null = Get-AtwsAccount -id 0 -ParentAccountID $null } | Should -Not -Throw
        }
        
        
        It 'should exist an Account with id 0 and a ParentAccountId of $null' {
            $accountWithNull = Get-AtwsAccount -id 0 -ParentAccountID $null
            $accountWithNull | Should -BeOfType Autotask.Account
        }
    }

    # The root cause was a mistake in ConvertTo-AtwsFilter
    # We'll check this by mocking Get-AtwsData and verifying the -Filter
    Context 'Issue #36: Date queries with multiple date fields return 0 objects ' {
        
        It 'should pass -le as the last operator' { 
            
            InModuleScope $ModuleName {
        
                Mock 'Get-AtwsData' {
                    [PSCustomObject]@{
                        PSTypeName = 'Autotask.ContractServiceUnit'
                        StartDate  = Get-Date
                        EndDate    = Get-Date
                    }
                }

                $result = Get-AtwsContractServiceUnit -ContractID 0 -StartDate '2019.01.01' -EndDate '2019.12.31'
                Should -Invoke Get-AtwsData -Times 1 -Exactly -ParameterFilter { $Filter[-2] -eq '-le' }

            }
        }
        
    }

    Context 'Issue #38: Feature request: Make connection object available to advanced users duplicate enhancement ' {
        
        It 'should be loaded' {
            $loadedModule.Name | Should -Be $ModuleName
        }

        It 'should export Get-AtwsConnectionObject' {
            $loadedModule.ExportedCommands['Get-AtwsConnectionObject'].Name | Should -Be 'Get-AtwsConnectionObject'
        }

        $result = Get-AtwsConnectionObject -Confirm:$false

        It 'should return an Autotask web proxy object' {
            $result = Get-AtwsConnectionObject -Confirm:$false
            $result.GetType() | Should -Be 'Autotask.ATWSSoapClient'
        }
    }

    Context 'Issue #43: New-AtwsAttachment adds timezone difference twice ' {
        It 'should call with mocked AttachmentId and return date unchanged' {

            InModuleScope $moduleName {
        
                # Get a datetime object
                $createDate = Get-Date
                $atws = Get-AtwsConnectionObject -Confirm:$false

                Mock 'Get-AtwsAttachmentInfo' {
                    [PSCustomObject]@{
                        PSTypeName = 'Autotask.AttachmentInfo'
                        CreateDate = $createDate
                    }
                }

                Mock 'Get-AtwsTicket' {
                    Return $True
                }

                # Mock CreateAttachment()
                $createAttachmentMethod = @{
                    Type  = 'ScriptMethod'
                    Name  = 'CreateAttachment'
                    Value = {
                        1234 
                    }
                    Force = $True
                }
                $atws | Add-Member @createAttachmentMethod 

                $result = New-AtwsAttachment -URI https://google.com -TicketID 0
   
                Should -Invoke Get-AtwsAttachmentInfo -Times 1 -Exactly -ParameterFilter { $id -eq 1234 }

                $result.CreateDate | Should -Be $createDate
            }
        }
    }

    Context 'Issue #44: GetEntityByReferenceId documentation ' {

        BeforeAll { 
            $contract = Get-AtwsContract -AccountID 0 -IsDefaultContract $True
            $account = Get-AtwsContract -id $contract.Id -GetReferenceEntityById AccountID
        }

        It 'Account 0 should have a default contract' {
            $contract.Count | Should -Be 1
        }

        It '$contract should be a contract' {
            $contract | Should -BeOfType Autotask.Contract
        }

        It '-GetReferenceEntityById AccountID should return a single account' {
            $account.Count | Should -Be 1
        }

        It 'should be an Account and have id 0' {
            $account | Should -BeOfType Autotask.Account
            $account.id | Should -Be 0
        }
    }

    # The root cause was a mistake in ConvertTo-AtwsFilter
    # We'll check this by mocking Get-AtwsData and verifying the -Filter
    Context 'Issue #61: Date queries with multiple date values should not be expanded to date filters ' {

        It 'should pass -eq as the last operator' { 

            InModuleScope $ModuleName { 

                $dates = @('2019.01.01', '2019.12.31')

                Mock 'Get-AtwsData' {
                    [PSCustomObject]@{
                        PSTypeName = 'Autotask.ContractServiceUnit'
                        StartDate  = Get-Date
                        EndDate    = Get-Date
                    }
                }

                $result = Get-AtwsContractServiceUnit -ContractID 0 -StartDate $dates
                Should -Invoke Get-AtwsData -Times 1 -Exactly -ParameterFilter { $Filter[-3] -eq '-eq' }
            }
        }
        
    }

    Context 'Issue #63: Data type convertion error on Get-AtwsTicketCost ' {

        It 'Boolean parameters should not throw an exception' {
            { $null = Get-AtwsTicketCost -TicketID 0 -BillableToAccount $true -Billed $false } | Should -Not -Throw
        }

    }

    Context 'Issue #75: ATWSSoap returns wrong value on EntityInfo.HasUserDefinedFields' {
        # Get entityinfo for Account and force a lookup through the API
        It 'Account should have Userdefined fields' {
            $result = Get-AtwsFieldInfo -Entity Account -EntityInfo -UpdateCache
            $result.HasUserDefinedFields  | Should -Be $true
        }

    }

    Context 'Issue #94: TimeZone issues' {
        # Get entityinfo for Account and force a lookup through the API
        It 'There should be more than 0 ContractServiceUnits' {
            $Now = (Get-Date -Day 1).Date
            $contractId = 30390716 # Internal service contract
            $result = Get-AtwsContractServiceUnit -ContractID $contractId -StartDate $Now -LessThanOrEquals StartDate -EndDate $Now -GreaterThanOrEquals EndDate

            $result.count  | Should -BeGreaterThan 0
        }

    }
    
}

#Region ########### TESTS THAT FAILS ################
Describe "New- Entities tests." {
    BeforeAll {
        # Initiates collection of typed installedproducts for later use.
        $NewItems = @()
        0..1 | ForEach-Object {
            $Item = [Autotask.InstalledProduct]@{
                AccountID      = 0;
                Active         = $true
                ProductID      = 29682875
                ReferenceTitle = $_
                NumberOfUsers  = 1337
            }

            $Item.UserDefinedFields = @{ Name = 'Maskin navn'; Value = $_ }

            $NewItems += $Item
        }

        $NewTypedVariant = [System.Collections.Generic.List[Autotask.InstalledProduct]]::new()
        0..1| ForEach-Object {
            $Item = [Autotask.InstalledProduct]@{
                AccountID         = 0;
                Active            = $true
                ProductID         = 29682875
                ReferenceTitle    = $_
                NumberOfUsers     = 1337
                UserDefinedFields = [Autotask.UserDefinedField]@{ Name = 'Maskin navn'; Value = $_ }, [Autotask.UserDefinedField]@{ Name = 'Sist logget inn'; Value = (Get-Date -Format 'dd-MM-yyyy') }
            }

            $NewTypedVariant.add($Item)
        }

        # Add last created item to a generic list with a single item
        $CollectiontWithSingleNewItem = [System.Collections.Generic.List[Autotask.InstalledProduct]]::new()
        $CollectiontWithSingleNewItem.add($Item)

        $Contacts = Get-AtwsContact -FirstName 'Bjørn' -Like FirstName -Active $true
        $ContactGroup = New-AtwsContactGroup -Active $true -Name ("All Bears in the hood {0}" -f (New-Guid).Guid.Substring(0, 7))

        $ContactSelection = [System.Collections.Generic.List[Autotask.ContactGroupContact]]::new()
        $Contacts.foreach{
            $tmp = [Autotask.ContactGroupContact]@{
                ContactGroupID = $ContactGroup.id;
                ContactID      = $_.id;
            }
            $ContactSelection.add($tmp)
        }

        Set-AtwsModuleConfiguration -ErrorLimit 30
    }

    AfterAll {
        Set-AtwsContactGroup -InputObject $ContactGroup -Active $false
        Remove-AtwsContactGroup -InputObject $ContactGroup
    }

    Context "New-AtwsInstalledProduct" {
        It "Should not throw when creating one or more new installedProducts." {
            { New-AtwsInstalledProduct -InputObject $NewItems } | Should -Not -Throw
        }
        It "Should not throw with just 1 input object." {
            { New-AtwsInstalledProduct -InputObject $NewItems[0] } | Should -Not -Throw
        }
        It "Should not throw if the collection is typed either." {
            { New-AtwsInstalledProduct -InputObject $NewTypedVariant } | Should -Not -Throw
        }
        It "Should not throw if the collection is typed and containing just a single item." {
            { New-AtwsInstalledProduct -InputObject $CollectiontWithSingleNewItem } | Should -Not -Throw
        }
    }

    Context "ContactGroup tests. New group, add/create members, delete group again." {
        
        It "Should not throw when creating/adding contacts to a group" {
            { New-AtwsContactGroupContact -InputObject $ContactSelection } | Should -Not -Throw
        }
    }
}

#EndRegion
