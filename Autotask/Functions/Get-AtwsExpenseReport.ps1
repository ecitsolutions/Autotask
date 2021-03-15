#Requires -Version 5.0
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
Get-AtwsExpenseReport -Status <PickList Label>
Returns any ExpenseReports with property Status equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsExpenseReport -Status <PickList Label> -NotEquals Status 
Returns any ExpenseReports with property Status NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsExpenseReport -Status <PickList Label1>, <PickList Label2>
Returns any ExpenseReports with property Status equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsExpenseReport -Status <PickList Label1>, <PickList Label2> -NotEquals Status
Returns any ExpenseReports with property Status NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsExpenseReport -Id 1234 -ExpenseReportName SomeName* -Status <PickList Label1>, <PickList Label2> -Like ExpenseReportName -NotEquals Status -GreaterThan Id
An example of a more complex query. This command returns any ExpenseReports with Id GREATER THAN 1234, a ExpenseReportName that matches the simple pattern SomeName* AND that has a Status that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

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
    [Collections.Generic.List[string]]
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

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# Approved Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[datetime]]]
    $ApprovedDate,

# Approver ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $ApproverID,

# Business Division Subdivision ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $BusinessDivisionSubdivisionID,

# Cash Advance Amount
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $CashAdvanceAmount,

# Expense Total
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $ExpenseTotal,

# Expense Report ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[long]]]
    $id,

# Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [Collections.Generic.List[string]]
    $Name,

# Quick Books Reference Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [Collections.Generic.List[string]]
    $QuickBooksReferenceNumber,

# Reimbursement Currency Amount Due
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $ReimbursementCurrencyAmountDue,

# Reimbursement Currency Cash Advance Amount
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $ReimbursementCurrencyCashAdvanceAmount,

# Reimbursement Currency ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $ReimbursementCurrencyID,

# Rejection Reason
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,2048)]
    [Collections.Generic.List[string]]
    $RejectionReason,

# Status
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity ExpenseReport -FieldName Status -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity ExpenseReport -FieldName Status -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $Status,

# Submit Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[datetime]]]
    $SubmitDate,

# Submitter ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[Int]]]
    $SubmitterID,

# Period Ending
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[datetime]]]
    $WeekEnding,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ReimbursementCurrencyCashAdvanceAmount', 'ReimbursementCurrencyAmountDue', 'Name', 'QuickBooksReferenceNumber', 'ApproverID', 'ReimbursementCurrencyID', 'SubmitterID', 'Submit', 'id', 'DepartmentNumber', 'AmountDue', 'RejectionReason', 'ExpenseTotal', 'BusinessDivisionSubdivisionID', 'WeekEnding', 'Status', 'SubmitDate', 'ApprovedDate', 'CashAdvanceAmount')]
    [Collections.Generic.List[string]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ReimbursementCurrencyCashAdvanceAmount', 'ReimbursementCurrencyAmountDue', 'Name', 'QuickBooksReferenceNumber', 'ApproverID', 'ReimbursementCurrencyID', 'SubmitterID', 'Submit', 'id', 'DepartmentNumber', 'AmountDue', 'RejectionReason', 'ExpenseTotal', 'BusinessDivisionSubdivisionID', 'WeekEnding', 'Status', 'SubmitDate', 'ApprovedDate', 'CashAdvanceAmount')]
    [Collections.Generic.List[string]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ReimbursementCurrencyCashAdvanceAmount', 'ReimbursementCurrencyAmountDue', 'Name', 'QuickBooksReferenceNumber', 'ApproverID', 'ReimbursementCurrencyID', 'SubmitterID', 'Submit', 'id', 'DepartmentNumber', 'AmountDue', 'RejectionReason', 'ExpenseTotal', 'BusinessDivisionSubdivisionID', 'WeekEnding', 'Status', 'SubmitDate', 'ApprovedDate', 'CashAdvanceAmount')]
    [Collections.Generic.List[string]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Status', 'SubmitDate', 'SubmitterID', 'ApproverID', 'WeekEnding', 'ExpenseTotal', 'CashAdvanceAmount', 'RejectionReason', 'AmountDue', 'DepartmentNumber', 'QuickBooksReferenceNumber', 'ApprovedDate', 'ReimbursementCurrencyID', 'ReimbursementCurrencyCashAdvanceAmount', 'ReimbursementCurrencyAmountDue', 'BusinessDivisionSubdivisionID')]
    [Collections.Generic.List[string]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Status', 'SubmitDate', 'SubmitterID', 'ApproverID', 'WeekEnding', 'ExpenseTotal', 'CashAdvanceAmount', 'RejectionReason', 'AmountDue', 'DepartmentNumber', 'QuickBooksReferenceNumber', 'ApprovedDate', 'ReimbursementCurrencyID', 'ReimbursementCurrencyCashAdvanceAmount', 'ReimbursementCurrencyAmountDue', 'BusinessDivisionSubdivisionID')]
    [Collections.Generic.List[string]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Status', 'SubmitDate', 'SubmitterID', 'ApproverID', 'WeekEnding', 'ExpenseTotal', 'CashAdvanceAmount', 'RejectionReason', 'AmountDue', 'DepartmentNumber', 'QuickBooksReferenceNumber', 'ApprovedDate', 'ReimbursementCurrencyID', 'ReimbursementCurrencyCashAdvanceAmount', 'ReimbursementCurrencyAmountDue', 'BusinessDivisionSubdivisionID')]
    [Collections.Generic.List[string]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Status', 'SubmitDate', 'SubmitterID', 'ApproverID', 'WeekEnding', 'ExpenseTotal', 'CashAdvanceAmount', 'RejectionReason', 'AmountDue', 'DepartmentNumber', 'QuickBooksReferenceNumber', 'ApprovedDate', 'ReimbursementCurrencyID', 'ReimbursementCurrencyCashAdvanceAmount', 'ReimbursementCurrencyAmountDue', 'BusinessDivisionSubdivisionID')]
    [Collections.Generic.List[string]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'RejectionReason', 'DepartmentNumber', 'QuickBooksReferenceNumber')]
    [Collections.Generic.List[string]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'RejectionReason', 'DepartmentNumber', 'QuickBooksReferenceNumber')]
    [Collections.Generic.List[string]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'RejectionReason', 'DepartmentNumber', 'QuickBooksReferenceNumber')]
    [Collections.Generic.List[string]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'RejectionReason', 'DepartmentNumber', 'QuickBooksReferenceNumber')]
    [Collections.Generic.List[string]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'RejectionReason', 'DepartmentNumber', 'QuickBooksReferenceNumber')]
    [Collections.Generic.List[string]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('SubmitDate', 'WeekEnding', 'ApprovedDate')]
    [Collections.Generic.List[string]]
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

        $result = [collections.generic.list[psobject]]::new()
        $iterations = [collections.generic.list[psobject]]::new()
    }


    process {
        # Parameterset Get_All has a single parameter: -All
        # Set the Filter manually to get every single object of this type
        if ($PSCmdlet.ParameterSetName -eq 'Get_all') {
            $Filter = @('id', '-ge', 0)
            $iterations.Add($Filter)
        }
        # So it is not -All. If Filter does not exist it has to be By_parameters
        elseif (-not ($Filter)) {

            Write-Debug ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)

           
            # Count the values of the first parameter passed. We will not try do to this on more than 1 parameter, nor on any 
            # other parameter than the first. This is lazy, but efficient.
            $count = $PSBoundParameters.Values[0].count

            # If the count is less than or equal to 200 we pass PSBoundParameters as is
            if ($count -le 200) {
                [collections.generic.list[string]]$Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $entityName
                $iterations.Add($Filter)
            }
            # More than 200 values. This will cause a SQL query nested too much. Break a single parameter
            # into segments and create multiple queries with max 200 values
            else {
                # Deduplicate the value list or the same ID may be included in more than 1 query
                $outerLoop = $PSBoundParameters.Values[0] | Sort-Object -Unique

                Write-Verbose ('{0}: Received {1} objects containing {2} unique values for parameter {3}' -f $MyInvocation.MyCommand.Name, $count, $outerLoop.Count, $param)

                # Make a writable copy of PSBoundParameters
                $BoundParameters = $PSBoundParameters
                for ($i = 0; $i -lt $outerLoop.count; $i += 200) {
                    $j = $i + 199
                    if ($j -ge $outerLoop.count) {
                        $j = $outerLoop.count - 1
                    }

                    # make a selection
                    $BoundParameters[$param] = $outerLoop[$i .. $j]

                    Write-Verbose ('{0}: Asking for {1} values {2} to {3}' -f $MyInvocation.MyCommand.Name, $param, $i, $j)

                    # Convert named parameters to a filter definition that can be parsed to QueryXML
                    [collections.generic.list[string]]$Filter = ConvertTo-AtwsFilter -BoundParameters $BoundParameters -EntityName $entityName
                    $iterations.Add($Filter)
                }
            }
        }
        # Not parameters, nor Get_all. There are only three parameter sets, so now we know
        # that we were passed a Filter
        else {

            Write-Debug ('{0}: Query based on manual filter, parsing' -F $MyInvocation.MyCommand.Name)

            # Parse the filter string and expand variables in _this_ scope (dot-sourcing)
            # or the variables will not be available and expansion will fail
            $Filter = . Update-AtwsFilter -Filterstring $Filter
            $iterations.Add($Filter)
        }

        # Prepare shouldProcess comments
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to query the Autotask Web API for {1}(s).' -F $caption, $entityName
        $verboseWarning = '{0}: About to query the Autotask Web API for {1}(s). Do you want to continue?' -F $caption, $entityName

        # Lets do it and say we didn't!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) {
            foreach ($Filter in $iterations) {

                try {
                    # Make the query and pass the optional parameters to Get-AtwsData
                    # Force list even if result is only 1 object to be compatible with addrange()
                    [collections.generic.list[psobject]]$response = Get-AtwsData -Entity $entityName -Filter $Filter `
                        -NoPickListLabel:$NoPickListLabel.IsPresent `
                        -GetReferenceEntityById $GetReferenceEntityById
                }
                catch {
                    write-host "ERROR: " -ForegroundColor Red -NoNewline
                    write-host $_.Exception.Message
                    write-host ("{0}: {1}" -f $_.CategoryInfo.Category,$_.CategoryInfo.Reason) -ForegroundColor Cyan
                    $_.ScriptStackTrace -split '\n' | ForEach-Object {
                        Write-host "  |  " -ForegroundColor Cyan -NoNewline
                        Write-host $_
                    }
                }
                # Add response to result
                $result.AddRange($response)

                Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $result.Count)
            }
        }
    }

    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        if ($result) {
            Return [array]$result
        }
    }


}