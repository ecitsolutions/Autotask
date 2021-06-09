---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# New-AtwsModuleConfiguration

## SYNOPSIS
This function creates an internal configuration object to store all module options.
If 
given a profile name the configuration object will be saved to disk, not returned.

## SYNTAX

```
New-AtwsModuleConfiguration [[-Credential] <PSCredential>] [[-SecureTrackingIdentifier] <SecureString>]
 [-ConvertPicklistIdToLabel] [[-Prefix] <String>] [-RefreshCache] [[-DebugPref] <String>]
 [[-VerbosePref] <String>] [[-ErrorLimit] <Int32>] [[-Name] <String>] [[-Path] <FileInfo>]
 [[-PickListExpansion] <String>] [[-UdfExpansion] <String>] [[-DateConversion] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function creates an internal configuration object to store all module options.
It 
requires a credential object and API key to authenticate to Autotask, all other parameters
has default values and are optional.
If you pass an optional profile name the 
configuration object will be saved to disk, not returned.

## EXAMPLES

### EXAMPLE 1
```
New-AtwsModuleConfiguration -Credential $Credential -SecureTrackingIdentifier $string
```

### EXAMPLE 2
```
New-AtwsModuleConfiguration -Credential $Credential -SecureTrackingIdentifier $string -Name ProfileName
```

## PARAMETERS

### -Credential
An API user to Autotask.
If you do not supply a value you will be prompted interactively.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $(Get-Credential -Message 'Your Autotask API user')
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecureTrackingIdentifier
The API identifier from your resource in Autotask.
Must be encrypted as SecureString.
If you do not supply a value you will be prompted for a cleartext password.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $(Read-Host -AsSecureString -Prompt 'API Tracking Identifier')
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConvertPicklistIdToLabel
Please ignore.
It is only here for backwards compatibility.
Use -PicklistConversion.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: Picklist, UsePickListLabel

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Prefix
It can be empty, but if it isn't it should be max 8 characters and only letters and numbers
Please ignore.
It is only here for backwards compatibility.
Will be removed soon.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RefreshCache
Please ignore.
It is only here for backwards compatibility.
Will be removed soon.

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

### -DebugPref
You may save a default debug preference so you may have a separate profile for debugging.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: $Global:DebugPreference
Accept pipeline input: False
Accept wildcard characters: False
```

### -VerbosePref
You may save a default verbose preference so you may have a separate profile for debugging.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: $Global:VerbosePreference
Accept pipeline input: False
Accept wildcard characters: False
```

### -ErrorLimit
For bulk operations.
When you post 100+ objects with changes to the API it is annoying if the operation
fails on all of them just because 1 of them could not be updated.
How many such errors can you live with
before the whole operation should fail?

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 10
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name you want to use on the connection profile.
Default name is 'Default'.

```yaml
Type: String
Parameter Sets: (All)
Aliases: ProfileName, AtwsModuleConfigurationName

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Full path to an alternate configuration file you want the profile to be saved to.
Optional.

```yaml
Type: FileInfo
Parameter Sets: (All)
Aliases: ProfilePath

Required: False
Position: 8
Default value: $(Join-Path -Path $Global:AtwsModuleConfigurationPath -ChildPath AtwsConfig.clixml)
Accept pipeline input: False
Accept wildcard characters: False
```

### -PickListExpansion
How do you want picklist items to be expanded: Not at all (Disabled), have the text label
replace the index value (Inline) or a separate property with "Label" as suffix (LabelField)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: LabelField
Accept pipeline input: False
Accept wildcard characters: False
```

### -UdfExpansion
How do you want UDFs to be expanded: Not at all (Disabled), as new properties with
a hashtag as prefix (Inline) or as a hashtable on a single property .UDF ()

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: Inline
Accept pipeline input: False
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
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: Local
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
NAME: New-AtwsModuleConfiguration

Related commands:
Get-AtwsModuleConfiguration
Set-AtwsModuleConfiguration
Remove-AtwsModuleConfiguration
Save-AtwsModuleConfiguration

## RELATED LINKS
