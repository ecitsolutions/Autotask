---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# New-AtwsTicket

## SYNOPSIS
This function creates a new Ticket through the Autotask Web Services API.
All required properties are marked as required parameters to assist you on the command line.

## SYNTAX

### By_parameters (Default)
```
New-AtwsTicket [-UserDefinedFields <UserDefinedField[]>] -AccountID <Int32>
 [-AccountPhysicalLocationID <Int32>] [-AEMAlertID <String>] [-AllocationCodeID <Int32>]
 [-ApiVendorID <String>] [-AssignedResourceID <Int32>] [-AssignedResourceRoleID <Int32>]
 [-BusinessDivisionSubdivisionID <Int32>] [-ChangeApprovalBoard <String>] [-ChangeApprovalStatus <String>]
 [-ChangeApprovalType <String>] [-ChangeInfoField1 <String>] [-ChangeInfoField2 <String>]
 [-ChangeInfoField3 <String>] [-ChangeInfoField4 <String>] [-ChangeInfoField5 <String>]
 [-CompletedByResourceID <Int32>] [-CompletedDate <DateTime>] [-ContactID <Int32>] [-ContractID <Int32>]
 [-ContractServiceBundleID <Int64>] [-ContractServiceID <Int64>] [-CreateDate <DateTime>]
 [-CreatedByContactID <Int32>] [-CreatorResourceID <Int32>] [-CreatorType <String>]
 [-CurrentServiceThermometerRating <String>] [-Description <String>] [-DueDateTime <DateTime>]
 [-EstimatedHours <Double>] [-ExternalID <String>] [-FirstResponseAssignedResourceID <Int32>]
 [-FirstResponseDateTime <DateTime>] [-FirstResponseDueDateTime <DateTime>]
 [-FirstResponseInitiatingResourceID <Int32>] [-HoursToBeScheduled <Decimal>]
 [-ImpersonatorCreatorResourceID <Int32>] [-InstalledProductID <Int32>] [-IssueType <String>]
 [-LastActivityDate <DateTime>] [-LastActivityPersonType <String>] [-LastActivityResourceID <Int32>]
 [-LastCustomerNotificationDateTime <DateTime>] [-LastCustomerVisibleActivityDateTime <DateTime>]
 [-LastTrackedModificationDateTime <DateTime>] [-MonitorID <Int32>] [-MonitorTypeID <String>]
 [-OpportunityId <Int32>] [-PreviousServiceThermometerRating <String>] -Priority <String>
 [-ProblemTicketId <Int32>] [-ProjectID <Int32>] [-PurchaseOrderNumber <String>] [-QueueID <String>]
 [-Resolution <String>] [-ResolutionPlanDateTime <DateTime>] [-ResolutionPlanDueDateTime <DateTime>]
 [-ResolvedDateTime <DateTime>] [-ResolvedDueDateTime <DateTime>] [-RmaStatus <String>] [-RmaType <String>]
 [-ServiceLevelAgreementHasBeenMet <Boolean>] [-ServiceLevelAgreementID <String>]
 [-ServiceLevelAgreementPausedNextEventHours <Decimal>] [-ServiceThermometerTemperature <Int32>]
 [-Source <String>] -Status <String> [-SubIssueType <String>] [-TicketCategory <String>]
 [-TicketNumber <String>] [-TicketType <String>] -Title <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Input_Object
```
New-AtwsTicket [-InputObject <Ticket[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The function supports all properties of an \[Autotask.Ticket\] that can be updated through the Web Services API.
The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values.
Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter.
To get the Ticket with Id number 0 you could write 'New-AtwsTicket -Id 0' or you could write 'New-AtwsTicket -Filter {Id -eq 0}.

'New-AtwsTicket -Id 0,4' could be written as 'New-AtwsTicket -Filter {id -eq 0 -or id -eq 4}'.
For simple queries you can see that using parameters is much easier than the -Filter option.
But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday).
As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new Ticket you need the following required fields:
 -AccountID
 -Priority
 -Status
 -Title

Entities that have fields that refer to the base entity of this CmdLet:

## EXAMPLES

### EXAMPLE 1
```
$result = New-AtwsTicket -AccountID [Value] -Priority [Value] -Status [Value] -Title [Value]
Creates a new [Autotask.Ticket] through the Web Services API and returns the new object.
```

### EXAMPLE 2
```
$result = Get-AtwsTicket -Id 124 | New-AtwsTicket 
Copies [Autotask.Ticket] by Id 124 to a new object through the Web Services API and returns the new object.
```

### EXAMPLE 3
```
Copies [Autotask.Ticket] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsTicket to modify the object.
```

### EXAMPLE 4
```
-Passthru
Copies [Autotask.Ticket] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsTicket to modify the object and returns the new object.
```

## PARAMETERS

### -InputObject
An array of objects to create

```yaml
Type: Ticket[]
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
Client

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

### -AccountPhysicalLocationID
Account Physical Location

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

### -AEMAlertID
AEM Alert ID

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

### -AllocationCodeID
Allocation Code Name

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

### -ApiVendorID
API Vendor ID

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

### -AssignedResourceID
Resource

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

### -AssignedResourceRoleID
Resource Role Name

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

### -ChangeApprovalBoard
Change Approval Board ID

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

### -ChangeApprovalStatus
Change Approval Status

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

### -ChangeApprovalType
Change Approval Type

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

### -ChangeInfoField1
Change Info Field 1

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

### -ChangeInfoField2
Change Info Field 2

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

### -ChangeInfoField3
Change Info Field 3

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

### -ChangeInfoField4
Change Info Field 4

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

### -ChangeInfoField5
Change Info Field 5

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

### -CompletedByResourceID
Ticket Completed By

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

### -CompletedDate
Ticket Date Completed by Complete Project Wizard

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
Ticket Contact

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

### -ContractID
Contract

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

### -ContractServiceBundleID
Contract Service Bundle ID

```yaml
Type: Int64
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContractServiceID
Contract Service ID

```yaml
Type: Int64
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreateDate
Ticket Creation Date

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

### -CreatedByContactID
Created By Contact ID

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

### -CreatorResourceID
Ticket Creator

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

### -CreatorType
Creator Type

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

### -CurrentServiceThermometerRating
Current Service Thermometer Rating

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

### -Description
Ticket Description

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

### -DueDateTime
Ticket End Date

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

### -EstimatedHours
Ticket Estimated Hours

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

### -ExternalID
Ticket External ID

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

### -FirstResponseAssignedResourceID
First Response Assigned Resource

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

### -FirstResponseDateTime
First Response Date Time

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

### -FirstResponseDueDateTime
First Response Due Date Time

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

### -FirstResponseInitiatingResourceID
First Response Initiating Resource

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

### -HoursToBeScheduled
Hours to be Scheduled

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

### -InstalledProductID
Configuration Item

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

### -IssueType
Ticket Issue

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

### -LastActivityDate
Ticket Last Activity Date

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

### -LastActivityPersonType
Last Activity Person Type

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

### -LastActivityResourceID
Last Edited Resource ID

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

### -LastCustomerNotificationDateTime
Last Customer Notification

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

### -LastCustomerVisibleActivityDateTime
Last Customer Visible Activity

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

### -LastTrackedModificationDateTime
Last Tracked Modification Date Time

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

### -MonitorID
Monitor ID

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

### -MonitorTypeID
Monitor Type ID

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

### -OpportunityId
Opportunity ID

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

### -PreviousServiceThermometerRating
Previous Service Thermometer Rating

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

### -Priority
Ticket Priority

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

### -ProblemTicketId
Problem Ticket ID

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

### -ProjectID
Project ID

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

### -PurchaseOrderNumber
purchase_order_number

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

### -QueueID
Ticket Department Name OR Ticket Queue Name

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

### -Resolution
Resolution

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

### -ResolutionPlanDateTime
Resolution Plan Date Time

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

### -ResolutionPlanDueDateTime
Resolution Plan Due Date Time

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

### -ResolvedDateTime
Resolved Date Time

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

### -ResolvedDueDateTime
Resolved Due Date Time

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

### -RmaStatus
RMA Status

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

### -RmaType
RMA Type

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

### -ServiceLevelAgreementHasBeenMet
Has Met SLA

```yaml
Type: Boolean
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceLevelAgreementID
Service Level Agreement ID

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

### -ServiceLevelAgreementPausedNextEventHours
Next Service Level Agreement Event in Hours

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

### -ServiceThermometerTemperature
Service Thermometer Temperature

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

### -Source
Ticket Source

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

### -Status
Ticket Status

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

### -SubIssueType
Ticket Subissue Type

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

### -TicketCategory
Ticket Category

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

### -TicketNumber
Ticket Number

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

### -TicketType
Ticket Type

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

### -Title
Ticket Title

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

### [Autotask.Ticket]. This function outputs the Autotask.Ticket that was created by the API.
## NOTES
Related commands:
Get-AtwsTicket
 Set-AtwsTicket

## RELATED LINKS
