#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsSalesOrder
{


<#
.SYNOPSIS
This function get one or more SalesOrder through the Autotask Web Services API.
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
Status

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.SalesOrder[]]. This function outputs the Autotask.SalesOrder that was returned by the API.
.EXAMPLE
Get-AtwsSalesOrder -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsSalesOrder -SalesOrderName SomeName
Returns the object with SalesOrderName 'SomeName', if any.
 .EXAMPLE
Get-AtwsSalesOrder -SalesOrderName 'Some Name'
Returns the object with SalesOrderName 'Some Name', if any.
 .EXAMPLE
Get-AtwsSalesOrder -SalesOrderName 'Some Name' -NotEquals SalesOrderName
Returns any objects with a SalesOrderName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsSalesOrder -SalesOrderName SomeName* -Like SalesOrderName
Returns any object with a SalesOrderName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsSalesOrder -SalesOrderName SomeName* -NotLike SalesOrderName
Returns any object with a SalesOrderName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsSalesOrder -Status <PickList Label>
Returns any SalesOrders with property Status equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsSalesOrder -Status <PickList Label> -NotEquals Status 
Returns any SalesOrders with property Status NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsSalesOrder -Status <PickList Label1>, <PickList Label2>
Returns any SalesOrders with property Status equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsSalesOrder -Status <PickList Label1>, <PickList Label2> -NotEquals Status
Returns any SalesOrders with property Status NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsSalesOrder -Id 1234 -SalesOrderName SomeName* -Status <PickList Label1>, <PickList Label2> -Like SalesOrderName -NotEquals Status -GreaterThan Id
An example of a more complex query. This command returns any SalesOrders with Id GREATER THAN 1234, a SalesOrderName that matches the simple pattern SomeName* AND that has a Status that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
Set-AtwsSalesOrder

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
    [ValidateSet('BusinessDivisionSubdivisionID', 'ShipToCountryID', 'AccountID', 'OpportunityID', 'ImpersonatorCreatorResourceID', 'Contact')]
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
    [ValidateSet('PurchaseOrderItem', 'Opportunity')]
    [string]
    $GetExternalEntityByThisEntityId,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# Sales Order ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $id,

# Client ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $AccountID,

# Title
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,128)]
    [string[]]
    $Title,

# Status
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity SalesOrder -FieldName Status -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity SalesOrder -FieldName Status -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $Status,

# Contact ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $Contact,

# Owner
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $OwnerResourceID,

# Sales Order Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $SalesOrderDate,

# Promised Due Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $PromisedDueDate,

# Bill to Address1
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,150)]
    [string[]]
    $BillToAddress1,

# Bill to Address2
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,150)]
    [string[]]
    $BillToAddress2,

# Bill to City
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $BillToCity,

# Bill to County
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $BillToState,

# Bill to Postal Code
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $BillToPostalCode,

# Bill to Country
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $BillToCountry,

# Ship to Address1
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,150)]
    [string[]]
    $ShipToAddress1,

# Ship to Address2
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,150)]
    [string[]]
    $ShipToAddress2,

# Ship to City
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $ShipToCity,

# Ship to County
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $ShipToState,

# Ship to Postal Code
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $ShipToPostalCode,

# Ship to Country
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $ShipToCountry,

# Opportunity ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $OpportunityID,

# Additional Bill To Address Information
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $AdditionalBillToAddressInformation,

# Additional Ship To Address Information
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $AdditionalShipToAddressInformation,

# Bill To Country ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BillToCountryID,

# Ship To Country ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ShipToCountryID,

# Business Division Subdivision ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BusinessDivisionSubdivisionID,

# Impersonator Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ImpersonatorCreatorResourceID,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Status', 'ShipToState', 'ShipToCountry', 'BillToAddress2', 'OwnerResourceID', 'BillToCountry', 'BillToState', 'ShipToAddress2', 'ShipToAddress1', 'BillToCity', 'ShipToCity', 'PromisedDueDate', 'ImpersonatorCreatorResourceID', 'AccountID', 'BillToAddress1', 'BillToCountryID', 'Contact', 'ShipToPostalCode', 'AdditionalShipToAddressInformation', 'BusinessDivisionSubdivisionID', 'OpportunityID', 'BillToPostalCode', 'id', 'ShipToCountryID', 'Title', 'AdditionalBillToAddressInformation', 'SalesOrderDate')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Status', 'ShipToState', 'ShipToCountry', 'BillToAddress2', 'OwnerResourceID', 'BillToCountry', 'BillToState', 'ShipToAddress2', 'ShipToAddress1', 'BillToCity', 'ShipToCity', 'PromisedDueDate', 'ImpersonatorCreatorResourceID', 'AccountID', 'BillToAddress1', 'BillToCountryID', 'Contact', 'ShipToPostalCode', 'AdditionalShipToAddressInformation', 'BusinessDivisionSubdivisionID', 'OpportunityID', 'BillToPostalCode', 'id', 'ShipToCountryID', 'Title', 'AdditionalBillToAddressInformation', 'SalesOrderDate')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Status', 'ShipToState', 'ShipToCountry', 'BillToAddress2', 'OwnerResourceID', 'BillToCountry', 'BillToState', 'ShipToAddress2', 'ShipToAddress1', 'BillToCity', 'ShipToCity', 'PromisedDueDate', 'ImpersonatorCreatorResourceID', 'AccountID', 'BillToAddress1', 'BillToCountryID', 'Contact', 'ShipToPostalCode', 'AdditionalShipToAddressInformation', 'BusinessDivisionSubdivisionID', 'OpportunityID', 'BillToPostalCode', 'id', 'ShipToCountryID', 'Title', 'AdditionalBillToAddressInformation', 'SalesOrderDate')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'Title', 'Status', 'Contact', 'OwnerResourceID', 'SalesOrderDate', 'PromisedDueDate', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToPostalCode', 'BillToCountry', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'ShipToCountry', 'OpportunityID', 'AdditionalBillToAddressInformation', 'AdditionalShipToAddressInformation', 'BillToCountryID', 'ShipToCountryID', 'BusinessDivisionSubdivisionID', 'ImpersonatorCreatorResourceID')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'Title', 'Status', 'Contact', 'OwnerResourceID', 'SalesOrderDate', 'PromisedDueDate', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToPostalCode', 'BillToCountry', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'ShipToCountry', 'OpportunityID', 'AdditionalBillToAddressInformation', 'AdditionalShipToAddressInformation', 'BillToCountryID', 'ShipToCountryID', 'BusinessDivisionSubdivisionID', 'ImpersonatorCreatorResourceID')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'Title', 'Status', 'Contact', 'OwnerResourceID', 'SalesOrderDate', 'PromisedDueDate', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToPostalCode', 'BillToCountry', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'ShipToCountry', 'OpportunityID', 'AdditionalBillToAddressInformation', 'AdditionalShipToAddressInformation', 'BillToCountryID', 'ShipToCountryID', 'BusinessDivisionSubdivisionID', 'ImpersonatorCreatorResourceID')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'Title', 'Status', 'Contact', 'OwnerResourceID', 'SalesOrderDate', 'PromisedDueDate', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToPostalCode', 'BillToCountry', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'ShipToCountry', 'OpportunityID', 'AdditionalBillToAddressInformation', 'AdditionalShipToAddressInformation', 'BillToCountryID', 'ShipToCountryID', 'BusinessDivisionSubdivisionID', 'ImpersonatorCreatorResourceID')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Title', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToPostalCode', 'BillToCountry', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'ShipToCountry', 'AdditionalBillToAddressInformation', 'AdditionalShipToAddressInformation')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Title', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToPostalCode', 'BillToCountry', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'ShipToCountry', 'AdditionalBillToAddressInformation', 'AdditionalShipToAddressInformation')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Title', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToPostalCode', 'BillToCountry', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'ShipToCountry', 'AdditionalBillToAddressInformation', 'AdditionalShipToAddressInformation')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Title', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToPostalCode', 'BillToCountry', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'ShipToCountry', 'AdditionalBillToAddressInformation', 'AdditionalShipToAddressInformation')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Title', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToPostalCode', 'BillToCountry', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'ShipToCountry', 'AdditionalBillToAddressInformation', 'AdditionalShipToAddressInformation')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('SalesOrderDate', 'PromisedDueDate')]
    [string[]]
    $IsThisDay
  )

    begin { 
        $entityName = 'SalesOrder'
    
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
