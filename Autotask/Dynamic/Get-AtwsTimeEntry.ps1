#Requires -Version 4.0
#Version 1.6.13
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsTimeEntry
{


<#
.SYNOPSIS
This function get one or more TimeEntry through the Autotask Web Services API.
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

Type
 

Entities that have fields that refer to the base entity of this CmdLet:

BillingItem
 BillingItemApprovalLevel
 NotificationHistory

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.TimeEntry[]]. This function outputs the Autotask.TimeEntry that was returned by the API.
.EXAMPLE
Get-AtwsTimeEntry -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsTimeEntry -TimeEntryName SomeName
Returns the object with TimeEntryName 'SomeName', if any.
 .EXAMPLE
Get-AtwsTimeEntry -TimeEntryName 'Some Name'
Returns the object with TimeEntryName 'Some Name', if any.
 .EXAMPLE
Get-AtwsTimeEntry -TimeEntryName 'Some Name' -NotEquals TimeEntryName
Returns any objects with a TimeEntryName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsTimeEntry -TimeEntryName SomeName* -Like TimeEntryName
Returns any object with a TimeEntryName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsTimeEntry -TimeEntryName SomeName* -NotLike TimeEntryName
Returns any object with a TimeEntryName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsTimeEntry -T <PickList Label>
Returns any TimeEntrys with property T equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsTimeEntry -T <PickList Label> -NotEquals T 
Returns any TimeEntrys with property T NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsTimeEntry -T <PickList Label1>, <PickList Label2>
Returns any TimeEntrys with property T equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsTimeEntry -T <PickList Label1>, <PickList Label2> -NotEquals T
Returns any TimeEntrys with property T NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsTimeEntry -Id 1234 -TimeEntryName SomeName* -T <PickList Label1>, <PickList Label2> -Like TimeEntryName -NotEquals T -GreaterThan Id
An example of a more complex query. This command returns any TimeEntrys with Id GREATER THAN 1234, a TimeEntryName that matches the simple pattern SomeName* AND that has a T that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsTimeEntry
 .LINK
Remove-AtwsTimeEntry
 .LINK
Set-AtwsTimeEntry

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
    [ValidateSet('AllocationCodeID', 'BillingApprovalResourceID', 'ContractID', 'ContractServiceBundleID', 'ContractServiceID', 'ImpersonatorCreatorResourceID', 'ImpersonatorUpdaterResourceID', 'InternalAllocationCodeID', 'ResourceID', 'RoleID', 'TaskID', 'TicketID')]
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
    [ValidateSet('BillingItem:TimeEntryID', 'BillingItemApprovalLevel:TimeEntryID', 'NotificationHistory:TimeEntryID')]
    [string]
    $GetExternalEntityByThisEntityId,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# Time Entry ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Task ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $TaskID,

# Ticket ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $TicketID,

# Internal Allocation Code ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $InternalAllocationCodeID,

# TaskTypeLink
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $Type,

# Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $DateWorked,

# Start Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $StartDateTime,

# End Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $EndDateTime,

# Hours Worked
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $HoursWorked,

# Hours To Bill
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $HoursToBill,

# Offset Hours
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $OffsetHours,

# Summary Notes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,32000)]
    [string[]]
    $SummaryNotes,

# Internal Notes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,32000)]
    [string[]]
    $InternalNotes,

# Role ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $RoleID,

# Create Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CreateDateTime,

# Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $ResourceID,

# Created User ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CreatorUserID,

# Last Modified By User ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $LastModifiedUserID,

# Last Modified Datetime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LastModifiedDateTime,

# Allocation Code ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $AllocationCodeID,

# Contract ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ContractID,

# Show On Invoice
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $ShowOnInvoice,

# Non-Billable
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $NonBillable,

# Billing Approval Level Most Recent
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BillingApprovalLevelMostRecent,

# Billing Approval Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BillingApprovalResourceID,

# Billing Approval Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $BillingApprovalDateTime,

# Contract Service ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $ContractServiceID,

# Contract Service Bundle ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $ContractServiceBundleID,

# Impersonator Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ImpersonatorCreatorResourceID,

# Impersonator Updater Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ImpersonatorUpdaterResourceID,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TaskID', 'TicketID', 'InternalAllocationCodeID', 'Type', 'DateWorked', 'StartDateTime', 'EndDateTime', 'HoursWorked', 'HoursToBill', 'OffsetHours', 'SummaryNotes', 'InternalNotes', 'RoleID', 'CreateDateTime', 'ResourceID', 'CreatorUserID', 'LastModifiedUserID', 'LastModifiedDateTime', 'AllocationCodeID', 'ContractID', 'ShowOnInvoice', 'NonBillable', 'BillingApprovalLevelMostRecent', 'BillingApprovalResourceID', 'BillingApprovalDateTime', 'ContractServiceID', 'ContractServiceBundleID', 'ImpersonatorCreatorResourceID', 'ImpersonatorUpdaterResourceID')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TaskID', 'TicketID', 'InternalAllocationCodeID', 'Type', 'DateWorked', 'StartDateTime', 'EndDateTime', 'HoursWorked', 'HoursToBill', 'OffsetHours', 'SummaryNotes', 'InternalNotes', 'RoleID', 'CreateDateTime', 'ResourceID', 'CreatorUserID', 'LastModifiedUserID', 'LastModifiedDateTime', 'AllocationCodeID', 'ContractID', 'ShowOnInvoice', 'NonBillable', 'BillingApprovalLevelMostRecent', 'BillingApprovalResourceID', 'BillingApprovalDateTime', 'ContractServiceID', 'ContractServiceBundleID', 'ImpersonatorCreatorResourceID', 'ImpersonatorUpdaterResourceID')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TaskID', 'TicketID', 'InternalAllocationCodeID', 'Type', 'DateWorked', 'StartDateTime', 'EndDateTime', 'HoursWorked', 'HoursToBill', 'OffsetHours', 'SummaryNotes', 'InternalNotes', 'RoleID', 'CreateDateTime', 'ResourceID', 'CreatorUserID', 'LastModifiedUserID', 'LastModifiedDateTime', 'AllocationCodeID', 'ContractID', 'ShowOnInvoice', 'NonBillable', 'BillingApprovalLevelMostRecent', 'BillingApprovalResourceID', 'BillingApprovalDateTime', 'ContractServiceID', 'ContractServiceBundleID', 'ImpersonatorCreatorResourceID', 'ImpersonatorUpdaterResourceID')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TaskID', 'TicketID', 'InternalAllocationCodeID', 'Type', 'DateWorked', 'StartDateTime', 'EndDateTime', 'HoursWorked', 'HoursToBill', 'OffsetHours', 'SummaryNotes', 'InternalNotes', 'RoleID', 'CreateDateTime', 'ResourceID', 'CreatorUserID', 'LastModifiedUserID', 'LastModifiedDateTime', 'AllocationCodeID', 'ContractID', 'BillingApprovalLevelMostRecent', 'BillingApprovalResourceID', 'BillingApprovalDateTime', 'ContractServiceID', 'ContractServiceBundleID', 'ImpersonatorCreatorResourceID', 'ImpersonatorUpdaterResourceID')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TaskID', 'TicketID', 'InternalAllocationCodeID', 'Type', 'DateWorked', 'StartDateTime', 'EndDateTime', 'HoursWorked', 'HoursToBill', 'OffsetHours', 'SummaryNotes', 'InternalNotes', 'RoleID', 'CreateDateTime', 'ResourceID', 'CreatorUserID', 'LastModifiedUserID', 'LastModifiedDateTime', 'AllocationCodeID', 'ContractID', 'BillingApprovalLevelMostRecent', 'BillingApprovalResourceID', 'BillingApprovalDateTime', 'ContractServiceID', 'ContractServiceBundleID', 'ImpersonatorCreatorResourceID', 'ImpersonatorUpdaterResourceID')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TaskID', 'TicketID', 'InternalAllocationCodeID', 'Type', 'DateWorked', 'StartDateTime', 'EndDateTime', 'HoursWorked', 'HoursToBill', 'OffsetHours', 'SummaryNotes', 'InternalNotes', 'RoleID', 'CreateDateTime', 'ResourceID', 'CreatorUserID', 'LastModifiedUserID', 'LastModifiedDateTime', 'AllocationCodeID', 'ContractID', 'BillingApprovalLevelMostRecent', 'BillingApprovalResourceID', 'BillingApprovalDateTime', 'ContractServiceID', 'ContractServiceBundleID', 'ImpersonatorCreatorResourceID', 'ImpersonatorUpdaterResourceID')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TaskID', 'TicketID', 'InternalAllocationCodeID', 'Type', 'DateWorked', 'StartDateTime', 'EndDateTime', 'HoursWorked', 'HoursToBill', 'OffsetHours', 'SummaryNotes', 'InternalNotes', 'RoleID', 'CreateDateTime', 'ResourceID', 'CreatorUserID', 'LastModifiedUserID', 'LastModifiedDateTime', 'AllocationCodeID', 'ContractID', 'BillingApprovalLevelMostRecent', 'BillingApprovalResourceID', 'BillingApprovalDateTime', 'ContractServiceID', 'ContractServiceBundleID', 'ImpersonatorCreatorResourceID', 'ImpersonatorUpdaterResourceID')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('SummaryNotes', 'InternalNotes')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('SummaryNotes', 'InternalNotes')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('SummaryNotes', 'InternalNotes')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('SummaryNotes', 'InternalNotes')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('SummaryNotes', 'InternalNotes')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('DateWorked', 'StartDateTime', 'EndDateTime', 'CreateDateTime', 'LastModifiedDateTime', 'BillingApprovalDateTime')]
    [string[]]
    $IsThisDay
  )

    begin { 
        $entityName = 'TimeEntry'
    
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
