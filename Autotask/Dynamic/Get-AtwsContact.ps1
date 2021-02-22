#Requires -Version 4.0
#Version 1.6.14
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

AccountNote
 AccountToDo
 AttachmentInfo
 ClientPortalUser
 ContactBillingProductAssociation
 ContactGroupContact
 Contract
 InstalledProduct
 NotificationHistory
 Opportunity
 ProjectNote
 Quote
 SalesOrder
 SurveyResults
 TaskNote
 Ticket
 TicketAdditionalContact
 TicketChangeRequestApproval
 TicketNote

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

# Return entities of selected type that are referencing to this entity.
    [Parameter(
      ParametersetName = 'Filter'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('External')]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('AccountNote:ContactID', 'AccountToDo:ContactID', 'AttachmentInfo:AttachedByContactID', 'ClientPortalUser:ContactID', 'ContactBillingProductAssociation:ContactID', 'ContactGroupContact:ContactID', 'Contract:BillToAccountContactID', 'Contract:ContactID', 'InstalledProduct:ContactID', 'InstalledProduct:InstalledByContactID', 'NotificationHistory:InitiatingContactID', 'Opportunity:ContactID', 'ProjectNote:CreatedByContactID', 'Quote:ContactID', 'SalesOrder:Contact', 'SurveyResults:ContactID', 'TaskNote:CreatedByContactID', 'Ticket:ContactID', 'Ticket:CreatedByContactID', 'TicketAdditionalContact:ContactID', 'TicketChangeRequestApproval:ContactID', 'TicketNote:CreatedByContactID')]
    [string]
    $GetExternalEntityByThisEntityId,

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

# Contact ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Client
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $AccountID,

# First Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,50)]
    [string[]]
    $FirstName,

# Last Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,50)]
    [string[]]
    $LastName,

# Middle Initial
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $MiddleInitial,

# Title
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $Title,

# Contact Address 1
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [string[]]
    $AddressLine,

# Contact Address 2
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [string[]]
    $AddressLine1,

# Contact City
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,32)]
    [string[]]
    $City,

# Contact County
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,40)]
    [string[]]
    $State,

# Contact Postal Code
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,16)]
    [string[]]
    $ZipCode,

# Contact Country
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $Country,

# Email
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,254)]
    [string[]]
    $EMailAddress,

# Email2
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,254)]
    [string[]]
    $EMailAddress2,

# Email3
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,254)]
    [string[]]
    $EMailAddress3,

# Notification
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $Notification,

# Contact Phone
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $Phone,

# Contact Phone Ext.
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,10)]
    [string[]]
    $Extension,

# Contact Alternate Phone
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,32)]
    [string[]]
    $AlternatePhone,

# Contact Mobile Phone
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $MobilePhone,

# Contact Fax
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $FaxNumber,

# Note
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $Note,

# Last Activity Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LastActivityDate,

# Room Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $RoomNumber,

# Active
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $Active,

# Create Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CreateDate,

# Last Modified Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LastModifiedDate,

# Additional Address Information
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $AdditionalAddressInformation,

# External ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $ExternalID,

# Contact Country ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CountryID,

# Bulk Email Opt Out Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $BulkEmailOptOutTime,

# Name Prefix
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $NamePrefix,

# Name Suffix
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $NameSuffix,

# Facebook URL
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,200)]
    [string[]]
    $FacebookUrl,

# Twitter URL
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,200)]
    [string[]]
    $TwitterUrl,

# LinkedIn URL
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,200)]
    [string[]]
    $LinkedInUrl,

# Primary Contact
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $PrimaryContact,

# Account Physical Location
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $AccountPhysicalLocationID,

# Solicitation Opt Out Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $SolicitationOptOutTime,

# API Vendor ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $ApiVendorID,

# Impersonator Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ImpersonatorCreatorResourceID,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'FirstName', 'LastName', 'MiddleInitial', 'Title', 'AddressLine', 'AddressLine1', 'City', 'State', 'ZipCode', 'Country', 'EMailAddress', 'EMailAddress2', 'EMailAddress3', 'Notification', 'Phone', 'Extension', 'AlternatePhone', 'MobilePhone', 'FaxNumber', 'Note', 'LastActivityDate', 'RoomNumber', 'Active', 'CreateDate', 'LastModifiedDate', 'AdditionalAddressInformation', 'ExternalID', 'CountryID', 'BulkEmailOptOutTime', 'NamePrefix', 'NameSuffix', 'FacebookUrl', 'TwitterUrl', 'LinkedInUrl', 'PrimaryContact', 'AccountPhysicalLocationID', 'SolicitationOptOutTime', 'ApiVendorID', 'ImpersonatorCreatorResourceID', 'UserDefinedField')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'FirstName', 'LastName', 'MiddleInitial', 'Title', 'AddressLine', 'AddressLine1', 'City', 'State', 'ZipCode', 'Country', 'EMailAddress', 'EMailAddress2', 'EMailAddress3', 'Notification', 'Phone', 'Extension', 'AlternatePhone', 'MobilePhone', 'FaxNumber', 'Note', 'LastActivityDate', 'RoomNumber', 'Active', 'CreateDate', 'LastModifiedDate', 'AdditionalAddressInformation', 'ExternalID', 'CountryID', 'BulkEmailOptOutTime', 'NamePrefix', 'NameSuffix', 'FacebookUrl', 'TwitterUrl', 'LinkedInUrl', 'PrimaryContact', 'AccountPhysicalLocationID', 'SolicitationOptOutTime', 'ApiVendorID', 'ImpersonatorCreatorResourceID', 'UserDefinedField')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'FirstName', 'LastName', 'MiddleInitial', 'Title', 'AddressLine', 'AddressLine1', 'City', 'State', 'ZipCode', 'Country', 'EMailAddress', 'EMailAddress2', 'EMailAddress3', 'Notification', 'Phone', 'Extension', 'AlternatePhone', 'MobilePhone', 'FaxNumber', 'Note', 'LastActivityDate', 'RoomNumber', 'Active', 'CreateDate', 'LastModifiedDate', 'AdditionalAddressInformation', 'ExternalID', 'CountryID', 'BulkEmailOptOutTime', 'NamePrefix', 'NameSuffix', 'FacebookUrl', 'TwitterUrl', 'LinkedInUrl', 'PrimaryContact', 'AccountPhysicalLocationID', 'SolicitationOptOutTime', 'ApiVendorID', 'ImpersonatorCreatorResourceID', 'UserDefinedField')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'FirstName', 'LastName', 'MiddleInitial', 'Title', 'AddressLine', 'AddressLine1', 'City', 'State', 'ZipCode', 'Country', 'EMailAddress', 'EMailAddress2', 'EMailAddress3', 'Phone', 'Extension', 'AlternatePhone', 'MobilePhone', 'FaxNumber', 'Note', 'LastActivityDate', 'RoomNumber', 'Active', 'CreateDate', 'LastModifiedDate', 'AdditionalAddressInformation', 'ExternalID', 'CountryID', 'BulkEmailOptOutTime', 'NamePrefix', 'NameSuffix', 'FacebookUrl', 'TwitterUrl', 'LinkedInUrl', 'AccountPhysicalLocationID', 'SolicitationOptOutTime', 'ApiVendorID', 'ImpersonatorCreatorResourceID', 'UserDefinedField')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'FirstName', 'LastName', 'MiddleInitial', 'Title', 'AddressLine', 'AddressLine1', 'City', 'State', 'ZipCode', 'Country', 'EMailAddress', 'EMailAddress2', 'EMailAddress3', 'Phone', 'Extension', 'AlternatePhone', 'MobilePhone', 'FaxNumber', 'Note', 'LastActivityDate', 'RoomNumber', 'Active', 'CreateDate', 'LastModifiedDate', 'AdditionalAddressInformation', 'ExternalID', 'CountryID', 'BulkEmailOptOutTime', 'NamePrefix', 'NameSuffix', 'FacebookUrl', 'TwitterUrl', 'LinkedInUrl', 'AccountPhysicalLocationID', 'SolicitationOptOutTime', 'ApiVendorID', 'ImpersonatorCreatorResourceID', 'UserDefinedField')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'FirstName', 'LastName', 'MiddleInitial', 'Title', 'AddressLine', 'AddressLine1', 'City', 'State', 'ZipCode', 'Country', 'EMailAddress', 'EMailAddress2', 'EMailAddress3', 'Phone', 'Extension', 'AlternatePhone', 'MobilePhone', 'FaxNumber', 'Note', 'LastActivityDate', 'RoomNumber', 'Active', 'CreateDate', 'LastModifiedDate', 'AdditionalAddressInformation', 'ExternalID', 'CountryID', 'BulkEmailOptOutTime', 'NamePrefix', 'NameSuffix', 'FacebookUrl', 'TwitterUrl', 'LinkedInUrl', 'AccountPhysicalLocationID', 'SolicitationOptOutTime', 'ApiVendorID', 'ImpersonatorCreatorResourceID', 'UserDefinedField')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'FirstName', 'LastName', 'MiddleInitial', 'Title', 'AddressLine', 'AddressLine1', 'City', 'State', 'ZipCode', 'Country', 'EMailAddress', 'EMailAddress2', 'EMailAddress3', 'Phone', 'Extension', 'AlternatePhone', 'MobilePhone', 'FaxNumber', 'Note', 'LastActivityDate', 'RoomNumber', 'Active', 'CreateDate', 'LastModifiedDate', 'AdditionalAddressInformation', 'ExternalID', 'CountryID', 'BulkEmailOptOutTime', 'NamePrefix', 'NameSuffix', 'FacebookUrl', 'TwitterUrl', 'LinkedInUrl', 'AccountPhysicalLocationID', 'SolicitationOptOutTime', 'ApiVendorID', 'ImpersonatorCreatorResourceID', 'UserDefinedField')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('FirstName', 'LastName', 'MiddleInitial', 'Title', 'AddressLine', 'AddressLine1', 'City', 'State', 'ZipCode', 'Country', 'EMailAddress', 'EMailAddress2', 'EMailAddress3', 'Phone', 'Extension', 'AlternatePhone', 'MobilePhone', 'FaxNumber', 'Note', 'RoomNumber', 'AdditionalAddressInformation', 'ExternalID', 'FacebookUrl', 'TwitterUrl', 'LinkedInUrl', 'UserDefinedField')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('FirstName', 'LastName', 'MiddleInitial', 'Title', 'AddressLine', 'AddressLine1', 'City', 'State', 'ZipCode', 'Country', 'EMailAddress', 'EMailAddress2', 'EMailAddress3', 'Phone', 'Extension', 'AlternatePhone', 'MobilePhone', 'FaxNumber', 'Note', 'RoomNumber', 'AdditionalAddressInformation', 'ExternalID', 'FacebookUrl', 'TwitterUrl', 'LinkedInUrl', 'UserDefinedField')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('FirstName', 'LastName', 'MiddleInitial', 'Title', 'AddressLine', 'AddressLine1', 'City', 'State', 'ZipCode', 'Country', 'EMailAddress', 'EMailAddress2', 'EMailAddress3', 'Phone', 'Extension', 'AlternatePhone', 'MobilePhone', 'FaxNumber', 'Note', 'RoomNumber', 'AdditionalAddressInformation', 'ExternalID', 'FacebookUrl', 'TwitterUrl', 'LinkedInUrl', 'UserDefinedField')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('FirstName', 'LastName', 'MiddleInitial', 'Title', 'AddressLine', 'AddressLine1', 'City', 'State', 'ZipCode', 'Country', 'EMailAddress', 'EMailAddress2', 'EMailAddress3', 'Phone', 'Extension', 'AlternatePhone', 'MobilePhone', 'FaxNumber', 'Note', 'RoomNumber', 'AdditionalAddressInformation', 'ExternalID', 'FacebookUrl', 'TwitterUrl', 'LinkedInUrl', 'UserDefinedField')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('FirstName', 'LastName', 'MiddleInitial', 'Title', 'AddressLine', 'AddressLine1', 'City', 'State', 'ZipCode', 'Country', 'EMailAddress', 'EMailAddress2', 'EMailAddress3', 'Phone', 'Extension', 'AlternatePhone', 'MobilePhone', 'FaxNumber', 'Note', 'RoomNumber', 'AdditionalAddressInformation', 'ExternalID', 'FacebookUrl', 'TwitterUrl', 'LinkedInUrl', 'UserDefinedField')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('LastActivityDate', 'CreateDate', 'LastModifiedDate', 'BulkEmailOptOutTime', 'SolicitationOptOutTime', 'UserDefinedField')]
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
