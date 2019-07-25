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
      Mandatory = $true,
      ParameterSetName = 'Default'
  )]
  [ValidateNotNullOrEmpty()]    
  [pscredential]
  $Credential,
    
  [Parameter(
      Mandatory = $true,
      ParameterSetName = 'Default'
  )]
  [String]
  $ApiTrackingIdentifier
)

Describe 'Test all issues for regression errors' -Tag 'Issues' { 

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

  Context 'Issue #43: New-AtwsAttachment adds timezone difference twice ' { }

  # Issue #42 is tested in Autotask.Module.Import.Tests.ps1

  Context 'Issue #41: Beta-module overwrites personal disk cache for release module ' { }

  # Issue #40 is an information request

  # Issue #39 was retracted

  Context 'Issue #38: Feature request: Make connection object available to advanced users duplicate enhancement ' {

    # Load the module in this context, a straight load with -Argumentlist is appropriate
    $ModuleName = 'Autotask'

    $ModulePath = '{0}\{1}' -F $(Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)), $ModuleName
    
    Import-Module $ModulePath -Force -ArgumentList $Credential, $ApiTrackingIdentifier

    $LoadedModule = Get-Module $ModuleName

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

  Context 'Issue #37: Feature request: Attachments upload enhancement good first issue ' {
    
    # Load the module in this context, a straight load with -Argumentlist is appropriate
    $ModuleName = 'Autotask'

    $ModulePath = '{0}\{1}' -F $(Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)), $ModuleName
    
    Import-Module $ModulePath -Force -ArgumentList $Credential, $ApiTrackingIdentifier

    $LoadedModule = Get-Module $ModuleName

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

  Context 'Issue #36: Date queries with multiple date fields return 0 objects ' { }

  # Issue #35 is a duplicate of issue #38. Or vice versa. But it is already tested...
  # Issue #34 does not exist 

  Context 'Issue #33: Updating Diskcache auto running at every import ' { }

  Context 'Issue #32: Suppress DATE and TIME warning enhancement ' { }

  # Issue #31 was outside of scope - a parameter wasnt queryable by Autotask design

  # Issue #30: Switch to skip ApiTrackingIdentifier for backward compatibility?  - Deemed out of scope

  Context 'Issue #29: Set-AtwsContact :: Cannot convert Parameter -id from int64[] to int64 bug ' { }

  #Issue #28: Set-AtWsTicketCost - Update status - was an API documentation issue

  Context 'Issue #27: Receiving Confirm prompts with $global:ConfirmPreference="None" ' { }

  # Issue #26: Multiple errors and issues - reporter got it to work on a different computer
  
  Context 'Issue #25: Set-AtwsTicket.ps1 - int32[] to int64 conversion error ' { }


  Context 'Issue #24: Missing commands, e.g., *-AtwsTicket ' { }

  Context 'Issue #23: Help w/ picklists lookups in functions and scripts. ' { }

  Context 'Issue #22: UDF wildcard does not work ' { }

  Context 'Issue #21: New-AtwsContractServiceAdjustment: Get-AtwsData : This entity type does not support the query action. ' { }

  Context 'Issue #20: new-atwscontract: System.dateTime: Can not convert data to date in field ' { }

  # Issue #19: Receiving this error when importing the Autotask Module. I am using an API User. - An API documentation issue related to API version 1.6

  # Issue #18: The specified module was not loaded because no valid module file was found in any module directory. - Already tested in separate tests

  Context 'Issue #17: Running on Azure Runbooks (Cache) ' { }

  Context 'Issue #16: Always confirming the write of new autotask data. ' { }

  Context 'Issue #15: Date errors using filter ' { }

  Context 'Issue #14: Changing UDF ' { }

  Context 'Issue #11: Set "ServiceLevelAgreementID" on contract to nothing ' { }

  Context 'Issue #10: Unable to connect, as a "\" seems to be prepended ' { }

  Context 'Issue #9: DateTime conversions ' { }

  Context 'Issue #8: Set-AtwsAccount -TerritoryID <Integer> Fails  ' { }

  Context 'Issue #7: Get-AtwsTicket -SubIssueType not updating properly. ' { }
 
  Context 'Issue #4: Get / Set AccountManager field ' { }

  Context 'Issue #3: Value does not exist for the required field when using New-AtwsData -InputObject ' { }

  Context 'Issue #2: Filters with parenthesis no longer work ' { }


  Context 'Issue #1: Account where a certain field (int) is empty' {
    
    $Account = Get-AtwsAccount -id 0
    $NoAccount = Get-AtwsAccount -id 0 -KeyAccountIcon $null
    $AccountWithNull = Get-AtwsAccount -id 0 -ParentAccountId $null

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