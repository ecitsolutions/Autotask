---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# Remove-AtwsAccountWebhookExcludedResource

## SYNOPSIS
This function deletes a AccountWebhookExcludedResource through the Autotask Web Services API.

## SYNTAX

### Input_Object (Default)
```
Remove-AtwsAccountWebhookExcludedResource [-InputObject <AccountWebhookExcludedResource[]>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### By_parameters
```
Remove-AtwsAccountWebhookExcludedResource -Id <Int64[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function deletes a AccountWebhookExcludedResource through the Autotask Web Services API.

Entities that have fields that refer to the base entity of this CmdLet:

## EXAMPLES

### EXAMPLE 1
```
Remove-AtwsAccountWebhookExcludedResource  [-ParameterName] [Parameter value]
```

## PARAMETERS

### -InputObject
Any objects that should be deleted

```yaml
Type: AccountWebhookExcludedResource[]
Parameter Sets: Input_Object
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Id
The unique id of an object to delete

```yaml
Type: Int64[]
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

### [Autotask.AccountWebhookExcludedResource[]]. This function takes objects as input. Pipeline is supported.
## OUTPUTS

### Nothing. This fuction just deletes the Autotask.AccountWebhookExcludedResource that was passed to the function.
## NOTES
Related commands:
New-AtwsAccountWebhookExcludedResource
 Get-AtwsAccountWebhookExcludedResource

## RELATED LINKS
