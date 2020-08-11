#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function New-AtwsOpportunity
{


<#
.SYNOPSIS
This function creates a new Opportunity through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.Opportunity] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the Opportunity with Id number 0 you could write 'New-AtwsOpportunity -Id 0' or you could write 'New-AtwsOpportunity -Filter {Id -eq 0}.

'New-AtwsOpportunity -Id 0,4' could be written as 'New-AtwsOpportunity -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new Opportunity you need the following required fields:
 -AccountID
 -Amount
 -Cost
 -CreateDate
 -OwnerResourceID
 -ProjectedCloseDate
 -Stage
 -Status
 -Title
 -Probability
 -UseQuoteTotals

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Opportunity]. This function outputs the Autotask.Opportunity that was created by the API.
.EXAMPLE
$result = New-AtwsOpportunity -AccountID [Value] -Amount [Value] -Cost [Value] -CreateDate [Value] -OwnerResourceID [Value] -ProjectedCloseDate [Value] -Stage [Value] -Status [Value] -Title [Value] -Probability [Value] -UseQuoteTotals [Value]
Creates a new [Autotask.Opportunity] through the Web Services API and returns the new object.
 .EXAMPLE
$result = Get-AtwsOpportunity -Id 124 | New-AtwsOpportunity 
Copies [Autotask.Opportunity] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsOpportunity -Id 124 | New-AtwsOpportunity | Set-AtwsOpportunity -ParameterName <Parameter Value>
Copies [Autotask.Opportunity] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsOpportunity to modify the object.
 .EXAMPLE
$result = Get-AtwsOpportunity -Id 124 | New-AtwsOpportunity | Set-AtwsOpportunity -ParameterName <Parameter Value> -Passthru
Copies [Autotask.Opportunity] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsOpportunity to modify the object and returns the new object.

.LINK
Get-AtwsOpportunity
 .LINK
Set-AtwsOpportunity

#>

  [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName='By_parameters', ConfirmImpact='Low')]
  Param
  (
# An array of objects to create
    [Parameter(
      ParametersetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.Opportunity[]]
    $InputObject,

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
    [string]
    $LossReason,

# Status
    [Parameter(
      Mandatory = $true,
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
    [string]
    $Status,

# Closed Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $ClosedDate,

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
    [string]
    $WinReason,

# Last Activity
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $LastActivity,

# ContactObjectID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ContactID,

# Technical Assessment Score
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $TechnicalAssessmentScore,

# One-Time Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $OnetimeCost,

# Amount
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [decimal]
    $Amount,

# CreatorObjectID
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $OwnerResourceID,

# Probability
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $Probability,

# StartDate
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $ProjectedLiveDate,

# Sales Order ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $SalesOrderID,

# ThroughDate
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $ThroughDate,

# Revenue Spread
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $RevenueSpread,

# HelpNeeded
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string]
    $HelpNeeded,

# CreateDate
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $CreateDate,

# Promised Fulfillment Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $PromisedFulfillmentDate,

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
    [string]
    $Rating,

# Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,8000)]
    [string]
    $Description,

# Quarterly Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $QuarterlyCost,

# NumberOfUsers
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $AdvancedField1,

# Date Stamp
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $DateStamp,

# Loss Reason Detail
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string]
    $LossReasonDetail,

# ProductObjectID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ProductID,

# Sales Process Percent Complete
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $SalesProcessPercentComplete,

# Barriers
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string]
    $Barriers,

# Assessment Score
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $AssessmentScore,

# Use Quote Totals
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [boolean]
    $UseQuoteTotals,

# Cost
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [decimal]
    $Cost,

# DailyCost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $AdvancedField4,

# NextStep
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string]
    $NextStep,

# Market
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string]
    $Market,

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
    [string]
    $PrimaryCompetitor,

# Lost Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $LostDate,

# AccountObjectID
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $AccountID,

# Quarterly Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $QuarterlyRevenue,

# Monthly Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $MonthlyRevenue,

# One-Time Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $OnetimeRevenue,

# Relationship Assessment Score
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $RelationshipAssessmentScore,

# Impersonator Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ImpersonatorCreatorResourceID,

# Yearly Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $YearlyCost,

# Semi-Annual Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $SemiannualRevenue,

# Business Division Subdivision ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
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
      $set = Get-AtwsPicklistValue -Entity Opportunity -FieldName OpportunityCategoryID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $OpportunityCategoryID,

# SetupFee
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $AdvancedField2,

# HourlyCost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $AdvancedField3,

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
    [string]
    $RevenueSpreadUnit,

# StageObjectID
    [Parameter(
      Mandatory = $true,
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
    [string]
    $Stage,

# Monthly Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $MonthlyCost,

# Win Reason Detail
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string]
    $WinReasonDetail,

# promotion_name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $PromotionName,

# Semi-Annual Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $SemiannualCost,

# Name
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,128)]
    [string]
    $Title,

# Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $CreatorResourceID,

# ProjClose
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $ProjectedCloseDate,

# Total Amount Months
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $TotalAmountMonths,

# Yearly Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $YearlyRevenue,

# MonthlyCost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $AdvancedField5,

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
    [string]
    $LeadReferral
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
        
        $processObject = @()
    }

    process {
    
        if ($InputObject) {
            Write-Verbose -Message ('{0}: Copy Object mode: Setting ID property to zero' -F $MyInvocation.MyCommand.Name)  

            $fields = Get-AtwsFieldInfo -Entity $entityName
      
            $CopyNo = 1

            foreach ($object in $InputObject) { 
                # Create a new object and copy properties
                $newObject = New-Object -TypeName Autotask.$entityName
        
                # Copy every non readonly property
                $fieldNames = $fields.Where( { $_.Name -ne 'id' }).Name

                if ($PSBoundParameters.ContainsKey('UserDefinedFields')) { 
                    $fieldNames += 'UserDefinedFields' 
                }

                foreach ($field in $fieldNames) { 
                    $newObject.$field = $object.$field 
                }

                if ($newObject -is [Autotask.Ticket]) {
                    Write-Verbose -Message ('{0}: Copy Object mode: Object is a Ticket. Title must be modified to avoid duplicate detection.' -F $MyInvocation.MyCommand.Name)  
                    $title = '{0} (Copy {1})' -F $newObject.Title, $CopyNo
                    $copyNo++
                    $newObject.Title = $title
                }
                $processObject += $newObject
            }   
        }
        else {
            Write-Debug -Message ('{0}: Creating empty [Autotask.{1}]' -F $MyInvocation.MyCommand.Name, $entityName) 
            $processObject += New-Object -TypeName Autotask.$entityName    
        }
        
        # Prepare shouldProcess comments
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to create {1} {2}(s). This action cannot be undone.' -F $caption, $processObject.Count, $entityName
        $verboseWarning = '{0}: About to create {1} {2}(s). This action may not be undoable. Do you want to continue?' -F $caption, $processObject.Count, $entityName

        # Lets don't and say we did!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
            
            # Process parameters and update objects with their values
            $processObject = $processObject | Update-AtwsObjectsWithParameters -BoundParameters $PSBoundParameters -EntityName $EntityName
            
            $result = Set-AtwsData -Entity $processObject -Create
        }
    }

    end {
        Write-Debug -Message ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $result.count, $entityName)
        Return $result
    }

}
