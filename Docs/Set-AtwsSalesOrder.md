---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# Set-AtwsSalesOrder

## SYNOPSIS
This function sets parameters on the SalesOrder specified by the -InputObject parameter or pipeline through the use of the Autotask Web Services API.
Any property of the SalesOrder that is not marked as READ ONLY by Autotask can be speficied with a parameter.
You can specify multiple paramters.

## SYNTAX

### InputObject (Default)
```
Set-AtwsSalesOrder [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Input_Object
```
Set-AtwsSalesOrder [-InputObject <SalesOrder[]>] [-PassThru] [-UserDefinedFields <UserDefinedField[]>]
 [-AdditionalBillToAddressInformation <String>] [-AdditionalShipToAddressInformation <String>]
 [-BillToAddress1 <String>] [-BillToAddress2 <String>] [-BillToCity <String>] [-BillToCountry <String>]
 [-BillToCountryID <Int32>] [-BillToPostalCode <String>] [-BillToState <String>]
 [-BusinessDivisionSubdivisionID <Int32>] [-Contact <Int32>] [-OwnerResourceID <Int32>]
 [-PromisedDueDate <DateTime>] [-SalesOrderDate <DateTime>] [-ShipToAddress1 <String>]
 [-ShipToAddress2 <String>] [-ShipToCity <String>] [-ShipToCountry <String>] [-ShipToCountryID <Int32>]
 [-ShipToPostalCode <String>] [-ShipToState <String>] [-Status <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### By_Id
```
Set-AtwsSalesOrder [-Id <Int32[]>] [-AdditionalBillToAddressInformation <String>]
 [-AdditionalShipToAddressInformation <String>] [-BillToAddress1 <String>] [-BillToAddress2 <String>]
 [-BillToCity <String>] [-BillToCountry <String>] [-BillToCountryID <Int32>] [-BillToPostalCode <String>]
 [-BillToState <String>] [-BusinessDivisionSubdivisionID <Int32>] [-Contact <Int32>] [-OwnerResourceID <Int32>]
 [-PromisedDueDate <DateTime>] [-SalesOrderDate <DateTime>] [-ShipToAddress1 <String>]
 [-ShipToAddress2 <String>] [-ShipToCity <String>] [-ShipToCountry <String>] [-ShipToCountryID <Int32>]
 [-ShipToPostalCode <String>] [-ShipToState <String>] [-Status <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### By_parameters
```
Set-AtwsSalesOrder [-PassThru] [-UserDefinedFields <UserDefinedField[]>]
 [-AdditionalBillToAddressInformation <String>] [-AdditionalShipToAddressInformation <String>]
 [-BillToAddress1 <String>] [-BillToAddress2 <String>] [-BillToCity <String>] [-BillToCountry <String>]
 [-BillToCountryID <Int32>] [-BillToPostalCode <String>] [-BillToState <String>]
 [-BusinessDivisionSubdivisionID <Int32>] -Contact <Int32> -OwnerResourceID <Int32>
 [-PromisedDueDate <DateTime>] -SalesOrderDate <DateTime> [-ShipToAddress1 <String>] [-ShipToAddress2 <String>]
 [-ShipToCity <String>] [-ShipToCountry <String>] [-ShipToCountryID <Int32>] [-ShipToPostalCode <String>]
 [-ShipToState <String>] -Status <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function one or more objects of type \[Autotask.SalesOrder\] as input.
You can pipe the objects to the function or pass them using the -InputObject parameter.
You specify the property you want to set and the value you want to set it to using parameters.
The function modifies all objects and updates the online data through the Autotask Web Services API.
The function supports all properties of an \[Autotask.SalesOrder\] that can be updated through the Web Services API.
The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values.

Entities that have fields that refer to the base entity of this CmdLet:

## EXAMPLES

### EXAMPLE 1
```
Set-AtwsSalesOrder -InputObject $SalesOrder [-ParameterName] [Parameter value]
Passes one or more [Autotask.SalesOrder] object(s) as a variable to the function and sets the property by name 'ParameterName' on ALL the objects before they are passed to the Autotask Web Service API and updated.
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
Type: SalesOrder[]
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
Type: Int32[]
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

### -AdditionalBillToAddressInformation
Additional Bill To Address Information

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

### -AdditionalShipToAddressInformation
Additional Ship To Address Information

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

### -BillToAddress1
Bill to Address1

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

### -BillToAddress2
Bill to Address2

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

### -BillToCity
Bill to City

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

### -BillToCountry
Bill to Country

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

### -BillToCountryID
Bill To Country ID

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

### -BillToPostalCode
Bill to Postal Code

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

### -BillToState
Bill to County

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

### -BusinessDivisionSubdivisionID
Business Division Subdivision ID

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

### -Contact
Contact ID

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

### -OwnerResourceID
Owner

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

### -PromisedDueDate
Promised Due Date

```yaml
Type: DateTime
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SalesOrderDate
Sales Order Date

```yaml
Type: DateTime
Parameter Sets: Input_Object, By_Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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

### -ShipToAddress1
Ship to Address1

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

### -ShipToAddress2
Ship to Address2

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

### -ShipToCity
Ship to City

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

### -ShipToCountry
Ship to Country

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

### -ShipToCountryID
Ship To Country ID

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

### -ShipToPostalCode
Ship to Postal Code

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

### -ShipToState
Ship to County

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

### -Status
Status

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

### [Autotask.SalesOrder[]]. This function takes one or more objects as input. Pipeline is supported.
## OUTPUTS

### Nothing or [Autotask.SalesOrder]. This function optionally returns the updated objects if you use the -PassThru parameter.
## NOTES
Related commands:
Get-AtwsSalesOrder

## RELATED LINKS
