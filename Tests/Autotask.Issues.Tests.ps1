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



Describe 'Issue #44: GetEntityByReferenceId documentation ' {

  It 'should be an account with id 0' {
    
    $Res
    
  }

}

Describe 'Issue #43: New-AtwsAttachment adds timezone difference twice ' {}

Describe 'Issue #42: 1.6.2.14: no valid module was found in any module directory ' {}

Describe 'Issue #41: Beta-module overwrites personal disk cache for release module ' {}

Describe 'Issue #40: Get-AtwsService - No Unit Count? ' {}

Describe 'Issue #39: New-AtwsData : Contracts of type 7 (Recurring Services) require a ContractPeriodType. ' {}

Describe 'Issue #38: Feature request: Make connection object available to advanced users duplicate enhancement ' {}

Describe 'Issue #37: Feature request: Attachments upload enhancement good first issue ' {}

Describe 'Issue #36: Date queries with multiple date fields return 0 objects ' {}

Describe 'Issue #35: How to access API methods directly with 1.6.2.x ' {}

Describe 'Issue #33: Updating Diskcache auto running at every import ' {}

Describe 'Issue #32: Suppress DATE and TIME warning enhancement ' {}

Describe 'Issue #31: No DefaultServiceDeskRoleID parameter on the Get-AtwsResource function ' {}

Describe 'Issue #30: Switch to skip ApiTrackingIdentifier for backward compatibility? ' {}

Describe 'Issue #29: Set-AtwsContact :: Cannot convert Parameter -id from int64[] to int64 bug ' {}


Describe 'Issue #28: Set-AtWsTicketCost - Update status ' {}

Describe 'Issue #27: Receiving Confirm prompts with $global:ConfirmPreference="None" ' {}


Describe 'Issue #26: Multiple errors and issues. ' {}

Describe 'Issue #25: Set-AtwsTicket.ps1 - int32[] to int64 conversion error ' {}


Describe 'Issue #24: Missing commands, e.g., *-AtwsTicket ' {}

Describe 'Issue #23: Help w/ picklists lookups in functions and scripts. ' {}

Describe 'Issue #22: UDF wildcard does not work ' {}

Describe 'Issue #21: New-AtwsContractServiceAdjustment: Get-AtwsData : This entity type does not support the query action. ' {}

Describe 'Issue #20: new-atwscontract: System.dateTime: Can not convert data to date in field ' {}

Describe 'Issue #19: Receiving this error when importing the Autotask Module. I am using an API User. ' {}

Describe 'Issue #18: The specified module was not loaded because no valid module file was found in any module directory. ' {}

Describe 'Issue #17: Running on Azure Runbooks (Cache) ' {}

Describe 'Issue #16: Always confirming the write of new autotask data. ' {}

Describe 'Issue #15: Date errors using filter ' {}

Describe 'Issue #14: Changing UDF ' {}

Describe 'Issue #11: Set "ServiceLevelAgreementID" on contract to nothing ' {}

Describe 'Issue #10: Unable to connect, as a "\" seems to be prepended ' {}

Describe 'Issue #9: DateTime conversions ' {}

Describe 'Issue #8: Set-AtwsAccount -TerritoryID <Integer> Fails  ' {}

Describe 'Issue #7: Get-AtwsTicket -SubIssueType not updating properly. ' {}
 
Describe 'Issue #4: Get / Set AccountManager field ' {}

Describe 'Issue #3: Value does not exist for the required field when using New-AtwsData -InputObject ' {}

Describe 'Issue #2: Filters with parenthesis no longer work ' {}


Describe 'Issue #1: Account where a certain field (int) is empty' {
  
}