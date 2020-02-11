#Requires -Version 4.0
<#

.COPYRIGHT
Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsAttachment {


    <#
      .SYNOPSIS
      This function gets one or more Attachments through the Autotask Web Services API.
      .DESCRIPTION
      Based on your parameters this function either gets an attachment directly (by attachment id) or
      uses your parameters to get any attachment information about the objects you provide (by object or
      by object id) through Get-AtwsAttachmentInfo. The function then uses the AttachmentInfo objects to 
      get any attachment ids and then the attachments are downloaded and returned.
      
      .INPUTS
      Either Nothing, Account, Ticket, Opportunity or Project
      .OUTPUTS
      Autotask attachments
      .EXAMPLE
      Get-AtwsAttachment -Id 0
      Returns the attachment with Id 0, if any.
      .EXAMPLE
      Get-AtwsAttachmentInfo -AccountId 0
      Returns any attachments connected to the Account with id 0.
      .EXAMPLE
      Get-AtwsAttachmentInfo -OpportunityId 0
      Returns any attachments connected to an Opportunity with id 0.
      .EXAMPLE
      Get-AtwsAttachmentInfo -ProjectId 0
      Returns any attachments connected to a Project with id 0.
      .EXAMPLE
      Get-AtwsAttachmentInfo -TicketId 0
      Returns any attachments connected to a Ticket with id 0.
      .EXAMPLE
      $Ticket | Get-AtwsAttachmentInfo
      Returns any attachments connected to the Ticket passed through the pipeline. Also works for Opportunities, Accounts and Projects.
      .NOTE
      Strongly related to Get-AtwsAttachmentInfo
  #>

    [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'By_id', ConfirmImpact = 'None')]
    Param
    (

        # An object that will be modified by any parameters and updated in Autotask
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Input_Object',
            ValueFromPipeline = $true
        )]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { 
                # InputObject must be one of these four types
                $_[0].GetType().Name -in 'Account', 'Ticket', 'Opportunity', 'Project' 
            })]
        [PSObject[]]
        $InputObject,

        # Attachment ID
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'By_id'
        )]
        [ValidateNotNullOrEmpty()]
        [long[]]
        $id,

        # Account ID
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Account'
        )]
        [ValidateScript( {
                if ( -Not (Get-AtwsAccount -id $_) ) {
                    throw "Account does not exist"
                }
                return $true
            })]
        [long[]]
        $AccountID,

        # Opportunity ID
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Opportunity'
        )]
        [ValidateScript( {
                if ( -Not (Get-AtwsOpportunity -id $_) ) {
                    throw "Opportunity does not exist"
                }
                return $true
            })]
        [long[]]
        $OpportunityID,

        # Project ID
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Project'
        )]
        [ValidateScript( {
                if ( -Not (Get-AtwsProject -id $_) ) {
                    throw "Project does not exist"
                }
                return $true
            })]
        [long[]]
        $ProjectID,

        # Ticket ID
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Ticket'
        )]
        [ValidateScript( {
                if ( -Not (Get-AtwsTicket -id $_) ) {
                    throw "Ticket does not exist"
                }
                return $true
            })]
        [long[]]
        $TicketID
   
    )

    begin { 
   
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
        # Dynamic field info
        $fields = Get-AtwsFieldInfo -Entity AttachmentInfo
        $dateTimeParams = $fields.Where( { $_.Type -eq 'datetime' }).Name
        $picklists = $fields.Where{ $_.IsPickList }
    
        # Set up TimeZone offset handling
        if (-not($script:ESTzone)) {
            $script:ESTzone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Eastern Standard Time")
        }
    
        if (-not($script:ESToffset)) {
            $now = Get-Date
            $ESTtime = [System.TimeZoneInfo]::ConvertTimeFromUtc($now.ToUniversalTime(), $ESTzone)

            $script:ESToffset = (New-TimeSpan -Start $ESTtime -End $now).TotalHours
        }
    
    }


    process {

        # Do we have to look up attachment Id by another object Id
        if ($PSCmdlet.ParameterSetName -ne 'By_id') { 
      
            # Yes, we have to get the attachment Id ourselves. So, what kind of object 
            # are we looking for?

            $attachmentInfoParams = @{ } 

            $objectType = switch ($PSCmdlet.ParameterSetName) {
                'Input_Object' { 
                    $InputObject[0].GetType().Name 
                    $objectId = $InputObject.Id
                }
                default { 
                    $PSCmdlet.ParameterSetName 
                    $objectId = switch ($PSCmdlet.ParameterSetName) {
                        'Account' { $AccountID }
                        'Opportunity' { $OpportunityID }
                        'Project' { $ProjectID }
                        'Ticket' { $TicketID }
                    }
                }
            }

            switch ($objectType) {
                'Opportunity' {
                    $attachmentInfoParams['OpportunityId'] = $objectId
                }
                default {
                    $attachmentInfoParams['ParentId'] = $objectId
                    $attachmentInfoParams['ParentType'] = $objectType
                }
            }
      
            $attachmentInfo = Get-AtwsAttachmentInfo @attachmentInfoParams

            if ($attachmentInfo.Count -gt 0) {
                $id = $attachmentInfo.Id
            }
            else {
                # Empty result
                return
            }
        }
    

        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to query the Autotask Web API for attatchment(s).' -F $caption
        $verboseWarning = '{0}: About to query the Autotask Web API for attatchment(s). Do you want to continue?' -F $caption
    
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
            $result = @()
            foreach ($attachmentId in $id) {
                $result += $Script:Atws.GetAttachment($attachmentId)
            }

            Write-Verbose ('{0}: Number of attachments downloaded: {1}' -F $MyInvocation.MyCommand.Name, $result.Count)
    

            # Expand UDFs by default
            # Normalize dates (convert to local time). EVery datetime field ever returned
            # By the API is in CEST.
            foreach ($item in $result) {
                # Any userdefined fields?
                if ($item.UserDefinedFields.Count -gt 0) { 
                    # Expand User defined fields for easy filtering of collections and readability
                    foreach ($UDF in $item.UserDefinedFields) {
                        # Make names you HAVE TO escape...
                        $UDFName = '#{0}' -F $UDF.Name
                        Add-Member -InputObject $item -MemberType NoteProperty -Name $UDFName -Value $UDF.Value -Force
                    }  
                }
      
                # Adjust TimeZone on all DateTime properties
                # Dates RETURNED by the API are always in CEST. Add timezone difference
                # to get local time
                foreach ($dateTimeParam in $dateTimeParams) {
      
                    # Get the datetime value
                    $value = $item.$dateTimeParam
                
                    # Skip if parameter is empty
                    if (-not ($value)) {
                        Continue
                    }
                    # Yes, you really have to ADD the difference
                    $item.$dateTimeParam = $value.AddHours($script:ESToffset)
                }

                if ($Script:Atws.Configuration.ConvertPicklistIdToLabel) { 
                    # Restore picklist labels
                    foreach ($field in $picklists) {
                        if ($item.$($field.Name) -in $field.PicklistValues.Value) {
                            $item.$($field.Name) = ($field.PickListValues.Where{ $_.Value -eq $item.$($field.Name) }).Label
                        }
                    }
                }
            }
        }
    }

    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        if ($result) {
            return $result
        }
    }


}
