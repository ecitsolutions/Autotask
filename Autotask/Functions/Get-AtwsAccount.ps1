#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsAccount
{


<#
.SYNOPSIS
This function get one or more Account through the Autotask Web Services API.
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
AccountType
KeyAccountIcon
TerritoryID
MarketSegmentID
CompetitorID
BillToAddressToUse
InvoiceMethod
ApiVendorID
PurchaseOrderTemplateID

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Account[]]. This function outputs the Autotask.Account that was returned by the API.
.EXAMPLE
Get-AtwsAccount -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsAccount -AccountName SomeName
Returns the object with AccountName 'SomeName', if any.
 .EXAMPLE
Get-AtwsAccount -AccountName 'Some Name'
Returns the object with AccountName 'Some Name', if any.
 .EXAMPLE
Get-AtwsAccount -AccountName 'Some Name' -NotEquals AccountName
Returns any objects with a AccountName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsAccount -AccountName SomeName* -Like AccountName
Returns any object with a AccountName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsAccount -AccountName SomeName* -NotLike AccountName
Returns any object with a AccountName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsAccount -AccountType <PickList Label>
Returns any Accounts with property AccountType equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsAccount -AccountType <PickList Label> -NotEquals AccountType 
Returns any Accounts with property AccountType NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsAccount -AccountType <PickList Label1>, <PickList Label2>
Returns any Accounts with property AccountType equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsAccount -AccountType <PickList Label1>, <PickList Label2> -NotEquals AccountType
Returns any Accounts with property AccountType NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsAccount -Id 1234 -AccountName SomeName* -AccountType <PickList Label1>, <PickList Label2> -Like AccountName -NotEquals AccountType -GreaterThan Id
An example of a more complex query. This command returns any Accounts with Id GREATER THAN 1234, a AccountName that matches the simple pattern SomeName* AND that has a AccountType that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsAccount
 .LINK
Set-AtwsAccount

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
    [Collections.Generic.List[string]]
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
    [ValidateSet('BillToAccountPhysicalLocationID', 'BillToCountryID', 'CountryID', 'CreatedByResourceID', 'CurrencyID', 'ImpersonatorCreatorResourceID', 'InvoiceTemplateID', 'OwnerResourceID', 'ParentAccountID', 'QuoteTemplateID', 'TaxRegionID')]
    [string]
    $GetReferenceEntityById,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# A single user defined field can be used pr query
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('UDF')]
    [ValidateNotNullOrEmpty()]
    [Autotask.UserDefinedField]
    $UserDefinedField,

# Client Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('Name')]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [Collections.Generic.List[string]]
    $AccountName,

# Client Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [Collections.Generic.List[string]]
    $AccountNumber,

# Client Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Account -FieldName AccountType -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Account -FieldName AccountType -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $AccountType,

# Account Active
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[boolean]]]
    $Active,

# Additional Address Information
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [Collections.Generic.List[string]]
    $AdditionalAddressInformation,

# Address 1
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [Collections.Generic.List[string]]
    $Address1,

# Address 2
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [Collections.Generic.List[string]]
    $Address2,

# Alternate Phone 1
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [Collections.Generic.List[string]]
    $AlternatePhone1,

# Alternate Phone 2
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [Collections.Generic.List[string]]
    $AlternatePhone2,

# API Vendor ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Account -FieldName ApiVendorID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Account -FieldName ApiVendorID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $ApiVendorID,

# Bill To Account Physical Location ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $BillToAccountPhysicalLocationID,

# Bill To Additional Address Information
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [Collections.Generic.List[string]]
    $BillToAdditionalAddressInformation,

# Bill To Address Line 1
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,150)]
    [Collections.Generic.List[string]]
    $BillToAddress1,

# Bill To Address Line 2
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,150)]
    [Collections.Generic.List[string]]
    $BillToAddress2,

# Bill To Address to Use
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Account -FieldName BillToAddressToUse -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Account -FieldName BillToAddressToUse -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $BillToAddressToUse,

# Bill To Attention
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [Collections.Generic.List[string]]
    $BillToAttention,

# Bill To City
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [Collections.Generic.List[string]]
    $BillToCity,

# Bill To Country ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $BillToCountryID,

# Bill To County
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [Collections.Generic.List[string]]
    $BillToState,

# Bill To Postal Code
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [Collections.Generic.List[string]]
    $BillToZipCode,

# City
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,30)]
    [Collections.Generic.List[string]]
    $City,

# Client Portal Active
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[boolean]]]
    $ClientPortalActive,

# Competitor
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Account -FieldName CompetitorID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Account -FieldName CompetitorID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $CompetitorID,

# Country
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [Collections.Generic.List[string]]
    $Country,

# Country ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $CountryID,

# Create Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[datetime]]]
    $CreateDate,

# Created By Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $CreatedByResourceID,

# Currency ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $CurrencyID,

# Enabled For Comanaged
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[boolean]]]
    $EnabledForComanaged,

# Fax
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [Collections.Generic.List[string]]
    $Fax,

# Client ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[long]]]
    $id,

# Impersonator Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $ImpersonatorCreatorResourceID,

# Invoice Email Message ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $InvoiceEmailMessageID,

# Transmission Method
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Account -FieldName InvoiceMethod -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Account -FieldName InvoiceMethod -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $InvoiceMethod,

# Invoice non contract items to Parent Client
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[boolean]]]
    $InvoiceNonContractItemsToParentAccount,

# Invoice Template ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $InvoiceTemplateID,

# Key Account Icon
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Account -FieldName KeyAccountIcon -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Account -FieldName KeyAccountIcon -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $KeyAccountIcon,

# Last Activity Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[datetime]]]
    $LastActivityDate,

# Last Modified Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[datetime]]]
    $LastTrackedModifiedDateTime,

# Market Segment
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Account -FieldName MarketSegmentID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Account -FieldName MarketSegmentID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $MarketSegmentID,

# Client Owner
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[Int]]]
    $OwnerResourceID,

# Parent Client
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $ParentAccountID,

# Phone
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,25)]
    [Collections.Generic.List[string]]
    $Phone,

# Postal Code
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,10)]
    [Collections.Generic.List[string]]
    $PostalCode,

# Purchase Order Template ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Account -FieldName PurchaseOrderTemplateID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Account -FieldName PurchaseOrderTemplateID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $PurchaseOrderTemplateID,

# Quote Email Message ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $QuoteEmailMessageID,

# Quote Template ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $QuoteTemplateID,

# County
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,40)]
    [Collections.Generic.List[string]]
    $State,

# Survey Account Rating
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $SurveyAccountRating,

# TaskFire Active
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[boolean]]]
    $TaskFireActive,

# Tax Exempt
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[boolean]]]
    $TaxExempt,

# Tax ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [Collections.Generic.List[string]]
    $TaxID,

# Tax Region ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $TaxRegionID,

# Territory Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Account -FieldName TerritoryID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Account -FieldName TerritoryID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $TerritoryID,

# Web
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [Collections.Generic.List[string]]
    $WebAddress,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('BillToAttention', 'BillToZipCode', 'InvoiceEmailMessageID', 'AlternatePhone2', 'ParentAccountID', 'StockSymbol', 'ApiVendorID', 'AdditionalAddressInformation', 'SICCode', 'OwnerResourceID', 'id', 'BillToCountryID', 'TaxRegionID', 'InvoiceNonContractItemsToParentAccount', 'CreatedByResourceID', 'BillToAccountPhysicalLocationID', 'CreateDate', 'State', 'City', 'CountryID', 'Address1', 'AccountName', 'BillToAddressToUse', 'CompetitorID', 'LastActivityDate', 'AssetValue', 'Phone', 'WebAddress', 'PurchaseOrderTemplateID', 'MarketSegmentID', 'BillToCity', 'ImpersonatorCreatorResourceID', 'TaxExempt', 'KeyAccountIcon', 'StockMarket', 'TaxID', 'InvoiceTemplateID', 'BillToAddress1', 'SurveyAccountRating', 'EnabledForComanaged', 'TerritoryID', 'ClientPortalActive', 'LastTrackedModifiedDateTime', 'PostalCode', 'AlternatePhone1', 'Country', 'QuoteTemplateID', 'AccountNumber', 'BillToAddress2', 'BillToAdditionalAddressInformation', 'TaskFireActive', 'Address2', 'QuoteEmailMessageID', 'CurrencyID', 'InvoiceMethod', 'Active', 'Fax', 'AccountType', 'BillToState', '')]
    [Collections.Generic.List[string]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('BillToAttention', 'BillToZipCode', 'InvoiceEmailMessageID', 'AlternatePhone2', 'ParentAccountID', 'StockSymbol', 'ApiVendorID', 'AdditionalAddressInformation', 'SICCode', 'OwnerResourceID', 'id', 'BillToCountryID', 'TaxRegionID', 'InvoiceNonContractItemsToParentAccount', 'CreatedByResourceID', 'BillToAccountPhysicalLocationID', 'CreateDate', 'State', 'City', 'CountryID', 'Address1', 'AccountName', 'BillToAddressToUse', 'CompetitorID', 'LastActivityDate', 'AssetValue', 'Phone', 'WebAddress', 'PurchaseOrderTemplateID', 'MarketSegmentID', 'BillToCity', 'ImpersonatorCreatorResourceID', 'TaxExempt', 'KeyAccountIcon', 'StockMarket', 'TaxID', 'InvoiceTemplateID', 'BillToAddress1', 'SurveyAccountRating', 'EnabledForComanaged', 'TerritoryID', 'ClientPortalActive', 'LastTrackedModifiedDateTime', 'PostalCode', 'AlternatePhone1', 'Country', 'QuoteTemplateID', 'AccountNumber', 'BillToAddress2', 'BillToAdditionalAddressInformation', 'TaskFireActive', 'Address2', 'QuoteEmailMessageID', 'CurrencyID', 'InvoiceMethod', 'Active', 'Fax', 'AccountType', 'BillToState', '')]
    [Collections.Generic.List[string]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('BillToAttention', 'BillToZipCode', 'InvoiceEmailMessageID', 'AlternatePhone2', 'ParentAccountID', 'StockSymbol', 'ApiVendorID', 'AdditionalAddressInformation', 'SICCode', 'OwnerResourceID', 'id', 'BillToCountryID', 'TaxRegionID', 'InvoiceNonContractItemsToParentAccount', 'CreatedByResourceID', 'BillToAccountPhysicalLocationID', 'CreateDate', 'State', 'City', 'CountryID', 'Address1', 'AccountName', 'BillToAddressToUse', 'CompetitorID', 'LastActivityDate', 'AssetValue', 'Phone', 'WebAddress', 'PurchaseOrderTemplateID', 'MarketSegmentID', 'BillToCity', 'ImpersonatorCreatorResourceID', 'TaxExempt', 'KeyAccountIcon', 'StockMarket', 'TaxID', 'InvoiceTemplateID', 'BillToAddress1', 'SurveyAccountRating', 'EnabledForComanaged', 'TerritoryID', 'ClientPortalActive', 'LastTrackedModifiedDateTime', 'PostalCode', 'AlternatePhone1', 'Country', 'QuoteTemplateID', 'AccountNumber', 'BillToAddress2', 'BillToAdditionalAddressInformation', 'TaskFireActive', 'Address2', 'QuoteEmailMessageID', 'CurrencyID', 'InvoiceMethod', 'Active', 'Fax', 'AccountType', 'BillToState', '')]
    [Collections.Generic.List[string]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountName', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'Country', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax', 'WebAddress', 'AccountType', 'KeyAccountIcon', 'OwnerResourceID', 'TerritoryID', 'MarketSegmentID', 'CompetitorID', 'ParentAccountID', 'StockSymbol', 'StockMarket', 'SICCode', 'AssetValue', 'AccountNumber', 'CreateDate', 'LastActivityDate', 'TaxRegionID', 'TaxID', 'AdditionalAddressInformation', 'CountryID', 'BillToAddressToUse', 'BillToAttention', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToZipCode', 'BillToCountryID', 'BillToAdditionalAddressInformation', 'InvoiceMethod', 'QuoteTemplateID', 'QuoteEmailMessageID', 'InvoiceTemplateID', 'InvoiceEmailMessageID', 'CurrencyID', 'BillToAccountPhysicalLocationID', 'SurveyAccountRating', 'CreatedByResourceID', 'ApiVendorID', 'ImpersonatorCreatorResourceID', 'LastTrackedModifiedDateTime', 'PurchaseOrderTemplateID', 'UserDefinedField')]
    [Collections.Generic.List[string]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountName', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'Country', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax', 'WebAddress', 'AccountType', 'KeyAccountIcon', 'OwnerResourceID', 'TerritoryID', 'MarketSegmentID', 'CompetitorID', 'ParentAccountID', 'StockSymbol', 'StockMarket', 'SICCode', 'AssetValue', 'AccountNumber', 'CreateDate', 'LastActivityDate', 'TaxRegionID', 'TaxID', 'AdditionalAddressInformation', 'CountryID', 'BillToAddressToUse', 'BillToAttention', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToZipCode', 'BillToCountryID', 'BillToAdditionalAddressInformation', 'InvoiceMethod', 'QuoteTemplateID', 'QuoteEmailMessageID', 'InvoiceTemplateID', 'InvoiceEmailMessageID', 'CurrencyID', 'BillToAccountPhysicalLocationID', 'SurveyAccountRating', 'CreatedByResourceID', 'ApiVendorID', 'ImpersonatorCreatorResourceID', 'LastTrackedModifiedDateTime', 'PurchaseOrderTemplateID', 'UserDefinedField')]
    [Collections.Generic.List[string]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountName', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'Country', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax', 'WebAddress', 'AccountType', 'KeyAccountIcon', 'OwnerResourceID', 'TerritoryID', 'MarketSegmentID', 'CompetitorID', 'ParentAccountID', 'StockSymbol', 'StockMarket', 'SICCode', 'AssetValue', 'AccountNumber', 'CreateDate', 'LastActivityDate', 'TaxRegionID', 'TaxID', 'AdditionalAddressInformation', 'CountryID', 'BillToAddressToUse', 'BillToAttention', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToZipCode', 'BillToCountryID', 'BillToAdditionalAddressInformation', 'InvoiceMethod', 'QuoteTemplateID', 'QuoteEmailMessageID', 'InvoiceTemplateID', 'InvoiceEmailMessageID', 'CurrencyID', 'BillToAccountPhysicalLocationID', 'SurveyAccountRating', 'CreatedByResourceID', 'ApiVendorID', 'ImpersonatorCreatorResourceID', 'LastTrackedModifiedDateTime', 'PurchaseOrderTemplateID', 'UserDefinedField')]
    [Collections.Generic.List[string]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountName', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'Country', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax', 'WebAddress', 'AccountType', 'KeyAccountIcon', 'OwnerResourceID', 'TerritoryID', 'MarketSegmentID', 'CompetitorID', 'ParentAccountID', 'StockSymbol', 'StockMarket', 'SICCode', 'AssetValue', 'AccountNumber', 'CreateDate', 'LastActivityDate', 'TaxRegionID', 'TaxID', 'AdditionalAddressInformation', 'CountryID', 'BillToAddressToUse', 'BillToAttention', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToZipCode', 'BillToCountryID', 'BillToAdditionalAddressInformation', 'InvoiceMethod', 'QuoteTemplateID', 'QuoteEmailMessageID', 'InvoiceTemplateID', 'InvoiceEmailMessageID', 'CurrencyID', 'BillToAccountPhysicalLocationID', 'SurveyAccountRating', 'CreatedByResourceID', 'ApiVendorID', 'ImpersonatorCreatorResourceID', 'LastTrackedModifiedDateTime', 'PurchaseOrderTemplateID', 'UserDefinedField')]
    [Collections.Generic.List[string]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountName', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'Country', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax', 'WebAddress', 'StockSymbol', 'StockMarket', 'SICCode', 'AccountNumber', 'TaxID', 'AdditionalAddressInformation', 'BillToAttention', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToZipCode', 'BillToAdditionalAddressInformation', 'UserDefinedField')]
    [Collections.Generic.List[string]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountName', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'Country', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax', 'WebAddress', 'StockSymbol', 'StockMarket', 'SICCode', 'AccountNumber', 'TaxID', 'AdditionalAddressInformation', 'BillToAttention', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToZipCode', 'BillToAdditionalAddressInformation', 'UserDefinedField')]
    [Collections.Generic.List[string]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountName', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'Country', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax', 'WebAddress', 'StockSymbol', 'StockMarket', 'SICCode', 'AccountNumber', 'TaxID', 'AdditionalAddressInformation', 'BillToAttention', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToZipCode', 'BillToAdditionalAddressInformation', 'UserDefinedField')]
    [Collections.Generic.List[string]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountName', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'Country', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax', 'WebAddress', 'StockSymbol', 'StockMarket', 'SICCode', 'AccountNumber', 'TaxID', 'AdditionalAddressInformation', 'BillToAttention', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToZipCode', 'BillToAdditionalAddressInformation', 'UserDefinedField')]
    [Collections.Generic.List[string]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountName', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'Country', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax', 'WebAddress', 'StockSymbol', 'StockMarket', 'SICCode', 'AccountNumber', 'TaxID', 'AdditionalAddressInformation', 'BillToAttention', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToZipCode', 'BillToAdditionalAddressInformation', 'UserDefinedField')]
    [Collections.Generic.List[string]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'LastActivityDate', 'LastTrackedModifiedDateTime', 'UserDefinedField')]
    [Collections.Generic.List[string]]
    $IsThisDay
  )

    begin {
        $entityName = 'Account'

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

        $result = [collections.generic.list[psobject]]::new()
        $iterations = [collections.generic.list[psobject]]::new()
    }


    process {
        # Parameterset Get_All has a single parameter: -All
        # Set the Filter manually to get every single object of this type
        if ($PSCmdlet.ParameterSetName -eq 'Get_all') {
            $Filter = @('id', '-ge', 0)
            $iterations.Add($Filter)
        }
        # So it is not -All. If Filter does not exist it has to be By_parameters
        elseif (-not ($Filter)) {

            Write-Debug ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)

           
            # Count the values of the first parameter passed. We will not try do to this on more than 1 parameter, nor on any 
            # other parameter than the first. This is lazy, but efficient.
            $count = $PSBoundParameters.Values[0].count

            # If the count is less than or equal to 200 we pass PSBoundParameters as is
            if ($count -le 200) {
                [collections.generic.list[string]]$Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $entityName
                $iterations.Add($Filter)
            }
            # More than 200 values. This will cause a SQL query nested too much. Break a single parameter
            # into segments and create multiple queries with max 200 values
            else {
                # Deduplicate the value list or the same ID may be included in more than 1 query
                $outerLoop = $PSBoundParameters.Values[0] | Sort-Object -Unique

                Write-Verbose ('{0}: Received {1} objects containing {2} unique values for parameter {3}' -f $MyInvocation.MyCommand.Name, $count, $outerLoop.Count, $param)

                # Make a writable copy of PSBoundParameters
                $BoundParameters = $PSBoundParameters
                for ($i = 0; $i -lt $outerLoop.count; $i += 200) {
                    $j = $i + 199
                    if ($j -ge $outerLoop.count) {
                        $j = $outerLoop.count - 1
                    }

                    # make a selection
                    $BoundParameters[$param] = $outerLoop[$i .. $j]

                    Write-Verbose ('{0}: Asking for {1} values {2} to {3}' -f $MyInvocation.MyCommand.Name, $param, $i, $j)

                    # Convert named parameters to a filter definition that can be parsed to QueryXML
                    [collections.generic.list[string]]$Filter = ConvertTo-AtwsFilter -BoundParameters $BoundParameters -EntityName $entityName
                    $iterations.Add($Filter)
                }
            }
        }
        # Not parameters, nor Get_all. There are only three parameter sets, so now we know
        # that we were passed a Filter
        else {

            Write-Debug ('{0}: Query based on manual filter, parsing' -F $MyInvocation.MyCommand.Name)

            # Parse the filter string and expand variables in _this_ scope (dot-sourcing)
            # or the variables will not be available and expansion will fail
            $Filter = . Update-AtwsFilter -Filterstring $Filter
            $iterations.Add($Filter)
        }

        # Prepare shouldProcess comments
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to query the Autotask Web API for {1}(s).' -F $caption, $entityName
        $verboseWarning = '{0}: About to query the Autotask Web API for {1}(s). Do you want to continue?' -F $caption, $entityName

        # Lets do it and say we didn't!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) {
            foreach ($Filter in $iterations) {

                try {
                    # Make the query and pass the optional parameters to Get-AtwsData
                    # Force list even if result is only 1 object to be compatible with addrange()
                    [collections.generic.list[psobject]]$response = Get-AtwsData -Entity $entityName -Filter $Filter `
                        -NoPickListLabel:$NoPickListLabel.IsPresent `
                        -GetReferenceEntityById $GetReferenceEntityById
                }
                catch {
                    write-host "ERROR: " -ForegroundColor Red -NoNewline
                    write-host $_.Exception.Message
                    write-host ("{0}: {1}" -f $_.CategoryInfo.Category,$_.CategoryInfo.Reason) -ForegroundColor Cyan
                    $_.ScriptStackTrace -split '\n' | ForEach-Object {
                        Write-host "  |  " -ForegroundColor Cyan -NoNewline
                        Write-host $_
                    }
                }
                # Add response to result
                $result.AddRange($response)

                Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $result.Count)
            }
        }
    }

    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        if ($result) {
            Return [array]$result
        }
    }


}
