#Requires -Version 4.0

<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

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
      [Byte[]]
      .OUTPUTS
      Autotask attachments
      .EXAMPLE
      $Document | New-AtwsAttachment -TicketId 0 -Title 'A title'
      Uploads $Document as an attachment to the Ticket with id 0 and sets the attachment title to 'A Title'.
      .EXAMPLE
      New-AtwsAttachment -TicketId 0 -Path C:\Document.docx
      Uploads C:\Document.docx as an attachment to the Ticket with id 0 and sets the attachment title to 'Document.docx'.
      .EXAMPLE
      New-AtwsAttachment -TicketId 0 -Title 'A title' -Path C:\Document.docx
      Uploads C:\Document.docx as an attachment to the Ticket with id 0 and sets the attachment title to 'A title'.
      .EXAMPLE
      New-AtwsAttachment -TicketId 0 -Path C:\Document.docx -FileLink
      Adds an file link attachment to the Ticket with id 0, title 'Document.docx' and C:\Document.docx as full path.
      .NOTE
      Strongly related to Get-AtwsAttachmentInfo
  #>

  [CmdLetBinding(SupportsShouldProcess = $True, DefaultParameterSetName = 'Ticket', ConfirmImpact = 'None')]
  Param
  (

    # An object as a byte array that will be attached to an Autotask object
    [Parameter(
        Mandatory = $True,
        ParameterSetName = 'Account_as_byte',
        ValueFromPipeline = $true
    )]
    [Parameter(
        Mandatory = $True, 
        ParameterSetName = 'Opportunity_as_byte',
        ValueFromPipeline = $true
    )]
    [Parameter(
        Mandatory = $True, 
        ParameterSetName = 'Project_as_byte',
        ValueFromPipeline = $true
    )]
    [Parameter(
        Mandatory = $True, 
        ParameterSetName = 'Ticket_as_byte',
        ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Byte[]]
    $Data,

    # A is required for Data
    [Parameter(
        Mandatory = $True,
        ParameterSetName = 'Account_as_byte'
    )]
    [Parameter(
        Mandatory = $True, 
        ParameterSetName = 'Opportunity_as_byte'
    )]
    [Parameter(
        Mandatory = $True, 
        ParameterSetName = 'Project_as_byte'
    )]
    [Parameter(
        Mandatory = $True, 
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
    [String]
    $Title,
    
    # A file path that will be attached to an Autotask object
    [Parameter(
        Mandatory = $True, 
        ParameterSetName = 'Account'
    )]
    [Parameter(
        Mandatory = $True, 
        ParameterSetName = 'Opportunity'
    )]
    [Parameter(
        Mandatory = $True, 
        ParameterSetName = 'Project'
    )]
    [Parameter(
        Mandatory = $True, 
        ParameterSetName = 'Ticket'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({
          if( -Not ($_ | Test-Path) ){
            throw "File or folder does not exist"
          }
          return $true
    })]
    [IO.FileInfo]
    $Path,

    # URL to attach
    [Parameter(
        Mandatory = $True, 
        ParameterSetName = 'Account_as_url'
    )]
    [Parameter(
        Mandatory = $True, 
        ParameterSetName = 'Opportunity_as_url'
    )]
    [Parameter(
        Mandatory = $True, 
        ParameterSetName = 'Project_as_url'
    )]
    [Parameter(
        Mandatory = $True, 
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
    [Switch]
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
    [Switch]
    $FolderLink,

    # Account ID
    [Parameter(
        Mandatory = $True,
        ParameterSetName = 'Account'
    )]
    [Parameter(
        Mandatory = $True,
        ParameterSetName = 'Account_as_byte'
    )]
    [Parameter(
        Mandatory = $True,
        ParameterSetName = 'Account_as_url'
    )]
    [ValidateScript({
          if( -Not (Get-AtwsAccount -id $_) ){
            throw "Account does not exist"
          }
          return $true
    })]    
    [long]
    $AccountID,

    # Opportunity ID
    [Parameter(
        Mandatory = $True,
        ParameterSetName = 'Opportunity'
    )]
    [Parameter(
        Mandatory = $True,
        ParameterSetName = 'Opportunity_as_byte'
    )]
    [Parameter(
        Mandatory = $True,
        ParameterSetName = 'Opportunity_as_url'
    )]
    [ValidateScript({
          if( -Not (Get-AtwsOpportunity -id $_) ){
            throw "Opportunity does not exist"
          }
          return $true
    })]
    [long]
    $OpportunityID,

    # Project ID
    [Parameter(
        Mandatory = $True,
        ParameterSetName = 'Project'
    )]
    [Parameter(
        Mandatory = $True,
        ParameterSetName = 'Project_as_byte'
    )]
    [Parameter(
        Mandatory = $True,
        ParameterSetName = 'Project_as_url'
    )]
    [ValidateScript({
          if( -Not (Get-AtwsProject -id $_) ){
            throw "Project does not exist"
          }
          return $true
    })]
    [long]
    $ProjectID,

    # Ticket ID
    [Parameter(
        Mandatory = $True,
        ParameterSetName = 'Ticket'
    )]
    [Parameter(
        Mandatory = $True,
        ParameterSetName = 'Ticket_as_byte'
    )]
    [Parameter(
        Mandatory = $True,
        ParameterSetName = 'Ticket_as_url'
    )]
    [ValidateScript({
          if( -Not (Get-AtwsTicket -id $_) ){
            throw "Ticket does not exist"
          }
          return $true
    })]
    [long]
    $TicketID,

    [ValidateSet('All Autotask Users','Internal Users Only')]
    [String]
    $Publish = 'All Autotask Users'
   
  )

  Begin { 
   
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
    # Dynamic field info
    $Fields = Get-AtwsFieldInfo -Entity AttachmentInfo
    $DateTimeParams = $Fields.Where({$_.Type -eq 'datetime'}).Name
    $Picklists = $Fields.Where{$_.IsPickList}
    
    # Set up TimeZone offset handling
    If (-not($script:ESTzone)) {
      $script:ESTzone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Eastern Standard Time")
    }
    
    If (-not($script:ESToffset)) {
      $Now = Get-Date
      $ESTtime = [System.TimeZoneInfo]::ConvertTimeFromUtc($Now.ToUniversalTime(), $ESTzone)

      $script:ESToffset = (New-TimeSpan -Start $ESTtime -End $Now).TotalHours
    }
    
    # Publish dictionary
    $PublishToIndex = @{
      'All Autotask Users' = '1'
      'Internal Users Only' = '2'
    }
  }


  Process {
    
    # A new Attachment object
    $Attachment = New-object "$Script:Namespace.Attachment"
    
    # A new AttachmentInfo object
    $AttachmentInfo = New-object "$Script:Namespace.AttachmentInfo"
    
    # Attach info object to attachment object
    $Attachment.Info = $AttachmentInfo

    # Publishsettings 
    $AttachmentInfo.Publish = $PublishToIndex[$Publish]
    
    # Attachment type
    If ($Data) {
      $Attachment.Data = $Data
      $AttachmentInfo.Type = 'FILE_ATTACHMENT'
      $AttachmentInfo.FullPath = $Title
    }
    # Is it an URL?
    ElseIf ($URI) {
      If ($FolderLink.IsPresent) {
        $AttachmentInfo.Type = 'FOLDER_LINK'
      }
      ElseIf ($FileLink.IsPresent) {
        $AttachmentInfo.Type = 'FILE_LINK'
      }
      Else { 
        $AttachmentInfo.Type = 'URL'
      }
      $ATtachmentInfo.FullPath = $URI.AbsoluteUri
      $AttachmentInfo.Title = $AttachmentInfo.FullPath
    }
    # It is a file and it is going to be attached.
    Else {
      [Byte[]]$Data = Get-Content -Path $Path.FullName -Encoding Byte -ReadCount 0
      $Attachment.Data = $Data

      # Type is attachment
      $AttachmentInfo.Type = 'FILE_ATTACHMENT'
      $AttachmentInfo.Title = $Path.BaseName
      $AttachmentInfo.FullPath = $Path.FullName

    }
    
    # Overwrite title with $Title if it exists
    If ($Title) {
      $AttachmentInfo.Title = $Title
    }
    
    # What are we attaching to?
    $ObjectType = ($PSCmdlet.ParameterSetName -split '_')[0]

    If ($OpportunityID) {
       $AttachmentInfo.OpportunityId = $OpportunityId
    }
    Else {
      $AttachmentInfo.ParentId = $TicketId + $AccountID + $ProjectID
      $AttachmentInfo.ParentType = $Picklists.Where{$_.name -eq 'ParentType'}.PickListValues.Where{$_.Label -eq $ObjectType}.Value
    }

    $Caption = $MyInvocation.MyCommand.Name
    $VerboseDescrition = '{0}: About to create an attachment of type {1} with title {2}.' -F $Caption, $AttachmentInfo.Type, $AttachmentInfo.Title
    $VerboseWarning = '{0}: About to create an attachment of type {1} with title {2}. Do you want to continue?' -F $Caption, $AttachmentInfo.Type, $AttachmentInfo.Title
    
    If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
      $AttachmentId = $Script:Atws.CreateAttachment($Attachment)
      
      $Result = Get-AtwsAttachmentInfo -id $AttachmentId
      
      Write-Verbose ('{0}: Created attachment with id {1} and title {2}' -F $MyInvocation.MyCommand.Name, $AttachmentId, $Result.Title)
    

      # Expand UDFs by default
      # Normalize dates (convert to local time). EVery datetime field ever returned
      # By the API is in CEST.
      Foreach ($Item in $Result)
      {
        # Any userdefined fields?
        If ($Item.UserDefinedFields.Count -gt 0)
        { 
          # Expand User defined fields for easy filtering of collections and readability
          Foreach ($UDF in $Item.UserDefinedFields)
          {
            # Make names you HAVE TO escape...
            $UDFName = '#{0}' -F $UDF.Name
            Add-Member -InputObject $Item -MemberType NoteProperty -Name $UDFName -Value $UDF.Value -Force
          }  
        }
      
        # Adjust TimeZone on all DateTime properties
        # Dates RETURNED by the API are always in CEST. Add timezone difference
        # to get local time
        Foreach ($DateTimeParam in $DateTimeParams) {
      
          # Get the datetime value
          $Value = $Item.$DateTimeParam
                
          # Skip if parameter is empty
          If (-not ($Value)) {
            Continue
          }
          # Yes, you really have to ADD the difference
          $Item.$DateTimeParam  = $Value.AddHours($script:ESToffset)
        }

        If ($Script:UsePickListLabels) { 
          # Restore picklist labels
          Foreach ($Field in $Picklists)
          {
            If ($Item.$($Field.Name) -in $Field.PicklistValues.Value) {
              $Item.$($Field.Name) = ($Field.PickListValues.Where{$_.Value -eq $Item.$($Field.Name)}).Label
            }
          }
        }
      }
    }
  }

  End {
    Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    If ($Result) {
      Return $Result
    }
  }


}
