#Requires -Version 4.0
#Version 1.6.2.17
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsContractBillingRule
{


<#
.SYNOPSIS
This function get one or more ContractBillingRule through the Autotask Web Services API.
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

DetermineUnits
 

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.ContractBillingRule[]]. This function outputs the Autotask.ContractBillingRule that was returned by the API.
.EXAMPLE
Get-AtwsContractBillingRule -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsContractBillingRule -ContractBillingRuleName SomeName
Returns the object with ContractBillingRuleName 'SomeName', if any.
 .EXAMPLE
Get-AtwsContractBillingRule -ContractBillingRuleName 'Some Name'
Returns the object with ContractBillingRuleName 'Some Name', if any.
 .EXAMPLE
Get-AtwsContractBillingRule -ContractBillingRuleName 'Some Name' -NotEquals ContractBillingRuleName
Returns any objects with a ContractBillingRuleName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsContractBillingRule -ContractBillingRuleName SomeName* -Like ContractBillingRuleName
Returns any object with a ContractBillingRuleName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsContractBillingRule -ContractBillingRuleName SomeName* -NotLike ContractBillingRuleName
Returns any object with a ContractBillingRuleName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsContractBillingRule -D <PickList Label>
Returns any ContractBillingRules with property D equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsContractBillingRule -D <PickList Label> -NotEquals D 
Returns any ContractBillingRules with property D NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsContractBillingRule -D <PickList Label1>, <PickList Label2>
Returns any ContractBillingRules with property D equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsContractBillingRule -D <PickList Label1>, <PickList Label2> -NotEquals D
Returns any ContractBillingRules with property D NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsContractBillingRule -Id 1234 -ContractBillingRuleName SomeName* -D <PickList Label1>, <PickList Label2> -Like ContractBillingRuleName -NotEquals D -GreaterThan Id
An example of a more complex query. This command returns any ContractBillingRules with Id GREATER THAN 1234, a ContractBillingRuleName that matches the simple pattern SomeName* AND that has a D that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsContractBillingRule
 .LINK
Remove-AtwsContractBillingRule
 .LINK
Set-AtwsContractBillingRule

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
    [ValidateSet('ContractID', 'ProductID')]
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

# Contract Billing Rule ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Invoice Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string[]]
    $InvoiceDescription,

# Contract ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $ContractID,

# Product ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $ProductID,

# Active
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $Active,

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
    [Nullable[datetime][]]
    $EndDate,

# Determine Units
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $DetermineUnits,

# Minimum Units
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $MinimumUnits,

# Maximum Units
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $MaximumUnits,

# Create Charges As Billable
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $CreateChargesAsBillable,

# Include Items In Charge Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $IncludeItemsInChargeDescription,

# Enable Daily Prorating
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $EnableDailyProrating,

# Daily Prorated Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $DailyProratedCost,

# Daily Prorated Price
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $DailyProratedPrice,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'InvoiceDescription', 'ContractID', 'ProductID', 'Active', 'StartDate', 'EndDate', 'DetermineUnits', 'MinimumUnits', 'MaximumUnits', 'CreateChargesAsBillable', 'IncludeItemsInChargeDescription', 'EnableDailyProrating', 'DailyProratedCost', 'DailyProratedPrice')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'InvoiceDescription', 'ContractID', 'ProductID', 'Active', 'StartDate', 'EndDate', 'DetermineUnits', 'MinimumUnits', 'MaximumUnits', 'CreateChargesAsBillable', 'IncludeItemsInChargeDescription', 'EnableDailyProrating', 'DailyProratedCost', 'DailyProratedPrice')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'InvoiceDescription', 'ContractID', 'ProductID', 'Active', 'StartDate', 'EndDate', 'DetermineUnits', 'MinimumUnits', 'MaximumUnits', 'CreateChargesAsBillable', 'IncludeItemsInChargeDescription', 'EnableDailyProrating', 'DailyProratedCost', 'DailyProratedPrice')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'InvoiceDescription', 'ContractID', 'ProductID', 'StartDate', 'EndDate', 'DetermineUnits', 'MinimumUnits', 'MaximumUnits', 'DailyProratedCost', 'DailyProratedPrice')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'InvoiceDescription', 'ContractID', 'ProductID', 'StartDate', 'EndDate', 'DetermineUnits', 'MinimumUnits', 'MaximumUnits', 'DailyProratedCost', 'DailyProratedPrice')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'InvoiceDescription', 'ContractID', 'ProductID', 'StartDate', 'EndDate', 'DetermineUnits', 'MinimumUnits', 'MaximumUnits', 'DailyProratedCost', 'DailyProratedPrice')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'InvoiceDescription', 'ContractID', 'ProductID', 'StartDate', 'EndDate', 'DetermineUnits', 'MinimumUnits', 'MaximumUnits', 'DailyProratedCost', 'DailyProratedPrice')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('InvoiceDescription')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('InvoiceDescription')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('InvoiceDescription')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('InvoiceDescription')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('InvoiceDescription')]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('StartDate', 'EndDate')]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'ContractBillingRule'
    
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
