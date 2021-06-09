---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# Save-AtwsModuleConfiguration

## SYNOPSIS
This function saves to disk the internal configuration object that stores all module options.

## SYNTAX

```
Save-AtwsModuleConfiguration [[-Configuration] <PSObject>] [[-Name] <String>] [[-Path] <FileInfo>]
 [<CommonParameters>]
```

## DESCRIPTION
This function saves to disk the internal configuration object that stores all module options.
The default path is the current PowerShell configuration directory,

## EXAMPLES

### EXAMPLE 1
```
Save-AtwsModuleConfiguration
```

### EXAMPLE 2
```
Save-AtwsModuleConfiguration -Path AtwsConfig.clixml
```

## PARAMETERS

### -Configuration
Validate the configuration object before accepting it
A configuration object created with New-AtwsModuleConfiguration.
Defaults to currently active configuration settings, if any.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Current default configuration profile, if any
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Name
A name for your configuration profile.
You can specify this name to Connect-AtwsWebApi and swich to
another configuration set at runtime, any time you like.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Nothing.
## OUTPUTS

### [PSObject]
## NOTES
NAME: Save-AtwsModuleConfiguration

Related commands:
Get-AtwsModuleConfiguration
Set-AtwsModuleConfiguration
New-AtwsModuleConfiguration
Remove-AtwsModuleConfiguration

## RELATED LINKS
