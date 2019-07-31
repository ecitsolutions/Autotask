#Requires -Version 4.0
#Version 1.6.2.17
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsInvoiceTemplate
{


<#
.SYNOPSIS
This function get one or more InvoiceTemplate through the Autotask Web Services API.
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

GroupBy
 

ItemizeItemsInEachGroup
 

SortBy
 

PageLayout
 

PageNumberFormat
 

DateFormat
 

NumberFormat
 

TimeFormat
 

Entities that have fields that refer to the base entity of this CmdLet:

Account
 Country
 Invoice

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.InvoiceTemplate[]]. This function outputs the Autotask.InvoiceTemplate that was returned by the API.
.EXAMPLE
Get-AtwsInvoiceTemplate -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsInvoiceTemplate -InvoiceTemplateName SomeName
Returns the object with InvoiceTemplateName 'SomeName', if any.
 .EXAMPLE
Get-AtwsInvoiceTemplate -InvoiceTemplateName 'Some Name'
Returns the object with InvoiceTemplateName 'Some Name', if any.
 .EXAMPLE
Get-AtwsInvoiceTemplate -InvoiceTemplateName 'Some Name' -NotEquals InvoiceTemplateName
Returns any objects with a InvoiceTemplateName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsInvoiceTemplate -InvoiceTemplateName SomeName* -Like InvoiceTemplateName
Returns any object with a InvoiceTemplateName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsInvoiceTemplate -InvoiceTemplateName SomeName* -NotLike InvoiceTemplateName
Returns any object with a InvoiceTemplateName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsInvoiceTemplate -GroupBy <PickList Label>
Returns any InvoiceTemplates with property GroupBy equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsInvoiceTemplate -GroupBy <PickList Label> -NotEquals GroupBy 
Returns any InvoiceTemplates with property GroupBy NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsInvoiceTemplate -GroupBy <PickList Label1>, <PickList Label2>
Returns any InvoiceTemplates with property GroupBy equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsInvoiceTemplate -GroupBy <PickList Label1>, <PickList Label2> -NotEquals GroupBy
Returns any InvoiceTemplates with property GroupBy NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsInvoiceTemplate -Id 1234 -InvoiceTemplateName SomeName* -GroupBy <PickList Label1>, <PickList Label2> -Like InvoiceTemplateName -NotEquals GroupBy -GreaterThan Id
An example of a more complex query. This command returns any InvoiceTemplates with Id GREATER THAN 1234, a InvoiceTemplateName that matches the simple pattern SomeName* AND that has a GroupBy that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.


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
    [ValidateSet('PaymentTerms')]
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
    [ValidateSet('Account:InvoiceTemplateID', 'Country:InvoiceTemplateID', 'Invoice:InvoiceEditorTemplateID')]
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

# Invoice Template ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Display Tax Category
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $DisplayTaxCategory,

# Display Tax Category Superscripts
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $DisplayTaxCategorySuperscripts,

# Display Separate Line Item For Each Tax
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $DisplaySeparateLineItemForEachTax,

# Group By
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $GroupBy,

# Itemize Items In Each Group
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $ItemizeItemsInEachGroup,

# Sort By
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $SortBy,

# Itemize Services And Bundles
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $ItemizeServicesAndBundles,

# Display Zero Amount Recurring Services And Bundles
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $DisplayZeroAmountRecurringServicesAndBundles,

# Display Labor Associated With Recurring Service Contracts
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $DisplayRecurringServiceContractLabor,

# Display Labor Associated With Fixed Price Contracts
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $DisplayFixedPriceContractLabor,

# Rate Cost Expression
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $RateCostExpression,

# Covered By Recurring Service Fixed Price Per Ticket Contract Label
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $CoveredByRecurringServiceFixedPricePerTicketContractLabel,

# Covered By Block Retainer Contract Label
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $CoveredByBlockRetainerContractLabel,

# Non Billable Labor Label
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $NonBillableLaborLabel,

# Page Layout
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $PageLayout,

# Payment Terms
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $PaymentTerms,

# Display Page Number Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $PageNumberFormat,

# Date Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $DateFormat,

# Number Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $NumberFormat,

# Time Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $TimeFormat,

# Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,50)]
    [string[]]
    $Name,

# Show Grid Header
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $ShowGridHeader,

# Show Vertical Grid Lines
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $ShowVerticalGridLines,

# Currency Positive Pattern
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,10)]
    [string[]]
    $CurrencyPositiveFormat,

# Currency Negative Pattern
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,10)]
    [string[]]
    $CurrencyNegativeFormat,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'DisplayTaxCategory', 'DisplayTaxCategorySuperscripts', 'DisplaySeparateLineItemForEachTax', 'GroupBy', 'ItemizeItemsInEachGroup', 'SortBy', 'ItemizeServicesAndBundles', 'DisplayZeroAmountRecurringServicesAndBundles', 'DisplayRecurringServiceContractLabor', 'DisplayFixedPriceContractLabor', 'RateCostExpression', 'CoveredByRecurringServiceFixedPricePerTicketContractLabel', 'CoveredByBlockRetainerContractLabel', 'NonBillableLaborLabel', 'PageLayout', 'PaymentTerms', 'PageNumberFormat', 'DateFormat', 'NumberFormat', 'TimeFormat', 'Name', 'ShowGridHeader', 'ShowVerticalGridLines', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'DisplayTaxCategory', 'DisplayTaxCategorySuperscripts', 'DisplaySeparateLineItemForEachTax', 'GroupBy', 'ItemizeItemsInEachGroup', 'SortBy', 'ItemizeServicesAndBundles', 'DisplayZeroAmountRecurringServicesAndBundles', 'DisplayRecurringServiceContractLabor', 'DisplayFixedPriceContractLabor', 'RateCostExpression', 'CoveredByRecurringServiceFixedPricePerTicketContractLabel', 'CoveredByBlockRetainerContractLabel', 'NonBillableLaborLabel', 'PageLayout', 'PaymentTerms', 'PageNumberFormat', 'DateFormat', 'NumberFormat', 'TimeFormat', 'Name', 'ShowGridHeader', 'ShowVerticalGridLines', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'DisplayTaxCategory', 'DisplayTaxCategorySuperscripts', 'DisplaySeparateLineItemForEachTax', 'GroupBy', 'ItemizeItemsInEachGroup', 'SortBy', 'ItemizeServicesAndBundles', 'DisplayZeroAmountRecurringServicesAndBundles', 'DisplayRecurringServiceContractLabor', 'DisplayFixedPriceContractLabor', 'RateCostExpression', 'CoveredByRecurringServiceFixedPricePerTicketContractLabel', 'CoveredByBlockRetainerContractLabel', 'NonBillableLaborLabel', 'PageLayout', 'PaymentTerms', 'PageNumberFormat', 'DateFormat', 'NumberFormat', 'TimeFormat', 'Name', 'ShowGridHeader', 'ShowVerticalGridLines', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'GroupBy', 'ItemizeItemsInEachGroup', 'SortBy', 'RateCostExpression', 'CoveredByRecurringServiceFixedPricePerTicketContractLabel', 'CoveredByBlockRetainerContractLabel', 'NonBillableLaborLabel', 'PageLayout', 'PaymentTerms', 'PageNumberFormat', 'DateFormat', 'NumberFormat', 'TimeFormat', 'Name', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'GroupBy', 'ItemizeItemsInEachGroup', 'SortBy', 'RateCostExpression', 'CoveredByRecurringServiceFixedPricePerTicketContractLabel', 'CoveredByBlockRetainerContractLabel', 'NonBillableLaborLabel', 'PageLayout', 'PaymentTerms', 'PageNumberFormat', 'DateFormat', 'NumberFormat', 'TimeFormat', 'Name', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'GroupBy', 'ItemizeItemsInEachGroup', 'SortBy', 'RateCostExpression', 'CoveredByRecurringServiceFixedPricePerTicketContractLabel', 'CoveredByBlockRetainerContractLabel', 'NonBillableLaborLabel', 'PageLayout', 'PaymentTerms', 'PageNumberFormat', 'DateFormat', 'NumberFormat', 'TimeFormat', 'Name', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'GroupBy', 'ItemizeItemsInEachGroup', 'SortBy', 'RateCostExpression', 'CoveredByRecurringServiceFixedPricePerTicketContractLabel', 'CoveredByBlockRetainerContractLabel', 'NonBillableLaborLabel', 'PageLayout', 'PaymentTerms', 'PageNumberFormat', 'DateFormat', 'NumberFormat', 'TimeFormat', 'Name', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('RateCostExpression', 'CoveredByRecurringServiceFixedPricePerTicketContractLabel', 'CoveredByBlockRetainerContractLabel', 'NonBillableLaborLabel', 'Name', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('RateCostExpression', 'CoveredByRecurringServiceFixedPricePerTicketContractLabel', 'CoveredByBlockRetainerContractLabel', 'NonBillableLaborLabel', 'Name', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('RateCostExpression', 'CoveredByRecurringServiceFixedPricePerTicketContractLabel', 'CoveredByBlockRetainerContractLabel', 'NonBillableLaborLabel', 'Name', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('RateCostExpression', 'CoveredByRecurringServiceFixedPricePerTicketContractLabel', 'CoveredByBlockRetainerContractLabel', 'NonBillableLaborLabel', 'Name', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('RateCostExpression', 'CoveredByRecurringServiceFixedPricePerTicketContractLabel', 'CoveredByBlockRetainerContractLabel', 'NonBillableLaborLabel', 'Name', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $IsThisDay
  )

    begin { 
        $entityName = 'InvoiceTemplate'
    
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
