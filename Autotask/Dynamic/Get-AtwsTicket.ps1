#Requires -Version 4.0
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
    [ValidateSet('AccountID', 'AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'ContactID', 'ContractID', 'CreatorResourceID', 'InstalledProductID', 'ProblemTicketId', 'OpportunityId', 'ContractServiceID', 'ContractServiceBundleID', 'ProjectID', 'BusinessDivisionSubdivisionID', 'CompletedByResourceID', 'AccountPhysicalLocationID', 'LastActivityResourceID')]
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
    [ValidateSet('NotificationHistory:TicketID', 'ServiceCallTicket:TicketID', 'BillingItem:TicketID', 'TicketCost:TicketID', 'TicketChecklistItem:TicketID', 'TicketSecondaryResource:TicketID', 'Ticket:ProblemTicketId', 'TicketAdditionalContact:TicketID', 'ServiceLevelAgreementResults:TicketID', 'ExpenseItem:TicketID', 'TicketNote:TicketID', 'TicketChangeRequestApproval:TicketID', 'TicketHistory:TicketID', 'TicketAdditionalInstalledProduct:TicketID', 'ChangeRequestLink:ChangeRequestTicketID', 'ChangeRequestLink:ProblemOrIncidentTicketID', 'TimeEntry:TicketID', 'PurchaseOrderItem:TicketID', 'SurveyResults:TicketID', 'AccountToDo:TicketID')]
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
    [Int[]]
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
    [Int[]]
    $Priority,

# Ticket Department Name OR Ticket Queue Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $QueueID,

# Ticket Source
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $Source,

# Ticket Status
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int[]]
    $Status,

# Ticket Subissue Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
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
    [Int[]]
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
    [Int[]]
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
    [Int[]]
    $ChangeApprovalBoard,

# Change Approval Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $ChangeApprovalType,

# Change Approval Status
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
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
    [Int[]]
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
    [Int[]]
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
    [Int[]]
    $CurrentServiceThermometerRating,

# Previous Service Thermometer Rating
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
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
              
      # $Filter is usually passed as a flat string. Convert it to an array.
      If ($Filter.Count -eq 1 -and $Filter -match ' ' )
      { 
        # First, make sure it is a single string and replace parenthesis with our special operator
        $Filter = $Filter -join ' ' -replace '\(',' -begin ' -replace '\)', ' -end '
    
        # Removing double possible spaces we may have introduced
        Do {$Filter = $Filter -replace '  ',' '}
        While ($Filter -match '  ')

        # Split back in to array, respecting quotes
        $Words = $Filter.Trim().Split(' ')
        [String[]]$Filter = @()
        $Temp = @()
        Foreach ($Word in $Words)
        {
          If ($Temp.Count -eq 0 -and $Word -match '^[\"\'']')
          {
            $Temp += $Word.TrimStart('"''')
          }
          ElseIf ($Temp.Count -gt 0 -and $Word -match "[\'\""]$")
          {
            $Temp += $Word.TrimEnd("'""")
            $Filter += $Temp -join ' '
            $Temp = @()
          }
          ElseIf ($Temp.Count -gt 0)
          {
            $Temp += $Word
          }
          Else
          {
            $Filter += $Word
          }
        }
      }
      
      Write-Debug ('{0}: Checking query for variables that have survived as string' -F $MyInvocation.MyCommand.Name)
      
      $NewFilter = @()
      Foreach ($Word in $Filter)
      {
        $Value = $Word
        # Is it a variable name?
        If ($Word -match '^\$\{?(\w+:)?(\w+)\}?(\.\w[\.\w]+)?$')
        {
          # If present, first group is SCOPE. In the context of this function, the only possible scope
          # is Global; Script = the module, local is internal to this function.
          $Scope = 'Global' # or numbered scope 2
        
          # The variable name MUST be present
          $VariableName = $Matches[2]

          # A property tail CAN be present
          $PropertyTail = $Matches[3]
        
          # Check that the variable exists
          $Variable = Try
          { Get-Variable -Name $VariableName -Scope $Scope -ValueOnly -ErrorAction Stop }
          Catch
          {
            Write-Error ('{0}: Could not find any variable called ${1}. Is it misspelled or has it not been set yet?' -f $MyInvocation.MyCommand.Name, $VariableName)
            # Force stop of calling script, because this will completely break the query
            Return
          }

          # Test if the variable "Variable" has been set
          If (Test-Path Variable:Variable) {
            Write-Debug ('{0}: Substituting {1} for its value' -F $MyInvocation.MyCommand.Name, $Word)
            If ($PropertyTail) {
              # Add properties back 
              $Expression = '$Variable{0}' -F $PropertyTail
  
              # Invoke-Expression is considered risky from an SQL injection kind of perspective. But by only
              # permitting a .dot separated string of [a-zA-Z0-9_] we are PROBABLY safe...
              $Value = Invoke-Expression -Command $Expression
            }
            Else {
              $Value = $Variable
            }
            If ($Value -eq $Null) {
              Write-Error ('{0}: Could not find any variable called {1}. Is it misspelled or has it not been set yet?' -F $MyInvocation.MyCommand.Name, $Expression)
              # Force stop of calling script, because this will completely break the query
              Return
            }
            Else { 
              # Normalize dates. Important to avoid QueryXML problems
              If ($Value.GetType().Name -eq 'DateTime')
              {[String]$Value = ConvertTo-AtwsDate -ParameterName $NewFilter[-2] -DateTime $Value}
            }
          }
        }
        $NewFilter += $Value
      }
    } 

    $Result = Get-AtwsData -Entity $EntityName -Filter $Filter

    Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $Result.Count)
    
    # Datetimeparameters
    $DateTimeParams = $Fields.Where({$_.Type -eq 'datetime'}).Name
    
    # Expand UDFs by default
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
          Add-Member -InputObject $Item -MemberType NoteProperty -Name $UDFName -Value $UDF.Value
        }  
      }
      
      # Adjust TimeZone on all DateTime properties
      Foreach ($DateTimeParam in $DateTimeParams) {
      
        # Get the datetime value
        $ParameterValue = $Item.$DateTimeParam
                
        # Skip if parameter is empty
        If (-not ($ParameterValue)) {
          Continue
        }
        
        $TimePresent = $ParameterValue.Hour -gt 0 -or $ParameterValue.Minute -gt 0 -or $ParameterValue.Second -gt 0 -or $ParameterValue.Millisecond -gt 0 
                
        # If this is a DATE it should not be touched
        If ($DateTimeParam -like "*DateTime" -or $TimePresent) {

          # This is DATETIME 
          # We need to adjust the timezone difference 

          # Yes, you really have to ADD the difference
          $ParameterValue = $ParameterValue.AddHours($script:ESToffset)
            
          # Store the value back to the object (not the API!)
          $Item.$DateTimeParam = $ParameterValue
        }
      }
    }
    
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
