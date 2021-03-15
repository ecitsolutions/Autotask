#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
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
    [Collections.Generic.List[string]]
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

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# Covered By Block Retainer Contract Label
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [Collections.Generic.List[string]]
    $CoveredByBlockRetainerContractLabel,

# Covered By Recurring Service Fixed Price Per Ticket Contract Label
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [Collections.Generic.List[string]]
    $CoveredByRecurringServiceFixedPricePerTicketContractLabel,

# Currency Negative Pattern
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,10)]
    [Collections.Generic.List[string]]
    $CurrencyNegativeFormat,

# Currency Positive Pattern
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,10)]
    [Collections.Generic.List[string]]
    $CurrencyPositiveFormat,

# Date Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InvoiceTemplate -FieldName DateFormat -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InvoiceTemplate -FieldName DateFormat -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $DateFormat,

# Display Labor Associated With Fixed Price Contracts
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[boolean]]]
    $DisplayFixedPriceContractLabor,

# Display Labor Associated With Recurring Service Contracts
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[boolean]]]
    $DisplayRecurringServiceContractLabor,

# Display Separate Line Item For Each Tax
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[boolean]]]
    $DisplaySeparateLineItemForEachTax,

# Display Tax Category
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[boolean]]]
    $DisplayTaxCategory,

# Display Tax Category Superscripts
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[boolean]]]
    $DisplayTaxCategorySuperscripts,

# Display Zero Amount Recurring Services And Bundles
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[boolean]]]
    $DisplayZeroAmountRecurringServicesAndBundles,

# Group By
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InvoiceTemplate -FieldName GroupBy -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InvoiceTemplate -FieldName GroupBy -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $GroupBy,

# Invoice Template ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[long]]]
    $id,

# Itemize Items In Each Group
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InvoiceTemplate -FieldName ItemizeItemsInEachGroup -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InvoiceTemplate -FieldName ItemizeItemsInEachGroup -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $ItemizeItemsInEachGroup,

# Itemize Services And Bundles
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[boolean]]]
    $ItemizeServicesAndBundles,

# Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,50)]
    [Collections.Generic.List[string]]
    $Name,

# Non Billable Labor Label
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [Collections.Generic.List[string]]
    $NonBillableLaborLabel,

# Number Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InvoiceTemplate -FieldName NumberFormat -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InvoiceTemplate -FieldName NumberFormat -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $NumberFormat,

# Page Layout
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InvoiceTemplate -FieldName PageLayout -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InvoiceTemplate -FieldName PageLayout -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $PageLayout,

# Display Page Number Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InvoiceTemplate -FieldName PageNumberFormat -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InvoiceTemplate -FieldName PageNumberFormat -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $PageNumberFormat,

# Payment Terms
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[Int]]]
    $PaymentTerms,

# Rate Cost Expression
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [Collections.Generic.List[string]]
    $RateCostExpression,

# Show Grid Header
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[boolean]]]
    $ShowGridHeader,

# Show Vertical Grid Lines
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[boolean]]]
    $ShowVerticalGridLines,

# Sort By
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InvoiceTemplate -FieldName SortBy -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InvoiceTemplate -FieldName SortBy -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $SortBy,

# Time Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InvoiceTemplate -FieldName TimeFormat -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InvoiceTemplate -FieldName TimeFormat -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $TimeFormat,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('RateCostExpression', 'CurrencyNegativeFormat', 'Name', 'TimeFormat', 'PageNumberFormat', 'id', 'DisplayTaxCategorySuperscripts', 'ItemizeServicesAndBundles', 'ShowGridHeader', 'ItemizeItemsInEachGroup', 'CoveredByBlockRetainerContractLabel', 'ShowVerticalGridLines', 'DisplayZeroAmountRecurringServicesAndBundles', 'CurrencyPositiveFormat', 'GroupBy', 'PageLayout', 'DisplayRecurringServiceContractLabor', 'DisplayTaxCategory', 'DateFormat', 'SortBy', 'DisplayFixedPriceContractLabor', 'NumberFormat', 'PaymentTerms', 'DisplaySeparateLineItemForEachTax', 'NonBillableLaborLabel', 'CoveredByRecurringServiceFixedPricePerTicketContractLabel')]
    [Collections.Generic.List[string]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('RateCostExpression', 'CurrencyNegativeFormat', 'Name', 'TimeFormat', 'PageNumberFormat', 'id', 'DisplayTaxCategorySuperscripts', 'ItemizeServicesAndBundles', 'ShowGridHeader', 'ItemizeItemsInEachGroup', 'CoveredByBlockRetainerContractLabel', 'ShowVerticalGridLines', 'DisplayZeroAmountRecurringServicesAndBundles', 'CurrencyPositiveFormat', 'GroupBy', 'PageLayout', 'DisplayRecurringServiceContractLabor', 'DisplayTaxCategory', 'DateFormat', 'SortBy', 'DisplayFixedPriceContractLabor', 'NumberFormat', 'PaymentTerms', 'DisplaySeparateLineItemForEachTax', 'NonBillableLaborLabel', 'CoveredByRecurringServiceFixedPricePerTicketContractLabel')]
    [Collections.Generic.List[string]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('RateCostExpression', 'CurrencyNegativeFormat', 'Name', 'TimeFormat', 'PageNumberFormat', 'id', 'DisplayTaxCategorySuperscripts', 'ItemizeServicesAndBundles', 'ShowGridHeader', 'ItemizeItemsInEachGroup', 'CoveredByBlockRetainerContractLabel', 'ShowVerticalGridLines', 'DisplayZeroAmountRecurringServicesAndBundles', 'CurrencyPositiveFormat', 'GroupBy', 'PageLayout', 'DisplayRecurringServiceContractLabor', 'DisplayTaxCategory', 'DateFormat', 'SortBy', 'DisplayFixedPriceContractLabor', 'NumberFormat', 'PaymentTerms', 'DisplaySeparateLineItemForEachTax', 'NonBillableLaborLabel', 'CoveredByRecurringServiceFixedPricePerTicketContractLabel')]
    [Collections.Generic.List[string]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'GroupBy', 'ItemizeItemsInEachGroup', 'SortBy', 'RateCostExpression', 'CoveredByRecurringServiceFixedPricePerTicketContractLabel', 'CoveredByBlockRetainerContractLabel', 'NonBillableLaborLabel', 'PageLayout', 'PaymentTerms', 'PageNumberFormat', 'DateFormat', 'NumberFormat', 'TimeFormat', 'Name', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [Collections.Generic.List[string]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'GroupBy', 'ItemizeItemsInEachGroup', 'SortBy', 'RateCostExpression', 'CoveredByRecurringServiceFixedPricePerTicketContractLabel', 'CoveredByBlockRetainerContractLabel', 'NonBillableLaborLabel', 'PageLayout', 'PaymentTerms', 'PageNumberFormat', 'DateFormat', 'NumberFormat', 'TimeFormat', 'Name', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [Collections.Generic.List[string]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'GroupBy', 'ItemizeItemsInEachGroup', 'SortBy', 'RateCostExpression', 'CoveredByRecurringServiceFixedPricePerTicketContractLabel', 'CoveredByBlockRetainerContractLabel', 'NonBillableLaborLabel', 'PageLayout', 'PaymentTerms', 'PageNumberFormat', 'DateFormat', 'NumberFormat', 'TimeFormat', 'Name', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [Collections.Generic.List[string]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'GroupBy', 'ItemizeItemsInEachGroup', 'SortBy', 'RateCostExpression', 'CoveredByRecurringServiceFixedPricePerTicketContractLabel', 'CoveredByBlockRetainerContractLabel', 'NonBillableLaborLabel', 'PageLayout', 'PaymentTerms', 'PageNumberFormat', 'DateFormat', 'NumberFormat', 'TimeFormat', 'Name', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [Collections.Generic.List[string]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('RateCostExpression', 'CoveredByRecurringServiceFixedPricePerTicketContractLabel', 'CoveredByBlockRetainerContractLabel', 'NonBillableLaborLabel', 'Name', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [Collections.Generic.List[string]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('RateCostExpression', 'CoveredByRecurringServiceFixedPricePerTicketContractLabel', 'CoveredByBlockRetainerContractLabel', 'NonBillableLaborLabel', 'Name', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [Collections.Generic.List[string]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('RateCostExpression', 'CoveredByRecurringServiceFixedPricePerTicketContractLabel', 'CoveredByBlockRetainerContractLabel', 'NonBillableLaborLabel', 'Name', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [Collections.Generic.List[string]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('RateCostExpression', 'CoveredByRecurringServiceFixedPricePerTicketContractLabel', 'CoveredByBlockRetainerContractLabel', 'NonBillableLaborLabel', 'Name', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [Collections.Generic.List[string]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('RateCostExpression', 'CoveredByRecurringServiceFixedPricePerTicketContractLabel', 'CoveredByBlockRetainerContractLabel', 'NonBillableLaborLabel', 'Name', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [Collections.Generic.List[string]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[string]]
    $IsThisDay
  )

    begin {
        $entityName = 'InvoiceTemplate'

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

           
            # Count the values of the first parameter passed. We will not try do to this on more than 1 parameter, nor on any 
            # other parameter than the first. This is lazy, but efficient.
            $count = $PSBoundParameters.Values[0].count

            # If the count is less than or equal to 200 we pass PSBoundParameters as is
            if ($count -le 200) {
                [collections.generic.list[string]]$Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $entityName
                $iterations.Add($Filter)
            }
            # More than 200 values. This will cause a SQL query nested too much. Break a single parameter
            # into segments and create multiple queries with max 200 values
            else {
                # Deduplicate the value list or the same ID may be included in more than 1 query
                $outerLoop = $PSBoundParameters.Values[0] | Sort-Object -Unique

                Write-Verbose ('{0}: Received {1} objects containing {2} unique values for parameter {3}' -f $MyInvocation.MyCommand.Name, $count, $outerLoop.Count, $param)

                # Make a writable copy of PSBoundParameters
                $BoundParameters = $PSBoundParameters
                for ($i = 0; $i -lt $outerLoop.count; $i += 200) {
                    $j = $i + 199
                    if ($j -ge $outerLoop.count) {
                        $j = $outerLoop.count - 1
                    }

                    # make a selection
                    $BoundParameters[$param] = $outerLoop[$i .. $j]

                    Write-Verbose ('{0}: Asking for {1} values {2} to {3}' -f $MyInvocation.MyCommand.Name, $param, $i, $j)

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
                    write-host "ERROR: " -ForegroundColor Red -NoNewline
                    write-host $_.Exception.Message
                    write-host ("{0}: {1}" -f $_.CategoryInfo.Category,$_.CategoryInfo.Reason) -ForegroundColor Cyan
                    $_.ScriptStackTrace -split '\n' | ForEach-Object {
                        Write-host "  |  " -ForegroundColor Cyan -NoNewline
                        Write-host $_
                    }
                }
                # Add response to result
                $result.AddRange($response)

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