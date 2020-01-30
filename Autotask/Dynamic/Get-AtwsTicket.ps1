#Requires -Version 4.0
#Version 1.6.4.1
<#

.COPYRIGHT
Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
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

Additional operators for [string] parameters are:
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
 

ApiVendorID
 

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

  [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName='Filter', ConfirmImpact='None')]
  Param
  (
# A filter that limits the number of objects that is returned from the API
    [Parameter(
      Mandatory = $true,
      ValueFromRemainingArguments = $true,
      ParametersetName = 'Filter'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Filter,

# Follow this external ID and return any external objects
    [Parameter(
      ParametersetName = 'Filter'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('GetRef')]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('AccountID', 'AccountPhysicalLocationID', 'AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'BusinessDivisionSubdivisionID', 'CompletedByResourceID', 'ContactID', 'ContractID', 'ContractServiceBundleID', 'ContractServiceID', 'CreatorResourceID', 'InstalledProductID', 'LastActivityResourceID', 'OpportunityId', 'ProblemTicketId', 'ProjectID')]
    [string]
    $GetReferenceEntityById,

# Return entities of selected type that are referencing to this entity.
    [Parameter(
      ParametersetName = 'Filter'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('External')]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('AccountToDo:TicketID', 'BillingItem:TicketID', 'ChangeRequestLink:ChangeRequestTicketID', 'ChangeRequestLink:ProblemOrIncidentTicketID', 'ExpenseItem:TicketID', 'NotificationHistory:TicketID', 'PurchaseOrderItem:TicketID', 'ServiceCallTicket:TicketID', 'ServiceLevelAgreementResults:TicketID', 'SurveyResults:TicketID', 'Ticket:ProblemTicketId', 'TicketAdditionalContact:TicketID', 'TicketAdditionalInstalledProduct:TicketID', 'TicketChangeRequestApproval:TicketID', 'TicketChecklistItem:TicketID', 'TicketChecklistLibrary:TicketID', 'TicketCost:TicketID', 'TicketHistory:TicketID', 'TicketNote:TicketID', 'TicketSecondaryResource:TicketID', 'TimeEntry:TicketID')]
    [string]
    $GetExternalEntityByThisEntityId,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# Do not add descriptions for all picklist attributes with values
    [Parameter(
      ParametersetName = 'Filter'
    )]
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [switch]
    $NoPickListLabel,

# A single user defined field can be used pr query
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('UDF')]
    [ValidateNotNullOrEmpty()]
    [Autotask.UserDefinedField]
    $UserDefinedField,

# Client
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $AccountID,

# Allocation Code Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $AllocationCodeID,

# Resource
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $AssignedResourceID,

# Resource Role Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $AssignedResourceRoleID,

# Ticket Date Completed by Complete Project Wizard
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CompletedDate,

# Ticket Contact
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ContactID,

# Contract
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ContractID,

# Ticket Creation Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CreateDate,

# Ticket Creator
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CreatorResourceID,

# Ticket Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,8000)]
    [string[]]
    $Description,

# Ticket End Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $DueDateTime,

# Ticket Estimated Hours
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $EstimatedHours,

# Ticket External ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $ExternalID,

# Ticket ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Configuration Item
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $InstalledProductID,

# Ticket Issue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $IssueType,

# Ticket Last Activity Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LastActivityDate,

# Ticket Priority
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Priority,

# Ticket Department Name OR Ticket Queue Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $QueueID,

# Ticket Source
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $Source,

# Ticket Status
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Status,

# Ticket Subissue Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $SubIssueType,

# Ticket Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $TicketNumber,

# Ticket Title
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,255)]
    [string[]]
    $Title,

# First Response Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $FirstResponseDateTime,

# Resolution Plan Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ResolutionPlanDateTime,

# Resolved Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ResolvedDateTime,

# First Response Due Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $FirstResponseDueDateTime,

# Resolution Plan Due Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ResolutionPlanDueDateTime,

# Resolved Due Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ResolvedDueDateTime,

# Service Level Agreement ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $ServiceLevelAgreementID,

# Has Met SLA
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $ServiceLevelAgreementHasBeenMet,

# Resolution
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,32000)]
    [string[]]
    $Resolution,

# purchase_order_number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $PurchaseOrderNumber,

# Ticket Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $TicketType,

# Problem Ticket ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ProblemTicketId,

# Opportunity ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $OpportunityId,

# Change Approval Board ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $ChangeApprovalBoard,

# Change Approval Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $ChangeApprovalType,

# Change Approval Status
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $ChangeApprovalStatus,

# Change Info Field 1
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,8000)]
    [string[]]
    $ChangeInfoField1,

# Change Info Field 2
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,8000)]
    [string[]]
    $ChangeInfoField2,

# Change Info Field 3
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,8000)]
    [string[]]
    $ChangeInfoField3,

# Change Info Field 4
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,8000)]
    [string[]]
    $ChangeInfoField4,

# Change Info Field 5
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,8000)]
    [string[]]
    $ChangeInfoField5,

# Last Customer Notification
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LastCustomerNotificationDateTime,

# Last Customer Visible Activity
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LastCustomerVisibleActivityDateTime,

# Contract Service ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $ContractServiceID,

# Contract Service Bundle ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $ContractServiceBundleID,

# Monitor Type ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $MonitorTypeID,

# Monitor ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $MonitorID,

# AEM Alert ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $AEMAlertID,

# Hours to be Scheduled
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $HoursToBeScheduled,

# Ticket Category
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $TicketCategory,

# First Response Initiating Resource
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $FirstResponseInitiatingResourceID,

# First Response Assigned Resource
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $FirstResponseAssignedResourceID,

# Project ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ProjectID,

# Business Division Subdivision ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BusinessDivisionSubdivisionID,

# Ticket Completed By
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CompletedByResourceID,

# Account Physical Location
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $AccountPhysicalLocationID,

# Last Edited Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $LastActivityResourceID,

# Current Service Thermometer Rating
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $CurrentServiceThermometerRating,

# Previous Service Thermometer Rating
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $PreviousServiceThermometerRating,

# Service Thermometer Temperature
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ServiceThermometerTemperature,

# API Vendor ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $ApiVendorID,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'CompletedDate', 'ContactID', 'ContractID', 'CreateDate', 'CreatorResourceID', 'Description', 'DueDateTime', 'EstimatedHours', 'ExternalID', 'id', 'InstalledProductID', 'IssueType', 'LastActivityDate', 'Priority', 'QueueID', 'Source', 'Status', 'SubIssueType', 'TicketNumber', 'Title', 'FirstResponseDateTime', 'ResolutionPlanDateTime', 'ResolvedDateTime', 'FirstResponseDueDateTime', 'ResolutionPlanDueDateTime', 'ResolvedDueDateTime', 'ServiceLevelAgreementID', 'ServiceLevelAgreementHasBeenMet', 'Resolution', 'PurchaseOrderNumber', 'TicketType', 'ProblemTicketId', 'OpportunityId', 'ChangeApprovalBoard', 'ChangeApprovalType', 'ChangeApprovalStatus', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'LastCustomerNotificationDateTime', 'LastCustomerVisibleActivityDateTime', 'ContractServiceID', 'ContractServiceBundleID', 'MonitorTypeID', 'MonitorID', 'AEMAlertID', 'HoursToBeScheduled', 'TicketCategory', 'FirstResponseInitiatingResourceID', 'FirstResponseAssignedResourceID', 'ProjectID', 'BusinessDivisionSubdivisionID', 'CompletedByResourceID', 'AccountPhysicalLocationID', 'LastActivityResourceID', 'CurrentServiceThermometerRating', 'PreviousServiceThermometerRating', 'ServiceThermometerTemperature', 'ApiVendorID', 'UserDefinedField')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'CompletedDate', 'ContactID', 'ContractID', 'CreateDate', 'CreatorResourceID', 'Description', 'DueDateTime', 'EstimatedHours', 'ExternalID', 'id', 'InstalledProductID', 'IssueType', 'LastActivityDate', 'Priority', 'QueueID', 'Source', 'Status', 'SubIssueType', 'TicketNumber', 'Title', 'FirstResponseDateTime', 'ResolutionPlanDateTime', 'ResolvedDateTime', 'FirstResponseDueDateTime', 'ResolutionPlanDueDateTime', 'ResolvedDueDateTime', 'ServiceLevelAgreementID', 'ServiceLevelAgreementHasBeenMet', 'Resolution', 'PurchaseOrderNumber', 'TicketType', 'ProblemTicketId', 'OpportunityId', 'ChangeApprovalBoard', 'ChangeApprovalType', 'ChangeApprovalStatus', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'LastCustomerNotificationDateTime', 'LastCustomerVisibleActivityDateTime', 'ContractServiceID', 'ContractServiceBundleID', 'MonitorTypeID', 'MonitorID', 'AEMAlertID', 'HoursToBeScheduled', 'TicketCategory', 'FirstResponseInitiatingResourceID', 'FirstResponseAssignedResourceID', 'ProjectID', 'BusinessDivisionSubdivisionID', 'CompletedByResourceID', 'AccountPhysicalLocationID', 'LastActivityResourceID', 'CurrentServiceThermometerRating', 'PreviousServiceThermometerRating', 'ServiceThermometerTemperature', 'ApiVendorID', 'UserDefinedField')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'CompletedDate', 'ContactID', 'ContractID', 'CreateDate', 'CreatorResourceID', 'Description', 'DueDateTime', 'EstimatedHours', 'ExternalID', 'id', 'InstalledProductID', 'IssueType', 'LastActivityDate', 'Priority', 'QueueID', 'Source', 'Status', 'SubIssueType', 'TicketNumber', 'Title', 'FirstResponseDateTime', 'ResolutionPlanDateTime', 'ResolvedDateTime', 'FirstResponseDueDateTime', 'ResolutionPlanDueDateTime', 'ResolvedDueDateTime', 'ServiceLevelAgreementID', 'ServiceLevelAgreementHasBeenMet', 'Resolution', 'PurchaseOrderNumber', 'TicketType', 'ProblemTicketId', 'OpportunityId', 'ChangeApprovalBoard', 'ChangeApprovalType', 'ChangeApprovalStatus', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'LastCustomerNotificationDateTime', 'LastCustomerVisibleActivityDateTime', 'ContractServiceID', 'ContractServiceBundleID', 'MonitorTypeID', 'MonitorID', 'AEMAlertID', 'HoursToBeScheduled', 'TicketCategory', 'FirstResponseInitiatingResourceID', 'FirstResponseAssignedResourceID', 'ProjectID', 'BusinessDivisionSubdivisionID', 'CompletedByResourceID', 'AccountPhysicalLocationID', 'LastActivityResourceID', 'CurrentServiceThermometerRating', 'PreviousServiceThermometerRating', 'ServiceThermometerTemperature', 'ApiVendorID', 'UserDefinedField')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'CompletedDate', 'ContactID', 'ContractID', 'CreateDate', 'CreatorResourceID', 'Description', 'DueDateTime', 'EstimatedHours', 'ExternalID', 'id', 'InstalledProductID', 'IssueType', 'LastActivityDate', 'Priority', 'QueueID', 'Source', 'Status', 'SubIssueType', 'TicketNumber', 'Title', 'FirstResponseDateTime', 'ResolutionPlanDateTime', 'ResolvedDateTime', 'FirstResponseDueDateTime', 'ResolutionPlanDueDateTime', 'ResolvedDueDateTime', 'ServiceLevelAgreementID', 'Resolution', 'PurchaseOrderNumber', 'TicketType', 'ProblemTicketId', 'OpportunityId', 'ChangeApprovalBoard', 'ChangeApprovalType', 'ChangeApprovalStatus', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'LastCustomerNotificationDateTime', 'LastCustomerVisibleActivityDateTime', 'ContractServiceID', 'ContractServiceBundleID', 'MonitorTypeID', 'MonitorID', 'AEMAlertID', 'HoursToBeScheduled', 'TicketCategory', 'FirstResponseInitiatingResourceID', 'FirstResponseAssignedResourceID', 'ProjectID', 'BusinessDivisionSubdivisionID', 'CompletedByResourceID', 'AccountPhysicalLocationID', 'LastActivityResourceID', 'CurrentServiceThermometerRating', 'PreviousServiceThermometerRating', 'ServiceThermometerTemperature', 'ApiVendorID', 'UserDefinedField')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'CompletedDate', 'ContactID', 'ContractID', 'CreateDate', 'CreatorResourceID', 'Description', 'DueDateTime', 'EstimatedHours', 'ExternalID', 'id', 'InstalledProductID', 'IssueType', 'LastActivityDate', 'Priority', 'QueueID', 'Source', 'Status', 'SubIssueType', 'TicketNumber', 'Title', 'FirstResponseDateTime', 'ResolutionPlanDateTime', 'ResolvedDateTime', 'FirstResponseDueDateTime', 'ResolutionPlanDueDateTime', 'ResolvedDueDateTime', 'ServiceLevelAgreementID', 'Resolution', 'PurchaseOrderNumber', 'TicketType', 'ProblemTicketId', 'OpportunityId', 'ChangeApprovalBoard', 'ChangeApprovalType', 'ChangeApprovalStatus', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'LastCustomerNotificationDateTime', 'LastCustomerVisibleActivityDateTime', 'ContractServiceID', 'ContractServiceBundleID', 'MonitorTypeID', 'MonitorID', 'AEMAlertID', 'HoursToBeScheduled', 'TicketCategory', 'FirstResponseInitiatingResourceID', 'FirstResponseAssignedResourceID', 'ProjectID', 'BusinessDivisionSubdivisionID', 'CompletedByResourceID', 'AccountPhysicalLocationID', 'LastActivityResourceID', 'CurrentServiceThermometerRating', 'PreviousServiceThermometerRating', 'ServiceThermometerTemperature', 'ApiVendorID', 'UserDefinedField')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'CompletedDate', 'ContactID', 'ContractID', 'CreateDate', 'CreatorResourceID', 'Description', 'DueDateTime', 'EstimatedHours', 'ExternalID', 'id', 'InstalledProductID', 'IssueType', 'LastActivityDate', 'Priority', 'QueueID', 'Source', 'Status', 'SubIssueType', 'TicketNumber', 'Title', 'FirstResponseDateTime', 'ResolutionPlanDateTime', 'ResolvedDateTime', 'FirstResponseDueDateTime', 'ResolutionPlanDueDateTime', 'ResolvedDueDateTime', 'ServiceLevelAgreementID', 'Resolution', 'PurchaseOrderNumber', 'TicketType', 'ProblemTicketId', 'OpportunityId', 'ChangeApprovalBoard', 'ChangeApprovalType', 'ChangeApprovalStatus', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'LastCustomerNotificationDateTime', 'LastCustomerVisibleActivityDateTime', 'ContractServiceID', 'ContractServiceBundleID', 'MonitorTypeID', 'MonitorID', 'AEMAlertID', 'HoursToBeScheduled', 'TicketCategory', 'FirstResponseInitiatingResourceID', 'FirstResponseAssignedResourceID', 'ProjectID', 'BusinessDivisionSubdivisionID', 'CompletedByResourceID', 'AccountPhysicalLocationID', 'LastActivityResourceID', 'CurrentServiceThermometerRating', 'PreviousServiceThermometerRating', 'ServiceThermometerTemperature', 'ApiVendorID', 'UserDefinedField')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'CompletedDate', 'ContactID', 'ContractID', 'CreateDate', 'CreatorResourceID', 'Description', 'DueDateTime', 'EstimatedHours', 'ExternalID', 'id', 'InstalledProductID', 'IssueType', 'LastActivityDate', 'Priority', 'QueueID', 'Source', 'Status', 'SubIssueType', 'TicketNumber', 'Title', 'FirstResponseDateTime', 'ResolutionPlanDateTime', 'ResolvedDateTime', 'FirstResponseDueDateTime', 'ResolutionPlanDueDateTime', 'ResolvedDueDateTime', 'ServiceLevelAgreementID', 'Resolution', 'PurchaseOrderNumber', 'TicketType', 'ProblemTicketId', 'OpportunityId', 'ChangeApprovalBoard', 'ChangeApprovalType', 'ChangeApprovalStatus', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'LastCustomerNotificationDateTime', 'LastCustomerVisibleActivityDateTime', 'ContractServiceID', 'ContractServiceBundleID', 'MonitorTypeID', 'MonitorID', 'AEMAlertID', 'HoursToBeScheduled', 'TicketCategory', 'FirstResponseInitiatingResourceID', 'FirstResponseAssignedResourceID', 'ProjectID', 'BusinessDivisionSubdivisionID', 'CompletedByResourceID', 'AccountPhysicalLocationID', 'LastActivityResourceID', 'CurrentServiceThermometerRating', 'PreviousServiceThermometerRating', 'ServiceThermometerTemperature', 'ApiVendorID', 'UserDefinedField')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'ExternalID', 'TicketNumber', 'Title', 'Resolution', 'PurchaseOrderNumber', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'AEMAlertID', 'UserDefinedField')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'ExternalID', 'TicketNumber', 'Title', 'Resolution', 'PurchaseOrderNumber', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'AEMAlertID', 'UserDefinedField')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'ExternalID', 'TicketNumber', 'Title', 'Resolution', 'PurchaseOrderNumber', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'AEMAlertID', 'UserDefinedField')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'ExternalID', 'TicketNumber', 'Title', 'Resolution', 'PurchaseOrderNumber', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'AEMAlertID', 'UserDefinedField')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'ExternalID', 'TicketNumber', 'Title', 'Resolution', 'PurchaseOrderNumber', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'AEMAlertID', 'UserDefinedField')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CompletedDate', 'CreateDate', 'DueDateTime', 'LastActivityDate', 'FirstResponseDateTime', 'ResolutionPlanDateTime', 'ResolvedDateTime', 'FirstResponseDueDateTime', 'ResolutionPlanDueDateTime', 'ResolvedDueDateTime', 'LastCustomerNotificationDateTime', 'LastCustomerVisibleActivityDateTime', 'UserDefinedField')]
    [string[]]
    $IsThisDay
  )

    begin { 
        $entityName = 'Ticket'
    
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {
            $DebugPreference = 'Continue' 
        }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
    }


    process {
        # Parameterset Get_All has a single parameter: -All
        # Set the Filter manually to get every single object of this type 
        if ($PSCmdlet.ParameterSetName -eq 'Get_all') { 
            $Filter = @('id', '-ge', 0)
        }
        # So it is not -All. If Filter does not exist it has to be By_parameters
        elseif (-not ($Filter)) {
    
            Write-Debug ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)
      
            # Convert named parameters to a filter definition that can be parsed to QueryXML
            [string[]]$Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $entityName
        }
        # Not parameters, nor Get_all. There are only three parameter sets, so now we know
        # that we were passed a Filter
        else {
      
            Write-Debug ('{0}: Query based on manual filter, parsing' -F $MyInvocation.MyCommand.Name)
            
            # Parse the filter string and expand variables in _this_ scope (dot-sourcing)
            # or the variables will not be available and expansion will fail
            $Filter = . Update-AtwsFilter -Filterstring $Filter
        } 

        # Prepare shouldProcess comments
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to query the Autotask Web API for {1}(s).' -F $caption, $entityName
        $verboseWarning = '{0}: About to query the Autotask Web API for {1}(s). Do you want to continue?' -F $caption, $entityName
    
        # Lets do it and say we didn't!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
    
            # Make the query and pass the optional parameters to Get-AtwsData
            $result = Get-AtwsData -Entity $entityName -Filter $Filter `
                -NoPickListLabel:$NoPickListLabel.IsPresent `
                -GetReferenceEntityById $GetReferenceEntityById `
                -GetExternalEntityByThisEntityId $GetExternalEntityByThisEntityId
    
            Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $result.Count)

        }
    }

    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        if ($result) {
            Return $result
        }
    }


}
