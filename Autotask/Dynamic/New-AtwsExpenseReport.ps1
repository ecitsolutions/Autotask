#Requires -Version 4.0
#Version 1.6.2.9
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function New-AtwsExpenseReport
{


<#
.SYNOPSIS
This function creates a new ExpenseReport through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.ExpenseReport] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the ExpenseReport with Id number 0 you could write 'New-AtwsExpenseReport -Id 0' or you could write 'New-AtwsExpenseReport -Filter {Id -eq 0}.

'New-AtwsExpenseReport -Id 0,4' could be written as 'New-AtwsExpenseReport -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new ExpenseReport you need the following required fields:
 -Name
 -SubmitterID
 -WeekEnding

Entities that have fields that refer to the base entity of this CmdLet:

ExpenseItem

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.ExpenseReport]. This function outputs the Autotask.ExpenseReport that was created by the API.
.EXAMPLE
$Result = New-AtwsExpenseReport -Name [Value] -SubmitterID [Value] -WeekEnding [Value]
Creates a new [Autotask.ExpenseReport] through the Web Services API and returns the new object.
 .EXAMPLE
$Result = Get-AtwsExpenseReport -Id 124 | New-AtwsExpenseReport 
Copies [Autotask.ExpenseReport] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsExpenseReport -Id 124 | New-AtwsExpenseReport | Set-AtwsExpenseReport -ParameterName <Parameter Value>
Copies [Autotask.ExpenseReport] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsExpenseReport to modify the object.
 .EXAMPLE
$Result = Get-AtwsExpenseReport -Id 124 | New-AtwsExpenseReport | Set-AtwsExpenseReport -ParameterName <Parameter Value> -Passthru
Copies [Autotask.ExpenseReport] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsExpenseReport to modify the object and returns the new object.

.LINK
Get-AtwsExpenseReport
 .LINK
Set-AtwsExpenseReport

#>

  [CmdLetBinding(DefaultParameterSetName='By_parameters', ConfirmImpact='Low')]
  Param
  (
# An array of objects to create
    [Parameter(
      ParameterSetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.ExpenseReport[]]
    $InputObject,

# Name
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1,100)]
    [string]
    $Name,

# Status
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $Status,

# Submit
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean]
    $Submit,

# Submit Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $SubmitDate,

# Submitter ID
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $SubmitterID,

# Approver ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $ApproverID,

# Period Ending
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $WeekEnding,

# Expense Total
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $ExpenseTotal,

# Cash Advance Amount
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $CashAdvanceAmount,

# Rejection Reason
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,2048)]
    [string]
    $RejectionReason,

# Amount Due
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $AmountDue,

# Department Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string]
    $DepartmentNumber,

# Quick Books Reference Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,100)]
    [string]
    $QuickBooksReferenceNumber,

# Approved Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $ApprovedDate,

# Reimbursement Currency ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $ReimbursementCurrencyID,

# Reimbursement Currency Cash Advance Amount
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $ReimbursementCurrencyCashAdvanceAmount,

# Reimbursement Currency Amount Due
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $ReimbursementCurrencyAmountDue,

# Business Division Subdivision ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $BusinessDivisionSubdivisionID
  )
 
  Begin
  { 
    $EntityName = 'ExpenseReport'
           
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

    $Result = New-AtwsData -Entity $ProcessObject
  }

  End
  {
    Write-Debug ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $Result.count, $EntityName)
    Return $Result
  }

}
