<#

        .COPYRIGHT
        Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
        See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.

        .SYNOPSIS
        This set of tests has a test per issue reported on GitHub and is supposed to guard against re-introducing old bugs
        .DESCRIPTION
        In this Pester script I have written one or a set of tests per issue reported on GitHub. This is will hopefully discover any mistakes that re-introduces old bugs.

        .INPUTS
        Nothing. This function only takes parameters.
        .OUTPUTS
        Nothing.

#>

[cmdletbinding(
        SupportsShouldProcess = $True,
        ConfirmImpact = 'Low',
        DefaultParameterSetName = 'Default'
)]

Param
(
    [Parameter(
            Mandatory = $True,
            ParameterSetName = 'Default'
    )]
    [ValidateNotNullOrEmpty()]    
    [pscredential]
    $Credential,
    
    [Parameter(
            Mandatory = $True,
            ParameterSetName = 'Default'
    )]
    [String]
    $ApiTrackingIdentifier,

    [Parameter(
        Mandatory = $false,
        ParameterSetName = 'Default'
    )]
    [String]
    $ModuleName = 'Autotask',

    [Parameter(
        Mandatory = $false,
        ParameterSetName = 'Default'
    )]
    [ValidateSCript( {
            Test-Path $_
        })]
    [String]
    $RootPath = $(Split-Path -Parent -Path (Split-Path -Parent -Path $MyInvocation.MyCommand.Path))
)

$modulePath = '{0}\{1}' -F $RootPath, $ModuleName

$loadedModule = Get-Module -Name $ModuleName
If (-not ($loadedModule)) { 
    # Import the module. Issues that need their own load version will have to do so in their context
    Import-Module $modulePath -Force -ArgumentList $Credential, $ApiTrackingIdentifier
}

Describe 'Issue #75' -Tag 'Issues' {

    Context 'Issue #75: ATWSSoap returns wrong value on EntityInfo.HasUserDefinedFields' {
        # Get entityinfo for Account and force a lookup through the API
        $result = Get-AtwsFieldInfo -Entity Account -EntityInfo -UpdateCache

        It 'Account should have Userdefined fields' {
            $result.HasUserDefinedFields  | Should -be $true
        }

    }
}


Describe 'Issue #74' -Tag 'Issues' {

    Context 'Issue #74: Updating Disc Cache on every Import' {

        It 'Boolean parameters should not throw an exception' {
            # Placeholder
        }

    }
}


describe 'Issue #63' -Tag 'Issues' {

    context 'Issue #63: Data type convertion error on Get-AtwsTicketCost ' {

        it 'Boolean parameters should not throw an exception' {
          {$null = Get-AtwsTicketCost -TicketID 0 -BillableToAccount $true -Billed $false} | Should -Not -Throw
        }

    }
}

describe 'Issue #44' -Tag 'Issues' {

    context 'Issue #44: GetEntityByReferenceId documentation ' {
        $contract = Get-AtwsContract -AccountID 0 -IsDefaultContract $True
        $account = Get-AtwsContract -id $contract.Id -GetReferenceEntityById AccountID

        it 'Account 0 should have a default contract' {
            $contract.Count | Should -Be 1
        }

        it '$contract should be a contract' {
            $contract | Should -BeOfType Autotask.Contract
        }

        it '-GetReferenceEntityById AccountID should return a single account' {
            $account.Count | Should -Be 1
        }

        it 'should be an Account and have id 0' {
            $account | Should -BeOfType Autotask.Account
            $account.id | Should -Be 0
        }
    }
}

describe 'Issue #43' -Tag 'Issues' {

    context 'Issue #43: New-AtwsAttachment adds timezone difference twice ' {
    
        InModuleScope Autotask {
        
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

            it 'should call with mocked AttachmentId' {
                $assertParams = @{
                    CommandName     = 'Get-AtwsAttachmentInfo'
                    ParameterFilter = {
                        $id -eq 1234 
                    }
                }
                Assert-MockCalled @assertParams
            }

            it 'should return the date unchanged' {
                $result.CreateDate | Should -Be $createDate
            }
        }
    }
}

# Issue #42 is tested in Autotask.Module.Import.Tests.ps1

<#
        describe 'Issue #41' -Tag 'Issues' {

        context 'Issue #41: Beta-module overwrites personal disk cache for release module ' { }

        
        }
#>

# Issue #40 is an information request

# Issue #39 was retracted
        
describe 'Issue #38' -Tag 'Issues' {

    context 'Issue #38: Feature request: Make connection object available to advanced users duplicate enhancement ' {
        it 'should be loaded' {
            $loadedModule.Name | Should -Be $ModuleName
        }

        it 'should export Get-AtwsConnectionObject' {
            $loadedModule.ExportedCommands['Get-AtwsConnectionObject'].Name | Should -Be 'Get-AtwsConnectionObject'
        }

        $result = Get-AtwsConnectionObject -Confirm:$false

        it 'should return an Autotask web proxy object' {
            $result.GetType() | Should -be 'Autotask.ATWSSoapClient'
        }
    }
}

describe 'Issue #37' -Tag 'Issues' {
    context 'Issue #37: Feature request: Attachments upload enhancement good first issue ' {

        it 'should be loaded' {
            $loadedModule.Name | Should -Be $ModuleName
        }

        it 'should export Get-AtwsAttachment' {
            $loadedModule.ExportedCommands['Get-AtwsAttachment'].Name | Should -Be 'Get-AtwsAttachment'
        }

        it 'should export New-AtwsAttachment' {
            $loadedModule.ExportedCommands['New-AtwsAttachment'].Name | Should -Be 'New-AtwsAttachment'
        }

        it 'should export Remove-AtwsAttachment' {
            $loadedModule.ExportedCommands['Remove-AtwsAttachment'].Name | Should -Be 'Remove-AtwsAttachment'
        }
    }
}

describe 'Issue #36' -Tag 'Issues' {
    # The root cause was a mistake in ConvertTo-AtwsFilter
    # We'll check this by mocking Get-AtwsData and verifying the -Filter
    InModuleScope Autotask { 
        
        Mock 'Get-AtwsData' {
            [PSCustomObject]@{
                PSTypeName = 'Autotask.ContractServiceUnit'
                StartDate = Get-Date
                EndDate = Get-Date
            }
        }
        
        context 'Issue #36: Date queries with multiple date fields return 0 objects ' {
        
            $result = Get-AtwsContractServiceUnit -ContractID 0 -StartDate '2019.01.01' -EndDate '2019.12.31'
            
            it 'should pass -le as the last operator' { 
                $assertParams = @{
                    CommandName     = 'Get-AtwsData'
                    ParameterFilter = {
                        $Filter[-2] -eq '-le' 
                    }
                }
                Assert-MockCalled @assertParams
            }
        }
    }
}

# Issue #35 is a duplicate of issue #38. Or vice versa. But it is already tested...
# Issue #34 does not exist 

describe 'Issue #33' -Tag 'Issues' {
    
    # Get creation time of current file
    $atws = Get-AtwsConnectionObject -Confirm:$false
    [IO.FileInfo]$functionFile = Join-Path $atws.DynamicCache 'Get-AtwsTicket.ps1'
    $lastWriteTime = $functionFile.LastWriteTime
    
    # Remove any loaded modules before trying to load it again
    Remove-Module -Name $ModuleName -Force -ErrorAction SilentlyContinue
    
    context 'Issue #33: Updating Diskcache auto running at every import' {
        
        # Reimport module
        Import-Module $ModulePath -Force -ArgumentList $Credential, $ApiTrackingIdentifier
       
        # Re-read fileinfo
        [IO.FileInfo]$functionFile = Join-Path $atws.DynamicCache 'Get-AtwsTicket.ps1'

        it 'should NOT have updated Get-AtwsTicket' {
            $functionFile.LastWriteTime | should -Be $lastWriteTime
        }

        # Re-import module with force upgrade of Ticket entity
        Import-Module $ModulePath -Force -ArgumentList $Credential, $ApiTrackingIdentifier, 'Ticket'

        # Re-read fileinfo
        [IO.FileInfo]$functionFile = Join-Path $atws.DynamicCache 'Get-AtwsTicket.ps1'

        it 'should have updated Get-AtwsTicket after second module import' {
            $functionFile.LastWriteTime | should -Not -Be $lastWriteTime
        }
    }
}


describe 'Issue #32' -Tag 'Issues' {
    context 'Issue #32: Suppress DATE and TIME warning enhancement ' {
 
    }
}

# Issue #31 was outside of scope - a parameter wasnt queryable by Autotask design

# Issue #30: Switch to skip ApiTrackingIdentifier for backward compatibility?  - Deemed out of scope

describe 'Issue #29' -Tag 'Issues' {
    context 'Issue #29: Set-AtwsContact :: Cannot convert Parameter -id from int64[] to int64 bug ' {
 
    }

    #Issue #28: Set-AtWsTicketCost - Update status - was an API documentation issue
}

describe 'Issue #27' -Tag 'Issues' {
    context 'Issue #27: Receiving Confirm prompts with $global:ConfirmPreference="None" ' {
 
    }

    # Issue #26: Multiple errors and issues - reporter got it to work on a different computer
}

describe 'Issue #25' -Tag 'Issues' {
    context 'Issue #25: Set-AtwsTicket.ps1 - int32[] to int64 conversion error ' {
 
    }
}

describe 'Issue #24' -Tag 'Issues' {
    context 'Issue #24: Missing commands, e.g., *-AtwsTicket ' {
 
    }
}

describe 'Issue #23' -Tag 'Issues' {
    context 'Issue #23: Help w/ picklists lookups in functions and scripts. ' {
 
    }
}

describe 'Issue #22' -Tag 'Issues' {
    context 'Issue #22: UDF wildcard does not work ' {
 
    }
}

describe 'Issue #21' -Tag 'Issues' {
    context 'Issue #21: New-AtwsContractServiceAdjustment: Get-AtwsData : This entity type does not support the query action. ' {
 
    }
}

describe 'Issue #20' -Tag 'Issues' {
    context 'Issue #20: new-atwscontract: System.dateTime: Can not convert data to date in field ' {
 
    }

    # Issue #19: Receiving this error when importing the Autotask Module. I am using an API User. - An API documentation issue related to API version 1.6

    # Issue #18: The specified module was not loaded because no valid module file was found in any module directory. - Already tested in separate tests
}

describe 'Issue #17' -Tag 'Issues' {
    context 'Issue #17: Running on Azure Runbooks (Cache) ' {
 
    }
}

describe 'Issue #16' -Tag 'Issues' {
    context 'Issue #16: Always confirming the write of new autotask data. ' {
 
    }
}

describe 'Issue #15' -Tag 'Issues' {
    context 'Issue #15: Date errors using filter ' {
 
    }
}

describe 'Issue #14' -Tag 'Issues' {
    context 'Issue #14: Changing UDF ' {
 
    }
}

describe 'Issue #11' -Tag 'Issues' {
    context 'Issue #11: Set "ServiceLevelAgreementID" on contract to nothing ' {
 
    }
}

describe 'Issue #10' -Tag 'Issues' {
    context 'Issue #10: Unable to connect, as a "\" seems to be prepended ' {
 
    }
}

describe 'Issue #9' -Tag 'Issues' {
    context 'Issue #9: DateTime conversions ' {
 
    }
}

describe 'Issue #8' -Tag 'Issues' {
    context 'Issue #8: Set-AtwsAccount -TerritoryID <Integer> Fails  ' {
 
    }
}

describe 'Issue #7' -Tag 'Issues' {
    context 'Issue #7: Get-AtwsTicket -SubIssueType not updating properly. ' {
 
    }
}

describe 'Issue #4' -Tag 'Issues' {
    context 'Issue #4: Get / Set AccountManager field ' {
 
    }
}

describe 'Issue #3' -Tag 'Issues' {
    context 'Issue #3: Value does not exist for the required field when using New-AtwsData -InputObject ' {
 
    }
}

describe 'Issue #2' -Tag 'Issues' {
    context 'Issue #2: Filters with parenthesis no longer work ' {
 
    }
}

describe 'Issue #1' -Tag 'Issues' {
    Context 'Issue #1: Account where a certain field (int) is empty' {

        $account = Get-AtwsAccount -id 0

        It 'should exist an Account with id 0' {
            $account | Should -BeOfType Autotask.Account
        }
        
        It 'should not throw an exception when using -IsNull' { 
            { $null = Get-AtwsAccount -id 0 -IsNull KeyAccountIcon } | Should -Not -Throw
        }

        # Do it for real this time
        $accountWithPicklistNull = Get-AtwsAccount -id 0 -IsNull KeyAccountIcon
        It 'should NOT return anything with -IsNull KeyAccountIcon' {
            $accountWithPicklistNull | Should -BeNullOrEmpty
        }

        It 'should throw an exception when using $null with a validateset parameter' { 
            { $null = Get-AtwsAccount -id 0 -KeyAccountIcon $null } | Should -Throw
        }
        
        It 'should NOT throw an exception when using $null with an integer parameter' { 
            { $null = Get-AtwsAccount -id 0 -ParentAccountID $null } | Should -Not -Throw
        }
        
        $accountWithNull = Get-AtwsAccount -id 0 -ParentAccountID $null
        It 'should exist an Account with id 0 and a ParentAccountId of $null' {
            $accountWithNull | Should -BeOfType Autotask.Account
        }
    }
}