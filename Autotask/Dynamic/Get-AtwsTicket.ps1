#Requires -Version 4.0
#Version 1.6.2.10
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsTicket
{


<#
.SYNOPSIS
This function get one or more Ticket through the Autotask Web Services API.
.DESCRIPTION
This function creates a query based on any parameters you give and returns any resulting objects from the Autotask Web Services Api. By default the function returns any objects with properties that are Equal (-eq) to the value of the parameter. To give you more flexibility you can modify the operator by using -NotEquals [ParameterName[]], -LessThan [ParameterName[]] and so on.

Possible operators for all parameters are:
 -NotEquals
 -GreaterThan
 -GreaterThanOrEqual
 -LessThan
 -LessThanOrEquals 

Additional operators for [String] parameters are:
 -Like (supports * or % as wildcards)
 -NotLike
 -BeginsWith
 -EndsWith
 -Contains

Properties with picklists are:

IssueType
 

Priority
 

QueueID
 

Source
 

Status
 

SubIssueType
 

ServiceLevelAgreementID
 

TicketType
 

ChangeApprovalBoard
 

ChangeApprovalType
 

ChangeApprovalStatus
 

MonitorTypeID
 

TicketCategory
 

CreatorType
 

LastActivityPersonType
 

CurrentServiceThermometerRating
 

PreviousServiceThermometerRating
 

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
[Autotask.Ticket[]]. This function outputs the Autotask.Ticket that was returned by the API.
.EXAMPLE
Get-AtwsTicket -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsTicket -TicketName SomeName
Returns the object with TicketName 'SomeName', if any.
 .EXAMPLE
Get-AtwsTicket -TicketName 'Some Name'
Returns the object with TicketName 'Some Name', if any.
 .EXAMPLE
Get-AtwsTicket -TicketName 'Some Name' -NotEquals TicketName
Returns any objects with a TicketName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsTicket -TicketName SomeName* -Like TicketName
Returns any object with a TicketName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsTicket -TicketName SomeName* -NotLike TicketName
Returns any object with a TicketName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsTicket -IssueType <PickList Label>
Returns any Tickets with property IssueType equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsTicket -IssueType <PickList Label> -NotEquals IssueType 
Returns any Tickets with property IssueType NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsTicket -IssueType <PickList Label1>, <PickList Label2>
Returns any Tickets with property IssueType equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsTicket -IssueType <PickList Label1>, <PickList Label2> -NotEquals IssueType
Returns any Tickets with property IssueType NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsTicket -Id 1234 -TicketName SomeName* -IssueType <PickList Label1>, <PickList Label2> -Like TicketName -NotEquals IssueType -GreaterThan Id
An example of a more complex query. This command returns any Tickets with Id GREATER THAN 1234, a TicketName that matches the simple pattern SomeName* AND that has a IssueType that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsTicket
 .LINK
Set-AtwsTicket

#>

  [CmdLetBinding(DefaultParameterSetName='Filter', ConfirmImpact='None')]
  Param
  (
# A filter that limits the number of objects that is returned from the API
    [Parameter(
      Mandatory = $true,
      ValueFromRemainingArguments = $true,
      ParameterSetName = 'Filter'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $Filter,

# Follow this external ID and return any external objects
    [Parameter(
      ParameterSetName = 'Filter'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Alias('GetRef')]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('AccountID', 'AccountPhysicalLocationID', 'AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'BusinessDivisionSubdivisionID', 'CompletedByResourceID', 'ContactID', 'ContractID', 'ContractServiceBundleID', 'ContractServiceID', 'CreatorResourceID', 'InstalledProductID', 'LastActivityResourceID', 'OpportunityId', 'ProblemTicketId', 'ProjectID')]
    [String]
    $GetReferenceEntityById,

# Return entities of selected type that are referencing to this entity.
    [Parameter(
      ParameterSetName = 'Filter'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Alias('External')]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('AccountToDo:TicketID', 'BillingItem:TicketID', 'ChangeRequestLink:ChangeRequestTicketID', 'ChangeRequestLink:ProblemOrIncidentTicketID', 'ExpenseItem:TicketID', 'NotificationHistory:TicketID', 'PurchaseOrderItem:TicketID', 'ServiceCallTicket:TicketID', 'ServiceLevelAgreementResults:TicketID', 'SurveyResults:TicketID', 'Ticket:ProblemTicketId', 'TicketAdditionalContact:TicketID', 'TicketAdditionalInstalledProduct:TicketID', 'TicketChangeRequestApproval:TicketID', 'TicketChecklistItem:TicketID', 'TicketChecklistLibrary:TicketID', 'TicketCost:TicketID', 'TicketHistory:TicketID', 'TicketNote:TicketID', 'TicketSecondaryResource:TicketID', 'TimeEntry:TicketID')]
    [String]
    $GetExternalEntityByThisEntityId,

# Return all objects in one query
    [Parameter(
      ParameterSetName = 'Get_all'
    )]
    [Switch]
    $All,

# Do not add descriptions for all picklist attributes with values
    [Parameter(
      ParameterSetName = 'Filter'
    )]
    [Parameter(
      ParameterSetName = 'Get_all'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Switch]
    $NoPickListLabel,

# A single user defined field can be used pr query
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Alias('UDF')]
    [ValidateNotNullOrEmpty()]
    [Autotask.UserDefinedField]
    $UserDefinedField,

# Client
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int[]]
    $AccountID,

# Allocation Code Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $AllocationCodeID,

# Resource
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $AssignedResourceID,

# Resource Role Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $AssignedResourceRoleID,

# Ticket Date Completed by Complete Project Wizard
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime[]]
    $CompletedDate,

# Ticket Contact
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $ContactID,

# Contract
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $ContractID,

# Ticket Creation Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime[]]
    $CreateDate,

# Ticket Creator
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $CreatorResourceID,

# Ticket Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,8000)]
    [string[]]
    $Description,

# Ticket End Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime[]]
    $DueDateTime,

# Ticket Estimated Hours
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double[]]
    $EstimatedHours,

# Ticket External ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string[]]
    $ExternalID,

# Ticket ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [long[]]
    $id,

# Configuration Item
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $InstalledProductID,

# Ticket Issue
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $IssueType,

# Ticket Last Activity Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime[]]
    $LastActivityDate,

# Ticket Priority
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $Priority,

# Ticket Department Name OR Ticket Queue Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $QueueID,

# Ticket Source
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $Source,

# Ticket Status
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $Status,

# Ticket Subissue Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $SubIssueType,

# Ticket Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string[]]
    $TicketNumber,

# Ticket Title
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1,255)]
    [string[]]
    $Title,

# First Response Date Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime[]]
    $FirstResponseDateTime,

# Resolution Plan Date Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime[]]
    $ResolutionPlanDateTime,

# Resolved Date Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime[]]
    $ResolvedDateTime,

# First Response Due Date Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime[]]
    $FirstResponseDueDateTime,

# Resolution Plan Due Date Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime[]]
    $ResolutionPlanDueDateTime,

# Resolved Due Date Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime[]]
    $ResolvedDueDateTime,

# Service Level Agreement ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $ServiceLevelAgreementID,

# Has Met SLA
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean[]]
    $ServiceLevelAgreementHasBeenMet,

# Resolution
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,32000)]
    [string[]]
    $Resolution,

# purchase_order_number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string[]]
    $PurchaseOrderNumber,

# Ticket Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $TicketType,

# Problem Ticket ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $ProblemTicketId,

# Opportunity ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $OpportunityId,

# Change Approval Board ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $ChangeApprovalBoard,

# Change Approval Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $ChangeApprovalType,

# Change Approval Status
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $ChangeApprovalStatus,

# Change Info Field 1
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,8000)]
    [string[]]
    $ChangeInfoField1,

# Change Info Field 2
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,8000)]
    [string[]]
    $ChangeInfoField2,

# Change Info Field 3
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,8000)]
    [string[]]
    $ChangeInfoField3,

# Change Info Field 4
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,8000)]
    [string[]]
    $ChangeInfoField4,

# Change Info Field 5
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,8000)]
    [string[]]
    $ChangeInfoField5,

# Last Customer Notification
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime[]]
    $LastCustomerNotificationDateTime,

# Last Customer Visible Activity
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime[]]
    $LastCustomerVisibleActivityDateTime,

# Contract Service ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long[]]
    $ContractServiceID,

# Contract Service Bundle ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long[]]
    $ContractServiceBundleID,

# Monitor Type ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $MonitorTypeID,

# Monitor ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $MonitorID,

# AEM Alert ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string[]]
    $AEMAlertID,

# Hours to be Scheduled
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double[]]
    $HoursToBeScheduled,

# Ticket Category
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $TicketCategory,

# First Response Initiating Resource
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $FirstResponseInitiatingResourceID,

# First Response Assigned Resource
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $FirstResponseAssignedResourceID,

# Project ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $ProjectID,

# Business Division Subdivision ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $BusinessDivisionSubdivisionID,

# Ticket Completed By
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $CompletedByResourceID,

# Account Physical Location
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $AccountPhysicalLocationID,

# Last Edited Resource ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $LastActivityResourceID,

# Current Service Thermometer Rating
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $CurrentServiceThermometerRating,

# Previous Service Thermometer Rating
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $PreviousServiceThermometerRating,

# Service Thermometer Temperature
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $ServiceThermometerTemperature,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'CompletedDate', 'ContactID', 'ContractID', 'CreateDate', 'CreatorResourceID', 'Description', 'DueDateTime', 'EstimatedHours', 'ExternalID', 'id', 'InstalledProductID', 'IssueType', 'LastActivityDate', 'Priority', 'QueueID', 'Source', 'Status', 'SubIssueType', 'TicketNumber', 'Title', 'FirstResponseDateTime', 'ResolutionPlanDateTime', 'ResolvedDateTime', 'FirstResponseDueDateTime', 'ResolutionPlanDueDateTime', 'ResolvedDueDateTime', 'ServiceLevelAgreementID', 'ServiceLevelAgreementHasBeenMet', 'Resolution', 'PurchaseOrderNumber', 'TicketType', 'ProblemTicketId', 'OpportunityId', 'ChangeApprovalBoard', 'ChangeApprovalType', 'ChangeApprovalStatus', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'LastCustomerNotificationDateTime', 'LastCustomerVisibleActivityDateTime', 'ContractServiceID', 'ContractServiceBundleID', 'MonitorTypeID', 'MonitorID', 'AEMAlertID', 'HoursToBeScheduled', 'TicketCategory', 'FirstResponseInitiatingResourceID', 'FirstResponseAssignedResourceID', 'ProjectID', 'BusinessDivisionSubdivisionID', 'CompletedByResourceID', 'AccountPhysicalLocationID', 'LastActivityResourceID', 'CurrentServiceThermometerRating', 'PreviousServiceThermometerRating', 'ServiceThermometerTemperature', 'UserDefinedField')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'CompletedDate', 'ContactID', 'ContractID', 'CreateDate', 'CreatorResourceID', 'Description', 'DueDateTime', 'EstimatedHours', 'ExternalID', 'id', 'InstalledProductID', 'IssueType', 'LastActivityDate', 'Priority', 'QueueID', 'Source', 'Status', 'SubIssueType', 'TicketNumber', 'Title', 'FirstResponseDateTime', 'ResolutionPlanDateTime', 'ResolvedDateTime', 'FirstResponseDueDateTime', 'ResolutionPlanDueDateTime', 'ResolvedDueDateTime', 'ServiceLevelAgreementID', 'ServiceLevelAgreementHasBeenMet', 'Resolution', 'PurchaseOrderNumber', 'TicketType', 'ProblemTicketId', 'OpportunityId', 'ChangeApprovalBoard', 'ChangeApprovalType', 'ChangeApprovalStatus', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'LastCustomerNotificationDateTime', 'LastCustomerVisibleActivityDateTime', 'ContractServiceID', 'ContractServiceBundleID', 'MonitorTypeID', 'MonitorID', 'AEMAlertID', 'HoursToBeScheduled', 'TicketCategory', 'FirstResponseInitiatingResourceID', 'FirstResponseAssignedResourceID', 'ProjectID', 'BusinessDivisionSubdivisionID', 'CompletedByResourceID', 'AccountPhysicalLocationID', 'LastActivityResourceID', 'CurrentServiceThermometerRating', 'PreviousServiceThermometerRating', 'ServiceThermometerTemperature', 'UserDefinedField')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'CompletedDate', 'ContactID', 'ContractID', 'CreateDate', 'CreatorResourceID', 'Description', 'DueDateTime', 'EstimatedHours', 'ExternalID', 'id', 'InstalledProductID', 'IssueType', 'LastActivityDate', 'Priority', 'QueueID', 'Source', 'Status', 'SubIssueType', 'TicketNumber', 'Title', 'FirstResponseDateTime', 'ResolutionPlanDateTime', 'ResolvedDateTime', 'FirstResponseDueDateTime', 'ResolutionPlanDueDateTime', 'ResolvedDueDateTime', 'ServiceLevelAgreementID', 'ServiceLevelAgreementHasBeenMet', 'Resolution', 'PurchaseOrderNumber', 'TicketType', 'ProblemTicketId', 'OpportunityId', 'ChangeApprovalBoard', 'ChangeApprovalType', 'ChangeApprovalStatus', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'LastCustomerNotificationDateTime', 'LastCustomerVisibleActivityDateTime', 'ContractServiceID', 'ContractServiceBundleID', 'MonitorTypeID', 'MonitorID', 'AEMAlertID', 'HoursToBeScheduled', 'TicketCategory', 'FirstResponseInitiatingResourceID', 'FirstResponseAssignedResourceID', 'ProjectID', 'BusinessDivisionSubdivisionID', 'CompletedByResourceID', 'AccountPhysicalLocationID', 'LastActivityResourceID', 'CurrentServiceThermometerRating', 'PreviousServiceThermometerRating', 'ServiceThermometerTemperature', 'UserDefinedField')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'CompletedDate', 'ContactID', 'ContractID', 'CreateDate', 'CreatorResourceID', 'Description', 'DueDateTime', 'EstimatedHours', 'ExternalID', 'id', 'InstalledProductID', 'IssueType', 'LastActivityDate', 'Priority', 'QueueID', 'Source', 'Status', 'SubIssueType', 'TicketNumber', 'Title', 'FirstResponseDateTime', 'ResolutionPlanDateTime', 'ResolvedDateTime', 'FirstResponseDueDateTime', 'ResolutionPlanDueDateTime', 'ResolvedDueDateTime', 'ServiceLevelAgreementID', 'Resolution', 'PurchaseOrderNumber', 'TicketType', 'ProblemTicketId', 'OpportunityId', 'ChangeApprovalBoard', 'ChangeApprovalType', 'ChangeApprovalStatus', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'LastCustomerNotificationDateTime', 'LastCustomerVisibleActivityDateTime', 'ContractServiceID', 'ContractServiceBundleID', 'MonitorTypeID', 'MonitorID', 'AEMAlertID', 'HoursToBeScheduled', 'TicketCategory', 'FirstResponseInitiatingResourceID', 'FirstResponseAssignedResourceID', 'ProjectID', 'BusinessDivisionSubdivisionID', 'CompletedByResourceID', 'AccountPhysicalLocationID', 'LastActivityResourceID', 'CurrentServiceThermometerRating', 'PreviousServiceThermometerRating', 'ServiceThermometerTemperature', 'UserDefinedField')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'CompletedDate', 'ContactID', 'ContractID', 'CreateDate', 'CreatorResourceID', 'Description', 'DueDateTime', 'EstimatedHours', 'ExternalID', 'id', 'InstalledProductID', 'IssueType', 'LastActivityDate', 'Priority', 'QueueID', 'Source', 'Status', 'SubIssueType', 'TicketNumber', 'Title', 'FirstResponseDateTime', 'ResolutionPlanDateTime', 'ResolvedDateTime', 'FirstResponseDueDateTime', 'ResolutionPlanDueDateTime', 'ResolvedDueDateTime', 'ServiceLevelAgreementID', 'Resolution', 'PurchaseOrderNumber', 'TicketType', 'ProblemTicketId', 'OpportunityId', 'ChangeApprovalBoard', 'ChangeApprovalType', 'ChangeApprovalStatus', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'LastCustomerNotificationDateTime', 'LastCustomerVisibleActivityDateTime', 'ContractServiceID', 'ContractServiceBundleID', 'MonitorTypeID', 'MonitorID', 'AEMAlertID', 'HoursToBeScheduled', 'TicketCategory', 'FirstResponseInitiatingResourceID', 'FirstResponseAssignedResourceID', 'ProjectID', 'BusinessDivisionSubdivisionID', 'CompletedByResourceID', 'AccountPhysicalLocationID', 'LastActivityResourceID', 'CurrentServiceThermometerRating', 'PreviousServiceThermometerRating', 'ServiceThermometerTemperature', 'UserDefinedField')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'CompletedDate', 'ContactID', 'ContractID', 'CreateDate', 'CreatorResourceID', 'Description', 'DueDateTime', 'EstimatedHours', 'ExternalID', 'id', 'InstalledProductID', 'IssueType', 'LastActivityDate', 'Priority', 'QueueID', 'Source', 'Status', 'SubIssueType', 'TicketNumber', 'Title', 'FirstResponseDateTime', 'ResolutionPlanDateTime', 'ResolvedDateTime', 'FirstResponseDueDateTime', 'ResolutionPlanDueDateTime', 'ResolvedDueDateTime', 'ServiceLevelAgreementID', 'Resolution', 'PurchaseOrderNumber', 'TicketType', 'ProblemTicketId', 'OpportunityId', 'ChangeApprovalBoard', 'ChangeApprovalType', 'ChangeApprovalStatus', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'LastCustomerNotificationDateTime', 'LastCustomerVisibleActivityDateTime', 'ContractServiceID', 'ContractServiceBundleID', 'MonitorTypeID', 'MonitorID', 'AEMAlertID', 'HoursToBeScheduled', 'TicketCategory', 'FirstResponseInitiatingResourceID', 'FirstResponseAssignedResourceID', 'ProjectID', 'BusinessDivisionSubdivisionID', 'CompletedByResourceID', 'AccountPhysicalLocationID', 'LastActivityResourceID', 'CurrentServiceThermometerRating', 'PreviousServiceThermometerRating', 'ServiceThermometerTemperature', 'UserDefinedField')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'CompletedDate', 'ContactID', 'ContractID', 'CreateDate', 'CreatorResourceID', 'Description', 'DueDateTime', 'EstimatedHours', 'ExternalID', 'id', 'InstalledProductID', 'IssueType', 'LastActivityDate', 'Priority', 'QueueID', 'Source', 'Status', 'SubIssueType', 'TicketNumber', 'Title', 'FirstResponseDateTime', 'ResolutionPlanDateTime', 'ResolvedDateTime', 'FirstResponseDueDateTime', 'ResolutionPlanDueDateTime', 'ResolvedDueDateTime', 'ServiceLevelAgreementID', 'Resolution', 'PurchaseOrderNumber', 'TicketType', 'ProblemTicketId', 'OpportunityId', 'ChangeApprovalBoard', 'ChangeApprovalType', 'ChangeApprovalStatus', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'LastCustomerNotificationDateTime', 'LastCustomerVisibleActivityDateTime', 'ContractServiceID', 'ContractServiceBundleID', 'MonitorTypeID', 'MonitorID', 'AEMAlertID', 'HoursToBeScheduled', 'TicketCategory', 'FirstResponseInitiatingResourceID', 'FirstResponseAssignedResourceID', 'ProjectID', 'BusinessDivisionSubdivisionID', 'CompletedByResourceID', 'AccountPhysicalLocationID', 'LastActivityResourceID', 'CurrentServiceThermometerRating', 'PreviousServiceThermometerRating', 'ServiceThermometerTemperature', 'UserDefinedField')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'ExternalID', 'TicketNumber', 'Title', 'Resolution', 'PurchaseOrderNumber', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'AEMAlertID', 'UserDefinedField')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'ExternalID', 'TicketNumber', 'Title', 'Resolution', 'PurchaseOrderNumber', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'AEMAlertID', 'UserDefinedField')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'ExternalID', 'TicketNumber', 'Title', 'Resolution', 'PurchaseOrderNumber', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'AEMAlertID', 'UserDefinedField')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'ExternalID', 'TicketNumber', 'Title', 'Resolution', 'PurchaseOrderNumber', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'AEMAlertID', 'UserDefinedField')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'ExternalID', 'TicketNumber', 'Title', 'Resolution', 'PurchaseOrderNumber', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'AEMAlertID', 'UserDefinedField')]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('CompletedDate', 'CreateDate', 'DueDateTime', 'LastActivityDate', 'FirstResponseDateTime', 'ResolutionPlanDateTime', 'ResolvedDateTime', 'FirstResponseDueDateTime', 'ResolutionPlanDueDateTime', 'ResolvedDueDateTime', 'LastCustomerNotificationDateTime', 'LastCustomerVisibleActivityDateTime', 'UserDefinedField')]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'Ticket'
    
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
  }


  Process
  {
    If ($PSCmdlet.ParameterSetName -eq 'Get_all')
    { 
      $Filter = @('id', '-ge', 0)
    }
    ElseIf (-not ($Filter)) {
    
      Write-Debug ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)
      
      # Convert named parameters to a filter definition that can be parsed to QueryXML
      $Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $EntityName
    }
    Else {
      
      Write-Debug ('{0}: Query based on manual filter, parsing' -F $MyInvocation.MyCommand.Name)
              
      $Filter = . Update-AtwsFilter -FilterString $Filter
    } 

    $Result = Get-AtwsData -Entity $EntityName -Filter $Filter

    Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $Result.Count)
    
    # Datetimeparameters
    $Fields = Get-AtwsFieldInfo -Entity $EntityName
    
    # Should we return an indirect object?
    if ( ($Result) -and ($GetReferenceEntityById))
    {
      Write-Debug ('{0}: User has asked for external reference objects by {1}' -F $MyInvocation.MyCommand.Name, $GetReferenceEntityById)
      
      $Field = $Fields.Where({$_.Name -eq $GetReferenceEntityById})
      $ResultValues = $Result | Where-Object {$null -ne $_.$GetReferenceEntityById}
      If ($ResultValues.Count -lt $Result.Count)
      {
        Write-Warning ('{0}: Only {1} of the {2}s in the primary query had a value in the property {3}.' -F $MyInvocation.MyCommand.Name, 
          $ResultValues.Count,
          $EntityName,
        $GetReferenceEntityById) -WarningAction Continue
      }
      $Filter = 'id -eq {0}' -F $($ResultValues.$GetReferenceEntityById -join ' -or id -eq ')
      $Result = Get-Atwsdata -Entity $Field.ReferenceEntityType -Filter $Filter
    }
    ElseIf ( ($Result) -and ($GetExternalEntityByThisEntityId))
    {
      Write-Debug ('{0}: User has asked for {1} that are referencing this result' -F $MyInvocation.MyCommand.Name, $GetExternalEntityByThisEntityId)
      $ReferenceInfo = $GetExternalEntityByThisEntityId -Split ':'
      $Filter = '{0} -eq {1}' -F $ReferenceInfo[1], $($Result.id -join (' -or {0}id -eq ' -F $ReferenceInfo[1]))
      $Result = Get-Atwsdata -Entity $ReferenceInfo[0] -Filter $Filter
     }
    # Do the user want labels along with index values for Picklists?
    ElseIf ( ($Result) -and -not ($NoPickListLabel))
    {
      Foreach ($Field in $Fields.Where{$_.IsPickList})
      {
        $FieldName = '{0}Label' -F $Field.Name
        Foreach ($Item in $Result)
        {
          $Value = ($Field.PickListValues.Where{$_.Value -eq $Item.$($Field.Name)}).Label
          Add-Member -InputObject $Item -MemberType NoteProperty -Name $FieldName -Value $Value -Force
          
        }
      }
    }
  }

  End
  {
    Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    If ($Result)
    {
      Return $Result
    }
  }


}
