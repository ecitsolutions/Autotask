---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# New-AtwsInstalledProductWebhookField

## SYNOPSIS
This function creates a new InstalledProductWebhookField through the Autotask Web Services API.
All required properties are marked as required parameters to assist you on the command line.

## SYNTAX

### By_parameters (Default)
```
New-AtwsInstalledProductWebhookField -FieldID <String> -IsDisplayAlwaysField <Boolean>
 -IsSubscribedField <Boolean> -WebhookID <Int32> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Input_Object
```
New-AtwsInstalledProductWebhookField [-InputObject <InstalledProductWebhookField[]>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The function supports all properties of an \[Autotask.InstalledProductWebhookField\] that can be updated through the Web Services API.
The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values.
Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter.
To get the InstalledProductWebhookField with Id number 0 you could write 'New-AtwsInstalledProductWebhookField -Id 0' or you could write 'New-AtwsInstalledProductWebhookField -Filter {Id -eq 0}.

'New-AtwsInstalledProductWebhookField -Id 0,4' could be written as 'New-AtwsInstalledProductWebhookField -Filter {id -eq 0 -or id -eq 4}'.
For simple queries you can see that using parameters is much easier than the -Filter option.
But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday).
As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new InstalledProductWebhookField you need the following required fields:
 -WebhookID
 -FieldID
 -IsSubscribedField
 -IsDisplayAlwaysField

Entities that have fields that refer to the base entity of this CmdLet:

## EXAMPLES

### EXAMPLE 1
```
$result = New-AtwsInstalledProductWebhookField -WebhookID [Value] -FieldID [Value] -IsSubscribedField [Value] -IsDisplayAlwaysField [Value]
Creates a new [Autotask.InstalledProductWebhookField] through the Web Services API and returns the new object.
```

### EXAMPLE 2
```
$result = Get-AtwsInstalledProductWebhookField -Id 124 | New-AtwsInstalledProductWebhookField 
Copies [Autotask.InstalledProductWebhookField] by Id 124 to a new object through the Web Services API and returns the new object.
```

### EXAMPLE 3
```
Copies [Autotask.InstalledProductWebhookField] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsInstalledProductWebhookField to modify the object.
```

### EXAMPLE 4
```
-Passthru
Copies [Autotask.InstalledProductWebhookField] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsInstalledProductWebhookField to modify the object and returns the new object.
```

## PARAMETERS

### -InputObject
An array of objects to create

```yaml
Type: InstalledProductWebhookField[]
Parameter Sets: Input_Object
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -FieldID
Field ID

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

### -IsDisplayAlwaysField
Is Display Always Field

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

### -IsSubscribedField
Is Subscribed Field

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

### -WebhookID
Webhook ID

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

### [Autotask.InstalledProductWebhookField]. This function outputs the Autotask.InstalledProductWebhookField that was created by the API.
## NOTES
Related commands:
Remove-AtwsInstalledProductWebhookField
 Get-AtwsInstalledProductWebhookField
 Set-AtwsInstalledProductWebhookField

## RELATED LINKS
