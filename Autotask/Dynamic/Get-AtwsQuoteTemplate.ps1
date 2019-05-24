#Requires -Version 4.0
#Version 1.6.2.11
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

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

Additional operators for [String] parameters are:
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

Account
 Country
 Quote

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

  [CmdLetBinding(DefaultParameterSetName='Filter', ConfirmImpact='None')]
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
    [ValidateSet('CreatedBy', 'LastActivityBy')]
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
    [ValidateSet('Account:QuoteTemplateID', 'Country:QuoteTemplateID', 'Quote:QuoteTemplateID')]
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

# ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [long[]]
    $id,

# Active
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean[]]
    $Active,

# Calculate Tax Separately
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean[]]
    $CalculateTaxSeparately,

# Create Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime[]]
    $CreateDate,

# Created By
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $CreatedBy,

# Date Format
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $DateFormat,

# Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,200)]
    [string[]]
    $Description,

# Display Tax Category Superscripts
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean[]]
    $DisplayTaxCategorySuperscripts,

# Last Activity By
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $LastActivityBy,

# Last Activity Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime[]]
    $LastActivityDate,

# Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1,50)]
    [string[]]
    $Name,

# Number Format
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $NumberFormat,

# Page Layout
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $PageLayout,

# Page Number Format
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $PageNumberFormat,

# Show Each Tax In Group
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean[]]
    $ShowEachTaxInGroup,

# Show Grid Header
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean[]]
    $ShowGridHeader,

# Show Tax Category
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean[]]
    $ShowTaxCategory,

# Show Vertical Grid Lines
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean[]]
    $ShowVerticalGridLines,

# Currency Positive Pattern
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1,10)]
    [string[]]
    $CurrencyPositiveFormat,

# Currency Negative Pattern
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1,10)]
    [string[]]
    $CurrencyNegativeFormat,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Active', 'CalculateTaxSeparately', 'CreateDate', 'CreatedBy', 'DateFormat', 'Description', 'DisplayTaxCategorySuperscripts', 'LastActivityBy', 'LastActivityDate', 'Name', 'NumberFormat', 'PageLayout', 'PageNumberFormat', 'ShowEachTaxInGroup', 'ShowGridHeader', 'ShowTaxCategory', 'ShowVerticalGridLines', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Active', 'CalculateTaxSeparately', 'CreateDate', 'CreatedBy', 'DateFormat', 'Description', 'DisplayTaxCategorySuperscripts', 'LastActivityBy', 'LastActivityDate', 'Name', 'NumberFormat', 'PageLayout', 'PageNumberFormat', 'ShowEachTaxInGroup', 'ShowGridHeader', 'ShowTaxCategory', 'ShowVerticalGridLines', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Active', 'CalculateTaxSeparately', 'CreateDate', 'CreatedBy', 'DateFormat', 'Description', 'DisplayTaxCategorySuperscripts', 'LastActivityBy', 'LastActivityDate', 'Name', 'NumberFormat', 'PageLayout', 'PageNumberFormat', 'ShowEachTaxInGroup', 'ShowGridHeader', 'ShowTaxCategory', 'ShowVerticalGridLines', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'CreateDate', 'CreatedBy', 'DateFormat', 'Description', 'LastActivityBy', 'LastActivityDate', 'Name', 'NumberFormat', 'PageLayout', 'PageNumberFormat', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'CreateDate', 'CreatedBy', 'DateFormat', 'Description', 'LastActivityBy', 'LastActivityDate', 'Name', 'NumberFormat', 'PageLayout', 'PageNumberFormat', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'CreateDate', 'CreatedBy', 'DateFormat', 'Description', 'LastActivityBy', 'LastActivityDate', 'Name', 'NumberFormat', 'PageLayout', 'PageNumberFormat', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'CreateDate', 'CreatedBy', 'DateFormat', 'Description', 'LastActivityBy', 'LastActivityDate', 'Name', 'NumberFormat', 'PageLayout', 'PageNumberFormat', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'Name', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'Name', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'Name', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'Name', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'Name', 'CurrencyPositiveFormat', 'CurrencyNegativeFormat')]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'LastActivityDate')]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'QuoteTemplate'
    
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

  End
  {
    Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    If ($Result)
    {
      Return $Result
    }
  }


}
