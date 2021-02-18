#Requires -Version 4.0
#Version 1.6.12
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsChangeOrderCost
{


<#
.SYNOPSIS
This function get one or more ChangeOrderCost through the Autotask Web Services API.
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

CostType
 

Status
 

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.ChangeOrderCost[]]. This function outputs the Autotask.ChangeOrderCost that was returned by the API.
.EXAMPLE
Get-AtwsChangeOrderCost -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsChangeOrderCost -ChangeOrderCostName SomeName
Returns the object with ChangeOrderCostName 'SomeName', if any.
 .EXAMPLE
Get-AtwsChangeOrderCost -ChangeOrderCostName 'Some Name'
Returns the object with ChangeOrderCostName 'Some Name', if any.
 .EXAMPLE
Get-AtwsChangeOrderCost -ChangeOrderCostName 'Some Name' -NotEquals ChangeOrderCostName
Returns any objects with a ChangeOrderCostName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsChangeOrderCost -ChangeOrderCostName SomeName* -Like ChangeOrderCostName
Returns any object with a ChangeOrderCostName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsChangeOrderCost -ChangeOrderCostName SomeName* -NotLike ChangeOrderCostName
Returns any object with a ChangeOrderCostName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsChangeOrderCost -CostType <PickList Label>
Returns any ChangeOrderCosts with property CostType equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsChangeOrderCost -CostType <PickList Label> -NotEquals CostType 
Returns any ChangeOrderCosts with property CostType NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsChangeOrderCost -CostType <PickList Label1>, <PickList Label2>
Returns any ChangeOrderCosts with property CostType equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsChangeOrderCost -CostType <PickList Label1>, <PickList Label2> -NotEquals CostType
Returns any ChangeOrderCosts with property CostType NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsChangeOrderCost -Id 1234 -ChangeOrderCostName SomeName* -CostType <PickList Label1>, <PickList Label2> -Like ChangeOrderCostName -NotEquals CostType -GreaterThan Id
An example of a more complex query. This command returns any ChangeOrderCosts with Id GREATER THAN 1234, a ChangeOrderCostName that matches the simple pattern SomeName* AND that has a CostType that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsChangeOrderCost
 .LINK
Remove-AtwsChangeOrderCost
 .LINK
Set-AtwsChangeOrderCost

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
    [ValidateSet('AllocationCodeID', 'BusinessDivisionSubdivisionID', 'ContractServiceBundleID', 'ContractServiceID', 'CreatorResourceID', 'ProductID', 'StatusLastModifiedBy', 'TaskID')]
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
    [string]
    $GetExternalEntityByThisEntityId,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# Change Order Cost ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Allocation Code ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $AllocationCodeID,

# Billable Amount
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $BillableAmount,

# Billable To Account
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $BillableToAccount,

# Billed
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $Billed,

# Cost Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $CostType,

# Create Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CreateDate,

# Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CreatorResourceID,

# Date Purchased
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $DatePurchased,

# Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string[]]
    $Description,

# Extended Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $ExtendedCost,

# Internal Purchase Order Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $InternalPurchaseOrderNumber,

# Product ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ProductID,

# Purchase Order Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $PurchaseOrderNumber,

# Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [string[]]
    $Name,

# Contract Service ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ContractServiceID,

# Contract Service Bundle ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ContractServiceBundleID,

# Status
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $Status,

# Status Last Modified By
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $StatusLastModifiedBy,

# Status Last Modified Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $StatusLastModifiedDate,

# Unit Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $UnitCost,

# Unit Price
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $UnitPrice,

# Unit Quantity
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $UnitQuantity,

# Internal Currency Billable Amount
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $InternalCurrencyBillableAmount,

# Internal Currency Unit Price
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $InternalCurrencyUnitPrice,

# Business Division Subdivision ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BusinessDivisionSubdivisionID,

# Task ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $TaskID,

# Change Order Hours
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $ChangeOrderHours,

# Notes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string[]]
    $Notes,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AllocationCodeID', 'BillableAmount', 'BillableToAccount', 'Billed', 'CostType', 'CreateDate', 'CreatorResourceID', 'DatePurchased', 'Description', 'ExtendedCost', 'InternalPurchaseOrderNumber', 'ProductID', 'PurchaseOrderNumber', 'Name', 'ContractServiceID', 'ContractServiceBundleID', 'Status', 'StatusLastModifiedBy', 'StatusLastModifiedDate', 'UnitCost', 'UnitPrice', 'UnitQuantity', 'InternalCurrencyBillableAmount', 'InternalCurrencyUnitPrice', 'BusinessDivisionSubdivisionID', 'TaskID', 'ChangeOrderHours', 'Notes')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AllocationCodeID', 'BillableAmount', 'BillableToAccount', 'Billed', 'CostType', 'CreateDate', 'CreatorResourceID', 'DatePurchased', 'Description', 'ExtendedCost', 'InternalPurchaseOrderNumber', 'ProductID', 'PurchaseOrderNumber', 'Name', 'ContractServiceID', 'ContractServiceBundleID', 'Status', 'StatusLastModifiedBy', 'StatusLastModifiedDate', 'UnitCost', 'UnitPrice', 'UnitQuantity', 'InternalCurrencyBillableAmount', 'InternalCurrencyUnitPrice', 'BusinessDivisionSubdivisionID', 'TaskID', 'ChangeOrderHours', 'Notes')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AllocationCodeID', 'BillableAmount', 'BillableToAccount', 'Billed', 'CostType', 'CreateDate', 'CreatorResourceID', 'DatePurchased', 'Description', 'ExtendedCost', 'InternalPurchaseOrderNumber', 'ProductID', 'PurchaseOrderNumber', 'Name', 'ContractServiceID', 'ContractServiceBundleID', 'Status', 'StatusLastModifiedBy', 'StatusLastModifiedDate', 'UnitCost', 'UnitPrice', 'UnitQuantity', 'InternalCurrencyBillableAmount', 'InternalCurrencyUnitPrice', 'BusinessDivisionSubdivisionID', 'TaskID', 'ChangeOrderHours', 'Notes')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AllocationCodeID', 'BillableAmount', 'CostType', 'CreateDate', 'CreatorResourceID', 'DatePurchased', 'Description', 'ExtendedCost', 'InternalPurchaseOrderNumber', 'ProductID', 'PurchaseOrderNumber', 'Name', 'ContractServiceID', 'ContractServiceBundleID', 'Status', 'StatusLastModifiedBy', 'StatusLastModifiedDate', 'UnitCost', 'UnitPrice', 'UnitQuantity', 'InternalCurrencyBillableAmount', 'InternalCurrencyUnitPrice', 'BusinessDivisionSubdivisionID', 'TaskID', 'ChangeOrderHours', 'Notes')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AllocationCodeID', 'BillableAmount', 'CostType', 'CreateDate', 'CreatorResourceID', 'DatePurchased', 'Description', 'ExtendedCost', 'InternalPurchaseOrderNumber', 'ProductID', 'PurchaseOrderNumber', 'Name', 'ContractServiceID', 'ContractServiceBundleID', 'Status', 'StatusLastModifiedBy', 'StatusLastModifiedDate', 'UnitCost', 'UnitPrice', 'UnitQuantity', 'InternalCurrencyBillableAmount', 'InternalCurrencyUnitPrice', 'BusinessDivisionSubdivisionID', 'TaskID', 'ChangeOrderHours', 'Notes')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AllocationCodeID', 'BillableAmount', 'CostType', 'CreateDate', 'CreatorResourceID', 'DatePurchased', 'Description', 'ExtendedCost', 'InternalPurchaseOrderNumber', 'ProductID', 'PurchaseOrderNumber', 'Name', 'ContractServiceID', 'ContractServiceBundleID', 'Status', 'StatusLastModifiedBy', 'StatusLastModifiedDate', 'UnitCost', 'UnitPrice', 'UnitQuantity', 'InternalCurrencyBillableAmount', 'InternalCurrencyUnitPrice', 'BusinessDivisionSubdivisionID', 'TaskID', 'ChangeOrderHours', 'Notes')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AllocationCodeID', 'BillableAmount', 'CostType', 'CreateDate', 'CreatorResourceID', 'DatePurchased', 'Description', 'ExtendedCost', 'InternalPurchaseOrderNumber', 'ProductID', 'PurchaseOrderNumber', 'Name', 'ContractServiceID', 'ContractServiceBundleID', 'Status', 'StatusLastModifiedBy', 'StatusLastModifiedDate', 'UnitCost', 'UnitPrice', 'UnitQuantity', 'InternalCurrencyBillableAmount', 'InternalCurrencyUnitPrice', 'BusinessDivisionSubdivisionID', 'TaskID', 'ChangeOrderHours', 'Notes')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'InternalPurchaseOrderNumber', 'PurchaseOrderNumber', 'Name', 'Notes')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'InternalPurchaseOrderNumber', 'PurchaseOrderNumber', 'Name', 'Notes')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'InternalPurchaseOrderNumber', 'PurchaseOrderNumber', 'Name', 'Notes')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'InternalPurchaseOrderNumber', 'PurchaseOrderNumber', 'Name', 'Notes')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'InternalPurchaseOrderNumber', 'PurchaseOrderNumber', 'Name', 'Notes')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'DatePurchased', 'StatusLastModifiedDate')]
    [string[]]
    $IsThisDay
  )

    begin { 
        $entityName = 'ChangeOrderCost'
    
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
