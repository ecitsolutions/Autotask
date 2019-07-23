#Requires -Version 4.0
#Version 1.6.2.15
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

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

Additional operators for [String] parameters are:
 -Like (supports * or % as wildcards)
 -NotLike
 -BeginsWith
 -EndsWith
 -Contains

Properties with picklists are:

EmailTypeCode
 

EmailTypeCode2
 

EmailTypeCode3
 

Gender
 

Greeting
 

LocationID
 

ResourceType
 

Suffix
 

TravelAvailabilityPct
 

UserType
 

DateFormat
 

TimeFormat
 

PayrollType
 

NumberFormat
 

LicenseType
 

Entities that have fields that refer to the base entity of this CmdLet:

Account
 AccountNote
 AccountTeam
 AccountToDo
 Appointment
 AttachmentInfo
 BillingItem
 BillingItemApprovalLevel
 BusinessDivisionSubdivisionResource
 ContractCost
 ContractMilestone
 ContractNote
 ContractRoleCost
 Currency
 ExpenseReport
 InstalledProduct
 InventoryLocation
 InventoryTransfer
 Invoice
 NotificationHistory
 Opportunity
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
 ServiceCallTaskResource
 ServiceCallTicketResource
 ServiceLevelAgreementResults
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

  [CmdLetBinding(SupportsShouldProcess = $True, DefaultParameterSetName='Filter', ConfirmImpact='None')]
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
    [ValidateSet('DefaultServiceDeskRoleID')]
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
    [ValidateSet('Account:CreatedByResourceID', 'Account:OwnerResourceID', 'AccountNote:AssignedResourceID', 'AccountNote:ImpersonatorCreatorResourceID', 'AccountNote:ImpersonatorUpdaterResourceID', 'AccountTeam:ResourceID', 'AccountToDo:AssignedToResourceID', 'AccountToDo:CreatorResourceID', 'Appointment:CreatorResourceID', 'Appointment:ResourceID', 'AttachmentInfo:AttachedByResourceID', 'BillingItem:AccountManagerWhenApprovedID', 'BillingItem:ItemApproverID', 'BillingItemApprovalLevel:ApprovalResourceID', 'BusinessDivisionSubdivisionResource:ResourceID', 'ContractCost:CreatorResourceID', 'ContractMilestone:CreatorResourceID', 'ContractNote:CreatorResourceID', 'ContractNote:ImpersonatorCreatorResourceID', 'ContractNote:ImpersonatorUpdaterResourceID', 'ContractRoleCost:ResourceID', 'Currency:UpdateResourceId', 'ExpenseReport:ApproverID', 'ExpenseReport:SubmitterID', 'InstalledProduct:CreatedByPersonID', 'InstalledProduct:InstalledByID', 'InstalledProduct:LastActivityPersonID', 'InventoryLocation:ResourceID', 'InventoryTransfer:TransferByResourceID', 'Invoice:CreatorResourceID', 'Invoice:VoidedByResourceID', 'NotificationHistory:InitiatingResourceID', 'Opportunity:OwnerResourceID', 'Project:CompanyOwnerResourceID', 'Project:CreatorResourceID', 'Project:LastActivityResourceID', 'Project:ProjectLeadResourceID', 'ProjectCost:CreatorResourceID', 'ProjectNote:CreatorResourceID', 'ProjectNote:ImpersonatorCreatorResourceID', 'ProjectNote:ImpersonatorUpdaterResourceID', 'PurchaseOrder:CreatorResourceID', 'PurchaseOrderReceive:ReceivedByResourceID', 'Quote:CreatorResourceID', 'Quote:LastModifiedBy', 'QuoteTemplate:CreatedBy', 'QuoteTemplate:LastActivityBy', 'ResourceRole:ResourceID', 'ResourceRoleDepartment:ResourceID', 'ResourceRoleQueue:ResourceID', 'ResourceServiceDeskRole:ResourceID', 'ResourceSkill:ResourceID', 'SalesOrder:OwnerResourceID', 'Service:CreatorResourceID', 'Service:UpdateResourceID', 'ServiceBundle:CreatorResourceID', 'ServiceBundle:UpdateResourceID', 'ServiceCallTaskResource:ResourceID', 'ServiceCallTicketResource:ResourceID', 'ServiceLevelAgreementResults:FirstResponseInitiatingResourceID', 'ServiceLevelAgreementResults:FirstResponseResourceID', 'ServiceLevelAgreementResults:ResolutionPlanResourceID', 'ServiceLevelAgreementResults:ResolutionResourceID', 'Task:AssignedResourceID', 'Task:CompletedByResourceID', 'Task:CreatorResourceID', 'Task:LastActivityResourceID', 'TaskNote:CreatorResourceID', 'TaskNote:ImpersonatorCreatorResourceID', 'TaskNote:ImpersonatorUpdaterResourceID', 'TaskSecondaryResource:ResourceID', 'Ticket:AssignedResourceID', 'Ticket:CompletedByResourceID', 'Ticket:CreatorResourceID', 'Ticket:LastActivityResourceID', 'TicketChangeRequestApproval:ResourceID', 'TicketChecklistItem:CompletedByResourceID', 'TicketCost:CreatorResourceID', 'TicketHistory:ResourceID', 'TicketNote:CreatorResourceID', 'TicketNote:ImpersonatorCreatorResourceID', 'TicketNote:ImpersonatorUpdaterResourceID', 'TicketSecondaryResource:ResourceID', 'TimeEntry:BillingApprovalResourceID', 'TimeEntry:ImpersonatorCreatorResourceID', 'TimeEntry:ImpersonatorUpdaterResourceID', 'TimeEntry:ResourceID')]
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

# Status
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $Active,

# Email
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,254)]
    [string[]]
    $Email,

# Add Email 1
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,254)]
    [string[]]
    $Email2,

# Add Email 2
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,254)]
    [string[]]
    $Email3,

# Email Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $EmailTypeCode,

# Add Email 1 Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $EmailTypeCode2,

# Add Email 2 Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $EmailTypeCode3,

# First Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,50)]
    [string[]]
    $FirstName,

# Gender
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $Gender,

# Greeting
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $Greeting,

# Home Phone
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $HomePhone,

# Resource ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Pay Roll Identifier
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,32)]
    [string[]]
    $Initials,

# Last Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,50)]
    [string[]]
    $LastName,

# Pimary Location
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $LocationID,

# Middle Initial
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $MiddleName,

# Mobile Phone
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $MobilePhone,

# Office Extension
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,10)]
    [string[]]
    $OfficeExtension,

# Office Phone
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $OfficePhone,

# Resource Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $ResourceType,

# Suffix
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $Suffix,

# Title
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $Title,

# Travel Availability Pct
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $TravelAvailabilityPct,

# UserName
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,32)]
    [string[]]
    $UserName,

# User Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $UserType,

# Date Format
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $DateFormat,

# Time Format
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $TimeFormat,

# Payroll Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $PayrollType,

# Number Format
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $NumberFormat,

# Accounting Reference ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $AccountingReferenceID,

# Interal Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $InternalCost,

# Hire Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $HireDate,

# Survey Resource Rating
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $SurveyResourceRating,

# License Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $LicenseType,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Active', 'Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'Greeting', 'HomePhone', 'id', 'Initials', 'LastName', 'LocationID', 'MiddleName', 'MobilePhone', 'OfficeExtension', 'OfficePhone', 'ResourceType', 'Suffix', 'Title', 'TravelAvailabilityPct', 'UserName', 'UserType', 'DateFormat', 'TimeFormat', 'PayrollType', 'NumberFormat', 'AccountingReferenceID', 'InternalCost', 'HireDate', 'SurveyResourceRating', 'LicenseType')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Active', 'Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'Greeting', 'HomePhone', 'id', 'Initials', 'LastName', 'LocationID', 'MiddleName', 'MobilePhone', 'OfficeExtension', 'OfficePhone', 'ResourceType', 'Suffix', 'Title', 'TravelAvailabilityPct', 'UserName', 'UserType', 'DateFormat', 'TimeFormat', 'PayrollType', 'NumberFormat', 'AccountingReferenceID', 'InternalCost', 'HireDate', 'SurveyResourceRating', 'LicenseType')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Active', 'Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'Greeting', 'HomePhone', 'id', 'Initials', 'LastName', 'LocationID', 'MiddleName', 'MobilePhone', 'OfficeExtension', 'OfficePhone', 'ResourceType', 'Suffix', 'Title', 'TravelAvailabilityPct', 'UserName', 'UserType', 'DateFormat', 'TimeFormat', 'PayrollType', 'NumberFormat', 'AccountingReferenceID', 'InternalCost', 'HireDate', 'SurveyResourceRating', 'LicenseType')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'Greeting', 'HomePhone', 'id', 'Initials', 'LastName', 'LocationID', 'MiddleName', 'MobilePhone', 'OfficeExtension', 'OfficePhone', 'ResourceType', 'Suffix', 'Title', 'TravelAvailabilityPct', 'UserName', 'UserType', 'DateFormat', 'TimeFormat', 'PayrollType', 'NumberFormat', 'AccountingReferenceID', 'InternalCost', 'HireDate', 'SurveyResourceRating', 'LicenseType')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'Greeting', 'HomePhone', 'id', 'Initials', 'LastName', 'LocationID', 'MiddleName', 'MobilePhone', 'OfficeExtension', 'OfficePhone', 'ResourceType', 'Suffix', 'Title', 'TravelAvailabilityPct', 'UserName', 'UserType', 'DateFormat', 'TimeFormat', 'PayrollType', 'NumberFormat', 'AccountingReferenceID', 'InternalCost', 'HireDate', 'SurveyResourceRating', 'LicenseType')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'Greeting', 'HomePhone', 'id', 'Initials', 'LastName', 'LocationID', 'MiddleName', 'MobilePhone', 'OfficeExtension', 'OfficePhone', 'ResourceType', 'Suffix', 'Title', 'TravelAvailabilityPct', 'UserName', 'UserType', 'DateFormat', 'TimeFormat', 'PayrollType', 'NumberFormat', 'AccountingReferenceID', 'InternalCost', 'HireDate', 'SurveyResourceRating', 'LicenseType')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'Greeting', 'HomePhone', 'id', 'Initials', 'LastName', 'LocationID', 'MiddleName', 'MobilePhone', 'OfficeExtension', 'OfficePhone', 'ResourceType', 'Suffix', 'Title', 'TravelAvailabilityPct', 'UserName', 'UserType', 'DateFormat', 'TimeFormat', 'PayrollType', 'NumberFormat', 'AccountingReferenceID', 'InternalCost', 'HireDate', 'SurveyResourceRating', 'LicenseType')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'HomePhone', 'Initials', 'LastName', 'MiddleName', 'MobilePhone', 'OfficeExtension', 'OfficePhone', 'ResourceType', 'Suffix', 'Title', 'TravelAvailabilityPct', 'UserName', 'DateFormat', 'TimeFormat', 'NumberFormat', 'AccountingReferenceID')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'HomePhone', 'Initials', 'LastName', 'MiddleName', 'MobilePhone', 'OfficeExtension', 'OfficePhone', 'ResourceType', 'Suffix', 'Title', 'TravelAvailabilityPct', 'UserName', 'DateFormat', 'TimeFormat', 'NumberFormat', 'AccountingReferenceID')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'HomePhone', 'Initials', 'LastName', 'MiddleName', 'MobilePhone', 'OfficeExtension', 'OfficePhone', 'ResourceType', 'Suffix', 'Title', 'TravelAvailabilityPct', 'UserName', 'DateFormat', 'TimeFormat', 'NumberFormat', 'AccountingReferenceID')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'HomePhone', 'Initials', 'LastName', 'MiddleName', 'MobilePhone', 'OfficeExtension', 'OfficePhone', 'ResourceType', 'Suffix', 'Title', 'TravelAvailabilityPct', 'UserName', 'DateFormat', 'TimeFormat', 'NumberFormat', 'AccountingReferenceID')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'HomePhone', 'Initials', 'LastName', 'MiddleName', 'MobilePhone', 'OfficeExtension', 'OfficePhone', 'ResourceType', 'Suffix', 'Title', 'TravelAvailabilityPct', 'UserName', 'DateFormat', 'TimeFormat', 'NumberFormat', 'AccountingReferenceID')]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('HireDate')]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'Resource'
    
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

    $Caption = $MyInvocation.MyCommand.Name
    $VerboseDescrition = '{0}: About to query the Autotask Web API for {1}(s).' -F $Caption, $EntityName
    $VerboseWarning = '{0}: About to query the Autotask Web API for {1}(s). Do you want to continue?' -F $Caption, $EntityName
    
    If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
      $Result = Get-AtwsData -Entity $EntityName -Filter $Filter
    

      Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $Result.Count)
    
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
