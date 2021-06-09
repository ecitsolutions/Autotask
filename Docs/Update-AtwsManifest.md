---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# Update-AtwsManifest

## SYNOPSIS
This function recreates the module manifest and nuspec with default settings.

## SYNTAX

```
Update-AtwsManifest [[-UpdateVersion] <String>] [-Beta] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function recreates a module manifest and nuspec for the current module and has an option
for increasing the version number to the next available based on current API version
and module version.
There is also an option for creating a manifest for a beta module.

## EXAMPLES

### EXAMPLE 1
```
Update-AtwsManifest
Recreates a manifest and a nuspec file for the current module and overwrites the existing files
with them.
```

### EXAMPLE 2
```
Update-AtwsManifest -UpdateVersion
Recreates a manifest and a nuspec file for the current module, updates the version number in both
and overwrites the existing files with them.
```

## PARAMETERS

### -UpdateVersion
Optional flag that causes the function to increase the version number a single increment.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Beta
Optional flag that causes the function to save the manifest files with suffix "Beta".

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

### Nothing, only parameters.
## OUTPUTS

### A PowerShell module manifest and nuspec file for the current module.
## NOTES
NAME: Update-AtwsFunctions

## RELATED LINKS
