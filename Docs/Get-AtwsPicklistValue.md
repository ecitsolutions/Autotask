---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# Get-AtwsPicklistValue

## SYNOPSIS
This function gets valid fields for an Autotask Entity

## SYNTAX

### by_Entity (Default)
```
Get-AtwsPicklistValue [-UserDefinedFields] [-Entity] <String> [-FieldName] <String> [[-ParentValue] <String>]
 [<CommonParameters>]
```

### as_Values
```
Get-AtwsPicklistValue [-UserDefinedFields] [-Value] [-Entity] <String> [-FieldName] <String>
 [[-ParentValue] <String>] [<CommonParameters>]
```

### as_Labels
```
Get-AtwsPicklistValue [-UserDefinedFields] [-Label] [-Quoted] [-Hashtable] [-Entity] <String>
 [-FieldName] <String> [[-ParentValue] <String>] [<CommonParameters>]
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

### -UserDefinedFields
{{ Fill UserDefinedFields Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: UDF

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Label
{{ Fill Label Description }}

```yaml
Type: SwitchParameter
Parameter Sets: as_Labels
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Quoted
{{ Fill Quoted Description }}

```yaml
Type: SwitchParameter
Parameter Sets: as_Labels
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hashtable
{{ Fill Hashtable Description }}

```yaml
Type: SwitchParameter
Parameter Sets: as_Labels
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
{{ Fill Value Description }}

```yaml
Type: SwitchParameter
Parameter Sets: as_Values
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
Parameter Sets: (All)
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
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentValue
{{ Fill ParentValue Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None.
## OUTPUTS

### [Autotask.Field[]]
## NOTES

## RELATED LINKS
