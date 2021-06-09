---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# Uninstall-AtwsOldModuleVersion

## SYNOPSIS
This function uninstalls old module versions.

## SYNTAX

```
Uninstall-AtwsOldModuleVersion [[-ModuleName] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
When you update modules from Powershell Gallery with built-in functions any new
module versions are installed alongside existing versions.
Sometimes this may 
cause problems, including wasting disk space.
This function gets a list of all
installed versions of a module and uninstalls every version but the last.

## EXAMPLES

### EXAMPLE 1
```
Uninstall-AtwsOldModuleVersion
Uninstalls all but the last version of this module.
```

### EXAMPLE 2
```
Uninstall-AtwsOldModuleVersion -ModuleName ModuleName
Uninstalls all but the last version of any module named ModuleName.
```

## PARAMETERS

### -ModuleName
The name of the module where all versions but the last should be uninstalled.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: False
Position: 1
Default value: $MyInvocation.MyCommand.ModuleName
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

### Nothing, only a parameter.
## OUTPUTS

### Nothing, it only deletes.
## NOTES
NAME: Uninstall-AtwsOldModuleVersion

## RELATED LINKS
