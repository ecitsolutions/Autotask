#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) Hugo Klemmestad. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsQuoteTemplate
{


<#
.SYNOPSIS
This function get one or more QuoteTemplate through the Autotask Web Services API.
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
DateFormat
DisplayCurrencySymbol
NumberFormat
PageLayout
PageNumberFormat

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.QuoteTemplate[]]. This function outputs the Autotask.QuoteTemplate that was returned by the API.
.EXAMPLE
Get-AtwsQuoteTemplate -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsQuoteTemplate -QuoteTemplateName SomeName
Returns the object with QuoteTemplateName 'SomeName', if any.
 .EXAMPLE
Get-AtwsQuoteTemplate -QuoteTemplateName 'Some Name'
Returns the object with QuoteTemplateName 'Some Name', if any.
 .EXAMPLE
Get-AtwsQuoteTemplate -QuoteTemplateName 'Some Name' -NotEquals QuoteTemplateName
Returns any objects with a QuoteTemplateName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsQuoteTemplate -QuoteTemplateName SomeName* -Like QuoteTemplateName
Returns any object with a QuoteTemplateName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsQuoteTemplate -QuoteTemplateName SomeName* -NotLike QuoteTemplateName
Returns any object with a QuoteTemplateName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsQuoteTemplate -DateFormat 'PickList Label'
Returns any QuoteTemplates with property DateFormat equal to the 'PickList Label'. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsQuoteTemplate -DateFormat 'PickList Label' -NotEquals DateFormat 
Returns any QuoteTemplates with property DateFormat NOT equal to the 'PickList Label'.
 .EXAMPLE
Get-AtwsQuoteTemplate -DateFormat 'PickList Label1', 'PickList Label2'
Returns any QuoteTemplates with property DateFormat equal to EITHER 'PickList Label1' OR 'PickList Label2'.
 .EXAMPLE
Get-AtwsQuoteTemplate -DateFormat 'PickList Label1', 'PickList Label2' -NotEquals DateFormat
Returns any QuoteTemplates with property DateFormat NOT equal to NEITHER 'PickList Label1' NOR 'PickList Label2'.
 .EXAMPLE
Get-AtwsQuoteTemplate -Id 1234 -QuoteTemplateName SomeName* -DateFormat 'PickList Label1', 'PickList Label2' -Like QuoteTemplateName -NotEquals DateFormat -GreaterThan Id
An example of a more complex query. This command returns any QuoteTemplates with Id GREATER THAN 1234, a QuoteTemplateName that matches the simple pattern SomeName* AND that has a DateFormat that is NOT equal to NEITHER 'PickList Label1' NOR 'PickList Label2'.

.NOTES
Related commands:

#>

  [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName='Filter', ConfirmImpact='None',
  HelpURI='https://github.com/ecitsolutions/Autotask/blob/master/Docs/Get-AtwsQuoteTemplate.md')]
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
    [ValidateSet('CreatedBy', 'LastActivityBy')]
    [string]
    $GetReferenceEntityById,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# Active
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $Active,

# Calculate Tax Separately
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $CalculateTaxSeparately,

# Create Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CreateDate,

# Created By
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CreatedBy,

# Currency Negative Pattern
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,10)]
    [string[]]
    $CurrencyNegativeFormat,

# Currency Positive Pattern
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,10)]
    [string[]]
    $CurrencyPositiveFormat,

# Date Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity QuoteTemplate -FieldName DateFormat -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity QuoteTemplate -FieldName DateFormat -Label) + (Get-AtwsPicklistValue -Entity QuoteTemplate -FieldName DateFormat -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $DateFormat,

# Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,200)]
    [string[]]
    $Description,

# Display Tax Category Superscripts
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $DisplayTaxCategorySuperscripts,

# ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Last Activity By
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $LastActivityBy,

# Last Activity Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LastActivityDate,

# Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,50)]
    [string[]]
    $Name,

# Number Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity QuoteTemplate -FieldName NumberFormat -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity QuoteTemplate -FieldName NumberFormat -Label) + (Get-AtwsPicklistValue -Entity QuoteTemplate -FieldName NumberFormat -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $NumberFormat,

# Page Layout
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity QuoteTemplate -FieldName PageLayout -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity QuoteTemplate -FieldName PageLayout -Label) + (Get-AtwsPicklistValue -Entity QuoteTemplate -FieldName PageLayout -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $PageLayout,

# Page Number Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity QuoteTemplate -FieldName PageNumberFormat -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity QuoteTemplate -FieldName PageNumberFormat -Label) + (Get-AtwsPicklistValue -Entity QuoteTemplate -FieldName PageNumberFormat -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $PageNumberFormat,

# Show Each Tax In Group
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $ShowEachTaxInGroup,

# Show Grid Header
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $ShowGridHeader,

# Show Tax Category
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $ShowTaxCategory,

# Show Vertical Grid Lines
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $ShowVerticalGridLines,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Active', 'CalculateTaxSeparately', 'CreateDate', 'CreatedBy', 'CurrencyNegativeFormat', 'CurrencyPositiveFormat', 'DateFormat', 'Description', 'DisplayCurrencySymbol', 'DisplayTaxCategorySuperscripts', 'id', 'LastActivityBy', 'LastActivityDate', 'Name', 'NumberFormat', 'PageLayout', 'PageNumberFormat', 'ShowEachTaxInGroup', 'ShowGridHeader', 'ShowTaxCategory', 'ShowVerticalGridLines')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Active', 'CalculateTaxSeparately', 'CreateDate', 'CreatedBy', 'CurrencyNegativeFormat', 'CurrencyPositiveFormat', 'DateFormat', 'Description', 'DisplayCurrencySymbol', 'DisplayTaxCategorySuperscripts', 'id', 'LastActivityBy', 'LastActivityDate', 'Name', 'NumberFormat', 'PageLayout', 'PageNumberFormat', 'ShowEachTaxInGroup', 'ShowGridHeader', 'ShowTaxCategory', 'ShowVerticalGridLines')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Active', 'CalculateTaxSeparately', 'CreateDate', 'CreatedBy', 'CurrencyNegativeFormat', 'CurrencyPositiveFormat', 'DateFormat', 'Description', 'DisplayCurrencySymbol', 'DisplayTaxCategorySuperscripts', 'id', 'LastActivityBy', 'LastActivityDate', 'Name', 'NumberFormat', 'PageLayout', 'PageNumberFormat', 'ShowEachTaxInGroup', 'ShowGridHeader', 'ShowTaxCategory', 'ShowVerticalGridLines')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'CreatedBy', 'CurrencyNegativeFormat', 'CurrencyPositiveFormat', 'DateFormat', 'Description', 'DisplayCurrencySymbol', 'id', 'LastActivityBy', 'LastActivityDate', 'Name', 'NumberFormat', 'PageLayout', 'PageNumberFormat')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'CreatedBy', 'CurrencyNegativeFormat', 'CurrencyPositiveFormat', 'DateFormat', 'Description', 'DisplayCurrencySymbol', 'id', 'LastActivityBy', 'LastActivityDate', 'Name', 'NumberFormat', 'PageLayout', 'PageNumberFormat')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'CreatedBy', 'CurrencyNegativeFormat', 'CurrencyPositiveFormat', 'DateFormat', 'Description', 'DisplayCurrencySymbol', 'id', 'LastActivityBy', 'LastActivityDate', 'Name', 'NumberFormat', 'PageLayout', 'PageNumberFormat')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'CreatedBy', 'CurrencyNegativeFormat', 'CurrencyPositiveFormat', 'DateFormat', 'Description', 'DisplayCurrencySymbol', 'id', 'LastActivityBy', 'LastActivityDate', 'Name', 'NumberFormat', 'PageLayout', 'PageNumberFormat')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CurrencyNegativeFormat', 'CurrencyPositiveFormat', 'Description', 'Name')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CurrencyNegativeFormat', 'CurrencyPositiveFormat', 'Description', 'Name')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CurrencyNegativeFormat', 'CurrencyPositiveFormat', 'Description', 'Name')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CurrencyNegativeFormat', 'CurrencyPositiveFormat', 'Description', 'Name')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CurrencyNegativeFormat', 'CurrencyPositiveFormat', 'Description', 'Name')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'LastActivityDate')]
    [string[]]
    $IsThisDay
  )

    begin {
        $entityName = 'QuoteTemplate'

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
