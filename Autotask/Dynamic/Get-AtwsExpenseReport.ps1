#Requires -Version 4.0
#Version 1.6.9
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
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

Additional operators for [string] parameters are:
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

  [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName='Filter', ConfirmImpact='None')]
  Param
  (
# A filter that limits the number of objects that is returned from the API
    [Parameter(
      Mandatory = $true,
      ValueFromRemainingArguments = $true,
      ParametersetName = 'Filter'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Filter,

# Follow this external ID and return any external objects
    [Parameter(
      ParametersetName = 'Filter'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('GetRef')]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('ApproverID', 'BusinessDivisionSubdivisionID', 'ReimbursementCurrencyID', 'SubmitterID')]
    [string]
    $GetReferenceEntityById,

# Return entities of selected type that are referencing to this entity.
    [Parameter(
      ParametersetName = 'Filter'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('External')]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('ExpenseItem:ExpenseReportID')]
    [string]
    $GetExternalEntityByThisEntityId,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# Expense Report ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [string[]]
    $Name,

# Status
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $Status,

# Submit Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $SubmitDate,

# Submitter ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $SubmitterID,

# Approver ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ApproverID,

# Period Ending
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $WeekEnding,

# Expense Total
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $ExpenseTotal,

# Cash Advance Amount
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $CashAdvanceAmount,

# Rejection Reason
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,2048)]
    [string[]]
    $RejectionReason,

# Quick Books Reference Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $QuickBooksReferenceNumber,

# Approved Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ApprovedDate,

# Reimbursement Currency ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ReimbursementCurrencyID,

# Reimbursement Currency Cash Advance Amount
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $ReimbursementCurrencyCashAdvanceAmount,

# Reimbursement Currency Amount Due
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $ReimbursementCurrencyAmountDue,

# Business Division Subdivision ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BusinessDivisionSubdivisionID,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Status', 'SubmitDate', 'SubmitterID', 'ApproverID', 'WeekEnding', 'ExpenseTotal', 'CashAdvanceAmount', 'RejectionReason', 'QuickBooksReferenceNumber', 'ApprovedDate', 'ReimbursementCurrencyID', 'ReimbursementCurrencyCashAdvanceAmount', 'ReimbursementCurrencyAmountDue', 'BusinessDivisionSubdivisionID')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Status', 'SubmitDate', 'SubmitterID', 'ApproverID', 'WeekEnding', 'ExpenseTotal', 'CashAdvanceAmount', 'RejectionReason', 'QuickBooksReferenceNumber', 'ApprovedDate', 'ReimbursementCurrencyID', 'ReimbursementCurrencyCashAdvanceAmount', 'ReimbursementCurrencyAmountDue', 'BusinessDivisionSubdivisionID')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Status', 'SubmitDate', 'SubmitterID', 'ApproverID', 'WeekEnding', 'ExpenseTotal', 'CashAdvanceAmount', 'RejectionReason', 'QuickBooksReferenceNumber', 'ApprovedDate', 'ReimbursementCurrencyID', 'ReimbursementCurrencyCashAdvanceAmount', 'ReimbursementCurrencyAmountDue', 'BusinessDivisionSubdivisionID')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Status', 'SubmitDate', 'SubmitterID', 'ApproverID', 'WeekEnding', 'ExpenseTotal', 'CashAdvanceAmount', 'RejectionReason', 'QuickBooksReferenceNumber', 'ApprovedDate', 'ReimbursementCurrencyID', 'ReimbursementCurrencyCashAdvanceAmount', 'ReimbursementCurrencyAmountDue', 'BusinessDivisionSubdivisionID')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Status', 'SubmitDate', 'SubmitterID', 'ApproverID', 'WeekEnding', 'ExpenseTotal', 'CashAdvanceAmount', 'RejectionReason', 'QuickBooksReferenceNumber', 'ApprovedDate', 'ReimbursementCurrencyID', 'ReimbursementCurrencyCashAdvanceAmount', 'ReimbursementCurrencyAmountDue', 'BusinessDivisionSubdivisionID')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Status', 'SubmitDate', 'SubmitterID', 'ApproverID', 'WeekEnding', 'ExpenseTotal', 'CashAdvanceAmount', 'RejectionReason', 'QuickBooksReferenceNumber', 'ApprovedDate', 'ReimbursementCurrencyID', 'ReimbursementCurrencyCashAdvanceAmount', 'ReimbursementCurrencyAmountDue', 'BusinessDivisionSubdivisionID')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Status', 'SubmitDate', 'SubmitterID', 'ApproverID', 'WeekEnding', 'ExpenseTotal', 'CashAdvanceAmount', 'RejectionReason', 'QuickBooksReferenceNumber', 'ApprovedDate', 'ReimbursementCurrencyID', 'ReimbursementCurrencyCashAdvanceAmount', 'ReimbursementCurrencyAmountDue', 'BusinessDivisionSubdivisionID')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'RejectionReason', 'QuickBooksReferenceNumber')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'RejectionReason', 'QuickBooksReferenceNumber')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'RejectionReason', 'QuickBooksReferenceNumber')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'RejectionReason', 'QuickBooksReferenceNumber')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'RejectionReason', 'QuickBooksReferenceNumber')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('SubmitDate', 'WeekEnding', 'ApprovedDate')]
    [string[]]
    $IsThisDay
  )

    begin { 
        $entityName = 'ExpenseReport'
    
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {
            $DebugPreference = 'Continue' 
        }
        else {
            # Respect configured preference
            $DebugPreference = $Script:Atws.Configuration.DebugPref
        }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

        if (!($PSCmdlet.MyInvocation.BoundParameters['Verbose'].IsPresent)) {
            # No local override of central preference. Load central preference
            $VerbosePreference = $Script:Atws.Configuration.VerbosePref
        }
    
    }


    process {
        # Parameterset Get_All has a single parameter: -All
        # Set the Filter manually to get every single object of this type 
        if ($PSCmdlet.ParameterSetName -eq 'Get_all') { 
            $Filter = @('id', '-ge', 0)
        }
        # So it is not -All. If Filter does not exist it has to be By_parameters
        elseif (-not ($Filter)) {
    
            Write-Debug ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)
      
            # Convert named parameters to a filter definition that can be parsed to QueryXML
            [string[]]$Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $entityName
        }
        # Not parameters, nor Get_all. There are only three parameter sets, so now we know
        # that we were passed a Filter
        else {
      
            Write-Debug ('{0}: Query based on manual filter, parsing' -F $MyInvocation.MyCommand.Name)
            
            # Parse the filter string and expand variables in _this_ scope (dot-sourcing)
            # or the variables will not be available and expansion will fail
            $Filter = . Update-AtwsFilter -Filterstring $Filter
        } 

        # Prepare shouldProcess comments
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to query the Autotask Web API for {1}(s).' -F $caption, $entityName
        $verboseWarning = '{0}: About to query the Autotask Web API for {1}(s). Do you want to continue?' -F $caption, $entityName
    
        # Lets do it and say we didn't!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
    
            # Make the query and pass the optional parameters to Get-AtwsData
            $result = Get-AtwsData -Entity $entityName -Filter $Filter `
                -NoPickListLabel:$NoPickListLabel.IsPresent `
                -GetReferenceEntityById $GetReferenceEntityById `
                -GetExternalEntityByThisEntityId $GetExternalEntityByThisEntityId
    
            Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $result.Count)

        }
    }

    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        if ($result) {
            Return $result
        }
    }


}
