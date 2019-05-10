#Requires -Version 4.0
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsCountry
{


<#
.SYNOPSIS
This function get one or more Country through the Autotask Web Services API.
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

AddressFormatID
 

Entities that have fields that refer to the base entity of this CmdLet:

Account
 AccountPhysicalLocation
 BusinessLocation
 Contact
 SalesOrder

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Country[]]. This function outputs the Autotask.Country that was returned by the API.
.EXAMPLE
Get-AtwsCountry -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsCountry -CountryName SomeName
Returns the object with CountryName 'SomeName', if any.
 .EXAMPLE
Get-AtwsCountry -CountryName 'Some Name'
Returns the object with CountryName 'Some Name', if any.
 .EXAMPLE
Get-AtwsCountry -CountryName 'Some Name' -NotEquals CountryName
Returns any objects with a CountryName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsCountry -CountryName SomeName* -Like CountryName
Returns any object with a CountryName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsCountry -CountryName SomeName* -NotLike CountryName
Returns any object with a CountryName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsCountry -A <PickList Label>
Returns any Countrys with property A equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsCountry -A <PickList Label> -NotEquals A 
Returns any Countrys with property A NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsCountry -A <PickList Label1>, <PickList Label2>
Returns any Countrys with property A equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsCountry -A <PickList Label1>, <PickList Label2> -NotEquals A
Returns any Countrys with property A NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsCountry -Id 1234 -CountryName SomeName* -A <PickList Label1>, <PickList Label2> -Like CountryName -NotEquals A -GreaterThan Id
An example of a more complex query. This command returns any Countrys with Id GREATER THAN 1234, a CountryName that matches the simple pattern SomeName* AND that has a A that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
Set-AtwsCountry

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
    [ValidateSet('QuoteTemplateID', 'InvoiceTemplateID')]
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
    [ValidateSet('Contact:CountryID', 'Account:CountryID', 'Account:BillToCountryID', 'AccountPhysicalLocation:CountryID', 'SalesOrder:BillToCountryID', 'SalesOrder:ShipToCountryID', 'BusinessLocation:CountryID')]
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

# Country ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [long[]]
    $id,

# Country Code
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,2)]
    [string[]]
    $CountryCode,

# ISO Standard Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string[]]
    $Name,

# Display Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1,100)]
    [string[]]
    $DisplayName,

# Active
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean[]]
    $Active,

# Default Country
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean[]]
    $IsDefaultCountry,

# Address Format ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [long[]]
    $AddressFormatID,

# Quote Template ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $QuoteTemplateID,

# Invoice Template ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $InvoiceTemplateID,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'CountryCode', 'Name', 'DisplayName', 'Active', 'IsDefaultCountry', 'AddressFormatID', 'QuoteTemplateID', 'InvoiceTemplateID')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'CountryCode', 'Name', 'DisplayName', 'Active', 'IsDefaultCountry', 'AddressFormatID', 'QuoteTemplateID', 'InvoiceTemplateID')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'CountryCode', 'Name', 'DisplayName', 'Active', 'IsDefaultCountry', 'AddressFormatID', 'QuoteTemplateID', 'InvoiceTemplateID')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'CountryCode', 'Name', 'DisplayName', 'AddressFormatID', 'QuoteTemplateID', 'InvoiceTemplateID')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'CountryCode', 'Name', 'DisplayName', 'AddressFormatID', 'QuoteTemplateID', 'InvoiceTemplateID')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'CountryCode', 'Name', 'DisplayName', 'AddressFormatID', 'QuoteTemplateID', 'InvoiceTemplateID')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'CountryCode', 'Name', 'DisplayName', 'AddressFormatID', 'QuoteTemplateID', 'InvoiceTemplateID')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('CountryCode', 'Name', 'DisplayName')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('CountryCode', 'Name', 'DisplayName')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('CountryCode', 'Name', 'DisplayName')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('CountryCode', 'Name', 'DisplayName')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('CountryCode', 'Name', 'DisplayName')]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'Country'
    
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
              
      # $Filter is usually passed as a flat string. Convert it to an array.
      If ($Filter.Count -eq 1 -and $Filter -match ' ' )
      { 
        # First, make sure it is a single string and replace parenthesis with our special operator
        $Filter = $Filter -join ' ' -replace '\(',' -begin ' -replace '\)', ' -end '
    
        # Removing double possible spaces we may have introduced
        Do {$Filter = $Filter -replace '  ',' '}
        While ($Filter -match '  ')

        # Split back in to array, respecting quotes
        $Words = $Filter.Trim().Split(' ')
        [String[]]$Filter = @()
        $Temp = @()
        Foreach ($Word in $Words)
        {
          If ($Temp.Count -eq 0 -and $Word -match '^[\"\'']')
          {
            $Temp += $Word.TrimStart('"''')
          }
          ElseIf ($Temp.Count -gt 0 -and $Word -match "[\'\""]$")
          {
            $Temp += $Word.TrimEnd("'""")
            $Filter += $Temp -join ' '
            $Temp = @()
          }
          ElseIf ($Temp.Count -gt 0)
          {
            $Temp += $Word
          }
          Else
          {
            $Filter += $Word
          }
        }
      }
      
      Write-Debug ('{0}: Checking query for variables that have survived as string' -F $MyInvocation.MyCommand.Name)
      
      $NewFilter = @()
      Foreach ($Word in $Filter)
      {
        $Value = $Word
        # Is it a variable name?
        If ($Word -match '^\$\{?(\w+:)?(\w+)\}?(\.\w[\.\w]+)?$')
        {
          # If present, first group is SCOPE. In the context of this function, the only possible scope
          # is Global; Script = the module, local is internal to this function.
          $Scope = 'Global' # or numbered scope 2
        
          # The variable name MUST be present
          $VariableName = $Matches[2]

          # A property tail CAN be present
          $PropertyTail = $Matches[3]
        
          # Check that the variable exists
          $Variable = Try
          { Get-Variable -Name $VariableName -Scope $Scope -ValueOnly -ErrorAction Stop }
          Catch
          {
            Write-Error ('{0}: Could not find any variable called ${1}. Is it misspelled or has it not been set yet?' -f $MyInvocation.MyCommand.Name, $VariableName)
            # Force stop of calling script, because this will completely break the query
            Return
          }

          # Test if the variable "Variable" has been set
          If (Test-Path Variable:Variable) {
            Write-Debug ('{0}: Substituting {1} for its value' -F $MyInvocation.MyCommand.Name, $Word)
            If ($PropertyTail) {
              # Add properties back 
              $Expression = '$Variable{0}' -F $PropertyTail
  
              # Invoke-Expression is considered risky from an SQL injection kind of perspective. But by only
              # permitting a .dot separated string of [a-zA-Z0-9_] we are PROBABLY safe...
              $Value = Invoke-Expression -Command $Expression
            }
            Else {
              $Value = $Variable
            }
            If ($Value -eq $Null) {
              Write-Error ('{0}: Could not find any variable called {1}. Is it misspelled or has it not been set yet?' -F $MyInvocation.MyCommand.Name, $Expression)
              # Force stop of calling script, because this will completely break the query
              Return
            }
            Else { 
              # Normalize dates. Important to avoid QueryXML problems
              If ($Value.GetType().Name -eq 'DateTime')
              {[String]$Value = ConvertTo-AtwsDate -ParameterName $NewFilter[-2] -DateTime $Value}
            }
          }
        }
        $NewFilter += $Value
      }
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
