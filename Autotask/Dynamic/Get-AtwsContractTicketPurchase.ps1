#Requires -Version 4.0
#Version 1.6.2.17
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsContractTicketPurchase
{


<#
.SYNOPSIS
This function get one or more ContractTicketPurchase through the Autotask Web Services API.
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

IsPaid
 

PaymentType
 

Status
 

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.ContractTicketPurchase[]]. This function outputs the Autotask.ContractTicketPurchase that was returned by the API.
.EXAMPLE
Get-AtwsContractTicketPurchase -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsContractTicketPurchase -ContractTicketPurchaseName SomeName
Returns the object with ContractTicketPurchaseName 'SomeName', if any.
 .EXAMPLE
Get-AtwsContractTicketPurchase -ContractTicketPurchaseName 'Some Name'
Returns the object with ContractTicketPurchaseName 'Some Name', if any.
 .EXAMPLE
Get-AtwsContractTicketPurchase -ContractTicketPurchaseName 'Some Name' -NotEquals ContractTicketPurchaseName
Returns any objects with a ContractTicketPurchaseName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsContractTicketPurchase -ContractTicketPurchaseName SomeName* -Like ContractTicketPurchaseName
Returns any object with a ContractTicketPurchaseName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsContractTicketPurchase -ContractTicketPurchaseName SomeName* -NotLike ContractTicketPurchaseName
Returns any object with a ContractTicketPurchaseName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsContractTicketPurchase -IsPaid <PickList Label>
Returns any ContractTicketPurchases with property IsPaid equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsContractTicketPurchase -IsPaid <PickList Label> -NotEquals IsPaid 
Returns any ContractTicketPurchases with property IsPaid NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsContractTicketPurchase -IsPaid <PickList Label1>, <PickList Label2>
Returns any ContractTicketPurchases with property IsPaid equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsContractTicketPurchase -IsPaid <PickList Label1>, <PickList Label2> -NotEquals IsPaid
Returns any ContractTicketPurchases with property IsPaid NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsContractTicketPurchase -Id 1234 -ContractTicketPurchaseName SomeName* -IsPaid <PickList Label1>, <PickList Label2> -Like ContractTicketPurchaseName -NotEquals IsPaid -GreaterThan Id
An example of a more complex query. This command returns any ContractTicketPurchases with Id GREATER THAN 1234, a ContractTicketPurchaseName that matches the simple pattern SomeName* AND that has a IsPaid that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsContractTicketPurchase
 .LINK
Set-AtwsContractTicketPurchase

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
    [Nullable[long][]]
    $id,

# Contract ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $ContractID,

# Paid
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $IsPaid,

# DatePurchased
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $DatePurchased,

# Start Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $StartDate,

# End Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $EndDate,

# Tickets Purchased
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[double][]]
    $TicketsPurchased,

# Rate
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[double][]]
    $PerTicketRate,

# Invoice Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $InvoiceNumber,

# Payment Number
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
    $PaymentType,

# Status
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $Status,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'IsPaid', 'DatePurchased', 'StartDate', 'EndDate', 'TicketsPurchased', 'PerTicketRate', 'InvoiceNumber', 'PaymentNumber', 'PaymentType', 'Status')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'IsPaid', 'DatePurchased', 'StartDate', 'EndDate', 'TicketsPurchased', 'PerTicketRate', 'InvoiceNumber', 'PaymentNumber', 'PaymentType', 'Status')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'IsPaid', 'DatePurchased', 'StartDate', 'EndDate', 'TicketsPurchased', 'PerTicketRate', 'InvoiceNumber', 'PaymentNumber', 'PaymentType', 'Status')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'DatePurchased', 'StartDate', 'EndDate', 'TicketsPurchased', 'PerTicketRate', 'InvoiceNumber', 'PaymentNumber', 'PaymentType', 'Status')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'DatePurchased', 'StartDate', 'EndDate', 'TicketsPurchased', 'PerTicketRate', 'InvoiceNumber', 'PaymentNumber', 'PaymentType', 'Status')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'DatePurchased', 'StartDate', 'EndDate', 'TicketsPurchased', 'PerTicketRate', 'InvoiceNumber', 'PaymentNumber', 'PaymentType', 'Status')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'DatePurchased', 'StartDate', 'EndDate', 'TicketsPurchased', 'PerTicketRate', 'InvoiceNumber', 'PaymentNumber', 'PaymentType', 'Status')]
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
    $EntityName = 'ContractTicketPurchase'
    
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
    
      # Make the query and pass the optional parameters to Get-AtwsData
      $Result = Get-AtwsData -Entity $EntityName -Filter $Filter `
        -NoPickListLabel:$NoPickListLabel.IsPresent `
        -GetReferenceEntityById $GetReferenceEntityById `
        -GetExternalEntityByThisEntityId $GetExternalEntityByThisEntityId
    
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
