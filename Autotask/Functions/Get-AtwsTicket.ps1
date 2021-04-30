#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
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
RmaStatus
RmaType

Entities that have fields that refer to the base entity of this CmdLet:


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
    [ValidateSet('AccountID', 'AccountPhysicalLocationID', 'AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'BusinessDivisionSubdivisionID', 'CompletedByResourceID', 'ContactID', 'ContractID', 'ContractServiceBundleID', 'ContractServiceID', 'CreatedByContactID', 'CreatorResourceID', 'ImpersonatorCreatorResourceID', 'InstalledProductID', 'LastActivityResourceID', 'OpportunityId', 'ProblemTicketId', 'ProjectID')]
    [string]
    $GetReferenceEntityById,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

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

# Account Physical Location
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $AccountPhysicalLocationID,

# AEM Alert ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $AEMAlertID,

# Allocation Code Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $AllocationCodeID,

# API Vendor ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Ticket -FieldName ApiVendorID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Ticket -FieldName ApiVendorID -Label) + (Get-AtwsPicklistValue -Entity Ticket -FieldName ApiVendorID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $ApiVendorID,

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

# Business Division Subdivision ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BusinessDivisionSubdivisionID,

# Change Approval Board ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Ticket -FieldName ChangeApprovalBoard -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Ticket -FieldName ChangeApprovalBoard -Label) + (Get-AtwsPicklistValue -Entity Ticket -FieldName ChangeApprovalBoard -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $ChangeApprovalBoard,

# Change Approval Status
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Ticket -FieldName ChangeApprovalStatus -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Ticket -FieldName ChangeApprovalStatus -Label) + (Get-AtwsPicklistValue -Entity Ticket -FieldName ChangeApprovalStatus -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $ChangeApprovalStatus,

# Change Approval Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Ticket -FieldName ChangeApprovalType -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Ticket -FieldName ChangeApprovalType -Label) + (Get-AtwsPicklistValue -Entity Ticket -FieldName ChangeApprovalType -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $ChangeApprovalType,

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

# Ticket Completed By
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CompletedByResourceID,

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

# Contract Service Bundle ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $ContractServiceBundleID,

# Contract Service ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $ContractServiceID,

# Ticket Creation Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CreateDate,

# Created By Contact ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CreatedByContactID,

# Ticket Creator
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CreatorResourceID,

# Current Service Thermometer Rating
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Ticket -FieldName CurrentServiceThermometerRating -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Ticket -FieldName CurrentServiceThermometerRating -Label) + (Get-AtwsPicklistValue -Entity Ticket -FieldName CurrentServiceThermometerRating -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $CurrentServiceThermometerRating,

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

# First Response Assigned Resource
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $FirstResponseAssignedResourceID,

# First Response Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $FirstResponseDateTime,

# First Response Due Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $FirstResponseDueDateTime,

# First Response Initiating Resource
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $FirstResponseInitiatingResourceID,

# Hours to be Scheduled
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $HoursToBeScheduled,

# Ticket ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Impersonator Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ImpersonatorCreatorResourceID,

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
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Ticket -FieldName IssueType -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Ticket -FieldName IssueType -Label) + (Get-AtwsPicklistValue -Entity Ticket -FieldName IssueType -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $IssueType,

# Ticket Last Activity Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LastActivityDate,

# Last Edited Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $LastActivityResourceID,

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

# Last Tracked Modification Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LastTrackedModificationDateTime,

# Monitor ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $MonitorID,

# Monitor Type ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Ticket -FieldName MonitorTypeID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Ticket -FieldName MonitorTypeID -Label) + (Get-AtwsPicklistValue -Entity Ticket -FieldName MonitorTypeID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $MonitorTypeID,

# Opportunity ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $OpportunityId,

# Previous Service Thermometer Rating
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Ticket -FieldName PreviousServiceThermometerRating -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Ticket -FieldName PreviousServiceThermometerRating -Label) + (Get-AtwsPicklistValue -Entity Ticket -FieldName PreviousServiceThermometerRating -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $PreviousServiceThermometerRating,

# Ticket Priority
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Ticket -FieldName Priority -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Ticket -FieldName Priority -Label) + (Get-AtwsPicklistValue -Entity Ticket -FieldName Priority -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $Priority,

# Problem Ticket ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ProblemTicketId,

# Project ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ProjectID,

# purchase_order_number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $PurchaseOrderNumber,

# Ticket Department Name OR Ticket Queue Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Ticket -FieldName QueueID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Ticket -FieldName QueueID -Label) + (Get-AtwsPicklistValue -Entity Ticket -FieldName QueueID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $QueueID,

# Resolution
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,32000)]
    [string[]]
    $Resolution,

# Resolution Plan Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ResolutionPlanDateTime,

# Resolution Plan Due Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ResolutionPlanDueDateTime,

# Resolved Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ResolvedDateTime,

# Resolved Due Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ResolvedDueDateTime,

# RMA Status
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Ticket -FieldName RmaStatus -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Ticket -FieldName RmaStatus -Label) + (Get-AtwsPicklistValue -Entity Ticket -FieldName RmaStatus -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $RmaStatus,

# RMA Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Ticket -FieldName RmaType -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Ticket -FieldName RmaType -Label) + (Get-AtwsPicklistValue -Entity Ticket -FieldName RmaType -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $RmaType,

# Has Met SLA
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $ServiceLevelAgreementHasBeenMet,

# Service Level Agreement ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Ticket -FieldName ServiceLevelAgreementID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Ticket -FieldName ServiceLevelAgreementID -Label) + (Get-AtwsPicklistValue -Entity Ticket -FieldName ServiceLevelAgreementID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $ServiceLevelAgreementID,

# Service Thermometer Temperature
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ServiceThermometerTemperature,

# Ticket Source
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Ticket -FieldName Source -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Ticket -FieldName Source -Label) + (Get-AtwsPicklistValue -Entity Ticket -FieldName Source -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $Source,

# Ticket Status
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Ticket -FieldName Status -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Ticket -FieldName Status -Label) + (Get-AtwsPicklistValue -Entity Ticket -FieldName Status -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $Status,

# Ticket Subissue Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter( {
        param($Cmd, $Param, $Word, $Ast, $FakeBound)
        if ($fakeBound.IssueType) {    
            Get-AtwsPicklistValue -Entity Ticket -FieldName SubIssueType -ParentValue $fakeBound.IssueType -Label -Quoted
        }
        else {
            Get-AtwsPicklistValue -Entity Ticket -FieldName SubIssueType -Label -Quoted
        }
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Ticket -FieldName SubIssueType -Label) + (Get-AtwsPicklistValue -Entity Ticket -FieldName SubIssueType -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $SubIssueType,

# Ticket Category
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Ticket -FieldName TicketCategory -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Ticket -FieldName TicketCategory -Label) + (Get-AtwsPicklistValue -Entity Ticket -FieldName TicketCategory -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $TicketCategory,

# Ticket Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $TicketNumber,

# Ticket Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Ticket -FieldName TicketType -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Ticket -FieldName TicketType -Label) + (Get-AtwsPicklistValue -Entity Ticket -FieldName TicketType -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $TicketType,

# Ticket Title
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,255)]
    [string[]]
    $Title,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AccountPhysicalLocationID', 'AEMAlertID', 'AllocationCodeID', 'ApiVendorID', 'AssignedResourceID', 'AssignedResourceRoleID', 'BusinessDivisionSubdivisionID', 'ChangeApprovalBoard', 'ChangeApprovalStatus', 'ChangeApprovalType', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'CompletedByResourceID', 'CompletedDate', 'ContactID', 'ContractID', 'ContractServiceBundleID', 'ContractServiceID', 'CreateDate', 'CreatedByContactID', 'CreatorResourceID', 'CreatorType', 'CurrentServiceThermometerRating', 'Description', 'DueDateTime', 'EstimatedHours', 'ExternalID', 'FirstResponseAssignedResourceID', 'FirstResponseDateTime', 'FirstResponseDueDateTime', 'FirstResponseInitiatingResourceID', 'HoursToBeScheduled', 'id', 'ImpersonatorCreatorResourceID', 'InstalledProductID', 'IssueType', 'LastActivityDate', 'LastActivityPersonType', 'LastActivityResourceID', 'LastCustomerNotificationDateTime', 'LastCustomerVisibleActivityDateTime', 'LastTrackedModificationDateTime', 'MonitorID', 'MonitorTypeID', 'OpportunityId', 'PreviousServiceThermometerRating', 'Priority', 'ProblemTicketId', 'ProjectID', 'PurchaseOrderNumber', 'QueueID', 'Resolution', 'ResolutionPlanDateTime', 'ResolutionPlanDueDateTime', 'ResolvedDateTime', 'ResolvedDueDateTime', 'RmaStatus', 'RmaType', 'ServiceLevelAgreementHasBeenMet', 'ServiceLevelAgreementID', 'ServiceLevelAgreementPausedNextEventHours', 'ServiceThermometerTemperature', 'Source', 'Status', 'SubIssueType', 'TicketCategory', 'TicketNumber', 'TicketType', 'Title')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AccountPhysicalLocationID', 'AEMAlertID', 'AllocationCodeID', 'ApiVendorID', 'AssignedResourceID', 'AssignedResourceRoleID', 'BusinessDivisionSubdivisionID', 'ChangeApprovalBoard', 'ChangeApprovalStatus', 'ChangeApprovalType', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'CompletedByResourceID', 'CompletedDate', 'ContactID', 'ContractID', 'ContractServiceBundleID', 'ContractServiceID', 'CreateDate', 'CreatedByContactID', 'CreatorResourceID', 'CreatorType', 'CurrentServiceThermometerRating', 'Description', 'DueDateTime', 'EstimatedHours', 'ExternalID', 'FirstResponseAssignedResourceID', 'FirstResponseDateTime', 'FirstResponseDueDateTime', 'FirstResponseInitiatingResourceID', 'HoursToBeScheduled', 'id', 'ImpersonatorCreatorResourceID', 'InstalledProductID', 'IssueType', 'LastActivityDate', 'LastActivityPersonType', 'LastActivityResourceID', 'LastCustomerNotificationDateTime', 'LastCustomerVisibleActivityDateTime', 'LastTrackedModificationDateTime', 'MonitorID', 'MonitorTypeID', 'OpportunityId', 'PreviousServiceThermometerRating', 'Priority', 'ProblemTicketId', 'ProjectID', 'PurchaseOrderNumber', 'QueueID', 'Resolution', 'ResolutionPlanDateTime', 'ResolutionPlanDueDateTime', 'ResolvedDateTime', 'ResolvedDueDateTime', 'RmaStatus', 'RmaType', 'ServiceLevelAgreementHasBeenMet', 'ServiceLevelAgreementID', 'ServiceLevelAgreementPausedNextEventHours', 'ServiceThermometerTemperature', 'Source', 'Status', 'SubIssueType', 'TicketCategory', 'TicketNumber', 'TicketType', 'Title')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AccountPhysicalLocationID', 'AEMAlertID', 'AllocationCodeID', 'ApiVendorID', 'AssignedResourceID', 'AssignedResourceRoleID', 'BusinessDivisionSubdivisionID', 'ChangeApprovalBoard', 'ChangeApprovalStatus', 'ChangeApprovalType', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'CompletedByResourceID', 'CompletedDate', 'ContactID', 'ContractID', 'ContractServiceBundleID', 'ContractServiceID', 'CreateDate', 'CreatedByContactID', 'CreatorResourceID', 'CreatorType', 'CurrentServiceThermometerRating', 'Description', 'DueDateTime', 'EstimatedHours', 'ExternalID', 'FirstResponseAssignedResourceID', 'FirstResponseDateTime', 'FirstResponseDueDateTime', 'FirstResponseInitiatingResourceID', 'HoursToBeScheduled', 'id', 'ImpersonatorCreatorResourceID', 'InstalledProductID', 'IssueType', 'LastActivityDate', 'LastActivityPersonType', 'LastActivityResourceID', 'LastCustomerNotificationDateTime', 'LastCustomerVisibleActivityDateTime', 'LastTrackedModificationDateTime', 'MonitorID', 'MonitorTypeID', 'OpportunityId', 'PreviousServiceThermometerRating', 'Priority', 'ProblemTicketId', 'ProjectID', 'PurchaseOrderNumber', 'QueueID', 'Resolution', 'ResolutionPlanDateTime', 'ResolutionPlanDueDateTime', 'ResolvedDateTime', 'ResolvedDueDateTime', 'RmaStatus', 'RmaType', 'ServiceLevelAgreementHasBeenMet', 'ServiceLevelAgreementID', 'ServiceLevelAgreementPausedNextEventHours', 'ServiceThermometerTemperature', 'Source', 'Status', 'SubIssueType', 'TicketCategory', 'TicketNumber', 'TicketType', 'Title')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AccountPhysicalLocationID', 'AEMAlertID', 'AllocationCodeID', 'ApiVendorID', 'AssignedResourceID', 'AssignedResourceRoleID', 'BusinessDivisionSubdivisionID', 'ChangeApprovalBoard', 'ChangeApprovalStatus', 'ChangeApprovalType', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'CompletedByResourceID', 'CompletedDate', 'ContactID', 'ContractID', 'ContractServiceBundleID', 'ContractServiceID', 'CreateDate', 'CreatedByContactID', 'CreatorResourceID', 'CreatorType', 'CurrentServiceThermometerRating', 'Description', 'DueDateTime', 'EstimatedHours', 'ExternalID', 'FirstResponseAssignedResourceID', 'FirstResponseDateTime', 'FirstResponseDueDateTime', 'FirstResponseInitiatingResourceID', 'HoursToBeScheduled', 'id', 'ImpersonatorCreatorResourceID', 'InstalledProductID', 'IssueType', 'LastActivityDate', 'LastActivityPersonType', 'LastActivityResourceID', 'LastCustomerNotificationDateTime', 'LastCustomerVisibleActivityDateTime', 'LastTrackedModificationDateTime', 'MonitorID', 'MonitorTypeID', 'OpportunityId', 'PreviousServiceThermometerRating', 'Priority', 'ProblemTicketId', 'ProjectID', 'PurchaseOrderNumber', 'QueueID', 'Resolution', 'ResolutionPlanDateTime', 'ResolutionPlanDueDateTime', 'ResolvedDateTime', 'ResolvedDueDateTime', 'RmaStatus', 'RmaType', 'ServiceLevelAgreementID', 'ServiceLevelAgreementPausedNextEventHours', 'ServiceThermometerTemperature', 'Source', 'Status', 'SubIssueType', 'TicketCategory', 'TicketNumber', 'TicketType', 'Title', 'UserDefinedField')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AccountPhysicalLocationID', 'AEMAlertID', 'AllocationCodeID', 'ApiVendorID', 'AssignedResourceID', 'AssignedResourceRoleID', 'BusinessDivisionSubdivisionID', 'ChangeApprovalBoard', 'ChangeApprovalStatus', 'ChangeApprovalType', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'CompletedByResourceID', 'CompletedDate', 'ContactID', 'ContractID', 'ContractServiceBundleID', 'ContractServiceID', 'CreateDate', 'CreatedByContactID', 'CreatorResourceID', 'CreatorType', 'CurrentServiceThermometerRating', 'Description', 'DueDateTime', 'EstimatedHours', 'ExternalID', 'FirstResponseAssignedResourceID', 'FirstResponseDateTime', 'FirstResponseDueDateTime', 'FirstResponseInitiatingResourceID', 'HoursToBeScheduled', 'id', 'ImpersonatorCreatorResourceID', 'InstalledProductID', 'IssueType', 'LastActivityDate', 'LastActivityPersonType', 'LastActivityResourceID', 'LastCustomerNotificationDateTime', 'LastCustomerVisibleActivityDateTime', 'LastTrackedModificationDateTime', 'MonitorID', 'MonitorTypeID', 'OpportunityId', 'PreviousServiceThermometerRating', 'Priority', 'ProblemTicketId', 'ProjectID', 'PurchaseOrderNumber', 'QueueID', 'Resolution', 'ResolutionPlanDateTime', 'ResolutionPlanDueDateTime', 'ResolvedDateTime', 'ResolvedDueDateTime', 'RmaStatus', 'RmaType', 'ServiceLevelAgreementID', 'ServiceLevelAgreementPausedNextEventHours', 'ServiceThermometerTemperature', 'Source', 'Status', 'SubIssueType', 'TicketCategory', 'TicketNumber', 'TicketType', 'Title', 'UserDefinedField')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AccountPhysicalLocationID', 'AEMAlertID', 'AllocationCodeID', 'ApiVendorID', 'AssignedResourceID', 'AssignedResourceRoleID', 'BusinessDivisionSubdivisionID', 'ChangeApprovalBoard', 'ChangeApprovalStatus', 'ChangeApprovalType', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'CompletedByResourceID', 'CompletedDate', 'ContactID', 'ContractID', 'ContractServiceBundleID', 'ContractServiceID', 'CreateDate', 'CreatedByContactID', 'CreatorResourceID', 'CreatorType', 'CurrentServiceThermometerRating', 'Description', 'DueDateTime', 'EstimatedHours', 'ExternalID', 'FirstResponseAssignedResourceID', 'FirstResponseDateTime', 'FirstResponseDueDateTime', 'FirstResponseInitiatingResourceID', 'HoursToBeScheduled', 'id', 'ImpersonatorCreatorResourceID', 'InstalledProductID', 'IssueType', 'LastActivityDate', 'LastActivityPersonType', 'LastActivityResourceID', 'LastCustomerNotificationDateTime', 'LastCustomerVisibleActivityDateTime', 'LastTrackedModificationDateTime', 'MonitorID', 'MonitorTypeID', 'OpportunityId', 'PreviousServiceThermometerRating', 'Priority', 'ProblemTicketId', 'ProjectID', 'PurchaseOrderNumber', 'QueueID', 'Resolution', 'ResolutionPlanDateTime', 'ResolutionPlanDueDateTime', 'ResolvedDateTime', 'ResolvedDueDateTime', 'RmaStatus', 'RmaType', 'ServiceLevelAgreementID', 'ServiceLevelAgreementPausedNextEventHours', 'ServiceThermometerTemperature', 'Source', 'Status', 'SubIssueType', 'TicketCategory', 'TicketNumber', 'TicketType', 'Title', 'UserDefinedField')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AccountPhysicalLocationID', 'AEMAlertID', 'AllocationCodeID', 'ApiVendorID', 'AssignedResourceID', 'AssignedResourceRoleID', 'BusinessDivisionSubdivisionID', 'ChangeApprovalBoard', 'ChangeApprovalStatus', 'ChangeApprovalType', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'CompletedByResourceID', 'CompletedDate', 'ContactID', 'ContractID', 'ContractServiceBundleID', 'ContractServiceID', 'CreateDate', 'CreatedByContactID', 'CreatorResourceID', 'CreatorType', 'CurrentServiceThermometerRating', 'Description', 'DueDateTime', 'EstimatedHours', 'ExternalID', 'FirstResponseAssignedResourceID', 'FirstResponseDateTime', 'FirstResponseDueDateTime', 'FirstResponseInitiatingResourceID', 'HoursToBeScheduled', 'id', 'ImpersonatorCreatorResourceID', 'InstalledProductID', 'IssueType', 'LastActivityDate', 'LastActivityPersonType', 'LastActivityResourceID', 'LastCustomerNotificationDateTime', 'LastCustomerVisibleActivityDateTime', 'LastTrackedModificationDateTime', 'MonitorID', 'MonitorTypeID', 'OpportunityId', 'PreviousServiceThermometerRating', 'Priority', 'ProblemTicketId', 'ProjectID', 'PurchaseOrderNumber', 'QueueID', 'Resolution', 'ResolutionPlanDateTime', 'ResolutionPlanDueDateTime', 'ResolvedDateTime', 'ResolvedDueDateTime', 'RmaStatus', 'RmaType', 'ServiceLevelAgreementID', 'ServiceLevelAgreementPausedNextEventHours', 'ServiceThermometerTemperature', 'Source', 'Status', 'SubIssueType', 'TicketCategory', 'TicketNumber', 'TicketType', 'Title', 'UserDefinedField')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AEMAlertID', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'Description', 'ExternalID', 'PurchaseOrderNumber', 'Resolution', 'TicketNumber', 'Title', 'UserDefinedField')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AEMAlertID', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'Description', 'ExternalID', 'PurchaseOrderNumber', 'Resolution', 'TicketNumber', 'Title', 'UserDefinedField')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AEMAlertID', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'Description', 'ExternalID', 'PurchaseOrderNumber', 'Resolution', 'TicketNumber', 'Title', 'UserDefinedField')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AEMAlertID', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'Description', 'ExternalID', 'PurchaseOrderNumber', 'Resolution', 'TicketNumber', 'Title', 'UserDefinedField')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AEMAlertID', 'ChangeInfoField1', 'ChangeInfoField2', 'ChangeInfoField3', 'ChangeInfoField4', 'ChangeInfoField5', 'Description', 'ExternalID', 'PurchaseOrderNumber', 'Resolution', 'TicketNumber', 'Title', 'UserDefinedField')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CompletedDate', 'CreateDate', 'DueDateTime', 'FirstResponseDateTime', 'FirstResponseDueDateTime', 'LastActivityDate', 'LastCustomerNotificationDateTime', 'LastCustomerVisibleActivityDateTime', 'LastTrackedModificationDateTime', 'ResolutionPlanDateTime', 'ResolutionPlanDueDateTime', 'ResolvedDateTime', 'ResolvedDueDateTime', 'UserDefinedField')]
    [string[]]
    $IsThisDay
  )

    begin {
        $entityName = 'Ticket'

        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {
            $DebugPreference = 'Continue'
        }
        else {
            # Respect configured preference
            $DebugPreference = $Script:Atws.Configuration.DebugPref
        }

        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

        if (!($PSCmdlet.MyInvocation.BoundParameters['Verbose'].IsPresent)) {
            # No local override of central preference. Load central preference
            $VerbosePreference = $Script:Atws.Configuration.VerbosePref
        }

        $result = [collections.generic.list[psobject]]::new()
        $iterations = [collections.generic.list[psobject]]::new()
    }


    process {
        # Parameterset Get_All has a single parameter: -All
        # Set the Filter manually to get every single object of this type
        if ($PSCmdlet.ParameterSetName -eq 'Get_all') {
            $Filter = @('id', '-ge', 0)
            $iterations.Add($Filter)
        }
        # So it is not -All. If Filter does not exist it has to be By_parameters
        elseif (-not ($Filter)) {

            Write-Debug ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)

            # What is the highest number of values for a parameter and is it higher than 200?
            $max = $PSBoundParameters.Values[0].length | Measure-Object -Maximum

            # If the count is less than or equal to 200 we pass PSBoundParameters as is
            if ($max.Maximum -le 200) {
                [collections.generic.list[string]]$Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $entityName
                $iterations.Add($Filter)
            }
            # More than 200 values. This will cause a SQL query nested too much error. Break a single parameter
            # into segments and create multiple queries with max 200 values
            else {
                
                # Find the parameter with the $max.Maximum number of items
                foreach ($param in $PSCmdlet.MyInvocation.BoundParameters.GetEnumerator() ) {
                    # When we have found the right parameter, stop iterating
                    if ($param.Value.length -eq $max.Maximum) { break }
                }
     
                # Deduplicate the value list or the same ID may be included in more than 1 query
                $outerLoop = $PSCmdlet.MyInvocation.BoundParameters.$($param.key) | Sort-Object -Unique

                Write-Verbose ('{0}: Received {1} objects containing {2} unique values for parameter {3}' -f $MyInvocation.MyCommand.Name, $count, $outerLoop.Count, $param.key)
                  
                for ($s = 0; $s -lt $outerLoop.count; $s += 200) {
                    $e = $s + 199
                    if ($e -ge $outerLoop.count) {
                        $e = $outerLoop.count - 1
                    }
                  
                    # Make writable of BoundParameters
                    $BoundParameters = $PSCmdlet.MyInvocation.BoundParameters

                    # make a selection
                    $BoundParameters.$($param.key) = $outerLoop[$s .. $e]

                    Write-Verbose ('{0}: Asking for {1} values {2} to {3}' -f $MyInvocation.MyCommand.Name, $param, $s, $e)

                    # Convert named parameters to a filter definition that can be parsed to QueryXML
                    [collections.generic.list[string]]$Filter = ConvertTo-AtwsFilter -BoundParameters $BoundParameters -EntityName $entityName
                    $iterations.Add($Filter)
                }
            }
        }
        # Not parameters, nor Get_all. There are only three parameter sets, so now we know
        # that we were passed a Filter
        else {

            Write-Debug ('{0}: Query based on manual filter, parsing' -F $MyInvocation.MyCommand.Name)

            # Parse the filter string and expand variables in _this_ scope (dot-sourcing)
            # or the variables will not be available and expansion will fail
            $Filter = . Update-AtwsFilter -Filterstring $Filter
            $iterations.Add($Filter)
        }

        # Prepare shouldProcess comments
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to query the Autotask Web API for {1}(s).' -F $caption, $entityName
        $verboseWarning = '{0}: About to query the Autotask Web API for {1}(s). Do you want to continue?' -F $caption, $entityName

        # Lets do it and say we didn't!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) {
            foreach ($Filter in $iterations) {

                try {
                    # Make the query and pass the optional parameters to Get-AtwsData
                    # Force list even if result is only 1 object to be compatible with addrange()
                    [collections.generic.list[psobject]]$response = Get-AtwsData -Entity $entityName -Filter $Filter `
                        -NoPickListLabel:$NoPickListLabel.IsPresent `
                        -GetReferenceEntityById $GetReferenceEntityById
                }
                catch {
                    # Write a debug message with detailed information to developers
                    $reason = ("{0}: {1}" -f $_.CategoryInfo.Category, $_.CategoryInfo.Reason)
                    $message = "{2}: {0}`r`n`r`nLine:{1}`r`n`r`nScript stacktrace:`r`n{3}" -f $_.Exception.Message, $_.InvocationInfo.Line, $reason, $_.ScriptStackTrace
                    Write-Debug $message

                    # Pass on the error
                    $PSCmdlet.ThrowTerminatingError($_)
                    return
                }
                # Add response to result - if there are any response to add
                if ($response.count -gt 0) { 
                    $result.AddRange($response)
                }

                Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $result.Count)
            }
        }
    }

    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        if ($result) {
            Return [array]$result
        }
    }


}
