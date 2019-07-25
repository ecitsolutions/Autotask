#Requires -Version 4.0
#Version 1.6.2.17
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsContractServiceUnit
{


<#
.SYNOPSIS
This function get one or more ContractServiceUnit through the Autotask Web Services API.
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


Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.ContractServiceUnit[]]. This function outputs the Autotask.ContractServiceUnit that was returned by the API.
.EXAMPLE
Get-AtwsContractServiceUnit -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsContractServiceUnit -ContractServiceUnitName SomeName
Returns the object with ContractServiceUnitName 'SomeName', if any.
 .EXAMPLE
Get-AtwsContractServiceUnit -ContractServiceUnitName 'Some Name'
Returns the object with ContractServiceUnitName 'Some Name', if any.
 .EXAMPLE
Get-AtwsContractServiceUnit -ContractServiceUnitName 'Some Name' -NotEquals ContractServiceUnitName
Returns any objects with a ContractServiceUnitName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsContractServiceUnit -ContractServiceUnitName SomeName* -Like ContractServiceUnitName
Returns any object with a ContractServiceUnitName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsContractServiceUnit -ContractServiceUnitName SomeName* -NotLike ContractServiceUnitName
Returns any object with a ContractServiceUnitName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.


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
    [ValidateSet('BusinessDivisionSubdivisionID', 'ContractID', 'ContractServiceID', 'ServiceID', 'VendorAccountID')]
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

# contract_service_unique_id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# ContractID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $ContractID,

# ServiceID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $ServiceID,

# StartDate
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $StartDate,

# EndDate
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $EndDate,

# Units
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $Units,

# Price
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[float][]]
    $Price,

# approve_and_post_date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ApproveAndPostDate,

# Period Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[float][]]
    $Cost,

# Vendor Account ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $VendorAccountID,

# Contract Service Id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ContractServiceID,

# InternalCurrencyPrice
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[float][]]
    $InternalCurrencyPrice,

# Business Division Subdivision ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BusinessDivisionSubdivisionID,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'ServiceID', 'StartDate', 'EndDate', 'Units', 'Price', 'ApproveAndPostDate', 'Cost', 'VendorAccountID', 'ContractServiceID', 'InternalCurrencyPrice', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'ServiceID', 'StartDate', 'EndDate', 'Units', 'Price', 'ApproveAndPostDate', 'Cost', 'VendorAccountID', 'ContractServiceID', 'InternalCurrencyPrice', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'ServiceID', 'StartDate', 'EndDate', 'Units', 'Price', 'ApproveAndPostDate', 'Cost', 'VendorAccountID', 'ContractServiceID', 'InternalCurrencyPrice', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'ServiceID', 'StartDate', 'EndDate', 'Units', 'Price', 'ApproveAndPostDate', 'Cost', 'VendorAccountID', 'ContractServiceID', 'InternalCurrencyPrice', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'ServiceID', 'StartDate', 'EndDate', 'Units', 'Price', 'ApproveAndPostDate', 'Cost', 'VendorAccountID', 'ContractServiceID', 'InternalCurrencyPrice', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'ServiceID', 'StartDate', 'EndDate', 'Units', 'Price', 'ApproveAndPostDate', 'Cost', 'VendorAccountID', 'ContractServiceID', 'InternalCurrencyPrice', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'ServiceID', 'StartDate', 'EndDate', 'Units', 'Price', 'ApproveAndPostDate', 'Cost', 'VendorAccountID', 'ContractServiceID', 'InternalCurrencyPrice', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('StartDate', 'EndDate', 'ApproveAndPostDate')]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'ContractServiceUnit'
    
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
      $Result = Get-AtwsData -Entity $EntityName -Filter $Filter -NoPickListLabel:$NoPickListLabel.IsPresent
    
      Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $Result.Count)

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
