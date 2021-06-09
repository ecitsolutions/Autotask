---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# Get-AtwsAttachment

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### By_id (Default)
```
Get-AtwsAttachment -id <Int64[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Input_Object
```
Get-AtwsAttachment -InputObject <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Account
```
Get-AtwsAttachment -AccountID <Int64[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Opportunity
```
Get-AtwsAttachment -OpportunityID <Int64[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Project
```
Get-AtwsAttachment -ProjectID <Int64[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Task Or Ticket
```
Get-AtwsAttachment -TicketID <Int64[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -AccountID
{{ Fill AccountID Description }}

```yaml
Type: Int64[]
Parameter Sets: Account
Aliases:

Required: True
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

### -InputObject
{{ Fill InputObject Description }}

```yaml
Type: Object
Parameter Sets: Input_Object
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -OpportunityID
{{ Fill OpportunityID Description }}

```yaml
Type: Int64[]
Parameter Sets: Opportunity
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProjectID
{{ Fill ProjectID Description }}

```yaml
Type: Int64[]
Parameter Sets: Project
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TicketID
{{ Fill TicketID Description }}

```yaml
Type: Int64[]
Parameter Sets: Task Or Ticket
Aliases:

Required: True
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

### -id
{{ Fill id Description }}

```yaml
Type: Int64[]
Parameter Sets: By_id
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
