#Requires -Version 4.0
#Version 1.6.2.14
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsBillingItem
{


<#
.SYNOPSIS
This function get one or more BillingItem through the Autotask Web Services API.
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

Type
 

SubType
 

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.BillingItem[]]. This function outputs the Autotask.BillingItem that was returned by the API.
.EXAMPLE
Get-AtwsBillingItem -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsBillingItem -BillingItemName SomeName
Returns the object with BillingItemName 'SomeName', if any.
 .EXAMPLE
Get-AtwsBillingItem -BillingItemName 'Some Name'
Returns the object with BillingItemName 'Some Name', if any.
 .EXAMPLE
Get-AtwsBillingItem -BillingItemName 'Some Name' -NotEquals BillingItemName
Returns any objects with a BillingItemName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsBillingItem -BillingItemName SomeName* -Like BillingItemName
Returns any object with a BillingItemName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsBillingItem -BillingItemName SomeName* -NotLike BillingItemName
Returns any object with a BillingItemName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsBillingItem -Type <PickList Label>
Returns any BillingItems with property Type equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsBillingItem -Type <PickList Label> -NotEquals Type 
Returns any BillingItems with property Type NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsBillingItem -Type <PickList Label1>, <PickList Label2>
Returns any BillingItems with property Type equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsBillingItem -Type <PickList Label1>, <PickList Label2> -NotEquals Type
Returns any BillingItems with property Type NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsBillingItem -Id 1234 -BillingItemName SomeName* -Type <PickList Label1>, <PickList Label2> -Like BillingItemName -NotEquals Type -GreaterThan Id
An example of a more complex query. This command returns any BillingItems with Id GREATER THAN 1234, a BillingItemName that matches the simple pattern SomeName* AND that has a Type that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
Set-AtwsBillingItem

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
    [ValidateSet('AccountID', 'AccountManagerWhenApprovedID', 'AllocationCodeID', 'BusinessDivisionSubdivisionID', 'ContractCostID', 'ContractID', 'ExpenseItemID', 'InstalledProductID', 'InvoiceID', 'ItemApproverID', 'MilestoneID', 'ProjectCostID', 'ProjectID', 'RoleID', 'ServiceBundleID', 'ServiceID', 'TaskID', 'TicketCostID', 'TicketID', 'TimeEntryID', 'VendorID')]
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

# BillingItemID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $Type,

# Sub Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $SubType,

# ItemName
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string[]]
    $ItemName,

# Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string[]]
    $Description,

# Quantity
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $Quantity,

# Rate
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $Rate,

# TotalAmount
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $TotalAmount,

# OurCost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $OurCost,

# ItemDate
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ItemDate,

# InvoiceID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $InvoiceID,

# ItemApproverID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ItemApproverID,

# Client
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $AccountID,

# TicketID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $TicketID,

# TaskID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $TaskID,

# ProjectID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ProjectID,

# AllocationCodeID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $AllocationCodeID,

# RoleID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $RoleID,

# TimeEntryID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $TimeEntryID,

# ContractID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ContractID,

# WebServiceDate
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $WebServiceDate,

# NonBillable
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $NonBillable,

# TaxDollars
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $TaxDollars,

# purchase_order_number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $PurchaseOrderNumber,

# ExtendedPrice
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $ExtendedPrice,

# Expense Item
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ExpenseItemID,

# Contract Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $ContractCostID,

# Project Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $ProjectCostID,

# Ticket Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $TicketCostID,

# Invoice Line Item ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $LineItemID,

# Milestone ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $MilestoneID,

# Service ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $ServiceID,

# Service Bundle ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $ServiceBundleID,

# Vendor ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $VendorID,

# Installed Product Id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $InstalledProductID,

# InternalCurrencyExtendedPrice
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $InternalCurrencyExtendedPrice,

# InternalCurrencyRate
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $InternalCurrencyRate,

# InternalCurrencyTaxDollars
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $InternalCurrencyTaxDollars,

# InternalCurrencyTotalAmount
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $InternalCurrencyTotalAmount,

# AccountManagerWhenApprovedID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $AccountManagerWhenApprovedID,

# Business Division Subdivision ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BusinessDivisionSubdivisionID,

# Posted On Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $PostedOnTime,

# Posted Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $PostedDate,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Type', 'SubType', 'ItemName', 'Description', 'Quantity', 'Rate', 'TotalAmount', 'OurCost', 'ItemDate', 'InvoiceID', 'ItemApproverID', 'AccountID', 'TicketID', 'TaskID', 'ProjectID', 'AllocationCodeID', 'RoleID', 'TimeEntryID', 'ContractID', 'WebServiceDate', 'NonBillable', 'TaxDollars', 'PurchaseOrderNumber', 'ExtendedPrice', 'ExpenseItemID', 'ContractCostID', 'ProjectCostID', 'TicketCostID', 'LineItemID', 'MilestoneID', 'ServiceID', 'ServiceBundleID', 'VendorID', 'InstalledProductID', 'InternalCurrencyExtendedPrice', 'InternalCurrencyRate', 'InternalCurrencyTaxDollars', 'InternalCurrencyTotalAmount', 'AccountManagerWhenApprovedID', 'BusinessDivisionSubdivisionID', 'PostedOnTime', 'PostedDate')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Type', 'SubType', 'ItemName', 'Description', 'Quantity', 'Rate', 'TotalAmount', 'OurCost', 'ItemDate', 'InvoiceID', 'ItemApproverID', 'AccountID', 'TicketID', 'TaskID', 'ProjectID', 'AllocationCodeID', 'RoleID', 'TimeEntryID', 'ContractID', 'WebServiceDate', 'NonBillable', 'TaxDollars', 'PurchaseOrderNumber', 'ExtendedPrice', 'ExpenseItemID', 'ContractCostID', 'ProjectCostID', 'TicketCostID', 'LineItemID', 'MilestoneID', 'ServiceID', 'ServiceBundleID', 'VendorID', 'InstalledProductID', 'InternalCurrencyExtendedPrice', 'InternalCurrencyRate', 'InternalCurrencyTaxDollars', 'InternalCurrencyTotalAmount', 'AccountManagerWhenApprovedID', 'BusinessDivisionSubdivisionID', 'PostedOnTime', 'PostedDate')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Type', 'SubType', 'ItemName', 'Description', 'Quantity', 'Rate', 'TotalAmount', 'OurCost', 'ItemDate', 'InvoiceID', 'ItemApproverID', 'AccountID', 'TicketID', 'TaskID', 'ProjectID', 'AllocationCodeID', 'RoleID', 'TimeEntryID', 'ContractID', 'WebServiceDate', 'NonBillable', 'TaxDollars', 'PurchaseOrderNumber', 'ExtendedPrice', 'ExpenseItemID', 'ContractCostID', 'ProjectCostID', 'TicketCostID', 'LineItemID', 'MilestoneID', 'ServiceID', 'ServiceBundleID', 'VendorID', 'InstalledProductID', 'InternalCurrencyExtendedPrice', 'InternalCurrencyRate', 'InternalCurrencyTaxDollars', 'InternalCurrencyTotalAmount', 'AccountManagerWhenApprovedID', 'BusinessDivisionSubdivisionID', 'PostedOnTime', 'PostedDate')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Type', 'SubType', 'ItemName', 'Description', 'Quantity', 'Rate', 'TotalAmount', 'OurCost', 'ItemDate', 'InvoiceID', 'ItemApproverID', 'AccountID', 'TicketID', 'TaskID', 'ProjectID', 'AllocationCodeID', 'RoleID', 'TimeEntryID', 'ContractID', 'WebServiceDate', 'NonBillable', 'TaxDollars', 'PurchaseOrderNumber', 'ExtendedPrice', 'ExpenseItemID', 'ContractCostID', 'ProjectCostID', 'TicketCostID', 'LineItemID', 'MilestoneID', 'ServiceID', 'ServiceBundleID', 'VendorID', 'InstalledProductID', 'InternalCurrencyExtendedPrice', 'InternalCurrencyRate', 'InternalCurrencyTaxDollars', 'InternalCurrencyTotalAmount', 'AccountManagerWhenApprovedID', 'BusinessDivisionSubdivisionID', 'PostedOnTime', 'PostedDate')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Type', 'SubType', 'ItemName', 'Description', 'Quantity', 'Rate', 'TotalAmount', 'OurCost', 'ItemDate', 'InvoiceID', 'ItemApproverID', 'AccountID', 'TicketID', 'TaskID', 'ProjectID', 'AllocationCodeID', 'RoleID', 'TimeEntryID', 'ContractID', 'WebServiceDate', 'NonBillable', 'TaxDollars', 'PurchaseOrderNumber', 'ExtendedPrice', 'ExpenseItemID', 'ContractCostID', 'ProjectCostID', 'TicketCostID', 'LineItemID', 'MilestoneID', 'ServiceID', 'ServiceBundleID', 'VendorID', 'InstalledProductID', 'InternalCurrencyExtendedPrice', 'InternalCurrencyRate', 'InternalCurrencyTaxDollars', 'InternalCurrencyTotalAmount', 'AccountManagerWhenApprovedID', 'BusinessDivisionSubdivisionID', 'PostedOnTime', 'PostedDate')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Type', 'SubType', 'ItemName', 'Description', 'Quantity', 'Rate', 'TotalAmount', 'OurCost', 'ItemDate', 'InvoiceID', 'ItemApproverID', 'AccountID', 'TicketID', 'TaskID', 'ProjectID', 'AllocationCodeID', 'RoleID', 'TimeEntryID', 'ContractID', 'WebServiceDate', 'NonBillable', 'TaxDollars', 'PurchaseOrderNumber', 'ExtendedPrice', 'ExpenseItemID', 'ContractCostID', 'ProjectCostID', 'TicketCostID', 'LineItemID', 'MilestoneID', 'ServiceID', 'ServiceBundleID', 'VendorID', 'InstalledProductID', 'InternalCurrencyExtendedPrice', 'InternalCurrencyRate', 'InternalCurrencyTaxDollars', 'InternalCurrencyTotalAmount', 'AccountManagerWhenApprovedID', 'BusinessDivisionSubdivisionID', 'PostedOnTime', 'PostedDate')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Type', 'SubType', 'ItemName', 'Description', 'Quantity', 'Rate', 'TotalAmount', 'OurCost', 'ItemDate', 'InvoiceID', 'ItemApproverID', 'AccountID', 'TicketID', 'TaskID', 'ProjectID', 'AllocationCodeID', 'RoleID', 'TimeEntryID', 'ContractID', 'WebServiceDate', 'NonBillable', 'TaxDollars', 'PurchaseOrderNumber', 'ExtendedPrice', 'ExpenseItemID', 'ContractCostID', 'ProjectCostID', 'TicketCostID', 'LineItemID', 'MilestoneID', 'ServiceID', 'ServiceBundleID', 'VendorID', 'InstalledProductID', 'InternalCurrencyExtendedPrice', 'InternalCurrencyRate', 'InternalCurrencyTaxDollars', 'InternalCurrencyTotalAmount', 'AccountManagerWhenApprovedID', 'BusinessDivisionSubdivisionID', 'PostedOnTime', 'PostedDate')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('ItemName', 'Description', 'PurchaseOrderNumber')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('ItemName', 'Description', 'PurchaseOrderNumber')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('ItemName', 'Description', 'PurchaseOrderNumber')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('ItemName', 'Description', 'PurchaseOrderNumber')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('ItemName', 'Description', 'PurchaseOrderNumber')]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('ItemDate', 'WebServiceDate', 'PostedOnTime', 'PostedDate')]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'BillingItem'
    
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
