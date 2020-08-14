#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
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
Get-AtwsQuoteTemplate -DateFormat <PickList Label>
Returns any QuoteTemplates with property DateFormat equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsQuoteTemplate -DateFormat <PickList Label> -NotEquals DateFormat 
Returns any QuoteTemplates with property DateFormat NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsQuoteTemplate -DateFormat <PickList Label1>, <PickList Label2>
Returns any QuoteTemplates with property DateFormat equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsQuoteTemplate -DateFormat <PickList Label1>, <PickList Label2> -NotEquals DateFormat
Returns any QuoteTemplates with property DateFormat NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsQuoteTemplate -Id 1234 -QuoteTemplateName SomeName* -DateFormat <PickList Label1>, <PickList Label2> -Like QuoteTemplateName -NotEquals DateFormat -GreaterThan Id
An example of a more complex query. This command returns any QuoteTemplates with Id GREATER THAN 1234, a QuoteTemplateName that matches the simple pattern SomeName* AND that has a DateFormat that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.


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
      Get-AtwsPicklistValue -Entity QuoteTemplate -FieldName DateFormat -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity QuoteTemplate -FieldName DateFormat -Label
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
      Get-AtwsPicklistValue -Entity QuoteTemplate -FieldName NumberFormat -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity QuoteTemplate -FieldName NumberFormat -Label
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
      Get-AtwsPicklistValue -Entity QuoteTemplate -FieldName PageLayout -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity QuoteTemplate -FieldName PageLayout -Label
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
      Get-AtwsPicklistValue -Entity QuoteTemplate -FieldName PageNumberFormat -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity QuoteTemplate -FieldName PageNumberFormat -Label
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
    [ValidateSet('Name', 'CreateDate', 'CreatedBy', 'DateFormat', 'ShowGridHeader', 'LastActivityDate', 'ShowEachTaxInGroup', 'Description', 'NumberFormat', 'Active', 'ShowVerticalGridLines', 'CurrencyPositiveFormat', 'LastActivityBy', 'CalculateTaxSeparately', 'CurrencyNegativeFormat', 'ShowTaxCategory', 'PageLayout', 'DisplayCurrencySymbol', 'id', 'PageNumberFormat', 'DisplayTaxCategorySuperscripts')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'CreateDate', 'CreatedBy', 'DateFormat', 'ShowGridHeader', 'LastActivityDate', 'ShowEachTaxInGroup', 'Description', 'NumberFormat', 'Active', 'ShowVerticalGridLines', 'CurrencyPositiveFormat', 'LastActivityBy', 'CalculateTaxSeparately', 'CurrencyNegativeFormat', 'ShowTaxCategory', 'PageLayout', 'DisplayCurrencySymbol', 'id', 'PageNumberFormat', 'DisplayTaxCategorySuperscripts')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'CreateDate', 'CreatedBy', 'DateFormat', 'ShowGridHeader', 'LastActivityDate', 'ShowEachTaxInGroup', 'Description', 'NumberFormat', 'Active', 'ShowVerticalGridLines', 'CurrencyPositiveFormat', 'LastActivityBy', 'CalculateTaxSeparately', 'CurrencyNegativeFormat', 'ShowTaxCategory', 'PageLayout', 'DisplayCurrencySymbol', 'id', 'PageNumberFormat', 'DisplayTaxCategorySuperscripts')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'CreateDate', 'CreatedBy', 'DateFormat', 'Description', 'DisplayCurrencySymbol', 'LastActivityBy', 'LastActivityDate', 'Name', 'NumberFormat', 'PageLayout', 'PageNumberFormat', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'CreateDate', 'CreatedBy', 'DateFormat', 'Description', 'DisplayCurrencySymbol', 'LastActivityBy', 'LastActivityDate', 'Name', 'NumberFormat', 'PageLayout', 'PageNumberFormat', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'CreateDate', 'CreatedBy', 'DateFormat', 'Description', 'DisplayCurrencySymbol', 'LastActivityBy', 'LastActivityDate', 'Name', 'NumberFormat', 'PageLayout', 'PageNumberFormat', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'CreateDate', 'CreatedBy', 'DateFormat', 'Description', 'DisplayCurrencySymbol', 'LastActivityBy', 'LastActivityDate', 'Name', 'NumberFormat', 'PageLayout', 'PageNumberFormat', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'Name', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'Name', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'Name', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'Name', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'Name', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
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
