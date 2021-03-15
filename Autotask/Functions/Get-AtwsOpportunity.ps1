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
    [Collections.Generic.List[string]]
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

# AccountObjectID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[Int]]]
    $AccountID,

# NumberOfUsers
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[decimal]]]
    $AdvancedField1,

# SetupFee
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[decimal]]]
    $AdvancedField2,

# HourlyCost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[decimal]]]
    $AdvancedField3,

# DailyCost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[decimal]]]
    $AdvancedField4,

# MonthlyCost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[decimal]]]
    $AdvancedField5,

# Amount
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[decimal]]]
    $Amount,

# Assessment Score
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $AssessmentScore,

# Barriers
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [Collections.Generic.List[string]]
    $Barriers,

# Business Division Subdivision ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $BusinessDivisionSubdivisionID,

# Closed Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[datetime]]]
    $ClosedDate,

# ContactObjectID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $ContactID,

# Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[decimal]]]
    $Cost,

# CreateDate
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[datetime]]]
    $CreateDate,

# Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $CreatorResourceID,

# Date Stamp
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[datetime]]]
    $DateStamp,

# Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,8000)]
    [Collections.Generic.List[string]]
    $Description,

# HelpNeeded
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [Collections.Generic.List[string]]
    $HelpNeeded,

# Opportunity ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[long]]]
    $id,

# Impersonator Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $ImpersonatorCreatorResourceID,

# Last Activity
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[datetime]]]
    $LastActivity,

# LeadReferralObjectID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Opportunity -FieldName LeadReferral -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Opportunity -FieldName LeadReferral -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $LeadReferral,

# Loss Reason
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Opportunity -FieldName LossReason -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Opportunity -FieldName LossReason -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $LossReason,

# Loss Reason Detail
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [Collections.Generic.List[string]]
    $LossReasonDetail,

# Lost Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[datetime]]]
    $LostDate,

# Market
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [Collections.Generic.List[string]]
    $Market,

# Monthly Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[decimal]]]
    $MonthlyCost,

# Monthly Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[decimal]]]
    $MonthlyRevenue,

# NextStep
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [Collections.Generic.List[string]]
    $NextStep,

# One-Time Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[decimal]]]
    $OnetimeCost,

# One-Time Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[decimal]]]
    $OnetimeRevenue,

# Opportunity Category ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Opportunity -FieldName OpportunityCategoryID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Opportunity -FieldName OpportunityCategoryID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $OpportunityCategoryID,

# CreatorObjectID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[Int]]]
    $OwnerResourceID,

# Primary Competitor
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Opportunity -FieldName PrimaryCompetitor -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Opportunity -FieldName PrimaryCompetitor -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $PrimaryCompetitor,

# Probability
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[Int]]]
    $Probability,

# ProductObjectID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $ProductID,

# ProjClose
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[datetime]]]
    $ProjectedCloseDate,

# StartDate
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[datetime]]]
    $ProjectedLiveDate,

# Promised Fulfillment Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[datetime]]]
    $PromisedFulfillmentDate,

# promotion_name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [Collections.Generic.List[string]]
    $PromotionName,

# Quarterly Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[decimal]]]
    $QuarterlyCost,

# Quarterly Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[decimal]]]
    $QuarterlyRevenue,

# opportunity_rating_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Opportunity -FieldName Rating -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Opportunity -FieldName Rating -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $Rating,

# Relationship Assessment Score
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $RelationshipAssessmentScore,

# Revenue Spread
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $RevenueSpread,

# spread_revenue_recognition_unit
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Opportunity -FieldName RevenueSpreadUnit -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Opportunity -FieldName RevenueSpreadUnit -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $RevenueSpreadUnit,

# Sales Order ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $SalesOrderID,

# Sales Process Percent Complete
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[decimal]]]
    $SalesProcessPercentComplete,

# Semi-Annual Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[decimal]]]
    $SemiannualCost,

# Semi-Annual Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[decimal]]]
    $SemiannualRevenue,

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
      $set = Get-AtwsPicklistValue -Entity Opportunity -FieldName Stage -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
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
      $set = Get-AtwsPicklistValue -Entity Opportunity -FieldName Status -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $Status,

# Technical Assessment Score
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $TechnicalAssessmentScore,

# ThroughDate
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[datetime]]]
    $ThroughDate,

# Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,128)]
    [Collections.Generic.List[string]]
    $Title,

# Total Amount Months
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $TotalAmountMonths,

# Use Quote Totals
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[boolean]]]
    $UseQuoteTotals,

# Win Reason
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Opportunity -FieldName WinReason -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Opportunity -FieldName WinReason -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $WinReason,

# Win Reason Detail
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [Collections.Generic.List[string]]
    $WinReasonDetail,

# Yearly Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[decimal]]]
    $YearlyCost,

# Yearly Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[decimal]]]
    $YearlyRevenue,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AdvancedField3', 'PromotionName', 'ProjectedCloseDate', 'LossReasonDetail', 'OnetimeRevenue', 'SalesOrderID', 'ClosedDate', 'SemiannualCost', 'YearlyCost', 'CreatorResourceID', 'OwnerResourceID', 'RevenueSpread', 'ContactID', 'AdvancedField5', 'Probability', 'Market', 'CreateDate', 'HelpNeeded', 'LossReason', 'RelationshipAssessmentScore', 'UseQuoteTotals', 'ProductID', 'OpportunityCategoryID', 'QuarterlyCost', 'ImpersonatorCreatorResourceID', 'Status', 'MonthlyRevenue', 'WinReason', 'Barriers', 'PrimaryCompetitor', 'WinReasonDetail', 'AdvancedField4', 'NextStep', 'LastActivity', 'id', 'OnetimeCost', 'PromisedFulfillmentDate', 'SalesProcessPercentComplete', 'SemiannualRevenue', 'ThroughDate', 'Title', 'AccountID', 'DateStamp', 'YearlyRevenue', 'AdvancedField1', 'AdvancedField2', 'Amount', 'AssessmentScore', 'TotalAmountMonths', 'QuarterlyRevenue', 'Description', 'TechnicalAssessmentScore', 'LostDate', 'ProjectedLiveDate', 'BusinessDivisionSubdivisionID', 'Stage', 'MonthlyCost', 'Cost', 'LeadReferral', 'RevenueSpreadUnit', 'Rating')]
    [Collections.Generic.List[string]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AdvancedField3', 'PromotionName', 'ProjectedCloseDate', 'LossReasonDetail', 'OnetimeRevenue', 'SalesOrderID', 'ClosedDate', 'SemiannualCost', 'YearlyCost', 'CreatorResourceID', 'OwnerResourceID', 'RevenueSpread', 'ContactID', 'AdvancedField5', 'Probability', 'Market', 'CreateDate', 'HelpNeeded', 'LossReason', 'RelationshipAssessmentScore', 'UseQuoteTotals', 'ProductID', 'OpportunityCategoryID', 'QuarterlyCost', 'ImpersonatorCreatorResourceID', 'Status', 'MonthlyRevenue', 'WinReason', 'Barriers', 'PrimaryCompetitor', 'WinReasonDetail', 'AdvancedField4', 'NextStep', 'LastActivity', 'id', 'OnetimeCost', 'PromisedFulfillmentDate', 'SalesProcessPercentComplete', 'SemiannualRevenue', 'ThroughDate', 'Title', 'AccountID', 'DateStamp', 'YearlyRevenue', 'AdvancedField1', 'AdvancedField2', 'Amount', 'AssessmentScore', 'TotalAmountMonths', 'QuarterlyRevenue', 'Description', 'TechnicalAssessmentScore', 'LostDate', 'ProjectedLiveDate', 'BusinessDivisionSubdivisionID', 'Stage', 'MonthlyCost', 'Cost', 'LeadReferral', 'RevenueSpreadUnit', 'Rating')]
    [Collections.Generic.List[string]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AdvancedField3', 'PromotionName', 'ProjectedCloseDate', 'LossReasonDetail', 'OnetimeRevenue', 'SalesOrderID', 'ClosedDate', 'SemiannualCost', 'YearlyCost', 'CreatorResourceID', 'OwnerResourceID', 'RevenueSpread', 'ContactID', 'AdvancedField5', 'Probability', 'Market', 'CreateDate', 'HelpNeeded', 'LossReason', 'RelationshipAssessmentScore', 'UseQuoteTotals', 'ProductID', 'OpportunityCategoryID', 'QuarterlyCost', 'ImpersonatorCreatorResourceID', 'Status', 'MonthlyRevenue', 'WinReason', 'Barriers', 'PrimaryCompetitor', 'WinReasonDetail', 'AdvancedField4', 'NextStep', 'LastActivity', 'id', 'OnetimeCost', 'PromisedFulfillmentDate', 'SalesProcessPercentComplete', 'SemiannualRevenue', 'ThroughDate', 'Title', 'AccountID', 'DateStamp', 'YearlyRevenue', 'AdvancedField1', 'AdvancedField2', 'Amount', 'AssessmentScore', 'TotalAmountMonths', 'QuarterlyRevenue', 'Description', 'TechnicalAssessmentScore', 'LostDate', 'ProjectedLiveDate', 'BusinessDivisionSubdivisionID', 'Stage', 'MonthlyCost', 'Cost', 'LeadReferral', 'RevenueSpreadUnit', 'Rating')]
    [Collections.Generic.List[string]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'ContactID', 'ProductID', 'Stage', 'PrimaryCompetitor', 'LeadReferral', 'OwnerResourceID', 'Title', 'Status', 'ProjectedCloseDate', 'Probability', 'Amount', 'Cost', 'RevenueSpread', 'RevenueSpreadUnit', 'PromotionName', 'CreateDate', 'Market', 'Barriers', 'HelpNeeded', 'NextStep', 'ProjectedLiveDate', 'ThroughDate', 'AdvancedField1', 'AdvancedField3', 'AdvancedField4', 'AdvancedField5', 'AdvancedField2', 'Rating', 'TotalAmountMonths', 'ClosedDate', 'SalesOrderID', 'AssessmentScore', 'TechnicalAssessmentScore', 'RelationshipAssessmentScore', 'SalesProcessPercentComplete', 'WinReason', 'LossReason', 'WinReasonDetail', 'LossReasonDetail', 'LastActivity', 'DateStamp', 'OnetimeCost', 'OnetimeRevenue', 'MonthlyCost', 'MonthlyRevenue', 'QuarterlyCost', 'QuarterlyRevenue', 'SemiannualCost', 'SemiannualRevenue', 'YearlyCost', 'YearlyRevenue', 'BusinessDivisionSubdivisionID', 'OpportunityCategoryID', 'LostDate', 'PromisedFulfillmentDate', 'Description', 'ImpersonatorCreatorResourceID', 'CreatorResourceID')]
    [Collections.Generic.List[string]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'ContactID', 'ProductID', 'Stage', 'PrimaryCompetitor', 'LeadReferral', 'OwnerResourceID', 'Title', 'Status', 'ProjectedCloseDate', 'Probability', 'Amount', 'Cost', 'RevenueSpread', 'RevenueSpreadUnit', 'PromotionName', 'CreateDate', 'Market', 'Barriers', 'HelpNeeded', 'NextStep', 'ProjectedLiveDate', 'ThroughDate', 'AdvancedField1', 'AdvancedField3', 'AdvancedField4', 'AdvancedField5', 'AdvancedField2', 'Rating', 'TotalAmountMonths', 'ClosedDate', 'SalesOrderID', 'AssessmentScore', 'TechnicalAssessmentScore', 'RelationshipAssessmentScore', 'SalesProcessPercentComplete', 'WinReason', 'LossReason', 'WinReasonDetail', 'LossReasonDetail', 'LastActivity', 'DateStamp', 'OnetimeCost', 'OnetimeRevenue', 'MonthlyCost', 'MonthlyRevenue', 'QuarterlyCost', 'QuarterlyRevenue', 'SemiannualCost', 'SemiannualRevenue', 'YearlyCost', 'YearlyRevenue', 'BusinessDivisionSubdivisionID', 'OpportunityCategoryID', 'LostDate', 'PromisedFulfillmentDate', 'Description', 'ImpersonatorCreatorResourceID', 'CreatorResourceID')]
    [Collections.Generic.List[string]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'ContactID', 'ProductID', 'Stage', 'PrimaryCompetitor', 'LeadReferral', 'OwnerResourceID', 'Title', 'Status', 'ProjectedCloseDate', 'Probability', 'Amount', 'Cost', 'RevenueSpread', 'RevenueSpreadUnit', 'PromotionName', 'CreateDate', 'Market', 'Barriers', 'HelpNeeded', 'NextStep', 'ProjectedLiveDate', 'ThroughDate', 'AdvancedField1', 'AdvancedField3', 'AdvancedField4', 'AdvancedField5', 'AdvancedField2', 'Rating', 'TotalAmountMonths', 'ClosedDate', 'SalesOrderID', 'AssessmentScore', 'TechnicalAssessmentScore', 'RelationshipAssessmentScore', 'SalesProcessPercentComplete', 'WinReason', 'LossReason', 'WinReasonDetail', 'LossReasonDetail', 'LastActivity', 'DateStamp', 'OnetimeCost', 'OnetimeRevenue', 'MonthlyCost', 'MonthlyRevenue', 'QuarterlyCost', 'QuarterlyRevenue', 'SemiannualCost', 'SemiannualRevenue', 'YearlyCost', 'YearlyRevenue', 'BusinessDivisionSubdivisionID', 'OpportunityCategoryID', 'LostDate', 'PromisedFulfillmentDate', 'Description', 'ImpersonatorCreatorResourceID', 'CreatorResourceID')]
    [Collections.Generic.List[string]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'ContactID', 'ProductID', 'Stage', 'PrimaryCompetitor', 'LeadReferral', 'OwnerResourceID', 'Title', 'Status', 'ProjectedCloseDate', 'Probability', 'Amount', 'Cost', 'RevenueSpread', 'RevenueSpreadUnit', 'PromotionName', 'CreateDate', 'Market', 'Barriers', 'HelpNeeded', 'NextStep', 'ProjectedLiveDate', 'ThroughDate', 'AdvancedField1', 'AdvancedField3', 'AdvancedField4', 'AdvancedField5', 'AdvancedField2', 'Rating', 'TotalAmountMonths', 'ClosedDate', 'SalesOrderID', 'AssessmentScore', 'TechnicalAssessmentScore', 'RelationshipAssessmentScore', 'SalesProcessPercentComplete', 'WinReason', 'LossReason', 'WinReasonDetail', 'LossReasonDetail', 'LastActivity', 'DateStamp', 'OnetimeCost', 'OnetimeRevenue', 'MonthlyCost', 'MonthlyRevenue', 'QuarterlyCost', 'QuarterlyRevenue', 'SemiannualCost', 'SemiannualRevenue', 'YearlyCost', 'YearlyRevenue', 'BusinessDivisionSubdivisionID', 'OpportunityCategoryID', 'LostDate', 'PromisedFulfillmentDate', 'Description', 'ImpersonatorCreatorResourceID', 'CreatorResourceID')]
    [Collections.Generic.List[string]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Title', 'RevenueSpreadUnit', 'PromotionName', 'Market', 'Barriers', 'HelpNeeded', 'NextStep', 'WinReasonDetail', 'LossReasonDetail', 'Description')]
    [Collections.Generic.List[string]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Title', 'RevenueSpreadUnit', 'PromotionName', 'Market', 'Barriers', 'HelpNeeded', 'NextStep', 'WinReasonDetail', 'LossReasonDetail', 'Description')]
    [Collections.Generic.List[string]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Title', 'RevenueSpreadUnit', 'PromotionName', 'Market', 'Barriers', 'HelpNeeded', 'NextStep', 'WinReasonDetail', 'LossReasonDetail', 'Description')]
    [Collections.Generic.List[string]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Title', 'RevenueSpreadUnit', 'PromotionName', 'Market', 'Barriers', 'HelpNeeded', 'NextStep', 'WinReasonDetail', 'LossReasonDetail', 'Description')]
    [Collections.Generic.List[string]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Title', 'RevenueSpreadUnit', 'PromotionName', 'Market', 'Barriers', 'HelpNeeded', 'NextStep', 'WinReasonDetail', 'LossReasonDetail', 'Description')]
    [Collections.Generic.List[string]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ProjectedCloseDate', 'CreateDate', 'ProjectedLiveDate', 'ThroughDate', 'ClosedDate', 'LastActivity', 'DateStamp', 'LostDate', 'PromisedFulfillmentDate')]
    [Collections.Generic.List[string]]
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

           
            # Count the values of the first parameter passed. We will not try do to this on more than 1 parameter, nor on any 
            # other parameter than the first. This is lazy, but efficient.
            $count = $PSBoundParameters.Values[0].count

            # If the count is less than or equal to 200 we pass PSBoundParameters as is
            if ($count -le 200) {
                [collections.generic.list[string]]$Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $entityName
                $iterations.Add($Filter)
            }
            # More than 200 values. This will cause a SQL query nested too much. Break a single parameter
            # into segments and create multiple queries with max 200 values
            else {
                # Deduplicate the value list or the same ID may be included in more than 1 query
                $outerLoop = $PSBoundParameters.Values[0] | Sort-Object -Unique

                Write-Verbose ('{0}: Received {1} objects containing {2} unique values for parameter {3}' -f $MyInvocation.MyCommand.Name, $count, $outerLoop.Count, $param)

                # Make a writable copy of PSBoundParameters
                $BoundParameters = $PSBoundParameters
                for ($i = 0; $i -lt $outerLoop.count; $i += 200) {
                    $j = $i + 199
                    if ($j -ge $outerLoop.count) {
                        $j = $outerLoop.count - 1
                    }

                    # make a selection
                    $BoundParameters[$param] = $outerLoop[$i .. $j]

                    Write-Verbose ('{0}: Asking for {1} values {2} to {3}' -f $MyInvocation.MyCommand.Name, $param, $i, $j)

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
                    write-host "ERROR: " -ForegroundColor Red -NoNewline
                    write-host $_.Exception.Message
                    write-host ("{0}: {1}" -f $_.CategoryInfo.Category,$_.CategoryInfo.Reason) -ForegroundColor Cyan
                    $_.ScriptStackTrace -split '\n' | ForEach-Object {
                        Write-host "  |  " -ForegroundColor Cyan -NoNewline
                        Write-host $_
                    }
                }
                # Add response to result
                $result.AddRange($response)

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
