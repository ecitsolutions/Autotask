#Requires -Version 4.0
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-Currency
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
Get-Currency -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-Currency -CurrencyName SomeName
Returns the object with CurrencyName 'SomeName', if any.
 .EXAMPLE
Get-Currency -CurrencyName 'Some Name'
Returns the object with CurrencyName 'Some Name', if any.
 .EXAMPLE
Get-Currency -CurrencyName 'Some Name' -NotEquals CurrencyName
Returns any objects with a CurrencyName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-Currency -CurrencyName SomeName* -Like CurrencyName
Returns any object with a CurrencyName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-Currency -CurrencyName SomeName* -NotLike CurrencyName
Returns any object with a CurrencyName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-Currency -D <PickList Label>
Returns any Currencys with property D equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-Currency -D <PickList Label> -NotEquals D 
Returns any Currencys with property D NOT equal to the <PickList Label>.
 .EXAMPLE
Get-Currency -D <PickList Label1>, <PickList Label2>
Returns any Currencys with property D equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-Currency -D <PickList Label1>, <PickList Label2> -NotEquals D
Returns any Currencys with property D NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-Currency -Id 1234 -CurrencyName SomeName* -D <PickList Label1>, <PickList Label2> -Like CurrencyName -NotEquals D -GreaterThan Id
An example of a more complex query. This command returns any Currencys with Id GREATER THAN 1234, a CurrencyName that matches the simple pattern SomeName* AND that has a D that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
Set-Currency

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
    [ValidateSet('PriceListService:CurrencyID', 'Account:CurrencyID', 'PriceListProduct:CurrencyID', 'PriceListRole:CurrencyID', 'PriceListWorkTypeModifier:CurrencyID', 'PriceListServiceBundle:CurrencyID', 'ExpenseItem:ExpenseCurrencyID', 'PriceListMaterialCode:CurrencyID', 'ExpenseReport:ReimbursementCurrencyID')]
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
    [long[]]
    $id,

# Currency Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1,3)]
    [string[]]
    $Name,

# Currency Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1,100)]
    [string[]]
    $Description,

# Display Symbol
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int[]]
    $DisplaySymbol,

# Exchange Rate
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [decimal[]]
    $ExchangeRate,

# Last Modified Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime[]]
    $LastModifiedDateTime,

# Update Resource ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $UpdateResourceId,

# Is Internal Currency
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [boolean[]]
    $IsInternalCurrency,

# Active
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [boolean[]]
    $Active,

# Currency Positive Format
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1,10)]
    [string[]]
    $CurrencyPositiveFormat,

# Currency Negative Format
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
        
    # Set up TimeZone offset handling
    If (-not($script:ESTzone)) {
      $script:ESTzone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Eastern Standard Time")
    }
    
    If (-not($script:ESToffset)) {
      $Now = Get-Date
      $ESTtime = [System.TimeZoneInfo]::ConvertTimeFromUtc($Now.ToUniversalTime(), $ESTzone)

      $script:ESToffset = (New-TimeSpan -Start $ESTtime -End $Now).TotalHours
    }
  }


  Process
  {
    If ($PSCmdlet.ParameterSetName -eq 'Get_all')
    { $Filter = @('id', '-ge', 0)}
    ElseIf (-not ($Filter)) {
      Write-Debug ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)
      
      $Fields = Get-FieldInfo -Entity $EntityName
 
      Foreach ($Parameter in $PSBoundParameters.GetEnumerator()) {
        $Field = $Fields | Where-Object {$_.Name -eq $Parameter.Key}
        If ($Field -or $Parameter.Key -eq 'UserDefinedField') { 
          If ($Parameter.Value.Count -gt 1) {
            $Filter += '-begin'
          }
          Foreach ($ParameterValue in $Parameter.Value) {   
            $Operator = '-or'
            $ParameterName = $Parameter.Key
            If ($Field.IsPickList) {
              If ($Field.PickListParentValueField) {
                $ParentField = $Fields.Where{$_.Name -eq $Field.PickListParentValueField}
                $ParentLabel = $PSBoundParameters.$($ParentField.Name)
                $ParentValue = $ParentField.PickListValues | Where-Object {$_.Label -eq $ParentLabel}
                $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $ParameterValue -and $_.ParentValue -eq $ParentValue.Value}                
              }
              Else { 
                $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $ParameterValue}
              }
              $Value = $PickListValue.Value
            }
            ElseIf ($ParameterName -eq 'UserDefinedField') {
              $Filter += '-udf'              
              $ParameterName = $ParameterValue.Name
              $Value = $ParameterValue.Value
            }
            ElseIf ($ParameterValue.GetType().Name -eq 'DateTime')  {
              $Value = ConvertTo-AtwsDate -ParameterName $ParameterName -DateTime $ParameterValue
            }            
            Else {
              $Value = $ParameterValue
            }
            $Filter += $ParameterName
            If ($Parameter.Key -in $NotEquals) { 
              $Filter += '-ne'
              $Operator = '-and'
            }
            ElseIf ($Parameter.Key -in $GreaterThan)
            { $Filter += '-gt'}
            ElseIf ($Parameter.Key -in $GreaterThanOrEquals)
            { $Filter += '-ge'}
            ElseIf ($Parameter.Key -in $LessThan)
            { $Filter += '-lt'}
            ElseIf ($Parameter.Key -in $LessThanOrEquals)
            { $Filter += '-le'}
            ElseIf ($Parameter.Key -in $Like) { 
              $Filter += '-like'
              $Value = $Value -replace '\*', '%'
            }
            ElseIf ($Parameter.Key -in $NotLike) { 
              $Filter += '-notlike'
              $Value = $Value -replace '\*', '%'
            }
            ElseIf ($Parameter.Key -in $BeginsWith)
            { $Filter += '-beginswith'}
            ElseIf ($Parameter.Key -in $EndsWith)
            { $Filter += '-endswith'}
            ElseIf ($Parameter.Key -in $Contains)
            { $Filter += '-contains'}
            ElseIf ($Parameter.Key -in $IsThisDay)
            { $Filter += '-isthisday'}
            ElseIf ($Parameter.Key -in $IsNull -and $Parameter.Key -eq 'UserDefinedField')
            {
              $Filter += '-IsNull'
              $IsNull = $IsNull.Where({$_ -ne 'UserDefinedField'})
            }
            ElseIf ($Parameter.Key -in $IsNotNull -and $Parameter.Key -eq 'UserDefinedField')
            {
              $Filter += '-IsNotNull'
              $IsNotNull = $IsNotNull.Where({$_ -ne 'UserDefinedField'})
            }
            Else
            { $Filter += '-eq'}
            
            # Add Value to expression, unless this is a UserDefinedfield AND UserDefinedField has been
            # specified for -IsNull or -IsNotNull
            If ($Filter[-1] -notin @('-IsNull','-IsNotNull'))
            {$Filter += $Value}

            If ($Parameter.Value.Count -gt 1 -and $ParameterValue -ne $Parameter.Value[-1]) {
              $Filter += $Operator
            }
            ElseIf ($Parameter.Value.Count -gt 1) {
              $Filter += '-end'
            }
            
          }
            
        }
      }
      # IsNull and IsNotNull are special. They are the only operators that does not require a value to work
      If ($IsNull.Count -gt 0) {
        If ($Filter.Count -gt 0) {
          $Filter += '-and'
        }
        Foreach ($PropertyName in $IsNull) {
          $Filter += $PropertyName
          $Filter += '-isnull'
        }
      }
      If ($IsNotNull.Count -gt 0) {
        If ($Filter.Count -gt 0) {
          $Filter += '-and'
        }
        Foreach ($PropertyName in $IsNotNull) {
          $Filter += $PropertyName
          $Filter += '-isnotnull'
        }
      }  
    }
    Else {
      Write-Debug ('{0}: Passing -Filter raw to Get function' -F $MyInvocation.MyCommand.Name)
    } 

    $Result = Get-AtwsData -Entity $EntityName -Filter $Filter

    Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $Result.Count)
    
    # Datetimeparameters
    $DateTimeParams = $Fields.Where({$_.Type -eq 'datetime'}).Name
    
    # Expand UDFs by default
    Foreach ($Item in $Result)
    {
      # Any userdefined fields?
      If ($Item.UserDefinedFields.Count -gt 0)
      { 
        # Expand User defined fields for easy filtering of collections and readability
        Foreach ($UDF in $Item.UserDefinedFields)
        {
          # Make names you HAVE TO escape...
          $UDFName = '#{0}' -F $UDF.Name
          Add-Member -InputObject $Item -MemberType NoteProperty -Name $UDFName -Value $UDF.Value
        }  
      }
      
      # Adjust TimeZone on all DateTime properties
      Foreach ($DateTimeParam in $DateTimeParams) {
      
        # Get the datetime value
        $ParameterValue = $Item.$DateTimeParam
                
        # Skip if parameter is empty
        If (-not ($ParameterValue)) {
          Continue
        }
        
        $TimePresent = $ParameterValue.Hour -gt 0 -or $ParameterValue.Minute -gt 0 -or $ParameterValue.Second -gt 0 -or $ParameterValue.Millisecond -gt 0 
                
        # If this is a DATE it should not be touched
        If ($DateTimeParam -like "*DateTime" -or $TimePresent) {

          # This is DATETIME 
          # We need to adjust the timezone difference 

          # Yes, you really have to ADD the difference
          $ParameterValue = $ParameterValue.AddHours($script:ESToffset)
            
          # Store the value back to the object (not the API!)
          $Item.$DateTimeParam = $ParameterValue
        }
      }
    }
    
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
