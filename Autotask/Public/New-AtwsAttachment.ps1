#Requires -Version 4.0

<#

.COPYRIGHT
Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.

#>
Function New-AtwsAttachment {


    <#
      .SYNOPSIS
      This function creates a new attachment through the Autotask Web Services API.
      .DESCRIPTION
      This function creates a new attachment connected to either an Account, an Opportunity,
      a Project or a Ticket. The attachment can be passed through the pipeline or provided as
      en URL or a file or folder path.
      .INPUTS
      Nothing
      .OUTPUTS
      Autotask attachments
      .EXAMPLE
      New-AtwsAttachment -TicketId 0 -Path C:\Document.docx
      Uploads C:\Document.docx as an attachment to the Ticket with id 0 and sets the attachment title to 'Document.docx'.
      .EXAMPLE
      New-AtwsAttachment -TicketId 0 -Path C:\Document.docx  -Title 'A title'
      Uploads C:\Document.docx as an attachment to the Ticket with id 0 and sets the attachment title to 'A title'.
      .EXAMPLE
      New-AtwsAttachment -TicketId 0 -Path C:\Document.docx -FileLink
      Adds an file link attachment to the Ticket with id 0, title 'Document.docx' and C:\Document.docx as full path.
      .EXAMPLE
      $Attachment = Get-AtwsAttachment -TicketID 0 | Select-Object -First 1
      New-AtwsAttachment -Data $Attachment.Data -TicketId 1 -Title $Attachment.Info.Title -Extension $([IO.Path]::GetExtension($Attachment.Info.FullPath))
      Gets the first attachment from Ticket with id 0 and attaches it to Ticket with id 1
      .NOTE
      Strongly related to Get-AtwsAttachmentInfo
  #>

    [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'Ticket', ConfirmImpact = 'None')]
    Param
    (

        # An object as a byte array that will be attached to an Autotask object
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Account_as_byte'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Opportunity_as_byte'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Project_as_byte'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Ticket_as_byte'
        )]
        [ValidateNotNullOrEmpty()]
        [Byte[]]
        $Data,

        # An object as a byte array that will be attached to an Autotask object
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Account_as_byte'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Opportunity_as_byte'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Project_as_byte'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Ticket_as_byte'
        )]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^\.?\w+$')]
        [string]
        $Extension,

        # A is required for Data
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Account_as_byte'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Opportunity_as_byte'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Project_as_byte'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Ticket_as_byte'
        )]
        [Parameter(
            ParameterSetName = 'Account'
        )]
        [Parameter(
            ParameterSetName = 'Opportunity'
        )]
        [Parameter(
            ParameterSetName = 'Project'
        )]
        [Parameter(
            ParameterSetName = 'Ticket'
        )]
        [Parameter(
            ParameterSetName = 'Account_as_url'
        )]
        [Parameter(
            ParameterSetName = 'Opportunity_as_url'
        )]
        [Parameter(
            ParameterSetName = 'Project_as_url'
        )]
        [Parameter(
            ParameterSetName = 'Ticket_as_url'
        )]
        [ValidateNotNullOrEmpty()]
        [string]
        $Title,

        # A file path that will be attached to an Autotask object
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Account'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Opportunity'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Project'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Ticket'
        )]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( -Not ($_ | Test-Path) ) {
                    throw "File or folder does not exist"
                }
                return $true
            })]
        [IO.FileInfo]
        $Path,

        # URL to attach
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Account_as_url'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Opportunity_as_url'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Project_as_url'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Ticket_as_url'
        )]
        [URI]
        $URI,

        # Attach as a file link, not an attachment
        [Parameter(
            ParameterSetName = 'Account_as_url'
        )]
        [Parameter(
            ParameterSetName = 'Opportunity_as_url'
        )]
        [Parameter(
            ParameterSetName = 'Project_as_url'
        )]
        [Parameter(
            ParameterSetName = 'Ticket_as_url'
        )]
        [Alias('Link')]
        [switch]
        $FileLink,

        # Attach as a folder link, not an attachment
        [Parameter(
            ParameterSetName = 'Account_as_url'
        )]
        [Parameter(
            ParameterSetName = 'Opportunity_as_url'
        )]
        [Parameter(
            ParameterSetName = 'Project_as_url'
        )]
        [Parameter(
            ParameterSetName = 'Ticket_as_url'
        )]
        [Alias('Folder')]
        [switch]
        $FolderLink,

        # Account ID
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Account'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Account_as_byte'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Account_as_url'
        )]
        [ValidateScript( {
                if ( -Not (Get-AtwsAccount -id $_) ) {
                    throw "Account does not exist"
                }
                return $true
            })]
        [long]
        $AccountID,

        # Opportunity ID
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Opportunity'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Opportunity_as_byte'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Opportunity_as_url'
        )]
        [ValidateScript( {
                if ( -Not (Get-AtwsOpportunity -id $_) ) {
                    throw "Opportunity does not exist"
                }
                return $true
            })]
        [long]
        $OpportunityID,

        # Project ID
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Project'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Project_as_byte'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Project_as_url'
        )]
        [ValidateScript( {
                if ( -Not (Get-AtwsProject -id $_) ) {
                    throw "Project does not exist"
                }
                return $true
            })]
        [long]
        $ProjectID,

        # Ticket ID
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Ticket'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Ticket_as_byte'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Ticket_as_url'
        )]
        [ValidateScript( {
                if ( -Not (Get-AtwsTicket -id $_) ) {
                    throw "Ticket does not exist"
                }
                return $true
            })]
        [long]
        $TicketID,

        [ValidateSet('All Autotask Users', 'Internal Users Only')]
        [string]
        $Publish = 'All Autotask Users'

    )

    begin {

        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }

        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

        # Dynamic field info
        $fields = Get-AtwsFieldInfo -Entity AttachmentInfo

        $Picklists = $fields.Where{ $_.IsPickList }

        # Publish dictionary
        $PublishToIndex = @{
            'All Autotask Users'  = '1'
            'Internal Users Only' = '2'
        }
    }


    process {

        # A new Attachment object
        $Attachment = New-Object "Autotask.Attachment"

        # A new AttachmentInfo object
        $AttachmentInfo = New-Object "Autotask.AttachmentInfo"

        # Attach info object to attachment object
        $Attachment.Info = $AttachmentInfo

        # Publishsettings
        $AttachmentInfo.Publish = $PublishToIndex[$Publish]

        # Attachment type
        if ($Data) {
            $Attachment.Data = $Data
            $AttachmentInfo.Type = 'FILE_ATTACHMENT'
            $AttachmentInfo.FullPath = '{0}.{1}' -F $Title, $Extension.TrimStart('.')
        }
        # Is it an URL?
        elseif ($URI) {
            if ($FolderLink.IsPresent) {
                $AttachmentInfo.Type = 'FOLDER_LINK'
            }
            elseif ($FileLink.IsPresent) {
                $AttachmentInfo.Type = 'FILE_LINK'
            }
            else {
                $AttachmentInfo.Type = 'URL'
            }
            $ATtachmentInfo.FullPath = $URI.AbsoluteUri
            $AttachmentInfo.Title = $AttachmentInfo.FullPath
        }
        # It is a file and it is going to be attached.
        else {

            $AsByteStream = @{}

            if ($PSVersionTable.PSVersion.Major -ge 5) {
                $AsByteStream.AsByteStream = $True
            }
            else {
                $AsByteStream.Encoding = 'Byte'
            }

            [Byte[]]$Data = Get-Content @AsByteStream -Path $Path.FullName  -ReadCount 0
            $Attachment.Data = $Data

            # Type is attachment
            $AttachmentInfo.Type = 'FILE_ATTACHMENT'
            $AttachmentInfo.Title = $Path.BaseName
            $AttachmentInfo.FullPath = $Path.FullName

            # Determine content type by file name
            $AttachmentInfo.ContentType = $Path | Get-AtwsMimeMapping

        }

        # Overwrite title with $Title if it exists
        if ($Title) {
            $AttachmentInfo.Title = $Title
        }

        # What are we attaching to?
        $objectType = ($PSCmdlet.ParameterSetName -split '_')[0]

        $AttachmentInfo.ParentId = $TicketId + $AccountID + $ProjectID + $OpportunityId
        $AttachmentInfo.ParentType = $Picklists.Where{ $_.name -eq 'ParentType' }.PickListValues.Where{ $_.Label -eq $objectType }.Value

        # Prepare ShouldProcess
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to create an attachment of type {1} with title {2}.' -F $caption, $AttachmentInfo.Type, $AttachmentInfo.Title
        $verboseWarning = '{0}: About to create an attachment of type {1} with title {2}. Do you want to continue?' -F $caption, $AttachmentInfo.Type, $AttachmentInfo.Title

        # Do it, I dare you!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) {
            $AttachmentId = $Script:Atws.CreateAttachment($Script:Atws.integrationsValue, $Attachment)

            $result = Get-AtwsAttachmentInfo -id $AttachmentId

            Write-Verbose ('{0}: Created attachment with id {1} and title {2}' -F $MyInvocation.MyCommand.Name, $AttachmentId, $result.Title)

        }
    }

    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        if ($result) {
            Return $result
        }
    }


}