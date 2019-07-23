#Requires -Version 4.0

<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

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
      .NOTE
      Strongly related to Get-AtwsAttachmentInfo
  #>

  [CmdLetBinding(SupportsShouldProcess = $True, DefaultParameterSetName = 'Input_Object', ConfirmImpact = 'Low')]
  Param
  (

    # An object that will be modified by any parameters and updated in Autotask
    [Parameter(
        Mandatory = $True,
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
        Mandatory = $True,
        ParameterSetName = 'By_id'
    )]
    [ValidateNotNullOrEmpty()]
    [long[]]
    $id,

    # Account ID
    [Parameter(
        Mandatory = $True,
        ParameterSetName = 'Account'
    )]
    [ValidateScript({
          if( -Not (Get-AtwsAccount -id $_) ){
            throw "Account does not exist"
          }
          return $true
    })]
    [long[]]
    $AccountID,

    # Opportunity ID
    [Parameter(
        Mandatory = $True,
        ParameterSetName = 'Opportunity'
    )]
    [ValidateScript({
          if( -Not (Get-AtwsOpportunity -id $_) ){
            throw "Opportunity does not exist"
          }
          return $true
    })]
    [long[]]
    $OpportunityID,

    # Project ID
    [Parameter(
        Mandatory = $True,
        ParameterSetName = 'Project'
    )]
    [ValidateScript({
          if( -Not (Get-AtwsProject -id $_) ){
            throw "Project does not exist"
          }
          return $true
    })]
    [long[]]
    $ProjectID,

    # Ticket ID
    [Parameter(
        Mandatory = $True,
        ParameterSetName = 'Ticket'
    )]
    [ValidateScript({
          if( -Not (Get-AtwsTicket -id $_) ){
            throw "Ticket does not exist"
          }
          return $true
    })]
    [long[]]
    $TicketID
   
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
    
  }


  Process {

    # Do we have to look up attachment Id by another object Id
    If ($PSCmdlet.ParameterSetName -ne 'By_id') { 
      
      # Yes, we have to get the attachment Id ourselves. So, what kind of object 
      # are we looking for?

      $AttachmentInfoParams = @{ } 

      $ObjectType = Switch ($PSCmdlet.ParameterSetName) {
        'Input_Object' { 
          $InputObject[0].GetType().Name 
          $ObjectId = $InputObject.Id
        }
        default { 
          $PSCmdlet.ParameterSetName 
          $ObjectId = Switch ($PSCmdlet.ParameterSetName) {
            'Account' { $AccountID }
            'Opportunity' { $OpportunityID }
            'Project' { $ProjectID }
            'Ticket' { $TicketID }
          }
        }
      }

      Switch ($ObjectType) {
        'Opportunity' {
          $AttachmentInfoParams['OpportunityId'] = $ObjectId
        }
        default {
          $AttachmentInfoParams['ParentId'] = $ObjectId
          $AttachmentInfoParams['ParentType'] = $ObjectType
        }
      }
      
      $AttachmentInfo = Get-AtwsAttachmentInfo @AttachmentInfoParams

      If ($AttachmentInfo.Count -gt 0) {
        $id = $AttachmentInfo.Id
      }
      else {
        # Empty result
        Return
      }
    }
    

    $Caption = $MyInvocation.MyCommand.Name
    $VerboseDescrition = '{0}: About to delete {1} attatchment(s).' -F $Caption, $id.count
    $VerboseWarning = '{0}: About to delete {1} attatchment(s). Do you want to continue?' -F $Caption, $id.count
    
    If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
      $Result = @()
      Foreach ($AttachmentId in $id) {
        $Result += $Script:Atws.DeleteAttachment($AttachmentId)
      }

      Write-Verbose ('{0}: Number of attachment(s) deleted: {1}' -F $MyInvocation.MyCommand.Name, $Result.Count)
    
    }
  }

  End {
    Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
  }

}
