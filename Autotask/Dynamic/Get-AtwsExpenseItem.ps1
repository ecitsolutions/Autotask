#Requires -Version 4.0
#Version 1.6.2.12
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsExpenseItem
{


<#
.SYNOPSIS
This function get one or more ExpenseItem through the Autotask Web Services API.
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

ExpenseCategory
 

WorkType
 

PaymentType
 

Entities that have fields that refer to the base entity of this CmdLet:

BillingItem

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.ExpenseItem[]]. This function outputs the Autotask.ExpenseItem that was returned by the API.
.EXAMPLE
Get-AtwsExpenseItem -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsExpenseItem -ExpenseItemName SomeName
Returns the object with ExpenseItemName 'SomeName', if any.
 .EXAMPLE
Get-AtwsExpenseItem -ExpenseItemName 'Some Name'
Returns the object with ExpenseItemName 'Some Name', if any.
 .EXAMPLE
Get-AtwsExpenseItem -ExpenseItemName 'Some Name' -NotEquals ExpenseItemName
Returns any objects with a ExpenseItemName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsExpenseItem -ExpenseItemName SomeName* -Like ExpenseItemName
Returns any object with a ExpenseItemName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsExpenseItem -ExpenseItemName SomeName* -NotLike ExpenseItemName
Returns any object with a ExpenseItemName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsExpenseItem -ExpenseCategory <PickList Label>
Returns any ExpenseItems with property ExpenseCategory equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsExpenseItem -ExpenseCategory <PickList Label> -NotEquals ExpenseCategory 
Returns any ExpenseItems with property ExpenseCategory NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsExpenseItem -ExpenseCategory <PickList Label1>, <PickList Label2>
Returns any ExpenseItems with property ExpenseCategory equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsExpenseItem -ExpenseCategory <PickList Label1>, <PickList Label2> -NotEquals ExpenseCategory
Returns any ExpenseItems with property ExpenseCategory NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsExpenseItem -Id 1234 -ExpenseItemName SomeName* -ExpenseCategory <PickList Label1>, <PickList Label2> -Like ExpenseItemName -NotEquals ExpenseCategory -GreaterThan Id
An example of a more complex query. This command returns any ExpenseItems with Id GREATER THAN 1234, a ExpenseItemName that matches the simple pattern SomeName* AND that has a ExpenseCategory that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsExpenseItem
 .LINK
Set-AtwsExpenseItem

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
    [ValidateSet('AccountID', 'ExpenseCurrencyID', 'ExpenseReportID', 'ProjectID', 'TaskID', 'TicketID')]
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
    [ValidateSet('BillingItem:ExpenseItemID')]
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

# Expense Item ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Expense Report ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $ExpenseReportID,

# Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,128)]
    [string[]]
    $Description,

# Expense Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $ExpenseDate,

# Expense Category
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $ExpenseCategory,

# Work Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $WorkType,

# Expense Amount
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $ExpenseAmount,

# Payment Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $PaymentType,

# Have Receipt
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $HaveReceipt,

# Billable To Account
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $BillableToAccount,

# Account ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $AccountID,

# Project ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ProjectID,

# Task ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $TaskID,

# Ticket ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $TicketID,

# Entertainment Location
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [string[]]
    $EntertainmentLocation,

# Miles
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $Miles,

# Origin
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [string[]]
    $Origin,

# Destination
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [string[]]
    $Destination,

# purchase_order_number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $PurchaseOrderNumber,

# Odometer Start
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $OdometerStart,

# Odometer End
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $OdometerEnd,

# Currency ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ExpenseCurrencyID,

# Receipt Amount
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $ReceiptAmount,

# Reimbursement Amount
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $ReimbursementAmount,

# Reimbursement Currency Reimbursement Amount
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $ReimbursementCurrencyReimbursementAmount,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ExpenseReportID', 'Description', 'ExpenseDate', 'ExpenseCategory', 'WorkType', 'ExpenseAmount', 'PaymentType', 'HaveReceipt', 'BillableToAccount', 'AccountID', 'ProjectID', 'TaskID', 'TicketID', 'EntertainmentLocation', 'Miles', 'Origin', 'Destination', 'PurchaseOrderNumber', 'OdometerStart', 'OdometerEnd', 'ExpenseCurrencyID', 'ReceiptAmount', 'ReimbursementAmount', 'ReimbursementCurrencyReimbursementAmount')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ExpenseReportID', 'Description', 'ExpenseDate', 'ExpenseCategory', 'WorkType', 'ExpenseAmount', 'PaymentType', 'HaveReceipt', 'BillableToAccount', 'AccountID', 'ProjectID', 'TaskID', 'TicketID', 'EntertainmentLocation', 'Miles', 'Origin', 'Destination', 'PurchaseOrderNumber', 'OdometerStart', 'OdometerEnd', 'ExpenseCurrencyID', 'ReceiptAmount', 'ReimbursementAmount', 'ReimbursementCurrencyReimbursementAmount')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ExpenseReportID', 'Description', 'ExpenseDate', 'ExpenseCategory', 'WorkType', 'ExpenseAmount', 'PaymentType', 'HaveReceipt', 'BillableToAccount', 'AccountID', 'ProjectID', 'TaskID', 'TicketID', 'EntertainmentLocation', 'Miles', 'Origin', 'Destination', 'PurchaseOrderNumber', 'OdometerStart', 'OdometerEnd', 'ExpenseCurrencyID', 'ReceiptAmount', 'ReimbursementAmount', 'ReimbursementCurrencyReimbursementAmount')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ExpenseReportID', 'Description', 'ExpenseDate', 'ExpenseCategory', 'WorkType', 'ExpenseAmount', 'PaymentType', 'AccountID', 'ProjectID', 'TaskID', 'TicketID', 'EntertainmentLocation', 'Miles', 'Origin', 'Destination', 'PurchaseOrderNumber', 'OdometerStart', 'OdometerEnd', 'ExpenseCurrencyID', 'ReceiptAmount', 'ReimbursementAmount', 'ReimbursementCurrencyReimbursementAmount')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ExpenseReportID', 'Description', 'ExpenseDate', 'ExpenseCategory', 'WorkType', 'ExpenseAmount', 'PaymentType', 'AccountID', 'ProjectID', 'TaskID', 'TicketID', 'EntertainmentLocation', 'Miles', 'Origin', 'Destination', 'PurchaseOrderNumber', 'OdometerStart', 'OdometerEnd', 'ExpenseCurrencyID', 'ReceiptAmount', 'ReimbursementAmount', 'ReimbursementCurrencyReimbursementAmount')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ExpenseReportID', 'Description', 'ExpenseDate', 'ExpenseCategory', 'WorkType', 'ExpenseAmount', 'PaymentType', 'AccountID', 'ProjectID', 'TaskID', 'TicketID', 'EntertainmentLocation', 'Miles', 'Origin', 'Destination', 'PurchaseOrderNumber', 'OdometerStart', 'OdometerEnd', 'ExpenseCurrencyID', 'ReceiptAmount', 'ReimbursementAmount', 'ReimbursementCurrencyReimbursementAmount')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ExpenseReportID', 'Description', 'ExpenseDate', 'ExpenseCategory', 'WorkType', 'ExpenseAmount', 'PaymentType', 'AccountID', 'ProjectID', 'TaskID', 'TicketID', 'EntertainmentLocation', 'Miles', 'Origin', 'Destination', 'PurchaseOrderNumber', 'OdometerStart', 'OdometerEnd', 'ExpenseCurrencyID', 'ReceiptAmount', 'ReimbursementAmount', 'ReimbursementCurrencyReimbursementAmount')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'EntertainmentLocation', 'Origin', 'Destination', 'PurchaseOrderNumber')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'EntertainmentLocation', 'Origin', 'Destination', 'PurchaseOrderNumber')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'EntertainmentLocation', 'Origin', 'Destination', 'PurchaseOrderNumber')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'EntertainmentLocation', 'Origin', 'Destination', 'PurchaseOrderNumber')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'EntertainmentLocation', 'Origin', 'Destination', 'PurchaseOrderNumber')]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('ExpenseDate')]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'ExpenseItem'
    
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
      $Result = Get-AtwsData -Entity $EntityName -Filter $Filter
    

      Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $Result.Count)
    
      # Datetimeparameters
      $Fields = Get-AtwsFieldInfo -Entity $EntityName
    
      # Should we return an indirect object?
      if ( ($Result) -and ($GetReferenceEntityById))
      {
        Write-Debug ('{0}: User has asked for external reference objects by {1}' -F $MyInvocation.MyCommand.Name, $GetReferenceEntityById)
      
        $Field = $Fields.Where({$_.Name -eq $GetReferenceEntityById})
        $ResultValues = $Result | Where-Object {$null -ne $_.$GetReferenceEntityById}
        If ($ResultValues.Count -lt $Result.Count)
        {
          Write-Warning ('{0}: Only {1} of the {2}s in the primary query had a value in the property {3}.' -F $MyInvocation.MyCommand.Name, 
            $ResultValues.Count,
            $EntityName,
          $GetReferenceEntityById) -WarningAction Continue
        }
        $Filter = 'id -eq {0}' -F $($ResultValues.$GetReferenceEntityById -join ' -or id -eq ')
        $Result = Get-Atwsdata -Entity $Field.ReferenceEntityType -Filter $Filter
      }
      ElseIf ( ($Result) -and ($GetExternalEntityByThisEntityId))
      {
        Write-Debug ('{0}: User has asked for {1} that are referencing this result' -F $MyInvocation.MyCommand.Name, $GetExternalEntityByThisEntityId)
        $ReferenceInfo = $GetExternalEntityByThisEntityId -Split ':'
        $Filter = '{0} -eq {1}' -F $ReferenceInfo[1], $($Result.id -join (' -or {0}id -eq ' -F $ReferenceInfo[1]))
        $Result = Get-Atwsdata -Entity $ReferenceInfo[0] -Filter $Filter
      }
      # Do the user want labels along with index values for Picklists?
      ElseIf ( ($Result) -and -not ($NoPickListLabel))
      {
        Foreach ($Field in $Fields.Where{$_.IsPickList})
        {
          $FieldName = '{0}Label' -F $Field.Name
          Foreach ($Item in $Result)
          {
            $Value = ($Field.PickListValues.Where{$_.Value -eq $Item.$($Field.Name)}).Label
            Add-Member -InputObject $Item -MemberType NoteProperty -Name $FieldName -Value $Value -Force
          
          }
        }
      }
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
