﻿<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AllocationCode
{


<#
.SYNOPSIS
This function get one or more AllocationCode through the Autotask Web Services API.
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

GeneralLedgerCode
 

Type
 

UseType
 

AllocationCodeType
 

Entities that have fields that refer to the base entity of this CmdLet:

BillingItem
 ContractCost
 ContractExclusionAllocationCode
 ContractMilestone
 PriceListMaterialCode
 Product
 ProjectCost
 QuoteItem
 Service
 ServiceBundle
 ShippingType
 Subscription
 Task
 Ticket
 TicketCategoryFieldDefaults
 TicketCost
 TimeEntry

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.AllocationCode[]]. This function outputs the Autotask.AllocationCode that was returned by the API.
.EXAMPLE
Get-AllocationCode -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AllocationCode -AllocationCodeName SomeName
Returns the object with AllocationCodeName 'SomeName', if any.
 .EXAMPLE
Get-AllocationCode -AllocationCodeName 'Some Name'
Returns the object with AllocationCodeName 'Some Name', if any.
 .EXAMPLE
Get-AllocationCode -AllocationCodeName 'Some Name' -NotEquals AllocationCodeName
Returns any objects with a AllocationCodeName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AllocationCode -AllocationCodeName SomeName* -Like AllocationCodeName
Returns any object with a AllocationCodeName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AllocationCode -AllocationCodeName SomeName* -NotLike AllocationCodeName
Returns any object with a AllocationCodeName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AllocationCode -GeneralLedgerCode <PickList Label>
Returns any AllocationCodes with property GeneralLedgerCode equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AllocationCode -GeneralLedgerCode <PickList Label> -NotEquals GeneralLedgerCode 
Returns any AllocationCodes with property GeneralLedgerCode NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AllocationCode -GeneralLedgerCode <PickList Label1>, <PickList Label2>
Returns any AllocationCodes with property GeneralLedgerCode equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AllocationCode -GeneralLedgerCode <PickList Label1>, <PickList Label2> -NotEquals GeneralLedgerCode
Returns any AllocationCodes with property GeneralLedgerCode NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AllocationCode -Id 1234 -AllocationCodeName SomeName* -GeneralLedgerCode <PickList Label1>, <PickList Label2> -Like AllocationCodeName -NotEquals GeneralLedgerCode -GreaterThan Id
An example of a more complex query. This command returns any AllocationCodes with Id GREATER THAN 1234, a AllocationCodeName that matches the simple pattern SomeName* AND that has a GeneralLedgerCode that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.


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
    [ValidateSet('TaxCategoryID')]
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
    [ValidateSet('Service:AllocationCodeID', 'Product:ProductAllocationCodeID', 'Product:CostAllocationCodeID', 'ContractExclusionAllocationCode:AllocationCodeID', 'TicketCategoryFieldDefaults:WorkTypeID', 'ShippingType:AllocationCodeID', 'Subscription:MaterialCodeID', 'ServiceBundle:AllocationCodeID', 'BillingItem:AllocationCodeID', 'ContractMilestone:AllocationCodeID', 'TicketCost:AllocationCodeID', 'ProjectCost:AllocationCodeID', 'Ticket:AllocationCodeID', 'ContractCost:AllocationCodeID', 'PriceListMaterialCode:AllocationCodeID', 'QuoteItem:CostID', 'QuoteItem:ExpenseID', 'TimeEntry:InternalAllocationCodeID', 'TimeEntry:AllocationCodeID', 'Task:AllocationCodeID')]
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

# Allocation Code ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [long[]]
    $id,

# General Ledger Code
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $GeneralLedgerCode,

# Department ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $Department,

# Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,200)]
    [string[]]
    $Name,

# Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,100)]
    [string[]]
    $ExternalNumber,

# Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $Type,

# Use Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $UseType,

# Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,500)]
    [string[]]
    $Description,

# Active
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [boolean[]]
    $Active,

# Unit Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [double[]]
    $UnitCost,

# Unit Price
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [double[]]
    $UnitPrice,

# Allocation Code Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $AllocationCodeType,

# Tax Category ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $TaxCategoryID,

# Markup Rate
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double[]]
    $MarkupRate,

# Is Excluded From New Contracts
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean[]]
    $IsExcludedFromNewContracts,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'GeneralLedgerCode', 'Department', 'Name', 'ExternalNumber', 'Type', 'UseType', 'Description', 'Active', 'UnitCost', 'UnitPrice', 'AllocationCodeType', 'TaxCategoryID', 'MarkupRate', 'IsExcludedFromNewContracts')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'GeneralLedgerCode', 'Department', 'Name', 'ExternalNumber', 'Type', 'UseType', 'Description', 'Active', 'UnitCost', 'UnitPrice', 'AllocationCodeType', 'TaxCategoryID', 'MarkupRate', 'IsExcludedFromNewContracts')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'GeneralLedgerCode', 'Department', 'Name', 'ExternalNumber', 'Type', 'UseType', 'Description', 'Active', 'UnitCost', 'UnitPrice', 'AllocationCodeType', 'TaxCategoryID', 'MarkupRate', 'IsExcludedFromNewContracts')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'GeneralLedgerCode', 'Department', 'Name', 'ExternalNumber', 'Type', 'UseType', 'Description', 'UnitCost', 'UnitPrice', 'AllocationCodeType', 'TaxCategoryID', 'MarkupRate')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'GeneralLedgerCode', 'Department', 'Name', 'ExternalNumber', 'Type', 'UseType', 'Description', 'UnitCost', 'UnitPrice', 'AllocationCodeType', 'TaxCategoryID', 'MarkupRate')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'GeneralLedgerCode', 'Department', 'Name', 'ExternalNumber', 'Type', 'UseType', 'Description', 'UnitCost', 'UnitPrice', 'AllocationCodeType', 'TaxCategoryID', 'MarkupRate')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'GeneralLedgerCode', 'Department', 'Name', 'ExternalNumber', 'Type', 'UseType', 'Description', 'UnitCost', 'UnitPrice', 'AllocationCodeType', 'TaxCategoryID', 'MarkupRate')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'ExternalNumber', 'Description')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'ExternalNumber', 'Description')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'ExternalNumber', 'Description')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'ExternalNumber', 'Description')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'ExternalNumber', 'Description')]
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
    $EntityName = 'AllocationCode'

    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
        
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
      Write-Verbose ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)
      
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
              # XML supports sortable datetime format. This way dates should always be read correct by the API.
 
              If ($ParameterValue.Hour -eq 0 -and $ParameterValue.Minute -eq 0 -and $ParameterValue.Second -eq 0 -and $ParameterValue.Millisecond -eq 0) {
                
                # For dates, use Timezone EST
                $OffsetSpan = $ESTzone.BaseUtcOffset
              }
              Else { 
                # Else use local time
                $OffsetSpan = (Get-TimeZone).BaseUtcOffset
              }
              
              # Create the correct text string                           
              $Offset = '{0:00}:{1:00}' -F $OffsetSpan.Hours, $OffsetSpan.Minutes
              If ($OffsetSpan.Hours -ge 0) {
                $Offset = '+{0}' -F $Offset
              }
              $Value = '{0}{1}' -F $(Get-Date $ParameterValue -Format s), $Offset
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
      Write-Verbose ('{0}: Passing -Filter raw to Get function' -F $MyInvocation.MyCommand.Name)
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
        
        # If all TIME parameters are zero, then this is a DATE and should not be touched
        If ($ParameterValue.Hour -ne 0 -or 
            $ParameterValue.Minute -ne 0 -or
            $ParameterValue.Second -ne 0 -or
            $ParameterValue.Millisecond -ne 0) {

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
      Write-Verbose ('{0}: User has asked for external reference objects by {1}' -F $MyInvocation.MyCommand.Name, $GetReferenceEntityById)
      
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
      Write-Verbose ('{0}: User has asked for {1} that are referencing this result' -F $MyInvocation.MyCommand.Name, $GetExternalEntityByThisEntityId)
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
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    If ($Result)
    {
      Return $Result
    }
  }


}