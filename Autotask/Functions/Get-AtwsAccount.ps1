#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) Hugo Klemmestad. All rights reserved. Licensed under the MIT license.
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
Get-AtwsAccount -AccountType 'PickList Label'
Returns any Accounts with property AccountType equal to the 'PickList Label'. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsAccount -AccountType 'PickList Label' -NotEquals AccountType 
Returns any Accounts with property AccountType NOT equal to the 'PickList Label'.
 .EXAMPLE
Get-AtwsAccount -AccountType 'PickList Label1', 'PickList Label2'
Returns any Accounts with property AccountType equal to EITHER 'PickList Label1' OR 'PickList Label2'.
 .EXAMPLE
Get-AtwsAccount -AccountType 'PickList Label1', 'PickList Label2' -NotEquals AccountType
Returns any Accounts with property AccountType NOT equal to NEITHER 'PickList Label1' NOR 'PickList Label2'.
 .EXAMPLE
Get-AtwsAccount -Id 1234 -AccountName SomeName* -AccountType 'PickList Label1', 'PickList Label2' -Like AccountName -NotEquals AccountType -GreaterThan Id
An example of a more complex query. This command returns any Accounts with Id GREATER THAN 1234, a AccountName that matches the simple pattern SomeName* AND that has a AccountType that is NOT equal to NEITHER 'PickList Label1' NOR 'PickList Label2'.

.NOTES
Related commands:
New-AtwsAccount
 Set-AtwsAccount

#>

  [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName='Filter', ConfirmImpact='None',
  HelpURI='https://github.com/ecitsolutions/Autotask/blob/master/Docs/Get-AtwsAccount.md')]
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

# Account Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('Name')]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [string[]]
    $AccountName,

# Account Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $AccountNumber,

# Account Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Account -FieldName AccountType -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Account -FieldName AccountType -Label) + (Get-AtwsPicklistValue -Entity Account -FieldName AccountType -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $AccountType,

# Account Active
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $Active,

# Additional Address Information
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $AdditionalAddressInformation,

# Address 1
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,150)]
    [string[]]
    $Address1,

# Address 2
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,150)]
    [string[]]
    $Address2,

# Alternate Phone 1
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $AlternatePhone1,

# Alternate Phone 2
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $AlternatePhone2,

# API Vendor ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Account -FieldName ApiVendorID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Account -FieldName ApiVendorID -Label) + (Get-AtwsPicklistValue -Entity Account -FieldName ApiVendorID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $ApiVendorID,

# Bill To Account Physical Location ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BillToAccountPhysicalLocationID,

# Bill To Additional Address Information
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $BillToAdditionalAddressInformation,

# Bill To Address Line 1
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,150)]
    [string[]]
    $BillToAddress1,

# Bill To Address Line 2
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,150)]
    [string[]]
    $BillToAddress2,

# Bill To Address to Use
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Account -FieldName BillToAddressToUse -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Account -FieldName BillToAddressToUse -Label) + (Get-AtwsPicklistValue -Entity Account -FieldName BillToAddressToUse -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $BillToAddressToUse,

# Bill To Attention
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $BillToAttention,

# Bill To City
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $BillToCity,

# Bill To Country ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BillToCountryID,

# Bill To State
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [string[]]
    $BillToState,

# Bill To Postal Code
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $BillToZipCode,

# City
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $City,

# Client Portal Active
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $ClientPortalActive,

# Competitor
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Account -FieldName CompetitorID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Account -FieldName CompetitorID -Label) + (Get-AtwsPicklistValue -Entity Account -FieldName CompetitorID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $CompetitorID,

# Country
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $Country,

# Country ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CountryID,

# Create Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CreateDate,

# Created By Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CreatedByResourceID,

# Currency ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CurrencyID,

# Enabled For Comanaged
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $EnabledForComanaged,

# Fax
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $Fax,

# Account ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Impersonator Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ImpersonatorCreatorResourceID,

# Invoice Email Message ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $InvoiceEmailMessageID,

# Transmission Method
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Account -FieldName InvoiceMethod -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Account -FieldName InvoiceMethod -Label) + (Get-AtwsPicklistValue -Entity Account -FieldName InvoiceMethod -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $InvoiceMethod,

# Invoice non contract items to Parent Account
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $InvoiceNonContractItemsToParentAccount,

# Invoice Template ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $InvoiceTemplateID,

# Key Account Icon
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Account -FieldName KeyAccountIcon -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Account -FieldName KeyAccountIcon -Label) + (Get-AtwsPicklistValue -Entity Account -FieldName KeyAccountIcon -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $KeyAccountIcon,

# Last Activity Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LastActivityDate,

# Last Modified Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LastTrackedModifiedDateTime,

# Market Segment
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Account -FieldName MarketSegmentID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Account -FieldName MarketSegmentID -Label) + (Get-AtwsPicklistValue -Entity Account -FieldName MarketSegmentID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $MarketSegmentID,

# Account Owner
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $OwnerResourceID,

# Parent Company
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ParentAccountID,

# Phone
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,25)]
    [string[]]
    $Phone,

# Postal Code
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,30)]
    [string[]]
    $PostalCode,

# Purchase Order Template ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Account -FieldName PurchaseOrderTemplateID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Account -FieldName PurchaseOrderTemplateID -Label) + (Get-AtwsPicklistValue -Entity Account -FieldName PurchaseOrderTemplateID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $PurchaseOrderTemplateID,

# Quote Email Message ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $QuoteEmailMessageID,

# Quote Template ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $QuoteTemplateID,

# State
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $State,

# Survey Account Rating
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $SurveyAccountRating,

# TaskFire Active
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $TaskFireActive,

# Tax Exempt
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $TaxExempt,

# Tax ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $TaxID,

# Tax Region ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $TaxRegionID,

# Territory Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Account -FieldName TerritoryID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Account -FieldName TerritoryID -Label) + (Get-AtwsPicklistValue -Entity Account -FieldName TerritoryID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $TerritoryID,

# Web
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string[]]
    $WebAddress,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountName', 'AccountNumber', 'AccountType', 'Active', 'AdditionalAddressInformation', 'Address1', 'Address2', 'AlternatePhone1', 'AlternatePhone2', 'ApiVendorID', 'AssetValue', 'BillToAccountPhysicalLocationID', 'BillToAdditionalAddressInformation', 'BillToAddress1', 'BillToAddress2', 'BillToAddressToUse', 'BillToAttention', 'BillToCity', 'BillToCountryID', 'BillToState', 'BillToZipCode', 'City', 'ClientPortalActive', 'CompetitorID', 'Country', 'CountryID', 'CreateDate', 'CreatedByResourceID', 'CurrencyID', 'EnabledForComanaged', 'Fax', 'id', 'ImpersonatorCreatorResourceID', 'InvoiceEmailMessageID', 'InvoiceMethod', 'InvoiceNonContractItemsToParentAccount', 'InvoiceTemplateID', 'KeyAccountIcon', 'LastActivityDate', 'LastTrackedModifiedDateTime', 'MarketSegmentID', 'OwnerResourceID', 'ParentAccountID', 'Phone', 'PostalCode', 'PurchaseOrderTemplateID', 'QuoteEmailMessageID', 'QuoteTemplateID', 'SICCode', 'State', 'StockMarket', 'StockSymbol', 'SurveyAccountRating', 'TaskFireActive', 'TaxExempt', 'TaxID', 'TaxRegionID', 'TerritoryID', 'WebAddress')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountName', 'AccountNumber', 'AccountType', 'Active', 'AdditionalAddressInformation', 'Address1', 'Address2', 'AlternatePhone1', 'AlternatePhone2', 'ApiVendorID', 'AssetValue', 'BillToAccountPhysicalLocationID', 'BillToAdditionalAddressInformation', 'BillToAddress1', 'BillToAddress2', 'BillToAddressToUse', 'BillToAttention', 'BillToCity', 'BillToCountryID', 'BillToState', 'BillToZipCode', 'City', 'ClientPortalActive', 'CompetitorID', 'Country', 'CountryID', 'CreateDate', 'CreatedByResourceID', 'CurrencyID', 'EnabledForComanaged', 'Fax', 'id', 'ImpersonatorCreatorResourceID', 'InvoiceEmailMessageID', 'InvoiceMethod', 'InvoiceNonContractItemsToParentAccount', 'InvoiceTemplateID', 'KeyAccountIcon', 'LastActivityDate', 'LastTrackedModifiedDateTime', 'MarketSegmentID', 'OwnerResourceID', 'ParentAccountID', 'Phone', 'PostalCode', 'PurchaseOrderTemplateID', 'QuoteEmailMessageID', 'QuoteTemplateID', 'SICCode', 'State', 'StockMarket', 'StockSymbol', 'SurveyAccountRating', 'TaskFireActive', 'TaxExempt', 'TaxID', 'TaxRegionID', 'TerritoryID', 'WebAddress')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountName', 'AccountNumber', 'AccountType', 'Active', 'AdditionalAddressInformation', 'Address1', 'Address2', 'AlternatePhone1', 'AlternatePhone2', 'ApiVendorID', 'AssetValue', 'BillToAccountPhysicalLocationID', 'BillToAdditionalAddressInformation', 'BillToAddress1', 'BillToAddress2', 'BillToAddressToUse', 'BillToAttention', 'BillToCity', 'BillToCountryID', 'BillToState', 'BillToZipCode', 'City', 'ClientPortalActive', 'CompetitorID', 'Country', 'CountryID', 'CreateDate', 'CreatedByResourceID', 'CurrencyID', 'EnabledForComanaged', 'Fax', 'id', 'ImpersonatorCreatorResourceID', 'InvoiceEmailMessageID', 'InvoiceMethod', 'InvoiceNonContractItemsToParentAccount', 'InvoiceTemplateID', 'KeyAccountIcon', 'LastActivityDate', 'LastTrackedModifiedDateTime', 'MarketSegmentID', 'OwnerResourceID', 'ParentAccountID', 'Phone', 'PostalCode', 'PurchaseOrderTemplateID', 'QuoteEmailMessageID', 'QuoteTemplateID', 'SICCode', 'State', 'StockMarket', 'StockSymbol', 'SurveyAccountRating', 'TaskFireActive', 'TaxExempt', 'TaxID', 'TaxRegionID', 'TerritoryID', 'WebAddress')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountName', 'AccountNumber', 'AccountType', 'AdditionalAddressInformation', 'Address1', 'Address2', 'AlternatePhone1', 'AlternatePhone2', 'ApiVendorID', 'AssetValue', 'BillToAccountPhysicalLocationID', 'BillToAdditionalAddressInformation', 'BillToAddress1', 'BillToAddress2', 'BillToAddressToUse', 'BillToAttention', 'BillToCity', 'BillToCountryID', 'BillToState', 'BillToZipCode', 'City', 'CompetitorID', 'Country', 'CountryID', 'CreateDate', 'CreatedByResourceID', 'CurrencyID', 'Fax', 'id', 'ImpersonatorCreatorResourceID', 'InvoiceEmailMessageID', 'InvoiceMethod', 'InvoiceTemplateID', 'KeyAccountIcon', 'LastActivityDate', 'LastTrackedModifiedDateTime', 'MarketSegmentID', 'OwnerResourceID', 'ParentAccountID', 'Phone', 'PostalCode', 'PurchaseOrderTemplateID', 'QuoteEmailMessageID', 'QuoteTemplateID', 'SICCode', 'State', 'StockMarket', 'StockSymbol', 'SurveyAccountRating', 'TaxID', 'TaxRegionID', 'TerritoryID', 'UserDefinedField', 'WebAddress')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountName', 'AccountNumber', 'AccountType', 'AdditionalAddressInformation', 'Address1', 'Address2', 'AlternatePhone1', 'AlternatePhone2', 'ApiVendorID', 'AssetValue', 'BillToAccountPhysicalLocationID', 'BillToAdditionalAddressInformation', 'BillToAddress1', 'BillToAddress2', 'BillToAddressToUse', 'BillToAttention', 'BillToCity', 'BillToCountryID', 'BillToState', 'BillToZipCode', 'City', 'CompetitorID', 'Country', 'CountryID', 'CreateDate', 'CreatedByResourceID', 'CurrencyID', 'Fax', 'id', 'ImpersonatorCreatorResourceID', 'InvoiceEmailMessageID', 'InvoiceMethod', 'InvoiceTemplateID', 'KeyAccountIcon', 'LastActivityDate', 'LastTrackedModifiedDateTime', 'MarketSegmentID', 'OwnerResourceID', 'ParentAccountID', 'Phone', 'PostalCode', 'PurchaseOrderTemplateID', 'QuoteEmailMessageID', 'QuoteTemplateID', 'SICCode', 'State', 'StockMarket', 'StockSymbol', 'SurveyAccountRating', 'TaxID', 'TaxRegionID', 'TerritoryID', 'UserDefinedField', 'WebAddress')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountName', 'AccountNumber', 'AccountType', 'AdditionalAddressInformation', 'Address1', 'Address2', 'AlternatePhone1', 'AlternatePhone2', 'ApiVendorID', 'AssetValue', 'BillToAccountPhysicalLocationID', 'BillToAdditionalAddressInformation', 'BillToAddress1', 'BillToAddress2', 'BillToAddressToUse', 'BillToAttention', 'BillToCity', 'BillToCountryID', 'BillToState', 'BillToZipCode', 'City', 'CompetitorID', 'Country', 'CountryID', 'CreateDate', 'CreatedByResourceID', 'CurrencyID', 'Fax', 'id', 'ImpersonatorCreatorResourceID', 'InvoiceEmailMessageID', 'InvoiceMethod', 'InvoiceTemplateID', 'KeyAccountIcon', 'LastActivityDate', 'LastTrackedModifiedDateTime', 'MarketSegmentID', 'OwnerResourceID', 'ParentAccountID', 'Phone', 'PostalCode', 'PurchaseOrderTemplateID', 'QuoteEmailMessageID', 'QuoteTemplateID', 'SICCode', 'State', 'StockMarket', 'StockSymbol', 'SurveyAccountRating', 'TaxID', 'TaxRegionID', 'TerritoryID', 'UserDefinedField', 'WebAddress')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountName', 'AccountNumber', 'AccountType', 'AdditionalAddressInformation', 'Address1', 'Address2', 'AlternatePhone1', 'AlternatePhone2', 'ApiVendorID', 'AssetValue', 'BillToAccountPhysicalLocationID', 'BillToAdditionalAddressInformation', 'BillToAddress1', 'BillToAddress2', 'BillToAddressToUse', 'BillToAttention', 'BillToCity', 'BillToCountryID', 'BillToState', 'BillToZipCode', 'City', 'CompetitorID', 'Country', 'CountryID', 'CreateDate', 'CreatedByResourceID', 'CurrencyID', 'Fax', 'id', 'ImpersonatorCreatorResourceID', 'InvoiceEmailMessageID', 'InvoiceMethod', 'InvoiceTemplateID', 'KeyAccountIcon', 'LastActivityDate', 'LastTrackedModifiedDateTime', 'MarketSegmentID', 'OwnerResourceID', 'ParentAccountID', 'Phone', 'PostalCode', 'PurchaseOrderTemplateID', 'QuoteEmailMessageID', 'QuoteTemplateID', 'SICCode', 'State', 'StockMarket', 'StockSymbol', 'SurveyAccountRating', 'TaxID', 'TaxRegionID', 'TerritoryID', 'UserDefinedField', 'WebAddress')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountName', 'AccountNumber', 'AdditionalAddressInformation', 'Address1', 'Address2', 'AlternatePhone1', 'AlternatePhone2', 'BillToAdditionalAddressInformation', 'BillToAddress1', 'BillToAddress2', 'BillToAttention', 'BillToCity', 'BillToState', 'BillToZipCode', 'City', 'Country', 'Fax', 'Phone', 'PostalCode', 'SICCode', 'State', 'StockMarket', 'StockSymbol', 'TaxID', 'UserDefinedField', 'WebAddress')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountName', 'AccountNumber', 'AdditionalAddressInformation', 'Address1', 'Address2', 'AlternatePhone1', 'AlternatePhone2', 'BillToAdditionalAddressInformation', 'BillToAddress1', 'BillToAddress2', 'BillToAttention', 'BillToCity', 'BillToState', 'BillToZipCode', 'City', 'Country', 'Fax', 'Phone', 'PostalCode', 'SICCode', 'State', 'StockMarket', 'StockSymbol', 'TaxID', 'UserDefinedField', 'WebAddress')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountName', 'AccountNumber', 'AdditionalAddressInformation', 'Address1', 'Address2', 'AlternatePhone1', 'AlternatePhone2', 'BillToAdditionalAddressInformation', 'BillToAddress1', 'BillToAddress2', 'BillToAttention', 'BillToCity', 'BillToState', 'BillToZipCode', 'City', 'Country', 'Fax', 'Phone', 'PostalCode', 'SICCode', 'State', 'StockMarket', 'StockSymbol', 'TaxID', 'UserDefinedField', 'WebAddress')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountName', 'AccountNumber', 'AdditionalAddressInformation', 'Address1', 'Address2', 'AlternatePhone1', 'AlternatePhone2', 'BillToAdditionalAddressInformation', 'BillToAddress1', 'BillToAddress2', 'BillToAttention', 'BillToCity', 'BillToState', 'BillToZipCode', 'City', 'Country', 'Fax', 'Phone', 'PostalCode', 'SICCode', 'State', 'StockMarket', 'StockSymbol', 'TaxID', 'UserDefinedField', 'WebAddress')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountName', 'AccountNumber', 'AdditionalAddressInformation', 'Address1', 'Address2', 'AlternatePhone1', 'AlternatePhone2', 'BillToAdditionalAddressInformation', 'BillToAddress1', 'BillToAddress2', 'BillToAttention', 'BillToCity', 'BillToState', 'BillToZipCode', 'City', 'Country', 'Fax', 'Phone', 'PostalCode', 'SICCode', 'State', 'StockMarket', 'StockSymbol', 'TaxID', 'UserDefinedField', 'WebAddress')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'LastActivityDate', 'LastTrackedModifiedDateTime', 'UserDefinedField')]
    [string[]]
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

            # What is the highest number of values for a parameter and is it higher than 200?
            $max = $PSBoundParameters.Values[0].length | Measure-Object -Maximum

            # If the count is less than or equal to 200 we pass PSBoundParameters as is
            if ($max.Maximum -le 200) {
                [collections.generic.list[string]]$Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $entityName
                $iterations.Add($Filter)
            }
            # More than 200 values. This will cause a SQL query nested too much error. Break a single parameter
            # into segments and create multiple queries with max 200 values
            else {
                
                # Find the parameter with the $max.Maximum number of items
                foreach ($param in $PSCmdlet.MyInvocation.BoundParameters.GetEnumerator() ) {
                    # When we have found the right parameter, stop iterating
                    if ($param.Value.length -eq $max.Maximum) { break }
                }
     
                # Deduplicate the value list or the same ID may be included in more than 1 query
                $outerLoop = $PSCmdlet.MyInvocation.BoundParameters.$($param.key) | Sort-Object -Unique

                Write-Verbose ('{0}: Received {1} objects containing {2} unique values for parameter {3}' -f $MyInvocation.MyCommand.Name, $count, $outerLoop.Count, $param.key)
                  
                for ($s = 0; $s -lt $outerLoop.count; $s += 200) {
                    $e = $s + 199
                    if ($e -ge $outerLoop.count) {
                        $e = $outerLoop.count - 1
                    }
                  
                    # Make writable of BoundParameters
                    $BoundParameters = $PSCmdlet.MyInvocation.BoundParameters

                    # make a selection
                    $BoundParameters.$($param.key) = $outerLoop[$s .. $e]

                    Write-Verbose ('{0}: Asking for {1} values {2} to {3}' -f $MyInvocation.MyCommand.Name, $param, $s, $e)

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
                    # Write a debug message with detailed information to developers
                    $reason = ("{0}: {1}" -f $_.CategoryInfo.Category, $_.CategoryInfo.Reason)
                    $message = "{2}: {0}`r`n`r`nLine:{1}`r`n`r`nScript stacktrace:`r`n{3}" -f $_.Exception.Message, $_.InvocationInfo.Line, $reason, $_.ScriptStackTrace
                    Write-Debug $message

                    # Pass on the error
                    $PSCmdlet.ThrowTerminatingError($_)
                    return
                }
                # Add response to result - if there are any response to add
                if ($response.count -gt 0) { 
                    $result.AddRange($response)
                }

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
