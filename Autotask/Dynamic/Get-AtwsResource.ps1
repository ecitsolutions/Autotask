#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsResource
{


<#
.SYNOPSIS
This function get one or more Resource through the Autotask Web Services API.
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

EmailTypeCode
 MOBILE - Mobile email service
 PAGER - Pager e-mail address
 PRIMARY - Primary e-mail address
 SECONDARY - Secondary e-mail address
 SMS - SMS text messaging address

EmailTypeCode2
 MOBILE - Mobile email service
 PAGER - Pager e-mail address
 PRIMARY - Primary e-mail address
 SECONDARY - Secondary e-mail address
 SMS - SMS text messaging address

EmailTypeCode3
 MOBILE - Mobile email service
 PAGER - Pager e-mail address
 PRIMARY - Primary e-mail address
 SECONDARY - Secondary e-mail address
 SMS - SMS text messaging address

Gender
 F - Female
 M - Male

Greeting
 1 - Mr.
 2 - Mrs.
 3 - Ms.

LocationID
 90682 - Hønefoss
 90684 - ECIT Group Services
 90685 - Fornebu
 90686 - Fornebu (Holiday Set 2)
 90687 - Utdatert Location
 90688 - Autotask API
 90689 - Nøtterøy
 90690 - Drammen
 90691 - Drammen (Holiday Set 2)
 90692 - Hønefoss (Holiday Set 2)

ResourceType
 Contractor - Contractor
 Employee - Employee

Suffix
 

TravelAvailabilityPct
 0% - 0%
 up to 100% - up to 100%
 up to 25% - up to 25%
 up to 50% - up to 50%
 up to 75% - up to 75%

UserType
 7 - Service Desk User
 17 - Full Access (system)
 18 - System Administrator - Full tilgang
 19 - Sales
 20 - Service Desk User - Standard bruker
 21 - Dashboard User (system)
 22 - Minimal Access (system)
 23 - Service Desk User - Standard bruker+Kontrakter
 24 - API User (system)
 26 - Service Desk User - Standard bruker+Kontrakt+Kost
 27 - API User - custom changes
 28 - ECIT Group Services - Service Desk User
 29 - ECIT Group Services - Manager
 33 - System Administrator (system)
 34 - Manager (system)
 35 - Project Manager (system)
 36 - Sales (system)
 37 - Team Member (system)
 38 - Contractor (system)
 39 - Service Desk User (system)
 40 - Private CRM (system)
 41 - Time and Attendance (system)
 48 - Copy (1) of Service Desk User - Standard bruker
 49 - Service Desk User - Standard bruker+Kontrakt(les)
 51 - Co-Managed Help Desk (system)
 52 - Manager + Add Contacts
 53 - Service Desk User - Standard bruker+Kontrakt+exten
 54 - Jon Erik
 55 - Stian Mauritzen (copy og S&O+Products & Services)

DateFormat
 MM/dd/yyyy - MM/dd/yyyy
 MM-dd-yyyy - MM-dd-yyyy
 MM.dd.yyyy - MM.dd.yyyy
 dd/MM/yyyy - dd/MM/yyyy
 dd-MM-yyyy - dd-MM-yyyy
 dd.MM.yyyy - dd.MM.yyyy
 yyyy/MM/dd - yyyy/MM/dd
 yyyy-MM-dd - yyyy-MM-dd
 yyyy.MM.dd - yyyy.MM.dd

TimeFormat
 hh:mm a - hh:mm a
 HH:mm - HH:mm
 h:mm a - h:mm a

PayrollType
 1 - Salary
 2 - Hourly
 3 - Contractor
 4 - Salary Non Exempt

NumberFormat
 X,XXX.XX - X,XXX.XX
 X.XXX,XX - X.XXX,XX

LicenseType
 1 - Administrator
 2 - Executive
 3 - Professional
 4 - Team Member
 5 - Time & Attendance Only
 6 - Dashboard User
 7 - API User
 8 - Contractor
 9 - Co-Managed Help Desk

Entities that have fields that refer to the base entity of this CmdLet:

Account
 AccountNote
 AccountTeam
 AccountToDo
 AccountWebhook
 AccountWebhookExcludedResource
 Appointment
 AttachmentInfo
 BillingItem
 BillingItemApprovalLevel
 BusinessDivisionSubdivisionResource
 ChangeOrderCost
 ComanagedAssociation
 Contact
 ContactWebhook
 ContactWebhookExcludedResource
 ContractCost
 ContractMilestone
 ContractNote
 ContractRoleCost
 Currency
 ExpenseReport
 InstalledProduct
 InstalledProductNote
 InventoryItem
 InventoryLocation
 InventoryTransfer
 Invoice
 NotificationHistory
 Opportunity
 Phase
 Product
 Project
 ProjectCost
 ProjectNote
 PurchaseOrder
 PurchaseOrderReceive
 Quote
 QuoteTemplate
 ResourceRole
 ResourceRoleDepartment
 ResourceRoleQueue
 ResourceServiceDeskRole
 ResourceSkill
 SalesOrder
 Service
 ServiceBundle
 ServiceCall
 ServiceCallTaskResource
 ServiceCallTicketResource
 ServiceLevelAgreementResults
 Subscription
 Task
 TaskNote
 TaskSecondaryResource
 Ticket
 TicketChangeRequestApproval
 TicketChecklistItem
 TicketCost
 TicketHistory
 TicketNote
 TicketSecondaryResource
 TimeEntry

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Resource[]]. This function outputs the Autotask.Resource that was returned by the API.
.EXAMPLE
Get-AtwsResource -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsResource -ResourceName SomeName
Returns the object with ResourceName 'SomeName', if any.
 .EXAMPLE
Get-AtwsResource -ResourceName 'Some Name'
Returns the object with ResourceName 'Some Name', if any.
 .EXAMPLE
Get-AtwsResource -ResourceName 'Some Name' -NotEquals ResourceName
Returns any objects with a ResourceName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsResource -ResourceName SomeName* -Like ResourceName
Returns any object with a ResourceName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsResource -ResourceName SomeName* -NotLike ResourceName
Returns any object with a ResourceName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsResource -EmailTypeCode <PickList Label>
Returns any Resources with property EmailTypeCode equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsResource -EmailTypeCode <PickList Label> -NotEquals EmailTypeCode 
Returns any Resources with property EmailTypeCode NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsResource -EmailTypeCode <PickList Label1>, <PickList Label2>
Returns any Resources with property EmailTypeCode equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsResource -EmailTypeCode <PickList Label1>, <PickList Label2> -NotEquals EmailTypeCode
Returns any Resources with property EmailTypeCode NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsResource -Id 1234 -ResourceName SomeName* -EmailTypeCode <PickList Label1>, <PickList Label2> -Like ResourceName -NotEquals EmailTypeCode -GreaterThan Id
An example of a more complex query. This command returns any Resources with Id GREATER THAN 1234, a ResourceName that matches the simple pattern SomeName* AND that has a EmailTypeCode that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
Set-AtwsResource

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
    [ValidateSet('DefaultServiceDeskRoleID')]
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
    [ValidateSet('Account:CreatedByResourceID', 'Account:ImpersonatorCreatorResourceID', 'Account:OwnerResourceID', 'AccountNote:AssignedResourceID', 'AccountNote:ImpersonatorCreatorResourceID', 'AccountNote:ImpersonatorUpdaterResourceID', 'AccountTeam:ResourceID', 'AccountToDo:AssignedToResourceID', 'AccountToDo:CreatorResourceID', 'AccountToDo:ImpersonatorCreatorResourceID', 'AccountWebhook:OwnerResourceID', 'AccountWebhookExcludedResource:ResourceID', 'Appointment:CreatorResourceID', 'Appointment:ResourceID', 'AttachmentInfo:AttachedByResourceID', 'AttachmentInfo:ImpersonatorCreatorResourceID', 'BillingItem:AccountManagerWhenApprovedID', 'BillingItem:ItemApproverID', 'BillingItemApprovalLevel:ApprovalResourceID', 'BusinessDivisionSubdivisionResource:ResourceID', 'ChangeOrderCost:CreatorResourceID', 'ChangeOrderCost:StatusLastModifiedBy', 'ComanagedAssociation:ResourceID', 'Contact:ImpersonatorCreatorResourceID', 'ContactWebhook:OwnerResourceID', 'ContactWebhookExcludedResource:ResourceID', 'ContractCost:CreatorResourceID', 'ContractMilestone:CreatorResourceID', 'ContractNote:CreatorResourceID', 'ContractNote:ImpersonatorCreatorResourceID', 'ContractNote:ImpersonatorUpdaterResourceID', 'ContractRoleCost:ResourceID', 'Currency:UpdateResourceId', 'ExpenseReport:ApproverID', 'ExpenseReport:SubmitterID', 'InstalledProduct:CreatedByPersonID', 'InstalledProduct:ImpersonatorCreatorResourceID', 'InstalledProduct:InstalledByID', 'InstalledProduct:LastActivityPersonID', 'InstalledProductNote:CreatorResourceID', 'InstalledProductNote:ImpersonatorCreatorResourceID', 'InstalledProductNote:ImpersonatorUpdaterResourceID', 'InventoryItem:ImpersonatorCreatorResourceID', 'InventoryLocation:ImpersonatorCreatorResourceID', 'InventoryLocation:ResourceID', 'InventoryTransfer:TransferByResourceID', 'Invoice:CreatorResourceID', 'Invoice:VoidedByResourceID', 'NotificationHistory:InitiatingResourceID', 'Opportunity:ImpersonatorCreatorResourceID', 'Opportunity:OwnerResourceID', 'Phase:CreatorResourceID', 'Product:ImpersonatorCreatorResourceID', 'Project:CompanyOwnerResourceID', 'Project:CreatorResourceID', 'Project:ImpersonatorCreatorResourceID', 'Project:LastActivityResourceID', 'Project:ProjectLeadResourceID', 'ProjectCost:CreatorResourceID', 'ProjectNote:CreatorResourceID', 'ProjectNote:ImpersonatorCreatorResourceID', 'ProjectNote:ImpersonatorUpdaterResourceID', 'PurchaseOrder:CreatorResourceID', 'PurchaseOrder:ImpersonatorCreatorResourceID', 'PurchaseOrderReceive:ReceivedByResourceID', 'Quote:ApprovalStatusChangedByResourceID', 'Quote:CreatorResourceID', 'Quote:ImpersonatorCreatorResourceID', 'Quote:LastModifiedBy', 'QuoteTemplate:CreatedBy', 'QuoteTemplate:LastActivityBy', 'ResourceRole:ResourceID', 'ResourceRoleDepartment:ResourceID', 'ResourceRoleQueue:ResourceID', 'ResourceServiceDeskRole:ResourceID', 'ResourceSkill:ResourceID', 'SalesOrder:ImpersonatorCreatorResourceID', 'SalesOrder:OwnerResourceID', 'Service:CreatorResourceID', 'Service:UpdateResourceID', 'ServiceBundle:CreatorResourceID', 'ServiceBundle:UpdateResourceID', 'ServiceCall:ImpersonatorCreatorResourceID', 'ServiceCallTaskResource:ResourceID', 'ServiceCallTicketResource:ResourceID', 'ServiceLevelAgreementResults:FirstResponseInitiatingResourceID', 'ServiceLevelAgreementResults:FirstResponseResourceID', 'ServiceLevelAgreementResults:ResolutionPlanResourceID', 'ServiceLevelAgreementResults:ResolutionResourceID', 'Subscription:ImpersonatorCreatorResourceID', 'Task:AssignedResourceID', 'Task:CompletedByResourceID', 'Task:CreatorResourceID', 'Task:LastActivityResourceID', 'TaskNote:CreatorResourceID', 'TaskNote:ImpersonatorCreatorResourceID', 'TaskNote:ImpersonatorUpdaterResourceID', 'TaskSecondaryResource:ResourceID', 'Ticket:AssignedResourceID', 'Ticket:CompletedByResourceID', 'Ticket:CreatorResourceID', 'Ticket:ImpersonatorCreatorResourceID', 'Ticket:LastActivityResourceID', 'TicketChangeRequestApproval:ResourceID', 'TicketChecklistItem:CompletedByResourceID', 'TicketCost:CreatorResourceID', 'TicketHistory:ResourceID', 'TicketNote:CreatorResourceID', 'TicketNote:ImpersonatorCreatorResourceID', 'TicketNote:ImpersonatorUpdaterResourceID', 'TicketSecondaryResource:ResourceID', 'TimeEntry:BillingApprovalResourceID', 'TimeEntry:ImpersonatorCreatorResourceID', 'TimeEntry:ImpersonatorUpdaterResourceID', 'TimeEntry:ResourceID')]
    [string]
    $GetExternalEntityByThisEntityId,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# Status
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $Active,

# Email
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,254)]
    [string[]]
    $Email,

# Add Email 1
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,254)]
    [string[]]
    $Email2,

# Add Email 2
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,254)]
    [string[]]
    $Email3,

# Email Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName EmailTypeCode -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Resource -FieldName EmailTypeCode -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $EmailTypeCode,

# Add Email 1 Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName EmailTypeCode2 -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Resource -FieldName EmailTypeCode2 -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $EmailTypeCode2,

# Add Email 2 Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName EmailTypeCode3 -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Resource -FieldName EmailTypeCode3 -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $EmailTypeCode3,

# First Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,50)]
    [string[]]
    $FirstName,

# Gender
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName Gender -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Resource -FieldName Gender -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $Gender,

# Greeting
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName Greeting -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Resource -FieldName Greeting -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $Greeting,

# Home Phone
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $HomePhone,

# Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Pay Roll Identifier
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,32)]
    [string[]]
    $Initials,

# Last Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,50)]
    [string[]]
    $LastName,

# Pimary Location
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName LocationID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Resource -FieldName LocationID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $LocationID,

# Middle Initial
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $MiddleName,

# Mobile Phone
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $MobilePhone,

# Office Extension
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,10)]
    [string[]]
    $OfficeExtension,

# Office Phone
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $OfficePhone,

# Resource Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName ResourceType -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Resource -FieldName ResourceType -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $ResourceType,

# Suffix
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName Suffix -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Resource -FieldName Suffix -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $Suffix,

# Title
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $Title,

# Travel Availability Pct
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName TravelAvailabilityPct -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Resource -FieldName TravelAvailabilityPct -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $TravelAvailabilityPct,

# UserName
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,32)]
    [string[]]
    $UserName,

# User Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName UserType -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Resource -FieldName UserType -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $UserType,

# Date Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName DateFormat -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Resource -FieldName DateFormat -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $DateFormat,

# Time Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName TimeFormat -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Resource -FieldName TimeFormat -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $TimeFormat,

# Payroll Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName PayrollType -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Resource -FieldName PayrollType -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $PayrollType,

# Number Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName NumberFormat -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Resource -FieldName NumberFormat -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $NumberFormat,

# Accounting Reference ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $AccountingReferenceID,

# Interal Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $InternalCost,

# Hire Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $HireDate,

# Survey Resource Rating
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $SurveyResourceRating,

# License Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName LicenseType -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Resource -FieldName LicenseType -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $LicenseType,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Active', 'Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'Greeting', 'HomePhone', 'id', 'Initials', 'LastName', 'LocationID', 'MiddleName', 'MobilePhone', 'OfficeExtension', 'OfficePhone', 'ResourceType', 'Suffix', 'Title', 'TravelAvailabilityPct', 'UserName', 'UserType', 'DateFormat', 'TimeFormat', 'PayrollType', 'NumberFormat', 'AccountingReferenceID', 'InternalCost', 'HireDate', 'SurveyResourceRating', 'LicenseType')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Active', 'Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'Greeting', 'HomePhone', 'id', 'Initials', 'LastName', 'LocationID', 'MiddleName', 'MobilePhone', 'OfficeExtension', 'OfficePhone', 'ResourceType', 'Suffix', 'Title', 'TravelAvailabilityPct', 'UserName', 'UserType', 'DateFormat', 'TimeFormat', 'PayrollType', 'NumberFormat', 'AccountingReferenceID', 'InternalCost', 'HireDate', 'SurveyResourceRating', 'LicenseType')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Active', 'Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'Greeting', 'HomePhone', 'id', 'Initials', 'LastName', 'LocationID', 'MiddleName', 'MobilePhone', 'OfficeExtension', 'OfficePhone', 'ResourceType', 'Suffix', 'Title', 'TravelAvailabilityPct', 'UserName', 'UserType', 'DateFormat', 'TimeFormat', 'PayrollType', 'NumberFormat', 'AccountingReferenceID', 'InternalCost', 'HireDate', 'SurveyResourceRating', 'LicenseType')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'Greeting', 'HomePhone', 'id', 'Initials', 'LastName', 'LocationID', 'MiddleName', 'MobilePhone', 'OfficeExtension', 'OfficePhone', 'ResourceType', 'Suffix', 'Title', 'TravelAvailabilityPct', 'UserName', 'UserType', 'DateFormat', 'TimeFormat', 'PayrollType', 'NumberFormat', 'AccountingReferenceID', 'InternalCost', 'HireDate', 'SurveyResourceRating', 'LicenseType')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'Greeting', 'HomePhone', 'id', 'Initials', 'LastName', 'LocationID', 'MiddleName', 'MobilePhone', 'OfficeExtension', 'OfficePhone', 'ResourceType', 'Suffix', 'Title', 'TravelAvailabilityPct', 'UserName', 'UserType', 'DateFormat', 'TimeFormat', 'PayrollType', 'NumberFormat', 'AccountingReferenceID', 'InternalCost', 'HireDate', 'SurveyResourceRating', 'LicenseType')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'Greeting', 'HomePhone', 'id', 'Initials', 'LastName', 'LocationID', 'MiddleName', 'MobilePhone', 'OfficeExtension', 'OfficePhone', 'ResourceType', 'Suffix', 'Title', 'TravelAvailabilityPct', 'UserName', 'UserType', 'DateFormat', 'TimeFormat', 'PayrollType', 'NumberFormat', 'AccountingReferenceID', 'InternalCost', 'HireDate', 'SurveyResourceRating', 'LicenseType')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'Greeting', 'HomePhone', 'id', 'Initials', 'LastName', 'LocationID', 'MiddleName', 'MobilePhone', 'OfficeExtension', 'OfficePhone', 'ResourceType', 'Suffix', 'Title', 'TravelAvailabilityPct', 'UserName', 'UserType', 'DateFormat', 'TimeFormat', 'PayrollType', 'NumberFormat', 'AccountingReferenceID', 'InternalCost', 'HireDate', 'SurveyResourceRating', 'LicenseType')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'HomePhone', 'Initials', 'LastName', 'MiddleName', 'MobilePhone', 'OfficeExtension', 'OfficePhone', 'ResourceType', 'Suffix', 'Title', 'TravelAvailabilityPct', 'UserName', 'DateFormat', 'TimeFormat', 'NumberFormat', 'AccountingReferenceID')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'HomePhone', 'Initials', 'LastName', 'MiddleName', 'MobilePhone', 'OfficeExtension', 'OfficePhone', 'ResourceType', 'Suffix', 'Title', 'TravelAvailabilityPct', 'UserName', 'DateFormat', 'TimeFormat', 'NumberFormat', 'AccountingReferenceID')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'HomePhone', 'Initials', 'LastName', 'MiddleName', 'MobilePhone', 'OfficeExtension', 'OfficePhone', 'ResourceType', 'Suffix', 'Title', 'TravelAvailabilityPct', 'UserName', 'DateFormat', 'TimeFormat', 'NumberFormat', 'AccountingReferenceID')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'HomePhone', 'Initials', 'LastName', 'MiddleName', 'MobilePhone', 'OfficeExtension', 'OfficePhone', 'ResourceType', 'Suffix', 'Title', 'TravelAvailabilityPct', 'UserName', 'DateFormat', 'TimeFormat', 'NumberFormat', 'AccountingReferenceID')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'HomePhone', 'Initials', 'LastName', 'MiddleName', 'MobilePhone', 'OfficeExtension', 'OfficePhone', 'ResourceType', 'Suffix', 'Title', 'TravelAvailabilityPct', 'UserName', 'DateFormat', 'TimeFormat', 'NumberFormat', 'AccountingReferenceID')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('HireDate')]
    [string[]]
    $IsThisDay
  )

    begin { 
        $entityName = 'Resource'
    
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
