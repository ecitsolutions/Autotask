---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# Get-AtwsAccountWebhookField

## SYNOPSIS
This function get one or more AccountWebhookField through the Autotask Web Services API.

## SYNTAX

### Filter (Default)
```
Get-AtwsAccountWebhookField -Filter <String[]> [-GetReferenceEntityById <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### By_parameters
```
Get-AtwsAccountWebhookField [-GetReferenceEntityById <String>] [-FieldID <String[]>] [-id <Nullable`1[]>]
 [-IsDisplayAlwaysField <Nullable`1[]>] [-IsSubscribedField <Nullable`1[]>] [-WebhookID <Nullable`1[]>]
 [-NotEquals <String[]>] [-IsNull <String[]>] [-IsNotNull <String[]>] [-GreaterThan <String[]>]
 [-GreaterThanOrEquals <String[]>] [-LessThan <String[]>] [-LessThanOrEquals <String[]>] [-Like <String[]>]
 [-NotLike <String[]>] [-BeginsWith <String[]>] [-EndsWith <String[]>] [-Contains <String[]>]
 [-IsThisDay <String[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Get_all
```
Get-AtwsAccountWebhookField [-All] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function creates a query based on any parameters you give and returns any resulting objects from the Autotask Web Services Api.
By default the function returns any objects with properties that are Equal (-eq) to the value of the parameter.
To give you more flexibility you can modify the operator by using -NotEquals \[ParameterName\[\]\], -LessThan \[ParameterName\[\]\] and so on.

Possible operators for all parameters are:
 -NotEquals
 -GreaterThan
 -GreaterThanOrEqual
 -LessThan
 -LessThanOrEquals 

Additional operators for \[string\] parameters are:
 -Like (supports * or % as wildcards)
 -NotLike
 -BeginsWith
 -EndsWith
 -Contains

Properties with picklists are:
FieldID

Entities that have fields that refer to the base entity of this CmdLet:

## EXAMPLES

### EXAMPLE 1
```
Get-AtwsAccountWebhookField -Id 0
Returns the object with Id 0, if any.
```

### EXAMPLE 2
```
Get-AtwsAccountWebhookField -AccountWebhookFieldName SomeName
Returns the object with AccountWebhookFieldName 'SomeName', if any.
```

### EXAMPLE 3
```
Get-AtwsAccountWebhookField -AccountWebhookFieldName 'Some Name'
Returns the object with AccountWebhookFieldName 'Some Name', if any.
```

### EXAMPLE 4
```
Get-AtwsAccountWebhookField -AccountWebhookFieldName 'Some Name' -NotEquals AccountWebhookFieldName
Returns any objects with a AccountWebhookFieldName that is NOT equal to 'Some Name', if any.
```

### EXAMPLE 5
```
Get-AtwsAccountWebhookField -AccountWebhookFieldName SomeName* -Like AccountWebhookFieldName
Returns any object with a AccountWebhookFieldName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
```

### EXAMPLE 6
```
Get-AtwsAccountWebhookField -AccountWebhookFieldName SomeName* -NotLike AccountWebhookFieldName
Returns any object with a AccountWebhookFieldName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
```

### EXAMPLE 7
```
Returns any AccountWebhookFields with property FieldID equal to the <PickList Label>. '-PickList' is any parameter on .
```

### EXAMPLE 8
```
-NotEquals FieldID 
Returns any AccountWebhookFields with property FieldID NOT equal to the <PickList Label>.
```

### EXAMPLE 9
```
, <PickList Label2>
Returns any AccountWebhookFields with property FieldID equal to EITHER <PickList Label1> OR <PickList Label2>.
```

### EXAMPLE 10
```
, <PickList Label2> -NotEquals FieldID
Returns any AccountWebhookFields with property FieldID NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
```

### EXAMPLE 11
```
, <PickList Label2> -Like AccountWebhookFieldName -NotEquals FieldID -GreaterThan Id
An example of a more complex query. This command returns any AccountWebhookFields with Id GREATER THAN 1234, a AccountWebhookFieldName that matches the simple pattern SomeName* AND that has a FieldID that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
```

## PARAMETERS

### -Filter
A filter that limits the number of objects that is returned from the API

```yaml
Type: String[]
Parameter Sets: Filter
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GetReferenceEntityById
Follow this external ID and return any external objects

```yaml
Type: String
Parameter Sets: Filter, By_parameters
Aliases: GetRef

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -All
Return all objects in one query

```yaml
Type: SwitchParameter
Parameter Sets: Get_all
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -FieldID
Field ID

```yaml
Type: String[]
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
Account Webhook Field ID

```yaml
Type: Nullable`1[]
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsDisplayAlwaysField
Is Display Always Field

```yaml
Type: Nullable`1[]
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsSubscribedField
Is Subscribed Field

```yaml
Type: Nullable`1[]
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebhookID
Webhook ID

```yaml
Type: Nullable`1[]
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NotEquals
{{ Fill NotEquals Description }}

```yaml
Type: String[]
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsNull
{{ Fill IsNull Description }}

```yaml
Type: String[]
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsNotNull
{{ Fill IsNotNull Description }}

```yaml
Type: String[]
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GreaterThan
{{ Fill GreaterThan Description }}

```yaml
Type: String[]
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GreaterThanOrEquals
{{ Fill GreaterThanOrEquals Description }}

```yaml
Type: String[]
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LessThan
{{ Fill LessThan Description }}

```yaml
Type: String[]
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LessThanOrEquals
{{ Fill LessThanOrEquals Description }}

```yaml
Type: String[]
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Like
{{ Fill Like Description }}

```yaml
Type: String[]
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NotLike
{{ Fill NotLike Description }}

```yaml
Type: String[]
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BeginsWith
{{ Fill BeginsWith Description }}

```yaml
Type: String[]
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndsWith
{{ Fill EndsWith Description }}

```yaml
Type: String[]
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Contains
{{ Fill Contains Description }}

```yaml
Type: String[]
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsThisDay
{{ Fill IsThisDay Description }}

```yaml
Type: String[]
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
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

### Nothing. This function only takes parameters.
## OUTPUTS

### [Autotask.AccountWebhookField[]]. This function outputs the Autotask.AccountWebhookField that was returned by the API.
## NOTES
Related commands:
New-AtwsAccountWebhookField
 Remove-AtwsAccountWebhookField
 Set-AtwsAccountWebhookField

## RELATED LINKS
