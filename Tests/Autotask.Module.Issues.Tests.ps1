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

  Context 'Issue #44: GetEntityByReferenceId documentation ' -Tag 'Issue #44' {
    
    $Contract = Get-AtwsContract -AccountID 0 -IsDefaultContract
    $Account = Get-AtwsContract -id $Contract.Id -GetReferenceEntityById AccountID

    It 'Account 0 should have a default contract' {
      $Contract.Count | Should -Be 1
    }

    It '$Contract should be a contract' {
      $Contract | Should -BeOfType Contract
    }

    It '-GetReferenceEntityById AccountID should return a single account' {
      $Account.Count | Should -Be 1
    }

    It 'should be an Account and have id 0' {
      $Account | Should -BeOfType Account
      $Account.id | Should -Be 0
    }

  }

  Context 'Issue #43: New-AtwsAttachment adds timezone difference twice ' -Tag 'Issue #43' { }

  Context 'Issue #42: 1.6.2.14: no valid module was found in any module directory ' -Tag 'Issue #42' { }

  Context 'Issue #41: Beta-module overwrites personal disk cache for release module ' -Tag 'Issue #41' { }

  Context 'Issue #40: Get-AtwsService - No Unit Count? ' -Tag 'Issue #40' { }

  Context 'Issue #39: New-AtwsData : Contracts of type 7 (Recurring Services) require a ContractPeriodType. ' -Tag 'Issue #39' { }

  Context 'Issue #38: Feature request: Make connection object available to advanced users duplicate enhancement ' -Tag 'Issue #38' { }

  Context 'Issue #37: Feature request: Attachments upload enhancement good first issue ' -Tag 'Issue #37' { }

  Context 'Issue #36: Date queries with multiple date fields return 0 objects ' -Tag 'Issue #36' { }

  Context 'Issue #35: How to access API methods directly with 1.6.2.x ' -Tag 'Issue #35' { }

  Context 'Issue #33: Updating Diskcache auto running at every import ' -Tag 'Issue #33' { }

  Context 'Issue #32: Suppress DATE and TIME warning enhancement ' -Tag 'Issue #32' { }

  Context 'Issue #31: No DefaultServiceDeskRoleID parameter on the Get-AtwsResource function ' -Tag 'Issue #31' { }

  Context 'Issue #30: Switch to skip ApiTrackingIdentifier for backward compatibility? ' -Tag 'Issue #30' { }

  Context 'Issue #29: Set-AtwsContact :: Cannot convert Parameter -id from int64[] to int64 bug ' -Tag 'Issue #29' { }


  Context 'Issue #28: Set-AtWsTicketCost - Update status ' -Tag 'Issue #28' { }

  Context 'Issue #27: Receiving Confirm prompts with $global:ConfirmPreference="None" ' -Tag 'Issue #27' { }


  Context 'Issue #26: Multiple errors and issues. ' -Tag 'Issue #26' { }

  Context 'Issue #25: Set-AtwsTicket.ps1 - int32[] to int64 conversion error ' -Tag 'Issue #25' { }


  Context 'Issue #24: Missing commands, e.g., *-AtwsTicket ' -Tag 'Issue #24' { }

  Context 'Issue #23: Help w/ picklists lookups in functions and scripts. ' -Tag 'Issue #23' { }

  Context 'Issue #22: UDF wildcard does not work ' -Tag 'Issue #22' { }

  Context 'Issue #21: New-AtwsContractServiceAdjustment: Get-AtwsData : This entity type does not support the query action. ' -Tag 'Issue #21' { }

  Context 'Issue #20: new-atwscontract: System.dateTime: Can not convert data to date in field ' -Tag 'Issue #20' { }

  Context 'Issue #19: Receiving this error when importing the Autotask Module. I am using an API User. ' -Tag 'Issue #19' { }

  Context 'Issue #18: The specified module was not loaded because no valid module file was found in any module directory. ' -Tag 'Issue #18' { }

  Context 'Issue #17: Running on Azure Runbooks (Cache) ' -Tag 'Issue #17' { }

  Context 'Issue #16: Always confirming the write of new autotask data. ' -Tag 'Issue #16' { }

  Context 'Issue #15: Date errors using filter ' -Tag 'Issue #15' { }

  Context 'Issue #14: Changing UDF ' -Tag 'Issue #14' { }

  Context 'Issue #11: Set "ServiceLevelAgreementID" on contract to nothing ' -Tag 'Issue #11' { }

  Context 'Issue #10: Unable to connect, as a "\" seems to be prepended ' -Tag 'Issue #10' { }

  Context 'Issue #9: DateTime conversions ' -Tag 'Issue #9' { }

  Context 'Issue #8: Set-AtwsAccount -TerritoryID <Integer> Fails  ' -Tag 'Issue #8' { }

  Context 'Issue #7: Get-AtwsTicket -SubIssueType not updating properly. ' -Tag 'Issue #7' { }
 
  Context 'Issue #4: Get / Set AccountManager field ' -Tag 'Issue #4' { }

  Context 'Issue #3: Value does not exist for the required field when using New-AtwsData -InputObject ' -Tag 'Issue #3' { }

  Context 'Issue #2: Filters with parenthesis no longer work ' -Tag 'Issue #2' { }


  Context 'Issue #1: Account where a certain field (int) is empty' -Tag 'Issue #1' {
  
  }

}