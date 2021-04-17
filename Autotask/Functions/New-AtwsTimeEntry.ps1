#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function New-AtwsTimeEntry
{


<#
.SYNOPSIS
This function creates a new TimeEntry through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.TimeEntry] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the TimeEntry with Id number 0 you could write 'New-AtwsTimeEntry -Id 0' or you could write 'New-AtwsTimeEntry -Filter {Id -eq 0}.

'New-AtwsTimeEntry -Id 0,4' could be written as 'New-AtwsTimeEntry -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new TimeEntry you need the following required fields:
 -ResourceID

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.TimeEntry]. This function outputs the Autotask.TimeEntry that was created by the API.
.EXAMPLE
$result = New-AtwsTimeEntry -ResourceID [Value]
Creates a new [Autotask.TimeEntry] through the Web Services API and returns the new object.
 .EXAMPLE
$result = Get-AtwsTimeEntry -Id 124 | New-AtwsTimeEntry 
Copies [Autotask.TimeEntry] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsTimeEntry -Id 124 | New-AtwsTimeEntry | Set-AtwsTimeEntry -ParameterName <Parameter Value>
Copies [Autotask.TimeEntry] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsTimeEntry to modify the object.
 .EXAMPLE
$result = Get-AtwsTimeEntry -Id 124 | New-AtwsTimeEntry | Set-AtwsTimeEntry -ParameterName <Parameter Value> -Passthru
Copies [Autotask.TimeEntry] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsTimeEntry to modify the object and returns the new object.

.LINK
Remove-AtwsTimeEntry
 .LINK
Get-AtwsTimeEntry
 .LINK
Set-AtwsTimeEntry

#>

  [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName='By_parameters', ConfirmImpact='Low')]
  Param
  (
# An array of objects to create
    [Parameter(
      ParametersetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.TimeEntry[]]
    $InputObject,

# Allocation Code ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $AllocationCodeID,

# Billing Approval Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $BillingApprovalDateTime,

# Billing Approval Level Most Recent
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $BillingApprovalLevelMostRecent,

# Billing Approval Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $BillingApprovalResourceID,

# Contract ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ContractID,

# Contract Service Bundle ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
    $ContractServiceBundleID,

# Contract Service ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
    $ContractServiceID,

# Create Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $CreateDateTime,

# Created User ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $CreatorUserID,

# Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $DateWorked,

# End Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $EndDateTime,

# Hours To Bill
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $HoursToBill,

# Hours Worked
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $HoursWorked,

# Impersonator Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ImpersonatorCreatorResourceID,

# Impersonator Updater Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ImpersonatorUpdaterResourceID,

# Internal Allocation Code ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $InternalAllocationCodeID,

# Internal Notes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,32000)]
    [string]
    $InternalNotes,

# Last Modified Datetime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $LastModifiedDateTime,

# Last Modified By User ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $LastModifiedUserID,

# Non-Billable
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $NonBillable,

# Offset Hours
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $OffsetHours,

# Resource ID
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $ResourceID,

# Role ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $RoleID,

# Show On Invoice
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $ShowOnInvoice,

# Start Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $StartDateTime,

# Summary Notes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,32000)]
    [string]
    $SummaryNotes,

# Task ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $TaskID,

# Ticket ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $TicketID,

# TaskTypeLink
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity TimeEntry -FieldName Type -Label
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity TimeEntry -FieldName Type -Label) + (Get-AtwsPicklistValue -Entity TimeEntry -FieldName Type -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $Type
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

        $processObject = [collections.generic.list[psobject]]::new()
        $result = [collections.generic.list[psobject]]::new()
    }

    process {

        if ($InputObject) {
            Write-Verbose -Message ('{0}: Copy Object mode: Setting ID property to zero' -F $MyInvocation.MyCommand.Name)

            $entityInfo = Get-AtwsFieldInfo -Entity $entityName -EntityInfo

            $CopyNo = 1

            foreach ($object in $InputObject) {
                # Create a new object and copy properties
                $newObject = New-Object -TypeName Autotask.$entityName

                # Copy every non readonly property
                $fieldNames = [collections.generic.list[psobject]]::new()
                $WriteableFields = $entityInfo.WriteableFields
                $RequiredFields = $entityInfo.RequiredFields

                if ($WriteableFields.count -gt 1) { $fieldNames.AddRange($WriteableFields) } else { $fieldNames.Add($WriteableFields) }
                if ($RequiredFields.count -gt 1) { $fieldNames.AddRange($RequiredFields) } else { $fieldNames.Add($RequiredFields) }

                if ($PSBoundParameters.ContainsKey('UserDefinedFields')) {
                    $fieldNames += 'UserDefinedFields'
                }

                foreach ($field in $fieldNames) {
                    $newObject.$field = $object.$field
                }

                if ($newObject -is [Autotask.Ticket] -and $object.id -gt 0) {
                    Write-Verbose -Message ('{0}: Copy Object mode: Object is a Ticket. Title must be modified to avoid duplicate detection.' -F $MyInvocation.MyCommand.Name)
                    $title = '{0} (Copy {1})' -F $newObject.Title, $CopyNo
                    $copyNo++
                    $newObject.Title = $title
                }
                $processObject.Add($newObject)
            }
        }
        else {
            Write-Debug -Message ('{0}: Creating empty [Autotask.{1}]' -F $MyInvocation.MyCommand.Name, $entityName)
            $processObject.add((New-Object -TypeName Autotask.$entityName))
        }

        # Prepare shouldProcess comments
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to create {1} {2}(s). This action cannot be undone.' -F $caption, $processObject.Count, $entityName
        $verboseWarning = '{0}: About to create {1} {2}(s). This action may not be undoable. Do you want to continue?' -F $caption, $processObject.Count, $entityName

        # Lets don't and say we did!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) {

            # Process parameters and update objects with their values
            $processObject = $processObject | Update-AtwsObjectsWithParameters -BoundParameters $PSBoundParameters -EntityName $EntityName

            try {
                # If using pipeline this block (process) will run once pr item in the pipeline. make sure to return them all
                $Data = Set-AtwsData -Entity $processObject -Create
                if ($Data.Count -gt 1) {
                    $result.AddRange($Data)
                }
                else {
                    $result.Add($Data)
                }
            }
            catch {
                write-host "ERROR: " -ForegroundColor Red -NoNewline
                write-host $_.Exception.Message
                write-host ("{0}: {1}" -f $_.CategoryInfo.Category, $_.CategoryInfo.Reason) -ForegroundColor Cyan
                $_.ScriptStackTrace -split '\n' | ForEach-Object {
                    Write-host "  |  " -ForegroundColor Cyan -NoNewline
                    Write-host $_
                }
            }
        }
    }

    end {
        Write-Debug -Message ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $result.count, $entityName)
        Return [array]$result
    }

}
