---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# Set-AtwsOpportunity

## SYNOPSIS
This function sets parameters on the Opportunity specified by the -InputObject parameter or pipeline through the use of the Autotask Web Services API.
Any property of the Opportunity that is not marked as READ ONLY by Autotask can be speficied with a parameter.
You can specify multiple paramters.

## SYNTAX

### InputObject (Default)
```
Set-AtwsOpportunity [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Input_Object
```
Set-AtwsOpportunity [-InputObject <Opportunity[]>] [-PassThru] [-UserDefinedFields <UserDefinedField[]>]
 [-AccountID <Int32>] [-AdvancedField1 <Decimal>] [-AdvancedField2 <Decimal>] [-AdvancedField3 <Decimal>]
 [-AdvancedField4 <Decimal>] [-AdvancedField5 <Decimal>] [-Amount <Decimal>] [-Barriers <String>]
 [-BusinessDivisionSubdivisionID <Int32>] [-ClosedDate <DateTime>] [-ContactID <Int32>] [-Cost <Decimal>]
 [-CreateDate <DateTime>] [-Description <String>] [-HelpNeeded <String>] [-LeadReferral <String>]
 [-LossReason <String>] [-LossReasonDetail <String>] [-LostDate <DateTime>] [-Market <String>]
 [-MonthlyCost <Decimal>] [-MonthlyRevenue <Decimal>] [-NextStep <String>] [-OnetimeCost <Decimal>]
 [-OnetimeRevenue <Decimal>] [-OpportunityCategoryID <String>] [-OwnerResourceID <Int32>]
 [-PrimaryCompetitor <String>] [-Probability <Int32>] [-ProductID <Int32>] [-ProjectedCloseDate <DateTime>]
 [-ProjectedLiveDate <DateTime>] [-PromisedFulfillmentDate <DateTime>] [-PromotionName <String>]
 [-QuarterlyCost <Decimal>] [-QuarterlyRevenue <Decimal>] [-Rating <String>] [-RevenueSpread <Int32>]
 [-RevenueSpreadUnit <String>] [-SemiannualCost <Decimal>] [-SemiannualRevenue <Decimal>] [-Stage <String>]
 [-Status <String>] [-ThroughDate <DateTime>] [-Title <String>] [-TotalAmountMonths <Int32>]
 [-UseQuoteTotals <Boolean>] [-WinReason <String>] [-WinReasonDetail <String>] [-YearlyCost <Decimal>]
 [-YearlyRevenue <Decimal>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### By_Id
```
Set-AtwsOpportunity [-Id <Int64[]>] [-AccountID <Int32>] [-AdvancedField1 <Decimal>]
 [-AdvancedField2 <Decimal>] [-AdvancedField3 <Decimal>] [-AdvancedField4 <Decimal>]
 [-AdvancedField5 <Decimal>] [-Amount <Decimal>] [-Barriers <String>] [-BusinessDivisionSubdivisionID <Int32>]
 [-ClosedDate <DateTime>] [-ContactID <Int32>] [-Cost <Decimal>] [-CreateDate <DateTime>]
 [-Description <String>] [-HelpNeeded <String>] [-LeadReferral <String>] [-LossReason <String>]
 [-LossReasonDetail <String>] [-LostDate <DateTime>] [-Market <String>] [-MonthlyCost <Decimal>]
 [-MonthlyRevenue <Decimal>] [-NextStep <String>] [-OnetimeCost <Decimal>] [-OnetimeRevenue <Decimal>]
 [-OpportunityCategoryID <String>] [-OwnerResourceID <Int32>] [-PrimaryCompetitor <String>]
 [-Probability <Int32>] [-ProductID <Int32>] [-ProjectedCloseDate <DateTime>] [-ProjectedLiveDate <DateTime>]
 [-PromisedFulfillmentDate <DateTime>] [-PromotionName <String>] [-QuarterlyCost <Decimal>]
 [-QuarterlyRevenue <Decimal>] [-Rating <String>] [-RevenueSpread <Int32>] [-RevenueSpreadUnit <String>]
 [-SemiannualCost <Decimal>] [-SemiannualRevenue <Decimal>] [-Stage <String>] [-Status <String>]
 [-ThroughDate <DateTime>] [-Title <String>] [-TotalAmountMonths <Int32>] [-UseQuoteTotals <Boolean>]
 [-WinReason <String>] [-WinReasonDetail <String>] [-YearlyCost <Decimal>] [-YearlyRevenue <Decimal>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### By_parameters
```
Set-AtwsOpportunity [-PassThru] [-UserDefinedFields <UserDefinedField[]>] -AccountID <Int32>
 [-AdvancedField1 <Decimal>] [-AdvancedField2 <Decimal>] [-AdvancedField3 <Decimal>]
 [-AdvancedField4 <Decimal>] [-AdvancedField5 <Decimal>] -Amount <Decimal> [-Barriers <String>]
 [-BusinessDivisionSubdivisionID <Int32>] [-ClosedDate <DateTime>] [-ContactID <Int32>] -Cost <Decimal>
 -CreateDate <DateTime> [-Description <String>] [-HelpNeeded <String>] [-LeadReferral <String>]
 [-LossReason <String>] [-LossReasonDetail <String>] [-LostDate <DateTime>] [-Market <String>]
 [-MonthlyCost <Decimal>] [-MonthlyRevenue <Decimal>] [-NextStep <String>] [-OnetimeCost <Decimal>]
 [-OnetimeRevenue <Decimal>] [-OpportunityCategoryID <String>] -OwnerResourceID <Int32>
 [-PrimaryCompetitor <String>] -Probability <Int32> [-ProductID <Int32>] -ProjectedCloseDate <DateTime>
 [-ProjectedLiveDate <DateTime>] [-PromisedFulfillmentDate <DateTime>] [-PromotionName <String>]
 [-QuarterlyCost <Decimal>] [-QuarterlyRevenue <Decimal>] [-Rating <String>] [-RevenueSpread <Int32>]
 [-RevenueSpreadUnit <String>] [-SemiannualCost <Decimal>] [-SemiannualRevenue <Decimal>] -Stage <String>
 -Status <String> [-ThroughDate <DateTime>] -Title <String> [-TotalAmountMonths <Int32>]
 -UseQuoteTotals <Boolean> [-WinReason <String>] [-WinReasonDetail <String>] [-YearlyCost <Decimal>]
 [-YearlyRevenue <Decimal>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function one or more objects of type \[Autotask.Opportunity\] as input.
You can pipe the objects to the function or pass them using the -InputObject parameter.
You specify the property you want to set and the value you want to set it to using parameters.
The function modifies all objects and updates the online data through the Autotask Web Services API.
The function supports all properties of an \[Autotask.Opportunity\] that can be updated through the Web Services API.
The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values.

Entities that have fields that refer to the base entity of this CmdLet:

## EXAMPLES

### EXAMPLE 1
```
Set-AtwsOpportunity -InputObject $Opportunity [-ParameterName] [Parameter value]
Passes one or more [Autotask.Opportunity] object(s) as a variable to the function and sets the property by name 'ParameterName' on ALL the objects before they are passed to the Autotask Web Service API and updated.
```

### EXAMPLE 2
```
Same as the first example, but now the objects are passed to the funtion through the pipeline, not passed as a parameter. The end result is identical.
```

### EXAMPLE 3
```
Gets the instance with Id 0 directly from the Web Services API, modifies a parameter and updates Autotask. This approach works with all valid parameters for the Get function.
```

### EXAMPLE 4
```
Gets multiple instances by Id, modifies them all and updates Autotask.
```

### EXAMPLE 5
```
-PassThru
Gets multiple instances by Id, modifies them all, updates Autotask and returns the updated objects.
```

## PARAMETERS

### -InputObject
An object that will be modified by any parameters and updated in Autotask

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

### -Id
The object.ids of objects that should be modified by any parameters and updated in Autotask

```yaml
Type: Int64[]
Parameter Sets: By_Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Return any updated objects through the pipeline

```yaml
Type: SwitchParameter
Parameter Sets: Input_Object, By_parameters
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserDefinedFields
User defined fields already setup i Autotask

```yaml
Type: UserDefinedField[]
Parameter Sets: Input_Object, By_parameters
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
Parameter Sets: Input_Object, By_Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdvancedField1
NumberOfUsers

```yaml
Type: Decimal
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdvancedField2
SetupFee

```yaml
Type: Decimal
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdvancedField3
HourlyCost

```yaml
Type: Decimal
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdvancedField4
DailyCost

```yaml
Type: Decimal
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdvancedField5
MonthlyCost

```yaml
Type: Decimal
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Amount
Amount

```yaml
Type: Decimal
Parameter Sets: Input_Object, By_Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: Decimal
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Barriers
Barriers

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
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
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClosedDate
Closed Date

```yaml
Type: DateTime
Parameter Sets: Input_Object, By_Id, By_parameters
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
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Cost
Cost

```yaml
Type: Decimal
Parameter Sets: Input_Object, By_Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: Decimal
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreateDate
CreateDate

```yaml
Type: DateTime
Parameter Sets: Input_Object, By_Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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

### -Description
Description

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
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
Parameter Sets: Input_Object, By_Id, By_parameters
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
Parameter Sets: Input_Object, By_Id, By_parameters
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
Parameter Sets: Input_Object, By_Id, By_parameters
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
Parameter Sets: Input_Object, By_Id, By_parameters
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
Parameter Sets: Input_Object, By_Id, By_parameters
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
Parameter Sets: Input_Object, By_Id, By_parameters
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
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MonthlyRevenue
Monthly Revenue

```yaml
Type: Decimal
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NextStep
NextStep

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
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
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OnetimeRevenue
One-Time Revenue

```yaml
Type: Decimal
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OpportunityCategoryID
Opportunity Category ID

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
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
Parameter Sets: Input_Object, By_Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrimaryCompetitor
Primary Competitor

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
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
Parameter Sets: Input_Object, By_Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProductID
ProductObjectID

```yaml
Type: Int32
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProjectedCloseDate
ProjClose

```yaml
Type: DateTime
Parameter Sets: Input_Object, By_Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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
Parameter Sets: Input_Object, By_Id, By_parameters
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
Parameter Sets: Input_Object, By_Id, By_parameters
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
Parameter Sets: Input_Object, By_Id, By_parameters
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
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -QuarterlyRevenue
Quarterly Revenue

```yaml
Type: Decimal
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Rating
opportunity_rating_id

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RevenueSpread
Revenue Spread

```yaml
Type: Int32
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RevenueSpreadUnit
spread_revenue_recognition_unit

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SemiannualCost
Semi-Annual Cost

```yaml
Type: Decimal
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SemiannualRevenue
Semi-Annual Revenue

```yaml
Type: Decimal
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Stage
StageObjectID

```yaml
Type: String
Parameter Sets: Input_Object, By_Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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
Parameter Sets: Input_Object, By_Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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

### -ThroughDate
ThroughDate

```yaml
Type: DateTime
Parameter Sets: Input_Object, By_Id, By_parameters
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
Parameter Sets: Input_Object, By_Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseQuoteTotals
Use Quote Totals

```yaml
Type: Boolean
Parameter Sets: Input_Object, By_Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: Boolean
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WinReason
Win Reason

```yaml
Type: String
Parameter Sets: Input_Object, By_Id, By_parameters
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
Parameter Sets: Input_Object, By_Id, By_parameters
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
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -YearlyRevenue
Yearly Revenue

```yaml
Type: Decimal
Parameter Sets: Input_Object, By_Id, By_parameters
Aliases:

Required: False
Position: Named
Default value: None
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

### [Autotask.Opportunity[]]. This function takes one or more objects as input. Pipeline is supported.
## OUTPUTS

### Nothing or [Autotask.Opportunity]. This function optionally returns the updated objects if you use the -PassThru parameter.
## NOTES
Related commands:
New-AtwsOpportunity
 Get-AtwsOpportunity

## RELATED LINKS
