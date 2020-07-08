#Requires -Version 4.0
#Version 1.6.8
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsCurrency
{


<#
.SYNOPSIS
This function get one or more Currency through the Autotask Web Services API.
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

DisplaySymbol
 

Entities that have fields that refer to the base entity of this CmdLet:

Account
 ExpenseItem
 ExpenseReport
 PriceListMaterialCode
 PriceListProduct
 PriceListProductTier
 PriceListRole
 PriceListService
 PriceListServiceBundle
 PriceListWorkTypeModifier

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Currency[]]. This function outputs the Autotask.Currency that was returned by the API.
.EXAMPLE
Get-AtwsCurrency -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsCurrency -CurrencyName SomeName
Returns the object with CurrencyName 'SomeName', if any.
 .EXAMPLE
Get-AtwsCurrency -CurrencyName 'Some Name'
Returns the object with CurrencyName 'Some Name', if any.
 .EXAMPLE
Get-AtwsCurrency -CurrencyName 'Some Name' -NotEquals CurrencyName
Returns any objects with a CurrencyName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsCurrency -CurrencyName SomeName* -Like CurrencyName
Returns any object with a CurrencyName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsCurrency -CurrencyName SomeName* -NotLike CurrencyName
Returns any object with a CurrencyName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsCurrency -D <PickList Label>
Returns any Currencys with property D equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsCurrency -D <PickList Label> -NotEquals D 
Returns any Currencys with property D NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsCurrency -D <PickList Label1>, <PickList Label2>
Returns any Currencys with property D equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsCurrency -D <PickList Label1>, <PickList Label2> -NotEquals D
Returns any Currencys with property D NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsCurrency -Id 1234 -CurrencyName SomeName* -D <PickList Label1>, <PickList Label2> -Like CurrencyName -NotEquals D -GreaterThan Id
An example of a more complex query. This command returns any Currencys with Id GREATER THAN 1234, a CurrencyName that matches the simple pattern SomeName* AND that has a D that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
Set-AtwsCurrency

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
    [ValidateSet('UpdateResourceId')]
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
    [ValidateSet('Account:CurrencyID', 'ExpenseItem:ExpenseCurrencyID', 'ExpenseReport:ReimbursementCurrencyID', 'PriceListMaterialCode:CurrencyID', 'PriceListProduct:CurrencyID', 'PriceListProductTier:CurrencyID', 'PriceListRole:CurrencyID', 'PriceListService:CurrencyID', 'PriceListServiceBundle:CurrencyID', 'PriceListWorkTypeModifier:CurrencyID')]
    [string]
    $GetExternalEntityByThisEntityId,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# Currency ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Currency Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,3)]
    [string[]]
    $Name,

# Currency Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [string[]]
    $Description,

# Display Symbol
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $DisplaySymbol,

# Exchange Rate
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[decimal][]]
    $ExchangeRate,

# Last Modified Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LastModifiedDateTime,

# Update Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $UpdateResourceId,

# Is Internal Currency
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $IsInternalCurrency,

# Active
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $Active,

# Currency Positive Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,10)]
    [string[]]
    $CurrencyPositiveFormat,

# Currency Negative Format
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
    [ValidateSet('id', 'Name', 'Description', 'DisplaySymbol', 'ExchangeRate', 'LastModifiedDateTime', 'UpdateResourceId', 'IsInternalCurrency', 'Active', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'DisplaySymbol', 'ExchangeRate', 'LastModifiedDateTime', 'UpdateResourceId', 'IsInternalCurrency', 'Active', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'DisplaySymbol', 'ExchangeRate', 'LastModifiedDateTime', 'UpdateResourceId', 'IsInternalCurrency', 'Active', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'DisplaySymbol', 'ExchangeRate', 'LastModifiedDateTime', 'UpdateResourceId', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'DisplaySymbol', 'ExchangeRate', 'LastModifiedDateTime', 'UpdateResourceId', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'DisplaySymbol', 'ExchangeRate', 'LastModifiedDateTime', 'UpdateResourceId', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'DisplaySymbol', 'ExchangeRate', 'LastModifiedDateTime', 'UpdateResourceId', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('LastModifiedDateTime')]
    [string[]]
    $IsThisDay
  )

    begin { 
        $entityName = 'Currency'
    
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
