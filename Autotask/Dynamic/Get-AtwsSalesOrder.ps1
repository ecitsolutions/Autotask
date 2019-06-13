#Requires -Version 4.0
#Version 1.6.2.11
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsSalesOrder
{


<#
.SYNOPSIS
This function get one or more SalesOrder through the Autotask Web Services API.
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

Status
 

Entities that have fields that refer to the base entity of this CmdLet:

Opportunity
 PurchaseOrderItem

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.SalesOrder[]]. This function outputs the Autotask.SalesOrder that was returned by the API.
.EXAMPLE
Get-AtwsSalesOrder -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsSalesOrder -SalesOrderName SomeName
Returns the object with SalesOrderName 'SomeName', if any.
 .EXAMPLE
Get-AtwsSalesOrder -SalesOrderName 'Some Name'
Returns the object with SalesOrderName 'Some Name', if any.
 .EXAMPLE
Get-AtwsSalesOrder -SalesOrderName 'Some Name' -NotEquals SalesOrderName
Returns any objects with a SalesOrderName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsSalesOrder -SalesOrderName SomeName* -Like SalesOrderName
Returns any object with a SalesOrderName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsSalesOrder -SalesOrderName SomeName* -NotLike SalesOrderName
Returns any object with a SalesOrderName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsSalesOrder -S <PickList Label>
Returns any SalesOrders with property S equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsSalesOrder -S <PickList Label> -NotEquals S 
Returns any SalesOrders with property S NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsSalesOrder -S <PickList Label1>, <PickList Label2>
Returns any SalesOrders with property S equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsSalesOrder -S <PickList Label1>, <PickList Label2> -NotEquals S
Returns any SalesOrders with property S NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsSalesOrder -Id 1234 -SalesOrderName SomeName* -S <PickList Label1>, <PickList Label2> -Like SalesOrderName -NotEquals S -GreaterThan Id
An example of a more complex query. This command returns any SalesOrders with Id GREATER THAN 1234, a SalesOrderName that matches the simple pattern SomeName* AND that has a S that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
Set-AtwsSalesOrder

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
    [ValidateSet('AccountID', 'BillToCountryID', 'BusinessDivisionSubdivisionID', 'Contact', 'OpportunityID', 'OwnerResourceID', 'ShipToCountryID')]
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
    [ValidateSet('Opportunity:SalesOrderID', 'PurchaseOrderItem:SalesOrderID')]
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

# Sales Order ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $id,

# Client ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $AccountID,

# Title
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,128)]
    [string[]]
    $Title,

# Status
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $Status,

# Contact ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $Contact,

# Owner
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $OwnerResourceID,

# Sales Order Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $SalesOrderDate,

# Promised Due Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $PromisedDueDate,

# Bill to Address1
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,150)]
    [string[]]
    $BillToAddress1,

# Bill to Address2
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,150)]
    [string[]]
    $BillToAddress2,

# Bill to City
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $BillToCity,

# Bill to County
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $BillToState,

# Bill to Postal Code
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $BillToPostalCode,

# Bill to Country
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $BillToCountry,

# Ship to Address1
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,150)]
    [string[]]
    $ShipToAddress1,

# Ship to Address2
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,150)]
    [string[]]
    $ShipToAddress2,

# Ship to City
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $ShipToCity,

# Ship to County
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $ShipToState,

# Ship to Postal Code
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $ShipToPostalCode,

# Ship to Country
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $ShipToCountry,

# Opportunity ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $OpportunityID,

# Additional Bill To Address Information
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $AdditionalBillToAddressInformation,

# Additional Ship To Address Information
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $AdditionalShipToAddressInformation,

# Bill To Country ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BillToCountryID,

# Ship To Country ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ShipToCountryID,

# Business Division Subdivision ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BusinessDivisionSubdivisionID,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'Title', 'Status', 'Contact', 'OwnerResourceID', 'SalesOrderDate', 'PromisedDueDate', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToPostalCode', 'BillToCountry', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'ShipToCountry', 'OpportunityID', 'AdditionalBillToAddressInformation', 'AdditionalShipToAddressInformation', 'BillToCountryID', 'ShipToCountryID', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'Title', 'Status', 'Contact', 'OwnerResourceID', 'SalesOrderDate', 'PromisedDueDate', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToPostalCode', 'BillToCountry', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'ShipToCountry', 'OpportunityID', 'AdditionalBillToAddressInformation', 'AdditionalShipToAddressInformation', 'BillToCountryID', 'ShipToCountryID', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'Title', 'Status', 'Contact', 'OwnerResourceID', 'SalesOrderDate', 'PromisedDueDate', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToPostalCode', 'BillToCountry', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'ShipToCountry', 'OpportunityID', 'AdditionalBillToAddressInformation', 'AdditionalShipToAddressInformation', 'BillToCountryID', 'ShipToCountryID', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'Title', 'Status', 'Contact', 'OwnerResourceID', 'SalesOrderDate', 'PromisedDueDate', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToPostalCode', 'BillToCountry', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'ShipToCountry', 'OpportunityID', 'AdditionalBillToAddressInformation', 'AdditionalShipToAddressInformation', 'BillToCountryID', 'ShipToCountryID', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'Title', 'Status', 'Contact', 'OwnerResourceID', 'SalesOrderDate', 'PromisedDueDate', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToPostalCode', 'BillToCountry', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'ShipToCountry', 'OpportunityID', 'AdditionalBillToAddressInformation', 'AdditionalShipToAddressInformation', 'BillToCountryID', 'ShipToCountryID', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'Title', 'Status', 'Contact', 'OwnerResourceID', 'SalesOrderDate', 'PromisedDueDate', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToPostalCode', 'BillToCountry', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'ShipToCountry', 'OpportunityID', 'AdditionalBillToAddressInformation', 'AdditionalShipToAddressInformation', 'BillToCountryID', 'ShipToCountryID', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'Title', 'Status', 'Contact', 'OwnerResourceID', 'SalesOrderDate', 'PromisedDueDate', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToPostalCode', 'BillToCountry', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'ShipToCountry', 'OpportunityID', 'AdditionalBillToAddressInformation', 'AdditionalShipToAddressInformation', 'BillToCountryID', 'ShipToCountryID', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Title', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToPostalCode', 'BillToCountry', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'ShipToCountry', 'AdditionalBillToAddressInformation', 'AdditionalShipToAddressInformation')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Title', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToPostalCode', 'BillToCountry', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'ShipToCountry', 'AdditionalBillToAddressInformation', 'AdditionalShipToAddressInformation')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Title', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToPostalCode', 'BillToCountry', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'ShipToCountry', 'AdditionalBillToAddressInformation', 'AdditionalShipToAddressInformation')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Title', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToPostalCode', 'BillToCountry', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'ShipToCountry', 'AdditionalBillToAddressInformation', 'AdditionalShipToAddressInformation')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Title', 'BillToAddress1', 'BillToAddress2', 'BillToCity', 'BillToState', 'BillToPostalCode', 'BillToCountry', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'ShipToCountry', 'AdditionalBillToAddressInformation', 'AdditionalShipToAddressInformation')]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('SalesOrderDate', 'PromisedDueDate')]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'SalesOrder'
    
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
