#Requires -Version 4.0
#Version 1.6.2.16
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function New-AtwsTicketCost
{


<#
.SYNOPSIS
This function creates a new TicketCost through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.TicketCost] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the TicketCost with Id number 0 you could write 'New-AtwsTicketCost -Id 0' or you could write 'New-AtwsTicketCost -Filter {Id -eq 0}.

'New-AtwsTicketCost -Id 0,4' could be written as 'New-AtwsTicketCost -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new TicketCost you need the following required fields:
 -TicketID
 -Name
 -DatePurchased
 -CostType
 -UnitQuantity

Entities that have fields that refer to the base entity of this CmdLet:

BillingItem

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.TicketCost]. This function outputs the Autotask.TicketCost that was created by the API.
.EXAMPLE
$Result = New-AtwsTicketCost -TicketID [Value] -Name [Value] -DatePurchased [Value] -CostType [Value] -UnitQuantity [Value]
Creates a new [Autotask.TicketCost] through the Web Services API and returns the new object.
 .EXAMPLE
$Result = Get-AtwsTicketCost -Id 124 | New-AtwsTicketCost 
Copies [Autotask.TicketCost] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsTicketCost -Id 124 | New-AtwsTicketCost | Set-AtwsTicketCost -ParameterName <Parameter Value>
Copies [Autotask.TicketCost] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsTicketCost to modify the object.
 .EXAMPLE
$Result = Get-AtwsTicketCost -Id 124 | New-AtwsTicketCost | Set-AtwsTicketCost -ParameterName <Parameter Value> -Passthru
Copies [Autotask.TicketCost] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsTicketCost to modify the object and returns the new object.

.LINK
Remove-AtwsTicketCost
 .LINK
Get-AtwsTicketCost
 .LINK
Set-AtwsTicketCost

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
    [Autotask.TicketCost[]]
    $InputObject,

# Ticket
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [long]
    $TicketID,

# Product
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long]
    $ProductID,

# Allocation Code
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long]
    $AllocationCodeID,

# Name
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [string]
    $Name,

# Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string]
    $Description,

# Date Purchased
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $DatePurchased,

# Cost Type
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String]
    $CostType,

# Purchase Order Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $PurchaseOrderNumber,

# Internal Purchase Order Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $InternalPurchaseOrderNumber,

# Unit Quantity
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [double]
    $UnitQuantity,

# Unit Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $UnitCost,

# Unit Price
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $UnitPrice,

# Extended Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $ExtendedCost,

# Billable Amount
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $BillableAmount,

# Billable To Client
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean]
    $BillableToAccount,

# Billed
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean]
    $Billed,

# Status
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $Status,

# Last Modified By
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long]
    $StatusLastModifiedBy,

# Last Modified Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $StatusLastModifiedDate,

# Create Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $CreateDate,

# Created By
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long]
    $CreatorResourceID,

# Contract Service ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long]
    $ContractServiceID,

# Contract Service Bundle ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long]
    $ContractServiceBundleID,

# Internal Currency Billable Amount
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $InternalCurrencyBillableAmount,

# Internal Currency Unit Price
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $InternalCurrencyUnitPrice,

# Business Division Subdivision ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $BusinessDivisionSubdivisionID,

# Notes
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string]
    $Notes
  )
 
  Begin
  { 
    $EntityName = 'TicketCost'
           
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
