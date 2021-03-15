#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsQuoteItem
{


<#
.SYNOPSIS
This function get one or more QuoteItem through the Autotask Web Services API.
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
Type
PeriodType

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.QuoteItem[]]. This function outputs the Autotask.QuoteItem that was returned by the API.
.EXAMPLE
Get-AtwsQuoteItem -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsQuoteItem -QuoteItemName SomeName
Returns the object with QuoteItemName 'SomeName', if any.
 .EXAMPLE
Get-AtwsQuoteItem -QuoteItemName 'Some Name'
Returns the object with QuoteItemName 'Some Name', if any.
 .EXAMPLE
Get-AtwsQuoteItem -QuoteItemName 'Some Name' -NotEquals QuoteItemName
Returns any objects with a QuoteItemName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsQuoteItem -QuoteItemName SomeName* -Like QuoteItemName
Returns any object with a QuoteItemName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsQuoteItem -QuoteItemName SomeName* -NotLike QuoteItemName
Returns any object with a QuoteItemName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsQuoteItem -Type <PickList Label>
Returns any QuoteItems with property Type equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsQuoteItem -Type <PickList Label> -NotEquals Type 
Returns any QuoteItems with property Type NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsQuoteItem -Type <PickList Label1>, <PickList Label2>
Returns any QuoteItems with property Type equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsQuoteItem -Type <PickList Label1>, <PickList Label2> -NotEquals Type
Returns any QuoteItems with property Type NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsQuoteItem -Id 1234 -QuoteItemName SomeName* -Type <PickList Label1>, <PickList Label2> -Like QuoteItemName -NotEquals Type -GreaterThan Id
An example of a more complex query. This command returns any QuoteItems with Id GREATER THAN 1234, a QuoteItemName that matches the simple pattern SomeName* AND that has a Type that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsQuoteItem
 .LINK
Remove-AtwsQuoteItem
 .LINK
Set-AtwsQuoteItem

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
    [ValidateSet('CostID', 'ExpenseID', 'LaborID', 'ProductID', 'QuoteID', 'ServiceBundleID', 'ServiceID', 'ShippingID', 'TaxCategoryID')]
    [string]
    $GetReferenceEntityById,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# cost_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $CostID,

# quote_item_description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [Collections.Generic.List[string]]
    $Description,

# expense_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $ExpenseID,

# quote_item_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[long]]]
    $id,

# internal_currency_line_discount_dollars
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $InternalCurrencyLineDiscount,

# internal_currency_discount_dollars
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $InternalCurrencyUnitDiscount,

# internal_currency_unit_price
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $InternalCurrencyUnitPrice,

# optional
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[boolean]]]
    $IsOptional,

# taxable
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[boolean]]]
    $IsTaxable,

# labor_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $LaborID,

# line_discount_dollars
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[double]]]
    $LineDiscount,

# markup_rate
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $MarkupRate,

# quote_item_name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [Collections.Generic.List[string]]
    $Name,

# discount_percent
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[double]]]
    $PercentageDiscount,

# period_type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity QuoteItem -FieldName PeriodType -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity QuoteItem -FieldName PeriodType -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $PeriodType,

# product_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $ProductID,

# quantity
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[double]]]
    $Quantity,

# quote_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[Int]]]
    $QuoteID,

# service_bundle_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $ServiceBundleID,

# service_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $ServiceID,

# shipping_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $ShippingID,

# sort_order
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $SortOrderID,

# tax_category_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $TaxCategoryID,

# tax_rate_applied
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $TotalEffectiveTax,

# parent_type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity QuoteItem -FieldName Type -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity QuoteItem -FieldName Type -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $Type,

# unit_cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $UnitCost,

# discount_dollars
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[double]]]
    $UnitDiscount,

# unit_price
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $UnitPrice,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('IsTaxable', 'LineDiscount', 'PercentageDiscount', 'ServiceID', 'InternalCurrencyUnitDiscount', 'HighestCost', 'IsOptional', 'AverageCost', 'id', 'MarkupRate', 'PeriodType', 'LaborID', 'TotalEffectiveTax', 'TaxCategoryID', 'ProductID', 'ShippingID', 'QuoteID', 'Quantity', 'UnitDiscount', 'UnitCost', 'InternalCurrencyLineDiscount', 'InternalCurrencyUnitPrice', 'ExpenseID', 'SortOrderID', 'Type', 'Name', 'CostID', 'Description', 'UnitPrice', 'ServiceBundleID')]
    [Collections.Generic.List[string]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('IsTaxable', 'LineDiscount', 'PercentageDiscount', 'ServiceID', 'InternalCurrencyUnitDiscount', 'HighestCost', 'IsOptional', 'AverageCost', 'id', 'MarkupRate', 'PeriodType', 'LaborID', 'TotalEffectiveTax', 'TaxCategoryID', 'ProductID', 'ShippingID', 'QuoteID', 'Quantity', 'UnitDiscount', 'UnitCost', 'InternalCurrencyLineDiscount', 'InternalCurrencyUnitPrice', 'ExpenseID', 'SortOrderID', 'Type', 'Name', 'CostID', 'Description', 'UnitPrice', 'ServiceBundleID')]
    [Collections.Generic.List[string]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('IsTaxable', 'LineDiscount', 'PercentageDiscount', 'ServiceID', 'InternalCurrencyUnitDiscount', 'HighestCost', 'IsOptional', 'AverageCost', 'id', 'MarkupRate', 'PeriodType', 'LaborID', 'TotalEffectiveTax', 'TaxCategoryID', 'ProductID', 'ShippingID', 'QuoteID', 'Quantity', 'UnitDiscount', 'UnitCost', 'InternalCurrencyLineDiscount', 'InternalCurrencyUnitPrice', 'ExpenseID', 'SortOrderID', 'Type', 'Name', 'CostID', 'Description', 'UnitPrice', 'ServiceBundleID')]
    [Collections.Generic.List[string]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('QuoteID', 'id', 'Type', 'ProductID', 'CostID', 'LaborID', 'ExpenseID', 'ShippingID', 'ServiceID', 'ServiceBundleID', 'Name', 'UnitPrice', 'UnitCost', 'Quantity', 'UnitDiscount', 'PercentageDiscount', 'PeriodType', 'SortOrderID', 'Description', 'LineDiscount', 'AverageCost', 'HighestCost', 'TaxCategoryID', 'TotalEffectiveTax', 'MarkupRate', 'InternalCurrencyUnitPrice', 'InternalCurrencyUnitDiscount', 'InternalCurrencyLineDiscount')]
    [Collections.Generic.List[string]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('QuoteID', 'id', 'Type', 'ProductID', 'CostID', 'LaborID', 'ExpenseID', 'ShippingID', 'ServiceID', 'ServiceBundleID', 'Name', 'UnitPrice', 'UnitCost', 'Quantity', 'UnitDiscount', 'PercentageDiscount', 'PeriodType', 'SortOrderID', 'Description', 'LineDiscount', 'AverageCost', 'HighestCost', 'TaxCategoryID', 'TotalEffectiveTax', 'MarkupRate', 'InternalCurrencyUnitPrice', 'InternalCurrencyUnitDiscount', 'InternalCurrencyLineDiscount')]
    [Collections.Generic.List[string]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('QuoteID', 'id', 'Type', 'ProductID', 'CostID', 'LaborID', 'ExpenseID', 'ShippingID', 'ServiceID', 'ServiceBundleID', 'Name', 'UnitPrice', 'UnitCost', 'Quantity', 'UnitDiscount', 'PercentageDiscount', 'PeriodType', 'SortOrderID', 'Description', 'LineDiscount', 'AverageCost', 'HighestCost', 'TaxCategoryID', 'TotalEffectiveTax', 'MarkupRate', 'InternalCurrencyUnitPrice', 'InternalCurrencyUnitDiscount', 'InternalCurrencyLineDiscount')]
    [Collections.Generic.List[string]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('QuoteID', 'id', 'Type', 'ProductID', 'CostID', 'LaborID', 'ExpenseID', 'ShippingID', 'ServiceID', 'ServiceBundleID', 'Name', 'UnitPrice', 'UnitCost', 'Quantity', 'UnitDiscount', 'PercentageDiscount', 'PeriodType', 'SortOrderID', 'Description', 'LineDiscount', 'AverageCost', 'HighestCost', 'TaxCategoryID', 'TotalEffectiveTax', 'MarkupRate', 'InternalCurrencyUnitPrice', 'InternalCurrencyUnitDiscount', 'InternalCurrencyLineDiscount')]
    [Collections.Generic.List[string]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'PeriodType', 'Description')]
    [Collections.Generic.List[string]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'PeriodType', 'Description')]
    [Collections.Generic.List[string]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'PeriodType', 'Description')]
    [Collections.Generic.List[string]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'PeriodType', 'Description')]
    [Collections.Generic.List[string]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'PeriodType', 'Description')]
    [Collections.Generic.List[string]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[string]]
    $IsThisDay
  )

    begin {
        $entityName = 'QuoteItem'

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
