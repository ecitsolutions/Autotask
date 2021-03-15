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
 -Stage
 -OwnerResourceID
 -Title
 -Status
 -ProjectedCloseDate
 -Probability
 -Amount
 -Cost
 -UseQuoteTotals
 -CreateDate

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Opportunity]. This function outputs the Autotask.Opportunity that was created by the API.
.EXAMPLE
$result = New-AtwsOpportunity -AccountID [Value] -Stage [Value] -OwnerResourceID [Value] -Title [Value] -Status [Value] -ProjectedCloseDate [Value] -Probability [Value] -Amount [Value] -Cost [Value] -UseQuoteTotals [Value] -CreateDate [Value]
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
    [Collections.Generic.List[Autotask.Opportunity]]
    $InputObject,

# AccountObjectID
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $AccountID,

# NumberOfUsers
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $AdvancedField1,

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

# DailyCost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $AdvancedField4,

# MonthlyCost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $AdvancedField5,

# Amount
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [decimal]
    $Amount,

# Assessment Score
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $AssessmentScore,

# Barriers
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string]
    $Barriers,

# Business Division Subdivision ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $BusinessDivisionSubdivisionID,

# Closed Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $ClosedDate,

# ContactObjectID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ContactID,

# Cost
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [decimal]
    $Cost,

# CreateDate
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $CreateDate,

# Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $CreatorResourceID,

# Date Stamp
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $DateStamp,

# Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,8000)]
    [string]
    $Description,

# HelpNeeded
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string]
    $HelpNeeded,

# Impersonator Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ImpersonatorCreatorResourceID,

# Last Activity
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
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
    [string]
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
    [string]
    $LossReason,

# Loss Reason Detail
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string]
    $LossReasonDetail,

# Lost Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $LostDate,

# Market
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string]
    $Market,

# Monthly Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $MonthlyCost,

# Monthly Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $MonthlyRevenue,

# NextStep
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string]
    $NextStep,

# One-Time Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $OnetimeCost,

# One-Time Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
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
    [string]
    $OpportunityCategoryID,

# CreatorObjectID
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
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
    [string]
    $PrimaryCompetitor,

# Probability
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $Probability,

# ProductObjectID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ProductID,

# ProjClose
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $ProjectedCloseDate,

# StartDate
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $ProjectedLiveDate,

# Promised Fulfillment Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $PromisedFulfillmentDate,

# promotion_name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $PromotionName,

# Quarterly Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $QuarterlyCost,

# Quarterly Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
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
    [string]
    $Rating,

# Relationship Assessment Score
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $RelationshipAssessmentScore,

# Revenue Spread
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
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
    [string]
    $RevenueSpreadUnit,

# Sales Order ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $SalesOrderID,

# Sales Process Percent Complete
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $SalesProcessPercentComplete,

# Semi-Annual Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $SemiannualCost,

# Semi-Annual Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $SemiannualRevenue,

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

# Technical Assessment Score
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $TechnicalAssessmentScore,

# ThroughDate
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $ThroughDate,

# Name
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,128)]
    [string]
    $Title,

# Total Amount Months
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $TotalAmountMonths,

# Use Quote Totals
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [boolean]
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
    [string]
    $WinReason,

# Win Reason Detail
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string]
    $WinReasonDetail,

# Yearly Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $YearlyCost,

# Yearly Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $YearlyRevenue
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

        $processObject = [collections.generic.list[psobject]]::new()
        $result = [collections.generic.list[psobject]]::new()
    }

    process {

        if ($InputObject) {
            Write-Verbose -Message ('{0}: Copy Object mode: Setting ID property to zero' -F $MyInvocation.MyCommand.Name)

            $entityInfo = Get-AtwsFieldInfo -Entity $entityName -EntityInfo

            $CopyNo = 1

            foreach ($object in $InputObject) {
                # Create a new object and copy properties
                $newObject = New-Object -TypeName Autotask.$entityName

                # Copy every non readonly property
                $fieldNames = [collections.generic.list[psobject]]::new()
                $WriteableFields = $entityInfo.WriteableFields
                $RequiredFields = $entityInfo.RequiredFields

                if ($WriteableFields.count -gt 1) { $fieldNames.AddRange($WriteableFields) } else { $fieldNames.Add($WriteableFields) }
                if ($RequiredFields.count -gt 1) { $fieldNames.AddRange($RequiredFields) } else { $fieldNames.Add($RequiredFields) }

                if ($PSBoundParameters.ContainsKey('UserDefinedFields')) {
                    $fieldNames += 'UserDefinedFields'
                }

                foreach ($field in $fieldNames) {
                    $newObject.$field = $object.$field
                }

                if ($newObject -is [Autotask.Ticket] -and $object.id -gt 0) {
                    Write-Verbose -Message ('{0}: Copy Object mode: Object is a Ticket. Title must be modified to avoid duplicate detection.' -F $MyInvocation.MyCommand.Name)
                    $title = '{0} (Copy {1})' -F $newObject.Title, $CopyNo
                    $copyNo++
                    $newObject.Title = $title
                }
                $processObject.Add($newObject)
            }
        }
        else {
            Write-Debug -Message ('{0}: Creating empty [Autotask.{1}]' -F $MyInvocation.MyCommand.Name, $entityName)
            $processObject.add((New-Object -TypeName Autotask.$entityName))
        }

        # Prepare shouldProcess comments
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to create {1} {2}(s). This action cannot be undone.' -F $caption, $processObject.Count, $entityName
        $verboseWarning = '{0}: About to create {1} {2}(s). This action may not be undoable. Do you want to continue?' -F $caption, $processObject.Count, $entityName

        # Lets don't and say we did!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) {

            # Process parameters and update objects with their values
            $processObject = $processObject | Update-AtwsObjectsWithParameters -BoundParameters $PSBoundParameters -EntityName $EntityName

            try {
                # If using pipeline this block (process) will run once pr item in the pipeline. make sure to return them all
                $Data = Set-AtwsData -Entity $processObject -Create
                if ($Data.Count -gt 1) {
                    $result.AddRange($Data)
                }
                else {
                    $result.Add($Data)
                }
            }
            catch {
                write-host "ERROR: " -ForegroundColor Red -NoNewline
                write-host $_.Exception.Message
                write-host ("{0}: {1}" -f $_.CategoryInfo.Category, $_.CategoryInfo.Reason) -ForegroundColor Cyan
                $_.ScriptStackTrace -split '\n' | ForEach-Object {
                    Write-host "  |  " -ForegroundColor Cyan -NoNewline
                    Write-host $_
                }
            }
        }
    }

    end {
        Write-Debug -Message ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $result.count, $entityName)
        Return [array]$result
    }

}