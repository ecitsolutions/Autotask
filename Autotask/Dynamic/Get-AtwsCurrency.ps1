#Requires -Version 4.0
#Version 1.6.2.11
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

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

Additional operators for [String] parameters are:
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

  [CmdLetBinding(SupportsShouldProcess = $True, DefaultParameterSetName='Filter', ConfirmImpact='None')]
  Param
  (
# A filter that limits the number of objects that is returned from the API
    [Parameter(
      Mandatory = $true,
      ValueFromRemainingArguments = $true,
      ParameterSetName = 'Filter'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $Filter,

# Follow this external ID and return any external objects
    [Parameter(
      ParameterSetName = 'Filter'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Alias('GetRef')]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('UpdateResourceId')]
    [String]
    $GetReferenceEntityById,

# Return entities of selected type that are referencing to this entity.
    [Parameter(
      ParameterSetName = 'Filter'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Alias('External')]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('Account:CurrencyID', 'ExpenseItem:ExpenseCurrencyID', 'ExpenseReport:ReimbursementCurrencyID', 'PriceListMaterialCode:CurrencyID', 'PriceListProduct:CurrencyID', 'PriceListRole:CurrencyID', 'PriceListService:CurrencyID', 'PriceListServiceBundle:CurrencyID', 'PriceListWorkTypeModifier:CurrencyID')]
    [String]
    $GetExternalEntityByThisEntityId,

# Return all objects in one query
    [Parameter(
      ParameterSetName = 'Get_all'
    )]
    [Switch]
    $All,

# Do not add descriptions for all picklist attributes with values
    [Parameter(
      ParameterSetName = 'Filter'
    )]
    [Parameter(
      ParameterSetName = 'Get_all'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Switch]
    $NoPickListLabel,

# Currency ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Currency Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,3)]
    [string[]]
    $Name,

# Currency Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [string[]]
    $Description,

# Display Symbol
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $DisplaySymbol,

# Exchange Rate
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[decimal][]]
    $ExchangeRate,

# Last Modified Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LastModifiedDateTime,

# Update Resource ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $UpdateResourceId,

# Is Internal Currency
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $IsInternalCurrency,

# Active
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $Active,

# Currency Positive Format
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,10)]
    [string[]]
    $CurrencyPositiveFormat,

# Currency Negative Format
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,10)]
    [string[]]
    $CurrencyNegativeFormat,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'DisplaySymbol', 'ExchangeRate', 'LastModifiedDateTime', 'UpdateResourceId', 'IsInternalCurrency', 'Active', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'DisplaySymbol', 'ExchangeRate', 'LastModifiedDateTime', 'UpdateResourceId', 'IsInternalCurrency', 'Active', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'DisplaySymbol', 'ExchangeRate', 'LastModifiedDateTime', 'UpdateResourceId', 'IsInternalCurrency', 'Active', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'DisplaySymbol', 'ExchangeRate', 'LastModifiedDateTime', 'UpdateResourceId', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'DisplaySymbol', 'ExchangeRate', 'LastModifiedDateTime', 'UpdateResourceId', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'DisplaySymbol', 'ExchangeRate', 'LastModifiedDateTime', 'UpdateResourceId', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'DisplaySymbol', 'ExchangeRate', 'LastModifiedDateTime', 'UpdateResourceId', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('LastModifiedDateTime')]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'Currency'
    
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
  }


  Process
  {
    If ($PSCmdlet.ParameterSetName -eq 'Get_all')
    { 
      $Filter = @('id', '-ge', 0)
    }
    ElseIf (-not ($Filter)) {
    
      Write-Debug ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)
      
      # Convert named parameters to a filter definition that can be parsed to QueryXML
      $Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $EntityName
    }
    Else {
      
      Write-Debug ('{0}: Query based on manual filter, parsing' -F $MyInvocation.MyCommand.Name)
              
      $Filter = . Update-AtwsFilter -FilterString $Filter
    } 

    $Caption = $MyInvocation.MyCommand.Name
    $VerboseDescrition = '{0}: About to query the Autotask Web API for {1}(s).' -F $Caption, $EntityName
    $VerboseWarning = '{0}: About to query the Autotask Web API for {1}(s). Do you want to continue?' -F $Caption, $EntityName
    
    If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
      $Result = Get-AtwsData -Entity $EntityName -Filter $Filter
    

      Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $Result.Count)
    
      # Datetimeparameters
      $Fields = Get-AtwsFieldInfo -Entity $EntityName
    
      # Should we return an indirect object?
      if ( ($Result) -and ($GetReferenceEntityById))
      {
        Write-Debug ('{0}: User has asked for external reference objects by {1}' -F $MyInvocation.MyCommand.Name, $GetReferenceEntityById)
      
        $Field = $Fields.Where({$_.Name -eq $GetReferenceEntityById})
        $ResultValues = $Result | Where-Object {$null -ne $_.$GetReferenceEntityById}
        If ($ResultValues.Count -lt $Result.Count)
        {
          Write-Warning ('{0}: Only {1} of the {2}s in the primary query had a value in the property {3}.' -F $MyInvocation.MyCommand.Name, 
            $ResultValues.Count,
            $EntityName,
          $GetReferenceEntityById) -WarningAction Continue
        }
        $Filter = 'id -eq {0}' -F $($ResultValues.$GetReferenceEntityById -join ' -or id -eq ')
        $Result = Get-Atwsdata -Entity $Field.ReferenceEntityType -Filter $Filter
      }
      ElseIf ( ($Result) -and ($GetExternalEntityByThisEntityId))
      {
        Write-Debug ('{0}: User has asked for {1} that are referencing this result' -F $MyInvocation.MyCommand.Name, $GetExternalEntityByThisEntityId)
        $ReferenceInfo = $GetExternalEntityByThisEntityId -Split ':'
        $Filter = '{0} -eq {1}' -F $ReferenceInfo[1], $($Result.id -join (' -or {0}id -eq ' -F $ReferenceInfo[1]))
        $Result = Get-Atwsdata -Entity $ReferenceInfo[0] -Filter $Filter
      }
      # Do the user want labels along with index values for Picklists?
      ElseIf ( ($Result) -and -not ($NoPickListLabel))
      {
        Foreach ($Field in $Fields.Where{$_.IsPickList})
        {
          $FieldName = '{0}Label' -F $Field.Name
          Foreach ($Item in $Result)
          {
            $Value = ($Field.PickListValues.Where{$_.Value -eq $Item.$($Field.Name)}).Label
            Add-Member -InputObject $Item -MemberType NoteProperty -Name $FieldName -Value $Value -Force
          
          }
        }
      }
    }
  }

  End
  {
    Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    If ($Result)
    {
      Return $Result
    }
  }


}
