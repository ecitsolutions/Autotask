#Requires -Version 4.0
#Version 1.6.2.17
<#

.COPYRIGHT
Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsTask
{


<#
.SYNOPSIS
This function get one or more Task through the Autotask Web Services API.
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

DepartmentID
 

Status
 

PriorityLabel
 

TaskType
 

CreatorType
 

CompletedByType
 

LastActivityPersonType
 

Entities that have fields that refer to the base entity of this CmdLet:

BillingItem
 ChangeOrderCost
 ExpenseItem
 NotificationHistory
 ServiceCallTask
 TaskNote
 TaskPredecessor
 TaskSecondaryResource
 TimeEntry

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Task[]]. This function outputs the Autotask.Task that was returned by the API.
.EXAMPLE
Get-AtwsTask -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsTask -TaskName SomeName
Returns the object with TaskName 'SomeName', if any.
 .EXAMPLE
Get-AtwsTask -TaskName 'Some Name'
Returns the object with TaskName 'Some Name', if any.
 .EXAMPLE
Get-AtwsTask -TaskName 'Some Name' -NotEquals TaskName
Returns any objects with a TaskName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsTask -TaskName SomeName* -Like TaskName
Returns any object with a TaskName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsTask -TaskName SomeName* -NotLike TaskName
Returns any object with a TaskName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsTask -DepartmentID <PickList Label>
Returns any Tasks with property DepartmentID equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsTask -DepartmentID <PickList Label> -NotEquals DepartmentID 
Returns any Tasks with property DepartmentID NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsTask -DepartmentID <PickList Label1>, <PickList Label2>
Returns any Tasks with property DepartmentID equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsTask -DepartmentID <PickList Label1>, <PickList Label2> -NotEquals DepartmentID
Returns any Tasks with property DepartmentID NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsTask -Id 1234 -TaskName SomeName* -DepartmentID <PickList Label1>, <PickList Label2> -Like TaskName -NotEquals DepartmentID -GreaterThan Id
An example of a more complex query. This command returns any Tasks with Id GREATER THAN 1234, a TaskName that matches the simple pattern SomeName* AND that has a DepartmentID that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsTask
 .LINK
Set-AtwsTask

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
    [ValidateSet('AccountPhysicalLocationID', 'AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'CompletedByResourceID', 'CreatorResourceID', 'LastActivityResourceID', 'PhaseID', 'ProjectID')]
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
    [ValidateSet('BillingItem:TaskID', 'ChangeOrderCost:TaskID', 'ExpenseItem:TaskID', 'NotificationHistory:TaskID', 'ServiceCallTask:TaskID', 'TaskNote:TaskID', 'TaskPredecessor:PredecessorTaskID', 'TaskPredecessor:SuccessorTaskID', 'TaskSecondaryResource:TaskID', 'TimeEntry:TaskID')]
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

# Allocation Code Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $AllocationCodeID,

# Resource
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $AssignedResourceID,

# Resource Role Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $AssignedResourceRoleID,

# Can Client Portal User Complete Task
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $CanClientPortalUserCompleteTask,

# Task Complete Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CompletedDateTime,

# Task Creation Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CreateDateTime,

# Task Creator
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CreatorResourceID,

# Task Department Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $DepartmentID,

# Task Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,8000)]
    [string[]]
    $Description,

# Task End Datetime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $EndDateTime,

# Task Estimated Hours
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $EstimatedHours,

# Task External ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $ExternalID,

# Hours to be Scheduled
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $HoursToBeScheduled,

# Task ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Is Visible in Client Portal
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $IsVisibleInClientPortal,

# Task Last Activity Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LastActivityDateTime,

# Phase ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $PhaseID,

# Task Priority
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $Priority,

# Project
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $ProjectID,

# Purchase Order Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $PurchaseOrderNumber,

# Task Start Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $StartDateTime,

# Task Status
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Status,

# Priority Label
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $PriorityLabel,

# Task Billable
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $TaskIsBillable,

# Task Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $TaskNumber,

# Task Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $TaskType,

# Task Title
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,255)]
    [string[]]
    $Title,

# Creator Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $CreatorType,

# Task Completed By
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CompletedByResourceID,

# Completed By Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $CompletedByType,

# Last Activity Person Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $LastActivityPersonType,

# Last Activity By
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $LastActivityResourceID,

# Account Physical Location ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $AccountPhysicalLocationID,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'CanClientPortalUserCompleteTask', 'CompletedDateTime', 'CreateDateTime', 'CreatorResourceID', 'DepartmentID', 'Description', 'EndDateTime', 'EstimatedHours', 'ExternalID', 'HoursToBeScheduled', 'id', 'IsVisibleInClientPortal', 'LastActivityDateTime', 'PhaseID', 'Priority', 'ProjectID', 'PurchaseOrderNumber', 'StartDateTime', 'Status', 'PriorityLabel', 'TaskIsBillable', 'TaskNumber', 'TaskType', 'Title', 'CreatorType', 'CompletedByResourceID', 'CompletedByType', 'LastActivityPersonType', 'LastActivityResourceID', 'AccountPhysicalLocationID')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'CanClientPortalUserCompleteTask', 'CompletedDateTime', 'CreateDateTime', 'CreatorResourceID', 'DepartmentID', 'Description', 'EndDateTime', 'EstimatedHours', 'ExternalID', 'HoursToBeScheduled', 'id', 'IsVisibleInClientPortal', 'LastActivityDateTime', 'PhaseID', 'Priority', 'ProjectID', 'PurchaseOrderNumber', 'StartDateTime', 'Status', 'PriorityLabel', 'TaskIsBillable', 'TaskNumber', 'TaskType', 'Title', 'CreatorType', 'CompletedByResourceID', 'CompletedByType', 'LastActivityPersonType', 'LastActivityResourceID', 'AccountPhysicalLocationID')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'CanClientPortalUserCompleteTask', 'CompletedDateTime', 'CreateDateTime', 'CreatorResourceID', 'DepartmentID', 'Description', 'EndDateTime', 'EstimatedHours', 'ExternalID', 'HoursToBeScheduled', 'id', 'IsVisibleInClientPortal', 'LastActivityDateTime', 'PhaseID', 'Priority', 'ProjectID', 'PurchaseOrderNumber', 'StartDateTime', 'Status', 'PriorityLabel', 'TaskIsBillable', 'TaskNumber', 'TaskType', 'Title', 'CreatorType', 'CompletedByResourceID', 'CompletedByType', 'LastActivityPersonType', 'LastActivityResourceID', 'AccountPhysicalLocationID')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'CompletedDateTime', 'CreateDateTime', 'CreatorResourceID', 'DepartmentID', 'Description', 'EndDateTime', 'EstimatedHours', 'ExternalID', 'HoursToBeScheduled', 'id', 'LastActivityDateTime', 'PhaseID', 'Priority', 'ProjectID', 'PurchaseOrderNumber', 'StartDateTime', 'Status', 'PriorityLabel', 'TaskNumber', 'TaskType', 'Title', 'CreatorType', 'CompletedByResourceID', 'CompletedByType', 'LastActivityPersonType', 'LastActivityResourceID', 'AccountPhysicalLocationID')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'CompletedDateTime', 'CreateDateTime', 'CreatorResourceID', 'DepartmentID', 'Description', 'EndDateTime', 'EstimatedHours', 'ExternalID', 'HoursToBeScheduled', 'id', 'LastActivityDateTime', 'PhaseID', 'Priority', 'ProjectID', 'PurchaseOrderNumber', 'StartDateTime', 'Status', 'PriorityLabel', 'TaskNumber', 'TaskType', 'Title', 'CreatorType', 'CompletedByResourceID', 'CompletedByType', 'LastActivityPersonType', 'LastActivityResourceID', 'AccountPhysicalLocationID')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'CompletedDateTime', 'CreateDateTime', 'CreatorResourceID', 'DepartmentID', 'Description', 'EndDateTime', 'EstimatedHours', 'ExternalID', 'HoursToBeScheduled', 'id', 'LastActivityDateTime', 'PhaseID', 'Priority', 'ProjectID', 'PurchaseOrderNumber', 'StartDateTime', 'Status', 'PriorityLabel', 'TaskNumber', 'TaskType', 'Title', 'CreatorType', 'CompletedByResourceID', 'CompletedByType', 'LastActivityPersonType', 'LastActivityResourceID', 'AccountPhysicalLocationID')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'CompletedDateTime', 'CreateDateTime', 'CreatorResourceID', 'DepartmentID', 'Description', 'EndDateTime', 'EstimatedHours', 'ExternalID', 'HoursToBeScheduled', 'id', 'LastActivityDateTime', 'PhaseID', 'Priority', 'ProjectID', 'PurchaseOrderNumber', 'StartDateTime', 'Status', 'PriorityLabel', 'TaskNumber', 'TaskType', 'Title', 'CreatorType', 'CompletedByResourceID', 'CompletedByType', 'LastActivityPersonType', 'LastActivityResourceID', 'AccountPhysicalLocationID')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'ExternalID', 'PurchaseOrderNumber', 'TaskNumber', 'Title')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'ExternalID', 'PurchaseOrderNumber', 'TaskNumber', 'Title')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'ExternalID', 'PurchaseOrderNumber', 'TaskNumber', 'Title')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'ExternalID', 'PurchaseOrderNumber', 'TaskNumber', 'Title')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'ExternalID', 'PurchaseOrderNumber', 'TaskNumber', 'Title')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CompletedDateTime', 'CreateDateTime', 'EndDateTime', 'LastActivityDateTime', 'StartDateTime')]
    [string[]]
    $IsThisDay
  )

    begin { 
        $entityName = 'Task'
    
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
