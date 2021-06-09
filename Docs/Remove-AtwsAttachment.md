---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# Remove-AtwsAttachment

## SYNOPSIS
This function deletes Attachments through the Autotask Web Services API.

## SYNTAX

### Input_Object (Default)
```
Remove-AtwsAttachment -InputObject <PSObject[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### By_id
```
Remove-AtwsAttachment -id <Int64[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Account
```
Remove-AtwsAttachment -AccountID <Int64[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Opportunity
```
Remove-AtwsAttachment -OpportunityID <Int64[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Project
```
Remove-AtwsAttachment -ProjectID <Int64[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Task Or Ticket
```
Remove-AtwsAttachment -TicketID <Int64[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Based on your parameters this function either deletes an attachment directly (by attachment id) or
uses your parameters to get any attachment information about the objects you provide (by object or
by object id) through Get-AtwsAttachmentInfo.
The function then uses the AttachmentInfo objects to
delete any attachments.

## EXAMPLES

### EXAMPLE 1
```
Remove-AtwsAttachment -Id 0
Deletes the attachment with Id 0, if any.
```

### EXAMPLE 2
```
Remove-AtwsAttachmentInfo -AccountId 0
Deletes any attachments connected to the Account with id 0.
```

### EXAMPLE 3
```
Remove-AtwsAttachmentInfo -OpportunityId 0
Deletes any attachments connected to an Opportunity with id 0.
```

### EXAMPLE 4
```
Remove-AtwsAttachmentInfo -ProjectId 0
Deletes any attachments connected to a Project with id 0.
```

### EXAMPLE 5
```
Remove-AtwsAttachmentInfo -TicketId 0
Deletes any attachments connected to a Ticket with id 0.
```

### EXAMPLE 6
```
$Ticket | Remove-AtwsAttachment
Deletes any attachments connected to the Ticket passed through the pipeline. Also works for Opportunities, Accounts and Projects.
```

## PARAMETERS

### -InputObject
An object that will be modified by any parameters and updated in Autotask
InputObject must be one of these four types

```yaml
Type: PSObject[]
Parameter Sets: Input_Object
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -id
Attachment ID

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

### -AccountID
Account ID

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

### -OpportunityID
Opportunity ID

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
Project ID

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
Ticket ID

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

### Either Nothing, Account, Ticket, Opportunity or Project
## OUTPUTS

### Nothing
## NOTES
Strongly related to Get-AtwsAttachmentInfo

## RELATED LINKS
