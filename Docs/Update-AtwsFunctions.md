---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# Update-AtwsFunctions

## SYNOPSIS
This function recreates the autotask powershell functions.

## SYNTAX

```
Update-AtwsFunctions [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Entities with picklists need customized parameter definitions to get the right validateset
attributes.
This function regenerates either static functions (those for entities that do not
have any picklists or user defined fields) or dynamic functions (any function for an entity
with either picklists or user defined fields).

## EXAMPLES

### EXAMPLE 1
```
Update-AtwsFunctions -FunctionSet Static
Regenerates all static functions in $Module.Modulebase/Static directory
```

### EXAMPLE 2
```
Update-AtwsFunctions -FunctionSet Dynamic
Regenerates all static functions in $Module.Modulebase/Dynamic directory and the current user's
dynamic cache directory.
```

## PARAMETERS

### -Force
{{ Fill Force Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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

### A string representing the function set to regenerate, either Static or Dynamic.
## OUTPUTS

### Script files in module directory and the current user's dynamic cache.
## NOTES
NAME: Update-AtwsFunctions

## RELATED LINKS
