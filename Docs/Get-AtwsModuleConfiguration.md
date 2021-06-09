---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# Get-AtwsModuleConfiguration

## SYNOPSIS
This function loads from disk the internal configuration object that stores all module options.

## SYNTAX

```
Get-AtwsModuleConfiguration [[-Path] <FileInfo>] [[-Name] <String>] [-All] [<CommonParameters>]
```

## DESCRIPTION
This function loads from disk the internal configuration object that stores all module options.
The default path is the current PowerShell configuration directory,

## EXAMPLES

### EXAMPLE 1
```
Get-AtwsModuleConfiguration
```

### EXAMPLE 2
```
Get-AtwsModuleConfiguration -Name Sandbox
```

### EXAMPLE 3
```
Get-AtwsModuleConfiguration -Path AtwsConfig.clixml
```

## PARAMETERS

### -Path
{{ Fill Path Description }}

```yaml
Type: FileInfo
Parameter Sets: (All)
Aliases: ProfilePath

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
Aliases: ProfileName

Required: False
Position: 1
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

### -All
{{ Fill All Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Nothing.
## OUTPUTS

### [PSObject]
## NOTES
Related commands:
Save-AtwsModuleConfiguration
New-AtwsModuleConfiguration
Set-AtwsModuleConfiguration
Remove-AtwsModuleConfiguration

## RELATED LINKS
