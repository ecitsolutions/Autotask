#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsPurchaseOrder
{


<#
.SYNOPSIS
This function get one or more PurchaseOrder through the Autotask Web Services API.
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
TaxGroup
PaymentTerm
UseItemDescriptionsFrom

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.PurchaseOrder[]]. This function outputs the Autotask.PurchaseOrder that was returned by the API.
.EXAMPLE
Get-AtwsPurchaseOrder -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsPurchaseOrder -PurchaseOrderName SomeName
Returns the object with PurchaseOrderName 'SomeName', if any.
 .EXAMPLE
Get-AtwsPurchaseOrder -PurchaseOrderName 'Some Name'
Returns the object with PurchaseOrderName 'Some Name', if any.
 .EXAMPLE
Get-AtwsPurchaseOrder -PurchaseOrderName 'Some Name' -NotEquals PurchaseOrderName
Returns any objects with a PurchaseOrderName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsPurchaseOrder -PurchaseOrderName SomeName* -Like PurchaseOrderName
Returns any object with a PurchaseOrderName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsPurchaseOrder -PurchaseOrderName SomeName* -NotLike PurchaseOrderName
Returns any object with a PurchaseOrderName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsPurchaseOrder -Status <PickList Label>
Returns any PurchaseOrders with property Status equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsPurchaseOrder -Status <PickList Label> -NotEquals Status 
Returns any PurchaseOrders with property Status NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsPurchaseOrder -Status <PickList Label1>, <PickList Label2>
Returns any PurchaseOrders with property Status equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsPurchaseOrder -Status <PickList Label1>, <PickList Label2> -NotEquals Status
Returns any PurchaseOrders with property Status NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsPurchaseOrder -Id 1234 -PurchaseOrderName SomeName* -Status <PickList Label1>, <PickList Label2> -Like PurchaseOrderName -NotEquals Status -GreaterThan Id
An example of a more complex query. This command returns any PurchaseOrders with Id GREATER THAN 1234, a PurchaseOrderName that matches the simple pattern SomeName* AND that has a Status that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsPurchaseOrder
 .LINK
Set-AtwsPurchaseOrder

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
    [ValidateSet('CreatorResourceID', 'ImpersonatorCreatorResourceID', 'PurchaseForAccountID', 'ShippingType', 'VendorID')]
    [string]
    $GetReferenceEntityById,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# Cancel Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CancelDateTime,

# Create Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CreateDateTime,

# Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CreatorResourceID,

# External Purchase Order Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $ExternalPONumber,

# Fax
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $Fax,

# Freight Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $Freight,

# General Memo
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,4000)]
    [string[]]
    $GeneralMemo,

# Order ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Impersonator Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ImpersonatorCreatorResourceID,

# Internal Currency Freight Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $InternalCurrencyFreight,

# Latest Estimated Arrival Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LatestEstimatedArrivalDate,

# Payment Term ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity PurchaseOrder -FieldName PaymentTerm -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity PurchaseOrder -FieldName PaymentTerm -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $PaymentTerm,

# Phone
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $Phone,

# Purchase For Account ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $PurchaseForAccountID,

# Expected Ship Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ShippingDate,

# Shipping Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ShippingType,

# Address Line 1
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,128)]
    [string[]]
    $ShipToAddress1,

# Address Line 2
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [string[]]
    $ShipToAddress2,

# City
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,30)]
    [string[]]
    $ShipToCity,

# Addressee Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [string[]]
    $ShipToName,

# Postal Code
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,10)]
    [string[]]
    $ShipToPostalCode,

# State
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $ShipToState,

# Show Each Tax In Tax Group
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $ShowEachTaxInGroup,

# Show Tax Category
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $ShowTaxCategory,

# Order Status ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity PurchaseOrder -FieldName Status -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity PurchaseOrder -FieldName Status -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $Status,

# Submit Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $SubmitDateTime,

# Tax Group ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity PurchaseOrder -FieldName TaxGroup -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity PurchaseOrder -FieldName TaxGroup -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $TaxGroup,

# Use Item Descriptions From
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity PurchaseOrder -FieldName UseItemDescriptionsFrom -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity PurchaseOrder -FieldName UseItemDescriptionsFrom -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $UseItemDescriptionsFrom,

# Vendor Account ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $VendorID,

# Vendor Invoice Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $VendorInvoiceNumber,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ShippingType', 'ShipToAddress2', 'Status', 'UseItemDescriptionsFrom', 'Freight', 'TaxGroup', 'ShippingDate', 'Fax', 'ShipToAddress1', 'PaymentTerm', 'PurchaseForAccountID', 'ExternalPONumber', 'CancelDateTime', 'Phone', 'ShipToState', 'CreateDateTime', 'InternalCurrencyFreight', 'SubmitDateTime', 'ShipToPostalCode', 'VendorInvoiceNumber', 'VendorID', 'ShowEachTaxInGroup', 'ShipToName', 'ShowTaxCategory', 'ShipToCity', 'CreatorResourceID', 'ImpersonatorCreatorResourceID', 'LatestEstimatedArrivalDate', 'id', 'GeneralMemo')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ShippingType', 'ShipToAddress2', 'Status', 'UseItemDescriptionsFrom', 'Freight', 'TaxGroup', 'ShippingDate', 'Fax', 'ShipToAddress1', 'PaymentTerm', 'PurchaseForAccountID', 'ExternalPONumber', 'CancelDateTime', 'Phone', 'ShipToState', 'CreateDateTime', 'InternalCurrencyFreight', 'SubmitDateTime', 'ShipToPostalCode', 'VendorInvoiceNumber', 'VendorID', 'ShowEachTaxInGroup', 'ShipToName', 'ShowTaxCategory', 'ShipToCity', 'CreatorResourceID', 'ImpersonatorCreatorResourceID', 'LatestEstimatedArrivalDate', 'id', 'GeneralMemo')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ShippingType', 'ShipToAddress2', 'Status', 'UseItemDescriptionsFrom', 'Freight', 'TaxGroup', 'ShippingDate', 'Fax', 'ShipToAddress1', 'PaymentTerm', 'PurchaseForAccountID', 'ExternalPONumber', 'CancelDateTime', 'Phone', 'ShipToState', 'CreateDateTime', 'InternalCurrencyFreight', 'SubmitDateTime', 'ShipToPostalCode', 'VendorInvoiceNumber', 'VendorID', 'ShowEachTaxInGroup', 'ShipToName', 'ShowTaxCategory', 'ShipToCity', 'CreatorResourceID', 'ImpersonatorCreatorResourceID', 'LatestEstimatedArrivalDate', 'id', 'GeneralMemo')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'VendorID', 'Status', 'CreatorResourceID', 'CreateDateTime', 'SubmitDateTime', 'CancelDateTime', 'ShipToName', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'GeneralMemo', 'Phone', 'Fax', 'VendorInvoiceNumber', 'ExternalPONumber', 'PurchaseForAccountID', 'ShippingType', 'ShippingDate', 'Freight', 'TaxGroup', 'PaymentTerm', 'LatestEstimatedArrivalDate', 'UseItemDescriptionsFrom', 'InternalCurrencyFreight', 'ImpersonatorCreatorResourceID')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'VendorID', 'Status', 'CreatorResourceID', 'CreateDateTime', 'SubmitDateTime', 'CancelDateTime', 'ShipToName', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'GeneralMemo', 'Phone', 'Fax', 'VendorInvoiceNumber', 'ExternalPONumber', 'PurchaseForAccountID', 'ShippingType', 'ShippingDate', 'Freight', 'TaxGroup', 'PaymentTerm', 'LatestEstimatedArrivalDate', 'UseItemDescriptionsFrom', 'InternalCurrencyFreight', 'ImpersonatorCreatorResourceID')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'VendorID', 'Status', 'CreatorResourceID', 'CreateDateTime', 'SubmitDateTime', 'CancelDateTime', 'ShipToName', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'GeneralMemo', 'Phone', 'Fax', 'VendorInvoiceNumber', 'ExternalPONumber', 'PurchaseForAccountID', 'ShippingType', 'ShippingDate', 'Freight', 'TaxGroup', 'PaymentTerm', 'LatestEstimatedArrivalDate', 'UseItemDescriptionsFrom', 'InternalCurrencyFreight', 'ImpersonatorCreatorResourceID')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'VendorID', 'Status', 'CreatorResourceID', 'CreateDateTime', 'SubmitDateTime', 'CancelDateTime', 'ShipToName', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'GeneralMemo', 'Phone', 'Fax', 'VendorInvoiceNumber', 'ExternalPONumber', 'PurchaseForAccountID', 'ShippingType', 'ShippingDate', 'Freight', 'TaxGroup', 'PaymentTerm', 'LatestEstimatedArrivalDate', 'UseItemDescriptionsFrom', 'InternalCurrencyFreight', 'ImpersonatorCreatorResourceID')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ShipToName', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'GeneralMemo', 'Phone', 'Fax', 'VendorInvoiceNumber', 'ExternalPONumber')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ShipToName', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'GeneralMemo', 'Phone', 'Fax', 'VendorInvoiceNumber', 'ExternalPONumber')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ShipToName', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'GeneralMemo', 'Phone', 'Fax', 'VendorInvoiceNumber', 'ExternalPONumber')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ShipToName', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'GeneralMemo', 'Phone', 'Fax', 'VendorInvoiceNumber', 'ExternalPONumber')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ShipToName', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'GeneralMemo', 'Phone', 'Fax', 'VendorInvoiceNumber', 'ExternalPONumber')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDateTime', 'SubmitDateTime', 'CancelDateTime', 'ShippingDate', 'LatestEstimatedArrivalDate')]
    [string[]]
    $IsThisDay
  )

    begin { 
        $entityName = 'PurchaseOrder'
    
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
                -GetReferenceEntityById $GetReferenceEntityById
    
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
