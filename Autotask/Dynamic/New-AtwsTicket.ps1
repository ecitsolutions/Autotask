#Requires -Version 4.0
#Version 1.6.2.11
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function New-AtwsTicket
{


<#
.SYNOPSIS
This function creates a new Ticket through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.Ticket] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the Ticket with Id number 0 you could write 'New-AtwsTicket -Id 0' or you could write 'New-AtwsTicket -Filter {Id -eq 0}.

'New-AtwsTicket -Id 0,4' could be written as 'New-AtwsTicket -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new Ticket you need the following required fields:
 -AccountID
 -DueDateTime
 -Priority
 -Status
 -Title

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
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Ticket]. This function outputs the Autotask.Ticket that was created by the API.
.EXAMPLE
$Result = New-AtwsTicket -AccountID [Value] -DueDateTime [Value] -Priority [Value] -Status [Value] -Title [Value]
Creates a new [Autotask.Ticket] through the Web Services API and returns the new object.
 .EXAMPLE
$Result = Get-AtwsTicket -Id 124 | New-AtwsTicket 
Copies [Autotask.Ticket] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsTicket -Id 124 | New-AtwsTicket | Set-AtwsTicket -ParameterName <Parameter Value>
Copies [Autotask.Ticket] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsTicket to modify the object.
 .EXAMPLE
$Result = Get-AtwsTicket -Id 124 | New-AtwsTicket | Set-AtwsTicket -ParameterName <Parameter Value> -Passthru
Copies [Autotask.Ticket] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsTicket to modify the object and returns the new object.

.LINK
Get-AtwsTicket
 .LINK
Set-AtwsTicket

#>

  [CmdLetBinding(DefaultParameterSetName='By_parameters', ConfirmImpact='Low')]
  Param
  (
# An array of objects to create
    [Parameter(
      ParameterSetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.Ticket[]]
    $InputObject,

# User defined fields already setup i Autotask
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Alias('UDF')]
    [ValidateNotNullOrEmpty()]
    [Autotask.UserDefinedField[]]
    $UserDefinedFields,

# Client
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $AccountID,

# Allocation Code Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $AllocationCodeID,

# Resource
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $AssignedResourceID,

# Resource Role Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $AssignedResourceRoleID,

# Ticket Date Completed by Complete Project Wizard
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $CompletedDate,

# Ticket Contact
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $ContactID,

# Contract
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $ContractID,

# Ticket Creation Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $CreateDate,

# Ticket Creator
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $CreatorResourceID,

# Ticket Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,8000)]
    [string]
    $Description,

# Ticket End Date
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $DueDateTime,

# Ticket Estimated Hours
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $EstimatedHours,

# Ticket External ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string]
    $ExternalID,

# Configuration Item
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $InstalledProductID,

# Ticket Issue
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $IssueType,

# Ticket Last Activity Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $LastActivityDate,

# Ticket Priority
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String]
    $Priority,

# Ticket Department Name OR Ticket Queue Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $QueueID,

# Ticket Source
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $Source,

# Ticket Status
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String]
    $Status,

# Ticket Subissue Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $SubIssueType,

# Ticket Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string]
    $TicketNumber,

# Ticket Title
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1,255)]
    [string]
    $Title,

# First Response Date Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $FirstResponseDateTime,

# Resolution Plan Date Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $ResolutionPlanDateTime,

# Resolved Date Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $ResolvedDateTime,

# First Response Due Date Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $FirstResponseDueDateTime,

# Resolution Plan Due Date Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $ResolutionPlanDueDateTime,

# Resolved Due Date Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $ResolvedDueDateTime,

# Service Level Agreement ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $ServiceLevelAgreementID,

# Has Met SLA
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean]
    $ServiceLevelAgreementHasBeenMet,

# Resolution
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,32000)]
    [string]
    $Resolution,

# purchase_order_number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string]
    $PurchaseOrderNumber,

# Ticket Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $TicketType,

# Problem Ticket ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $ProblemTicketId,

# Opportunity ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $OpportunityId,

# Change Approval Board ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $ChangeApprovalBoard,

# Change Approval Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $ChangeApprovalType,

# Change Approval Status
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $ChangeApprovalStatus,

# Change Info Field 1
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,8000)]
    [string]
    $ChangeInfoField1,

# Change Info Field 2
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,8000)]
    [string]
    $ChangeInfoField2,

# Change Info Field 3
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,8000)]
    [string]
    $ChangeInfoField3,

# Change Info Field 4
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,8000)]
    [string]
    $ChangeInfoField4,

# Change Info Field 5
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,8000)]
    [string]
    $ChangeInfoField5,

# Last Customer Notification
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $LastCustomerNotificationDateTime,

# Last Customer Visible Activity
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $LastCustomerVisibleActivityDateTime,

# Contract Service ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long]
    $ContractServiceID,

# Contract Service Bundle ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long]
    $ContractServiceBundleID,

# Monitor Type ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $MonitorTypeID,

# Monitor ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $MonitorID,

# AEM Alert ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string]
    $AEMAlertID,

# Hours to be Scheduled
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $HoursToBeScheduled,

# Ticket Category
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $TicketCategory,

# First Response Initiating Resource
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $FirstResponseInitiatingResourceID,

# First Response Assigned Resource
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $FirstResponseAssignedResourceID,

# Project ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $ProjectID,

# Business Division Subdivision ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $BusinessDivisionSubdivisionID,

# Creator Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $CreatorType,

# Ticket Completed By
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $CompletedByResourceID,

# Account Physical Location
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $AccountPhysicalLocationID,

# Last Activity Person Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $LastActivityPersonType,

# Last Edited Resource ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $LastActivityResourceID,

# Next Service Level Agreement Event in Hours
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $ServiceLevelAgreementPausedNextEventHours,

# Current Service Thermometer Rating
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $CurrentServiceThermometerRating,

# Previous Service Thermometer Rating
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $PreviousServiceThermometerRating,

# Service Thermometer Temperature
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $ServiceThermometerTemperature
  )
 
  Begin
  { 
    $EntityName = 'Ticket'
           
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
    $ProcessObject = @()
  }

  Process
  {
    $Fields = Get-AtwsFieldInfo -Entity $EntityName
    
    If ($InputObject)
    {
      Write-Verbose ('{0}: Copy Object mode: Setting ID property to zero' -F $MyInvocation.MyCommand.Name)  
      
      $CopyNo = 1

      Foreach ($Object in $InputObject) 
      { 
        # Create a new object and copy properties
        $NewObject = New-Object Autotask.$EntityName
        
        # Copy every non readonly property
        $FieldNames = $Fields.Where({$_.Name -ne 'id'}).Name
        If ($PSBoundParameters.ContainsKey('UserDefinedFields')) {
          $FieldNames += 'UserDefinedFields'
        }
        Foreach ($Field in $FieldNames)
        {
          $NewObject.$Field = $Object.$Field
        }
        If ($NewObject -is [Autotask.Ticket])
        {
          Write-Verbose ('{0}: Copy Object mode: Object is a Ticket. Title must be modified to avoid duplicate detection.' -F $MyInvocation.MyCommand.Name)  
          $Title = '{0} (Copy {1})' -F $NewObject.Title, $CopyNo
          $CopyNo++
          $NewObject.Title = $Title
        }
        $ProcessObject += $NewObject
      }   
    }
    Else
    {
      Write-Debug ('{0}: Creating empty [Autotask.{1}]' -F $MyInvocation.MyCommand.Name, $EntityName) 
      $ProcessObject += New-Object Autotask.$EntityName    
    }
    
    Foreach ($Parameter in $PSBoundParameters.GetEnumerator())
    {
      $Field = $Fields | Where-Object {$_.Name -eq $Parameter.Key}
      If ($Field -or $Parameter.Key -eq 'UserDefinedFields')
      { 
        If ($Field.IsPickList)
        {
          If($Field.PickListParentValueField)
          {
            $ParentField = $Fields.Where{$_.Name -eq $Field.PickListParentValueField}
            $ParentLabel = $PSBoundParameters.$($ParentField.Name)
            $ParentValue = $ParentField.PickListValues | Where-Object {$_.Label -eq $ParentLabel}
            $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $Parameter.Value -and $_.ParentValue -eq $ParentValue.Value}                
          }
          Else 
          { 
            $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $Parameter.Value}
          }
          $Value = $PickListValue.Value
        }
        Else
        {
          $Value = $Parameter.Value
        } 

        Foreach ($Object in $ProcessObject) 
        { 
          $Object.$($Parameter.Key) = $Value
        }
      }
    }    

    $Result = New-AtwsData -Entity $ProcessObject
  }

  End
  {
    Write-Debug ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $Result.count, $EntityName)
    Return $Result
  }

}
