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
Stage
PrimaryCompetitor
LeadReferral
Status
RevenueSpreadUnit
Rating
WinReason
LossReason
OpportunityCategoryID

Entities that have fields that refer to the base entity of this CmdLet:


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
Get-AtwsOpportunity -Stage <PickList Label>
Returns any Opportunitys with property Stage equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsOpportunity -Stage <PickList Label> -NotEquals Stage 
Returns any Opportunitys with property Stage NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsOpportunity -Stage <PickList Label1>, <PickList Label2>
Returns any Opportunitys with property Stage equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsOpportunity -Stage <PickList Label1>, <PickList Label2> -NotEquals Stage
Returns any Opportunitys with property Stage NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsOpportunity -Id 1234 -OpportunityName SomeName* -Stage <PickList Label1>, <PickList Label2> -Like OpportunityName -NotEquals Stage -GreaterThan Id
An example of a more complex query. This command returns any Opportunitys with Id GREATER THAN 1234, a OpportunityName that matches the simple pattern SomeName* AND that has a Stage that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.NOTES
Related commands:
New-AtwsOpportunity
 Set-AtwsOpportunity

#>

  [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName='Filter', ConfirmImpact='None',
  HelpURI='https://github.com/ecitsolutions/Autotask/blob/master/Docs/Get-AtwsOpportunity.md')]
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
    [ValidateSet('AccountID', 'BusinessDivisionSubdivisionID', 'ContactID', 'CreatorResourceID', 'ImpersonatorCreatorResourceID', 'OwnerResourceID', 'ProductID', 'SalesOrderID')]
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

# Assessment Score
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $AssessmentScore,

# Barriers
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string[]]
    $Barriers,

# Business Division Subdivision ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BusinessDivisionSubdivisionID,

# Closed Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ClosedDate,

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

# Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CreatorResourceID,

# Date Stamp
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $DateStamp,

# Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,8000)]
    [string[]]
    $Description,

# HelpNeeded
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string[]]
    $HelpNeeded,

# Opportunity ID
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

# Last Activity
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LastActivity,

# LeadReferralObjectID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Opportunity -FieldName LeadReferral -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Opportunity -FieldName LeadReferral -Label) + (Get-AtwsPicklistValue -Entity Opportunity -FieldName LeadReferral -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $LeadReferral,

# Loss Reason
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Opportunity -FieldName LossReason -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Opportunity -FieldName LossReason -Label) + (Get-AtwsPicklistValue -Entity Opportunity -FieldName LossReason -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $LossReason,

# Loss Reason Detail
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string[]]
    $LossReasonDetail,

# Lost Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LostDate,

# Market
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string[]]
    $Market,

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

# NextStep
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string[]]
    $NextStep,

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

# Opportunity Category ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Opportunity -FieldName OpportunityCategoryID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Opportunity -FieldName OpportunityCategoryID -Label) + (Get-AtwsPicklistValue -Entity Opportunity -FieldName OpportunityCategoryID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $OpportunityCategoryID,

# CreatorObjectID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $OwnerResourceID,

# Primary Competitor
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Opportunity -FieldName PrimaryCompetitor -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Opportunity -FieldName PrimaryCompetitor -Label) + (Get-AtwsPicklistValue -Entity Opportunity -FieldName PrimaryCompetitor -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $PrimaryCompetitor,

# Probability
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $Probability,

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

# Promised Fulfillment Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $PromisedFulfillmentDate,

# promotion_name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $PromotionName,

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

# opportunity_rating_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Opportunity -FieldName Rating -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Opportunity -FieldName Rating -Label) + (Get-AtwsPicklistValue -Entity Opportunity -FieldName Rating -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $Rating,

# Relationship Assessment Score
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $RelationshipAssessmentScore,

# Revenue Spread
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $RevenueSpread,

# spread_revenue_recognition_unit
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Opportunity -FieldName RevenueSpreadUnit -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Opportunity -FieldName RevenueSpreadUnit -Label) + (Get-AtwsPicklistValue -Entity Opportunity -FieldName RevenueSpreadUnit -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $RevenueSpreadUnit,

# Sales Order ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $SalesOrderID,

# Sales Process Percent Complete
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $SalesProcessPercentComplete,

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

# StageObjectID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Opportunity -FieldName Stage -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Opportunity -FieldName Stage -Label) + (Get-AtwsPicklistValue -Entity Opportunity -FieldName Stage -Value)
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
      Get-AtwsPicklistValue -Entity Opportunity -FieldName Status -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Opportunity -FieldName Status -Label) + (Get-AtwsPicklistValue -Entity Opportunity -FieldName Status -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $Status,

# Technical Assessment Score
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $TechnicalAssessmentScore,

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

# Total Amount Months
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $TotalAmountMonths,

# Use Quote Totals
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $UseQuoteTotals,

# Win Reason
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Opportunity -FieldName WinReason -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Opportunity -FieldName WinReason -Label) + (Get-AtwsPicklistValue -Entity Opportunity -FieldName WinReason -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $WinReason,

# Win Reason Detail
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string[]]
    $WinReasonDetail,

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

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AdvancedField1', 'AdvancedField2', 'AdvancedField3', 'AdvancedField4', 'AdvancedField5', 'Amount', 'AssessmentScore', 'Barriers', 'BusinessDivisionSubdivisionID', 'ClosedDate', 'ContactID', 'Cost', 'CreateDate', 'CreatorResourceID', 'DateStamp', 'Description', 'HelpNeeded', 'id', 'ImpersonatorCreatorResourceID', 'LastActivity', 'LeadReferral', 'LossReason', 'LossReasonDetail', 'LostDate', 'Market', 'MonthlyCost', 'MonthlyRevenue', 'NextStep', 'OnetimeCost', 'OnetimeRevenue', 'OpportunityCategoryID', 'OwnerResourceID', 'PrimaryCompetitor', 'Probability', 'ProductID', 'ProjectedCloseDate', 'ProjectedLiveDate', 'PromisedFulfillmentDate', 'PromotionName', 'QuarterlyCost', 'QuarterlyRevenue', 'Rating', 'RelationshipAssessmentScore', 'RevenueSpread', 'RevenueSpreadUnit', 'SalesOrderID', 'SalesProcessPercentComplete', 'SemiannualCost', 'SemiannualRevenue', 'Stage', 'Status', 'TechnicalAssessmentScore', 'ThroughDate', 'Title', 'TotalAmountMonths', 'UseQuoteTotals', 'WinReason', 'WinReasonDetail', 'YearlyCost', 'YearlyRevenue')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AdvancedField1', 'AdvancedField2', 'AdvancedField3', 'AdvancedField4', 'AdvancedField5', 'Amount', 'AssessmentScore', 'Barriers', 'BusinessDivisionSubdivisionID', 'ClosedDate', 'ContactID', 'Cost', 'CreateDate', 'CreatorResourceID', 'DateStamp', 'Description', 'HelpNeeded', 'id', 'ImpersonatorCreatorResourceID', 'LastActivity', 'LeadReferral', 'LossReason', 'LossReasonDetail', 'LostDate', 'Market', 'MonthlyCost', 'MonthlyRevenue', 'NextStep', 'OnetimeCost', 'OnetimeRevenue', 'OpportunityCategoryID', 'OwnerResourceID', 'PrimaryCompetitor', 'Probability', 'ProductID', 'ProjectedCloseDate', 'ProjectedLiveDate', 'PromisedFulfillmentDate', 'PromotionName', 'QuarterlyCost', 'QuarterlyRevenue', 'Rating', 'RelationshipAssessmentScore', 'RevenueSpread', 'RevenueSpreadUnit', 'SalesOrderID', 'SalesProcessPercentComplete', 'SemiannualCost', 'SemiannualRevenue', 'Stage', 'Status', 'TechnicalAssessmentScore', 'ThroughDate', 'Title', 'TotalAmountMonths', 'UseQuoteTotals', 'WinReason', 'WinReasonDetail', 'YearlyCost', 'YearlyRevenue')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AdvancedField1', 'AdvancedField2', 'AdvancedField3', 'AdvancedField4', 'AdvancedField5', 'Amount', 'AssessmentScore', 'Barriers', 'BusinessDivisionSubdivisionID', 'ClosedDate', 'ContactID', 'Cost', 'CreateDate', 'CreatorResourceID', 'DateStamp', 'Description', 'HelpNeeded', 'id', 'ImpersonatorCreatorResourceID', 'LastActivity', 'LeadReferral', 'LossReason', 'LossReasonDetail', 'LostDate', 'Market', 'MonthlyCost', 'MonthlyRevenue', 'NextStep', 'OnetimeCost', 'OnetimeRevenue', 'OpportunityCategoryID', 'OwnerResourceID', 'PrimaryCompetitor', 'Probability', 'ProductID', 'ProjectedCloseDate', 'ProjectedLiveDate', 'PromisedFulfillmentDate', 'PromotionName', 'QuarterlyCost', 'QuarterlyRevenue', 'Rating', 'RelationshipAssessmentScore', 'RevenueSpread', 'RevenueSpreadUnit', 'SalesOrderID', 'SalesProcessPercentComplete', 'SemiannualCost', 'SemiannualRevenue', 'Stage', 'Status', 'TechnicalAssessmentScore', 'ThroughDate', 'Title', 'TotalAmountMonths', 'UseQuoteTotals', 'WinReason', 'WinReasonDetail', 'YearlyCost', 'YearlyRevenue')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AdvancedField1', 'AdvancedField2', 'AdvancedField3', 'AdvancedField4', 'AdvancedField5', 'Amount', 'AssessmentScore', 'Barriers', 'BusinessDivisionSubdivisionID', 'ClosedDate', 'ContactID', 'Cost', 'CreateDate', 'CreatorResourceID', 'DateStamp', 'Description', 'HelpNeeded', 'id', 'ImpersonatorCreatorResourceID', 'LastActivity', 'LeadReferral', 'LossReason', 'LossReasonDetail', 'LostDate', 'Market', 'MonthlyCost', 'MonthlyRevenue', 'NextStep', 'OnetimeCost', 'OnetimeRevenue', 'OpportunityCategoryID', 'OwnerResourceID', 'PrimaryCompetitor', 'Probability', 'ProductID', 'ProjectedCloseDate', 'ProjectedLiveDate', 'PromisedFulfillmentDate', 'PromotionName', 'QuarterlyCost', 'QuarterlyRevenue', 'Rating', 'RelationshipAssessmentScore', 'RevenueSpread', 'RevenueSpreadUnit', 'SalesOrderID', 'SalesProcessPercentComplete', 'SemiannualCost', 'SemiannualRevenue', 'Stage', 'Status', 'TechnicalAssessmentScore', 'ThroughDate', 'Title', 'TotalAmountMonths', 'UserDefinedField', 'WinReason', 'WinReasonDetail', 'YearlyCost', 'YearlyRevenue')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AdvancedField1', 'AdvancedField2', 'AdvancedField3', 'AdvancedField4', 'AdvancedField5', 'Amount', 'AssessmentScore', 'Barriers', 'BusinessDivisionSubdivisionID', 'ClosedDate', 'ContactID', 'Cost', 'CreateDate', 'CreatorResourceID', 'DateStamp', 'Description', 'HelpNeeded', 'id', 'ImpersonatorCreatorResourceID', 'LastActivity', 'LeadReferral', 'LossReason', 'LossReasonDetail', 'LostDate', 'Market', 'MonthlyCost', 'MonthlyRevenue', 'NextStep', 'OnetimeCost', 'OnetimeRevenue', 'OpportunityCategoryID', 'OwnerResourceID', 'PrimaryCompetitor', 'Probability', 'ProductID', 'ProjectedCloseDate', 'ProjectedLiveDate', 'PromisedFulfillmentDate', 'PromotionName', 'QuarterlyCost', 'QuarterlyRevenue', 'Rating', 'RelationshipAssessmentScore', 'RevenueSpread', 'RevenueSpreadUnit', 'SalesOrderID', 'SalesProcessPercentComplete', 'SemiannualCost', 'SemiannualRevenue', 'Stage', 'Status', 'TechnicalAssessmentScore', 'ThroughDate', 'Title', 'TotalAmountMonths', 'UserDefinedField', 'WinReason', 'WinReasonDetail', 'YearlyCost', 'YearlyRevenue')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AdvancedField1', 'AdvancedField2', 'AdvancedField3', 'AdvancedField4', 'AdvancedField5', 'Amount', 'AssessmentScore', 'Barriers', 'BusinessDivisionSubdivisionID', 'ClosedDate', 'ContactID', 'Cost', 'CreateDate', 'CreatorResourceID', 'DateStamp', 'Description', 'HelpNeeded', 'id', 'ImpersonatorCreatorResourceID', 'LastActivity', 'LeadReferral', 'LossReason', 'LossReasonDetail', 'LostDate', 'Market', 'MonthlyCost', 'MonthlyRevenue', 'NextStep', 'OnetimeCost', 'OnetimeRevenue', 'OpportunityCategoryID', 'OwnerResourceID', 'PrimaryCompetitor', 'Probability', 'ProductID', 'ProjectedCloseDate', 'ProjectedLiveDate', 'PromisedFulfillmentDate', 'PromotionName', 'QuarterlyCost', 'QuarterlyRevenue', 'Rating', 'RelationshipAssessmentScore', 'RevenueSpread', 'RevenueSpreadUnit', 'SalesOrderID', 'SalesProcessPercentComplete', 'SemiannualCost', 'SemiannualRevenue', 'Stage', 'Status', 'TechnicalAssessmentScore', 'ThroughDate', 'Title', 'TotalAmountMonths', 'UserDefinedField', 'WinReason', 'WinReasonDetail', 'YearlyCost', 'YearlyRevenue')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AdvancedField1', 'AdvancedField2', 'AdvancedField3', 'AdvancedField4', 'AdvancedField5', 'Amount', 'AssessmentScore', 'Barriers', 'BusinessDivisionSubdivisionID', 'ClosedDate', 'ContactID', 'Cost', 'CreateDate', 'CreatorResourceID', 'DateStamp', 'Description', 'HelpNeeded', 'id', 'ImpersonatorCreatorResourceID', 'LastActivity', 'LeadReferral', 'LossReason', 'LossReasonDetail', 'LostDate', 'Market', 'MonthlyCost', 'MonthlyRevenue', 'NextStep', 'OnetimeCost', 'OnetimeRevenue', 'OpportunityCategoryID', 'OwnerResourceID', 'PrimaryCompetitor', 'Probability', 'ProductID', 'ProjectedCloseDate', 'ProjectedLiveDate', 'PromisedFulfillmentDate', 'PromotionName', 'QuarterlyCost', 'QuarterlyRevenue', 'Rating', 'RelationshipAssessmentScore', 'RevenueSpread', 'RevenueSpreadUnit', 'SalesOrderID', 'SalesProcessPercentComplete', 'SemiannualCost', 'SemiannualRevenue', 'Stage', 'Status', 'TechnicalAssessmentScore', 'ThroughDate', 'Title', 'TotalAmountMonths', 'UserDefinedField', 'WinReason', 'WinReasonDetail', 'YearlyCost', 'YearlyRevenue')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Barriers', 'Description', 'HelpNeeded', 'LossReasonDetail', 'Market', 'NextStep', 'PromotionName', 'RevenueSpreadUnit', 'Title', 'UserDefinedField', 'WinReasonDetail')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Barriers', 'Description', 'HelpNeeded', 'LossReasonDetail', 'Market', 'NextStep', 'PromotionName', 'RevenueSpreadUnit', 'Title', 'UserDefinedField', 'WinReasonDetail')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Barriers', 'Description', 'HelpNeeded', 'LossReasonDetail', 'Market', 'NextStep', 'PromotionName', 'RevenueSpreadUnit', 'Title', 'UserDefinedField', 'WinReasonDetail')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Barriers', 'Description', 'HelpNeeded', 'LossReasonDetail', 'Market', 'NextStep', 'PromotionName', 'RevenueSpreadUnit', 'Title', 'UserDefinedField', 'WinReasonDetail')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Barriers', 'Description', 'HelpNeeded', 'LossReasonDetail', 'Market', 'NextStep', 'PromotionName', 'RevenueSpreadUnit', 'Title', 'UserDefinedField', 'WinReasonDetail')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ClosedDate', 'CreateDate', 'DateStamp', 'LastActivity', 'LostDate', 'ProjectedCloseDate', 'ProjectedLiveDate', 'PromisedFulfillmentDate', 'ThroughDate', 'UserDefinedField')]
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
