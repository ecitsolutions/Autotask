#Requires -Version 4.0
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function New-ExpenseReport
{


<#
.SYNOPSIS
This function creates a new ExpenseReport through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.ExpenseReport] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the ExpenseReport with Id number 0 you could write 'New-ExpenseReport -Id 0' or you could write 'New-ExpenseReport -Filter {Id -eq 0}.

'New-ExpenseReport -Id 0,4' could be written as 'New-ExpenseReport -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

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
$Result = New-ExpenseReport -Name [Value] -SubmitterID [Value] -WeekEnding [Value]
Creates a new [Autotask.ExpenseReport] through the Web Services API and returns the new object.
 .EXAMPLE
$Result = Get-ExpenseReport -Id 124 | New-ExpenseReport 
Copies [Autotask.ExpenseReport] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-ExpenseReport -Id 124 | New-ExpenseReport | Set-ExpenseReport -ParameterName <Parameter Value>
Copies [Autotask.ExpenseReport] by Id 124 to a new object through the Web Services API, passes the new object to the Set-ExpenseReport to modify the object.
 .EXAMPLE
$Result = Get-ExpenseReport -Id 124 | New-ExpenseReport | Set-ExpenseReport -ParameterName <Parameter Value> -Passthru
Copies [Autotask.ExpenseReport] by Id 124 to a new object through the Web Services API, passes the new object to the Set-ExpenseReport to modify the object and returns the new object.

.LINK
Get-ExpenseReport
 .LINK
Set-ExpenseReport

#>

  [CmdLetBinding(DefaultParameterSetName='By_parameters', ConfirmImpact='Medium')]
  Param
  (
# An array of objects to create
    [Parameter(
      Mandatory = $true,
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
    [Int]
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
           
    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    $ProcessObject = @()
    
    # Set up TimeZone offset handling
    If (-not($script:ESToffset))
    {
      $Now = Get-Date
      $ESTzone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Eastern Standard Time")
      $ESTtime = [System.TimeZoneInfo]::ConvertTimeFromUtc($Now.ToUniversalTime(), $ESTzone)

      $script:ESToffset = (New-TimeSpan -Start $ESTtime -End $Now).TotalHours
    }

  }

  Process
  {
    $Fields = Get-FieldInfo -Entity $EntityName
    
    If ($InputObject)
    {
      Write-Verbose ('{0}: Copy Object mode: Setting ID property to zero' -F $MyInvocation.MyCommand.Name)  
      
      $CopyNo = 1

      Foreach ($Object in $InputObject) 
      { 
        # Create a new object and copy properties
        $NewObject = New-Object Autotask.$EntityName
        
        # Copy every non readonly property
        Foreach ($Field in $Fields.Where({$_.Name -ne 'id'}).Name)
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
      Write-Verbose ('{0}: Creating empty [Autotask.{1}]' -F $MyInvocation.MyCommand.Name, $EntityName) 
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
        ElseIf ($Field.Type -eq 'datetime')
        {
          # Yes, you really have to ADD the difference
          $Value = $Parameter.Value.AddHours($script:ESToffset)
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
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

    If ($PSCmdLet.ParameterSetName -eq 'Input_Object')
    {
      # Verify copy mode
      Foreach ($Object in $Result)
      {
        If ($InputObject.Id -contains $Object.Id)
        {
          Write-Verbose ('{0}: Autotask detected new object as duplicate of {1} with Id {2} and tried to update object, not create a new copy. ' -F $MyInvocation.MyCommand.Name, $EntityName, $Object.Id)
        }
      }
    }

    Return $Result
  }


}
