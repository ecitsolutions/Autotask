#Requires -Version 4.0
#Version 1.6.2.11
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

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

Additional operators for [String] parameters are:
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
    [ValidateSet('AccountID', 'BusinessDivisionSubdivisionID', 'ContactID', 'OwnerResourceID', 'ProductID', 'SalesOrderID')]
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
    [ValidateSet('AccountNote:OpportunityID', 'AccountToDo:OpportunityID', 'AttachmentInfo:OpportunityID', 'Contract:OpportunityID', 'NotificationHistory:OpportunityID', 'Quote:OpportunityID', 'SalesOrder:OpportunityID', 'Ticket:OpportunityId')]
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

# Opportunity ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [long[]]
    $id,

# AccountObjectID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int[]]
    $AccountID,

# NumberOfUsers
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal[]]
    $AdvancedField1,

# SetupFee
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal[]]
    $AdvancedField2,

# HourlyCost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal[]]
    $AdvancedField3,

# DailyCost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal[]]
    $AdvancedField4,

# MonthlyCost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal[]]
    $AdvancedField5,

# Amount
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [decimal[]]
    $Amount,

# Barriers
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,500)]
    [string[]]
    $Barriers,

# ContactObjectID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $ContactID,

# Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [decimal[]]
    $Cost,

# CreateDate
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime[]]
    $CreateDate,

# HelpNeeded
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,500)]
    [string[]]
    $HelpNeeded,

# LeadReferralObjectID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $LeadReferral,

# Market
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,500)]
    [string[]]
    $Market,

# NextStep
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,500)]
    [string[]]
    $NextStep,

# CreatorObjectID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int[]]
    $OwnerResourceID,

# ProductObjectID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $ProductID,

# ProjClose
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime[]]
    $ProjectedCloseDate,

# StartDate
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime[]]
    $ProjectedLiveDate,

# promotion_name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string[]]
    $PromotionName,

# spread_revenue_recognition_unit
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $RevenueSpreadUnit,

# StageObjectID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $Stage,

# Status
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $Status,

# ThroughDate
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime[]]
    $ThroughDate,

# Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1,128)]
    [string[]]
    $Title,

# opportunity_rating_id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $Rating,

# Closed Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime[]]
    $ClosedDate,

# Assessment Score
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [float[]]
    $AssessmentScore,

# Technical Assessment Score
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [float[]]
    $TechnicalAssessmentScore,

# Relationship Assessment Score
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [float[]]
    $RelationshipAssessmentScore,

# Primary Competitor
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $PrimaryCompetitor,

# Win Reason
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $WinReason,

# Loss Reason
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $LossReason,

# Win Reason Detail
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,500)]
    [string[]]
    $WinReasonDetail,

# Loss Reason Detail
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,500)]
    [string[]]
    $LossReasonDetail,

# Last Activity
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime[]]
    $LastActivity,

# Date Stamp
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime[]]
    $DateStamp,

# Probability
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int[]]
    $Probability,

# Revenue Spread
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $RevenueSpread,

# Use Quote Totals
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [boolean[]]
    $UseQuoteTotals,

# Total Amount Months
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $TotalAmountMonths,

# Sales Process Percent Complete
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $SalesProcessPercentComplete,

# Sales Order ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $SalesOrderID,

# One-Time Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal[]]
    $OnetimeCost,

# One-Time Revenue
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal[]]
    $OnetimeRevenue,

# Monthly Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal[]]
    $MonthlyCost,

# Monthly Revenue
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal[]]
    $MonthlyRevenue,

# Quarterly Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal[]]
    $QuarterlyCost,

# Quarterly Revenue
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal[]]
    $QuarterlyRevenue,

# Semi-Annual Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal[]]
    $SemiannualCost,

# Semi-Annual Revenue
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal[]]
    $SemiannualRevenue,

# Yearly Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal[]]
    $YearlyCost,

# Yearly Revenue
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal[]]
    $YearlyRevenue,

# Business Division Subdivision ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $BusinessDivisionSubdivisionID,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'AdvancedField1', 'AdvancedField2', 'AdvancedField3', 'AdvancedField4', 'AdvancedField5', 'Amount', 'Barriers', 'ContactID', 'Cost', 'CreateDate', 'HelpNeeded', 'LeadReferral', 'Market', 'NextStep', 'OwnerResourceID', 'ProductID', 'ProjectedCloseDate', 'ProjectedLiveDate', 'PromotionName', 'RevenueSpreadUnit', 'Stage', 'Status', 'ThroughDate', 'Title', 'Rating', 'ClosedDate', 'AssessmentScore', 'TechnicalAssessmentScore', 'RelationshipAssessmentScore', 'PrimaryCompetitor', 'WinReason', 'LossReason', 'WinReasonDetail', 'LossReasonDetail', 'LastActivity', 'DateStamp', 'Probability', 'RevenueSpread', 'UseQuoteTotals', 'TotalAmountMonths', 'SalesProcessPercentComplete', 'SalesOrderID', 'OnetimeCost', 'OnetimeRevenue', 'MonthlyCost', 'MonthlyRevenue', 'QuarterlyCost', 'QuarterlyRevenue', 'SemiannualCost', 'SemiannualRevenue', 'YearlyCost', 'YearlyRevenue', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'AdvancedField1', 'AdvancedField2', 'AdvancedField3', 'AdvancedField4', 'AdvancedField5', 'Amount', 'Barriers', 'ContactID', 'Cost', 'CreateDate', 'HelpNeeded', 'LeadReferral', 'Market', 'NextStep', 'OwnerResourceID', 'ProductID', 'ProjectedCloseDate', 'ProjectedLiveDate', 'PromotionName', 'RevenueSpreadUnit', 'Stage', 'Status', 'ThroughDate', 'Title', 'Rating', 'ClosedDate', 'AssessmentScore', 'TechnicalAssessmentScore', 'RelationshipAssessmentScore', 'PrimaryCompetitor', 'WinReason', 'LossReason', 'WinReasonDetail', 'LossReasonDetail', 'LastActivity', 'DateStamp', 'Probability', 'RevenueSpread', 'UseQuoteTotals', 'TotalAmountMonths', 'SalesProcessPercentComplete', 'SalesOrderID', 'OnetimeCost', 'OnetimeRevenue', 'MonthlyCost', 'MonthlyRevenue', 'QuarterlyCost', 'QuarterlyRevenue', 'SemiannualCost', 'SemiannualRevenue', 'YearlyCost', 'YearlyRevenue', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'AdvancedField1', 'AdvancedField2', 'AdvancedField3', 'AdvancedField4', 'AdvancedField5', 'Amount', 'Barriers', 'ContactID', 'Cost', 'CreateDate', 'HelpNeeded', 'LeadReferral', 'Market', 'NextStep', 'OwnerResourceID', 'ProductID', 'ProjectedCloseDate', 'ProjectedLiveDate', 'PromotionName', 'RevenueSpreadUnit', 'Stage', 'Status', 'ThroughDate', 'Title', 'Rating', 'ClosedDate', 'AssessmentScore', 'TechnicalAssessmentScore', 'RelationshipAssessmentScore', 'PrimaryCompetitor', 'WinReason', 'LossReason', 'WinReasonDetail', 'LossReasonDetail', 'LastActivity', 'DateStamp', 'Probability', 'RevenueSpread', 'UseQuoteTotals', 'TotalAmountMonths', 'SalesProcessPercentComplete', 'SalesOrderID', 'OnetimeCost', 'OnetimeRevenue', 'MonthlyCost', 'MonthlyRevenue', 'QuarterlyCost', 'QuarterlyRevenue', 'SemiannualCost', 'SemiannualRevenue', 'YearlyCost', 'YearlyRevenue', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'AdvancedField1', 'AdvancedField2', 'AdvancedField3', 'AdvancedField4', 'AdvancedField5', 'Amount', 'Barriers', 'ContactID', 'Cost', 'CreateDate', 'HelpNeeded', 'LeadReferral', 'Market', 'NextStep', 'OwnerResourceID', 'ProductID', 'ProjectedCloseDate', 'ProjectedLiveDate', 'PromotionName', 'RevenueSpreadUnit', 'Stage', 'Status', 'ThroughDate', 'Title', 'Rating', 'ClosedDate', 'AssessmentScore', 'TechnicalAssessmentScore', 'RelationshipAssessmentScore', 'PrimaryCompetitor', 'WinReason', 'LossReason', 'WinReasonDetail', 'LossReasonDetail', 'LastActivity', 'DateStamp', 'Probability', 'RevenueSpread', 'TotalAmountMonths', 'SalesProcessPercentComplete', 'SalesOrderID', 'OnetimeCost', 'OnetimeRevenue', 'MonthlyCost', 'MonthlyRevenue', 'QuarterlyCost', 'QuarterlyRevenue', 'SemiannualCost', 'SemiannualRevenue', 'YearlyCost', 'YearlyRevenue', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'AdvancedField1', 'AdvancedField2', 'AdvancedField3', 'AdvancedField4', 'AdvancedField5', 'Amount', 'Barriers', 'ContactID', 'Cost', 'CreateDate', 'HelpNeeded', 'LeadReferral', 'Market', 'NextStep', 'OwnerResourceID', 'ProductID', 'ProjectedCloseDate', 'ProjectedLiveDate', 'PromotionName', 'RevenueSpreadUnit', 'Stage', 'Status', 'ThroughDate', 'Title', 'Rating', 'ClosedDate', 'AssessmentScore', 'TechnicalAssessmentScore', 'RelationshipAssessmentScore', 'PrimaryCompetitor', 'WinReason', 'LossReason', 'WinReasonDetail', 'LossReasonDetail', 'LastActivity', 'DateStamp', 'Probability', 'RevenueSpread', 'TotalAmountMonths', 'SalesProcessPercentComplete', 'SalesOrderID', 'OnetimeCost', 'OnetimeRevenue', 'MonthlyCost', 'MonthlyRevenue', 'QuarterlyCost', 'QuarterlyRevenue', 'SemiannualCost', 'SemiannualRevenue', 'YearlyCost', 'YearlyRevenue', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'AdvancedField1', 'AdvancedField2', 'AdvancedField3', 'AdvancedField4', 'AdvancedField5', 'Amount', 'Barriers', 'ContactID', 'Cost', 'CreateDate', 'HelpNeeded', 'LeadReferral', 'Market', 'NextStep', 'OwnerResourceID', 'ProductID', 'ProjectedCloseDate', 'ProjectedLiveDate', 'PromotionName', 'RevenueSpreadUnit', 'Stage', 'Status', 'ThroughDate', 'Title', 'Rating', 'ClosedDate', 'AssessmentScore', 'TechnicalAssessmentScore', 'RelationshipAssessmentScore', 'PrimaryCompetitor', 'WinReason', 'LossReason', 'WinReasonDetail', 'LossReasonDetail', 'LastActivity', 'DateStamp', 'Probability', 'RevenueSpread', 'TotalAmountMonths', 'SalesProcessPercentComplete', 'SalesOrderID', 'OnetimeCost', 'OnetimeRevenue', 'MonthlyCost', 'MonthlyRevenue', 'QuarterlyCost', 'QuarterlyRevenue', 'SemiannualCost', 'SemiannualRevenue', 'YearlyCost', 'YearlyRevenue', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'AdvancedField1', 'AdvancedField2', 'AdvancedField3', 'AdvancedField4', 'AdvancedField5', 'Amount', 'Barriers', 'ContactID', 'Cost', 'CreateDate', 'HelpNeeded', 'LeadReferral', 'Market', 'NextStep', 'OwnerResourceID', 'ProductID', 'ProjectedCloseDate', 'ProjectedLiveDate', 'PromotionName', 'RevenueSpreadUnit', 'Stage', 'Status', 'ThroughDate', 'Title', 'Rating', 'ClosedDate', 'AssessmentScore', 'TechnicalAssessmentScore', 'RelationshipAssessmentScore', 'PrimaryCompetitor', 'WinReason', 'LossReason', 'WinReasonDetail', 'LossReasonDetail', 'LastActivity', 'DateStamp', 'Probability', 'RevenueSpread', 'TotalAmountMonths', 'SalesProcessPercentComplete', 'SalesOrderID', 'OnetimeCost', 'OnetimeRevenue', 'MonthlyCost', 'MonthlyRevenue', 'QuarterlyCost', 'QuarterlyRevenue', 'SemiannualCost', 'SemiannualRevenue', 'YearlyCost', 'YearlyRevenue', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Barriers', 'HelpNeeded', 'Market', 'NextStep', 'PromotionName', 'RevenueSpreadUnit', 'Title', 'WinReasonDetail', 'LossReasonDetail')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Barriers', 'HelpNeeded', 'Market', 'NextStep', 'PromotionName', 'RevenueSpreadUnit', 'Title', 'WinReasonDetail', 'LossReasonDetail')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Barriers', 'HelpNeeded', 'Market', 'NextStep', 'PromotionName', 'RevenueSpreadUnit', 'Title', 'WinReasonDetail', 'LossReasonDetail')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Barriers', 'HelpNeeded', 'Market', 'NextStep', 'PromotionName', 'RevenueSpreadUnit', 'Title', 'WinReasonDetail', 'LossReasonDetail')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Barriers', 'HelpNeeded', 'Market', 'NextStep', 'PromotionName', 'RevenueSpreadUnit', 'Title', 'WinReasonDetail', 'LossReasonDetail')]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'ProjectedCloseDate', 'ProjectedLiveDate', 'ThroughDate', 'ClosedDate', 'LastActivity', 'DateStamp')]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'Opportunity'
    
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
