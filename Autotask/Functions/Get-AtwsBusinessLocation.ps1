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
    [string[]]
    $TimeFormat,

# Time Zone ID
    [Parameter(
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
    [ValidateSet('AdditionalAddressInfo', 'Address1', 'Address2', 'City', 'CountryID', 'DateFormat', 'Default', 'FirstDayOfWeek', 'FridayBusinessHoursEndTime', 'FridayBusinessHoursStartTime', 'FridayExtendedHoursEndTime', 'FridayExtendedHoursStartTime', 'HolidayExtendedHoursEndTime', 'HolidayExtendedHoursStartTime', 'HolidayHoursEndTime', 'HolidayHoursStartTime', 'HolidayHoursType', 'HolidaySetID', 'id', 'MondayBusinessHoursEndTime', 'MondayBusinessHoursStartTime', 'MondayExtendedHoursEndTime', 'MondayExtendedHoursStartTime', 'Name', 'NoHoursOnHolidays', 'NumberFormat', 'PostalCode', 'SaturdayBusinessHoursEndTime', 'SaturdayBusinessHoursStartTime', 'SaturdayExtendedHoursEndTime', 'SaturdayExtendedHoursStartTime', 'State', 'SundayBusinessHoursEndTime', 'SundayBusinessHoursStartTime', 'SundayExtendedHoursEndTime', 'SundayExtendedHoursStartTime', 'ThursdayBusinessHoursEndTime', 'ThursdayBusinessHoursStartTime', 'ThursdayExtendedHoursEndTime', 'ThursdayExtendedHoursStartTime', 'TimeFormat', 'TimeZoneID', 'TuesdayBusinessHoursEndTime', 'TuesdayBusinessHoursStartTime', 'TuesdayExtendedHoursEndTime', 'TuesdayExtendedHoursStartTime', 'WednesdayBusinessHoursEndTime', 'WednesdayBusinessHoursStartTime', 'WednesdayExtendedHoursEndTime', 'WednesdayExtendedHoursStartTime')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AdditionalAddressInfo', 'Address1', 'Address2', 'City', 'CountryID', 'DateFormat', 'Default', 'FirstDayOfWeek', 'FridayBusinessHoursEndTime', 'FridayBusinessHoursStartTime', 'FridayExtendedHoursEndTime', 'FridayExtendedHoursStartTime', 'HolidayExtendedHoursEndTime', 'HolidayExtendedHoursStartTime', 'HolidayHoursEndTime', 'HolidayHoursStartTime', 'HolidayHoursType', 'HolidaySetID', 'id', 'MondayBusinessHoursEndTime', 'MondayBusinessHoursStartTime', 'MondayExtendedHoursEndTime', 'MondayExtendedHoursStartTime', 'Name', 'NoHoursOnHolidays', 'NumberFormat', 'PostalCode', 'SaturdayBusinessHoursEndTime', 'SaturdayBusinessHoursStartTime', 'SaturdayExtendedHoursEndTime', 'SaturdayExtendedHoursStartTime', 'State', 'SundayBusinessHoursEndTime', 'SundayBusinessHoursStartTime', 'SundayExtendedHoursEndTime', 'SundayExtendedHoursStartTime', 'ThursdayBusinessHoursEndTime', 'ThursdayBusinessHoursStartTime', 'ThursdayExtendedHoursEndTime', 'ThursdayExtendedHoursStartTime', 'TimeFormat', 'TimeZoneID', 'TuesdayBusinessHoursEndTime', 'TuesdayBusinessHoursStartTime', 'TuesdayExtendedHoursEndTime', 'TuesdayExtendedHoursStartTime', 'WednesdayBusinessHoursEndTime', 'WednesdayBusinessHoursStartTime', 'WednesdayExtendedHoursEndTime', 'WednesdayExtendedHoursStartTime')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AdditionalAddressInfo', 'Address1', 'Address2', 'City', 'CountryID', 'DateFormat', 'Default', 'FirstDayOfWeek', 'FridayBusinessHoursEndTime', 'FridayBusinessHoursStartTime', 'FridayExtendedHoursEndTime', 'FridayExtendedHoursStartTime', 'HolidayExtendedHoursEndTime', 'HolidayExtendedHoursStartTime', 'HolidayHoursEndTime', 'HolidayHoursStartTime', 'HolidayHoursType', 'HolidaySetID', 'id', 'MondayBusinessHoursEndTime', 'MondayBusinessHoursStartTime', 'MondayExtendedHoursEndTime', 'MondayExtendedHoursStartTime', 'Name', 'NoHoursOnHolidays', 'NumberFormat', 'PostalCode', 'SaturdayBusinessHoursEndTime', 'SaturdayBusinessHoursStartTime', 'SaturdayExtendedHoursEndTime', 'SaturdayExtendedHoursStartTime', 'State', 'SundayBusinessHoursEndTime', 'SundayBusinessHoursStartTime', 'SundayExtendedHoursEndTime', 'SundayExtendedHoursStartTime', 'ThursdayBusinessHoursEndTime', 'ThursdayBusinessHoursStartTime', 'ThursdayExtendedHoursEndTime', 'ThursdayExtendedHoursStartTime', 'TimeFormat', 'TimeZoneID', 'TuesdayBusinessHoursEndTime', 'TuesdayBusinessHoursStartTime', 'TuesdayExtendedHoursEndTime', 'TuesdayExtendedHoursStartTime', 'WednesdayBusinessHoursEndTime', 'WednesdayBusinessHoursStartTime', 'WednesdayExtendedHoursEndTime', 'WednesdayExtendedHoursStartTime')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AdditionalAddressInfo', 'Address1', 'Address2', 'City', 'CountryID', 'DateFormat', 'FirstDayOfWeek', 'FridayBusinessHoursEndTime', 'FridayBusinessHoursStartTime', 'FridayExtendedHoursEndTime', 'FridayExtendedHoursStartTime', 'HolidayExtendedHoursEndTime', 'HolidayExtendedHoursStartTime', 'HolidayHoursEndTime', 'HolidayHoursStartTime', 'HolidayHoursType', 'HolidaySetID', 'id', 'MondayBusinessHoursEndTime', 'MondayBusinessHoursStartTime', 'MondayExtendedHoursEndTime', 'MondayExtendedHoursStartTime', 'Name', 'NumberFormat', 'PostalCode', 'SaturdayBusinessHoursEndTime', 'SaturdayBusinessHoursStartTime', 'SaturdayExtendedHoursEndTime', 'SaturdayExtendedHoursStartTime', 'State', 'SundayBusinessHoursEndTime', 'SundayBusinessHoursStartTime', 'SundayExtendedHoursEndTime', 'SundayExtendedHoursStartTime', 'ThursdayBusinessHoursEndTime', 'ThursdayBusinessHoursStartTime', 'ThursdayExtendedHoursEndTime', 'ThursdayExtendedHoursStartTime', 'TimeFormat', 'TimeZoneID', 'TuesdayBusinessHoursEndTime', 'TuesdayBusinessHoursStartTime', 'TuesdayExtendedHoursEndTime', 'TuesdayExtendedHoursStartTime', 'WednesdayBusinessHoursEndTime', 'WednesdayBusinessHoursStartTime', 'WednesdayExtendedHoursEndTime', 'WednesdayExtendedHoursStartTime')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AdditionalAddressInfo', 'Address1', 'Address2', 'City', 'CountryID', 'DateFormat', 'FirstDayOfWeek', 'FridayBusinessHoursEndTime', 'FridayBusinessHoursStartTime', 'FridayExtendedHoursEndTime', 'FridayExtendedHoursStartTime', 'HolidayExtendedHoursEndTime', 'HolidayExtendedHoursStartTime', 'HolidayHoursEndTime', 'HolidayHoursStartTime', 'HolidayHoursType', 'HolidaySetID', 'id', 'MondayBusinessHoursEndTime', 'MondayBusinessHoursStartTime', 'MondayExtendedHoursEndTime', 'MondayExtendedHoursStartTime', 'Name', 'NumberFormat', 'PostalCode', 'SaturdayBusinessHoursEndTime', 'SaturdayBusinessHoursStartTime', 'SaturdayExtendedHoursEndTime', 'SaturdayExtendedHoursStartTime', 'State', 'SundayBusinessHoursEndTime', 'SundayBusinessHoursStartTime', 'SundayExtendedHoursEndTime', 'SundayExtendedHoursStartTime', 'ThursdayBusinessHoursEndTime', 'ThursdayBusinessHoursStartTime', 'ThursdayExtendedHoursEndTime', 'ThursdayExtendedHoursStartTime', 'TimeFormat', 'TimeZoneID', 'TuesdayBusinessHoursEndTime', 'TuesdayBusinessHoursStartTime', 'TuesdayExtendedHoursEndTime', 'TuesdayExtendedHoursStartTime', 'WednesdayBusinessHoursEndTime', 'WednesdayBusinessHoursStartTime', 'WednesdayExtendedHoursEndTime', 'WednesdayExtendedHoursStartTime')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AdditionalAddressInfo', 'Address1', 'Address2', 'City', 'CountryID', 'DateFormat', 'FirstDayOfWeek', 'FridayBusinessHoursEndTime', 'FridayBusinessHoursStartTime', 'FridayExtendedHoursEndTime', 'FridayExtendedHoursStartTime', 'HolidayExtendedHoursEndTime', 'HolidayExtendedHoursStartTime', 'HolidayHoursEndTime', 'HolidayHoursStartTime', 'HolidayHoursType', 'HolidaySetID', 'id', 'MondayBusinessHoursEndTime', 'MondayBusinessHoursStartTime', 'MondayExtendedHoursEndTime', 'MondayExtendedHoursStartTime', 'Name', 'NumberFormat', 'PostalCode', 'SaturdayBusinessHoursEndTime', 'SaturdayBusinessHoursStartTime', 'SaturdayExtendedHoursEndTime', 'SaturdayExtendedHoursStartTime', 'State', 'SundayBusinessHoursEndTime', 'SundayBusinessHoursStartTime', 'SundayExtendedHoursEndTime', 'SundayExtendedHoursStartTime', 'ThursdayBusinessHoursEndTime', 'ThursdayBusinessHoursStartTime', 'ThursdayExtendedHoursEndTime', 'ThursdayExtendedHoursStartTime', 'TimeFormat', 'TimeZoneID', 'TuesdayBusinessHoursEndTime', 'TuesdayBusinessHoursStartTime', 'TuesdayExtendedHoursEndTime', 'TuesdayExtendedHoursStartTime', 'WednesdayBusinessHoursEndTime', 'WednesdayBusinessHoursStartTime', 'WednesdayExtendedHoursEndTime', 'WednesdayExtendedHoursStartTime')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AdditionalAddressInfo', 'Address1', 'Address2', 'City', 'CountryID', 'DateFormat', 'FirstDayOfWeek', 'FridayBusinessHoursEndTime', 'FridayBusinessHoursStartTime', 'FridayExtendedHoursEndTime', 'FridayExtendedHoursStartTime', 'HolidayExtendedHoursEndTime', 'HolidayExtendedHoursStartTime', 'HolidayHoursEndTime', 'HolidayHoursStartTime', 'HolidayHoursType', 'HolidaySetID', 'id', 'MondayBusinessHoursEndTime', 'MondayBusinessHoursStartTime', 'MondayExtendedHoursEndTime', 'MondayExtendedHoursStartTime', 'Name', 'NumberFormat', 'PostalCode', 'SaturdayBusinessHoursEndTime', 'SaturdayBusinessHoursStartTime', 'SaturdayExtendedHoursEndTime', 'SaturdayExtendedHoursStartTime', 'State', 'SundayBusinessHoursEndTime', 'SundayBusinessHoursStartTime', 'SundayExtendedHoursEndTime', 'SundayExtendedHoursStartTime', 'ThursdayBusinessHoursEndTime', 'ThursdayBusinessHoursStartTime', 'ThursdayExtendedHoursEndTime', 'ThursdayExtendedHoursStartTime', 'TimeFormat', 'TimeZoneID', 'TuesdayBusinessHoursEndTime', 'TuesdayBusinessHoursStartTime', 'TuesdayExtendedHoursEndTime', 'TuesdayExtendedHoursStartTime', 'WednesdayBusinessHoursEndTime', 'WednesdayBusinessHoursStartTime', 'WednesdayExtendedHoursEndTime', 'WednesdayExtendedHoursStartTime')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AdditionalAddressInfo', 'Address1', 'Address2', 'City', 'DateFormat', 'Name', 'NumberFormat', 'PostalCode', 'State', 'TimeFormat')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AdditionalAddressInfo', 'Address1', 'Address2', 'City', 'DateFormat', 'Name', 'NumberFormat', 'PostalCode', 'State', 'TimeFormat')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AdditionalAddressInfo', 'Address1', 'Address2', 'City', 'DateFormat', 'Name', 'NumberFormat', 'PostalCode', 'State', 'TimeFormat')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AdditionalAddressInfo', 'Address1', 'Address2', 'City', 'DateFormat', 'Name', 'NumberFormat', 'PostalCode', 'State', 'TimeFormat')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AdditionalAddressInfo', 'Address1', 'Address2', 'City', 'DateFormat', 'Name', 'NumberFormat', 'PostalCode', 'State', 'TimeFormat')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('FridayBusinessHoursEndTime', 'FridayBusinessHoursStartTime', 'FridayExtendedHoursEndTime', 'FridayExtendedHoursStartTime', 'HolidayExtendedHoursEndTime', 'HolidayExtendedHoursStartTime', 'HolidayHoursEndTime', 'HolidayHoursStartTime', 'MondayBusinessHoursEndTime', 'MondayBusinessHoursStartTime', 'MondayExtendedHoursEndTime', 'MondayExtendedHoursStartTime', 'SaturdayBusinessHoursEndTime', 'SaturdayBusinessHoursStartTime', 'SaturdayExtendedHoursEndTime', 'SaturdayExtendedHoursStartTime', 'SundayBusinessHoursEndTime', 'SundayBusinessHoursStartTime', 'SundayExtendedHoursEndTime', 'SundayExtendedHoursStartTime', 'ThursdayBusinessHoursEndTime', 'ThursdayBusinessHoursStartTime', 'ThursdayExtendedHoursEndTime', 'ThursdayExtendedHoursStartTime', 'TuesdayBusinessHoursEndTime', 'TuesdayBusinessHoursStartTime', 'TuesdayExtendedHoursEndTime', 'TuesdayExtendedHoursStartTime', 'WednesdayBusinessHoursEndTime', 'WednesdayBusinessHoursStartTime', 'WednesdayExtendedHoursEndTime', 'WednesdayExtendedHoursStartTime')]
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

            # What is the highest number of values for a parameter and is it higher than 200?
            $max = $PSBoundParameters.Values[0].length | Measure-Object -Maximum

            # If the count is less than or equal to 200 we pass PSBoundParameters as is
            if ($max.Maximum -le 200) {
                [collections.generic.list[string]]$Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $entityName
                $iterations.Add($Filter)
            }
            # More than 200 values. This will cause a SQL query nested too much error. Break a single parameter
            # into segments and create multiple queries with max 200 values
            else {
                
                # Find the parameter with the $max.Maximum number of items
                foreach ($param in $PSCmdlet.MyInvocation.BoundParameters.GetEnumerator() ) {
                    # When we have found the right parameter, stop iterating
                    if ($param.Value.length -eq $max.Maximum) { break }
                }
     
                # Deduplicate the value list or the same ID may be included in more than 1 query
                $outerLoop = $PSCmdlet.MyInvocation.BoundParameters.$($param.key) | Sort-Object -Unique

                Write-Verbose ('{0}: Received {1} objects containing {2} unique values for parameter {3}' -f $MyInvocation.MyCommand.Name, $count, $outerLoop.Count, $param.key)
                  
                for ($s = 0; $s -lt $outerLoop.count; $s += 200) {
                    $e = $s + 199
                    if ($e -ge $outerLoop.count) {
                        $e = $outerLoop.count - 1
                    }
                  
                    # Make writable of BoundParameters
                    $BoundParameters = $PSCmdlet.MyInvocation.BoundParameters

                    # make a selection
                    $BoundParameters.$($param.key) = $outerLoop[$s .. $e]

                    Write-Verbose ('{0}: Asking for {1} values {2} to {3}' -f $MyInvocation.MyCommand.Name, $param, $s, $e)

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
                    # Write a debug message with detailed information to developers
                    $reason = ("{0}: {1}" -f $_.CategoryInfo.Category, $_.CategoryInfo.Reason)
                    $message = "{2}: {0}`r`n`r`nLine:{1}`r`n`r`nScript stacktrace:`r`n{3}" -f $_.Exception.Message, $_.InvocationInfo.Line, $reason, $_.ScriptStackTrace
                    Write-Debug $message

                    # Pass on the error
                    $PSCmdlet.ThrowTerminatingError($_)
                    return
                }
                # Add response to result - if there are any response to add
                if ($response.count -gt 0) { 
                    $result.AddRange($response)
                }

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
