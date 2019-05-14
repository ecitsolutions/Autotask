#Requires -Version 4.0
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

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
[Autotask.Opportunity]. This function outputs the Autotask.Opportunity that was created by the API.
.EXAMPLE
$Result = New-AtwsOpportunity -AccountID [Value] -Amount [Value] -Cost [Value] -CreateDate [Value] -OwnerResourceID [Value] -ProjectedCloseDate [Value] -Stage [Value] -Status [Value] -Title [Value] -Probability [Value] -UseQuoteTotals [Value]
Creates a new [Autotask.Opportunity] through the Web Services API and returns the new object.
 .EXAMPLE
$Result = Get-AtwsOpportunity -Id 124 | New-AtwsOpportunity 
Copies [Autotask.Opportunity] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsOpportunity -Id 124 | New-AtwsOpportunity | Set-AtwsOpportunity -ParameterName <Parameter Value>
Copies [Autotask.Opportunity] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsOpportunity to modify the object.
 .EXAMPLE
$Result = Get-AtwsOpportunity -Id 124 | New-AtwsOpportunity | Set-AtwsOpportunity -ParameterName <Parameter Value> -Passthru
Copies [Autotask.Opportunity] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsOpportunity to modify the object and returns the new object.

.LINK
Get-AtwsOpportunity
 .LINK
Set-AtwsOpportunity

#>

  [CmdLetBinding(DefaultParameterSetName='By_parameters', ConfirmImpact='Low')]
  Param
  (
# An array of objects to create
    [Parameter(
      ParameterSetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.Opportunity[]]
    $InputObject,

# AccountObjectID
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $AccountID,

# NumberOfUsers
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal]
    $AdvancedField1,

# SetupFee
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal]
    $AdvancedField2,

# HourlyCost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal]
    $AdvancedField3,

# DailyCost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal]
    $AdvancedField4,

# MonthlyCost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal]
    $AdvancedField5,

# Amount
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [decimal]
    $Amount,

# Barriers
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,500)]
    [string]
    $Barriers,

# ContactObjectID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $ContactID,

# Cost
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [decimal]
    $Cost,

# CreateDate
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $CreateDate,

# HelpNeeded
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,500)]
    [string]
    $HelpNeeded,

# LeadReferralObjectID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $LeadReferral,

# Market
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,500)]
    [string]
    $Market,

# NextStep
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,500)]
    [string]
    $NextStep,

# CreatorObjectID
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $OwnerResourceID,

# ProductObjectID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $ProductID,

# ProjClose
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $ProjectedCloseDate,

# StartDate
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $ProjectedLiveDate,

# promotion_name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string]
    $PromotionName,

# spread_revenue_recognition_unit
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $RevenueSpreadUnit,

# StageObjectID
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String]
    $Stage,

# Status
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String]
    $Status,

# ThroughDate
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $ThroughDate,

# Description
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1,128)]
    [string]
    $Title,

# opportunity_rating_id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $Rating,

# Closed Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $ClosedDate,

# Assessment Score
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [float]
    $AssessmentScore,

# Technical Assessment Score
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [float]
    $TechnicalAssessmentScore,

# Relationship Assessment Score
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [float]
    $RelationshipAssessmentScore,

# Primary Competitor
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $PrimaryCompetitor,

# Win Reason
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $WinReason,

# Loss Reason
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $LossReason,

# Win Reason Detail
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,500)]
    [string]
    $WinReasonDetail,

# Loss Reason Detail
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,500)]
    [string]
    $LossReasonDetail,

# Last Activity
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $LastActivity,

# Date Stamp
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $DateStamp,

# Probability
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $Probability,

# Revenue Spread
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $RevenueSpread,

# Use Quote Totals
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [boolean]
    $UseQuoteTotals,

# Total Amount Months
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $TotalAmountMonths,

# Sales Process Percent Complete
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $SalesProcessPercentComplete,

# Sales Order ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $SalesOrderID,

# One-Time Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal]
    $OnetimeCost,

# One-Time Revenue
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal]
    $OnetimeRevenue,

# Monthly Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal]
    $MonthlyCost,

# Monthly Revenue
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal]
    $MonthlyRevenue,

# Quarterly Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal]
    $QuarterlyCost,

# Quarterly Revenue
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal]
    $QuarterlyRevenue,

# Semi-Annual Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal]
    $SemiannualCost,

# Semi-Annual Revenue
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal]
    $SemiannualRevenue,

# Yearly Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal]
    $YearlyCost,

# Yearly Revenue
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [decimal]
    $YearlyRevenue,

# Business Division Subdivision ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $BusinessDivisionSubdivisionID
  )
 
  Begin
  { 
    $EntityName = 'Opportunity'
           
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
    $ProcessObject = @()
    
    # Set up TimeZone offset handling
    If (-not($script:ESToffset))
    {
      $Now = Get-Date
      $ESTzone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Eastern Standard Time")
      $ESTtime = [System.TimeZoneInfo]::ConvertTimeFromUtc($Now.ToUniversalTime(), $ESTzone)

      $script:ESToffset = (New-TimeSpan -Start $ESTtime -End $Now).TotalHours
    }

  }

  Process
  {
    $Fields = Get-AtwsFieldInfo -Entity $EntityName
    
    If ($InputObject)
    {
      Write-Verbose ('{0}: Copy Object mode: Setting ID property to zero' -F $MyInvocation.MyCommand.Name)  
      
      $CopyNo = 1

      Foreach ($Object in $InputObject) 
      { 
        # Create a new object and copy properties
        $NewObject = New-Object Autotask.$EntityName
        
        # Copy every non readonly property
        $FieldNames = $Fields.Where({$_.Name -ne 'id'}).Name
        If ($PSBoundParameters.ContainsKey('UserDefinedFields')) {
          $FieldNames += 'UserDefinedFields'
        }
        Foreach ($Field in $FieldNames)
        {
          $NewObject.$Field = $Object.$Field
        }
        If ($NewObject -is [Autotask.Ticket])
        {
          Write-Verbose ('{0}: Copy Object mode: Object is a Ticket. Title must be modified to avoid duplicate detection.' -F $MyInvocation.MyCommand.Name)  
          $Title = '{0} (Copy {1})' -F $NewObject.Title, $CopyNo
          $CopyNo++
          $NewObject.Title = $Title
        }
        $ProcessObject += $NewObject
      }   
    }
    Else
    {
      Write-Debug ('{0}: Creating empty [Autotask.{1}]' -F $MyInvocation.MyCommand.Name, $EntityName) 
      $ProcessObject += New-Object Autotask.$EntityName    
    }
    
    Foreach ($Parameter in $PSBoundParameters.GetEnumerator())
    {
      $Field = $Fields | Where-Object {$_.Name -eq $Parameter.Key}
      If ($Field -or $Parameter.Key -eq 'UserDefinedFields')
      { 
        If ($Field.IsPickList)
        {
          If($Field.PickListParentValueField)
          {
            $ParentField = $Fields.Where{$_.Name -eq $Field.PickListParentValueField}
            $ParentLabel = $PSBoundParameters.$($ParentField.Name)
            $ParentValue = $ParentField.PickListValues | Where-Object {$_.Label -eq $ParentLabel}
            $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $Parameter.Value -and $_.ParentValue -eq $ParentValue.Value}                
          }
          Else 
          { 
            $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $Parameter.Value}
          }
          $Value = $PickListValue.Value
        }
        ElseIf ($Field.Type -eq 'datetime')
        {
          $TimePresent = $Parameter.Value.Hour -gt 0 -or $Parameter.Value.Minute -gt 0 -or $Parameter.Value.Second -gt 0 -or $Parameter.Value.Millisecond -gt 0 
          
          If ($Field.Name -like "*DateTime" -or $TimePresent) 
          { 
            # Yes, you really have to ADD the difference
            $Value = $Parameter.Value.AddHours($script:ESToffset)
          }  
          Else 
          {
            $Value = $Parameter.Value
          }      
        }
        Else
        {
          $Value = $Parameter.Value
        } 

        Foreach ($Object in $ProcessObject) 
        { 
          $Object.$($Parameter.Key) = $Value
        }
      }
    }
    $Result = New-AtwsData -Entity $ProcessObject
    
    # The API documentation explicitly states that you can only use the objects returned 
    # by the .create() function to get the new objects ID.
    # so to return objects with accurately represents what has been created we have to 
    # get them again by id
    # But not all objects support queries, for instance service adjustments
    $EntityInfo = Get-AtwsFieldInfo -Entity $EntityName -EntityInfo
    
    If ($EntityInfo.CanQuery)
    { 
      $NewObjectFilter = 'id -eq {0}' -F ($Result.Id -join ' -or id -eq ')
      $Result = Get-AtwsData -Entity $EntityName -Filter $NewObjectFilter
    }
  }

  End
  {
    Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

    If ($PSCmdLet.ParameterSetName -eq 'Input_Object')
    {
      # Verify copy mode
      Foreach ($Object in $Result)
      {
        If ($InputObject.Id -contains $Object.Id)
        {
          Write-Warning ('{0}: Autotask detected new object as duplicate of {1} with Id {2} and tried to update object, not create a new copy. ' -F $MyInvocation.MyCommand.Name, $EntityName, $Object.Id)
        }
      }
    }

    Return $Result
  }


}
