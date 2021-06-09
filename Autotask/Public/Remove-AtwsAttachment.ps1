#Requires -Version 4.0

<#

.COPYRIGHT
Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.

#>
Function Remove-AtwsAttachment {


    <#
      .SYNOPSIS
      This function deletes Attachments through the Autotask Web Services API.
      .DESCRIPTION
      Based on your parameters this function either deletes an attachment directly (by attachment id) or
      uses your parameters to get any attachment information about the objects you provide (by object or
      by object id) through Get-AtwsAttachmentInfo. The function then uses the AttachmentInfo objects to
      delete any attachments.
      .INPUTS
      Either Nothing, Account, Ticket, Opportunity or Project
      .OUTPUTS
      Nothing
      .EXAMPLE
      Remove-AtwsAttachment -Id 0
      Deletes the attachment with Id 0, if any.
      .EXAMPLE
      Remove-AtwsAttachmentInfo -AccountId 0
      Deletes any attachments connected to the Account with id 0.
      .EXAMPLE
      Remove-AtwsAttachmentInfo -OpportunityId 0
      Deletes any attachments connected to an Opportunity with id 0.
      .EXAMPLE
      Remove-AtwsAttachmentInfo -ProjectId 0
      Deletes any attachments connected to a Project with id 0.
      .EXAMPLE
      Remove-AtwsAttachmentInfo -TicketId 0
      Deletes any attachments connected to a Ticket with id 0.
      .EXAMPLE
      $Ticket | Remove-AtwsAttachment
      Deletes any attachments connected to the Ticket passed through the pipeline. Also works for Opportunities, Accounts and Projects.
      .NOTES
      Strongly related to Get-AtwsAttachmentInfo
  #>

    [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'Input_Object', ConfirmImpact = 'Low')]
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
            ParameterSetName = 'Task Or Ticket'
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

    }


    process {

        # Do we have to look up attachment Id by another object Id
        if ($PSCmdlet.ParameterSetName -ne 'By_id') {

            # Yes, we have to get the attachment Id ourselves. So, what kind of object
            # are we looking for?

            $AttachmentInfoParams = @{ }

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
                        'Task Or Ticket' { $TicketID }
                    }
                }
            }

            switch ($objectType) {
                'Opportunity' {
                    $AttachmentInfoParams['OpportunityId'] = $objectId
                }
                default {
                    $AttachmentInfoParams['ParentId'] = $objectId
                    $AttachmentInfoParams['ParentType'] = $objectType
                }
            }

            $AttachmentInfo = Get-AtwsAttachmentInfo @AttachmentInfoParams

            if ($AttachmentInfo.Count -gt 0) {
                $id = $AttachmentInfo.Id
            }
            else {
                # Empty result
                Return
            }
        }


        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to delete {1} attatchment(s).' -F $caption, $id.count
        $verboseWarning = '{0}: About to delete {1} attatchment(s). Do you want to continue?' -F $caption, $id.count

        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) {
            $result = @()
            foreach ($AttachmentId in $id) {
                $result += $Script:Atws.DeleteAttachment($Script:Atws.integrationsValue, $AttachmentId)
            }

            Write-Verbose ('{0}: Number of attachment(s) deleted: {1}' -F $MyInvocation.MyCommand.Name, $result.Count)

        }
    }

    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    }

}
