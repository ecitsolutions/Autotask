#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsBusinessLocation
{


<#
.SYNOPSIS
This function get one or more BusinessLocation through the Autotask Web Services API.
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
FirstDayOfWeek
DateFormat
TimeFormat
NumberFormat
TimeZoneID
HolidayHoursType

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.BusinessLocation[]]. This function outputs the Autotask.BusinessLocation that was returned by the API.
.EXAMPLE
Get-AtwsBusinessLocation -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsBusinessLocation -BusinessLocationName SomeName
Returns the object with BusinessLocationName 'SomeName', if any.
 .EXAMPLE
Get-AtwsBusinessLocation -BusinessLocationName 'Some Name'
Returns the object with BusinessLocationName 'Some Name', if any.
 .EXAMPLE
Get-AtwsBusinessLocation -BusinessLocationName 'Some Name' -NotEquals BusinessLocationName
Returns any objects with a BusinessLocationName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsBusinessLocation -BusinessLocationName SomeName* -Like BusinessLocationName
Returns any object with a BusinessLocationName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsBusinessLocation -BusinessLocationName SomeName* -NotLike BusinessLocationName
Returns any object with a BusinessLocationName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsBusinessLocation -FirstDayOfWeek <PickList Label>
Returns any BusinessLocations with property FirstDayOfWeek equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsBusinessLocation -FirstDayOfWeek <PickList Label> -NotEquals FirstDayOfWeek 
Returns any BusinessLocations with property FirstDayOfWeek NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsBusinessLocation -FirstDayOfWeek <PickList Label1>, <PickList Label2>
Returns any BusinessLocations with property FirstDayOfWeek equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsBusinessLocation -FirstDayOfWeek <PickList Label1>, <PickList Label2> -NotEquals FirstDayOfWeek
Returns any BusinessLocations with property FirstDayOfWeek NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsBusinessLocation -Id 1234 -BusinessLocationName SomeName* -FirstDayOfWeek <PickList Label1>, <PickList Label2> -Like BusinessLocationName -NotEquals FirstDayOfWeek -GreaterThan Id
An example of a more complex query. This command returns any BusinessLocations with Id GREATER THAN 1234, a BusinessLocationName that matches the simple pattern SomeName* AND that has a FirstDayOfWeek that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsBusinessLocation
 .LINK
Set-AtwsBusinessLocation

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
    [ValidateSet('CountryID', 'HolidaySetID')]
    [string]
    $GetReferenceEntityById,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# Additional Address Info
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $AdditionalAddressInfo,

# Address1
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $Address1,

# Address2
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $Address2,

# City
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $City,

# Country ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CountryID,

# Date Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity BusinessLocation -FieldName DateFormat -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity BusinessLocation -FieldName DateFormat -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $DateFormat,

# Default
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $Default,

# First Day Of Week
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity BusinessLocation -FieldName FirstDayOfWeek -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity BusinessLocation -FieldName FirstDayOfWeek -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $FirstDayOfWeek,

# FridayBusinessHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $FridayBusinessHoursEndTime,

# FridayBusinessHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $FridayBusinessHoursStartTime,

# FridayExtendedHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $FridayExtendedHoursEndTime,

# FridayExtendedHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $FridayExtendedHoursStartTime,

# Holiday Extended Hours End Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $HolidayExtendedHoursEndTime,

# Holiday Extended Hours Start Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $HolidayExtendedHoursStartTime,

# Holiday Hours End Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $HolidayHoursEndTime,

# Holiday Hours Start Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $HolidayHoursStartTime,

# Holiday Hours Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity BusinessLocation -FieldName HolidayHoursType -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity BusinessLocation -FieldName HolidayHoursType -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $HolidayHoursType,

# Holiday Set ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $HolidaySetID,

# Business Location ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# MondayBusinessHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $MondayBusinessHoursEndTime,

# MondayBusinessHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $MondayBusinessHoursStartTime,

# MondayExtendedHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $MondayExtendedHoursEndTime,

# MondayExtendedHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $MondayExtendedHoursStartTime,

# Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [string[]]
    $Name,

# No Hours On Holidays
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $NoHoursOnHolidays,

# Number Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity BusinessLocation -FieldName NumberFormat -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity BusinessLocation -FieldName NumberFormat -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $NumberFormat,

# Postal Code
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,20)]
    [string[]]
    $PostalCode,

# SaturdayBusinessHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $SaturdayBusinessHoursEndTime,

# SaturdayBusinessHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $SaturdayBusinessHoursStartTime,

# SaturdayExtendedHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $SaturdayExtendedHoursEndTime,

# SaturdayExtendedHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $SaturdayExtendedHoursStartTime,

# State
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $State,

# SundayBusinessHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $SundayBusinessHoursEndTime,

# SundayBusinessHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $SundayBusinessHoursStartTime,

# SundayExtendedHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $SundayExtendedHoursEndTime,

# SundayExtendedHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $SundayExtendedHoursStartTime,

# ThursdayBusinessHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ThursdayBusinessHoursEndTime,

# ThursdayBusinessHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ThursdayBusinessHoursStartTime,

# ThursdayExtendedHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ThursdayExtendedHoursEndTime,

# ThursdayExtendedHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ThursdayExtendedHoursStartTime,

# Time Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity BusinessLocation -FieldName TimeFormat -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity BusinessLocation -FieldName TimeFormat -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $TimeFormat,

# Time Zone ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity BusinessLocation -FieldName TimeZoneID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity BusinessLocation -FieldName TimeZoneID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $TimeZoneID,

# TuesdayBusinessHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $TuesdayBusinessHoursEndTime,

# TuesdayBusinessHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $TuesdayBusinessHoursStartTime,

# TuesdayExtendedHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $TuesdayExtendedHoursEndTime,

# TuesdayExtendedHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $TuesdayExtendedHoursStartTime,

# WednesdayBusinessHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $WednesdayBusinessHoursEndTime,

# WednesdayBusinessHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $WednesdayBusinessHoursStartTime,

# WednesdayExtendedHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $WednesdayExtendedHoursEndTime,

# WednesdayExtendedHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $WednesdayExtendedHoursStartTime,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('NumberFormat', 'FridayBusinessHoursEndTime', 'FirstDayOfWeek', 'WednesdayExtendedHoursEndTime', 'HolidayExtendedHoursEndTime', 'MondayBusinessHoursEndTime', 'ThursdayExtendedHoursStartTime', 'FridayBusinessHoursStartTime', 'TimeFormat', 'SundayBusinessHoursStartTime', 'id', 'HolidayHoursStartTime', 'SundayExtendedHoursEndTime', 'CountryID', 'HolidaySetID', 'SundayBusinessHoursEndTime', 'Address1', 'Default', 'FridayExtendedHoursEndTime', 'WednesdayExtendedHoursStartTime', 'TuesdayExtendedHoursStartTime', 'SundayExtendedHoursStartTime', 'Address2', 'TuesdayBusinessHoursEndTime', 'SaturdayExtendedHoursEndTime', 'MondayExtendedHoursEndTime', 'HolidayHoursEndTime', 'State', 'WednesdayBusinessHoursStartTime', 'Name', 'PostalCode', 'TimeZoneID', 'ThursdayBusinessHoursEndTime', 'TuesdayExtendedHoursEndTime', 'NoHoursOnHolidays', 'HolidayHoursType', 'MondayBusinessHoursStartTime', 'ThursdayBusinessHoursStartTime', 'TuesdayBusinessHoursStartTime', 'SaturdayBusinessHoursEndTime', 'DateFormat', 'City', 'SaturdayBusinessHoursStartTime', 'FridayExtendedHoursStartTime', 'WednesdayBusinessHoursEndTime', 'AdditionalAddressInfo', 'HolidayExtendedHoursStartTime', 'ThursdayExtendedHoursEndTime', 'MondayExtendedHoursStartTime', 'SaturdayExtendedHoursStartTime')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('NumberFormat', 'FridayBusinessHoursEndTime', 'FirstDayOfWeek', 'WednesdayExtendedHoursEndTime', 'HolidayExtendedHoursEndTime', 'MondayBusinessHoursEndTime', 'ThursdayExtendedHoursStartTime', 'FridayBusinessHoursStartTime', 'TimeFormat', 'SundayBusinessHoursStartTime', 'id', 'HolidayHoursStartTime', 'SundayExtendedHoursEndTime', 'CountryID', 'HolidaySetID', 'SundayBusinessHoursEndTime', 'Address1', 'Default', 'FridayExtendedHoursEndTime', 'WednesdayExtendedHoursStartTime', 'TuesdayExtendedHoursStartTime', 'SundayExtendedHoursStartTime', 'Address2', 'TuesdayBusinessHoursEndTime', 'SaturdayExtendedHoursEndTime', 'MondayExtendedHoursEndTime', 'HolidayHoursEndTime', 'State', 'WednesdayBusinessHoursStartTime', 'Name', 'PostalCode', 'TimeZoneID', 'ThursdayBusinessHoursEndTime', 'TuesdayExtendedHoursEndTime', 'NoHoursOnHolidays', 'HolidayHoursType', 'MondayBusinessHoursStartTime', 'ThursdayBusinessHoursStartTime', 'TuesdayBusinessHoursStartTime', 'SaturdayBusinessHoursEndTime', 'DateFormat', 'City', 'SaturdayBusinessHoursStartTime', 'FridayExtendedHoursStartTime', 'WednesdayBusinessHoursEndTime', 'AdditionalAddressInfo', 'HolidayExtendedHoursStartTime', 'ThursdayExtendedHoursEndTime', 'MondayExtendedHoursStartTime', 'SaturdayExtendedHoursStartTime')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('NumberFormat', 'FridayBusinessHoursEndTime', 'FirstDayOfWeek', 'WednesdayExtendedHoursEndTime', 'HolidayExtendedHoursEndTime', 'MondayBusinessHoursEndTime', 'ThursdayExtendedHoursStartTime', 'FridayBusinessHoursStartTime', 'TimeFormat', 'SundayBusinessHoursStartTime', 'id', 'HolidayHoursStartTime', 'SundayExtendedHoursEndTime', 'CountryID', 'HolidaySetID', 'SundayBusinessHoursEndTime', 'Address1', 'Default', 'FridayExtendedHoursEndTime', 'WednesdayExtendedHoursStartTime', 'TuesdayExtendedHoursStartTime', 'SundayExtendedHoursStartTime', 'Address2', 'TuesdayBusinessHoursEndTime', 'SaturdayExtendedHoursEndTime', 'MondayExtendedHoursEndTime', 'HolidayHoursEndTime', 'State', 'WednesdayBusinessHoursStartTime', 'Name', 'PostalCode', 'TimeZoneID', 'ThursdayBusinessHoursEndTime', 'TuesdayExtendedHoursEndTime', 'NoHoursOnHolidays', 'HolidayHoursType', 'MondayBusinessHoursStartTime', 'ThursdayBusinessHoursStartTime', 'TuesdayBusinessHoursStartTime', 'SaturdayBusinessHoursEndTime', 'DateFormat', 'City', 'SaturdayBusinessHoursStartTime', 'FridayExtendedHoursStartTime', 'WednesdayBusinessHoursEndTime', 'AdditionalAddressInfo', 'HolidayExtendedHoursStartTime', 'ThursdayExtendedHoursEndTime', 'MondayExtendedHoursStartTime', 'SaturdayExtendedHoursStartTime')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'AdditionalAddressInfo', 'CountryID', 'HolidaySetID', 'FirstDayOfWeek', 'DateFormat', 'TimeFormat', 'NumberFormat', 'TimeZoneID', 'SundayBusinessHoursStartTime', 'SundayBusinessHoursEndTime', 'SundayExtendedHoursStartTime', 'SundayExtendedHoursEndTime', 'MondayBusinessHoursStartTime', 'MondayBusinessHoursEndTime', 'MondayExtendedHoursStartTime', 'MondayExtendedHoursEndTime', 'TuesdayBusinessHoursStartTime', 'TuesdayBusinessHoursEndTime', 'TuesdayExtendedHoursStartTime', 'TuesdayExtendedHoursEndTime', 'WednesdayBusinessHoursStartTime', 'WednesdayBusinessHoursEndTime', 'WednesdayExtendedHoursStartTime', 'WednesdayExtendedHoursEndTime', 'ThursdayBusinessHoursStartTime', 'ThursdayBusinessHoursEndTime', 'ThursdayExtendedHoursStartTime', 'ThursdayExtendedHoursEndTime', 'FridayBusinessHoursStartTime', 'FridayBusinessHoursEndTime', 'FridayExtendedHoursStartTime', 'FridayExtendedHoursEndTime', 'SaturdayBusinessHoursStartTime', 'SaturdayBusinessHoursEndTime', 'SaturdayExtendedHoursStartTime', 'SaturdayExtendedHoursEndTime', 'HolidayHoursType', 'HolidayHoursStartTime', 'HolidayHoursEndTime', 'HolidayExtendedHoursStartTime', 'HolidayExtendedHoursEndTime')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'AdditionalAddressInfo', 'CountryID', 'HolidaySetID', 'FirstDayOfWeek', 'DateFormat', 'TimeFormat', 'NumberFormat', 'TimeZoneID', 'SundayBusinessHoursStartTime', 'SundayBusinessHoursEndTime', 'SundayExtendedHoursStartTime', 'SundayExtendedHoursEndTime', 'MondayBusinessHoursStartTime', 'MondayBusinessHoursEndTime', 'MondayExtendedHoursStartTime', 'MondayExtendedHoursEndTime', 'TuesdayBusinessHoursStartTime', 'TuesdayBusinessHoursEndTime', 'TuesdayExtendedHoursStartTime', 'TuesdayExtendedHoursEndTime', 'WednesdayBusinessHoursStartTime', 'WednesdayBusinessHoursEndTime', 'WednesdayExtendedHoursStartTime', 'WednesdayExtendedHoursEndTime', 'ThursdayBusinessHoursStartTime', 'ThursdayBusinessHoursEndTime', 'ThursdayExtendedHoursStartTime', 'ThursdayExtendedHoursEndTime', 'FridayBusinessHoursStartTime', 'FridayBusinessHoursEndTime', 'FridayExtendedHoursStartTime', 'FridayExtendedHoursEndTime', 'SaturdayBusinessHoursStartTime', 'SaturdayBusinessHoursEndTime', 'SaturdayExtendedHoursStartTime', 'SaturdayExtendedHoursEndTime', 'HolidayHoursType', 'HolidayHoursStartTime', 'HolidayHoursEndTime', 'HolidayExtendedHoursStartTime', 'HolidayExtendedHoursEndTime')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'AdditionalAddressInfo', 'CountryID', 'HolidaySetID', 'FirstDayOfWeek', 'DateFormat', 'TimeFormat', 'NumberFormat', 'TimeZoneID', 'SundayBusinessHoursStartTime', 'SundayBusinessHoursEndTime', 'SundayExtendedHoursStartTime', 'SundayExtendedHoursEndTime', 'MondayBusinessHoursStartTime', 'MondayBusinessHoursEndTime', 'MondayExtendedHoursStartTime', 'MondayExtendedHoursEndTime', 'TuesdayBusinessHoursStartTime', 'TuesdayBusinessHoursEndTime', 'TuesdayExtendedHoursStartTime', 'TuesdayExtendedHoursEndTime', 'WednesdayBusinessHoursStartTime', 'WednesdayBusinessHoursEndTime', 'WednesdayExtendedHoursStartTime', 'WednesdayExtendedHoursEndTime', 'ThursdayBusinessHoursStartTime', 'ThursdayBusinessHoursEndTime', 'ThursdayExtendedHoursStartTime', 'ThursdayExtendedHoursEndTime', 'FridayBusinessHoursStartTime', 'FridayBusinessHoursEndTime', 'FridayExtendedHoursStartTime', 'FridayExtendedHoursEndTime', 'SaturdayBusinessHoursStartTime', 'SaturdayBusinessHoursEndTime', 'SaturdayExtendedHoursStartTime', 'SaturdayExtendedHoursEndTime', 'HolidayHoursType', 'HolidayHoursStartTime', 'HolidayHoursEndTime', 'HolidayExtendedHoursStartTime', 'HolidayExtendedHoursEndTime')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'AdditionalAddressInfo', 'CountryID', 'HolidaySetID', 'FirstDayOfWeek', 'DateFormat', 'TimeFormat', 'NumberFormat', 'TimeZoneID', 'SundayBusinessHoursStartTime', 'SundayBusinessHoursEndTime', 'SundayExtendedHoursStartTime', 'SundayExtendedHoursEndTime', 'MondayBusinessHoursStartTime', 'MondayBusinessHoursEndTime', 'MondayExtendedHoursStartTime', 'MondayExtendedHoursEndTime', 'TuesdayBusinessHoursStartTime', 'TuesdayBusinessHoursEndTime', 'TuesdayExtendedHoursStartTime', 'TuesdayExtendedHoursEndTime', 'WednesdayBusinessHoursStartTime', 'WednesdayBusinessHoursEndTime', 'WednesdayExtendedHoursStartTime', 'WednesdayExtendedHoursEndTime', 'ThursdayBusinessHoursStartTime', 'ThursdayBusinessHoursEndTime', 'ThursdayExtendedHoursStartTime', 'ThursdayExtendedHoursEndTime', 'FridayBusinessHoursStartTime', 'FridayBusinessHoursEndTime', 'FridayExtendedHoursStartTime', 'FridayExtendedHoursEndTime', 'SaturdayBusinessHoursStartTime', 'SaturdayBusinessHoursEndTime', 'SaturdayExtendedHoursStartTime', 'SaturdayExtendedHoursEndTime', 'HolidayHoursType', 'HolidayHoursStartTime', 'HolidayHoursEndTime', 'HolidayExtendedHoursStartTime', 'HolidayExtendedHoursEndTime')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'AdditionalAddressInfo', 'DateFormat', 'TimeFormat', 'NumberFormat')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'AdditionalAddressInfo', 'DateFormat', 'TimeFormat', 'NumberFormat')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'AdditionalAddressInfo', 'DateFormat', 'TimeFormat', 'NumberFormat')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'AdditionalAddressInfo', 'DateFormat', 'TimeFormat', 'NumberFormat')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'AdditionalAddressInfo', 'DateFormat', 'TimeFormat', 'NumberFormat')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('SundayBusinessHoursStartTime', 'SundayBusinessHoursEndTime', 'SundayExtendedHoursStartTime', 'SundayExtendedHoursEndTime', 'MondayBusinessHoursStartTime', 'MondayBusinessHoursEndTime', 'MondayExtendedHoursStartTime', 'MondayExtendedHoursEndTime', 'TuesdayBusinessHoursStartTime', 'TuesdayBusinessHoursEndTime', 'TuesdayExtendedHoursStartTime', 'TuesdayExtendedHoursEndTime', 'WednesdayBusinessHoursStartTime', 'WednesdayBusinessHoursEndTime', 'WednesdayExtendedHoursStartTime', 'WednesdayExtendedHoursEndTime', 'ThursdayBusinessHoursStartTime', 'ThursdayBusinessHoursEndTime', 'ThursdayExtendedHoursStartTime', 'ThursdayExtendedHoursEndTime', 'FridayBusinessHoursStartTime', 'FridayBusinessHoursEndTime', 'FridayExtendedHoursStartTime', 'FridayExtendedHoursEndTime', 'SaturdayBusinessHoursStartTime', 'SaturdayBusinessHoursEndTime', 'SaturdayExtendedHoursStartTime', 'SaturdayExtendedHoursEndTime', 'HolidayHoursStartTime', 'HolidayHoursEndTime', 'HolidayExtendedHoursStartTime', 'HolidayExtendedHoursEndTime')]
    [string[]]
    $IsThisDay
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
        
        $result = [Collections.ArrayList]::new()
        $iterations = [Collections.Arraylist]::new()
    }


    process {
        # Parameterset Get_All has a single parameter: -All
        # Set the Filter manually to get every single object of this type 
        if ($PSCmdlet.ParameterSetName -eq 'Get_all') { 
            $Filter = @('id', '-ge', 0)
            [void]$iterations.Add($Filter)
        }
        # So it is not -All. If Filter does not exist it has to be By_parameters
        elseif (-not ($Filter)) {
    
            Write-Debug ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)
            
            # find parameter with highest count
            $index = @{}
            $max = ($PSBoundParameters.getenumerator() | foreach-object { $index[$_.count] = $_.key ; $_.count } | Sort-Object -Descending)[0]
            $param = $index[$max]
            # Extract the parameter content, sort it ascending (we assume it is an Id field)
            # and deduplicate
            $count = $PSBoundParameters[$param].count
            [array]$outerLoop = $PSBoundParameters[$param] | Sort-Object -Unique
            $dedup = $outerLoop.Count

            Write-Verbose ('{0}: Received {1} objects containing {2} unique values for parameter {3}' -f $MyInvocation.MyCommand.Name, $count, $dedup, $param)

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
                [string[]]$Filter = ConvertTo-AtwsFilter -BoundParameters $BoundParameters -EntityName $entityName
                [void]$iterations.Add($Filter)
            }
        }
        # Not parameters, nor Get_all. There are only three parameter sets, so now we know
        # that we were passed a Filter
        else {
      
            Write-Debug ('{0}: Query based on manual filter, parsing' -F $MyInvocation.MyCommand.Name)
            
            # Parse the filter string and expand variables in _this_ scope (dot-sourcing)
            # or the variables will not be available and expansion will fail
            $Filter = . Update-AtwsFilter -Filterstring $Filter
            [void]$iterations.Add($Filter)
        } 

        # Prepare shouldProcess comments
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to query the Autotask Web API for {1}(s).' -F $caption, $entityName
        $verboseWarning = '{0}: About to query the Autotask Web API for {1}(s). Do you want to continue?' -F $caption, $entityName
    
        # Lets do it and say we didn't!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
            foreach ($Filter in $iterations) { 

                # Make the query and pass the optional parameters to Get-AtwsData
                $response = Get-AtwsData -Entity $entityName -Filter $Filter `
                    -NoPickListLabel:$NoPickListLabel.IsPresent `
                    -GetReferenceEntityById $GetReferenceEntityById
                
                # If multiple items use .addrange(). If a single item use .add()
                if ($response.count -gt 1) { 
                    [void]$result.AddRange($response)
                }
                else {
                    [void]$result.Add($response)
                }
                Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $result.Count)
            }
        }
    }

    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        if ($result) {
            Return $result
        }
    }


}
