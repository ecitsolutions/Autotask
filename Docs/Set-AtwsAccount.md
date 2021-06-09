---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# Set-AtwsAccount

## SYNOPSIS
This function sets parameters on the Account specified by the -InputObject parameter or pipeline through the use of the Autotask Web Services API.
Any property of the Account that is not marked as READ ONLY by Autotask can be speficied with a parameter.
You can specify multiple paramters.

## SYNTAX

### InputObject (Default)
```
Set-AtwsAccount [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Input_Object
```
Set-AtwsAccount [-InputObject <Account[]>] [-PassThru] [-UserDefinedFields <UserDefinedField[]>]
 [-AccountName <String>] [-AccountNumber <String>] [-AccountType <String>] [-Active <Boolean>]
 [-AdditionalAddressInformation <String>] [-Address1 <String>] [-Address2 <String>] [-AlternatePhone1 <String>]
 [-AlternatePhone2 <String>] [-AssetValue <Double>] [-BillToAccountPhysicalLocationID <Int32>]
 [-BillToAttention <String>] [-City <String>] [-CompetitorID <String>] [-Country <String>] [-CountryID <Int32>]
 [-CurrencyID <Int32>] [-EnabledForComanaged <Boolean>] [-Fax <String>] [-InvoiceEmailMessageID <Int32>]
 [-InvoiceMethod <String>] [-InvoiceNonContractItemsToParentAccount <Boolean>] [-InvoiceTemplateID <Int32>]
 [-KeyAccountIcon <String>] [-MarketSegmentID <String>] [-OwnerResourceID <Int32>] [-ParentAccountID <Int32>]
 [-Phone <String>] [-PostalCode <String>] [-PurchaseOrderTemplateID <String>] [-QuoteEmailMessageID <Int32>]
 [-QuoteTemplateID <Int32>] [-SICCode <String>] [-State <String>] [-StockMarket <String>]
 [-StockSymbol <String>] [-TaxExempt <Boolean>] [-TaxID <String>] [-TaxRegionID <Int32>]
 [-TerritoryID <String>] [-WebAddress <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### By_Id
```
Set-AtwsAccount [-Id <Int64[]>] [-AccountName <String>] [-AccountNumber <String>] [-AccountType <String>]
 [-Active <Boolean>] [-AdditionalAddressInformation <String>] [-Address1 <String>] [-Address2 <String>]
 [-AlternatePhone1 <String>] [-AlternatePhone2 <String>] [-AssetValue <Double>]
 [-BillToAccountPhysicalLocationID <Int32>] [-BillToAttention <String>] [-City <String>]
 [-CompetitorID <String>] [-Country <String>] [-CountryID <Int32>] [-CurrencyID <Int32>]
 [-EnabledForComanaged <Boolean>] [-Fax <String>] [-InvoiceEmailMessageID <Int32>] [-InvoiceMethod <String>]
 [-InvoiceNonContractItemsToParentAccount <Boolean>] [-InvoiceTemplateID <Int32>] [-KeyAccountIcon <String>]
 [-MarketSegmentID <String>] [-OwnerResourceID <Int32>] [-ParentAccountID <Int32>] [-Phone <String>]
 [-PostalCode <String>] [-PurchaseOrderTemplateID <String>] [-QuoteEmailMessageID <Int32>]
 [-QuoteTemplateID <Int32>] [-SICCode <String>] [-State <String>] [-StockMarket <String>]
 [-StockSymbol <String>] [-TaxExempt <Boolean>] [-TaxID <String>] [-TaxRegionID <Int32>]
 [-TerritoryID <String>] [-WebAddress <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### By_parameters
```
Set-AtwsAccount [-PassThru] [-UserDefinedFields <UserDefinedField[]>] -AccountName <String>
 [-AccountNumber <String>] -AccountType <String> [-Active <Boolean>] [-AdditionalAddressInformation <String>]
 [-Address1 <String>] [-Address2 <String>] [-AlternatePhone1 <String>] [-AlternatePhone2 <String>]
 [-AssetValue <Double>] [-BillToAccountPhysicalLocationID <Int32>] [-BillToAttention <String>] [-City <String>]
 [-CompetitorID <String>] [-Country <String>] [-CountryID <Int32>] [-CurrencyID <Int32>]
 [-EnabledForComanaged <Boolean>] [-Fax <String>] [-InvoiceEmailMessageID <Int32>] [-InvoiceMethod <String>]
 [-InvoiceNonContractItemsToParentAccount <Boolean>] [-InvoiceTemplateID <Int32>] [-KeyAccountIcon <String>]
 [-MarketSegmentID <String>] -OwnerResourceID <Int32> [-ParentAccountID <Int32>] -Phone <String>
 [-PostalCode <String>] [-PurchaseOrderTemplateID <String>] [-QuoteEmailMessageID <Int32>]
 [-QuoteTemplateID <Int32>] [-SICCode <String>] [-State <String>] [-StockMarket <String>]
 [-StockSymbol <String>] [-TaxExempt <Boolean>] [-TaxID <String>] [-TaxRegionID <Int32>]
 [-TerritoryID <String>] [-WebAddress <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function one or more objects of type \[Autotask.Account\] as input.
You can pipe the objects to the function or pass them using the -InputObject parameter.
You specify the property you want to set and the value you want to set it to using parameters.
The function modifies all objects and updates the online data through the Autotask Web Services API.
The function supports all properties of an \[Autotask.Account\] that can be updated through the Web Services API.
The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values.

Entities that have fields that refer to the base entity of this CmdLet:

## EXAMPLES

### EXAMPLE 1
```
Set-AtwsAccount -InputObject $Account [-ParameterName] [Parameter value]
Passes one or more [Autotask.Account] object(s) as a variable to the function and sets the property by name 'ParameterName' on ALL the objects before they are passed to the Autotask Web Service API and updated.
```

### EXAMPLE 2
```
Same as the first example, but now the objects are passed to the funtion through the pipeline, not passed as a parameter. The end result is identical.
```

### EXAMPLE 3
```
Gets the instance with Id 0 directly from the Web Services API, modifies a parameter and updates Autotask. This approach works with all valid parameters for the Get function.
```

### EXAMPLE 4
```
Gets multiple instances by Id, modifies them all and updates Autotask.
```

### EXAMPLE 5
```
-PassThru
Gets multiple instances by Id, modifies them all, updates Autotask and returns the updated objects.
```

## PARAMETERS

### -InputObject
An object that will be modified by any parameters and updated in Autotask

```yaml
Type: Account[]
Parameter Sets: Input_Object
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Id
The object.ids of objects that should be modified by any parameters and updated in Autotask

```yaml
Type: Int64[]
Parameter Sets: By_Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Return any updated objects through the pipeline

```yaml
Type: SwitchParameter
Parameter Sets: Input_Object, By_parameters
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserDefinedFields
User defined fields already setup i Autotask

```yaml
Type: UserDefinedField[]
Parameter Sets: Input_Object, By_parameters
Aliases: UDF

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccountName
Client Name

```yaml
Type: String
Parameter Sets: Input_Object, By_Id
Aliases: Name

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: By_parameters
Aliases: Name

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccountNumber
Client Number

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccountType
Client Type

```yaml
Type: String
Parameter Sets: Input_Object, By_Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Active
Account Active

```yaml
Type: Boolean
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdditionalAddressInformation
Additional Address Information

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Address1
Address 1

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Address2
Address 2

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AlternatePhone1
Alternate Phone 1

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AlternatePhone2
Alternate Phone 2

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssetValue
Asset Value

```yaml
Type: Double
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BillToAccountPhysicalLocationID
Bill To Account Physical Location ID

```yaml
Type: Int32
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BillToAttention
Bill To Attention

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -City
City

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CompetitorID
Competitor

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Country
Country

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CountryID
Country ID

```yaml
Type: Int32
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CurrencyID
Currency ID

```yaml
Type: Int32
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnabledForComanaged
Enabled For Comanaged

```yaml
Type: Boolean
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fax
Fax

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InvoiceEmailMessageID
Invoice Email Message ID

```yaml
Type: Int32
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InvoiceMethod
Transmission Method

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InvoiceNonContractItemsToParentAccount
Invoice non contract items to Parent Client

```yaml
Type: Boolean
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InvoiceTemplateID
Invoice Template ID

```yaml
Type: Int32
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KeyAccountIcon
Key Account Icon

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MarketSegmentID
Market Segment

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OwnerResourceID
Client Owner

```yaml
Type: Int32
Parameter Sets: Input_Object, By_Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentAccountID
Parent Client

```yaml
Type: Int32
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Phone
Phone

```yaml
Type: String
Parameter Sets: Input_Object, By_Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PostalCode
Postal Code

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PurchaseOrderTemplateID
Purchase Order Template ID

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -QuoteEmailMessageID
Quote Email Message ID

```yaml
Type: Int32
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -QuoteTemplateID
Quote Template ID

```yaml
Type: Int32
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SICCode
SIC Code

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -State
County

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StockMarket
Stock Market

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StockSymbol
Stock Symbol

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TaxExempt
Tax Exempt

```yaml
Type: Boolean
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TaxID
Tax ID

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TaxRegionID
Tax Region ID

```yaml
Type: Int32
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TerritoryID
Territory Name

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebAddress
Web

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [Autotask.Account[]]. This function takes one or more objects as input. Pipeline is supported.
## OUTPUTS

### Nothing or [Autotask.Account]. This function optionally returns the updated objects if you use the -PassThru parameter.
## NOTES
Related commands:
New-AtwsAccount
 Get-AtwsAccount

## RELATED LINKS
