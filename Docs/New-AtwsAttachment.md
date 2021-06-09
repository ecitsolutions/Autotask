---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# New-AtwsAttachment

## SYNOPSIS
This function creates a new attachment through the Autotask Web Services API.

## SYNTAX

### Task Or Ticket (Default)
```
New-AtwsAttachment [-Title <String>] -Path <FileInfo> -TicketID <Int64> [-Publish <String>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### Ticket_as_byte
```
New-AtwsAttachment -Data <Byte[]> -Extension <String> -Title <String> -TicketID <Int64> [-Publish <String>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Project_as_byte
```
New-AtwsAttachment -Data <Byte[]> -Extension <String> -Title <String> -ProjectID <Int64> [-Publish <String>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Opportunity_as_byte
```
New-AtwsAttachment -Data <Byte[]> -Extension <String> -Title <String> -OpportunityID <Int64>
 [-Publish <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Account_as_byte
```
New-AtwsAttachment -Data <Byte[]> -Extension <String> -Title <String> -AccountID <Int64> [-Publish <String>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Ticket_as_url
```
New-AtwsAttachment [-Title <String>] -URI <Uri> [-FileLink] [-FolderLink] -TicketID <Int64> [-Publish <String>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Project_as_url
```
New-AtwsAttachment [-Title <String>] -URI <Uri> [-FileLink] [-FolderLink] -ProjectID <Int64>
 [-Publish <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Opportunity_as_url
```
New-AtwsAttachment [-Title <String>] -URI <Uri> [-FileLink] [-FolderLink] -OpportunityID <Int64>
 [-Publish <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Account_as_url
```
New-AtwsAttachment [-Title <String>] -URI <Uri> [-FileLink] [-FolderLink] -AccountID <Int64>
 [-Publish <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Project
```
New-AtwsAttachment [-Title <String>] -Path <FileInfo> -ProjectID <Int64> [-Publish <String>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### Opportunity
```
New-AtwsAttachment [-Title <String>] -Path <FileInfo> -OpportunityID <Int64> [-Publish <String>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### Account
```
New-AtwsAttachment [-Title <String>] -Path <FileInfo> -AccountID <Int64> [-Publish <String>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function creates a new attachment connected to either an Account, an Opportunity,
a Project or a Ticket.
The attachment can be passed through the pipeline or provided as
en URL or a file or folder path.

## EXAMPLES

### EXAMPLE 1
```
New-AtwsAttachment -TicketId 0 -Path C:\Document.docx
Uploads C:\Document.docx as an attachment to the Ticket with id 0 and sets the attachment title to 'Document.docx'.
```

### EXAMPLE 2
```
New-AtwsAttachment -TicketId 0 -Path C:\Document.docx  -Title 'A title'
Uploads C:\Document.docx as an attachment to the Ticket with id 0 and sets the attachment title to 'A title'.
```

### EXAMPLE 3
```
New-AtwsAttachment -TicketId 0 -Path C:\Document.docx -FileLink
Adds an file link attachment to the Ticket with id 0, title 'Document.docx' and C:\Document.docx as full path.
```

### EXAMPLE 4
```
$Attachment = Get-AtwsAttachment -TicketID 0 | Select-Object -First 1
New-AtwsAttachment -Data $Attachment.Data -TicketId 1 -Title $Attachment.Info.Title -Extension $([IO.Path]::GetExtension($Attachment.Info.FullPath))
Gets the first attachment from Ticket with id 0 and attaches it to Ticket with id 1
```

## PARAMETERS

### -Data
An object as a byte array that will be attached to an Autotask object

```yaml
Type: Byte[]
Parameter Sets: Ticket_as_byte, Project_as_byte, Opportunity_as_byte, Account_as_byte
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Extension
An object as a byte array that will be attached to an Autotask object

```yaml
Type: String
Parameter Sets: Ticket_as_byte, Project_as_byte, Opportunity_as_byte, Account_as_byte
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title
A is required for Data

```yaml
Type: String
Parameter Sets: Task Or Ticket, Ticket_as_url, Project_as_url, Opportunity_as_url, Account_as_url, Project, Opportunity, Account
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Ticket_as_byte, Project_as_byte, Opportunity_as_byte, Account_as_byte
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
A file path that will be attached to an Autotask object

```yaml
Type: FileInfo
Parameter Sets: Task Or Ticket, Project, Opportunity, Account
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -URI
URL to attach

```yaml
Type: Uri
Parameter Sets: Ticket_as_url, Project_as_url, Opportunity_as_url, Account_as_url
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileLink
Attach as a file link, not an attachment

```yaml
Type: SwitchParameter
Parameter Sets: Ticket_as_url, Project_as_url, Opportunity_as_url, Account_as_url
Aliases: Link

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -FolderLink
Attach as a folder link, not an attachment

```yaml
Type: SwitchParameter
Parameter Sets: Ticket_as_url, Project_as_url, Opportunity_as_url, Account_as_url
Aliases: Folder

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccountID
Account ID

```yaml
Type: Int64
Parameter Sets: Account_as_byte, Account_as_url, Account
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -OpportunityID
Opportunity ID

```yaml
Type: Int64
Parameter Sets: Opportunity_as_byte, Opportunity_as_url, Opportunity
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProjectID
Project ID

```yaml
Type: Int64
Parameter Sets: Project_as_byte, Project_as_url, Project
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -TicketID
Ticket ID

```yaml
Type: Int64
Parameter Sets: Task Or Ticket, Ticket_as_byte, Ticket_as_url
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Publish
{{ Fill Publish Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: All Autotask Users
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

### Autotask attachments
## NOTES
Strongly related to Get-AtwsAttachmentInfo

## RELATED LINKS
