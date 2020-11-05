#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function New-AtwsTask
{


<#
.SYNOPSIS
This function creates a new Task through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.Task] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the Task with Id number 0 you could write 'New-AtwsTask -Id 0' or you could write 'New-AtwsTask -Filter {Id -eq 0}.

'New-AtwsTask -Id 0,4' could be written as 'New-AtwsTask -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new Task you need the following required fields:
 -ProjectID
 -Status
 -TaskType
 -Title

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Task]. This function outputs the Autotask.Task that was created by the API.
.EXAMPLE
$result = New-AtwsTask -ProjectID [Value] -Status [Value] -TaskType [Value] -Title [Value]
Creates a new [Autotask.Task] through the Web Services API and returns the new object.
 .EXAMPLE
$result = Get-AtwsTask -Id 124 | New-AtwsTask 
Copies [Autotask.Task] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsTask -Id 124 | New-AtwsTask | Set-AtwsTask -ParameterName <Parameter Value>
Copies [Autotask.Task] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsTask to modify the object.
 .EXAMPLE
$result = Get-AtwsTask -Id 124 | New-AtwsTask | Set-AtwsTask -ParameterName <Parameter Value> -Passthru
Copies [Autotask.Task] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsTask to modify the object and returns the new object.

.LINK
Get-AtwsTask
 .LINK
Set-AtwsTask

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
    [Autotask.Task[]]
    $InputObject,

# Account Physical Location ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $AccountPhysicalLocationID,

# Allocation Code Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $AllocationCodeID,

# Resource
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $AssignedResourceID,

# Resource Role Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $AssignedResourceRoleID,

# Can Client Portal User Complete Task
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $CanClientPortalUserCompleteTask,

# Task Completed By
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
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
    [string]
    $CompletedByType,

# Task Complete Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $CompletedDateTime,

# Task Creation Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $CreateDateTime,

# Task Creator
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
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
    [string]
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
    [string]
    $DepartmentID,

# Task Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,8000)]
    [string]
    $Description,

# Task End Datetime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $EndDateTime,

# Task Estimated Hours
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $EstimatedHours,

# Task External ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $ExternalID,

# Hours to be Scheduled
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $HoursToBeScheduled,

# Is Visible in Client Portal
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $IsVisibleInClientPortal,

# Task Last Activity Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
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
    [string]
    $LastActivityPersonType,

# Last Activity By
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $LastActivityResourceID,

# Phase ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $PhaseID,

# Task Priority
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
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
    [string]
    $PriorityLabel,

# Project
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $ProjectID,

# Purchase Order Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $PurchaseOrderNumber,

# Remaining Hours
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $RemainingHours,

# Task Start Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $StartDateTime,

# Task Status
    [Parameter(
      Mandatory = $true,
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
    [string]
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
    [string]
    $TaskCategoryID,

# Task Billable
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $TaskIsBillable,

# Task Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $TaskNumber,

# Task Type
    [Parameter(
      Mandatory = $true,
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
    [string]
    $TaskType,

# Task Title
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,255)]
    [string]
    $Title
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
        
        $processObject = [Collections.ArrayList]::new()
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
                $fieldNames = $entityInfo.WritableFields

                if ($PSBoundParameters.ContainsKey('UserDefinedFields')) { 
                    $fieldNames += 'UserDefinedFields' 
                }

                foreach ($field in $fieldNames) { 
                    $newObject.$field = $object.$field 
                }

                if ($newObject -is [Autotask.Ticket]) {
                    Write-Verbose -Message ('{0}: Copy Object mode: Object is a Ticket. Title must be modified to avoid duplicate detection.' -F $MyInvocation.MyCommand.Name)  
                    $title = '{0} (Copy {1})' -F $newObject.Title, $CopyNo
                    $copyNo++
                    $newObject.Title = $title
                }
                [void]$processObject.Add($newObject)
            }   
        }
        else {
            Write-Debug -Message ('{0}: Creating empty [Autotask.{1}]' -F $MyInvocation.MyCommand.Name, $entityName) 
            [void]$processObject.add((New-Object -TypeName Autotask.$entityName))   
        }
        
        # Prepare shouldProcess comments
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to create {1} {2}(s). This action cannot be undone.' -F $caption, $processObject.Count, $entityName
        $verboseWarning = '{0}: About to create {1} {2}(s). This action may not be undoable. Do you want to continue?' -F $caption, $processObject.Count, $entityName

        # Lets don't and say we did!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
            
            # Process parameters and update objects with their values
            $processObject = $processObject | Update-AtwsObjectsWithParameters -BoundParameters $PSBoundParameters -EntityName $EntityName
            
            $result = Set-AtwsData -Entity $processObject -Create
        }
    }

    end {
        Write-Debug -Message ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $result.count, $entityName)
        Return $result
    }

}
