---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# Get-AtwsConnectionObject

## SYNOPSIS
This function returns a SOAPClient Object with the active connection to Autotask Web Api from the current namespace.

## SYNTAX

```
Get-AtwsConnectionObject [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function returns a SOAPClient Object with the active connection to Autotask Web API from the current namespace.
Advanced users may use this object for direct access to API methods or hardcoded queries.
It may also be useful for 
debugging.

## EXAMPLES

### EXAMPLE 1
```
$Atws = Get-AtwsConnectionObject
Gets a SOAPClient Object with the active connection to Autotask Web Api from the current namespace.
```

## PARAMETERS

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

### [Autotask.SOAPClient]
## NOTES
NAME: Get-AtwsConnectionObject

## RELATED LINKS
