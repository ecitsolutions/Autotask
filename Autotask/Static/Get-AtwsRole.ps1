#Requires -Version 4.0
#Version 1.6.2.17
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsRole
{


<#
.SYNOPSIS
This function get one or more Role through the Autotask Web Services API.
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

BillingItem
 ContractExclusionRole
 ContractExclusionSetExcludedRole
 ContractFactor
 ContractRate
 ContractRoleCost
 PriceListRole
 QuoteItem
 Resource
 ResourceRole
 ResourceRoleDepartment
 ResourceRoleQueue
 ResourceServiceDeskRole
 Task
 TaskSecondaryResource
 Ticket
 TicketSecondaryResource
 TimeEntry

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Role[]]. This function outputs the Autotask.Role that was returned by the API.
.EXAMPLE
Get-AtwsRole -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsRole -RoleName SomeName
Returns the object with RoleName 'SomeName', if any.
 .EXAMPLE
Get-AtwsRole -RoleName 'Some Name'
Returns the object with RoleName 'Some Name', if any.
 .EXAMPLE
Get-AtwsRole -RoleName 'Some Name' -NotEquals RoleName
Returns any objects with a RoleName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsRole -RoleName SomeName* -Like RoleName
Returns any object with a RoleName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsRole -RoleName SomeName* -NotLike RoleName
Returns any object with a RoleName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.

.LINK
New-AtwsRole
 .LINK
Set-AtwsRole

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
    [ValidateSet('QuoteItemDefaultTaxCategoryId')]
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
    [ValidateSet('BillingItem:RoleID', 'ContractExclusionRole:RoleID', 'ContractExclusionSetExcludedRole:ExcludedRoleID', 'ContractFactor:RoleID', 'ContractRate:RoleID', 'ContractRoleCost:RoleID', 'PriceListRole:RoleID', 'QuoteItem:LaborID', 'Resource:DefaultServiceDeskRoleID', 'ResourceRole:RoleID', 'ResourceRoleDepartment:RoleID', 'ResourceRoleQueue:RoleID', 'ResourceServiceDeskRole:RoleID', 'Task:AssignedResourceRoleID', 'TaskSecondaryResource:RoleID', 'Ticket:AssignedResourceRoleID', 'TicketSecondaryResource:RoleID', 'TimeEntry:RoleID')]
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

# Role ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,200)]
    [string[]]
    $Name,

# Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,200)]
    [string[]]
    $Description,

# System Role
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $SystemRole,

# Hourly Factor
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[decimal][]]
    $HourlyFactor,

# Hourly Rate
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[decimal][]]
    $HourlyRate,

# Quote Item Default Tax Category ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $QuoteItemDefaultTaxCategoryId,

# Active
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $Active,

# Is Excluded From New Contracts
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $IsExcludedFromNewContracts,

# Role Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $RoleType,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'SystemRole', 'HourlyFactor', 'HourlyRate', 'QuoteItemDefaultTaxCategoryId', 'Active', 'IsExcludedFromNewContracts', 'RoleType')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'SystemRole', 'HourlyFactor', 'HourlyRate', 'QuoteItemDefaultTaxCategoryId', 'Active', 'IsExcludedFromNewContracts', 'RoleType')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'SystemRole', 'HourlyFactor', 'HourlyRate', 'QuoteItemDefaultTaxCategoryId', 'Active', 'IsExcludedFromNewContracts', 'RoleType')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'HourlyFactor', 'HourlyRate', 'QuoteItemDefaultTaxCategoryId', 'RoleType')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'HourlyFactor', 'HourlyRate', 'QuoteItemDefaultTaxCategoryId', 'RoleType')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'HourlyFactor', 'HourlyRate', 'QuoteItemDefaultTaxCategoryId', 'RoleType')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'HourlyFactor', 'HourlyRate', 'QuoteItemDefaultTaxCategoryId', 'RoleType')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description')]
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
    $EntityName = 'Role'
    
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
