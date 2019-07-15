#Requires -Version 4.0
#Version 1.6.2.13
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Set-AtwsTicket
{


<#
.SYNOPSIS
This function sets parameters on the Ticket specified by the -InputObject parameter or pipeline through the use of the Autotask Web Services API. Any property of the Ticket that is not marked as READ ONLY by Autotask can be speficied with a parameter. You can specify multiple paramters.
.DESCRIPTION
This function one or more objects of type [Autotask.Ticket] as input. You can pipe the objects to the function or pass them using the -InputObject parameter. You specify the property you want to set and the value you want to set it to using parameters. The function modifies all objects and updates the online data through the Autotask Web Services API. The function supports all properties of an [Autotask.Ticket] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values.

Entities that have fields that refer to the base entity of this CmdLet:

AccountToDo
 BillingItem
 ChangeRequestLink
 ExpenseItem
 NotificationHistory
 PurchaseOrderItem
 ServiceCallTicket
 ServiceLevelAgreementResults
 SurveyResults
 Ticket
 TicketAdditionalContact
 TicketAdditionalInstalledProduct
 TicketChangeRequestApproval
 TicketChecklistItem
 TicketChecklistLibrary
 TicketCost
 TicketHistory
 TicketNote
 TicketSecondaryResource
 TimeEntry

.INPUTS
[Autotask.Ticket[]]. This function takes one or more objects as input. Pipeline is supported.
.OUTPUTS
Nothing or [Autotask.Ticket]. This function optionally returns the updated objects if you use the -PassThru parameter.
.EXAMPLE
Set-AtwsTicket -InputObject $Ticket [-ParameterName] [Parameter value]
Passes one or more [Autotask.Ticket] object(s) as a variable to the function and sets the property by name 'ParameterName' on ALL the objects before they are passed to the Autotask Web Service API and updated.
 .EXAMPLE
$Ticket | Set-AtwsTicket -ParameterName <Parameter value>
Same as the first example, but now the objects are passed to the funtion through the pipeline, not passed as a parameter. The end result is identical.
 .EXAMPLE
Get-AtwsTicket -Id 0 | Set-AtwsTicket -ParameterName <Parameter value>
Gets the instance with Id 0 directly from the Web Services API, modifies a parameter and updates Autotask. This approach works with all valid parameters for the Get function.
 .EXAMPLE
Get-AtwsTicket -Id 0,4,8 | Set-AtwsTicket -ParameterName <Parameter value>
Gets multiple instances by Id, modifies them all and updates Autotask.
 .EXAMPLE
$Result = Get-AtwsTicket -Id 0,4,8 | Set-AtwsTicket -ParameterName <Parameter value> -PassThru
Gets multiple instances by Id, modifies them all, updates Autotask and returns the updated objects.

.LINK
New-AtwsTicket
 .LINK
Get-AtwsTicket

#>

  [CmdLetBinding(SupportsShouldProcess = $True, DefaultParameterSetName='InputObject', ConfirmImpact='Low')]
  Param
  (
# An object that will be modified by any parameters and updated in Autotask
    [Parameter(
      ParameterSetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.Ticket[]]
    $InputObject,

# The object.ids of objects that should be modified by any parameters and updated in Autotask
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [long[]]
    $Id,

# Return any updated objects through the pipeline
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Switch]
    $PassThru,

# User defined fields already setup i Autotask
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Alias('UDF')]
    [Autotask.UserDefinedField[]]
    $UserDefinedFields,

# Client
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int]]
    $AccountID,

# Allocation Code Name
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[Int]]
    $AllocationCodeID,

# Resource
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[Int]]
    $AssignedResourceID,

# Resource Role Name
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[Int]]
    $AssignedResourceRoleID,

# Ticket Contact
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[Int]]
    $ContactID,

# Contract
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[Int]]
    $ContractID,

# Ticket Description
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(0,8000)]
    [string]
    $Description,

# Ticket End Date
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime]]
    $DueDateTime,

# Ticket Estimated Hours
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[double]]
    $EstimatedHours,

# Ticket External ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(0,50)]
    [string]
    $ExternalID,

# Configuration Item
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[Int]]
    $InstalledProductID,

# Ticket Issue
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [String]
    $IssueType,

# Ticket Priority
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [String]
    $Priority,

# Ticket Department Name OR Ticket Queue Name
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [String]
    $QueueID,

# Ticket Source
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [String]
    $Source,

# Ticket Status
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [String]
    $Status,

# Ticket Subissue Type
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [String]
    $SubIssueType,

# Ticket Title
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,255)]
    [string]
    $Title,

# Service Level Agreement ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [String]
    $ServiceLevelAgreementID,

# Resolution
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(0,32000)]
    [string]
    $Resolution,

# purchase_order_number
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(0,50)]
    [string]
    $PurchaseOrderNumber,

# Ticket Type
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [String]
    $TicketType,

# Problem Ticket ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[Int]]
    $ProblemTicketId,

# Opportunity ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[Int]]
    $OpportunityId,

# Change Approval Board ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [String]
    $ChangeApprovalBoard,

# Change Approval Type
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [String]
    $ChangeApprovalType,

# Change Approval Status
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [String]
    $ChangeApprovalStatus,

# Change Info Field 1
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(0,8000)]
    [string]
    $ChangeInfoField1,

# Change Info Field 2
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(0,8000)]
    [string]
    $ChangeInfoField2,

# Change Info Field 3
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(0,8000)]
    [string]
    $ChangeInfoField3,

# Change Info Field 4
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(0,8000)]
    [string]
    $ChangeInfoField4,

# Change Info Field 5
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(0,8000)]
    [string]
    $ChangeInfoField5,

# Contract Service ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[long]]
    $ContractServiceID,

# Contract Service Bundle ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[long]]
    $ContractServiceBundleID,

# Monitor Type ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [String]
    $MonitorTypeID,

# Monitor ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[Int]]
    $MonitorID,

# Ticket Category
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [String]
    $TicketCategory,

# Project ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[Int]]
    $ProjectID,

# Business Division Subdivision ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[Int]]
    $BusinessDivisionSubdivisionID,

# Account Physical Location
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[Int]]
    $AccountPhysicalLocationID
  )
 
  Begin
  { 
    $EntityName = 'Ticket'
    
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
        
    # Set up TimeZone offset handling
    If (-not($script:LocalToEST))
    {
      $Now = Get-Date
      $ESTzone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Eastern Standard Time")
      $ESTtime = [System.TimeZoneInfo]::ConvertTimeFromUtc($Now.ToUniversalTime(), $ESTzone)

      # Time difference in hours from localtime to API time
      $script:LocalToEST = (New-TimeSpan -Start $Now -End $ESTtime).TotalHours
    }
    
    # Collect fresh copies of InputObject if passed any IDs
    If ($Id.Count -gt 0 -and $Id.Count -le 200) {
      $Filter = 'Id -eq {0}' -F ($Id -join ' -or Id -eq ')
      $InputObject = Get-AtwsData -Entity $EntityName -Filter $Filter
      
      # Remove the ID parameter so we do not try to set it on every object
      $Null = $PSBoundParameters.Remove('id')
    }
    ElseIf ($Id.Count -gt 200) {
      Throw [ApplicationException] 'Too many objects, the module can process a maximum of 200 objects when using the Id parameter.'
    }
  }

  Process
  {
    $Fields = Get-AtwsFieldInfo -Entity $EntityName
    
    # Loop through parameters and update any inputobjects with the given parameter values    
    Foreach ($Parameter in $PSBoundParameters.GetEnumerator())
    {
      $Field = $Fields | Where-Object {$_.Name -eq $Parameter.Key}
      If (($Field) -or $Parameter.Key -eq 'UserDefinedFields')
      { 
        If ($Field.IsPickList)
        {
          $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $Parameter.Value}
          $Value = $PickListValue.Value
        }
        Else
        {
          $Value = $Parameter.Value
        }  
        Foreach ($Object in $InputObject) 
        { 
          $Object.$($Parameter.Key) = $Value
        }
      }
    }

    $Caption = $MyInvocation.MyCommand.Name
    $VerboseDescrition = '{0}: About to modify {1} {2}(s). This action cannot be undone.' -F $Caption, $InputObject.Count, $EntityName
    $VerboseWarning = '{0}: About to modify {1} {2}(s). This action cannot be undone. Do you want to continue?' -F $Caption, $InputObject.Count, $EntityName

    If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
  
      # Normalize dates, i.e. set them to CEST. The .Update() method of the API reads all datetime fields as CEST
      # We can safely ignore readonly fields, even if we have modified them previously. The API ignores them.
      $DateTimeParams = $Fields.Where({$_.Type -eq 'datetime' -and -not $_.IsReadOnly}).Name
    
      # Do Picklists more human readable
      $Picklists = $Fields.Where{$_.IsPickList}
    
      # Adjust TimeZone on all DateTime properties
      Foreach ($Object in $InputObject) 
      { 
        Foreach ($DateTimeParam in $DateTimeParams) {
      
          # Get the datetime value
          $Value = $Object.$DateTimeParam
                
          # Skip if parameter is empty
          If (-not ($Value)) {
            Continue
          }
          # Convert the datetime back to CEST
          $Object.$DateTimeParam = $Value.AddHours($script:LocalToEST)
        }
      
        # Revert picklist labels to their values
        Foreach ($Field in $Picklists)
        {
          If ($Object.$($Field.Name) -in $Field.PicklistValues.Label) {
            $Object.$($Field.Name) = ($Field.PickListValues.Where{$_.Label -eq $Object.$($Field.Name)}).Value
          }
        }
      }

      $ModifiedObjects = Set-AtwsData -Entity $InputObject
    
      # Revert changes back on any inputobject
      Foreach ($Object in $InputObject) 
      { 
        Foreach ($DateTimeParam in $DateTimeParams) {
      
          # Get the datetime value
          $Value = $Object.$DateTimeParam
                
          # Skip if parameter is empty
          If (-not ($Value)) {
            Continue
          }
          # Revert the datetime back from CEST
          $Object.$DateTimeParam = $Value.AddHours($script:LocalToEST * -1)
        }
      
        If ($Script:UsePickListLabels) { 
          # Restore picklist labels
          Foreach ($Field in $Picklists)
          {
            If ($Object.$($Field.Name) -in $Field.PicklistValues.Value) {
              $Object.$($Field.Name) = ($Field.PickListValues.Where{$_.Value -eq $Object.$($Field.Name)}).Label
            }
          }
        }
      }
    }
    
  }

  End
  {
    Write-Debug ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $ModifiedObjects.count, $EntityName)
    If ($PassThru.IsPresent) { 
      Return $ModifiedObjects
    }
  }

}
