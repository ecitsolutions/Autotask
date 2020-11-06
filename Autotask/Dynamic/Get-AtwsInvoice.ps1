#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsInvoice
{


<#
.SYNOPSIS
This function get one or more Invoice through the Autotask Web Services API.
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

TaxGroup
 

PaymentTerm
 

Entities that have fields that refer to the base entity of this CmdLet:

BillingItem

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Invoice[]]. This function outputs the Autotask.Invoice that was returned by the API.
.EXAMPLE
Get-AtwsInvoice -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsInvoice -InvoiceName SomeName
Returns the object with InvoiceName 'SomeName', if any.
 .EXAMPLE
Get-AtwsInvoice -InvoiceName 'Some Name'
Returns the object with InvoiceName 'Some Name', if any.
 .EXAMPLE
Get-AtwsInvoice -InvoiceName 'Some Name' -NotEquals InvoiceName
Returns any objects with a InvoiceName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsInvoice -InvoiceName SomeName* -Like InvoiceName
Returns any object with a InvoiceName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsInvoice -InvoiceName SomeName* -NotLike InvoiceName
Returns any object with a InvoiceName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsInvoice -TaxGroup <PickList Label>
Returns any Invoices with property TaxGroup equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsInvoice -TaxGroup <PickList Label> -NotEquals TaxGroup 
Returns any Invoices with property TaxGroup NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsInvoice -TaxGroup <PickList Label1>, <PickList Label2>
Returns any Invoices with property TaxGroup equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsInvoice -TaxGroup <PickList Label1>, <PickList Label2> -NotEquals TaxGroup
Returns any Invoices with property TaxGroup NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsInvoice -Id 1234 -InvoiceName SomeName* -TaxGroup <PickList Label1>, <PickList Label2> -Like InvoiceName -NotEquals TaxGroup -GreaterThan Id
An example of a more complex query. This command returns any Invoices with Id GREATER THAN 1234, a InvoiceName that matches the simple pattern SomeName* AND that has a TaxGroup that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
Set-AtwsInvoice

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
    [ValidateSet('AccountID', 'CreatorResourceID', 'InvoiceEditorTemplateID', 'VoidedByResourceID')]
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
    [ValidateSet('BillingItem:InvoiceID')]
    [string]
    $GetExternalEntityByThisEntityId,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# Invoice ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Client ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $AccountID,

# Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CreatorResourceID,

# Invoice Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $InvoiceDateTime,

# Create Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CreateDateTime,

# Invoice Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $InvoiceNumber,

# Comments
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string[]]
    $Comments,

# Invoice Total
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $InvoiceTotal,

# Total Tax Value
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $TotalTaxValue,

# From Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $FromDate,

# To Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ToDate,

# Order Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,20)]
    [string[]]
    $OrderNumber,

# Payment Term ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Invoice -FieldName PaymentTerm -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Invoice -FieldName PaymentTerm -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $PaymentTerm,

# Web Service Use Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $WebServiceDate,

# Is Voided
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $IsVoided,

# Voided Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $VoidedDate,

# Voided By Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $VoidedByResourceID,

# Paid Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $PaidDate,

# Tax Region Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,200)]
    [string[]]
    $TaxRegionName,

# Batch ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BatchID,

# Invoice Editor Template ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $InvoiceEditorTemplateID,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'CreatorResourceID', 'InvoiceDateTime', 'CreateDateTime', 'InvoiceNumber', 'Comments', 'InvoiceTotal', 'TotalTaxValue', 'FromDate', 'ToDate', 'OrderNumber', 'PaymentTerm', 'WebServiceDate', 'IsVoided', 'VoidedDate', 'VoidedByResourceID', 'PaidDate', 'TaxRegionName', 'BatchID', 'InvoiceEditorTemplateID')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'CreatorResourceID', 'InvoiceDateTime', 'CreateDateTime', 'InvoiceNumber', 'Comments', 'InvoiceTotal', 'TotalTaxValue', 'FromDate', 'ToDate', 'OrderNumber', 'PaymentTerm', 'WebServiceDate', 'IsVoided', 'VoidedDate', 'VoidedByResourceID', 'PaidDate', 'TaxRegionName', 'BatchID', 'InvoiceEditorTemplateID')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'CreatorResourceID', 'InvoiceDateTime', 'CreateDateTime', 'InvoiceNumber', 'Comments', 'InvoiceTotal', 'TotalTaxValue', 'FromDate', 'ToDate', 'OrderNumber', 'PaymentTerm', 'WebServiceDate', 'IsVoided', 'VoidedDate', 'VoidedByResourceID', 'PaidDate', 'TaxRegionName', 'BatchID', 'InvoiceEditorTemplateID')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'CreatorResourceID', 'InvoiceDateTime', 'CreateDateTime', 'InvoiceNumber', 'Comments', 'InvoiceTotal', 'TotalTaxValue', 'FromDate', 'ToDate', 'OrderNumber', 'PaymentTerm', 'WebServiceDate', 'VoidedDate', 'VoidedByResourceID', 'PaidDate', 'TaxRegionName', 'BatchID', 'InvoiceEditorTemplateID')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'CreatorResourceID', 'InvoiceDateTime', 'CreateDateTime', 'InvoiceNumber', 'Comments', 'InvoiceTotal', 'TotalTaxValue', 'FromDate', 'ToDate', 'OrderNumber', 'PaymentTerm', 'WebServiceDate', 'VoidedDate', 'VoidedByResourceID', 'PaidDate', 'TaxRegionName', 'BatchID', 'InvoiceEditorTemplateID')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'CreatorResourceID', 'InvoiceDateTime', 'CreateDateTime', 'InvoiceNumber', 'Comments', 'InvoiceTotal', 'TotalTaxValue', 'FromDate', 'ToDate', 'OrderNumber', 'PaymentTerm', 'WebServiceDate', 'VoidedDate', 'VoidedByResourceID', 'PaidDate', 'TaxRegionName', 'BatchID', 'InvoiceEditorTemplateID')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'CreatorResourceID', 'InvoiceDateTime', 'CreateDateTime', 'InvoiceNumber', 'Comments', 'InvoiceTotal', 'TotalTaxValue', 'FromDate', 'ToDate', 'OrderNumber', 'PaymentTerm', 'WebServiceDate', 'VoidedDate', 'VoidedByResourceID', 'PaidDate', 'TaxRegionName', 'BatchID', 'InvoiceEditorTemplateID')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('InvoiceNumber', 'Comments', 'OrderNumber', 'TaxRegionName')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('InvoiceNumber', 'Comments', 'OrderNumber', 'TaxRegionName')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('InvoiceNumber', 'Comments', 'OrderNumber', 'TaxRegionName')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('InvoiceNumber', 'Comments', 'OrderNumber', 'TaxRegionName')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('InvoiceNumber', 'Comments', 'OrderNumber', 'TaxRegionName')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('InvoiceDateTime', 'CreateDateTime', 'FromDate', 'ToDate', 'WebServiceDate', 'VoidedDate', 'PaidDate')]
    [string[]]
    $IsThisDay
  )

    begin { 
        $entityName = 'Invoice'
    
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
