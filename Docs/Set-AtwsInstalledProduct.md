---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# Set-AtwsInstalledProduct

## SYNOPSIS
This function sets parameters on the InstalledProduct specified by the -InputObject parameter or pipeline through the use of the Autotask Web Services API.
Any property of the InstalledProduct that is not marked as READ ONLY by Autotask can be speficied with a parameter.
You can specify multiple paramters.

## SYNTAX

### InputObject (Default)
```
Set-AtwsInstalledProduct [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Input_Object
```
Set-AtwsInstalledProduct [-InputObject <InstalledProduct[]>] [-PassThru]
 [-UserDefinedFields <UserDefinedField[]>] [-AccountPhysicalLocationID <Int32>] [-Active <Boolean>]
 [-ContactID <Int32>] [-ContractID <Int32>] [-ContractServiceBundleID <Int32>] [-ContractServiceID <Int32>]
 [-DailyCost <Double>] [-HourlyCost <Double>] [-InstallDate <DateTime>] [-InstalledProductCategoryID <Int32>]
 [-Location <String>] [-MonthlyCost <Double>] [-Notes <String>] [-NumberOfUsers <Double>]
 [-ParentInstalledProductID <Int32>] [-PerUseCost <Double>] [-ProductID <Int32>] [-ReferenceNumber <String>]
 [-ReferenceTitle <String>] [-SerialNumber <String>] [-ServiceBundleID <Int32>] [-ServiceID <Int32>]
 [-ServiceLevelAgreementID <String>] [-SetupFee <Double>] [-Type <String>] [-VendorID <Int32>]
 [-WarrantyExpirationDate <DateTime>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### By_Id
```
Set-AtwsInstalledProduct [-Id <Int64[]>] [-AccountPhysicalLocationID <Int32>] [-Active <Boolean>]
 [-ContactID <Int32>] [-ContractID <Int32>] [-ContractServiceBundleID <Int32>] [-ContractServiceID <Int32>]
 [-DailyCost <Double>] [-HourlyCost <Double>] [-InstallDate <DateTime>] [-InstalledProductCategoryID <Int32>]
 [-Location <String>] [-MonthlyCost <Double>] [-Notes <String>] [-NumberOfUsers <Double>]
 [-ParentInstalledProductID <Int32>] [-PerUseCost <Double>] [-ProductID <Int32>] [-ReferenceNumber <String>]
 [-ReferenceTitle <String>] [-SerialNumber <String>] [-ServiceBundleID <Int32>] [-ServiceID <Int32>]
 [-ServiceLevelAgreementID <String>] [-SetupFee <Double>] [-Type <String>] [-VendorID <Int32>]
 [-WarrantyExpirationDate <DateTime>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### By_parameters
```
Set-AtwsInstalledProduct [-PassThru] [-UserDefinedFields <UserDefinedField[]>]
 [-AccountPhysicalLocationID <Int32>] -Active <Boolean> [-ContactID <Int32>] [-ContractID <Int32>]
 [-ContractServiceBundleID <Int32>] [-ContractServiceID <Int32>] [-DailyCost <Double>] [-HourlyCost <Double>]
 [-InstallDate <DateTime>] [-InstalledProductCategoryID <Int32>] [-Location <String>] [-MonthlyCost <Double>]
 [-Notes <String>] [-NumberOfUsers <Double>] [-ParentInstalledProductID <Int32>] [-PerUseCost <Double>]
 -ProductID <Int32> [-ReferenceNumber <String>] [-ReferenceTitle <String>] [-SerialNumber <String>]
 [-ServiceBundleID <Int32>] [-ServiceID <Int32>] [-ServiceLevelAgreementID <String>] [-SetupFee <Double>]
 [-Type <String>] [-VendorID <Int32>] [-WarrantyExpirationDate <DateTime>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
This function one or more objects of type \[Autotask.InstalledProduct\] as input.
You can pipe the objects to the function or pass them using the -InputObject parameter.
You specify the property you want to set and the value you want to set it to using parameters.
The function modifies all objects and updates the online data through the Autotask Web Services API.
The function supports all properties of an \[Autotask.InstalledProduct\] that can be updated through the Web Services API.
The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values.

Entities that have fields that refer to the base entity of this CmdLet:

## EXAMPLES

### EXAMPLE 1
```
Set-AtwsInstalledProduct -InputObject $InstalledProduct [-ParameterName] [Parameter value]
Passes one or more [Autotask.InstalledProduct] object(s) as a variable to the function and sets the property by name 'ParameterName' on ALL the objects before they are passed to the Autotask Web Service API and updated.
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
Type: InstalledProduct[]
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

### -AccountPhysicalLocationID
Account Physical Location

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

### -Active
Product Active

```yaml
Type: Boolean
Parameter Sets: Input_Object, By_Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: Boolean
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContactID
Contact Name

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

### -ContractID
Contract ID

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

### -ContractServiceBundleID
Contract Service Bundle Id

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

### -ContractServiceID
Contract Service Id

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

### -DailyCost
Configuration Item Daily Cost

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

### -HourlyCost
Configuration Item Hourly Cost

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

### -InstallDate
Install Date

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

### -InstalledProductCategoryID
Installed Product Category ID

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

### -Location
Location

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

### -MonthlyCost
Configuration Item Monthly Cost

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

### -Notes
Configuration Item Notes

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

### -NumberOfUsers
Configuration Item Number of Users

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

### -ParentInstalledProductID
Parent Configuration Item

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

### -PerUseCost
Configuration Item Per Use Cost

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

### -ProductID
Product ID

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

### -ReferenceNumber
Reference Number

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

### -ReferenceTitle
Reference Title

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

### -SerialNumber
Serial Number

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

### -ServiceBundleID
Service Bundle ID

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

### -ServiceID
Service ID

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

### -ServiceLevelAgreementID
Service Level Agreement

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

### -SetupFee
Configuration Item Setup Fee

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

### -Type
Configuration Item Type

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

### -VendorID
Vendor Name

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

### -WarrantyExpirationDate
Warranty Expiration Date

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

### [Autotask.InstalledProduct[]]. This function takes one or more objects as input. Pipeline is supported.
## OUTPUTS

### Nothing or [Autotask.InstalledProduct]. This function optionally returns the updated objects if you use the -PassThru parameter.
## NOTES
Related commands:
New-AtwsInstalledProduct
 Get-AtwsInstalledProduct

## RELATED LINKS
