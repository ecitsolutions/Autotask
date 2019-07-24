#Requires -Version 4.0

<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

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

  [CmdLetBinding(SupportsShouldProcess = $True, DefaultParameterSetName = 'By_id', ConfirmImpact = 'None')]
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
    $VerboseDescrition = '{0}: About to query the Autotask Web API for attatchment(s).' -F $Caption
    $VerboseWarning = '{0}: About to query the Autotask Web API for attatchment(s). Do you want to continue?' -F $Caption
    
    If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
      $Result = @()
      Foreach ($AttachmentId in $id) {
        $Result += $Script:Atws.GetAttachment($AttachmentId)
      }

      Write-Verbose ('{0}: Number of attachments downloaded: {1}' -F $MyInvocation.MyCommand.Name, $Result.Count)
    

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
