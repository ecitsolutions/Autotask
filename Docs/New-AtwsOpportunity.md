---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# New-AtwsOpportunity

## SYNOPSIS
This function creates a new Opportunity through the Autotask Web Services API.
All required properties are marked as required parameters to assist you on the command line.

## SYNTAX

### By_parameters (Default)
```
New-AtwsOpportunity [-UserDefinedFields <UserDefinedField[]>] -AccountID <Int32> [-AdvancedField1 <Decimal>]
 [-AdvancedField2 <Decimal>] [-AdvancedField3 <Decimal>] [-AdvancedField4 <Decimal>]
 [-AdvancedField5 <Decimal>] -Amount <Decimal> [-AssessmentScore <Double>] [-Barriers <String>]
 [-BusinessDivisionSubdivisionID <Int32>] [-ClosedDate <DateTime>] [-ContactID <Int32>] -Cost <Decimal>
 -CreateDate <DateTime> [-CreatorResourceID <Int32>] [-DateStamp <DateTime>] [-Description <String>]
 [-HelpNeeded <String>] [-ImpersonatorCreatorResourceID <Int32>] [-LastActivity <DateTime>]
 [-LeadReferral <String>] [-LossReason <String>] [-LossReasonDetail <String>] [-LostDate <DateTime>]
 [-Market <String>] [-MonthlyCost <Decimal>] [-MonthlyRevenue <Decimal>] [-NextStep <String>]
 [-OnetimeCost <Decimal>] [-OnetimeRevenue <Decimal>] [-OpportunityCategoryID <String>]
 -OwnerResourceID <Int32> [-PrimaryCompetitor <String>] -Probability <Int32> [-ProductID <Int32>]
 -ProjectedCloseDate <DateTime> [-ProjectedLiveDate <DateTime>] [-PromisedFulfillmentDate <DateTime>]
 [-PromotionName <String>] [-QuarterlyCost <Decimal>] [-QuarterlyRevenue <Decimal>] [-Rating <String>]
 [-RelationshipAssessmentScore <Double>] [-RevenueSpread <Int32>] [-RevenueSpreadUnit <String>]
 [-SalesOrderID <Int32>] [-SalesProcessPercentComplete <Decimal>] [-SemiannualCost <Decimal>]
 [-SemiannualRevenue <Decimal>] -Stage <String> -Status <String> [-TechnicalAssessmentScore <Double>]
 [-ThroughDate <DateTime>] -Title <String> [-TotalAmountMonths <Int32>] -UseQuoteTotals <Boolean>
 [-WinReason <String>] [-WinReasonDetail <String>] [-YearlyCost <Decimal>] [-YearlyRevenue <Decimal>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### Input_Object
```
New-AtwsOpportunity [-InputObject <Opportunity[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The function supports all properties of an \[Autotask.Opportunity\] that can be updated through the Web Services API.
The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values.
Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter.
To get the Opportunity with Id number 0 you could write 'New-AtwsOpportunity -Id 0' or you could write 'New-AtwsOpportunity -Filter {Id -eq 0}.

'New-AtwsOpportunity -Id 0,4' could be written as 'New-AtwsOpportunity -Filter {id -eq 0 -or id -eq 4}'.
For simple queries you can see that using parameters is much easier than the -Filter option.
But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday).
As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

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

## EXAMPLES

### EXAMPLE 1
```
$result = New-AtwsOpportunity -AccountID [Value] -Stage [Value] -OwnerResourceID [Value] -Title [Value] -Status [Value] -ProjectedCloseDate [Value] -Probability [Value] -Amount [Value] -Cost [Value] -UseQuoteTotals [Value] -CreateDate [Value]
Creates a new [Autotask.Opportunity] through the Web Services API and returns the new object.
```

### EXAMPLE 2
```
$result = Get-AtwsOpportunity -Id 124 | New-AtwsOpportunity 
Copies [Autotask.Opportunity] by Id 124 to a new object through the Web Services API and returns the new object.
```

### EXAMPLE 3
```
Copies [Autotask.Opportunity] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsOpportunity to modify the object.
```

### EXAMPLE 4
```
-Passthru
Copies [Autotask.Opportunity] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsOpportunity to modify the object and returns the new object.
```

## PARAMETERS

### -InputObject
An array of objects to create

```yaml
Type: Opportunity[]
Parameter Sets: Input_Object
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -UserDefinedFields
User defined fields already setup i Autotask

```yaml
Type: UserDefinedField[]
Parameter Sets: By_parameters
Aliases: UDF

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccountID
AccountObjectID

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdvancedField1
NumberOfUsers

```yaml
Type: Decimal
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdvancedField2
SetupFee

```yaml
Type: Decimal
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdvancedField3
HourlyCost

```yaml
Type: Decimal
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdvancedField4
DailyCost

```yaml
Type: Decimal
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdvancedField5
MonthlyCost

```yaml
Type: Decimal
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Amount
Amount

```yaml
Type: Decimal
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssessmentScore
Assessment Score

```yaml
Type: Double
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Barriers
Barriers

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BusinessDivisionSubdivisionID
Business Division Subdivision ID

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClosedDate
Closed Date

```yaml
Type: DateTime
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContactID
ContactObjectID

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Cost
Cost

```yaml
Type: Decimal
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreateDate
CreateDate

```yaml
Type: DateTime
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreatorResourceID
Creator Resource ID

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DateStamp
Date Stamp

```yaml
Type: DateTime
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Description

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HelpNeeded
HelpNeeded

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ImpersonatorCreatorResourceID
Impersonator Creator Resource ID

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -LastActivity
Last Activity

```yaml
Type: DateTime
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LeadReferral
LeadReferralObjectID

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LossReason
Loss Reason

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LossReasonDetail
Loss Reason Detail

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LostDate
Lost Date

```yaml
Type: DateTime
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Market
Market

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MonthlyCost
Monthly Cost

```yaml
Type: Decimal
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -MonthlyRevenue
Monthly Revenue

```yaml
Type: Decimal
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -NextStep
NextStep

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OnetimeCost
One-Time Cost

```yaml
Type: Decimal
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -OnetimeRevenue
One-Time Revenue

```yaml
Type: Decimal
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -OpportunityCategoryID
Opportunity Category ID

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OwnerResourceID
CreatorObjectID

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrimaryCompetitor
Primary Competitor

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Probability
Probability

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProductID
ProductObjectID

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProjectedCloseDate
ProjClose

```yaml
Type: DateTime
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProjectedLiveDate
StartDate

```yaml
Type: DateTime
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PromisedFulfillmentDate
Promised Fulfillment Date

```yaml
Type: DateTime
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PromotionName
promotion_name

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -QuarterlyCost
Quarterly Cost

```yaml
Type: Decimal
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -QuarterlyRevenue
Quarterly Revenue

```yaml
Type: Decimal
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Rating
opportunity_rating_id

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RelationshipAssessmentScore
Relationship Assessment Score

```yaml
Type: Double
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -RevenueSpread
Revenue Spread

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -RevenueSpreadUnit
spread_revenue_recognition_unit

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SalesOrderID
Sales Order ID

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -SalesProcessPercentComplete
Sales Process Percent Complete

```yaml
Type: Decimal
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -SemiannualCost
Semi-Annual Cost

```yaml
Type: Decimal
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -SemiannualRevenue
Semi-Annual Revenue

```yaml
Type: Decimal
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Stage
StageObjectID

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Status
Status

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TechnicalAssessmentScore
Technical Assessment Score

```yaml
Type: Double
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ThroughDate
ThroughDate

```yaml
Type: DateTime
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title
Name

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TotalAmountMonths
Total Amount Months

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseQuoteTotals
Use Quote Totals

```yaml
Type: Boolean
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WinReason
Win Reason

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WinReasonDetail
Win Reason Detail

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -YearlyCost
Yearly Cost

```yaml
Type: Decimal
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -YearlyRevenue
Yearly Revenue

```yaml
Type: Decimal
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Nothing. This function only takes parameters.
## OUTPUTS

### [Autotask.Opportunity]. This function outputs the Autotask.Opportunity that was created by the API.
## NOTES
Related commands:
Get-AtwsOpportunity
 Set-AtwsOpportunity

## RELATED LINKS
