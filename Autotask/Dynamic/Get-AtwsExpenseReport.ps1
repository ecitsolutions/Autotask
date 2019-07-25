#Requires -Version 4.0
#Version 1.6.2.17
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsExpenseReport
{


<#
.SYNOPSIS
This function get one or more ExpenseReport through the Autotask Web Services API.
.DESCRIPTION
This function creates a query based on any parameters you give and returns any resulting objects from the Autotask Web Services Api. By default the function returns any objects with properties that are Equal (-eq) to the value of the parameter. To give you more flexibility you can modify the operator by using -NotEquals [ParameterName[]], -LessThan [ParameterName[]] and so on.

Possible operators for all parameters are:
 -NotEquals
 -GreaterThan
 -GreaterThanOrEqual
 -LessThan
 -LessThanOrEquals 

Additional operators for [String] parameters are:
 -Like (supports * or % as wildcards)
 -NotLike
 -BeginsWith
 -EndsWith
 -Contains

Properties with picklists are:

Status
 

Entities that have fields that refer to the base entity of this CmdLet:

ExpenseItem

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.ExpenseReport[]]. This function outputs the Autotask.ExpenseReport that was returned by the API.
.EXAMPLE
Get-AtwsExpenseReport -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsExpenseReport -ExpenseReportName SomeName
Returns the object with ExpenseReportName 'SomeName', if any.
 .EXAMPLE
Get-AtwsExpenseReport -ExpenseReportName 'Some Name'
Returns the object with ExpenseReportName 'Some Name', if any.
 .EXAMPLE
Get-AtwsExpenseReport -ExpenseReportName 'Some Name' -NotEquals ExpenseReportName
Returns any objects with a ExpenseReportName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsExpenseReport -ExpenseReportName SomeName* -Like ExpenseReportName
Returns any object with a ExpenseReportName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsExpenseReport -ExpenseReportName SomeName* -NotLike ExpenseReportName
Returns any object with a ExpenseReportName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsExpenseReport -S <PickList Label>
Returns any ExpenseReports with property S equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsExpenseReport -S <PickList Label> -NotEquals S 
Returns any ExpenseReports with property S NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsExpenseReport -S <PickList Label1>, <PickList Label2>
Returns any ExpenseReports with property S equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsExpenseReport -S <PickList Label1>, <PickList Label2> -NotEquals S
Returns any ExpenseReports with property S NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsExpenseReport -Id 1234 -ExpenseReportName SomeName* -S <PickList Label1>, <PickList Label2> -Like ExpenseReportName -NotEquals S -GreaterThan Id
An example of a more complex query. This command returns any ExpenseReports with Id GREATER THAN 1234, a ExpenseReportName that matches the simple pattern SomeName* AND that has a S that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsExpenseReport
 .LINK
Set-AtwsExpenseReport

#>

  [CmdLetBinding(SupportsShouldProcess = $True, DefaultParameterSetName='Filter', ConfirmImpact='None')]
  Param
  (
# A filter that limits the number of objects that is returned from the API
    [Parameter(
      Mandatory = $true,
      ValueFromRemainingArguments = $true,
      ParameterSetName = 'Filter'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $Filter,

# Follow this external ID and return any external objects
    [Parameter(
      ParameterSetName = 'Filter'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Alias('GetRef')]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('ApproverID', 'BusinessDivisionSubdivisionID', 'ReimbursementCurrencyID', 'SubmitterID')]
    [String]
    $GetReferenceEntityById,

# Return entities of selected type that are referencing to this entity.
    [Parameter(
      ParameterSetName = 'Filter'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Alias('External')]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('ExpenseItem:ExpenseReportID')]
    [String]
    $GetExternalEntityByThisEntityId,

# Return all objects in one query
    [Parameter(
      ParameterSetName = 'Get_all'
    )]
    [Switch]
    $All,

# Do not add descriptions for all picklist attributes with values
    [Parameter(
      ParameterSetName = 'Filter'
    )]
    [Parameter(
      ParameterSetName = 'Get_all'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Switch]
    $NoPickListLabel,

# Expense Report ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [string[]]
    $Name,

# Status
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $Status,

# Submit Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $SubmitDate,

# Submitter ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $SubmitterID,

# Approver ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ApproverID,

# Period Ending
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $WeekEnding,

# Expense Total
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $ExpenseTotal,

# Cash Advance Amount
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $CashAdvanceAmount,

# Rejection Reason
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,2048)]
    [string[]]
    $RejectionReason,

# Quick Books Reference Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $QuickBooksReferenceNumber,

# Approved Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ApprovedDate,

# Reimbursement Currency ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ReimbursementCurrencyID,

# Reimbursement Currency Cash Advance Amount
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $ReimbursementCurrencyCashAdvanceAmount,

# Reimbursement Currency Amount Due
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $ReimbursementCurrencyAmountDue,

# Business Division Subdivision ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BusinessDivisionSubdivisionID,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Status', 'SubmitDate', 'SubmitterID', 'ApproverID', 'WeekEnding', 'ExpenseTotal', 'CashAdvanceAmount', 'RejectionReason', 'QuickBooksReferenceNumber', 'ApprovedDate', 'ReimbursementCurrencyID', 'ReimbursementCurrencyCashAdvanceAmount', 'ReimbursementCurrencyAmountDue', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Status', 'SubmitDate', 'SubmitterID', 'ApproverID', 'WeekEnding', 'ExpenseTotal', 'CashAdvanceAmount', 'RejectionReason', 'QuickBooksReferenceNumber', 'ApprovedDate', 'ReimbursementCurrencyID', 'ReimbursementCurrencyCashAdvanceAmount', 'ReimbursementCurrencyAmountDue', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Status', 'SubmitDate', 'SubmitterID', 'ApproverID', 'WeekEnding', 'ExpenseTotal', 'CashAdvanceAmount', 'RejectionReason', 'QuickBooksReferenceNumber', 'ApprovedDate', 'ReimbursementCurrencyID', 'ReimbursementCurrencyCashAdvanceAmount', 'ReimbursementCurrencyAmountDue', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Status', 'SubmitDate', 'SubmitterID', 'ApproverID', 'WeekEnding', 'ExpenseTotal', 'CashAdvanceAmount', 'RejectionReason', 'QuickBooksReferenceNumber', 'ApprovedDate', 'ReimbursementCurrencyID', 'ReimbursementCurrencyCashAdvanceAmount', 'ReimbursementCurrencyAmountDue', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Status', 'SubmitDate', 'SubmitterID', 'ApproverID', 'WeekEnding', 'ExpenseTotal', 'CashAdvanceAmount', 'RejectionReason', 'QuickBooksReferenceNumber', 'ApprovedDate', 'ReimbursementCurrencyID', 'ReimbursementCurrencyCashAdvanceAmount', 'ReimbursementCurrencyAmountDue', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Status', 'SubmitDate', 'SubmitterID', 'ApproverID', 'WeekEnding', 'ExpenseTotal', 'CashAdvanceAmount', 'RejectionReason', 'QuickBooksReferenceNumber', 'ApprovedDate', 'ReimbursementCurrencyID', 'ReimbursementCurrencyCashAdvanceAmount', 'ReimbursementCurrencyAmountDue', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Status', 'SubmitDate', 'SubmitterID', 'ApproverID', 'WeekEnding', 'ExpenseTotal', 'CashAdvanceAmount', 'RejectionReason', 'QuickBooksReferenceNumber', 'ApprovedDate', 'ReimbursementCurrencyID', 'ReimbursementCurrencyCashAdvanceAmount', 'ReimbursementCurrencyAmountDue', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'RejectionReason', 'QuickBooksReferenceNumber')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'RejectionReason', 'QuickBooksReferenceNumber')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'RejectionReason', 'QuickBooksReferenceNumber')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'RejectionReason', 'QuickBooksReferenceNumber')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'RejectionReason', 'QuickBooksReferenceNumber')]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('SubmitDate', 'WeekEnding', 'ApprovedDate')]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'ExpenseReport'
    
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
  }


  Process
  {
    If ($PSCmdlet.ParameterSetName -eq 'Get_all')
    { 
      $Filter = @('id', '-ge', 0)
    }
    ElseIf (-not ($Filter)) {
    
      Write-Debug ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)
      
      # Convert named parameters to a filter definition that can be parsed to QueryXML
      $Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $EntityName
    }
    Else {
      
      Write-Debug ('{0}: Query based on manual filter, parsing' -F $MyInvocation.MyCommand.Name)
              
      $Filter = . Update-AtwsFilter -FilterString $Filter
    } 

    $Caption = $MyInvocation.MyCommand.Name
    $VerboseDescrition = '{0}: About to query the Autotask Web API for {1}(s).' -F $Caption, $EntityName
    $VerboseWarning = '{0}: About to query the Autotask Web API for {1}(s). Do you want to continue?' -F $Caption, $EntityName
    
    If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
    
      # Make the query and pass the optional parameters to Get-AtwsData
      $Result = Get-AtwsData -Entity $EntityName -Filter $Filter `
        -NoPickListLabel:$NoPickListLabel.IsPresent `
        -GetReferenceEntityById $GetReferenceEntityById `
        -GetExternalEntityByThisEntityId $GetExternalEntityByThisEntityId
    
      Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $Result.Count)

    }
  }

  End
  {
    Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    If ($Result)
    {
      Return $Result
    }
  }


}
