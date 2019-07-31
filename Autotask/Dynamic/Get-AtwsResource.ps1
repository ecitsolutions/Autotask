#Requires -Version 4.0
#Version 1.6.2.17
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

Additional operators for [string] parameters are:
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
 Phase
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
    [ValidateSet('Account:CreatedByResourceID', 'Account:OwnerResourceID', 'AccountNote:AssignedResourceID', 'AccountNote:ImpersonatorCreatorResourceID', 'AccountNote:ImpersonatorUpdaterResourceID', 'AccountTeam:ResourceID', 'AccountToDo:AssignedToResourceID', 'AccountToDo:CreatorResourceID', 'Appointment:CreatorResourceID', 'Appointment:ResourceID', 'AttachmentInfo:AttachedByResourceID', 'BillingItem:AccountManagerWhenApprovedID', 'BillingItem:ItemApproverID', 'BillingItemApprovalLevel:ApprovalResourceID', 'BusinessDivisionSubdivisionResource:ResourceID', 'ContractCost:CreatorResourceID', 'ContractMilestone:CreatorResourceID', 'ContractNote:CreatorResourceID', 'ContractNote:ImpersonatorCreatorResourceID', 'ContractNote:ImpersonatorUpdaterResourceID', 'ContractRoleCost:ResourceID', 'Currency:UpdateResourceId', 'ExpenseReport:ApproverID', 'ExpenseReport:SubmitterID', 'InstalledProduct:CreatedByPersonID', 'InstalledProduct:InstalledByID', 'InstalledProduct:LastActivityPersonID', 'InventoryLocation:ResourceID', 'InventoryTransfer:TransferByResourceID', 'Invoice:CreatorResourceID', 'Invoice:VoidedByResourceID', 'NotificationHistory:InitiatingResourceID', 'Opportunity:OwnerResourceID', 'Phase:CreatorResourceID', 'Project:CompanyOwnerResourceID', 'Project:CreatorResourceID', 'Project:LastActivityResourceID', 'Project:ProjectLeadResourceID', 'ProjectCost:CreatorResourceID', 'ProjectNote:CreatorResourceID', 'ProjectNote:ImpersonatorCreatorResourceID', 'ProjectNote:ImpersonatorUpdaterResourceID', 'PurchaseOrder:CreatorResourceID', 'PurchaseOrderReceive:ReceivedByResourceID', 'Quote:CreatorResourceID', 'Quote:LastModifiedBy', 'QuoteTemplate:CreatedBy', 'QuoteTemplate:LastActivityBy', 'ResourceRole:ResourceID', 'ResourceRoleDepartment:ResourceID', 'ResourceRoleQueue:ResourceID', 'ResourceServiceDeskRole:ResourceID', 'ResourceSkill:ResourceID', 'SalesOrder:OwnerResourceID', 'Service:CreatorResourceID', 'Service:UpdateResourceID', 'ServiceBundle:CreatorResourceID', 'ServiceBundle:UpdateResourceID', 'ServiceCallTaskResource:ResourceID', 'ServiceCallTicketResource:ResourceID', 'ServiceLevelAgreementResults:FirstResponseInitiatingResourceID', 'ServiceLevelAgreementResults:FirstResponseResourceID', 'ServiceLevelAgreementResults:ResolutionPlanResourceID', 'ServiceLevelAgreementResults:ResolutionResourceID', 'Task:AssignedResourceID', 'Task:CompletedByResourceID', 'Task:CreatorResourceID', 'Task:LastActivityResourceID', 'TaskNote:CreatorResourceID', 'TaskNote:ImpersonatorCreatorResourceID', 'TaskNote:ImpersonatorUpdaterResourceID', 'TaskSecondaryResource:ResourceID', 'Ticket:AssignedResourceID', 'Ticket:CompletedByResourceID', 'Ticket:CreatorResourceID', 'Ticket:LastActivityResourceID', 'TicketChangeRequestApproval:ResourceID', 'TicketChecklistItem:CompletedByResourceID', 'TicketCost:CreatorResourceID', 'TicketHistory:ResourceID', 'TicketNote:CreatorResourceID', 'TicketNote:ImpersonatorCreatorResourceID', 'TicketNote:ImpersonatorUpdaterResourceID', 'TicketSecondaryResource:ResourceID', 'TimeEntry:BillingApprovalResourceID', 'TimeEntry:ImpersonatorCreatorResourceID', 'TimeEntry:ImpersonatorUpdaterResourceID', 'TimeEntry:ResourceID')]
    [string]
    $GetExternalEntityByThisEntityId,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# Do not add descriptions for all picklist attributes with values
    [Parameter(
      ParametersetName = 'Filter'
    )]
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [switch]
    $NoPickListLabel,

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
    [string[]]
    $EmailTypeCode,

# Add Email 1 Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $EmailTypeCode2,

# Add Email 2 Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
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
    [string[]]
    $Gender,

# Greeting
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
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
    [string[]]
    $ResourceType,

# Suffix
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
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
    [string[]]
    $UserType,

# Date Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $DateFormat,

# Time Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $TimeFormat,

# Payroll Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $PayrollType,

# Number Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
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
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
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
            $Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $entityName
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
