---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# Remove-AtwsModuleConfiguration

## SYNOPSIS
This function deletes from disk a named configuration object that stores all module options.

## SYNTAX

```
Remove-AtwsModuleConfiguration [[-Path] <FileInfo>] [[-Name] <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
This function loads from disk the current list of configuration objects that have been saved.
Any configuration with the name given will be deleted.

## EXAMPLES

### EXAMPLE 1
```
Remove-AtwsModuleConfiguration -Name Sandbox
```

### EXAMPLE 2
```
Remove-AtwsModuleConfiguration -Name Default -Path AtwsConfig.clixml
```

## PARAMETERS

### -Path
{{ Fill Path Description }}

```yaml
Type: FileInfo
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $(Join-Path -Path $Global:AtwsModuleConfigurationPath -ChildPath AtwsConfig.clixml)
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
{{ Fill Name Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Default
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

### Nothing
## NOTES
NAME: Remove-AtwsModuleConfiguration

Related commands:
Get-AtwsModuleConfiguration
Set-AtwsModuleConfiguration
New-AtwsModuleConfiguration
Save-AtwsModuleConfiguration

## RELATED LINKS
