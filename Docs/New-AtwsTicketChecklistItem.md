---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# New-AtwsTicketChecklistItem

## SYNOPSIS
This function creates a new TicketChecklistItem through the Autotask Web Services API.
All required properties are marked as required parameters to assist you on the command line.

## SYNTAX

### By_parameters (Default)
```
New-AtwsTicketChecklistItem [-Completed <Boolean>] [-CompletedByResourceID <Int32>]
 [-CompletedDateTime <DateTime>] [-Important <Boolean>] -ItemName <String> [-KnowledgebaseArticleID <String>]
 [-Position <Int32>] -TicketID <Int32> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Input_Object
```
New-AtwsTicketChecklistItem [-InputObject <TicketChecklistItem[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The function supports all properties of an \[Autotask.TicketChecklistItem\] that can be updated through the Web Services API.
The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values.
Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter.
To get the TicketChecklistItem with Id number 0 you could write 'New-AtwsTicketChecklistItem -Id 0' or you could write 'New-AtwsTicketChecklistItem -Filter {Id -eq 0}.

'New-AtwsTicketChecklistItem -Id 0,4' could be written as 'New-AtwsTicketChecklistItem -Filter {id -eq 0 -or id -eq 4}'.
For simple queries you can see that using parameters is much easier than the -Filter option.
But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday).
As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new TicketChecklistItem you need the following required fields:
 -ItemName
 -TicketID

Entities that have fields that refer to the base entity of this CmdLet:

## EXAMPLES

### EXAMPLE 1
```
$result = New-AtwsTicketChecklistItem -ItemName [Value] -TicketID [Value]
Creates a new [Autotask.TicketChecklistItem] through the Web Services API and returns the new object.
```

### EXAMPLE 2
```
$result = Get-AtwsTicketChecklistItem -Id 124 | New-AtwsTicketChecklistItem 
Copies [Autotask.TicketChecklistItem] by Id 124 to a new object through the Web Services API and returns the new object.
```

### EXAMPLE 3
```
Copies [Autotask.TicketChecklistItem] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsTicketChecklistItem to modify the object.
```

### EXAMPLE 4
```
-Passthru
Copies [Autotask.TicketChecklistItem] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsTicketChecklistItem to modify the object and returns the new object.
```

## PARAMETERS

### -InputObject
An array of objects to create

```yaml
Type: TicketChecklistItem[]
Parameter Sets: Input_Object
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Completed
Completed

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

### -CompletedByResourceID
Completed By Resource ID

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

### -CompletedDateTime
Completed date

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

### -Important
Important

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

### -ItemName
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

### -KnowledgebaseArticleID
Knowledgebase Article ID

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

### -Position
Position

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

### -TicketID
Ticket ID

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

### [Autotask.TicketChecklistItem]. This function outputs the Autotask.TicketChecklistItem that was created by the API.
## NOTES
Related commands:
Remove-AtwsTicketChecklistItem
 Get-AtwsTicketChecklistItem
 Set-AtwsTicketChecklistItem

## RELATED LINKS
