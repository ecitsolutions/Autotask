#Requires -Version 4.0
#Version 1.6.2.17
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsContractRetainer
{


<#
.SYNOPSIS
This function get one or more ContractRetainer through the Autotask Web Services API.
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
 

IsPaid
 

paymentID
 

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.ContractRetainer[]]. This function outputs the Autotask.ContractRetainer that was returned by the API.
.EXAMPLE
Get-AtwsContractRetainer -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsContractRetainer -ContractRetainerName SomeName
Returns the object with ContractRetainerName 'SomeName', if any.
 .EXAMPLE
Get-AtwsContractRetainer -ContractRetainerName 'Some Name'
Returns the object with ContractRetainerName 'Some Name', if any.
 .EXAMPLE
Get-AtwsContractRetainer -ContractRetainerName 'Some Name' -NotEquals ContractRetainerName
Returns any objects with a ContractRetainerName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsContractRetainer -ContractRetainerName SomeName* -Like ContractRetainerName
Returns any object with a ContractRetainerName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsContractRetainer -ContractRetainerName SomeName* -NotLike ContractRetainerName
Returns any object with a ContractRetainerName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsContractRetainer -Status <PickList Label>
Returns any ContractRetainers with property Status equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsContractRetainer -Status <PickList Label> -NotEquals Status 
Returns any ContractRetainers with property Status NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsContractRetainer -Status <PickList Label1>, <PickList Label2>
Returns any ContractRetainers with property Status equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsContractRetainer -Status <PickList Label1>, <PickList Label2> -NotEquals Status
Returns any ContractRetainers with property Status NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsContractRetainer -Id 1234 -ContractRetainerName SomeName* -Status <PickList Label1>, <PickList Label2> -Like ContractRetainerName -NotEquals Status -GreaterThan Id
An example of a more complex query. This command returns any ContractRetainers with Id GREATER THAN 1234, a ContractRetainerName that matches the simple pattern SomeName* AND that has a Status that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsContractRetainer
 .LINK
Set-AtwsContractRetainer

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
    [ValidateSet('ContractID')]
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

# id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $id,

# Contract ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $ContractID,

# Status
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $Status,

# Paid
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $IsPaid,

# Date Purchased
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $DatePurchased,

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

# Amount
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[double][]]
    $Amount,

# InvoiceNumber
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $InvoiceNumber,

# PaymentNumber
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $PaymentNumber,

# Payment Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $paymentID,

# Internal Currency Amount
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $InternalCurrencyAmount,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'Status', 'IsPaid', 'DatePurchased', 'StartDate', 'EndDate', 'Amount', 'InvoiceNumber', 'PaymentNumber', 'paymentID', 'InternalCurrencyAmount')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'Status', 'IsPaid', 'DatePurchased', 'StartDate', 'EndDate', 'Amount', 'InvoiceNumber', 'PaymentNumber', 'paymentID', 'InternalCurrencyAmount')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'Status', 'IsPaid', 'DatePurchased', 'StartDate', 'EndDate', 'Amount', 'InvoiceNumber', 'PaymentNumber', 'paymentID', 'InternalCurrencyAmount')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'Status', 'IsPaid', 'DatePurchased', 'StartDate', 'EndDate', 'Amount', 'InvoiceNumber', 'PaymentNumber', 'paymentID', 'InternalCurrencyAmount')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'Status', 'IsPaid', 'DatePurchased', 'StartDate', 'EndDate', 'Amount', 'InvoiceNumber', 'PaymentNumber', 'paymentID', 'InternalCurrencyAmount')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'Status', 'IsPaid', 'DatePurchased', 'StartDate', 'EndDate', 'Amount', 'InvoiceNumber', 'PaymentNumber', 'paymentID', 'InternalCurrencyAmount')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'Status', 'IsPaid', 'DatePurchased', 'StartDate', 'EndDate', 'Amount', 'InvoiceNumber', 'PaymentNumber', 'paymentID', 'InternalCurrencyAmount')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('InvoiceNumber', 'PaymentNumber')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('InvoiceNumber', 'PaymentNumber')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('InvoiceNumber', 'PaymentNumber')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('InvoiceNumber', 'PaymentNumber')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('InvoiceNumber', 'PaymentNumber')]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('DatePurchased', 'StartDate', 'EndDate')]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'ContractRetainer'
    
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
