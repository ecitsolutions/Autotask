#Requires -Version 4.0
#Version 1.6.2.17
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsProduct
{


<#
.SYNOPSIS
This function get one or more Product through the Autotask Web Services API.
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

ProductCategory
 

PeriodType
 

BillingType
 

PriceCostMethod
 

Entities that have fields that refer to the base entity of this CmdLet:

ContactBillingProductAssociation
 ContractBillingRule
 ContractCost
 InstalledProduct
 InstalledProductBillingProductAssociation
 InventoryItem
 InventoryTransfer
 Opportunity
 PriceListProduct
 ProductTier
 ProductVendor
 ProjectCost
 PurchaseOrderItem
 QuoteItem
 TicketCost

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Product[]]. This function outputs the Autotask.Product that was returned by the API.
.EXAMPLE
Get-AtwsProduct -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsProduct -ProductName SomeName
Returns the object with ProductName 'SomeName', if any.
 .EXAMPLE
Get-AtwsProduct -ProductName 'Some Name'
Returns the object with ProductName 'Some Name', if any.
 .EXAMPLE
Get-AtwsProduct -ProductName 'Some Name' -NotEquals ProductName
Returns any objects with a ProductName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsProduct -ProductName SomeName* -Like ProductName
Returns any object with a ProductName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsProduct -ProductName SomeName* -NotLike ProductName
Returns any object with a ProductName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsProduct -ProductCategory <PickList Label>
Returns any Products with property ProductCategory equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsProduct -ProductCategory <PickList Label> -NotEquals ProductCategory 
Returns any Products with property ProductCategory NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsProduct -ProductCategory <PickList Label1>, <PickList Label2>
Returns any Products with property ProductCategory equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsProduct -ProductCategory <PickList Label1>, <PickList Label2> -NotEquals ProductCategory
Returns any Products with property ProductCategory NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsProduct -Id 1234 -ProductName SomeName* -ProductCategory <PickList Label1>, <PickList Label2> -Like ProductName -NotEquals ProductCategory -GreaterThan Id
An example of a more complex query. This command returns any Products with Id GREATER THAN 1234, a ProductName that matches the simple pattern SomeName* AND that has a ProductCategory that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsProduct
 .LINK
Set-AtwsProduct

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
    [ValidateSet('CostAllocationCodeID', 'DefaultVendorID', 'ProductAllocationCodeID')]
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
    [ValidateSet('ContactBillingProductAssociation:BillingProductID', 'ContractBillingRule:ProductID', 'ContractCost:ProductID', 'InstalledProduct:ProductID', 'InstalledProductBillingProductAssociation:BillingProductID', 'InventoryItem:ProductID', 'InventoryTransfer:ProductID', 'Opportunity:ProductID', 'PriceListProduct:ProductID', 'ProductTier:ProductID', 'ProductVendor:ProductID', 'ProjectCost:ProductID', 'PurchaseOrderItem:ProductID', 'QuoteItem:ProductID', 'TicketCost:ProductID')]
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

# ProductID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Product Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [string[]]
    $Name,

# Product Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string[]]
    $Description,

# Product SKU
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $SKU,

# Product Link
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string[]]
    $Link,

# Product Category
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $ProductCategory,

# External ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $ExternalProductID,

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

# MSRP
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $MSRP,

# Vendor Account ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $DefaultVendorID,

# Vendor Product Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $VendorProductNumber,

# Manufacturer Account Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $ManufacturerName,

# Manufacturer Product Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $ManufacturerProductName,

# Active
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $Active,

# Period Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $PeriodType,

# Allocation Code ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $ProductAllocationCodeID,

# Is Serialized
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $Serialized,

# Cost Allocation Code ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CostAllocationCodeID,

# Does Not Require Procurement
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $DoesNotRequireProcurement,

# markup_rate
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $MarkupRate,

# Internal Product ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $InternalProductID,

# Billing Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $BillingType,

# Price Cost Method
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $PriceCostMethod,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'SKU', 'Link', 'ProductCategory', 'ExternalProductID', 'UnitCost', 'UnitPrice', 'MSRP', 'DefaultVendorID', 'VendorProductNumber', 'ManufacturerName', 'ManufacturerProductName', 'Active', 'PeriodType', 'ProductAllocationCodeID', 'Serialized', 'CostAllocationCodeID', 'DoesNotRequireProcurement', 'MarkupRate', 'InternalProductID', 'BillingType', 'PriceCostMethod')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'SKU', 'Link', 'ProductCategory', 'ExternalProductID', 'UnitCost', 'UnitPrice', 'MSRP', 'DefaultVendorID', 'VendorProductNumber', 'ManufacturerName', 'ManufacturerProductName', 'Active', 'PeriodType', 'ProductAllocationCodeID', 'Serialized', 'CostAllocationCodeID', 'DoesNotRequireProcurement', 'MarkupRate', 'InternalProductID', 'BillingType', 'PriceCostMethod')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'SKU', 'Link', 'ProductCategory', 'ExternalProductID', 'UnitCost', 'UnitPrice', 'MSRP', 'DefaultVendorID', 'VendorProductNumber', 'ManufacturerName', 'ManufacturerProductName', 'Active', 'PeriodType', 'ProductAllocationCodeID', 'Serialized', 'CostAllocationCodeID', 'DoesNotRequireProcurement', 'MarkupRate', 'InternalProductID', 'BillingType', 'PriceCostMethod')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'SKU', 'Link', 'ProductCategory', 'ExternalProductID', 'UnitCost', 'UnitPrice', 'MSRP', 'DefaultVendorID', 'VendorProductNumber', 'ManufacturerName', 'ManufacturerProductName', 'PeriodType', 'ProductAllocationCodeID', 'CostAllocationCodeID', 'MarkupRate', 'InternalProductID', 'BillingType', 'PriceCostMethod')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'SKU', 'Link', 'ProductCategory', 'ExternalProductID', 'UnitCost', 'UnitPrice', 'MSRP', 'DefaultVendorID', 'VendorProductNumber', 'ManufacturerName', 'ManufacturerProductName', 'PeriodType', 'ProductAllocationCodeID', 'CostAllocationCodeID', 'MarkupRate', 'InternalProductID', 'BillingType', 'PriceCostMethod')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'SKU', 'Link', 'ProductCategory', 'ExternalProductID', 'UnitCost', 'UnitPrice', 'MSRP', 'DefaultVendorID', 'VendorProductNumber', 'ManufacturerName', 'ManufacturerProductName', 'PeriodType', 'ProductAllocationCodeID', 'CostAllocationCodeID', 'MarkupRate', 'InternalProductID', 'BillingType', 'PriceCostMethod')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'SKU', 'Link', 'ProductCategory', 'ExternalProductID', 'UnitCost', 'UnitPrice', 'MSRP', 'DefaultVendorID', 'VendorProductNumber', 'ManufacturerName', 'ManufacturerProductName', 'PeriodType', 'ProductAllocationCodeID', 'CostAllocationCodeID', 'MarkupRate', 'InternalProductID', 'BillingType', 'PriceCostMethod')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'SKU', 'Link', 'ExternalProductID', 'VendorProductNumber', 'ManufacturerName', 'ManufacturerProductName', 'PeriodType', 'InternalProductID')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'SKU', 'Link', 'ExternalProductID', 'VendorProductNumber', 'ManufacturerName', 'ManufacturerProductName', 'PeriodType', 'InternalProductID')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'SKU', 'Link', 'ExternalProductID', 'VendorProductNumber', 'ManufacturerName', 'ManufacturerProductName', 'PeriodType', 'InternalProductID')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'SKU', 'Link', 'ExternalProductID', 'VendorProductNumber', 'ManufacturerName', 'ManufacturerProductName', 'PeriodType', 'InternalProductID')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'SKU', 'Link', 'ExternalProductID', 'VendorProductNumber', 'ManufacturerName', 'ManufacturerProductName', 'PeriodType', 'InternalProductID')]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'Product'
    
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
      $Result = Get-AtwsData -Entity $EntityName -Filter $Filter -NoPickListLabel:$NoPickListLabel.IsPresent
    
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
