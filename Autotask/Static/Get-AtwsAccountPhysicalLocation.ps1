#Requires -Version 4.0
#Version 1.6.2.17
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsAccountPhysicalLocation
{


<#
.SYNOPSIS
This function get one or more AccountPhysicalLocation through the Autotask Web Services API.
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


Entities that have fields that refer to the base entity of this CmdLet:

Account
 Contact
 InstalledProduct
 ServiceCall
 Task
 Ticket

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.AccountPhysicalLocation[]]. This function outputs the Autotask.AccountPhysicalLocation that was returned by the API.
.EXAMPLE
Get-AtwsAccountPhysicalLocation -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsAccountPhysicalLocation -AccountPhysicalLocationName SomeName
Returns the object with AccountPhysicalLocationName 'SomeName', if any.
 .EXAMPLE
Get-AtwsAccountPhysicalLocation -AccountPhysicalLocationName 'Some Name'
Returns the object with AccountPhysicalLocationName 'Some Name', if any.
 .EXAMPLE
Get-AtwsAccountPhysicalLocation -AccountPhysicalLocationName 'Some Name' -NotEquals AccountPhysicalLocationName
Returns any objects with a AccountPhysicalLocationName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsAccountPhysicalLocation -AccountPhysicalLocationName SomeName* -Like AccountPhysicalLocationName
Returns any object with a AccountPhysicalLocationName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsAccountPhysicalLocation -AccountPhysicalLocationName SomeName* -NotLike AccountPhysicalLocationName
Returns any object with a AccountPhysicalLocationName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.

.LINK
New-AtwsAccountPhysicalLocation
 .LINK
Remove-AtwsAccountPhysicalLocation
 .LINK
Set-AtwsAccountPhysicalLocation

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
    [ValidateSet('AccountID', 'CountryID')]
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
    [ValidateSet('Account:BillToAccountPhysicalLocationID', 'Contact:AccountPhysicalLocationID', 'InstalledProduct:AccountPhysicalLocationID', 'ServiceCall:AccountPhysicalLocationID', 'Task:AccountPhysicalLocationID', 'Ticket:AccountPhysicalLocationID')]
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

# Account Physical Location ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Account ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $AccountID,

# Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [string[]]
    $Name,

# Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string[]]
    $Description,

# Address1
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [string[]]
    $Address1,

# Address2
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
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

# Country ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CountryID,

# Phone
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $Phone,

# Alternate Phone 1
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $AlternatePhone1,

# Alternate Phone 2
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $AlternatePhone2,

# Fax
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $Fax,

# Round Trip Distance
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $RoundtripDistance,

# Active
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $Active,

# Primary
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $Primary,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'Name', 'Description', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'CountryID', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax', 'RoundtripDistance', 'Active', 'Primary')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'Name', 'Description', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'CountryID', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax', 'RoundtripDistance', 'Active', 'Primary')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'Name', 'Description', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'CountryID', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax', 'RoundtripDistance', 'Active', 'Primary')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'Name', 'Description', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'CountryID', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax', 'RoundtripDistance')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'Name', 'Description', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'CountryID', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax', 'RoundtripDistance')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'Name', 'Description', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'CountryID', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax', 'RoundtripDistance')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'Name', 'Description', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'CountryID', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax', 'RoundtripDistance')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'Address1', 'Address2', 'City', 'State', 'PostalCode', 'Phone', 'AlternatePhone1', 'AlternatePhone2', 'Fax')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $IsThisDay
  )

    begin { 
        $entityName = 'AccountPhysicalLocation'
    
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
            $Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $entityName
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
