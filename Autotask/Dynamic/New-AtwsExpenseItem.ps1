#Requires -Version 4.0
#Version 1.6.2.15
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function New-AtwsExpenseItem
{


<#
.SYNOPSIS
This function creates a new ExpenseItem through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.ExpenseItem] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the ExpenseItem with Id number 0 you could write 'New-AtwsExpenseItem -Id 0' or you could write 'New-AtwsExpenseItem -Filter {Id -eq 0}.

'New-AtwsExpenseItem -Id 0,4' could be written as 'New-AtwsExpenseItem -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new ExpenseItem you need the following required fields:
 -ExpenseReportID
 -Description
 -ExpenseDate
 -ExpenseCategory
 -PaymentType
 -HaveReceipt
 -BillableToAccount

Entities that have fields that refer to the base entity of this CmdLet:

BillingItem

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.ExpenseItem]. This function outputs the Autotask.ExpenseItem that was created by the API.
.EXAMPLE
$Result = New-AtwsExpenseItem -ExpenseReportID [Value] -Description [Value] -ExpenseDate [Value] -ExpenseCategory [Value] -PaymentType [Value] -HaveReceipt [Value] -BillableToAccount [Value]
Creates a new [Autotask.ExpenseItem] through the Web Services API and returns the new object.
 .EXAMPLE
$Result = Get-AtwsExpenseItem -Id 124 | New-AtwsExpenseItem 
Copies [Autotask.ExpenseItem] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsExpenseItem -Id 124 | New-AtwsExpenseItem | Set-AtwsExpenseItem -ParameterName <Parameter Value>
Copies [Autotask.ExpenseItem] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsExpenseItem to modify the object.
 .EXAMPLE
$Result = Get-AtwsExpenseItem -Id 124 | New-AtwsExpenseItem | Set-AtwsExpenseItem -ParameterName <Parameter Value> -Passthru
Copies [Autotask.ExpenseItem] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsExpenseItem to modify the object and returns the new object.

.LINK
Get-AtwsExpenseItem
 .LINK
Set-AtwsExpenseItem

#>

  [CmdLetBinding(SupportsShouldProcess = $True, DefaultParameterSetName='By_parameters', ConfirmImpact='Low')]
  Param
  (
# An array of objects to create
    [Parameter(
      ParameterSetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.ExpenseItem[]]
    $InputObject,

# Expense Report ID
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $ExpenseReportID,

# Description
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,128)]
    [string]
    $Description,

# Expense Date
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $ExpenseDate,

# Expense Category
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String]
    $ExpenseCategory,

# GL Code
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,20)]
    [string]
    $GLCode,

# Work Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $WorkType,

# Expense Amount
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $ExpenseAmount,

# Payment Type
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String]
    $PaymentType,

# Reimbursable
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean]
    $Reimbursable,

# Have Receipt
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [boolean]
    $HaveReceipt,

# Billable To Account
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [boolean]
    $BillableToAccount,

# Account ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $AccountID,

# Project ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $ProjectID,

# Task ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $TaskID,

# Ticket ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $TicketID,

# Entertainment Location
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [string]
    $EntertainmentLocation,

# Miles
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $Miles,

# Origin
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [string]
    $Origin,

# Destination
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [string]
    $Destination,

# Rejected
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean]
    $Rejected,

# purchase_order_number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $PurchaseOrderNumber,

# Odometer Start
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $OdometerStart,

# Odometer End
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $OdometerEnd,

# Currency ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $ExpenseCurrencyID,

# Receipt Amount
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $ReceiptAmount,

# Reimbursement Amount
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $ReimbursementAmount,

# Reimbursement Currency Reimbursement Amount
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $ReimbursementCurrencyReimbursementAmount
  )
 
  Begin
  { 
    $EntityName = 'ExpenseItem'
           
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
    $ProcessObject = @()
  }

  Process
  {
    $Fields = Get-AtwsFieldInfo -Entity $EntityName
    
    If ($InputObject)
    {
      Write-Verbose ('{0}: Copy Object mode: Setting ID property to zero' -F $MyInvocation.MyCommand.Name)  
      
      $CopyNo = 1

      Foreach ($Object in $InputObject) 
      { 
        # Create a new object and copy properties
        $NewObject = New-Object Autotask.$EntityName
        
        # Copy every non readonly property
        $FieldNames = $Fields.Where({$_.Name -ne 'id'}).Name
        If ($PSBoundParameters.ContainsKey('UserDefinedFields')) {
          $FieldNames += 'UserDefinedFields'
        }
        Foreach ($Field in $FieldNames)
        {
          $NewObject.$Field = $Object.$Field
        }
        If ($NewObject -is [Autotask.Ticket])
        {
          Write-Verbose ('{0}: Copy Object mode: Object is a Ticket. Title must be modified to avoid duplicate detection.' -F $MyInvocation.MyCommand.Name)  
          $Title = '{0} (Copy {1})' -F $NewObject.Title, $CopyNo
          $CopyNo++
          $NewObject.Title = $Title
        }
        $ProcessObject += $NewObject
      }   
    }
    Else
    {
      Write-Debug ('{0}: Creating empty [Autotask.{1}]' -F $MyInvocation.MyCommand.Name, $EntityName) 
      $ProcessObject += New-Object Autotask.$EntityName    
    }
    
    Foreach ($Parameter in $PSBoundParameters.GetEnumerator())
    {
      $Field = $Fields | Where-Object {$_.Name -eq $Parameter.Key}
      If ($Field -or $Parameter.Key -eq 'UserDefinedFields')
      { 
        If ($Field.IsPickList)
        {
          If($Field.PickListParentValueField)
          {
            $ParentField = $Fields.Where{$_.Name -eq $Field.PickListParentValueField}
            $ParentLabel = $PSBoundParameters.$($ParentField.Name)
            $ParentValue = $ParentField.PickListValues | Where-Object {$_.Label -eq $ParentLabel}
            $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $Parameter.Value -and $_.ParentValue -eq $ParentValue.Value}                
          }
          Else 
          { 
            $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $Parameter.Value}
          }
          $Value = $PickListValue.Value
        }
        Else
        {
          $Value = $Parameter.Value
        } 

        Foreach ($Object in $ProcessObject) 
        { 
          $Object.$($Parameter.Key) = $Value
        }
      }
    }   
     
    $Caption = $MyInvocation.MyCommand.Name
    $VerboseDescrition = '{0}: About to create {1} {2}(s). This action cannot be undone.' -F $Caption, $ProcessObject.Count, $EntityName
    $VerboseWarning = '{0}: About to create {1} {2}(s). This action may not be undoable. Do you want to continue?' -F $Caption, $ProcessObject.Count, $EntityName

    If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
      $Result = New-AtwsData -Entity $ProcessObject
    }
  }

  End
  {
    Write-Debug ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $Result.count, $EntityName)
    Return $Result
  }

}
