#Requires -Version 4.0
#Version 1.6.2.12
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

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

Additional operators for [String] parameters are:
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
    [ValidateSet('AllocationCodeID', 'BillingApprovalResourceID', 'ContractID', 'ContractServiceBundleID', 'ContractServiceID', 'ImpersonatorCreatorResourceID', 'ImpersonatorUpdaterResourceID', 'InternalAllocationCodeID', 'ResourceID', 'RoleID', 'TaskID', 'TicketID')]
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
    [ValidateSet('BillingItem:TimeEntryID', 'BillingItemApprovalLevel:TimeEntryID', 'NotificationHistory:TimeEntryID')]
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

# Time Entry ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Task ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $TaskID,

# Ticket ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $TicketID,

# Internal Allocation Code ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $InternalAllocationCodeID,

# TaskTypeLink
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $Type,

# Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $DateWorked,

# Start Date Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $StartDateTime,

# End Date Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $EndDateTime,

# Hours Worked
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $HoursWorked,

# Hours To Bill
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $HoursToBill,

# Offset Hours
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $OffsetHours,

# Summary Notes
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,8000)]
    [string[]]
    $SummaryNotes,

# Internal Notes
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,8000)]
    [string[]]
    $InternalNotes,

# Role ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $RoleID,

# Create Date Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CreateDateTime,

# Resource ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $ResourceID,

# Created User ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CreatorUserID,

# Last Modified By User ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $LastModifiedUserID,

# Last Modified Datetime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LastModifiedDateTime,

# Allocation Code ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $AllocationCodeID,

# Contract ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ContractID,

# Show On Invoice
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $ShowOnInvoice,

# Non-Billable
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $NonBillable,

# Billing Approval Level Most Recent
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BillingApprovalLevelMostRecent,

# Billing Approval Resource ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BillingApprovalResourceID,

# Billing Approval Date Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $BillingApprovalDateTime,

# Contract Service ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $ContractServiceID,

# Contract Service Bundle ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $ContractServiceBundleID,

# Impersonator Creator Resource ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ImpersonatorCreatorResourceID,

# Impersonator Updater Resource ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ImpersonatorUpdaterResourceID,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TaskID', 'TicketID', 'InternalAllocationCodeID', 'Type', 'DateWorked', 'StartDateTime', 'EndDateTime', 'HoursWorked', 'HoursToBill', 'OffsetHours', 'SummaryNotes', 'InternalNotes', 'RoleID', 'CreateDateTime', 'ResourceID', 'CreatorUserID', 'LastModifiedUserID', 'LastModifiedDateTime', 'AllocationCodeID', 'ContractID', 'ShowOnInvoice', 'NonBillable', 'BillingApprovalLevelMostRecent', 'BillingApprovalResourceID', 'BillingApprovalDateTime', 'ContractServiceID', 'ContractServiceBundleID', 'ImpersonatorCreatorResourceID', 'ImpersonatorUpdaterResourceID')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TaskID', 'TicketID', 'InternalAllocationCodeID', 'Type', 'DateWorked', 'StartDateTime', 'EndDateTime', 'HoursWorked', 'HoursToBill', 'OffsetHours', 'SummaryNotes', 'InternalNotes', 'RoleID', 'CreateDateTime', 'ResourceID', 'CreatorUserID', 'LastModifiedUserID', 'LastModifiedDateTime', 'AllocationCodeID', 'ContractID', 'ShowOnInvoice', 'NonBillable', 'BillingApprovalLevelMostRecent', 'BillingApprovalResourceID', 'BillingApprovalDateTime', 'ContractServiceID', 'ContractServiceBundleID', 'ImpersonatorCreatorResourceID', 'ImpersonatorUpdaterResourceID')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TaskID', 'TicketID', 'InternalAllocationCodeID', 'Type', 'DateWorked', 'StartDateTime', 'EndDateTime', 'HoursWorked', 'HoursToBill', 'OffsetHours', 'SummaryNotes', 'InternalNotes', 'RoleID', 'CreateDateTime', 'ResourceID', 'CreatorUserID', 'LastModifiedUserID', 'LastModifiedDateTime', 'AllocationCodeID', 'ContractID', 'ShowOnInvoice', 'NonBillable', 'BillingApprovalLevelMostRecent', 'BillingApprovalResourceID', 'BillingApprovalDateTime', 'ContractServiceID', 'ContractServiceBundleID', 'ImpersonatorCreatorResourceID', 'ImpersonatorUpdaterResourceID')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TaskID', 'TicketID', 'InternalAllocationCodeID', 'Type', 'DateWorked', 'StartDateTime', 'EndDateTime', 'HoursWorked', 'HoursToBill', 'OffsetHours', 'SummaryNotes', 'InternalNotes', 'RoleID', 'CreateDateTime', 'ResourceID', 'CreatorUserID', 'LastModifiedUserID', 'LastModifiedDateTime', 'AllocationCodeID', 'ContractID', 'BillingApprovalLevelMostRecent', 'BillingApprovalResourceID', 'BillingApprovalDateTime', 'ContractServiceID', 'ContractServiceBundleID', 'ImpersonatorCreatorResourceID', 'ImpersonatorUpdaterResourceID')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TaskID', 'TicketID', 'InternalAllocationCodeID', 'Type', 'DateWorked', 'StartDateTime', 'EndDateTime', 'HoursWorked', 'HoursToBill', 'OffsetHours', 'SummaryNotes', 'InternalNotes', 'RoleID', 'CreateDateTime', 'ResourceID', 'CreatorUserID', 'LastModifiedUserID', 'LastModifiedDateTime', 'AllocationCodeID', 'ContractID', 'BillingApprovalLevelMostRecent', 'BillingApprovalResourceID', 'BillingApprovalDateTime', 'ContractServiceID', 'ContractServiceBundleID', 'ImpersonatorCreatorResourceID', 'ImpersonatorUpdaterResourceID')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TaskID', 'TicketID', 'InternalAllocationCodeID', 'Type', 'DateWorked', 'StartDateTime', 'EndDateTime', 'HoursWorked', 'HoursToBill', 'OffsetHours', 'SummaryNotes', 'InternalNotes', 'RoleID', 'CreateDateTime', 'ResourceID', 'CreatorUserID', 'LastModifiedUserID', 'LastModifiedDateTime', 'AllocationCodeID', 'ContractID', 'BillingApprovalLevelMostRecent', 'BillingApprovalResourceID', 'BillingApprovalDateTime', 'ContractServiceID', 'ContractServiceBundleID', 'ImpersonatorCreatorResourceID', 'ImpersonatorUpdaterResourceID')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TaskID', 'TicketID', 'InternalAllocationCodeID', 'Type', 'DateWorked', 'StartDateTime', 'EndDateTime', 'HoursWorked', 'HoursToBill', 'OffsetHours', 'SummaryNotes', 'InternalNotes', 'RoleID', 'CreateDateTime', 'ResourceID', 'CreatorUserID', 'LastModifiedUserID', 'LastModifiedDateTime', 'AllocationCodeID', 'ContractID', 'BillingApprovalLevelMostRecent', 'BillingApprovalResourceID', 'BillingApprovalDateTime', 'ContractServiceID', 'ContractServiceBundleID', 'ImpersonatorCreatorResourceID', 'ImpersonatorUpdaterResourceID')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('SummaryNotes', 'InternalNotes')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('SummaryNotes', 'InternalNotes')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('SummaryNotes', 'InternalNotes')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('SummaryNotes', 'InternalNotes')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('SummaryNotes', 'InternalNotes')]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('DateWorked', 'StartDateTime', 'EndDateTime', 'CreateDateTime', 'LastModifiedDateTime', 'BillingApprovalDateTime')]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'TimeEntry'
    
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
    
      # Datetimeparameters
      $Fields = Get-AtwsFieldInfo -Entity $EntityName
    
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
