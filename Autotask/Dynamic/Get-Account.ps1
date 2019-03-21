#Requires -Version 4.0
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-Account
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

Additional operators for [String] parameters are:
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
 

Entities that have fields that refer to the base entity of this CmdLet:

Account
 AccountAlert
 AccountLocation
 AccountNote
 AccountPhysicalLocation
 AccountTeam
 AccountToDo
 BillingItem
 Contact
 Contract
 ContractServiceUnit
 ExpenseItem
 InstalledProduct
 Invoice
 NotificationHistory
 Opportunity
 Product
 ProductVendor
 Project
 PurchaseOrder
 Quote
 SalesOrder
 Service
 ServiceCall
 Subscription
 SurveyResults
 Ticket

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Account[]]. This function outputs the Autotask.Account that was returned by the API.
.EXAMPLE
Get-Account -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-Account -AccountName SomeName
Returns the object with AccountName 'SomeName', if any.
 .EXAMPLE
Get-Account -AccountName 'Some Name'
Returns the object with AccountName 'Some Name', if any.
 .EXAMPLE
Get-Account -AccountName 'Some Name' -NotEquals AccountName
Returns any objects with a AccountName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-Account -AccountName SomeName* -Like AccountName
Returns any object with a AccountName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-Account -AccountName SomeName* -NotLike AccountName
Returns any object with a AccountName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-Account -AccountType <PickList Label>
Returns any Accounts with property AccountType equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-Account -AccountType <PickList Label> -NotEquals AccountType 
Returns any Accounts with property AccountType NOT equal to the <PickList Label>.
 .EXAMPLE
Get-Account -AccountType <PickList Label1>, <PickList Label2>
Returns any Accounts with property AccountType equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-Account -AccountType <PickList Label1>, <PickList Label2> -NotEquals AccountType
Returns any Accounts with property AccountType NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-Account -Id 1234 -AccountName SomeName* -AccountType <PickList Label1>, <PickList Label2> -Like AccountName -NotEquals AccountType -GreaterThan Id
An example of a more complex query. This command returns any Accounts with Id GREATER THAN 1234, a AccountName that matches the simple pattern SomeName* AND that has a AccountType that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-Account
 .LINK
Set-Account

#>

  [CmdLetBinding(DefaultParameterSetName='Filter', ConfirmImpact='None')]
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
    [ValidateSet('OwnerResourceID', 'ParentAccountID', 'TaxRegionID', 'CountryID', 'BillToCountryID', 'QuoteTemplateID', 'InvoiceTemplateID', 'CurrencyID', 'BillToAccountPhysicalLocationID')]
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
    [ValidateSet('SalesOrder:AccountID', 'InstalledProduct:AccountID', 'InstalledProduct:VendorID', 'Project:AccountID', 'Invoice:AccountID', 'Service:VendorAccountID', 'Contact:AccountID', 'Account:ParentAccountID', 'AccountTeam:AccountID', 'Opportunity:AccountID', 'Product:DefaultVendorID', 'Contract:AccountID', 'ServiceCall:AccountID', 'Subscription:VendorID', 'BillingItem:AccountID', 'BillingItem:VendorID', 'ContractServiceUnit:VendorAccountID', 'AccountPhysicalLocation:AccountID', 'PurchaseOrder:VendorID', 'PurchaseOrder:PurchaseForAccountID', 'ProductVendor:VendorID', 'Ticket:AccountID', 'ExpenseItem:AccountID', 'AccountAlert:AccountID', 'AccountLocation:AccountID', 'AccountNote:AccountID', 'Quote:AccountID', 'AccountToDo:AccountID', 'SurveyResults:AccountID', 'NotificationHistory:AccountID')]
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

# A single user defined field can be used pr query
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Alias('UDF')]
    [ValidateNotNullOrEmpty()]
    [Autotask.UserDefinedField]
    $UserDefinedField,

# Client ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [long[]]
    $id,

# Client Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Alias('Name')]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1,100)]
    [string[]]
    $AccountName,

# Address 1
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,128)]
    [string[]]
    $Address1,

# Address 2
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,128)]
    [string[]]
    $Address2,

# City
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,30)]
    [string[]]
    $City,

# County
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,40)]
    [string[]]
    $State,

# Postal Code
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,10)]
    [string[]]
    $PostalCode,

# Country
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,100)]
    [string[]]
    $Country,

# Phone
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1,25)]
    [string[]]
    $Phone,

# Alternate Phone 1
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,25)]
    [string[]]
    $AlternatePhone1,

# Alternate Phone 2
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,25)]
    [string[]]
    $AlternatePhone2,

# Fax
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,25)]
    [string[]]
    $Fax,

# Web
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string[]]
    $WebAddress,

# Client Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int16[]]
    $AccountType,

# Key Account Icon
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $KeyAccountIcon,

# Client Owner
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int[]]
    $OwnerResourceID,

# Territory Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $TerritoryID,

# Market Segment
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $MarketSegmentID,

# Competitor
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $CompetitorID,

# Parent Client
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $ParentAccountID,

# Client Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string[]]
    $AccountNumber,

# Create Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime[]]
    $CreateDate,

# Last Activity Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime[]]
    $LastActivityDate,

# Account Active
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean[]]
    $Active,

# TaskFire Active
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean[]]
    $TaskFireActive,

# Client Portal Active
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean[]]
    $ClientPortalActive,

# Tax Region ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $TaxRegionID,

# Tax Exempt
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean[]]
    $TaxExempt,

# Tax ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string[]]
    $TaxID,

# Additional Address Information
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,100)]
    [string[]]
    $AdditionalAddressInformation,

# Country ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $CountryID,

# Bill To Address to Use
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $BillToAddressToUse,

# Bill To Attention
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string[]]
    $BillToAttention,

# Bill To Address Line 1
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,150)]
    [string[]]
    $BillToAddress1,

# Bill To Address Line 2
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,150)]
    [string[]]
    $BillToAddress2,

# Bill To City
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string[]]
    $BillToCity,

# Bill To County
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,128)]
    [string[]]
    $BillToState,

# Bill To Postal Code
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string[]]
    $BillToZipCode,

# Bill To Country ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $BillToCountryID,

# Bill To Additional Address Information
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,100)]
    [string[]]
    $BillToAdditionalAddressInformation,

# Transmission Method
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $InvoiceMethod,

# Invoice non contract items to Parent Client
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean[]]
    $InvoiceNonContractItemsToParentAccount,

# Quote Template ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $QuoteTemplateID,

# Quote Email Message ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $QuoteEmailMessageID,

# Invoice Template ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $InvoiceTemplateID,

# Invoice Email Message ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $InvoiceEmailMessageID,

# Currency ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $CurrencyID,

# Bill To Account Physical Location ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $BillToAccountPhysicalLocationID,

# Survey Account Rating
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double[]]
    $SurveyAccountRating,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountName', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'Country', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax', 'WebAddress', 'AccountType', 'KeyAccountIcon', 'OwnerResourceID', 'TerritoryID', 'MarketSegmentID', 'CompetitorID', 'ParentAccountID', 'AccountNumber', 'CreateDate', 'LastActivityDate', 'Active', 'TaskFireActive', 'ClientPortalActive', 'TaxRegionID', 'TaxExempt', 'TaxID', 'AdditionalAddressInformation', 'CountryID', 'BillToAddressToUse', 'BillToAttention', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToZipCode', 'BillToCountryID', 'BillToAdditionalAddressInformation', 'InvoiceMethod', 'InvoiceNonContractItemsToParentAccount', 'QuoteTemplateID', 'QuoteEmailMessageID', 'InvoiceTemplateID', 'InvoiceEmailMessageID', 'CurrencyID', 'BillToAccountPhysicalLocationID', 'SurveyAccountRating', 'UserDefinedField')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountName', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'Country', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax', 'WebAddress', 'AccountType', 'KeyAccountIcon', 'OwnerResourceID', 'TerritoryID', 'MarketSegmentID', 'CompetitorID', 'ParentAccountID', 'AccountNumber', 'CreateDate', 'LastActivityDate', 'Active', 'TaskFireActive', 'ClientPortalActive', 'TaxRegionID', 'TaxExempt', 'TaxID', 'AdditionalAddressInformation', 'CountryID', 'BillToAddressToUse', 'BillToAttention', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToZipCode', 'BillToCountryID', 'BillToAdditionalAddressInformation', 'InvoiceMethod', 'InvoiceNonContractItemsToParentAccount', 'QuoteTemplateID', 'QuoteEmailMessageID', 'InvoiceTemplateID', 'InvoiceEmailMessageID', 'CurrencyID', 'BillToAccountPhysicalLocationID', 'SurveyAccountRating', 'UserDefinedField')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountName', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'Country', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax', 'WebAddress', 'AccountType', 'KeyAccountIcon', 'OwnerResourceID', 'TerritoryID', 'MarketSegmentID', 'CompetitorID', 'ParentAccountID', 'AccountNumber', 'CreateDate', 'LastActivityDate', 'Active', 'TaskFireActive', 'ClientPortalActive', 'TaxRegionID', 'TaxExempt', 'TaxID', 'AdditionalAddressInformation', 'CountryID', 'BillToAddressToUse', 'BillToAttention', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToZipCode', 'BillToCountryID', 'BillToAdditionalAddressInformation', 'InvoiceMethod', 'InvoiceNonContractItemsToParentAccount', 'QuoteTemplateID', 'QuoteEmailMessageID', 'InvoiceTemplateID', 'InvoiceEmailMessageID', 'CurrencyID', 'BillToAccountPhysicalLocationID', 'SurveyAccountRating', 'UserDefinedField')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountName', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'Country', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax', 'WebAddress', 'AccountType', 'KeyAccountIcon', 'OwnerResourceID', 'TerritoryID', 'MarketSegmentID', 'CompetitorID', 'ParentAccountID', 'AccountNumber', 'CreateDate', 'LastActivityDate', 'TaxRegionID', 'TaxID', 'AdditionalAddressInformation', 'CountryID', 'BillToAddressToUse', 'BillToAttention', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToZipCode', 'BillToCountryID', 'BillToAdditionalAddressInformation', 'InvoiceMethod', 'QuoteTemplateID', 'QuoteEmailMessageID', 'InvoiceTemplateID', 'InvoiceEmailMessageID', 'CurrencyID', 'BillToAccountPhysicalLocationID', 'SurveyAccountRating', 'UserDefinedField')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountName', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'Country', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax', 'WebAddress', 'AccountType', 'KeyAccountIcon', 'OwnerResourceID', 'TerritoryID', 'MarketSegmentID', 'CompetitorID', 'ParentAccountID', 'AccountNumber', 'CreateDate', 'LastActivityDate', 'TaxRegionID', 'TaxID', 'AdditionalAddressInformation', 'CountryID', 'BillToAddressToUse', 'BillToAttention', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToZipCode', 'BillToCountryID', 'BillToAdditionalAddressInformation', 'InvoiceMethod', 'QuoteTemplateID', 'QuoteEmailMessageID', 'InvoiceTemplateID', 'InvoiceEmailMessageID', 'CurrencyID', 'BillToAccountPhysicalLocationID', 'SurveyAccountRating', 'UserDefinedField')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountName', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'Country', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax', 'WebAddress', 'AccountType', 'KeyAccountIcon', 'OwnerResourceID', 'TerritoryID', 'MarketSegmentID', 'CompetitorID', 'ParentAccountID', 'AccountNumber', 'CreateDate', 'LastActivityDate', 'TaxRegionID', 'TaxID', 'AdditionalAddressInformation', 'CountryID', 'BillToAddressToUse', 'BillToAttention', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToZipCode', 'BillToCountryID', 'BillToAdditionalAddressInformation', 'InvoiceMethod', 'QuoteTemplateID', 'QuoteEmailMessageID', 'InvoiceTemplateID', 'InvoiceEmailMessageID', 'CurrencyID', 'BillToAccountPhysicalLocationID', 'SurveyAccountRating', 'UserDefinedField')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountName', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'Country', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax', 'WebAddress', 'AccountType', 'KeyAccountIcon', 'OwnerResourceID', 'TerritoryID', 'MarketSegmentID', 'CompetitorID', 'ParentAccountID', 'AccountNumber', 'CreateDate', 'LastActivityDate', 'TaxRegionID', 'TaxID', 'AdditionalAddressInformation', 'CountryID', 'BillToAddressToUse', 'BillToAttention', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToZipCode', 'BillToCountryID', 'BillToAdditionalAddressInformation', 'InvoiceMethod', 'QuoteTemplateID', 'QuoteEmailMessageID', 'InvoiceTemplateID', 'InvoiceEmailMessageID', 'CurrencyID', 'BillToAccountPhysicalLocationID', 'SurveyAccountRating', 'UserDefinedField')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('AccountName', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'Country', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax', 'WebAddress', 'AccountNumber', 'TaxID', 'AdditionalAddressInformation', 'BillToAttention', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToZipCode', 'BillToAdditionalAddressInformation', 'UserDefinedField')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('AccountName', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'Country', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax', 'WebAddress', 'AccountNumber', 'TaxID', 'AdditionalAddressInformation', 'BillToAttention', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToZipCode', 'BillToAdditionalAddressInformation', 'UserDefinedField')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('AccountName', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'Country', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax', 'WebAddress', 'AccountNumber', 'TaxID', 'AdditionalAddressInformation', 'BillToAttention', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToZipCode', 'BillToAdditionalAddressInformation', 'UserDefinedField')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('AccountName', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'Country', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax', 'WebAddress', 'AccountNumber', 'TaxID', 'AdditionalAddressInformation', 'BillToAttention', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToZipCode', 'BillToAdditionalAddressInformation', 'UserDefinedField')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('AccountName', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'Country', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax', 'WebAddress', 'AccountNumber', 'TaxID', 'AdditionalAddressInformation', 'BillToAttention', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToZipCode', 'BillToAdditionalAddressInformation', 'UserDefinedField')]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'LastActivityDate', 'UserDefinedField')]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'Account'

    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
        
    # Set up TimeZone offset handling
    If (-not($script:ESTzone)) {
      $script:ESTzone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Eastern Standard Time")
    }
    
    If (-not($script:ESToffset)) {
      $Now = Get-Date
      $ESTtime = [System.TimeZoneInfo]::ConvertTimeFromUtc($Now.ToUniversalTime(), $ESTzone)

      $script:ESToffset = (New-TimeSpan -Start $ESTtime -End $Now).TotalHours
    }
  }


  Process
  {
    If ($PSCmdlet.ParameterSetName -eq 'Get_all')
    { $Filter = @('id', '-ge', 0)}
    ElseIf (-not ($Filter)) {
      Write-Verbose ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)
      
      $Fields = Get-FieldInfo -Entity $EntityName
 
      Foreach ($Parameter in $PSBoundParameters.GetEnumerator()) {
        $Field = $Fields | Where-Object {$_.Name -eq $Parameter.Key}
        If ($Field -or $Parameter.Key -eq 'UserDefinedField') { 
          If ($Parameter.Value.Count -gt 1) {
            $Filter += '-begin'
          }
          Foreach ($ParameterValue in $Parameter.Value) {   
            $Operator = '-or'
            $ParameterName = $Parameter.Key
            If ($Field.IsPickList) {
              If ($Field.PickListParentValueField) {
                $ParentField = $Fields.Where{$_.Name -eq $Field.PickListParentValueField}
                $ParentLabel = $PSBoundParameters.$($ParentField.Name)
                $ParentValue = $ParentField.PickListValues | Where-Object {$_.Label -eq $ParentLabel}
                $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $ParameterValue -and $_.ParentValue -eq $ParentValue.Value}                
              }
              Else { 
                $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $ParameterValue}
              }
              $Value = $PickListValue.Value
            }
            ElseIf ($ParameterName -eq 'UserDefinedField') {
              $Filter += '-udf'              
              $ParameterName = $ParameterValue.Name
              $Value = $ParameterValue.Value
            }
            ElseIf ($ParameterValue.GetType().Name -eq 'DateTime')  {
              # XML supports sortable datetime format. This way dates should always be read correct by the API.
 
              If ($ParameterValue.Hour -eq 0 -and $ParameterValue.Minute -eq 0 -and $ParameterValue.Second -eq 0 -and $ParameterValue.Millisecond -eq 0) {
                
                # For dates, use Timezone EST
                $OffsetSpan = $ESTzone.BaseUtcOffset
              }
              Else { 
                # Else use local time
                $OffsetSpan = (Get-TimeZone).BaseUtcOffset
              }
              
              # Create the correct text string                           
              $Offset = '{0:00}:{1:00}' -F $OffsetSpan.Hours, $OffsetSpan.Minutes
              If ($OffsetSpan.Hours -ge 0) {
                $Offset = '+{0}' -F $Offset
              }
              $Value = '{0}{1}' -F $(Get-Date $ParameterValue -Format s), $Offset
            }            
            Else {
              $Value = $ParameterValue
            }
            $Filter += $ParameterName
            If ($Parameter.Key -in $NotEquals) { 
              $Filter += '-ne'
              $Operator = '-and'
            }
            ElseIf ($Parameter.Key -in $GreaterThan)
            { $Filter += '-gt'}
            ElseIf ($Parameter.Key -in $GreaterThanOrEquals)
            { $Filter += '-ge'}
            ElseIf ($Parameter.Key -in $LessThan)
            { $Filter += '-lt'}
            ElseIf ($Parameter.Key -in $LessThanOrEquals)
            { $Filter += '-le'}
            ElseIf ($Parameter.Key -in $Like) { 
              $Filter += '-like'
              $Value = $Value -replace '\*', '%'
            }
            ElseIf ($Parameter.Key -in $NotLike) { 
              $Filter += '-notlike'
              $Value = $Value -replace '\*', '%'
            }
            ElseIf ($Parameter.Key -in $BeginsWith)
            { $Filter += '-beginswith'}
            ElseIf ($Parameter.Key -in $EndsWith)
            { $Filter += '-endswith'}
            ElseIf ($Parameter.Key -in $Contains)
            { $Filter += '-contains'}
            ElseIf ($Parameter.Key -in $IsThisDay)
            { $Filter += '-isthisday'}
            ElseIf ($Parameter.Key -in $IsNull -and $Parameter.Key -eq 'UserDefinedField')
            {
              $Filter += '-IsNull'
              $IsNull = $IsNull.Where({$_ -ne 'UserDefinedField'})
            }
            ElseIf ($Parameter.Key -in $IsNotNull -and $Parameter.Key -eq 'UserDefinedField')
            {
              $Filter += '-IsNotNull'
              $IsNotNull = $IsNotNull.Where({$_ -ne 'UserDefinedField'})
            }
            Else
            { $Filter += '-eq'}
            
            # Add Value to expression, unless this is a UserDefinedfield AND UserDefinedField has been
            # specified for -IsNull or -IsNotNull
            If ($Filter[-1] -notin @('-IsNull','-IsNotNull'))
            {$Filter += $Value}

            If ($Parameter.Value.Count -gt 1 -and $ParameterValue -ne $Parameter.Value[-1]) {
              $Filter += $Operator
            }
            ElseIf ($Parameter.Value.Count -gt 1) {
              $Filter += '-end'
            }
            
          }
            
        }
      }
      # IsNull and IsNotNull are special. They are the only operators that does not require a value to work
      If ($IsNull.Count -gt 0) {
        If ($Filter.Count -gt 0) {
          $Filter += '-and'
        }
        Foreach ($PropertyName in $IsNull) {
          $Filter += $PropertyName
          $Filter += '-isnull'
        }
      }
      If ($IsNotNull.Count -gt 0) {
        If ($Filter.Count -gt 0) {
          $Filter += '-and'
        }
        Foreach ($PropertyName in $IsNotNull) {
          $Filter += $PropertyName
          $Filter += '-isnotnull'
        }
      }  
    }
    Else {
      Write-Verbose ('{0}: Passing -Filter raw to Get function' -F $MyInvocation.MyCommand.Name)
    } 

    $Result = Get-AtwsData -Entity $EntityName -Filter $Filter

    Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $Result.Count)
    
    # Datetimeparameters
    $DateTimeParams = $Fields.Where({$_.Type -eq 'datetime'}).Name
    
    # Expand UDFs by default
    Foreach ($Item in $Result)
    {
      # Any userdefined fields?
      If ($Item.UserDefinedFields.Count -gt 0)
      { 
        # Expand User defined fields for easy filtering of collections and readability
        Foreach ($UDF in $Item.UserDefinedFields)
        {
          # Make names you HAVE TO escape...
          $UDFName = '#{0}' -F $UDF.Name
          Add-Member -InputObject $Item -MemberType NoteProperty -Name $UDFName -Value $UDF.Value
        }  
      }
      
      # Adjust TimeZone on all DateTime properties
      Foreach ($DateTimeParam in $DateTimeParams) {
      
        # Get the datetime value
        $ParameterValue = $Item.$DateTimeParam
                
        # Skip if parameter is empty
        If (-not ($ParameterValue)) {
          Continue
        }
        
        # If all TIME parameters are zero, then this is a DATE and should not be touched
        If ($ParameterValue.Hour -ne 0 -or 
            $ParameterValue.Minute -ne 0 -or
            $ParameterValue.Second -ne 0 -or
            $ParameterValue.Millisecond -ne 0) {

            # This is DATETIME 
            # We need to adjust the timezone difference 

            # Yes, you really have to ADD the difference
            $ParameterValue = $ParameterValue.AddHours($script:ESToffset)
            
            # Store the value back to the object (not the API!)
            $Item.$DateTimeParam = $ParameterValue
        }
      }
    }
    
    # Should we return an indirect object?
    if ( ($Result) -and ($GetReferenceEntityById))
    {
      Write-Verbose ('{0}: User has asked for external reference objects by {1}' -F $MyInvocation.MyCommand.Name, $GetReferenceEntityById)
      
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
      Write-Verbose ('{0}: User has asked for {1} that are referencing this result' -F $MyInvocation.MyCommand.Name, $GetExternalEntityByThisEntityId)
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

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    If ($Result)
    {
      Return $Result
    }
  }


}
