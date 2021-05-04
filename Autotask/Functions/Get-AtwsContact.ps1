#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsContact
{


<#
.SYNOPSIS
This function get one or more Contact through the Autotask Web Services API.
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
NamePrefix
NameSuffix
ApiVendorID

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Contact[]]. This function outputs the Autotask.Contact that was returned by the API.
.EXAMPLE
Get-AtwsContact -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsContact -ContactName SomeName
Returns the object with ContactName 'SomeName', if any.
 .EXAMPLE
Get-AtwsContact -ContactName 'Some Name'
Returns the object with ContactName 'Some Name', if any.
 .EXAMPLE
Get-AtwsContact -ContactName 'Some Name' -NotEquals ContactName
Returns any objects with a ContactName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsContact -ContactName SomeName* -Like ContactName
Returns any object with a ContactName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsContact -ContactName SomeName* -NotLike ContactName
Returns any object with a ContactName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsContact -NamePrefix <PickList Label>
Returns any Contacts with property NamePrefix equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsContact -NamePrefix <PickList Label> -NotEquals NamePrefix 
Returns any Contacts with property NamePrefix NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsContact -NamePrefix <PickList Label1>, <PickList Label2>
Returns any Contacts with property NamePrefix equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsContact -NamePrefix <PickList Label1>, <PickList Label2> -NotEquals NamePrefix
Returns any Contacts with property NamePrefix NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsContact -Id 1234 -ContactName SomeName* -NamePrefix <PickList Label1>, <PickList Label2> -Like ContactName -NotEquals NamePrefix -GreaterThan Id
An example of a more complex query. This command returns any Contacts with Id GREATER THAN 1234, a ContactName that matches the simple pattern SomeName* AND that has a NamePrefix that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsContact
 .LINK
Remove-AtwsContact
 .LINK
Set-AtwsContact

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
    [ValidateSet('AccountID', 'AccountPhysicalLocationID', 'CountryID', 'ImpersonatorCreatorResourceID')]
    [string]
    $GetReferenceEntityById,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# A single user defined field can be used pr query
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('UDF')]
    [ValidateNotNullOrEmpty()]
    [Autotask.UserDefinedField]
    $UserDefinedField,

# Additional Address Information
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $AdditionalAddressInformation,

# Last Modified Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LastModifiedDate,

# External ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $ExternalID,

# Bulk Email Opt Out Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $BulkEmailOptOutTime,

# Contact Country ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CountryID,

# Last Activity Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LastActivityDate,

# Note
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $Note,

# Room Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $RoomNumber,

# Create Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CreateDate,

# Active
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $Active,

# Account Physical Location
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $AccountPhysicalLocationID,

# Primary Contact
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $PrimaryContact,

# Solicitation Opt Out Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $SolicitationOptOutTime,

# Impersonator Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ImpersonatorCreatorResourceID,

# API Vendor ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Contact -FieldName ApiVendorID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Contact -FieldName ApiVendorID -Label) + (Get-AtwsPicklistValue -Entity Contact -FieldName ApiVendorID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $ApiVendorID,

# Name Suffix
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Contact -FieldName NameSuffix -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Contact -FieldName NameSuffix -Label) + (Get-AtwsPicklistValue -Entity Contact -FieldName NameSuffix -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $NameSuffix,

# Name Prefix
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Contact -FieldName NamePrefix -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Contact -FieldName NamePrefix -Label) + (Get-AtwsPicklistValue -Entity Contact -FieldName NamePrefix -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $NamePrefix,

# Facebook URL
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,200)]
    [string[]]
    $FacebookUrl,

# LinkedIn URL
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,200)]
    [string[]]
    $LinkedInUrl,

# Twitter URL
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,200)]
    [string[]]
    $TwitterUrl,

# Contact Fax
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $FaxNumber,

# Contact Address 1
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [string[]]
    $AddressLine,

# Title
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $Title,

# Contact Address 2
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [string[]]
    $AddressLine1,

# Contact County
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,40)]
    [string[]]
    $State,

# Contact City
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,32)]
    [string[]]
    $City,

# Client
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $AccountID,

# Contact ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# First Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,50)]
    [string[]]
    $FirstName,

# Middle Initial
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $MiddleInitial,

# Last Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,50)]
    [string[]]
    $LastName,

# Contact Phone
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $Phone,

# Notification
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $Notification,

# Contact Phone Ext.
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,10)]
    [string[]]
    $Extension,

# Contact Mobile Phone
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $MobilePhone,

# Contact Alternate Phone
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,32)]
    [string[]]
    $AlternatePhone,

# Contact Country
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $Country,

# Contact Postal Code
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,16)]
    [string[]]
    $ZipCode,

# Email
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,254)]
    [string[]]
    $EMailAddress,

# Email3
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,254)]
    [string[]]
    $EMailAddress3,

# Email2
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,254)]
    [string[]]
    $EMailAddress2,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AccountPhysicalLocationID', 'Active', 'AdditionalAddressInformation', 'AddressLine', 'AddressLine1', 'AlternatePhone', 'ApiVendorID', 'BulkEmailOptOut', 'BulkEmailOptOutTime', 'City', 'Country', 'CountryID', 'CreateDate', 'EMailAddress', 'EMailAddress2', 'EMailAddress3', 'Extension', 'ExternalID', 'FacebookUrl', 'FaxNumber', 'FirstName', 'id', 'ImpersonatorCreatorResourceID', 'LastActivityDate', 'LastModifiedDate', 'LastName', 'LinkedInUrl', 'MiddleInitial', 'MobilePhone', 'NamePrefix', 'NameSuffix', 'Note', 'Notification', 'Phone', 'PrimaryContact', 'RoomNumber', 'SolicitationOptOut', 'SolicitationOptOutTime', 'State', 'SurveyOptOut', 'Title', 'TwitterUrl', 'ZipCode')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AccountPhysicalLocationID', 'Active', 'AdditionalAddressInformation', 'AddressLine', 'AddressLine1', 'AlternatePhone', 'ApiVendorID', 'BulkEmailOptOut', 'BulkEmailOptOutTime', 'City', 'Country', 'CountryID', 'CreateDate', 'EMailAddress', 'EMailAddress2', 'EMailAddress3', 'Extension', 'ExternalID', 'FacebookUrl', 'FaxNumber', 'FirstName', 'id', 'ImpersonatorCreatorResourceID', 'LastActivityDate', 'LastModifiedDate', 'LastName', 'LinkedInUrl', 'MiddleInitial', 'MobilePhone', 'NamePrefix', 'NameSuffix', 'Note', 'Notification', 'Phone', 'PrimaryContact', 'RoomNumber', 'SolicitationOptOut', 'SolicitationOptOutTime', 'State', 'SurveyOptOut', 'Title', 'TwitterUrl', 'ZipCode')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AccountPhysicalLocationID', 'Active', 'AdditionalAddressInformation', 'AddressLine', 'AddressLine1', 'AlternatePhone', 'ApiVendorID', 'BulkEmailOptOut', 'BulkEmailOptOutTime', 'City', 'Country', 'CountryID', 'CreateDate', 'EMailAddress', 'EMailAddress2', 'EMailAddress3', 'Extension', 'ExternalID', 'FacebookUrl', 'FaxNumber', 'FirstName', 'id', 'ImpersonatorCreatorResourceID', 'LastActivityDate', 'LastModifiedDate', 'LastName', 'LinkedInUrl', 'MiddleInitial', 'MobilePhone', 'NamePrefix', 'NameSuffix', 'Note', 'Notification', 'Phone', 'PrimaryContact', 'RoomNumber', 'SolicitationOptOut', 'SolicitationOptOutTime', 'State', 'SurveyOptOut', 'Title', 'TwitterUrl', 'ZipCode')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AccountPhysicalLocationID', 'Active', 'AdditionalAddressInformation', 'AddressLine', 'AddressLine1', 'AlternatePhone', 'ApiVendorID', 'BulkEmailOptOutTime', 'City', 'Country', 'CountryID', 'CreateDate', 'EMailAddress', 'EMailAddress2', 'EMailAddress3', 'Extension', 'ExternalID', 'FacebookUrl', 'FaxNumber', 'FirstName', 'id', 'ImpersonatorCreatorResourceID', 'LastActivityDate', 'LastModifiedDate', 'LastName', 'LinkedInUrl', 'MiddleInitial', 'MobilePhone', 'NamePrefix', 'NameSuffix', 'Note', 'Phone', 'RoomNumber', 'SolicitationOptOutTime', 'State', 'Title', 'TwitterUrl', 'UserDefinedField', 'ZipCode')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AccountPhysicalLocationID', 'Active', 'AdditionalAddressInformation', 'AddressLine', 'AddressLine1', 'AlternatePhone', 'ApiVendorID', 'BulkEmailOptOutTime', 'City', 'Country', 'CountryID', 'CreateDate', 'EMailAddress', 'EMailAddress2', 'EMailAddress3', 'Extension', 'ExternalID', 'FacebookUrl', 'FaxNumber', 'FirstName', 'id', 'ImpersonatorCreatorResourceID', 'LastActivityDate', 'LastModifiedDate', 'LastName', 'LinkedInUrl', 'MiddleInitial', 'MobilePhone', 'NamePrefix', 'NameSuffix', 'Note', 'Phone', 'RoomNumber', 'SolicitationOptOutTime', 'State', 'Title', 'TwitterUrl', 'UserDefinedField', 'ZipCode')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AccountPhysicalLocationID', 'Active', 'AdditionalAddressInformation', 'AddressLine', 'AddressLine1', 'AlternatePhone', 'ApiVendorID', 'BulkEmailOptOutTime', 'City', 'Country', 'CountryID', 'CreateDate', 'EMailAddress', 'EMailAddress2', 'EMailAddress3', 'Extension', 'ExternalID', 'FacebookUrl', 'FaxNumber', 'FirstName', 'id', 'ImpersonatorCreatorResourceID', 'LastActivityDate', 'LastModifiedDate', 'LastName', 'LinkedInUrl', 'MiddleInitial', 'MobilePhone', 'NamePrefix', 'NameSuffix', 'Note', 'Phone', 'RoomNumber', 'SolicitationOptOutTime', 'State', 'Title', 'TwitterUrl', 'UserDefinedField', 'ZipCode')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AccountPhysicalLocationID', 'Active', 'AdditionalAddressInformation', 'AddressLine', 'AddressLine1', 'AlternatePhone', 'ApiVendorID', 'BulkEmailOptOutTime', 'City', 'Country', 'CountryID', 'CreateDate', 'EMailAddress', 'EMailAddress2', 'EMailAddress3', 'Extension', 'ExternalID', 'FacebookUrl', 'FaxNumber', 'FirstName', 'id', 'ImpersonatorCreatorResourceID', 'LastActivityDate', 'LastModifiedDate', 'LastName', 'LinkedInUrl', 'MiddleInitial', 'MobilePhone', 'NamePrefix', 'NameSuffix', 'Note', 'Phone', 'RoomNumber', 'SolicitationOptOutTime', 'State', 'Title', 'TwitterUrl', 'UserDefinedField', 'ZipCode')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AdditionalAddressInformation', 'AddressLine', 'AddressLine1', 'AlternatePhone', 'City', 'Country', 'EMailAddress', 'EMailAddress2', 'EMailAddress3', 'Extension', 'ExternalID', 'FacebookUrl', 'FaxNumber', 'FirstName', 'LastName', 'LinkedInUrl', 'MiddleInitial', 'MobilePhone', 'Note', 'Phone', 'RoomNumber', 'State', 'Title', 'TwitterUrl', 'UserDefinedField', 'ZipCode')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AdditionalAddressInformation', 'AddressLine', 'AddressLine1', 'AlternatePhone', 'City', 'Country', 'EMailAddress', 'EMailAddress2', 'EMailAddress3', 'Extension', 'ExternalID', 'FacebookUrl', 'FaxNumber', 'FirstName', 'LastName', 'LinkedInUrl', 'MiddleInitial', 'MobilePhone', 'Note', 'Phone', 'RoomNumber', 'State', 'Title', 'TwitterUrl', 'UserDefinedField', 'ZipCode')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AdditionalAddressInformation', 'AddressLine', 'AddressLine1', 'AlternatePhone', 'City', 'Country', 'EMailAddress', 'EMailAddress2', 'EMailAddress3', 'Extension', 'ExternalID', 'FacebookUrl', 'FaxNumber', 'FirstName', 'LastName', 'LinkedInUrl', 'MiddleInitial', 'MobilePhone', 'Note', 'Phone', 'RoomNumber', 'State', 'Title', 'TwitterUrl', 'UserDefinedField', 'ZipCode')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AdditionalAddressInformation', 'AddressLine', 'AddressLine1', 'AlternatePhone', 'City', 'Country', 'EMailAddress', 'EMailAddress2', 'EMailAddress3', 'Extension', 'ExternalID', 'FacebookUrl', 'FaxNumber', 'FirstName', 'LastName', 'LinkedInUrl', 'MiddleInitial', 'MobilePhone', 'Note', 'Phone', 'RoomNumber', 'State', 'Title', 'TwitterUrl', 'UserDefinedField', 'ZipCode')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AdditionalAddressInformation', 'AddressLine', 'AddressLine1', 'AlternatePhone', 'City', 'Country', 'EMailAddress', 'EMailAddress2', 'EMailAddress3', 'Extension', 'ExternalID', 'FacebookUrl', 'FaxNumber', 'FirstName', 'LastName', 'LinkedInUrl', 'MiddleInitial', 'MobilePhone', 'Note', 'Phone', 'RoomNumber', 'State', 'Title', 'TwitterUrl', 'UserDefinedField', 'ZipCode')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('BulkEmailOptOutTime', 'CreateDate', 'LastActivityDate', 'LastModifiedDate', 'SolicitationOptOutTime', 'UserDefinedField')]
    [string[]]
    $IsThisDay
  )

    begin {
        $entityName = 'Contact'

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
