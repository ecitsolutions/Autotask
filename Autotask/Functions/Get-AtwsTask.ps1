#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
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
TaskType
Status
PriorityLabel
CreatorType
CompletedByType
LastActivityPersonType
TaskCategoryID

Entities that have fields that refer to the base entity of this CmdLet:


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
    [Collections.Generic.List[string]]
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

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# Account Physical Location ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $AccountPhysicalLocationID,

# Allocation Code Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $AllocationCodeID,

# Resource
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $AssignedResourceID,

# Resource Role Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $AssignedResourceRoleID,

# Can Client Portal User Complete Task
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[boolean]]]
    $CanClientPortalUserCompleteTask,

# Task Completed By
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $CompletedByResourceID,

# Completed By Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Task -FieldName CompletedByType -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Task -FieldName CompletedByType -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $CompletedByType,

# Task Complete Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[datetime]]]
    $CompletedDateTime,

# Task Creation Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[datetime]]]
    $CreateDateTime,

# Task Creator
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $CreatorResourceID,

# Creator Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Task -FieldName CreatorType -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Task -FieldName CreatorType -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $CreatorType,

# Task Department Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Task -FieldName DepartmentID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Task -FieldName DepartmentID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $DepartmentID,

# Task Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,8000)]
    [Collections.Generic.List[string]]
    $Description,

# Task End Datetime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[datetime]]]
    $EndDateTime,

# Task Estimated Hours
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $EstimatedHours,

# Task External ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [Collections.Generic.List[string]]
    $ExternalID,

# Hours to be Scheduled
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $HoursToBeScheduled,

# Task ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[long]]]
    $id,

# Is Visible in Client Portal
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[boolean]]]
    $IsVisibleInClientPortal,

# Task Last Activity Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[datetime]]]
    $LastActivityDateTime,

# Last Activity Person Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Task -FieldName LastActivityPersonType -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Task -FieldName LastActivityPersonType -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $LastActivityPersonType,

# Last Activity By
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $LastActivityResourceID,

# Phase ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $PhaseID,

# Task Priority
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $Priority,

# Priority Label
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Task -FieldName PriorityLabel -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Task -FieldName PriorityLabel -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $PriorityLabel,

# Project
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[Int]]]
    $ProjectID,

# Purchase Order Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [Collections.Generic.List[string]]
    $PurchaseOrderNumber,

# Task Start Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[datetime]]]
    $StartDateTime,

# Task Status
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Task -FieldName Status -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Task -FieldName Status -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $Status,

# Task Category ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Task -FieldName TaskCategoryID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Task -FieldName TaskCategoryID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $TaskCategoryID,

# Task Billable
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[boolean]]]
    $TaskIsBillable,

# Task Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [Collections.Generic.List[string]]
    $TaskNumber,

# Task Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Task -FieldName TaskType -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Task -FieldName TaskType -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $TaskType,

# Task Title
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,255)]
    [Collections.Generic.List[string]]
    $Title,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('PurchaseOrderNumber', 'CreatorResourceID', 'TaskIsBillable', 'CreatorType', 'CompletedDateTime', 'AllocationCodeID', 'id', 'DepartmentID', 'TaskNumber', 'Priority', 'CompletedByResourceID', 'PriorityLabel', 'ProjectID', 'TaskCategoryID', 'IsVisibleInClientPortal', 'LastActivityDateTime', 'LastActivityPersonType', 'Status', 'AssignedResourceRoleID', 'RemainingHours', 'CreateDateTime', 'CanClientPortalUserCompleteTask', 'TaskType', 'AccountPhysicalLocationID', 'Title', 'ExternalID', 'PhaseID', 'CompletedByType', 'EndDateTime', 'EstimatedHours', 'Description', 'HoursToBeScheduled', 'StartDateTime', 'LastActivityResourceID', 'AssignedResourceID')]
    [Collections.Generic.List[string]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('PurchaseOrderNumber', 'CreatorResourceID', 'TaskIsBillable', 'CreatorType', 'CompletedDateTime', 'AllocationCodeID', 'id', 'DepartmentID', 'TaskNumber', 'Priority', 'CompletedByResourceID', 'PriorityLabel', 'ProjectID', 'TaskCategoryID', 'IsVisibleInClientPortal', 'LastActivityDateTime', 'LastActivityPersonType', 'Status', 'AssignedResourceRoleID', 'RemainingHours', 'CreateDateTime', 'CanClientPortalUserCompleteTask', 'TaskType', 'AccountPhysicalLocationID', 'Title', 'ExternalID', 'PhaseID', 'CompletedByType', 'EndDateTime', 'EstimatedHours', 'Description', 'HoursToBeScheduled', 'StartDateTime', 'LastActivityResourceID', 'AssignedResourceID')]
    [Collections.Generic.List[string]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('PurchaseOrderNumber', 'CreatorResourceID', 'TaskIsBillable', 'CreatorType', 'CompletedDateTime', 'AllocationCodeID', 'id', 'DepartmentID', 'TaskNumber', 'Priority', 'CompletedByResourceID', 'PriorityLabel', 'ProjectID', 'TaskCategoryID', 'IsVisibleInClientPortal', 'LastActivityDateTime', 'LastActivityPersonType', 'Status', 'AssignedResourceRoleID', 'RemainingHours', 'CreateDateTime', 'CanClientPortalUserCompleteTask', 'TaskType', 'AccountPhysicalLocationID', 'Title', 'ExternalID', 'PhaseID', 'CompletedByType', 'EndDateTime', 'EstimatedHours', 'Description', 'HoursToBeScheduled', 'StartDateTime', 'LastActivityResourceID', 'AssignedResourceID')]
    [Collections.Generic.List[string]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ProjectID', 'PhaseID', 'Title', 'Description', 'StartDateTime', 'EndDateTime', 'DepartmentID', 'AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'TaskType', 'Status', 'CompletedDateTime', 'CreateDateTime', 'CreatorResourceID', 'EstimatedHours', 'id', 'TaskNumber', 'ExternalID', 'LastActivityDateTime', 'Priority', 'PurchaseOrderNumber', 'RemainingHours', 'HoursToBeScheduled', 'PriorityLabel', 'CreatorType', 'CompletedByResourceID', 'CompletedByType', 'LastActivityResourceID', 'LastActivityPersonType', 'AccountPhysicalLocationID', 'TaskCategoryID')]
    [Collections.Generic.List[string]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ProjectID', 'PhaseID', 'Title', 'Description', 'StartDateTime', 'EndDateTime', 'DepartmentID', 'AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'TaskType', 'Status', 'CompletedDateTime', 'CreateDateTime', 'CreatorResourceID', 'EstimatedHours', 'id', 'TaskNumber', 'ExternalID', 'LastActivityDateTime', 'Priority', 'PurchaseOrderNumber', 'RemainingHours', 'HoursToBeScheduled', 'PriorityLabel', 'CreatorType', 'CompletedByResourceID', 'CompletedByType', 'LastActivityResourceID', 'LastActivityPersonType', 'AccountPhysicalLocationID', 'TaskCategoryID')]
    [Collections.Generic.List[string]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ProjectID', 'PhaseID', 'Title', 'Description', 'StartDateTime', 'EndDateTime', 'DepartmentID', 'AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'TaskType', 'Status', 'CompletedDateTime', 'CreateDateTime', 'CreatorResourceID', 'EstimatedHours', 'id', 'TaskNumber', 'ExternalID', 'LastActivityDateTime', 'Priority', 'PurchaseOrderNumber', 'RemainingHours', 'HoursToBeScheduled', 'PriorityLabel', 'CreatorType', 'CompletedByResourceID', 'CompletedByType', 'LastActivityResourceID', 'LastActivityPersonType', 'AccountPhysicalLocationID', 'TaskCategoryID')]
    [Collections.Generic.List[string]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ProjectID', 'PhaseID', 'Title', 'Description', 'StartDateTime', 'EndDateTime', 'DepartmentID', 'AllocationCodeID', 'AssignedResourceID', 'AssignedResourceRoleID', 'TaskType', 'Status', 'CompletedDateTime', 'CreateDateTime', 'CreatorResourceID', 'EstimatedHours', 'id', 'TaskNumber', 'ExternalID', 'LastActivityDateTime', 'Priority', 'PurchaseOrderNumber', 'RemainingHours', 'HoursToBeScheduled', 'PriorityLabel', 'CreatorType', 'CompletedByResourceID', 'CompletedByType', 'LastActivityResourceID', 'LastActivityPersonType', 'AccountPhysicalLocationID', 'TaskCategoryID')]
    [Collections.Generic.List[string]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Title', 'Description', 'TaskNumber', 'ExternalID', 'PurchaseOrderNumber')]
    [Collections.Generic.List[string]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Title', 'Description', 'TaskNumber', 'ExternalID', 'PurchaseOrderNumber')]
    [Collections.Generic.List[string]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Title', 'Description', 'TaskNumber', 'ExternalID', 'PurchaseOrderNumber')]
    [Collections.Generic.List[string]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Title', 'Description', 'TaskNumber', 'ExternalID', 'PurchaseOrderNumber')]
    [Collections.Generic.List[string]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Title', 'Description', 'TaskNumber', 'ExternalID', 'PurchaseOrderNumber')]
    [Collections.Generic.List[string]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('StartDateTime', 'EndDateTime', 'CompletedDateTime', 'CreateDateTime', 'LastActivityDateTime')]
    [Collections.Generic.List[string]]
    $IsThisDay
  )

    begin {
        $entityName = 'Task'

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

        $result = [collections.generic.list[psobject]]::new()
        $iterations = [collections.generic.list[psobject]]::new()
    }


    process {
        # Parameterset Get_All has a single parameter: -All
        # Set the Filter manually to get every single object of this type
        if ($PSCmdlet.ParameterSetName -eq 'Get_all') {
            $Filter = @('id', '-ge', 0)
            $iterations.Add($Filter)
        }
        # So it is not -All. If Filter does not exist it has to be By_parameters
        elseif (-not ($Filter)) {

            Write-Debug ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)

           
            # Count the values of the first parameter passed. We will not try do to this on more than 1 parameter, nor on any 
            # other parameter than the first. This is lazy, but efficient.
            $count = $PSBoundParameters.Values[0].count

            # If the count is less than or equal to 200 we pass PSBoundParameters as is
            if ($count -le 200) {
                [collections.generic.list[string]]$Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $entityName
                $iterations.Add($Filter)
            }
            # More than 200 values. This will cause a SQL query nested too much. Break a single parameter
            # into segments and create multiple queries with max 200 values
            else {
                # Deduplicate the value list or the same ID may be included in more than 1 query
                $outerLoop = $PSBoundParameters.Values[0] | Sort-Object -Unique

                Write-Verbose ('{0}: Received {1} objects containing {2} unique values for parameter {3}' -f $MyInvocation.MyCommand.Name, $count, $outerLoop.Count, $param)

                # Make a writable copy of PSBoundParameters
                $BoundParameters = $PSBoundParameters
                for ($i = 0; $i -lt $outerLoop.count; $i += 200) {
                    $j = $i + 199
                    if ($j -ge $outerLoop.count) {
                        $j = $outerLoop.count - 1
                    }

                    # make a selection
                    $BoundParameters[$param] = $outerLoop[$i .. $j]

                    Write-Verbose ('{0}: Asking for {1} values {2} to {3}' -f $MyInvocation.MyCommand.Name, $param, $i, $j)

                    # Convert named parameters to a filter definition that can be parsed to QueryXML
                    [collections.generic.list[string]]$Filter = ConvertTo-AtwsFilter -BoundParameters $BoundParameters -EntityName $entityName
                    $iterations.Add($Filter)
                }
            }
        }
        # Not parameters, nor Get_all. There are only three parameter sets, so now we know
        # that we were passed a Filter
        else {

            Write-Debug ('{0}: Query based on manual filter, parsing' -F $MyInvocation.MyCommand.Name)

            # Parse the filter string and expand variables in _this_ scope (dot-sourcing)
            # or the variables will not be available and expansion will fail
            $Filter = . Update-AtwsFilter -Filterstring $Filter
            $iterations.Add($Filter)
        }

        # Prepare shouldProcess comments
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to query the Autotask Web API for {1}(s).' -F $caption, $entityName
        $verboseWarning = '{0}: About to query the Autotask Web API for {1}(s). Do you want to continue?' -F $caption, $entityName

        # Lets do it and say we didn't!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) {
            foreach ($Filter in $iterations) {

                try {
                    # Make the query and pass the optional parameters to Get-AtwsData
                    # Force list even if result is only 1 object to be compatible with addrange()
                    [collections.generic.list[psobject]]$response = Get-AtwsData -Entity $entityName -Filter $Filter `
                        -NoPickListLabel:$NoPickListLabel.IsPresent `
                        -GetReferenceEntityById $GetReferenceEntityById
                }
                catch {
                    write-host "ERROR: " -ForegroundColor Red -NoNewline
                    write-host $_.Exception.Message
                    write-host ("{0}: {1}" -f $_.CategoryInfo.Category,$_.CategoryInfo.Reason) -ForegroundColor Cyan
                    $_.ScriptStackTrace -split '\n' | ForEach-Object {
                        Write-host "  |  " -ForegroundColor Cyan -NoNewline
                        Write-host $_
                    }
                }
                # Add response to result
                $result.AddRange($response)

                Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $result.Count)
            }
        }
    }

    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        if ($result) {
            Return [array]$result
        }
    }


}
