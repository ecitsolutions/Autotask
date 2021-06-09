---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# Set-AtwsBusinessLocation

## SYNOPSIS
This function sets parameters on the BusinessLocation specified by the -InputObject parameter or pipeline through the use of the Autotask Web Services API.
Any property of the BusinessLocation that is not marked as READ ONLY by Autotask can be speficied with a parameter.
You can specify multiple paramters.

## SYNTAX

### InputObject (Default)
```
Set-AtwsBusinessLocation [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Input_Object
```
Set-AtwsBusinessLocation [-InputObject <BusinessLocation[]>] [-PassThru] [-AdditionalAddressInfo <String>]
 [-Address1 <String>] [-Address2 <String>] [-City <String>] [-CountryID <Int32>] [-DateFormat <String>]
 [-Default <Boolean>] [-FirstDayOfWeek <String>] [-FridayBusinessHoursEndTime <DateTime>]
 [-FridayBusinessHoursStartTime <DateTime>] [-FridayExtendedHoursEndTime <DateTime>]
 [-FridayExtendedHoursStartTime <DateTime>] [-HolidayExtendedHoursEndTime <DateTime>]
 [-HolidayExtendedHoursStartTime <DateTime>] [-HolidayHoursEndTime <DateTime>]
 [-HolidayHoursStartTime <DateTime>] [-HolidayHoursType <String>] [-HolidaySetID <Int32>]
 [-MondayBusinessHoursEndTime <DateTime>] [-MondayBusinessHoursStartTime <DateTime>]
 [-MondayExtendedHoursEndTime <DateTime>] [-MondayExtendedHoursStartTime <DateTime>] [-Name <String>]
 [-NoHoursOnHolidays <Boolean>] [-NumberFormat <String>] [-PostalCode <String>]
 [-SaturdayBusinessHoursEndTime <DateTime>] [-SaturdayBusinessHoursStartTime <DateTime>]
 [-SaturdayExtendedHoursEndTime <DateTime>] [-SaturdayExtendedHoursStartTime <DateTime>] [-State <String>]
 [-SundayBusinessHoursEndTime <DateTime>] [-SundayBusinessHoursStartTime <DateTime>]
 [-SundayExtendedHoursEndTime <DateTime>] [-SundayExtendedHoursStartTime <DateTime>]
 [-ThursdayBusinessHoursEndTime <DateTime>] [-ThursdayBusinessHoursStartTime <DateTime>]
 [-ThursdayExtendedHoursEndTime <DateTime>] [-ThursdayExtendedHoursStartTime <DateTime>] [-TimeFormat <String>]
 [-TimeZoneID <String>] [-TuesdayBusinessHoursEndTime <DateTime>] [-TuesdayBusinessHoursStartTime <DateTime>]
 [-TuesdayExtendedHoursEndTime <DateTime>] [-TuesdayExtendedHoursStartTime <DateTime>]
 [-WednesdayBusinessHoursEndTime <DateTime>] [-WednesdayBusinessHoursStartTime <DateTime>]
 [-WednesdayExtendedHoursEndTime <DateTime>] [-WednesdayExtendedHoursStartTime <DateTime>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### By_Id
```
Set-AtwsBusinessLocation [-Id <Int64[]>] [-AdditionalAddressInfo <String>] [-Address1 <String>]
 [-Address2 <String>] [-City <String>] [-CountryID <Int32>] [-DateFormat <String>] [-Default <Boolean>]
 [-FirstDayOfWeek <String>] [-FridayBusinessHoursEndTime <DateTime>] [-FridayBusinessHoursStartTime <DateTime>]
 [-FridayExtendedHoursEndTime <DateTime>] [-FridayExtendedHoursStartTime <DateTime>]
 [-HolidayExtendedHoursEndTime <DateTime>] [-HolidayExtendedHoursStartTime <DateTime>]
 [-HolidayHoursEndTime <DateTime>] [-HolidayHoursStartTime <DateTime>] [-HolidayHoursType <String>]
 [-HolidaySetID <Int32>] [-MondayBusinessHoursEndTime <DateTime>] [-MondayBusinessHoursStartTime <DateTime>]
 [-MondayExtendedHoursEndTime <DateTime>] [-MondayExtendedHoursStartTime <DateTime>] [-Name <String>]
 [-NoHoursOnHolidays <Boolean>] [-NumberFormat <String>] [-PostalCode <String>]
 [-SaturdayBusinessHoursEndTime <DateTime>] [-SaturdayBusinessHoursStartTime <DateTime>]
 [-SaturdayExtendedHoursEndTime <DateTime>] [-SaturdayExtendedHoursStartTime <DateTime>] [-State <String>]
 [-SundayBusinessHoursEndTime <DateTime>] [-SundayBusinessHoursStartTime <DateTime>]
 [-SundayExtendedHoursEndTime <DateTime>] [-SundayExtendedHoursStartTime <DateTime>]
 [-ThursdayBusinessHoursEndTime <DateTime>] [-ThursdayBusinessHoursStartTime <DateTime>]
 [-ThursdayExtendedHoursEndTime <DateTime>] [-ThursdayExtendedHoursStartTime <DateTime>] [-TimeFormat <String>]
 [-TimeZoneID <String>] [-TuesdayBusinessHoursEndTime <DateTime>] [-TuesdayBusinessHoursStartTime <DateTime>]
 [-TuesdayExtendedHoursEndTime <DateTime>] [-TuesdayExtendedHoursStartTime <DateTime>]
 [-WednesdayBusinessHoursEndTime <DateTime>] [-WednesdayBusinessHoursStartTime <DateTime>]
 [-WednesdayExtendedHoursEndTime <DateTime>] [-WednesdayExtendedHoursStartTime <DateTime>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### By_parameters
```
Set-AtwsBusinessLocation [-PassThru] [-AdditionalAddressInfo <String>] [-Address1 <String>]
 [-Address2 <String>] [-City <String>] [-CountryID <Int32>] -DateFormat <String> [-Default <Boolean>]
 [-FirstDayOfWeek <String>] [-FridayBusinessHoursEndTime <DateTime>] [-FridayBusinessHoursStartTime <DateTime>]
 [-FridayExtendedHoursEndTime <DateTime>] [-FridayExtendedHoursStartTime <DateTime>]
 [-HolidayExtendedHoursEndTime <DateTime>] [-HolidayExtendedHoursStartTime <DateTime>]
 [-HolidayHoursEndTime <DateTime>] [-HolidayHoursStartTime <DateTime>] [-HolidayHoursType <String>]
 [-HolidaySetID <Int32>] [-MondayBusinessHoursEndTime <DateTime>] [-MondayBusinessHoursStartTime <DateTime>]
 [-MondayExtendedHoursEndTime <DateTime>] [-MondayExtendedHoursStartTime <DateTime>] -Name <String>
 [-NoHoursOnHolidays <Boolean>] -NumberFormat <String> [-PostalCode <String>]
 [-SaturdayBusinessHoursEndTime <DateTime>] [-SaturdayBusinessHoursStartTime <DateTime>]
 [-SaturdayExtendedHoursEndTime <DateTime>] [-SaturdayExtendedHoursStartTime <DateTime>] [-State <String>]
 [-SundayBusinessHoursEndTime <DateTime>] [-SundayBusinessHoursStartTime <DateTime>]
 [-SundayExtendedHoursEndTime <DateTime>] [-SundayExtendedHoursStartTime <DateTime>]
 [-ThursdayBusinessHoursEndTime <DateTime>] [-ThursdayBusinessHoursStartTime <DateTime>]
 [-ThursdayExtendedHoursEndTime <DateTime>] [-ThursdayExtendedHoursStartTime <DateTime>] -TimeFormat <String>
 -TimeZoneID <String> [-TuesdayBusinessHoursEndTime <DateTime>] [-TuesdayBusinessHoursStartTime <DateTime>]
 [-TuesdayExtendedHoursEndTime <DateTime>] [-TuesdayExtendedHoursStartTime <DateTime>]
 [-WednesdayBusinessHoursEndTime <DateTime>] [-WednesdayBusinessHoursStartTime <DateTime>]
 [-WednesdayExtendedHoursEndTime <DateTime>] [-WednesdayExtendedHoursStartTime <DateTime>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
This function one or more objects of type \[Autotask.BusinessLocation\] as input.
You can pipe the objects to the function or pass them using the -InputObject parameter.
You specify the property you want to set and the value you want to set it to using parameters.
The function modifies all objects and updates the online data through the Autotask Web Services API.
The function supports all properties of an \[Autotask.BusinessLocation\] that can be updated through the Web Services API.
The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values.

Entities that have fields that refer to the base entity of this CmdLet:

## EXAMPLES

### EXAMPLE 1
```
Set-AtwsBusinessLocation -InputObject $BusinessLocation [-ParameterName] [Parameter value]
Passes one or more [Autotask.BusinessLocation] object(s) as a variable to the function and sets the property by name 'ParameterName' on ALL the objects before they are passed to the Autotask Web Service API and updated.
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
Type: BusinessLocation[]
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

### -AdditionalAddressInfo
Additional Address Info

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
Address1

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
Address2

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

### -DateFormat
Date Format

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

### -Default
Default

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

### -FirstDayOfWeek
First Day Of Week

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

### -FridayBusinessHoursEndTime
FridayBusinessHoursEndTime

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

### -FridayBusinessHoursStartTime
FridayBusinessHoursStartTime

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

### -FridayExtendedHoursEndTime
FridayExtendedHoursEndTime

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

### -FridayExtendedHoursStartTime
FridayExtendedHoursStartTime

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

### -HolidayExtendedHoursEndTime
Holiday Extended Hours End Time

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

### -HolidayExtendedHoursStartTime
Holiday Extended Hours Start Time

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

### -HolidayHoursEndTime
Holiday Hours End Time

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

### -HolidayHoursStartTime
Holiday Hours Start Time

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

### -HolidayHoursType
Holiday Hours Type

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

### -HolidaySetID
Holiday Set ID

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

### -MondayBusinessHoursEndTime
MondayBusinessHoursEndTime

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

### -MondayBusinessHoursStartTime
MondayBusinessHoursStartTime

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

### -MondayExtendedHoursEndTime
MondayExtendedHoursEndTime

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

### -MondayExtendedHoursStartTime
MondayExtendedHoursStartTime

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

### -Name
Name

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

### -NoHoursOnHolidays
No Hours On Holidays

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

### -NumberFormat
Number Format

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

### -SaturdayBusinessHoursEndTime
SaturdayBusinessHoursEndTime

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

### -SaturdayBusinessHoursStartTime
SaturdayBusinessHoursStartTime

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

### -SaturdayExtendedHoursEndTime
SaturdayExtendedHoursEndTime

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

### -SaturdayExtendedHoursStartTime
SaturdayExtendedHoursStartTime

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

### -State
State

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

### -SundayBusinessHoursEndTime
SundayBusinessHoursEndTime

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

### -SundayBusinessHoursStartTime
SundayBusinessHoursStartTime

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

### -SundayExtendedHoursEndTime
SundayExtendedHoursEndTime

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

### -SundayExtendedHoursStartTime
SundayExtendedHoursStartTime

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

### -ThursdayBusinessHoursEndTime
ThursdayBusinessHoursEndTime

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

### -ThursdayBusinessHoursStartTime
ThursdayBusinessHoursStartTime

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

### -ThursdayExtendedHoursEndTime
ThursdayExtendedHoursEndTime

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

### -ThursdayExtendedHoursStartTime
ThursdayExtendedHoursStartTime

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

### -TimeFormat
Time Format

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

### -TimeZoneID
Time Zone ID

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

### -TuesdayBusinessHoursEndTime
TuesdayBusinessHoursEndTime

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

### -TuesdayBusinessHoursStartTime
TuesdayBusinessHoursStartTime

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

### -TuesdayExtendedHoursEndTime
TuesdayExtendedHoursEndTime

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

### -TuesdayExtendedHoursStartTime
TuesdayExtendedHoursStartTime

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

### -WednesdayBusinessHoursEndTime
WednesdayBusinessHoursEndTime

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

### -WednesdayBusinessHoursStartTime
WednesdayBusinessHoursStartTime

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

### -WednesdayExtendedHoursEndTime
WednesdayExtendedHoursEndTime

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

### -WednesdayExtendedHoursStartTime
WednesdayExtendedHoursStartTime

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

### [Autotask.BusinessLocation[]]. This function takes one or more objects as input. Pipeline is supported.
## OUTPUTS

### Nothing or [Autotask.BusinessLocation]. This function optionally returns the updated objects if you use the -PassThru parameter.
## NOTES
Related commands:
New-AtwsBusinessLocation
 Get-AtwsBusinessLocation

## RELATED LINKS
