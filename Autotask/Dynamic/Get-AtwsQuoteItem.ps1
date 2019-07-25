#Requires -Version 4.0
#Version 1.6.2.17
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsQuoteItem
{


<#
.SYNOPSIS
This function get one or more QuoteItem through the Autotask Web Services API.
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
 

PeriodType
 

Entities that have fields that refer to the base entity of this CmdLet:

ContractService
 ContractServiceAdjustment
 ContractServiceBundle
 ContractServiceBundleAdjustment

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.QuoteItem[]]. This function outputs the Autotask.QuoteItem that was returned by the API.
.EXAMPLE
Get-AtwsQuoteItem -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsQuoteItem -QuoteItemName SomeName
Returns the object with QuoteItemName 'SomeName', if any.
 .EXAMPLE
Get-AtwsQuoteItem -QuoteItemName 'Some Name'
Returns the object with QuoteItemName 'Some Name', if any.
 .EXAMPLE
Get-AtwsQuoteItem -QuoteItemName 'Some Name' -NotEquals QuoteItemName
Returns any objects with a QuoteItemName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsQuoteItem -QuoteItemName SomeName* -Like QuoteItemName
Returns any object with a QuoteItemName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsQuoteItem -QuoteItemName SomeName* -NotLike QuoteItemName
Returns any object with a QuoteItemName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsQuoteItem -Type <PickList Label>
Returns any QuoteItems with property Type equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsQuoteItem -Type <PickList Label> -NotEquals Type 
Returns any QuoteItems with property Type NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsQuoteItem -Type <PickList Label1>, <PickList Label2>
Returns any QuoteItems with property Type equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsQuoteItem -Type <PickList Label1>, <PickList Label2> -NotEquals Type
Returns any QuoteItems with property Type NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsQuoteItem -Id 1234 -QuoteItemName SomeName* -Type <PickList Label1>, <PickList Label2> -Like QuoteItemName -NotEquals Type -GreaterThan Id
An example of a more complex query. This command returns any QuoteItems with Id GREATER THAN 1234, a QuoteItemName that matches the simple pattern SomeName* AND that has a Type that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsQuoteItem
 .LINK
Remove-AtwsQuoteItem
 .LINK
Set-AtwsQuoteItem

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
    [ValidateSet('CostID', 'ExpenseID', 'LaborID', 'ProductID', 'QuoteID', 'ServiceBundleID', 'ServiceID', 'ShippingID', 'TaxCategoryID')]
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
    [ValidateSet('ContractService:QuoteItemID', 'ContractServiceAdjustment:QuoteItemID', 'ContractServiceBundle:QuoteItemID', 'ContractServiceBundleAdjustment:QuoteItemID')]
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

# quote_id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $QuoteID,

# quote_item_id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# parent_type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $Type,

# product_id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ProductID,

# cost_id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CostID,

# labor_id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $LaborID,

# expense_id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ExpenseID,

# shipping_id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ShippingID,

# service_id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ServiceID,

# service_bundle_id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ServiceBundleID,

# quote_item_name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $Name,

# unit_price
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $UnitPrice,

# unit_cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $UnitCost,

# quantity
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[double][]]
    $Quantity,

# discount_dollars
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[double][]]
    $UnitDiscount,

# discount_percent
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[double][]]
    $PercentageDiscount,

# taxable
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $IsTaxable,

# optional
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $IsOptional,

# period_type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $PeriodType,

# quote_item_description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string[]]
    $Description,

# line_discount_dollars
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[double][]]
    $LineDiscount,

# tax_category_id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $TaxCategoryID,

# tax_rate_applied
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $TotalEffectiveTax,

# markup_rate
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $MarkupRate,

# internal_currency_unit_price
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $InternalCurrencyUnitPrice,

# internal_currency_discount_dollars
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $InternalCurrencyUnitDiscount,

# internal_currency_line_discount_dollars
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $InternalCurrencyLineDiscount,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('QuoteID', 'id', 'Type', 'ProductID', 'CostID', 'LaborID', 'ExpenseID', 'ShippingID', 'ServiceID', 'ServiceBundleID', 'Name', 'UnitPrice', 'UnitCost', 'Quantity', 'UnitDiscount', 'PercentageDiscount', 'IsTaxable', 'IsOptional', 'PeriodType', 'Description', 'LineDiscount', 'TaxCategoryID', 'TotalEffectiveTax', 'MarkupRate', 'InternalCurrencyUnitPrice', 'InternalCurrencyUnitDiscount', 'InternalCurrencyLineDiscount')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('QuoteID', 'id', 'Type', 'ProductID', 'CostID', 'LaborID', 'ExpenseID', 'ShippingID', 'ServiceID', 'ServiceBundleID', 'Name', 'UnitPrice', 'UnitCost', 'Quantity', 'UnitDiscount', 'PercentageDiscount', 'IsTaxable', 'IsOptional', 'PeriodType', 'Description', 'LineDiscount', 'TaxCategoryID', 'TotalEffectiveTax', 'MarkupRate', 'InternalCurrencyUnitPrice', 'InternalCurrencyUnitDiscount', 'InternalCurrencyLineDiscount')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('QuoteID', 'id', 'Type', 'ProductID', 'CostID', 'LaborID', 'ExpenseID', 'ShippingID', 'ServiceID', 'ServiceBundleID', 'Name', 'UnitPrice', 'UnitCost', 'Quantity', 'UnitDiscount', 'PercentageDiscount', 'IsTaxable', 'IsOptional', 'PeriodType', 'Description', 'LineDiscount', 'TaxCategoryID', 'TotalEffectiveTax', 'MarkupRate', 'InternalCurrencyUnitPrice', 'InternalCurrencyUnitDiscount', 'InternalCurrencyLineDiscount')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('QuoteID', 'id', 'Type', 'ProductID', 'CostID', 'LaborID', 'ExpenseID', 'ShippingID', 'ServiceID', 'ServiceBundleID', 'Name', 'UnitPrice', 'UnitCost', 'Quantity', 'UnitDiscount', 'PercentageDiscount', 'PeriodType', 'Description', 'LineDiscount', 'TaxCategoryID', 'TotalEffectiveTax', 'MarkupRate', 'InternalCurrencyUnitPrice', 'InternalCurrencyUnitDiscount', 'InternalCurrencyLineDiscount')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('QuoteID', 'id', 'Type', 'ProductID', 'CostID', 'LaborID', 'ExpenseID', 'ShippingID', 'ServiceID', 'ServiceBundleID', 'Name', 'UnitPrice', 'UnitCost', 'Quantity', 'UnitDiscount', 'PercentageDiscount', 'PeriodType', 'Description', 'LineDiscount', 'TaxCategoryID', 'TotalEffectiveTax', 'MarkupRate', 'InternalCurrencyUnitPrice', 'InternalCurrencyUnitDiscount', 'InternalCurrencyLineDiscount')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('QuoteID', 'id', 'Type', 'ProductID', 'CostID', 'LaborID', 'ExpenseID', 'ShippingID', 'ServiceID', 'ServiceBundleID', 'Name', 'UnitPrice', 'UnitCost', 'Quantity', 'UnitDiscount', 'PercentageDiscount', 'PeriodType', 'Description', 'LineDiscount', 'TaxCategoryID', 'TotalEffectiveTax', 'MarkupRate', 'InternalCurrencyUnitPrice', 'InternalCurrencyUnitDiscount', 'InternalCurrencyLineDiscount')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('QuoteID', 'id', 'Type', 'ProductID', 'CostID', 'LaborID', 'ExpenseID', 'ShippingID', 'ServiceID', 'ServiceBundleID', 'Name', 'UnitPrice', 'UnitCost', 'Quantity', 'UnitDiscount', 'PercentageDiscount', 'PeriodType', 'Description', 'LineDiscount', 'TaxCategoryID', 'TotalEffectiveTax', 'MarkupRate', 'InternalCurrencyUnitPrice', 'InternalCurrencyUnitDiscount', 'InternalCurrencyLineDiscount')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'PeriodType', 'Description')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'PeriodType', 'Description')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'PeriodType', 'Description')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'PeriodType', 'Description')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'PeriodType', 'Description')]
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
    $EntityName = 'QuoteItem'
    
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
