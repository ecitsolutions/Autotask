#Requires -Version 4.0
#Version 1.6.5
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function New-AtwsContact
{


<#
.SYNOPSIS
This function creates a new Contact through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.Contact] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the Contact with Id number 0 you could write 'New-AtwsContact -Id 0' or you could write 'New-AtwsContact -Filter {Id -eq 0}.

'New-AtwsContact -Id 0,4' could be written as 'New-AtwsContact -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new Contact you need the following required fields:
 -AccountID
 -FirstName
 -LastName
 -Active

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
 Quote
 SalesOrder
 SurveyResults
 Ticket
 TicketAdditionalContact
 TicketChangeRequestApproval

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Contact]. This function outputs the Autotask.Contact that was created by the API.
.EXAMPLE
$result = New-AtwsContact -AccountID [Value] -FirstName [Value] -LastName [Value] -Active [Value]
Creates a new [Autotask.Contact] through the Web Services API and returns the new object.
 .EXAMPLE
$result = Get-AtwsContact -Id 124 | New-AtwsContact 
Copies [Autotask.Contact] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsContact -Id 124 | New-AtwsContact | Set-AtwsContact -ParameterName <Parameter Value>
Copies [Autotask.Contact] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsContact to modify the object.
 .EXAMPLE
$result = Get-AtwsContact -Id 124 | New-AtwsContact | Set-AtwsContact -ParameterName <Parameter Value> -Passthru
Copies [Autotask.Contact] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsContact to modify the object and returns the new object.

.LINK
Remove-AtwsContact
 .LINK
Get-AtwsContact
 .LINK
Set-AtwsContact

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
    [Autotask.Contact[]]
    $InputObject,

# User defined fields already setup i Autotask
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('UDF')]
    [ValidateNotNullOrEmpty()]
    [Autotask.UserDefinedField[]]
    $UserDefinedFields,

# Client
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $AccountID,

# First Name
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,50)]
    [string]
    $FirstName,

# Last Name
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,50)]
    [string]
    $LastName,

# Middle Initial
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $MiddleInitial,

# Title
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $Title,

# Contact Address 1
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [string]
    $AddressLine,

# Contact Address 2
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [string]
    $AddressLine1,

# Contact City
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,32)]
    [string]
    $City,

# Contact County
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,40)]
    [string]
    $State,

# Contact Postal Code
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,16)]
    [string]
    $ZipCode,

# Contact Country
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string]
    $Country,

# Email
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,254)]
    [string]
    $EMailAddress,

# Email2
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,254)]
    [string]
    $EMailAddress2,

# Email3
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,254)]
    [string]
    $EMailAddress3,

# Notification
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $Notification,

# Contact Phone
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string]
    $Phone,

# Contact Phone Ext.
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,10)]
    [string]
    $Extension,

# Contact Alternate Phone
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,32)]
    [string]
    $AlternatePhone,

# Contact Mobile Phone
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string]
    $MobilePhone,

# Contact Fax
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string]
    $FaxNumber,

# Note
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $Note,

# Last Activity Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $LastActivityDate,

# Room Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $RoomNumber,

# Active
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $Active,

# Create Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $CreateDate,

# Last Modified Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $LastModifiedDate,

# Additional Address Information
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string]
    $AdditionalAddressInformation,

# External ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $ExternalID,

# Contact Country ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $CountryID,

# Bulk Email Opt Out
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $BulkEmailOptOut,

# Bulk Email Opt Out Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $BulkEmailOptOutTime,

# Survey Opt Out
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $SurveyOptOut,

# Name Prefix
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string]
    $NamePrefix,

# Name Suffix
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string]
    $NameSuffix,

# Facebook URL
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,200)]
    [string]
    $FacebookUrl,

# Twitter URL
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,200)]
    [string]
    $TwitterUrl,

# LinkedIn URL
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,200)]
    [string]
    $LinkedInUrl,

# Primary Contact
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $PrimaryContact,

# Account Physical Location
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $AccountPhysicalLocationID,

# Solicitation Opt Out
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $SolicitationOptOut,

# Solicitation Opt Out Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $SolicitationOptOutTime,

# API Vendor ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string]
    $ApiVendorID,

# Impersonator Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ImpersonatorCreatorResourceID
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
        
        $processObject = @()
    }

    process {
    
        if ($InputObject) {
            Write-Verbose -Message ('{0}: Copy Object mode: Setting ID property to zero' -F $MyInvocation.MyCommand.Name)  

            $fields = Get-AtwsFieldInfo -Entity $entityName
      
            $CopyNo = 1

            foreach ($object in $InputObject) { 
                # Create a new object and copy properties
                $newObject = New-Object -TypeName Autotask.$entityName
        
                # Copy every non readonly property
                $fieldNames = $fields.Where( { $_.Name -ne 'id' }).Name

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
                $processObject += $newObject
            }   
        }
        else {
            Write-Debug -Message ('{0}: Creating empty [Autotask.{1}]' -F $MyInvocation.MyCommand.Name, $entityName) 
            $processObject += New-Object -TypeName Autotask.$entityName    
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
