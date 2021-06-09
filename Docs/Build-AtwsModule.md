---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# Build-AtwsModule

## SYNOPSIS
This function rebuilds the module based on updated info form the Autotask API

## SYNTAX

```
Build-AtwsModule [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This functions first verifies that you have write permissions to the module directory,
then proceeds with refreshing the entity cache from online data and rebuilds all
entity functions based on the updated entity cache.

## EXAMPLES

### EXAMPLE 1
```
Build-AtwsModule
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

### Nothing.
## OUTPUTS

### Script files in module directory.
## NOTES
NAME: Build-AtwsModule

## RELATED LINKS
