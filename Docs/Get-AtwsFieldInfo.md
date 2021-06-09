---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# Get-AtwsFieldInfo

## SYNOPSIS
This function gets valid fields for an Autotask Entity

## SYNTAX

### by_Entity (Default)
```
Get-AtwsFieldInfo [-UserDefinedFields] [-EntityInfo] [-Entity] <String> [-UpdateCache] [-CacheOnly] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### get_All
```
Get-AtwsFieldInfo [-All] [-UpdateCache] [-CacheOnly] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### by_Reference
```
Get-AtwsFieldInfo [-ReferencingEntity] [-Entity] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### single_Field
```
Get-AtwsFieldInfo [-UserDefinedFields] [-Entity] <String> [-FieldName] <String> [-CacheOnly] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function gets valid fields for an Autotask Entity

## EXAMPLES

### EXAMPLE 1
```
Get-AtwsFieldInfo -Entity Account
Gets all valid built-in fields and user defined fields for the Account entity.
```

## PARAMETERS

### -All
{{ Fill All Description }}

```yaml
Type: SwitchParameter
Parameter Sets: get_All
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReferencingEntity
{{ Fill ReferencingEntity Description }}

```yaml
Type: SwitchParameter
Parameter Sets: by_Reference
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserDefinedFields
{{ Fill UserDefinedFields Description }}

```yaml
Type: SwitchParameter
Parameter Sets: by_Entity, single_Field
Aliases: UDF

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -EntityInfo
{{ Fill EntityInfo Description }}

```yaml
Type: SwitchParameter
Parameter Sets: by_Entity
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Entity
{{ Fill Entity Description }}

```yaml
Type: String
Parameter Sets: by_Entity, by_Reference, single_Field
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FieldName
{{ Fill FieldName Description }}

```yaml
Type: String
Parameter Sets: single_Field
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UpdateCache
{{ Fill UpdateCache Description }}

```yaml
Type: SwitchParameter
Parameter Sets: by_Entity, get_All
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -CacheOnly
{{ Fill CacheOnly Description }}

```yaml
Type: SwitchParameter
Parameter Sets: by_Entity, get_All, single_Field
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

### None.
## OUTPUTS

### [Autotask.Field[]]
## NOTES

## RELATED LINKS
