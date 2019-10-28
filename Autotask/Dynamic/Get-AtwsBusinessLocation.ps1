#Requires -Version 4.0
#Version 1.6.2.17
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

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
 

Entities that have fields that refer to the base entity of this CmdLet:

Department

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

# Return entities of selected type that are referencing to this entity.
    [Parameter(
      ParametersetName = 'Filter'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('External')]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('Department:PrimaryLocationID')]
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

# Business Location ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [string[]]
    $Name,

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

# State
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $State,

# Postal Code
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,20)]
    [string[]]
    $PostalCode,

# Additional Address Info
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $AdditionalAddressInfo,

# Country ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CountryID,

# Holiday Set ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $HolidaySetID,

# No Hours On Holidays
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $NoHoursOnHolidays,

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
    [string[]]
    $FirstDayOfWeek,

# Date Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $DateFormat,

# Time Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $TimeFormat,

# Number Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $NumberFormat,

# Time Zone ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $TimeZoneID,

# SundayBusinessHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $SundayBusinessHoursStartTime,

# SundayBusinessHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $SundayBusinessHoursEndTime,

# SundayExtendedHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $SundayExtendedHoursStartTime,

# SundayExtendedHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $SundayExtendedHoursEndTime,

# MondayBusinessHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $MondayBusinessHoursStartTime,

# MondayBusinessHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $MondayBusinessHoursEndTime,

# MondayExtendedHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $MondayExtendedHoursStartTime,

# MondayExtendedHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $MondayExtendedHoursEndTime,

# TuesdayBusinessHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $TuesdayBusinessHoursStartTime,

# TuesdayBusinessHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $TuesdayBusinessHoursEndTime,

# TuesdayExtendedHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $TuesdayExtendedHoursStartTime,

# TuesdayExtendedHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $TuesdayExtendedHoursEndTime,

# WednesdayBusinessHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $WednesdayBusinessHoursStartTime,

# WednesdayBusinessHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $WednesdayBusinessHoursEndTime,

# WednesdayExtendedHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $WednesdayExtendedHoursStartTime,

# WednesdayExtendedHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $WednesdayExtendedHoursEndTime,

# ThursdayBusinessHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ThursdayBusinessHoursStartTime,

# ThursdayBusinessHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ThursdayBusinessHoursEndTime,

# ThursdayExtendedHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ThursdayExtendedHoursStartTime,

# ThursdayExtendedHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ThursdayExtendedHoursEndTime,

# FridayBusinessHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $FridayBusinessHoursStartTime,

# FridayBusinessHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $FridayBusinessHoursEndTime,

# FridayExtendedHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $FridayExtendedHoursStartTime,

# FridayExtendedHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $FridayExtendedHoursEndTime,

# SaturdayBusinessHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $SaturdayBusinessHoursStartTime,

# SaturdayBusinessHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $SaturdayBusinessHoursEndTime,

# SaturdayExtendedHoursStartTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $SaturdayExtendedHoursStartTime,

# SaturdayExtendedHoursEndTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $SaturdayExtendedHoursEndTime,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'AdditionalAddressInfo', 'CountryID', 'HolidaySetID', 'NoHoursOnHolidays', 'Default', 'FirstDayOfWeek', 'DateFormat', 'TimeFormat', 'NumberFormat', 'TimeZoneID', 'SundayBusinessHoursStartTime', 'SundayBusinessHoursEndTime', 'SundayExtendedHoursStartTime', 'SundayExtendedHoursEndTime', 'MondayBusinessHoursStartTime', 'MondayBusinessHoursEndTime', 'MondayExtendedHoursStartTime', 'MondayExtendedHoursEndTime', 'TuesdayBusinessHoursStartTime', 'TuesdayBusinessHoursEndTime', 'TuesdayExtendedHoursStartTime', 'TuesdayExtendedHoursEndTime', 'WednesdayBusinessHoursStartTime', 'WednesdayBusinessHoursEndTime', 'WednesdayExtendedHoursStartTime', 'WednesdayExtendedHoursEndTime', 'ThursdayBusinessHoursStartTime', 'ThursdayBusinessHoursEndTime', 'ThursdayExtendedHoursStartTime', 'ThursdayExtendedHoursEndTime', 'FridayBusinessHoursStartTime', 'FridayBusinessHoursEndTime', 'FridayExtendedHoursStartTime', 'FridayExtendedHoursEndTime', 'SaturdayBusinessHoursStartTime', 'SaturdayBusinessHoursEndTime', 'SaturdayExtendedHoursStartTime', 'SaturdayExtendedHoursEndTime')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'AdditionalAddressInfo', 'CountryID', 'HolidaySetID', 'NoHoursOnHolidays', 'Default', 'FirstDayOfWeek', 'DateFormat', 'TimeFormat', 'NumberFormat', 'TimeZoneID', 'SundayBusinessHoursStartTime', 'SundayBusinessHoursEndTime', 'SundayExtendedHoursStartTime', 'SundayExtendedHoursEndTime', 'MondayBusinessHoursStartTime', 'MondayBusinessHoursEndTime', 'MondayExtendedHoursStartTime', 'MondayExtendedHoursEndTime', 'TuesdayBusinessHoursStartTime', 'TuesdayBusinessHoursEndTime', 'TuesdayExtendedHoursStartTime', 'TuesdayExtendedHoursEndTime', 'WednesdayBusinessHoursStartTime', 'WednesdayBusinessHoursEndTime', 'WednesdayExtendedHoursStartTime', 'WednesdayExtendedHoursEndTime', 'ThursdayBusinessHoursStartTime', 'ThursdayBusinessHoursEndTime', 'ThursdayExtendedHoursStartTime', 'ThursdayExtendedHoursEndTime', 'FridayBusinessHoursStartTime', 'FridayBusinessHoursEndTime', 'FridayExtendedHoursStartTime', 'FridayExtendedHoursEndTime', 'SaturdayBusinessHoursStartTime', 'SaturdayBusinessHoursEndTime', 'SaturdayExtendedHoursStartTime', 'SaturdayExtendedHoursEndTime')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'AdditionalAddressInfo', 'CountryID', 'HolidaySetID', 'NoHoursOnHolidays', 'Default', 'FirstDayOfWeek', 'DateFormat', 'TimeFormat', 'NumberFormat', 'TimeZoneID', 'SundayBusinessHoursStartTime', 'SundayBusinessHoursEndTime', 'SundayExtendedHoursStartTime', 'SundayExtendedHoursEndTime', 'MondayBusinessHoursStartTime', 'MondayBusinessHoursEndTime', 'MondayExtendedHoursStartTime', 'MondayExtendedHoursEndTime', 'TuesdayBusinessHoursStartTime', 'TuesdayBusinessHoursEndTime', 'TuesdayExtendedHoursStartTime', 'TuesdayExtendedHoursEndTime', 'WednesdayBusinessHoursStartTime', 'WednesdayBusinessHoursEndTime', 'WednesdayExtendedHoursStartTime', 'WednesdayExtendedHoursEndTime', 'ThursdayBusinessHoursStartTime', 'ThursdayBusinessHoursEndTime', 'ThursdayExtendedHoursStartTime', 'ThursdayExtendedHoursEndTime', 'FridayBusinessHoursStartTime', 'FridayBusinessHoursEndTime', 'FridayExtendedHoursStartTime', 'FridayExtendedHoursEndTime', 'SaturdayBusinessHoursStartTime', 'SaturdayBusinessHoursEndTime', 'SaturdayExtendedHoursStartTime', 'SaturdayExtendedHoursEndTime')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'AdditionalAddressInfo', 'CountryID', 'HolidaySetID', 'FirstDayOfWeek', 'DateFormat', 'TimeFormat', 'NumberFormat', 'TimeZoneID', 'SundayBusinessHoursStartTime', 'SundayBusinessHoursEndTime', 'SundayExtendedHoursStartTime', 'SundayExtendedHoursEndTime', 'MondayBusinessHoursStartTime', 'MondayBusinessHoursEndTime', 'MondayExtendedHoursStartTime', 'MondayExtendedHoursEndTime', 'TuesdayBusinessHoursStartTime', 'TuesdayBusinessHoursEndTime', 'TuesdayExtendedHoursStartTime', 'TuesdayExtendedHoursEndTime', 'WednesdayBusinessHoursStartTime', 'WednesdayBusinessHoursEndTime', 'WednesdayExtendedHoursStartTime', 'WednesdayExtendedHoursEndTime', 'ThursdayBusinessHoursStartTime', 'ThursdayBusinessHoursEndTime', 'ThursdayExtendedHoursStartTime', 'ThursdayExtendedHoursEndTime', 'FridayBusinessHoursStartTime', 'FridayBusinessHoursEndTime', 'FridayExtendedHoursStartTime', 'FridayExtendedHoursEndTime', 'SaturdayBusinessHoursStartTime', 'SaturdayBusinessHoursEndTime', 'SaturdayExtendedHoursStartTime', 'SaturdayExtendedHoursEndTime')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'AdditionalAddressInfo', 'CountryID', 'HolidaySetID', 'FirstDayOfWeek', 'DateFormat', 'TimeFormat', 'NumberFormat', 'TimeZoneID', 'SundayBusinessHoursStartTime', 'SundayBusinessHoursEndTime', 'SundayExtendedHoursStartTime', 'SundayExtendedHoursEndTime', 'MondayBusinessHoursStartTime', 'MondayBusinessHoursEndTime', 'MondayExtendedHoursStartTime', 'MondayExtendedHoursEndTime', 'TuesdayBusinessHoursStartTime', 'TuesdayBusinessHoursEndTime', 'TuesdayExtendedHoursStartTime', 'TuesdayExtendedHoursEndTime', 'WednesdayBusinessHoursStartTime', 'WednesdayBusinessHoursEndTime', 'WednesdayExtendedHoursStartTime', 'WednesdayExtendedHoursEndTime', 'ThursdayBusinessHoursStartTime', 'ThursdayBusinessHoursEndTime', 'ThursdayExtendedHoursStartTime', 'ThursdayExtendedHoursEndTime', 'FridayBusinessHoursStartTime', 'FridayBusinessHoursEndTime', 'FridayExtendedHoursStartTime', 'FridayExtendedHoursEndTime', 'SaturdayBusinessHoursStartTime', 'SaturdayBusinessHoursEndTime', 'SaturdayExtendedHoursStartTime', 'SaturdayExtendedHoursEndTime')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'AdditionalAddressInfo', 'CountryID', 'HolidaySetID', 'FirstDayOfWeek', 'DateFormat', 'TimeFormat', 'NumberFormat', 'TimeZoneID', 'SundayBusinessHoursStartTime', 'SundayBusinessHoursEndTime', 'SundayExtendedHoursStartTime', 'SundayExtendedHoursEndTime', 'MondayBusinessHoursStartTime', 'MondayBusinessHoursEndTime', 'MondayExtendedHoursStartTime', 'MondayExtendedHoursEndTime', 'TuesdayBusinessHoursStartTime', 'TuesdayBusinessHoursEndTime', 'TuesdayExtendedHoursStartTime', 'TuesdayExtendedHoursEndTime', 'WednesdayBusinessHoursStartTime', 'WednesdayBusinessHoursEndTime', 'WednesdayExtendedHoursStartTime', 'WednesdayExtendedHoursEndTime', 'ThursdayBusinessHoursStartTime', 'ThursdayBusinessHoursEndTime', 'ThursdayExtendedHoursStartTime', 'ThursdayExtendedHoursEndTime', 'FridayBusinessHoursStartTime', 'FridayBusinessHoursEndTime', 'FridayExtendedHoursStartTime', 'FridayExtendedHoursEndTime', 'SaturdayBusinessHoursStartTime', 'SaturdayBusinessHoursEndTime', 'SaturdayExtendedHoursStartTime', 'SaturdayExtendedHoursEndTime')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'AdditionalAddressInfo', 'CountryID', 'HolidaySetID', 'FirstDayOfWeek', 'DateFormat', 'TimeFormat', 'NumberFormat', 'TimeZoneID', 'SundayBusinessHoursStartTime', 'SundayBusinessHoursEndTime', 'SundayExtendedHoursStartTime', 'SundayExtendedHoursEndTime', 'MondayBusinessHoursStartTime', 'MondayBusinessHoursEndTime', 'MondayExtendedHoursStartTime', 'MondayExtendedHoursEndTime', 'TuesdayBusinessHoursStartTime', 'TuesdayBusinessHoursEndTime', 'TuesdayExtendedHoursStartTime', 'TuesdayExtendedHoursEndTime', 'WednesdayBusinessHoursStartTime', 'WednesdayBusinessHoursEndTime', 'WednesdayExtendedHoursStartTime', 'WednesdayExtendedHoursEndTime', 'ThursdayBusinessHoursStartTime', 'ThursdayBusinessHoursEndTime', 'ThursdayExtendedHoursStartTime', 'ThursdayExtendedHoursEndTime', 'FridayBusinessHoursStartTime', 'FridayBusinessHoursEndTime', 'FridayExtendedHoursStartTime', 'FridayExtendedHoursEndTime', 'SaturdayBusinessHoursStartTime', 'SaturdayBusinessHoursEndTime', 'SaturdayExtendedHoursStartTime', 'SaturdayExtendedHoursEndTime')]
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
    [ValidateSet('SundayBusinessHoursStartTime', 'SundayBusinessHoursEndTime', 'SundayExtendedHoursStartTime', 'SundayExtendedHoursEndTime', 'MondayBusinessHoursStartTime', 'MondayBusinessHoursEndTime', 'MondayExtendedHoursStartTime', 'MondayExtendedHoursEndTime', 'TuesdayBusinessHoursStartTime', 'TuesdayBusinessHoursEndTime', 'TuesdayExtendedHoursStartTime', 'TuesdayExtendedHoursEndTime', 'WednesdayBusinessHoursStartTime', 'WednesdayBusinessHoursEndTime', 'WednesdayExtendedHoursStartTime', 'WednesdayExtendedHoursEndTime', 'ThursdayBusinessHoursStartTime', 'ThursdayBusinessHoursEndTime', 'ThursdayExtendedHoursStartTime', 'ThursdayExtendedHoursEndTime', 'FridayBusinessHoursStartTime', 'FridayBusinessHoursEndTime', 'FridayExtendedHoursStartTime', 'FridayExtendedHoursEndTime', 'SaturdayBusinessHoursStartTime', 'SaturdayBusinessHoursEndTime', 'SaturdayExtendedHoursStartTime', 'SaturdayExtendedHoursEndTime')]
    [string[]]
    $IsThisDay
  )

    begin { 
        $entityName = 'BusinessLocation'
    
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
