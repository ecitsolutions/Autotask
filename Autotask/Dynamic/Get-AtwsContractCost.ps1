#Requires -Version 4.0
#Version 1.6.2.17
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsContractCost
{


<#
.SYNOPSIS
This function get one or more ContractCost through the Autotask Web Services API.
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

CostType
 

Status
 

Entities that have fields that refer to the base entity of this CmdLet:

BillingItem

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.ContractCost[]]. This function outputs the Autotask.ContractCost that was returned by the API.
.EXAMPLE
Get-AtwsContractCost -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsContractCost -ContractCostName SomeName
Returns the object with ContractCostName 'SomeName', if any.
 .EXAMPLE
Get-AtwsContractCost -ContractCostName 'Some Name'
Returns the object with ContractCostName 'Some Name', if any.
 .EXAMPLE
Get-AtwsContractCost -ContractCostName 'Some Name' -NotEquals ContractCostName
Returns any objects with a ContractCostName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsContractCost -ContractCostName SomeName* -Like ContractCostName
Returns any object with a ContractCostName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsContractCost -ContractCostName SomeName* -NotLike ContractCostName
Returns any object with a ContractCostName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsContractCost -CostType <PickList Label>
Returns any ContractCosts with property CostType equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsContractCost -CostType <PickList Label> -NotEquals CostType 
Returns any ContractCosts with property CostType NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsContractCost -CostType <PickList Label1>, <PickList Label2>
Returns any ContractCosts with property CostType equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsContractCost -CostType <PickList Label1>, <PickList Label2> -NotEquals CostType
Returns any ContractCosts with property CostType NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsContractCost -Id 1234 -ContractCostName SomeName* -CostType <PickList Label1>, <PickList Label2> -Like ContractCostName -NotEquals CostType -GreaterThan Id
An example of a more complex query. This command returns any ContractCosts with Id GREATER THAN 1234, a ContractCostName that matches the simple pattern SomeName* AND that has a CostType that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsContractCost
 .LINK
Remove-AtwsContractCost
 .LINK
Set-AtwsContractCost

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
    [ValidateSet('AllocationCodeID', 'BusinessDivisionSubdivisionID', 'ContractID', 'ContractServiceBundleID', 'ContractServiceID', 'CreatorResourceID', 'ProductID')]
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
    [ValidateSet('BillingItem:ContractCostID')]
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

# id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Contract
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $ContractID,

# Product
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $ProductID,

# Allocation Code
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $AllocationCodeID,

# Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [string[]]
    $Name,

# Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string[]]
    $Description,

# Date Purchased
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $DatePurchased,

# Cost Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $CostType,

# Purchase Order Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $PurchaseOrderNumber,

# Internal Purchase Order Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $InternalPurchaseOrderNumber,

# Unit Quantity
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[double][]]
    $UnitQuantity,

# Unit Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $UnitCost,

# Unit Price
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $UnitPrice,

# Extended Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $ExtendedCost,

# Billable Amount
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $BillableAmount,

# Billable To Client
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $BillableToAccount,

# Billed
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $Billed,

# Status
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $Status,

# Last Modified By
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $StatusLastModifiedBy,

# Last Modified Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $StatusLastModifiedDate,

# Create Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CreateDate,

# Created By
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $CreatorResourceID,

# Contract Service ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $ContractServiceID,

# Contract Service Bundle ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $ContractServiceBundleID,

# Internal Currency Billable Amount
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $InternalCurrencyBillableAmount,

# Internal Currency Unit Price
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $InternalCurrencyUnitPrice,

# Business Division Subdivision ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BusinessDivisionSubdivisionID,

# Notes
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string[]]
    $Notes,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'ProductID', 'AllocationCodeID', 'Name', 'Description', 'DatePurchased', 'CostType', 'PurchaseOrderNumber', 'InternalPurchaseOrderNumber', 'UnitQuantity', 'UnitCost', 'UnitPrice', 'ExtendedCost', 'BillableAmount', 'BillableToAccount', 'Billed', 'Status', 'StatusLastModifiedBy', 'StatusLastModifiedDate', 'CreateDate', 'CreatorResourceID', 'ContractServiceID', 'ContractServiceBundleID', 'InternalCurrencyBillableAmount', 'InternalCurrencyUnitPrice', 'BusinessDivisionSubdivisionID', 'Notes')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'ProductID', 'AllocationCodeID', 'Name', 'Description', 'DatePurchased', 'CostType', 'PurchaseOrderNumber', 'InternalPurchaseOrderNumber', 'UnitQuantity', 'UnitCost', 'UnitPrice', 'ExtendedCost', 'BillableAmount', 'BillableToAccount', 'Billed', 'Status', 'StatusLastModifiedBy', 'StatusLastModifiedDate', 'CreateDate', 'CreatorResourceID', 'ContractServiceID', 'ContractServiceBundleID', 'InternalCurrencyBillableAmount', 'InternalCurrencyUnitPrice', 'BusinessDivisionSubdivisionID', 'Notes')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'ProductID', 'AllocationCodeID', 'Name', 'Description', 'DatePurchased', 'CostType', 'PurchaseOrderNumber', 'InternalPurchaseOrderNumber', 'UnitQuantity', 'UnitCost', 'UnitPrice', 'ExtendedCost', 'BillableAmount', 'BillableToAccount', 'Billed', 'Status', 'StatusLastModifiedBy', 'StatusLastModifiedDate', 'CreateDate', 'CreatorResourceID', 'ContractServiceID', 'ContractServiceBundleID', 'InternalCurrencyBillableAmount', 'InternalCurrencyUnitPrice', 'BusinessDivisionSubdivisionID', 'Notes')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'ProductID', 'AllocationCodeID', 'Name', 'Description', 'DatePurchased', 'CostType', 'PurchaseOrderNumber', 'InternalPurchaseOrderNumber', 'UnitQuantity', 'UnitCost', 'UnitPrice', 'ExtendedCost', 'BillableAmount', 'Status', 'StatusLastModifiedBy', 'StatusLastModifiedDate', 'CreateDate', 'CreatorResourceID', 'ContractServiceID', 'ContractServiceBundleID', 'InternalCurrencyBillableAmount', 'InternalCurrencyUnitPrice', 'BusinessDivisionSubdivisionID', 'Notes')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'ProductID', 'AllocationCodeID', 'Name', 'Description', 'DatePurchased', 'CostType', 'PurchaseOrderNumber', 'InternalPurchaseOrderNumber', 'UnitQuantity', 'UnitCost', 'UnitPrice', 'ExtendedCost', 'BillableAmount', 'Status', 'StatusLastModifiedBy', 'StatusLastModifiedDate', 'CreateDate', 'CreatorResourceID', 'ContractServiceID', 'ContractServiceBundleID', 'InternalCurrencyBillableAmount', 'InternalCurrencyUnitPrice', 'BusinessDivisionSubdivisionID', 'Notes')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'ProductID', 'AllocationCodeID', 'Name', 'Description', 'DatePurchased', 'CostType', 'PurchaseOrderNumber', 'InternalPurchaseOrderNumber', 'UnitQuantity', 'UnitCost', 'UnitPrice', 'ExtendedCost', 'BillableAmount', 'Status', 'StatusLastModifiedBy', 'StatusLastModifiedDate', 'CreateDate', 'CreatorResourceID', 'ContractServiceID', 'ContractServiceBundleID', 'InternalCurrencyBillableAmount', 'InternalCurrencyUnitPrice', 'BusinessDivisionSubdivisionID', 'Notes')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'ProductID', 'AllocationCodeID', 'Name', 'Description', 'DatePurchased', 'CostType', 'PurchaseOrderNumber', 'InternalPurchaseOrderNumber', 'UnitQuantity', 'UnitCost', 'UnitPrice', 'ExtendedCost', 'BillableAmount', 'Status', 'StatusLastModifiedBy', 'StatusLastModifiedDate', 'CreateDate', 'CreatorResourceID', 'ContractServiceID', 'ContractServiceBundleID', 'InternalCurrencyBillableAmount', 'InternalCurrencyUnitPrice', 'BusinessDivisionSubdivisionID', 'Notes')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'PurchaseOrderNumber', 'InternalPurchaseOrderNumber', 'Notes')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'PurchaseOrderNumber', 'InternalPurchaseOrderNumber', 'Notes')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'PurchaseOrderNumber', 'InternalPurchaseOrderNumber', 'Notes')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'PurchaseOrderNumber', 'InternalPurchaseOrderNumber', 'Notes')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'PurchaseOrderNumber', 'InternalPurchaseOrderNumber', 'Notes')]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('DatePurchased', 'StatusLastModifiedDate', 'CreateDate')]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'ContractCost'
    
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
