#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function New-AtwsProjectNote
{


<#
.SYNOPSIS
This function creates a new ProjectNote through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.ProjectNote] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the ProjectNote with Id number 0 you could write 'New-AtwsProjectNote -Id 0' or you could write 'New-AtwsProjectNote -Filter {Id -eq 0}.

'New-AtwsProjectNote -Id 0,4' could be written as 'New-AtwsProjectNote -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new ProjectNote you need the following required fields:
 -Description
 -NoteType
 -Publish
 -ProjectID
 -Title
 -Announce

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.ProjectNote]. This function outputs the Autotask.ProjectNote that was created by the API.
.EXAMPLE
$result = New-AtwsProjectNote -Description [Value] -NoteType [Value] -Publish [Value] -ProjectID [Value] -Title [Value] -Announce [Value]
Creates a new [Autotask.ProjectNote] through the Web Services API and returns the new object.
 .EXAMPLE
$result = Get-AtwsProjectNote -Id 124 | New-AtwsProjectNote 
Copies [Autotask.ProjectNote] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsProjectNote -Id 124 | New-AtwsProjectNote | Set-AtwsProjectNote -ParameterName <Parameter Value>
Copies [Autotask.ProjectNote] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsProjectNote to modify the object.
 .EXAMPLE
$result = Get-AtwsProjectNote -Id 124 | New-AtwsProjectNote | Set-AtwsProjectNote -ParameterName <Parameter Value> -Passthru
Copies [Autotask.ProjectNote] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsProjectNote to modify the object and returns the new object.

.LINK
Get-AtwsProjectNote
 .LINK
Set-AtwsProjectNote

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
    [Autotask.ProjectNote[]]
    $InputObject,

# Announce
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [boolean]
    $Announce,

# Create Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $CreateDateTime,

# Created By Contact ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $CreatedByContactID,

# Creator Resource
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $CreatorResourceID,

# Description
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,32000)]
    [string]
    $Description,

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

# LastActivityDate
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $LastActivityDate,

# Note Type
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity ProjectNote -FieldName NoteType -Label
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity ProjectNote -FieldName NoteType -Label) + (Get-AtwsPicklistValue -Entity ProjectNote -FieldName NoteType -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $NoteType,

# Project
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $ProjectID,

# Publish
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity ProjectNote -FieldName Publish -Label
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity ProjectNote -FieldName Publish -Label) + (Get-AtwsPicklistValue -Entity ProjectNote -FieldName Publish -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $Publish,

# Title
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,250)]
    [string]
    $Title
  )

    begin {
        $entityName = 'ProjectNote'

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
