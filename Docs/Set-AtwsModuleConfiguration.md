---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# Set-AtwsModuleConfiguration

## SYNOPSIS
This function updates the runtime configuration of the module.

## SYNTAX

### Username_and_password (Default)
```
Set-AtwsModuleConfiguration [-Username <String>] [-SecurePassword <SecureString>]
 [-SecureTrackingIdentifier <SecureString>] [-ConvertPicklistIdToLabel] [-Prefix <String>] [-RefreshCache]
 [-DebugPref <String>] [-VerbosePref <String>] [-ErrorLimit <Int32>] [-Path <FileInfo>] [-Name <String>]
 [-PickListExpansion <String>] [-UdfExpansion <String>] [-DateConversion <String>] [-PassThru] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### Credentials
```
Set-AtwsModuleConfiguration [-Credential <PSCredential>] [-SecureTrackingIdentifier <SecureString>]
 [-ConvertPicklistIdToLabel] [-Prefix <String>] [-RefreshCache] [-DebugPref <String>] [-VerbosePref <String>]
 [-ErrorLimit <Int32>] [-Path <FileInfo>] [-Name <String>] [-PickListExpansion <String>]
 [-UdfExpansion <String>] [-DateConversion <String>] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function updates the runtime configuration of the module.
Values that can be changed while the module is loaded
are:
- Credentials (both username and password may be changed separately)
- API key
- Whether parameters with picklist values should show labels in place of numbers (ConvertPicklistIdsToLabel)
- Debug preference
- Verbose preference
- Errorlimit - how many errors should Set-Atws* or New-Atws* functions accept before the operation is aborted

The parameters Prefix and RefreshCache does not have any effect on the current connection.
They must be saved and loaded
as part of a later connection to have any effect.

## EXAMPLES

### EXAMPLE 1
```
Set-AtwsModuleConfiguration -Credential $Credential -ApiTrackingIdentifier $string
```

## PARAMETERS

### -Credential
An API user to Autotask.
Optional.

```yaml
Type: PSCredential
Parameter Sets: Credentials
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Username
A new username to use for the connection.
Optional.

```yaml
Type: String
Parameter Sets: Username_and_password
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SecurePassword
A new password for this connection.
Must be encrypted as SecureString.
Optional.

```yaml
Type: SecureString
Parameter Sets: Username_and_password
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SecureTrackingIdentifier
The API identifier from your resource in Autotask.
Must be encrypted as SecureString.
Optional.

```yaml
Type: SecureString
Parameter Sets: Username_and_password
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: SecureString
Parameter Sets: Credentials
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ConvertPicklistIdToLabel
Please ignore.
It is only here for backwards compatibility.
Use -PicklistConversion

```yaml
Type: SwitchParameter
Parameter Sets: Username_and_password
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: SwitchParameter
Parameter Sets: Credentials
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Prefix
It can be empty, but if it isn't it should be max 8 characters and only letters and numbers
Please ignore.
It is only here for backwards functionality.
Will be removed soon.

```yaml
Type: String
Parameter Sets: Username_and_password
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Credentials
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -RefreshCache
Please ignore.
It is only here for backwards compatibility.
Will be removed soon.

```yaml
Type: SwitchParameter
Parameter Sets: Username_and_password
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: SwitchParameter
Parameter Sets: Credentials
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DebugPref
You may save a default debug preference so you may have a separate profile for debugging.

```yaml
Type: String
Parameter Sets: Username_and_password
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Credentials
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -VerbosePref
You may save a default verbose preference so you may have a separate profile for debugging.

```yaml
Type: String
Parameter Sets: Username_and_password
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Credentials
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ErrorLimit
For bulk operations.
When you post 100+ objects with changes to the API it is annoying if the operation
fails on all of them just because 1 of them could not be updated.
How many such errors can you live with
before the whole operation should fail?
Default = 10.
Optional.

```yaml
Type: Int32
Parameter Sets: Username_and_password
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: Int32
Parameter Sets: Credentials
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Path
Full path to an alternate configuration file you want the profile to be saved to.
Optional.

```yaml
Type: FileInfo
Parameter Sets: Username_and_password
Aliases: ProfilePath

Required: False
Position: Named
Default value: $(Join-Path -Path $Global:AtwsModuleConfigurationPath -ChildPath AtwsConfig.clixml)
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: FileInfo
Parameter Sets: Credentials
Aliases: ProfilePath

Required: False
Position: Named
Default value: $(Join-Path -Path $Global:AtwsModuleConfigurationPath -ChildPath AtwsConfig.clixml)
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Use this parameter to save to another configuration name.
The name you want to use on the connection profile.
Default name is 'Default'.

```yaml
Type: String
Parameter Sets: Username_and_password
Aliases: ProfileName

Required: False
Position: Named
Default value: Default
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Credentials
Aliases: ProfileName

Required: False
Position: Named
Default value: Default
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PickListExpansion
How do you want picklist items to be expanded: Not at all (Disabled), have the text label
replace the index value (Inline) or a separate property with "Label" as suffix (LabelField)

```yaml
Type: String
Parameter Sets: Username_and_password
Aliases:

Required: False
Position: Named
Default value: LabelField
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Credentials
Aliases:

Required: False
Position: Named
Default value: LabelField
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -UdfExpansion
How do you want UDFs to be expanded: Not at all (Disabled), as new properties with
a hashtag as prefix (Inline) or as a hashtable on a single property .UDF ()

```yaml
Type: String
Parameter Sets: Username_and_password
Aliases:

Required: False
Position: Named
Default value: Inline
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Credentials
Aliases:

Required: False
Position: Named
Default value: Inline
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DateConversion
Allow disabled and local before testing timezone conversion
Allow any valid TimeZone on current system
The Autotask API always uses Eastern Standard Time for all DateTime objects.
This option
controls which timezone DateTime objects will be converted to when they are retrieved.
The
default setting is 'Local', which imply that all DateTime objects will be converted to 
the current, local timezone setting on the system where the code runs.
Other options are
'Disabled' - do not perform any timezone conversion at all; and 'specific/timezone', i.e.
any timezone your local system supports.
Useful if your companys locations span multiple
timezones.

```yaml
Type: String
Parameter Sets: Username_and_password
Aliases:

Required: False
Position: Named
Default value: Local
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Credentials
Aliases:

Required: False
Position: Named
Default value: Local
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PassThru
Return the changed configuration as a new configuration object.
Useful if you want to change
an option (or more) in the current running configuration and save it to a new profile name
in one go.

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

### Nothing.
## NOTES
NAME: Set-AtwsModuleConfiguration

Related commands:
Get-AtwsModuleConfiguration
New-AtwsModuleConfiguration
Remove-AtwsModuleConfiguration
Save-AtwsModuleConfiguration

## RELATED LINKS
