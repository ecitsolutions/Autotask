---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# New-AtwsContractCost

## SYNOPSIS
This function creates a new ContractCost through the Autotask Web Services API.
All required properties are marked as required parameters to assist you on the command line.

## SYNTAX

### By_parameters (Default)
```
New-AtwsContractCost [-AllocationCodeID <Int64>] [-BillableAmount <Double>] [-BillableToAccount <Boolean>]
 [-Billed <Boolean>] [-BusinessDivisionSubdivisionID <Int32>] -ContractID <Int64>
 [-ContractServiceBundleID <Int64>] [-ContractServiceID <Int64>] -CostType <String> [-CreateDate <DateTime>]
 [-CreatorResourceID <Int64>] -DatePurchased <DateTime> [-Description <String>] [-ExtendedCost <Double>]
 [-InternalCurrencyBillableAmount <Double>] [-InternalCurrencyUnitPrice <Double>]
 [-InternalPurchaseOrderNumber <String>] -Name <String> [-Notes <String>] [-ProductID <Int64>]
 [-PurchaseOrderNumber <String>] [-Status <String>] [-StatusLastModifiedBy <Int64>]
 [-StatusLastModifiedDate <DateTime>] [-UnitCost <Double>] [-UnitPrice <Double>] -UnitQuantity <Double>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Input_Object
```
New-AtwsContractCost [-InputObject <ContractCost[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The function supports all properties of an \[Autotask.ContractCost\] that can be updated through the Web Services API.
The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values.
Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter.
To get the ContractCost with Id number 0 you could write 'New-AtwsContractCost -Id 0' or you could write 'New-AtwsContractCost -Filter {Id -eq 0}.

'New-AtwsContractCost -Id 0,4' could be written as 'New-AtwsContractCost -Filter {id -eq 0 -or id -eq 4}'.
For simple queries you can see that using parameters is much easier than the -Filter option.
But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday).
As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new ContractCost you need the following required fields:
 -ContractID
 -Name
 -DatePurchased
 -CostType
 -UnitQuantity

Entities that have fields that refer to the base entity of this CmdLet:

## EXAMPLES

### EXAMPLE 1
```
$result = New-AtwsContractCost -ContractID [Value] -Name [Value] -DatePurchased [Value] -CostType [Value] -UnitQuantity [Value]
Creates a new [Autotask.ContractCost] through the Web Services API and returns the new object.
```

### EXAMPLE 2
```
$result = Get-AtwsContractCost -Id 124 | New-AtwsContractCost 
Copies [Autotask.ContractCost] by Id 124 to a new object through the Web Services API and returns the new object.
```

### EXAMPLE 3
```
Copies [Autotask.ContractCost] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsContractCost to modify the object.
```

### EXAMPLE 4
```
-Passthru
Copies [Autotask.ContractCost] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsContractCost to modify the object and returns the new object.
```

## PARAMETERS

### -InputObject
An array of objects to create

```yaml
Type: ContractCost[]
Parameter Sets: Input_Object
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -AllocationCodeID
Allocation Code

```yaml
Type: Int64
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -BillableAmount
Billable Amount

```yaml
Type: Double
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -BillableToAccount
Billable To Client

```yaml
Type: Boolean
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Billed
Billed

```yaml
Type: Boolean
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -BusinessDivisionSubdivisionID
Business Division Subdivision ID

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContractID
Contract

```yaml
Type: Int64
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContractServiceBundleID
Contract Service Bundle ID

```yaml
Type: Int64
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContractServiceID
Contract Service ID

```yaml
Type: Int64
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -CostType
Cost Type

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

### -CreateDate
Create Date

```yaml
Type: DateTime
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreatorResourceID
Created By

```yaml
Type: Int64
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatePurchased
Date Purchased

```yaml
Type: DateTime
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Description

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExtendedCost
Extended Cost

```yaml
Type: Double
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -InternalCurrencyBillableAmount
Internal Currency Billable Amount

```yaml
Type: Double
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -InternalCurrencyUnitPrice
Internal Currency Unit Price

```yaml
Type: Double
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -InternalPurchaseOrderNumber
Internal Purchase Order Number

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Name

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

### -Notes
Notes

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProductID
Product

```yaml
Type: Int64
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PurchaseOrderNumber
Purchase Order Number

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Status
Status

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StatusLastModifiedBy
Last Modified By

```yaml
Type: Int64
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -StatusLastModifiedDate
Last Modified Date

```yaml
Type: DateTime
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UnitCost
Unit Cost

```yaml
Type: Double
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -UnitPrice
Unit Price

```yaml
Type: Double
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -UnitQuantity
Unit Quantity

```yaml
Type: Double
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: 0
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

### Nothing. This function only takes parameters.
## OUTPUTS

### [Autotask.ContractCost]. This function outputs the Autotask.ContractCost that was created by the API.
## NOTES
Related commands:
Remove-AtwsContractCost
 Get-AtwsContractCost
 Set-AtwsContractCost

## RELATED LINKS
