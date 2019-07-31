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

Additional operators for [string] parameters are:
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
    [ValidateSet('ContractID')]
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
    [string]
    $GetExternalEntityByThisEntityId,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# Do not add descriptions for all picklist attributes with values
    [Parameter(
      ParametersetName = 'Filter'
    )]
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [switch]
    $NoPickListLabel,

# id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Contract ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $ContractID,

# Paid
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $IsPaid,

# DatePurchased
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $DatePurchased,

# Start Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $StartDate,

# End Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $EndDate,

# Tickets Purchased
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[double][]]
    $TicketsPurchased,

# Rate
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[double][]]
    $PerTicketRate,

# Invoice Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $InvoiceNumber,

# Payment Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $PaymentNumber,

# Payment Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $PaymentType,

# Status
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $Status,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'IsPaid', 'DatePurchased', 'StartDate', 'EndDate', 'TicketsPurchased', 'PerTicketRate', 'InvoiceNumber', 'PaymentNumber', 'PaymentType', 'Status')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'IsPaid', 'DatePurchased', 'StartDate', 'EndDate', 'TicketsPurchased', 'PerTicketRate', 'InvoiceNumber', 'PaymentNumber', 'PaymentType', 'Status')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'IsPaid', 'DatePurchased', 'StartDate', 'EndDate', 'TicketsPurchased', 'PerTicketRate', 'InvoiceNumber', 'PaymentNumber', 'PaymentType', 'Status')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'DatePurchased', 'StartDate', 'EndDate', 'TicketsPurchased', 'PerTicketRate', 'InvoiceNumber', 'PaymentNumber', 'PaymentType', 'Status')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'DatePurchased', 'StartDate', 'EndDate', 'TicketsPurchased', 'PerTicketRate', 'InvoiceNumber', 'PaymentNumber', 'PaymentType', 'Status')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'DatePurchased', 'StartDate', 'EndDate', 'TicketsPurchased', 'PerTicketRate', 'InvoiceNumber', 'PaymentNumber', 'PaymentType', 'Status')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ContractID', 'DatePurchased', 'StartDate', 'EndDate', 'TicketsPurchased', 'PerTicketRate', 'InvoiceNumber', 'PaymentNumber', 'PaymentType', 'Status')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('InvoiceNumber', 'PaymentNumber')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('InvoiceNumber', 'PaymentNumber')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('InvoiceNumber', 'PaymentNumber')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('InvoiceNumber', 'PaymentNumber')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('InvoiceNumber', 'PaymentNumber')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('DatePurchased', 'StartDate', 'EndDate')]
    [string[]]
    $IsThisDay
  )

    begin { 
        $entityName = 'ContractTicketPurchase'
    
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {
            $DebugPreference = 'Continue' 
        }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
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
            $Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $entityName
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
