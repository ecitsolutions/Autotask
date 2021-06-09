---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# Set-AtwsTask

## SYNOPSIS
This function sets parameters on the Task specified by the -InputObject parameter or pipeline through the use of the Autotask Web Services API.
Any property of the Task that is not marked as READ ONLY by Autotask can be speficied with a parameter.
You can specify multiple paramters.

## SYNTAX

### InputObject (Default)
```
Set-AtwsTask [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Input_Object
```
Set-AtwsTask [-InputObject <Task[]>] [-PassThru] [-UserDefinedFields <UserDefinedField[]>]
 [-AccountPhysicalLocationID <Int32>] [-AllocationCodeID <Int32>] [-AssignedResourceID <Int32>]
 [-AssignedResourceRoleID <Int32>] [-CanClientPortalUserCompleteTask <Boolean>] [-DepartmentID <String>]
 [-Description <String>] [-EndDateTime <DateTime>] [-EstimatedHours <Double>] [-ExternalID <String>]
 [-IsVisibleInClientPortal <Boolean>] [-PhaseID <Int32>] [-Priority <Int32>] [-PriorityLabel <String>]
 [-ProjectID <Int32>] [-PurchaseOrderNumber <String>] [-RemainingHours <Double>] [-StartDateTime <DateTime>]
 [-Status <String>] [-TaskCategoryID <String>] [-TaskType <String>] [-Title <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### By_Id
```
Set-AtwsTask [-Id <Int64[]>] [-AccountPhysicalLocationID <Int32>] [-AllocationCodeID <Int32>]
 [-AssignedResourceID <Int32>] [-AssignedResourceRoleID <Int32>] [-CanClientPortalUserCompleteTask <Boolean>]
 [-DepartmentID <String>] [-Description <String>] [-EndDateTime <DateTime>] [-EstimatedHours <Double>]
 [-ExternalID <String>] [-IsVisibleInClientPortal <Boolean>] [-PhaseID <Int32>] [-Priority <Int32>]
 [-PriorityLabel <String>] [-ProjectID <Int32>] [-PurchaseOrderNumber <String>] [-RemainingHours <Double>]
 [-StartDateTime <DateTime>] [-Status <String>] [-TaskCategoryID <String>] [-TaskType <String>]
 [-Title <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### By_parameters
```
Set-AtwsTask [-PassThru] [-UserDefinedFields <UserDefinedField[]>] [-AccountPhysicalLocationID <Int32>]
 [-AllocationCodeID <Int32>] [-AssignedResourceID <Int32>] [-AssignedResourceRoleID <Int32>]
 [-CanClientPortalUserCompleteTask <Boolean>] [-DepartmentID <String>] [-Description <String>]
 [-EndDateTime <DateTime>] [-EstimatedHours <Double>] [-ExternalID <String>]
 [-IsVisibleInClientPortal <Boolean>] [-PhaseID <Int32>] [-Priority <Int32>] [-PriorityLabel <String>]
 -ProjectID <Int32> [-PurchaseOrderNumber <String>] [-RemainingHours <Double>] [-StartDateTime <DateTime>]
 -Status <String> [-TaskCategoryID <String>] -TaskType <String> -Title <String> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
This function one or more objects of type \[Autotask.Task\] as input.
You can pipe the objects to the function or pass them using the -InputObject parameter.
You specify the property you want to set and the value you want to set it to using parameters.
The function modifies all objects and updates the online data through the Autotask Web Services API.
The function supports all properties of an \[Autotask.Task\] that can be updated through the Web Services API.
The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values.

Entities that have fields that refer to the base entity of this CmdLet:

## EXAMPLES

### EXAMPLE 1
```
Set-AtwsTask -InputObject $Task [-ParameterName] [Parameter value]
Passes one or more [Autotask.Task] object(s) as a variable to the function and sets the property by name 'ParameterName' on ALL the objects before they are passed to the Autotask Web Service API and updated.
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
Type: Task[]
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
Account Physical Location ID

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

### -AllocationCodeID
Allocation Code Name

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

### -AssignedResourceID
Resource

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

### -AssignedResourceRoleID
Resource Role Name

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

### -CanClientPortalUserCompleteTask
Can Client Portal User Complete Task

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

### -DepartmentID
Task Department Name

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

### -Description
Task Description

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

### -EndDateTime
Task End Datetime

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

### -EstimatedHours
Task Estimated Hours

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

### -ExternalID
Task External ID

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

### -IsVisibleInClientPortal
Is Visible in Client Portal

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

### -PhaseID
Phase ID

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

### -Priority
Task Priority

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

### -PriorityLabel
Priority Label

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

### -ProjectID
Project

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

### -PurchaseOrderNumber
Purchase Order Number

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

### -RemainingHours
Remaining Hours

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

### -StartDateTime
Task Start Date

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

### -Status
Task Status

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

### -TaskCategoryID
Task Category ID

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

### -TaskType
Task Type

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

### -Title
Task Title

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

### [Autotask.Task[]]. This function takes one or more objects as input. Pipeline is supported.
## OUTPUTS

### Nothing or [Autotask.Task]. This function optionally returns the updated objects if you use the -PassThru parameter.
## NOTES
Related commands:
New-AtwsTask
 Get-AtwsTask

## RELATED LINKS
