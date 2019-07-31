<#

        .COPYRIGHT
        Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
        See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

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
    $ApiTrackingIdentifier
)

# Information about module location
$ModuleName = 'Autotask'

$ModulePath = '{0}\{1}' -F $(Split-Path -Parent -Path (Split-Path -Parent -Path $MyInvocation.MyCommand.Path)), $ModuleName

# Import the module. Issues that need their own load version will have to do so in their context
Import-Module $ModulePath -Force -ArgumentList $Credential, $ApiTrackingIdentifier

# Quite a few issues need this
$LoadedModule = Get-Module $ModuleName

Describe 'Issue #44' -Tag 'Issues' {

    Context 'Issue #44: GetEntityByReferenceId documentation ' {
        $Contract = Get-AtwsContract -AccountID 0 -IsDefaultContract $True
        $Account = Get-AtwsContract -id $Contract.Id -GetReferenceEntityById AccountID

        It 'Account 0 should have a default contract' {
            $Contract.Count | Should -Be 1
        }

        It '$Contract should be a contract' {
            $Contract | Should -BeOfType Autotask.Contract
        }

        It '-GetReferenceEntityById AccountID should return a single account' {
            $Account.Count | Should -Be 1
        }

        It 'should be an Account and have id 0' {
            $Account | Should -BeOfType Autotask.Account
            $Account.id | Should -Be 0
        }
    }
}

Describe 'Issue #43' -Tag 'Issues' {

    Context 'Issue #43: New-AtwsAttachment adds timezone difference twice ' {
    
        InModuleScope Autotask {
        
            # Get a datetime object
            $CreateDate = Get-Date
            $Atws = Get-AtwsConnectionObject -Confirm:$false

            Mock 'Get-AtwsAttachmentInfo' {
                [PSCustomObject]@{
                    PSTypeName = 'Autotask.AttachmentInfo'
                    CreateDate = $CreateDate
                }
            }

            Mock 'Get-AtwsTicket' {
                Return $True
            }

            # Mock CreateAttachment()
            $CreateAttachmentMethod = @{
                Type  = 'ScriptMethod'
                Name  = 'CreateAttachment'
                Value = {
                    1234 
                }
                Force = $True
            }
            $Atws | Add-Member @CreateAttachmentMethod 

            $Result = New-AtwsAttachment -URI https://google.com -TicketID 0

            It 'should call with mocked AttachmentId' {
                $AssertParams = @{
                    CommandName     = 'Get-AtwsAttachmentInfo'
                    ParameterFilter = {
                        $id -eq 1234 
                    }
                }
                Assert-MockCalled @AssertParams
            }

            It 'should return the date unchanged' {
                $Result.CreateDate | Should -Be $CreateDate
            }
        }
    }
}

# Issue #42 is tested in Autotask.Module.Import.Tests.ps1

<#
        Describe 'Issue #41' -Tag 'Issues' {

        Context 'Issue #41: Beta-module overwrites personal disk cache for release module ' { }

        
        }
#>

# Issue #40 is an information request

# Issue #39 was retracted
        
Describe 'Issue #38' -Tag 'Issues' {

    Context 'Issue #38: Feature request: Make connection object available to advanced users duplicate enhancement ' {
        It 'should be loaded' {
            $LoadedModule.Name | Should -Be $ModuleName
        }

        It 'should export Get-AtwsConnectionObject' {
            $LoadedModule.ExportedCommands['Get-AtwsConnectionObject'].Name | Should -Be 'Get-AtwsConnectionObject'
        }

        $Result = Get-AtwsConnectionObject -Confirm:$false

        It 'should return an Autotask web proxy object' {
            $Result | Should -BeOfType Autotask.ATWS
        }
    }
}

Describe 'Issue #37' -Tag 'Issues' {
    Context 'Issue #37: Feature request: Attachments upload enhancement good first issue ' {

        It 'should be loaded' {
            $LoadedModule.Name | Should -Be $ModuleName
        }

        It 'should export Get-AtwsAttachment' {
            $LoadedModule.ExportedCommands['Get-AtwsAttachment'].Name | Should -Be 'Get-AtwsAttachment'
        }

        It 'should export New-AtwsAttachment' {
            $LoadedModule.ExportedCommands['New-AtwsAttachment'].Name | Should -Be 'New-AtwsAttachment'
        }

        It 'should export Remove-AtwsAttachment' {
            $LoadedModule.ExportedCommands['Remove-AtwsAttachment'].Name | Should -Be 'Remove-AtwsAttachment'
        }
    }
}

Describe 'Issue #36' -Tag 'Issues' {
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
        
        Context 'Issue #36: Date queries with multiple date fields return 0 objects ' {
        
            $result = Get-AtwsContractServiceUnit -ContractID 0 -StartDate '2019.01.01' -EndDate '2019.12.31'
            
            it 'should pass -le as the last operator' { 
                $AssertParams = @{
                    CommandName     = 'Get-AtwsData'
                    ParameterFilter = {
                        $Filter[-2] -eq '-le' 
                    }
                }
                Assert-MockCalled @AssertParams
            }
        }
    }
}

# Issue #35 is a duplicate of issue #38. Or vice versa. But it is already tested...
# Issue #34 does not exist 

Describe 'Issue #33' -Tag 'Issues' {
    
    # Get creation time of current file
    $atws = Get-AtwsConnectionObject -Confirm:$false
    [IO.FileInfo]$functionFile = '{0}\WindowsPowershell\Cache\{1}\Dynamic\Get-AtwsTicket.ps1' -f $([environment]::GetFolderPath('MyDocuments')), $atws.CI
    $lastWriteTime = $functionFile.LastWriteTime
    
    Context 'Issue #33: Updating Diskcache auto running at every import' {
        
        # Reimport module
        Import-Module $ModulePath -Force -ArgumentList $Credential, $ApiTrackingIdentifier
       
        # Re-read fileinfo
        [IO.FileInfo]$functionFile = '{0}\WindowsPowershell\Cache\{1}\Dynamic\Get-AtwsTicket.ps1' -f $([environment]::GetFolderPath('MyDocuments')), $atws.CI

        it 'should NOT have updated Get-AtwsTicket' {
            $functionFile.LastWriteTime | should -Be $lastWriteTime
        }

        # Re-import module with force upgrade of Ticket entity
        Import-Module $ModulePath -Force -ArgumentList $Credential, $ApiTrackingIdentifier, 'Ticket'

        # Re-read fileinfo
        [IO.FileInfo]$functionFile = '{0}\WindowsPowershell\Cache\{1}\Dynamic\Get-AtwsTicket.ps1' -f $([environment]::GetFolderPath('MyDocuments')), $atws.CI

        it 'should have updated Get-AtwsTicket after second module import' {
            $functionFile.LastWriteTime | should -Not -Be $lastWriteTime
        }
    }
}


Describe 'Issue #32' -Tag 'Issues' {
    Context 'Issue #32: Suppress DATE and TIME warning enhancement ' {
 
    }
}

# Issue #31 was outside of scope - a parameter wasnt queryable by Autotask design

# Issue #30: Switch to skip ApiTrackingIdentifier for backward compatibility?  - Deemed out of scope

Describe 'Issue #29' -Tag 'Issues' {
    Context 'Issue #29: Set-AtwsContact :: Cannot convert Parameter -id from int64[] to int64 bug ' {
 
    }

    #Issue #28: Set-AtWsTicketCost - Update status - was an API documentation issue
}

Describe 'Issue #27' -Tag 'Issues' {
    Context 'Issue #27: Receiving Confirm prompts with $global:ConfirmPreference="None" ' {
 
    }

    # Issue #26: Multiple errors and issues - reporter got it to work on a different computer
}

Describe 'Issue #25' -Tag 'Issues' {
    Context 'Issue #25: Set-AtwsTicket.ps1 - int32[] to int64 conversion error ' {
 
    }
}

Describe 'Issue #24' -Tag 'Issues' {
    Context 'Issue #24: Missing commands, e.g., *-AtwsTicket ' {
 
    }
}

Describe 'Issue #23' -Tag 'Issues' {
    Context 'Issue #23: Help w/ picklists lookups in functions and scripts. ' {
 
    }
}

Describe 'Issue #22' -Tag 'Issues' {
    Context 'Issue #22: UDF wildcard does not work ' {
 
    }
}

Describe 'Issue #21' -Tag 'Issues' {
    Context 'Issue #21: New-AtwsContractServiceAdjustment: Get-AtwsData : This entity type does not support the query action. ' {
 
    }
}

Describe 'Issue #20' -Tag 'Issues' {
    Context 'Issue #20: new-atwscontract: System.dateTime: Can not convert data to date in field ' {
 
    }

    # Issue #19: Receiving this error when importing the Autotask Module. I am using an API User. - An API documentation issue related to API version 1.6

    # Issue #18: The specified module was not loaded because no valid module file was found in any module directory. - Already tested in separate tests
}

Describe 'Issue #17' -Tag 'Issues' {
    Context 'Issue #17: Running on Azure Runbooks (Cache) ' {
 
    }
}

Describe 'Issue #16' -Tag 'Issues' {
    Context 'Issue #16: Always confirming the write of new autotask data. ' {
 
    }
}

Describe 'Issue #15' -Tag 'Issues' {
    Context 'Issue #15: Date errors using filter ' {
 
    }
}

Describe 'Issue #14' -Tag 'Issues' {
    Context 'Issue #14: Changing UDF ' {
 
    }
}

Describe 'Issue #11' -Tag 'Issues' {
    Context 'Issue #11: Set "ServiceLevelAgreementID" on contract to nothing ' {
 
    }
}

Describe 'Issue #10' -Tag 'Issues' {
    Context 'Issue #10: Unable to connect, as a "\" seems to be prepended ' {
 
    }
}

Describe 'Issue #9' -Tag 'Issues' {
    Context 'Issue #9: DateTime conversions ' {
 
    }
}

Describe 'Issue #8' -Tag 'Issues' {
    Context 'Issue #8: Set-AtwsAccount -TerritoryID <Integer> Fails  ' {
 
    }
}

Describe 'Issue #7' -Tag 'Issues' {
    Context 'Issue #7: Get-AtwsTicket -SubIssueType not updating properly. ' {
 
    }
}

Describe 'Issue #4' -Tag 'Issues' {
    Context 'Issue #4: Get / Set AccountManager field ' {
 
    }
}

Describe 'Issue #3' -Tag 'Issues' {
    Context 'Issue #3: Value does not exist for the required field when using New-AtwsData -InputObject ' {
 
    }
}

Describe 'Issue #2' -Tag 'Issues' {
    Context 'Issue #2: Filters with parenthesis no longer work ' {
 
    }
}

Describe 'Issue #1' -Tag 'Issues' {
    Context 'Issue #1: Account where a certain field (int) is empty' {
        $Account = Get-AtwsAccount -id 0
        $NoAccount = Get-AtwsAccount -id 0 -KeyAccountIcon $null
        $AccountWithNull = Get-AtwsAccount -id 0 -ParentAccountID $null

        It 'should exist an Account with id 0' {
            $Account | Should -BeOfType Autotask.Account
        }

        It 'should NOT return anything with -KeyAccountIcon $null' {
            $NoAccount | Should -BeNullOrEmpty
        }

        It 'should exist an Account with id 0 and a ParentAccountId of $null' {
            $AccountWithNull | Should -BeOfType Autotask.Account
        }
    }
}