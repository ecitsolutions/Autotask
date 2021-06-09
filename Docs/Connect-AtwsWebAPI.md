---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# Connect-AtwsWebAPI

## SYNOPSIS
This function connects to the Autotask Web Services API, authenticates a user and creates a 
SOAP webservices proxy object.

## SYNTAX

### ConfigurationFile (Default)
```
Connect-AtwsWebAPI [-ProfilePath <FileInfo>] [-ProfileName <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Parameters
```
Connect-AtwsWebAPI -Credential <PSCredential> -ApiTrackingIdentifier <String> [-ConvertPicklistIdToLabel]
 [-Prefix <String>] [-RefreshCache] [-NoDiskCache] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ConfigurationObject
```
Connect-AtwsWebAPI -AtwsModuleConfiguration <PSObject> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The function takes a credential object and uses it to authenticate and connect to the Autotask
Web Services API.
This is done by creating a webservices proxy.
The proxy object imports the SOAP 
WSDL definition file, creates all entity classes in PowerShell and exposes the basic methods
(query(), create(), update(), remove(), GetEntityInfo(), GetFieldInfo() and a few more).

## EXAMPLES

### EXAMPLE 1
```
Connect-AtwsWebAPI
If there doesn't exist any saved Default connection profile it prompts for a username and password and authenticates to Autotask. Otherwise it loads the connection profile named "Default" and connects.
```

### EXAMPLE 2
```
Connect-AtwsWebAPI -ProfileName Sandbox
Loads the connection profile named 'Sandbox' and connects. If there are no saved connection profile called 'Sandbox' it throws an exception and exits.
```

### EXAMPLE 3
```
Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $ApiKey
Connects to Autotask using the credentials passed as parameters
```

### EXAMPLE 4
```
New-AtwsModuleConfiguration -Credential $Credential -ApiTrackingIdentifier $ApiKey -Dateconversion Disabled | Connect-AtwsWebAPI
Creates a new module configuration object with date conversion between EST (the Autotask API always uses EST no matter which data center you are connected to) and local time disabled.
```

## PARAMETERS

### -Credential
The username and password for your Autotask API user

```yaml
Type: PSCredential
Parameter Sets: Parameters
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiTrackingIdentifier
The API tracking identifier from your Autotask API user

```yaml
Type: String
Parameter Sets: Parameters
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConvertPicklistIdToLabel
Have the module substitute all picklist ids for their textlabel at runtime

```yaml
Type: SwitchParameter
Parameter Sets: Parameters
Aliases: Picklist, UsePickListLabels

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Prefix
It can be empty, but if it isn't it should be max 8 characters and only letters and numbers
Not used.
Kept for backwards compatility.
Will be removed soon.

```yaml
Type: String
Parameter Sets: Parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RefreshCache
Not used.
Kept for backwards compatility.
Will be removed soon.

```yaml
Type: SwitchParameter
Parameter Sets: Parameters
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoDiskCache
Not used.
Kept for backwards compatility.
Will be removed soon.

```yaml
Type: SwitchParameter
Parameter Sets: Parameters
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AtwsModuleConfiguration
A module configuration object created with New-AtwsModuleConfiguration

```yaml
Type: PSObject
Parameter Sets: ConfigurationObject
Aliases: Configuration, Profile

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProfilePath
The path to an alternate clixml file with connection profiles

```yaml
Type: FileInfo
Parameter Sets: ConfigurationFile
Aliases: Path

Required: False
Position: Named
Default value: $(Join-Path -Path $Global:AtwsModuleConfigurationPath -ChildPath AtwsConfig.clixml)
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProfileName
Name of the Configuration inside the Config file.
The name for the connection profile you want to use.
Default is "Default".

```yaml
Type: String
Parameter Sets: ConfigurationFile
Aliases: Name

Required: False
Position: Named
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

### Nothing
## OUTPUTS

### Nothing
## NOTES
Related commands:
New-AtwsModuleConfiguration
Save-AtwsModuleConfiguration
Set-AtwsModuleConfiguration
Get-AtwsModuleConfiguration

## RELATED LINKS
