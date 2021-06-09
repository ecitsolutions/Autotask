---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# New-AtwsContractBillingRule

## SYNOPSIS
This function creates a new ContractBillingRule through the Autotask Web Services API.
All required properties are marked as required parameters to assist you on the command line.

## SYNTAX

### By_parameters (Default)
```
New-AtwsContractBillingRule -Active <Boolean> -ContractID <Int32> -CreateChargesAsBillable <Boolean>
 [-DailyProratedCost <Decimal>] [-DailyProratedPrice <Decimal>] -DetermineUnits <String>
 -EnableDailyProrating <Boolean> [-EndDate <DateTime>] [-ExecutionMethod <String>]
 -IncludeItemsInChargeDescription <Boolean> [-InvoiceDescription <String>] [-MaximumUnits <Int32>]
 [-MinimumUnits <Int32>] -ProductID <Int32> -StartDate <DateTime> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Input_Object
```
New-AtwsContractBillingRule [-InputObject <ContractBillingRule[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The function supports all properties of an \[Autotask.ContractBillingRule\] that can be updated through the Web Services API.
The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values.
Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter.
To get the ContractBillingRule with Id number 0 you could write 'New-AtwsContractBillingRule -Id 0' or you could write 'New-AtwsContractBillingRule -Filter {Id -eq 0}.

'New-AtwsContractBillingRule -Id 0,4' could be written as 'New-AtwsContractBillingRule -Filter {id -eq 0 -or id -eq 4}'.
For simple queries you can see that using parameters is much easier than the -Filter option.
But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday).
As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new ContractBillingRule you need the following required fields:
 -ContractID
 -ProductID
 -Active
 -StartDate
 -DetermineUnits
 -CreateChargesAsBillable
 -IncludeItemsInChargeDescription
 -EnableDailyProrating

Entities that have fields that refer to the base entity of this CmdLet:

## EXAMPLES

### EXAMPLE 1
```
$result = New-AtwsContractBillingRule -ContractID [Value] -ProductID [Value] -Active [Value] -StartDate [Value] -DetermineUnits [Value] -CreateChargesAsBillable [Value] -IncludeItemsInChargeDescription [Value] -EnableDailyProrating [Value]
Creates a new [Autotask.ContractBillingRule] through the Web Services API and returns the new object.
```

### EXAMPLE 2
```
$result = Get-AtwsContractBillingRule -Id 124 | New-AtwsContractBillingRule 
Copies [Autotask.ContractBillingRule] by Id 124 to a new object through the Web Services API and returns the new object.
```

### EXAMPLE 3
```
Copies [Autotask.ContractBillingRule] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsContractBillingRule to modify the object.
```

### EXAMPLE 4
```
-Passthru
Copies [Autotask.ContractBillingRule] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsContractBillingRule to modify the object and returns the new object.
```

## PARAMETERS

### -InputObject
An array of objects to create

```yaml
Type: ContractBillingRule[]
Parameter Sets: Input_Object
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Active
Active

```yaml
Type: Boolean
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContractID
Contract ID

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreateChargesAsBillable
Create Charges As Billable

```yaml
Type: Boolean
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DailyProratedCost
Daily Prorated Cost

```yaml
Type: Decimal
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DailyProratedPrice
Daily Prorated Price

```yaml
Type: Decimal
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DetermineUnits
Determine Units

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

### -EnableDailyProrating
Enable Daily Prorating

```yaml
Type: Boolean
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate
End Date

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

### -ExecutionMethod
Execution Method

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

### -IncludeItemsInChargeDescription
Include Items In Charge Description

```yaml
Type: Boolean
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -InvoiceDescription
Invoice Description

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

### -MaximumUnits
Maximum Units

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

### -MinimumUnits
Minimum Units

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

### -ProductID
Product ID

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartDate
Start Date

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

### [Autotask.ContractBillingRule]. This function outputs the Autotask.ContractBillingRule that was created by the API.
## NOTES
Related commands:
Remove-AtwsContractBillingRule
 Get-AtwsContractBillingRule
 Set-AtwsContractBillingRule

## RELATED LINKS
