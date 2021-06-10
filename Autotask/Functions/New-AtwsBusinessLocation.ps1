#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function New-AtwsBusinessLocation
{


<#
.SYNOPSIS
This function creates a new BusinessLocation through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.BusinessLocation] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the BusinessLocation with Id number 0 you could write 'New-AtwsBusinessLocation -Id 0' or you could write 'New-AtwsBusinessLocation -Filter {Id -eq 0}.

'New-AtwsBusinessLocation -Id 0,4' could be written as 'New-AtwsBusinessLocation -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new BusinessLocation you need the following required fields:
 -Name
 -DateFormat
 -TimeFormat
 -NumberFormat
 -TimeZoneID

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.BusinessLocation]. This function outputs the Autotask.BusinessLocation that was created by the API.
.EXAMPLE
$result = New-AtwsBusinessLocation -Name [Value] -DateFormat [Value] -TimeFormat [Value] -NumberFormat [Value] -TimeZoneID [Value]
Creates a new [Autotask.BusinessLocation] through the Web Services API and returns the new object.
 .EXAMPLE
$result = Get-AtwsBusinessLocation -Id 124 | New-AtwsBusinessLocation 
Copies [Autotask.BusinessLocation] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsBusinessLocation -Id 124 | New-AtwsBusinessLocation | Set-AtwsBusinessLocation -ParameterName <Parameter Value>
Copies [Autotask.BusinessLocation] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsBusinessLocation to modify the object.
 .EXAMPLE
$result = Get-AtwsBusinessLocation -Id 124 | New-AtwsBusinessLocation | Set-AtwsBusinessLocation -ParameterName <Parameter Value> -Passthru
Copies [Autotask.BusinessLocation] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsBusinessLocation to modify the object and returns the new object.

.NOTES
Related commands:
Get-AtwsBusinessLocation
 Set-AtwsBusinessLocation

#>

  [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName='By_parameters', ConfirmImpact='Low',
  HelpURI='https://github.com/ecitsolutions/Autotask/blob/master/Docs/New-AtwsBusinessLocation.md')]
  Param
  (
# An array of objects to create
    [Parameter(
      ParametersetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.BusinessLocation[]]
    $InputObject,

# Additional Address Info
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string]
    $AdditionalAddressInfo,

# Address1
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string]
    $Address1,

# Address2
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string]
    $Address2,

# City
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $City,

# Country ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $CountryID,

# Date Format
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity BusinessLocation -FieldName DateFormat -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity BusinessLocation -FieldName DateFormat -Label) + (Get-AtwsPicklistValue -Entity BusinessLocation -FieldName DateFormat -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $DateFormat,

# Default
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $Default,

# First Day Of Week
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity BusinessLocation -FieldName FirstDayOfWeek -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity BusinessLocation -FieldName FirstDayOfWeek -Label) + (Get-AtwsPicklistValue -Entity BusinessLocation -FieldName FirstDayOfWeek -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $FirstDayOfWeek,

# FridayBusinessHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $FridayBusinessHoursEndTime,

# FridayBusinessHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $FridayBusinessHoursStartTime,

# FridayExtendedHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $FridayExtendedHoursEndTime,

# FridayExtendedHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $FridayExtendedHoursStartTime,

# Holiday Extended Hours End Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $HolidayExtendedHoursEndTime,

# Holiday Extended Hours Start Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $HolidayExtendedHoursStartTime,

# Holiday Hours End Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $HolidayHoursEndTime,

# Holiday Hours Start Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $HolidayHoursStartTime,

# Holiday Hours Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity BusinessLocation -FieldName HolidayHoursType -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity BusinessLocation -FieldName HolidayHoursType -Label) + (Get-AtwsPicklistValue -Entity BusinessLocation -FieldName HolidayHoursType -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $HolidayHoursType,

# Holiday Set ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $HolidaySetID,

# MondayBusinessHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $MondayBusinessHoursEndTime,

# MondayBusinessHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $MondayBusinessHoursStartTime,

# MondayExtendedHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $MondayExtendedHoursEndTime,

# MondayExtendedHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $MondayExtendedHoursStartTime,

# Name
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [string]
    $Name,

# No Hours On Holidays
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $NoHoursOnHolidays,

# Number Format
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity BusinessLocation -FieldName NumberFormat -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity BusinessLocation -FieldName NumberFormat -Label) + (Get-AtwsPicklistValue -Entity BusinessLocation -FieldName NumberFormat -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $NumberFormat,

# Postal Code
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,20)]
    [string]
    $PostalCode,

# SaturdayBusinessHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $SaturdayBusinessHoursEndTime,

# SaturdayBusinessHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $SaturdayBusinessHoursStartTime,

# SaturdayExtendedHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $SaturdayExtendedHoursEndTime,

# SaturdayExtendedHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $SaturdayExtendedHoursStartTime,

# State
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string]
    $State,

# SundayBusinessHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $SundayBusinessHoursEndTime,

# SundayBusinessHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $SundayBusinessHoursStartTime,

# SundayExtendedHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $SundayExtendedHoursEndTime,

# SundayExtendedHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $SundayExtendedHoursStartTime,

# ThursdayBusinessHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $ThursdayBusinessHoursEndTime,

# ThursdayBusinessHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $ThursdayBusinessHoursStartTime,

# ThursdayExtendedHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $ThursdayExtendedHoursEndTime,

# ThursdayExtendedHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $ThursdayExtendedHoursStartTime,

# Time Format
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity BusinessLocation -FieldName TimeFormat -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity BusinessLocation -FieldName TimeFormat -Label) + (Get-AtwsPicklistValue -Entity BusinessLocation -FieldName TimeFormat -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $TimeFormat,

# Time Zone ID
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity BusinessLocation -FieldName TimeZoneID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity BusinessLocation -FieldName TimeZoneID -Label) + (Get-AtwsPicklistValue -Entity BusinessLocation -FieldName TimeZoneID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $TimeZoneID,

# TuesdayBusinessHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $TuesdayBusinessHoursEndTime,

# TuesdayBusinessHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $TuesdayBusinessHoursStartTime,

# TuesdayExtendedHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $TuesdayExtendedHoursEndTime,

# TuesdayExtendedHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $TuesdayExtendedHoursStartTime,

# WednesdayBusinessHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $WednesdayBusinessHoursEndTime,

# WednesdayBusinessHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $WednesdayBusinessHoursStartTime,

# WednesdayExtendedHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $WednesdayExtendedHoursEndTime,

# WednesdayExtendedHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $WednesdayExtendedHoursStartTime
  )

    begin {
        $entityName = 'BusinessLocation'

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

            # Copy the input array to the processObject collection
            if ($InputObject.count -gt 1) { 
                [collections.generic.list[psobject]]$processObject = $InputObject
            }
            else {
                $processObject.add($InputObject[0])
            }

            # If any objects has the ID property set to a value, the sum of all IDs will be larger than zero
            $sum = ($processObject | Measure-Object -Property Id -Sum).Sum

            # If $sum has value we must reset object IDs or we will modify existing objects, not create new ones
            if ($sum -gt 0) {
                foreach ($object in $processObject) {
                    $object.Id = $null
                }
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
                # Force list even if result is only 1 object to be compatible with addrange()
                [collections.generic.list[psobject]]$response = Set-AtwsData -Entity $processObject -Create
            }
            catch {
                # Write a debug message with detailed information to developers
                $ex = $_.Exception
                $reason = ("{0}: {1}" -f $_.CategoryInfo.Category, $_.CategoryInfo.Reason)
                $message = "{2}: {0}`r`n`r`nLine:{1}`r`n`r`nScript stacktrace:`r`n{3}" -f $ex.Message, $_.InvocationInfo.Line, $reason, $_.ScriptStackTrace
                while ($ex.InnerException) { 
                    $ex = $ex.InnerException
                    $message = "InnerException: {0}`n{1}" -F $ex.Message, $message
                }

                Write-Debug $message

                # Pass on the error
                $PSCmdlet.ThrowTerminatingError($_)
                return
            }
            # If using pipeline this block (process) will run once pr item in the pipeline. make sure to return them all
            if ($response.Count -gt 0) {
                $result.AddRange($response)
            }
        }
    }

    end {
        Write-Debug -Message ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $result.count, $entityName)
        Return [array]$result
    }

}
