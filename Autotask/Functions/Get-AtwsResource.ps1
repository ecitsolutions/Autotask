#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) Hugo Klemmestad. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsResource
{


<#
.SYNOPSIS
This function get one or more Resource through the Autotask Web Services API.
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
EmailTypeCode
EmailTypeCode2
EmailTypeCode3
Gender
Greeting
LocationID
ResourceType
Suffix
TravelAvailabilityPct
UserType
DateFormat
TimeFormat
PayrollType
NumberFormat
LicenseType

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Resource[]]. This function outputs the Autotask.Resource that was returned by the API.
.EXAMPLE
Get-AtwsResource -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsResource -ResourceName SomeName
Returns the object with ResourceName 'SomeName', if any.
 .EXAMPLE
Get-AtwsResource -ResourceName 'Some Name'
Returns the object with ResourceName 'Some Name', if any.
 .EXAMPLE
Get-AtwsResource -ResourceName 'Some Name' -NotEquals ResourceName
Returns any objects with a ResourceName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsResource -ResourceName SomeName* -Like ResourceName
Returns any object with a ResourceName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsResource -ResourceName SomeName* -NotLike ResourceName
Returns any object with a ResourceName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsResource -EmailTypeCode 'PickList Label'
Returns any Resources with property EmailTypeCode equal to the 'PickList Label'. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsResource -EmailTypeCode 'PickList Label' -NotEquals EmailTypeCode 
Returns any Resources with property EmailTypeCode NOT equal to the 'PickList Label'.
 .EXAMPLE
Get-AtwsResource -EmailTypeCode 'PickList Label1', 'PickList Label2'
Returns any Resources with property EmailTypeCode equal to EITHER 'PickList Label1' OR 'PickList Label2'.
 .EXAMPLE
Get-AtwsResource -EmailTypeCode 'PickList Label1', 'PickList Label2' -NotEquals EmailTypeCode
Returns any Resources with property EmailTypeCode NOT equal to NEITHER 'PickList Label1' NOR 'PickList Label2'.
 .EXAMPLE
Get-AtwsResource -Id 1234 -ResourceName SomeName* -EmailTypeCode 'PickList Label1', 'PickList Label2' -Like ResourceName -NotEquals EmailTypeCode -GreaterThan Id
An example of a more complex query. This command returns any Resources with Id GREATER THAN 1234, a ResourceName that matches the simple pattern SomeName* AND that has a EmailTypeCode that is NOT equal to NEITHER 'PickList Label1' NOR 'PickList Label2'.

.NOTES
Related commands:
Set-AtwsResource

#>

  [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName='Filter', ConfirmImpact='None',
  HelpURI='https://github.com/ecitsolutions/Autotask/blob/master/Docs/Get-AtwsResource.md')]
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
    [ValidateSet('DefaultServiceDeskRoleID')]
    [string]
    $GetReferenceEntityById,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# Accounting Reference ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $AccountingReferenceID,

# Status
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $Active,

# Date Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName DateFormat -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Resource -FieldName DateFormat -Label) + (Get-AtwsPicklistValue -Entity Resource -FieldName DateFormat -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $DateFormat,

# Email
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,254)]
    [string[]]
    $Email,

# Add Email 1
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,254)]
    [string[]]
    $Email2,

# Add Email 2
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,254)]
    [string[]]
    $Email3,

# Email Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName EmailTypeCode -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Resource -FieldName EmailTypeCode -Label) + (Get-AtwsPicklistValue -Entity Resource -FieldName EmailTypeCode -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $EmailTypeCode,

# Add Email 1 Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName EmailTypeCode2 -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Resource -FieldName EmailTypeCode2 -Label) + (Get-AtwsPicklistValue -Entity Resource -FieldName EmailTypeCode2 -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $EmailTypeCode2,

# Add Email 2 Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName EmailTypeCode3 -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Resource -FieldName EmailTypeCode3 -Label) + (Get-AtwsPicklistValue -Entity Resource -FieldName EmailTypeCode3 -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $EmailTypeCode3,

# First Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,50)]
    [string[]]
    $FirstName,

# Gender
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName Gender -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Resource -FieldName Gender -Label) + (Get-AtwsPicklistValue -Entity Resource -FieldName Gender -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $Gender,

# Greeting
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName Greeting -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Resource -FieldName Greeting -Label) + (Get-AtwsPicklistValue -Entity Resource -FieldName Greeting -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $Greeting,

# Hire Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $HireDate,

# Home Phone
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $HomePhone,

# Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Pay Roll Identifier
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,32)]
    [string[]]
    $Initials,

# Interal Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $InternalCost,

# Last Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,50)]
    [string[]]
    $LastName,

# License Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName LicenseType -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Resource -FieldName LicenseType -Label) + (Get-AtwsPicklistValue -Entity Resource -FieldName LicenseType -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $LicenseType,

# Pimary Location
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName LocationID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Resource -FieldName LocationID -Label) + (Get-AtwsPicklistValue -Entity Resource -FieldName LocationID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $LocationID,

# Middle Initial
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $MiddleName,

# Mobile Phone
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $MobilePhone,

# Number Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName NumberFormat -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Resource -FieldName NumberFormat -Label) + (Get-AtwsPicklistValue -Entity Resource -FieldName NumberFormat -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $NumberFormat,

# Office Extension
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,10)]
    [string[]]
    $OfficeExtension,

# Office Phone
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $OfficePhone,

# Payroll Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName PayrollType -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Resource -FieldName PayrollType -Label) + (Get-AtwsPicklistValue -Entity Resource -FieldName PayrollType -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $PayrollType,

# Resource Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName ResourceType -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Resource -FieldName ResourceType -Label) + (Get-AtwsPicklistValue -Entity Resource -FieldName ResourceType -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $ResourceType,

# Suffix
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName Suffix -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Resource -FieldName Suffix -Label) + (Get-AtwsPicklistValue -Entity Resource -FieldName Suffix -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $Suffix,

# Survey Resource Rating
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $SurveyResourceRating,

# Time Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName TimeFormat -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Resource -FieldName TimeFormat -Label) + (Get-AtwsPicklistValue -Entity Resource -FieldName TimeFormat -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $TimeFormat,

# Title
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $Title,

# Travel Availability Pct
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName TravelAvailabilityPct -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Resource -FieldName TravelAvailabilityPct -Label) + (Get-AtwsPicklistValue -Entity Resource -FieldName TravelAvailabilityPct -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $TravelAvailabilityPct,

# UserName
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,32)]
    [string[]]
    $UserName,

# User Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Resource -FieldName UserType -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Resource -FieldName UserType -Label) + (Get-AtwsPicklistValue -Entity Resource -FieldName UserType -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $UserType,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountingReferenceID', 'Active', 'DateFormat', 'DefaultServiceDeskRoleID', 'Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'Greeting', 'HireDate', 'HomePhone', 'id', 'Initials', 'InternalCost', 'LastName', 'LicenseType', 'LocationID', 'MiddleName', 'MobilePhone', 'NumberFormat', 'OfficeExtension', 'OfficePhone', 'Password', 'PayrollType', 'ResourceType', 'Suffix', 'SurveyResourceRating', 'TimeFormat', 'Title', 'TravelAvailabilityPct', 'UserName', 'UserType')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountingReferenceID', 'Active', 'DateFormat', 'DefaultServiceDeskRoleID', 'Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'Greeting', 'HireDate', 'HomePhone', 'id', 'Initials', 'InternalCost', 'LastName', 'LicenseType', 'LocationID', 'MiddleName', 'MobilePhone', 'NumberFormat', 'OfficeExtension', 'OfficePhone', 'Password', 'PayrollType', 'ResourceType', 'Suffix', 'SurveyResourceRating', 'TimeFormat', 'Title', 'TravelAvailabilityPct', 'UserName', 'UserType')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountingReferenceID', 'Active', 'DateFormat', 'DefaultServiceDeskRoleID', 'Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'Greeting', 'HireDate', 'HomePhone', 'id', 'Initials', 'InternalCost', 'LastName', 'LicenseType', 'LocationID', 'MiddleName', 'MobilePhone', 'NumberFormat', 'OfficeExtension', 'OfficePhone', 'Password', 'PayrollType', 'ResourceType', 'Suffix', 'SurveyResourceRating', 'TimeFormat', 'Title', 'TravelAvailabilityPct', 'UserName', 'UserType')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountingReferenceID', 'DateFormat', 'DefaultServiceDeskRoleID', 'Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'Greeting', 'HireDate', 'HomePhone', 'id', 'Initials', 'InternalCost', 'LastName', 'LicenseType', 'LocationID', 'MiddleName', 'MobilePhone', 'NumberFormat', 'OfficeExtension', 'OfficePhone', 'Password', 'PayrollType', 'ResourceType', 'Suffix', 'SurveyResourceRating', 'TimeFormat', 'Title', 'TravelAvailabilityPct', 'UserName', 'UserType')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountingReferenceID', 'DateFormat', 'DefaultServiceDeskRoleID', 'Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'Greeting', 'HireDate', 'HomePhone', 'id', 'Initials', 'InternalCost', 'LastName', 'LicenseType', 'LocationID', 'MiddleName', 'MobilePhone', 'NumberFormat', 'OfficeExtension', 'OfficePhone', 'Password', 'PayrollType', 'ResourceType', 'Suffix', 'SurveyResourceRating', 'TimeFormat', 'Title', 'TravelAvailabilityPct', 'UserName', 'UserType')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountingReferenceID', 'DateFormat', 'DefaultServiceDeskRoleID', 'Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'Greeting', 'HireDate', 'HomePhone', 'id', 'Initials', 'InternalCost', 'LastName', 'LicenseType', 'LocationID', 'MiddleName', 'MobilePhone', 'NumberFormat', 'OfficeExtension', 'OfficePhone', 'Password', 'PayrollType', 'ResourceType', 'Suffix', 'SurveyResourceRating', 'TimeFormat', 'Title', 'TravelAvailabilityPct', 'UserName', 'UserType')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountingReferenceID', 'DateFormat', 'DefaultServiceDeskRoleID', 'Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'Greeting', 'HireDate', 'HomePhone', 'id', 'Initials', 'InternalCost', 'LastName', 'LicenseType', 'LocationID', 'MiddleName', 'MobilePhone', 'NumberFormat', 'OfficeExtension', 'OfficePhone', 'Password', 'PayrollType', 'ResourceType', 'Suffix', 'SurveyResourceRating', 'TimeFormat', 'Title', 'TravelAvailabilityPct', 'UserName', 'UserType')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountingReferenceID', 'DateFormat', 'Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'HomePhone', 'Initials', 'LastName', 'MiddleName', 'MobilePhone', 'NumberFormat', 'OfficeExtension', 'OfficePhone', 'Password', 'ResourceType', 'Suffix', 'TimeFormat', 'Title', 'TravelAvailabilityPct', 'UserName')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountingReferenceID', 'DateFormat', 'Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'HomePhone', 'Initials', 'LastName', 'MiddleName', 'MobilePhone', 'NumberFormat', 'OfficeExtension', 'OfficePhone', 'Password', 'ResourceType', 'Suffix', 'TimeFormat', 'Title', 'TravelAvailabilityPct', 'UserName')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountingReferenceID', 'DateFormat', 'Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'HomePhone', 'Initials', 'LastName', 'MiddleName', 'MobilePhone', 'NumberFormat', 'OfficeExtension', 'OfficePhone', 'Password', 'ResourceType', 'Suffix', 'TimeFormat', 'Title', 'TravelAvailabilityPct', 'UserName')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountingReferenceID', 'DateFormat', 'Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'HomePhone', 'Initials', 'LastName', 'MiddleName', 'MobilePhone', 'NumberFormat', 'OfficeExtension', 'OfficePhone', 'Password', 'ResourceType', 'Suffix', 'TimeFormat', 'Title', 'TravelAvailabilityPct', 'UserName')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountingReferenceID', 'DateFormat', 'Email', 'Email2', 'Email3', 'EmailTypeCode', 'EmailTypeCode2', 'EmailTypeCode3', 'FirstName', 'Gender', 'HomePhone', 'Initials', 'LastName', 'MiddleName', 'MobilePhone', 'NumberFormat', 'OfficeExtension', 'OfficePhone', 'Password', 'ResourceType', 'Suffix', 'TimeFormat', 'Title', 'TravelAvailabilityPct', 'UserName')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('HireDate')]
    [string[]]
    $IsThisDay
  )

    begin {
        $entityName = 'Resource'

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
