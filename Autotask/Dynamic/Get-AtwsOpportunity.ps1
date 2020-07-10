#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsOpportunity
{


<#
.SYNOPSIS
This function get one or more Opportunity through the Autotask Web Services API.
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

LeadReferral
 

RevenueSpreadUnit
 

Stage
 

Status
 

Rating
 

PrimaryCompetitor
 

WinReason
 

LossReason
 

OpportunityCategoryID
 

Entities that have fields that refer to the base entity of this CmdLet:

AccountNote
 AccountToDo
 AttachmentInfo
 Contract
 NotificationHistory
 Quote
 SalesOrder
 Ticket

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Opportunity[]]. This function outputs the Autotask.Opportunity that was returned by the API.
.EXAMPLE
Get-AtwsOpportunity -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsOpportunity -OpportunityName SomeName
Returns the object with OpportunityName 'SomeName', if any.
 .EXAMPLE
Get-AtwsOpportunity -OpportunityName 'Some Name'
Returns the object with OpportunityName 'Some Name', if any.
 .EXAMPLE
Get-AtwsOpportunity -OpportunityName 'Some Name' -NotEquals OpportunityName
Returns any objects with a OpportunityName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsOpportunity -OpportunityName SomeName* -Like OpportunityName
Returns any object with a OpportunityName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsOpportunity -OpportunityName SomeName* -NotLike OpportunityName
Returns any object with a OpportunityName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsOpportunity -LeadReferral <PickList Label>
Returns any Opportunitys with property LeadReferral equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsOpportunity -LeadReferral <PickList Label> -NotEquals LeadReferral 
Returns any Opportunitys with property LeadReferral NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsOpportunity -LeadReferral <PickList Label1>, <PickList Label2>
Returns any Opportunitys with property LeadReferral equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsOpportunity -LeadReferral <PickList Label1>, <PickList Label2> -NotEquals LeadReferral
Returns any Opportunitys with property LeadReferral NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsOpportunity -Id 1234 -OpportunityName SomeName* -LeadReferral <PickList Label1>, <PickList Label2> -Like OpportunityName -NotEquals LeadReferral -GreaterThan Id
An example of a more complex query. This command returns any Opportunitys with Id GREATER THAN 1234, a OpportunityName that matches the simple pattern SomeName* AND that has a LeadReferral that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsOpportunity
 .LINK
Set-AtwsOpportunity

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
    [ValidateSet('AccountID', 'BusinessDivisionSubdivisionID', 'ContactID', 'ImpersonatorCreatorResourceID', 'OwnerResourceID', 'ProductID', 'SalesOrderID')]
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
    [ValidateSet('AccountNote:OpportunityID', 'AccountToDo:OpportunityID', 'AttachmentInfo:OpportunityID', 'Contract:OpportunityID', 'NotificationHistory:OpportunityID', 'Quote:OpportunityID', 'SalesOrder:OpportunityID', 'Ticket:OpportunityId')]
    [string]
    $GetExternalEntityByThisEntityId,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# Opportunity ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# AccountObjectID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $AccountID,

# NumberOfUsers
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $AdvancedField1,

# SetupFee
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $AdvancedField2,

# HourlyCost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $AdvancedField3,

# DailyCost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $AdvancedField4,

# MonthlyCost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $AdvancedField5,

# Amount
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[decimal][]]
    $Amount,

# Barriers
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string[]]
    $Barriers,

# ContactObjectID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ContactID,

# Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[decimal][]]
    $Cost,

# CreateDate
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $CreateDate,

# HelpNeeded
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string[]]
    $HelpNeeded,

# LeadReferralObjectID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Opportunity -FieldName LeadReferral -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Account -FieldName KeyAccountIcon -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $LeadReferral,

# Market
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string[]]
    $Market,

# NextStep
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string[]]
    $NextStep,

# CreatorObjectID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $OwnerResourceID,

# ProductObjectID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ProductID,

# ProjClose
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $ProjectedCloseDate,

# StartDate
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ProjectedLiveDate,

# promotion_name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $PromotionName,

# spread_revenue_recognition_unit
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Opportunity -FieldName RevenueSpreadUnit -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Account -FieldName KeyAccountIcon -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $RevenueSpreadUnit,

# StageObjectID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Opportunity -FieldName Stage -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Account -FieldName KeyAccountIcon -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $Stage,

# Status
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Opportunity -FieldName Status -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Account -FieldName KeyAccountIcon -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $Status,

# ThroughDate
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ThroughDate,

# Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,128)]
    [string[]]
    $Title,

# opportunity_rating_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Opportunity -FieldName Rating -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Account -FieldName KeyAccountIcon -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $Rating,

# Closed Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ClosedDate,

# Assessment Score
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $AssessmentScore,

# Technical Assessment Score
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $TechnicalAssessmentScore,

# Relationship Assessment Score
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $RelationshipAssessmentScore,

# Primary Competitor
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Opportunity -FieldName PrimaryCompetitor -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Account -FieldName KeyAccountIcon -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $PrimaryCompetitor,

# Win Reason
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Opportunity -FieldName WinReason -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Account -FieldName KeyAccountIcon -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $WinReason,

# Loss Reason
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Opportunity -FieldName LossReason -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Account -FieldName KeyAccountIcon -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $LossReason,

# Win Reason Detail
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string[]]
    $WinReasonDetail,

# Loss Reason Detail
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string[]]
    $LossReasonDetail,

# Last Activity
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LastActivity,

# Date Stamp
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $DateStamp,

# Probability
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $Probability,

# Revenue Spread
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $RevenueSpread,

# Use Quote Totals
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $UseQuoteTotals,

# Total Amount Months
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $TotalAmountMonths,

# Sales Process Percent Complete
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $SalesProcessPercentComplete,

# Sales Order ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $SalesOrderID,

# One-Time Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $OnetimeCost,

# One-Time Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $OnetimeRevenue,

# Monthly Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $MonthlyCost,

# Monthly Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $MonthlyRevenue,

# Quarterly Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $QuarterlyCost,

# Quarterly Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $QuarterlyRevenue,

# Semi-Annual Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $SemiannualCost,

# Semi-Annual Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $SemiannualRevenue,

# Yearly Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $YearlyCost,

# Yearly Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $YearlyRevenue,

# Business Division Subdivision ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BusinessDivisionSubdivisionID,

# Opportunity Category ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Opportunity -FieldName OpportunityCategoryID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Account -FieldName KeyAccountIcon -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $OpportunityCategoryID,

# Lost Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LostDate,

# Promised Fulfillment Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $PromisedFulfillmentDate,

# Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,8000)]
    [string[]]
    $Description,

# Impersonator Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ImpersonatorCreatorResourceID,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'AdvancedField1', 'AdvancedField2', 'AdvancedField3', 'AdvancedField4', 'AdvancedField5', 'Amount', 'Barriers', 'ContactID', 'Cost', 'CreateDate', 'HelpNeeded', 'LeadReferral', 'Market', 'NextStep', 'OwnerResourceID', 'ProductID', 'ProjectedCloseDate', 'ProjectedLiveDate', 'PromotionName', 'RevenueSpreadUnit', 'Stage', 'Status', 'ThroughDate', 'Title', 'Rating', 'ClosedDate', 'AssessmentScore', 'TechnicalAssessmentScore', 'RelationshipAssessmentScore', 'PrimaryCompetitor', 'WinReason', 'LossReason', 'WinReasonDetail', 'LossReasonDetail', 'LastActivity', 'DateStamp', 'Probability', 'RevenueSpread', 'UseQuoteTotals', 'TotalAmountMonths', 'SalesProcessPercentComplete', 'SalesOrderID', 'OnetimeCost', 'OnetimeRevenue', 'MonthlyCost', 'MonthlyRevenue', 'QuarterlyCost', 'QuarterlyRevenue', 'SemiannualCost', 'SemiannualRevenue', 'YearlyCost', 'YearlyRevenue', 'BusinessDivisionSubdivisionID', 'OpportunityCategoryID', 'LostDate', 'PromisedFulfillmentDate', 'Description', 'ImpersonatorCreatorResourceID')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'AdvancedField1', 'AdvancedField2', 'AdvancedField3', 'AdvancedField4', 'AdvancedField5', 'Amount', 'Barriers', 'ContactID', 'Cost', 'CreateDate', 'HelpNeeded', 'LeadReferral', 'Market', 'NextStep', 'OwnerResourceID', 'ProductID', 'ProjectedCloseDate', 'ProjectedLiveDate', 'PromotionName', 'RevenueSpreadUnit', 'Stage', 'Status', 'ThroughDate', 'Title', 'Rating', 'ClosedDate', 'AssessmentScore', 'TechnicalAssessmentScore', 'RelationshipAssessmentScore', 'PrimaryCompetitor', 'WinReason', 'LossReason', 'WinReasonDetail', 'LossReasonDetail', 'LastActivity', 'DateStamp', 'Probability', 'RevenueSpread', 'UseQuoteTotals', 'TotalAmountMonths', 'SalesProcessPercentComplete', 'SalesOrderID', 'OnetimeCost', 'OnetimeRevenue', 'MonthlyCost', 'MonthlyRevenue', 'QuarterlyCost', 'QuarterlyRevenue', 'SemiannualCost', 'SemiannualRevenue', 'YearlyCost', 'YearlyRevenue', 'BusinessDivisionSubdivisionID', 'OpportunityCategoryID', 'LostDate', 'PromisedFulfillmentDate', 'Description', 'ImpersonatorCreatorResourceID')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'AdvancedField1', 'AdvancedField2', 'AdvancedField3', 'AdvancedField4', 'AdvancedField5', 'Amount', 'Barriers', 'ContactID', 'Cost', 'CreateDate', 'HelpNeeded', 'LeadReferral', 'Market', 'NextStep', 'OwnerResourceID', 'ProductID', 'ProjectedCloseDate', 'ProjectedLiveDate', 'PromotionName', 'RevenueSpreadUnit', 'Stage', 'Status', 'ThroughDate', 'Title', 'Rating', 'ClosedDate', 'AssessmentScore', 'TechnicalAssessmentScore', 'RelationshipAssessmentScore', 'PrimaryCompetitor', 'WinReason', 'LossReason', 'WinReasonDetail', 'LossReasonDetail', 'LastActivity', 'DateStamp', 'Probability', 'RevenueSpread', 'UseQuoteTotals', 'TotalAmountMonths', 'SalesProcessPercentComplete', 'SalesOrderID', 'OnetimeCost', 'OnetimeRevenue', 'MonthlyCost', 'MonthlyRevenue', 'QuarterlyCost', 'QuarterlyRevenue', 'SemiannualCost', 'SemiannualRevenue', 'YearlyCost', 'YearlyRevenue', 'BusinessDivisionSubdivisionID', 'OpportunityCategoryID', 'LostDate', 'PromisedFulfillmentDate', 'Description', 'ImpersonatorCreatorResourceID')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'AdvancedField1', 'AdvancedField2', 'AdvancedField3', 'AdvancedField4', 'AdvancedField5', 'Amount', 'Barriers', 'ContactID', 'Cost', 'CreateDate', 'HelpNeeded', 'LeadReferral', 'Market', 'NextStep', 'OwnerResourceID', 'ProductID', 'ProjectedCloseDate', 'ProjectedLiveDate', 'PromotionName', 'RevenueSpreadUnit', 'Stage', 'Status', 'ThroughDate', 'Title', 'Rating', 'ClosedDate', 'AssessmentScore', 'TechnicalAssessmentScore', 'RelationshipAssessmentScore', 'PrimaryCompetitor', 'WinReason', 'LossReason', 'WinReasonDetail', 'LossReasonDetail', 'LastActivity', 'DateStamp', 'Probability', 'RevenueSpread', 'TotalAmountMonths', 'SalesProcessPercentComplete', 'SalesOrderID', 'OnetimeCost', 'OnetimeRevenue', 'MonthlyCost', 'MonthlyRevenue', 'QuarterlyCost', 'QuarterlyRevenue', 'SemiannualCost', 'SemiannualRevenue', 'YearlyCost', 'YearlyRevenue', 'BusinessDivisionSubdivisionID', 'OpportunityCategoryID', 'LostDate', 'PromisedFulfillmentDate', 'Description', 'ImpersonatorCreatorResourceID')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'AdvancedField1', 'AdvancedField2', 'AdvancedField3', 'AdvancedField4', 'AdvancedField5', 'Amount', 'Barriers', 'ContactID', 'Cost', 'CreateDate', 'HelpNeeded', 'LeadReferral', 'Market', 'NextStep', 'OwnerResourceID', 'ProductID', 'ProjectedCloseDate', 'ProjectedLiveDate', 'PromotionName', 'RevenueSpreadUnit', 'Stage', 'Status', 'ThroughDate', 'Title', 'Rating', 'ClosedDate', 'AssessmentScore', 'TechnicalAssessmentScore', 'RelationshipAssessmentScore', 'PrimaryCompetitor', 'WinReason', 'LossReason', 'WinReasonDetail', 'LossReasonDetail', 'LastActivity', 'DateStamp', 'Probability', 'RevenueSpread', 'TotalAmountMonths', 'SalesProcessPercentComplete', 'SalesOrderID', 'OnetimeCost', 'OnetimeRevenue', 'MonthlyCost', 'MonthlyRevenue', 'QuarterlyCost', 'QuarterlyRevenue', 'SemiannualCost', 'SemiannualRevenue', 'YearlyCost', 'YearlyRevenue', 'BusinessDivisionSubdivisionID', 'OpportunityCategoryID', 'LostDate', 'PromisedFulfillmentDate', 'Description', 'ImpersonatorCreatorResourceID')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'AdvancedField1', 'AdvancedField2', 'AdvancedField3', 'AdvancedField4', 'AdvancedField5', 'Amount', 'Barriers', 'ContactID', 'Cost', 'CreateDate', 'HelpNeeded', 'LeadReferral', 'Market', 'NextStep', 'OwnerResourceID', 'ProductID', 'ProjectedCloseDate', 'ProjectedLiveDate', 'PromotionName', 'RevenueSpreadUnit', 'Stage', 'Status', 'ThroughDate', 'Title', 'Rating', 'ClosedDate', 'AssessmentScore', 'TechnicalAssessmentScore', 'RelationshipAssessmentScore', 'PrimaryCompetitor', 'WinReason', 'LossReason', 'WinReasonDetail', 'LossReasonDetail', 'LastActivity', 'DateStamp', 'Probability', 'RevenueSpread', 'TotalAmountMonths', 'SalesProcessPercentComplete', 'SalesOrderID', 'OnetimeCost', 'OnetimeRevenue', 'MonthlyCost', 'MonthlyRevenue', 'QuarterlyCost', 'QuarterlyRevenue', 'SemiannualCost', 'SemiannualRevenue', 'YearlyCost', 'YearlyRevenue', 'BusinessDivisionSubdivisionID', 'OpportunityCategoryID', 'LostDate', 'PromisedFulfillmentDate', 'Description', 'ImpersonatorCreatorResourceID')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'AdvancedField1', 'AdvancedField2', 'AdvancedField3', 'AdvancedField4', 'AdvancedField5', 'Amount', 'Barriers', 'ContactID', 'Cost', 'CreateDate', 'HelpNeeded', 'LeadReferral', 'Market', 'NextStep', 'OwnerResourceID', 'ProductID', 'ProjectedCloseDate', 'ProjectedLiveDate', 'PromotionName', 'RevenueSpreadUnit', 'Stage', 'Status', 'ThroughDate', 'Title', 'Rating', 'ClosedDate', 'AssessmentScore', 'TechnicalAssessmentScore', 'RelationshipAssessmentScore', 'PrimaryCompetitor', 'WinReason', 'LossReason', 'WinReasonDetail', 'LossReasonDetail', 'LastActivity', 'DateStamp', 'Probability', 'RevenueSpread', 'TotalAmountMonths', 'SalesProcessPercentComplete', 'SalesOrderID', 'OnetimeCost', 'OnetimeRevenue', 'MonthlyCost', 'MonthlyRevenue', 'QuarterlyCost', 'QuarterlyRevenue', 'SemiannualCost', 'SemiannualRevenue', 'YearlyCost', 'YearlyRevenue', 'BusinessDivisionSubdivisionID', 'OpportunityCategoryID', 'LostDate', 'PromisedFulfillmentDate', 'Description', 'ImpersonatorCreatorResourceID')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Barriers', 'HelpNeeded', 'Market', 'NextStep', 'PromotionName', 'RevenueSpreadUnit', 'Title', 'WinReasonDetail', 'LossReasonDetail', 'Description')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Barriers', 'HelpNeeded', 'Market', 'NextStep', 'PromotionName', 'RevenueSpreadUnit', 'Title', 'WinReasonDetail', 'LossReasonDetail', 'Description')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Barriers', 'HelpNeeded', 'Market', 'NextStep', 'PromotionName', 'RevenueSpreadUnit', 'Title', 'WinReasonDetail', 'LossReasonDetail', 'Description')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Barriers', 'HelpNeeded', 'Market', 'NextStep', 'PromotionName', 'RevenueSpreadUnit', 'Title', 'WinReasonDetail', 'LossReasonDetail', 'Description')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Barriers', 'HelpNeeded', 'Market', 'NextStep', 'PromotionName', 'RevenueSpreadUnit', 'Title', 'WinReasonDetail', 'LossReasonDetail', 'Description')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'ProjectedCloseDate', 'ProjectedLiveDate', 'ThroughDate', 'ClosedDate', 'LastActivity', 'DateStamp', 'LostDate', 'PromisedFulfillmentDate')]
    [string[]]
    $IsThisDay
  )

    begin { 
        $entityName = 'Opportunity'
    
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
