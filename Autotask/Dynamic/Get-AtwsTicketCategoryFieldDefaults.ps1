#Requires -Version 4.0
#Version 1.6.2.17
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsTicketCategoryFieldDefaults
{


<#
.SYNOPSIS
This function get one or more TicketCategoryFieldDefaults through the Autotask Web Services API.
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

IssueTypeID
 

QueueID
 

ServiceLevelAgreementID
 

SourceID
 

SubIssueTypeID
 

TicketTypeID
 

Status
 

Priority
 

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.TicketCategoryFieldDefaults[]]. This function outputs the Autotask.TicketCategoryFieldDefaults that was returned by the API.
.EXAMPLE
Get-AtwsTicketCategoryFieldDefaults -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsTicketCategoryFieldDefaults -TicketCategoryFieldDefaultsName SomeName
Returns the object with TicketCategoryFieldDefaultsName 'SomeName', if any.
 .EXAMPLE
Get-AtwsTicketCategoryFieldDefaults -TicketCategoryFieldDefaultsName 'Some Name'
Returns the object with TicketCategoryFieldDefaultsName 'Some Name', if any.
 .EXAMPLE
Get-AtwsTicketCategoryFieldDefaults -TicketCategoryFieldDefaultsName 'Some Name' -NotEquals TicketCategoryFieldDefaultsName
Returns any objects with a TicketCategoryFieldDefaultsName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsTicketCategoryFieldDefaults -TicketCategoryFieldDefaultsName SomeName* -Like TicketCategoryFieldDefaultsName
Returns any object with a TicketCategoryFieldDefaultsName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsTicketCategoryFieldDefaults -TicketCategoryFieldDefaultsName SomeName* -NotLike TicketCategoryFieldDefaultsName
Returns any object with a TicketCategoryFieldDefaultsName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsTicketCategoryFieldDefaults -IssueTypeID <PickList Label>
Returns any TicketCategoryFieldDefaultss with property IssueTypeID equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsTicketCategoryFieldDefaults -IssueTypeID <PickList Label> -NotEquals IssueTypeID 
Returns any TicketCategoryFieldDefaultss with property IssueTypeID NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsTicketCategoryFieldDefaults -IssueTypeID <PickList Label1>, <PickList Label2>
Returns any TicketCategoryFieldDefaultss with property IssueTypeID equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsTicketCategoryFieldDefaults -IssueTypeID <PickList Label1>, <PickList Label2> -NotEquals IssueTypeID
Returns any TicketCategoryFieldDefaultss with property IssueTypeID NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsTicketCategoryFieldDefaults -Id 1234 -TicketCategoryFieldDefaultsName SomeName* -IssueTypeID <PickList Label1>, <PickList Label2> -Like TicketCategoryFieldDefaultsName -NotEquals IssueTypeID -GreaterThan Id
An example of a more complex query. This command returns any TicketCategoryFieldDefaultss with Id GREATER THAN 1234, a TicketCategoryFieldDefaultsName that matches the simple pattern SomeName* AND that has a IssueTypeID that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.


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
    [ValidateSet('BusinessDivisionSubdivisionID', 'TicketCategoryID', 'WorkTypeID')]
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

# Ticket Category Field Defaults ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Business Division Subdivision ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BusinessDivisionSubdivisionID,

# Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,8000)]
    [string[]]
    $Description,

# Estimated Hours
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $EstimatedHours,

# Issue Type ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $IssueTypeID,

# Purchase Order Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $PurchaseOrderNumber,

# Queue ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $QueueID,

# Resolution
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,8000)]
    [string[]]
    $Resolution,

# Service Level Agreement ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $ServiceLevelAgreementID,

# Source ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $SourceID,

# Sub-Issue Type ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $SubIssueTypeID,

# Ticket Category ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $TicketCategoryID,

# Ticket Type ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $TicketTypeID,

# Title
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string[]]
    $Title,

# Work Type ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $WorkTypeID,

# Status
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $Status,

# Priority
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $Priority,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'BusinessDivisionSubdivisionID', 'Description', 'EstimatedHours', 'IssueTypeID', 'PurchaseOrderNumber', 'QueueID', 'Resolution', 'ServiceLevelAgreementID', 'SourceID', 'SubIssueTypeID', 'TicketCategoryID', 'TicketTypeID', 'Title', 'WorkTypeID', 'Status', 'Priority')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'BusinessDivisionSubdivisionID', 'Description', 'EstimatedHours', 'IssueTypeID', 'PurchaseOrderNumber', 'QueueID', 'Resolution', 'ServiceLevelAgreementID', 'SourceID', 'SubIssueTypeID', 'TicketCategoryID', 'TicketTypeID', 'Title', 'WorkTypeID', 'Status', 'Priority')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'BusinessDivisionSubdivisionID', 'Description', 'EstimatedHours', 'IssueTypeID', 'PurchaseOrderNumber', 'QueueID', 'Resolution', 'ServiceLevelAgreementID', 'SourceID', 'SubIssueTypeID', 'TicketCategoryID', 'TicketTypeID', 'Title', 'WorkTypeID', 'Status', 'Priority')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'BusinessDivisionSubdivisionID', 'Description', 'EstimatedHours', 'IssueTypeID', 'PurchaseOrderNumber', 'QueueID', 'Resolution', 'ServiceLevelAgreementID', 'SourceID', 'SubIssueTypeID', 'TicketCategoryID', 'TicketTypeID', 'Title', 'WorkTypeID', 'Status', 'Priority')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'BusinessDivisionSubdivisionID', 'Description', 'EstimatedHours', 'IssueTypeID', 'PurchaseOrderNumber', 'QueueID', 'Resolution', 'ServiceLevelAgreementID', 'SourceID', 'SubIssueTypeID', 'TicketCategoryID', 'TicketTypeID', 'Title', 'WorkTypeID', 'Status', 'Priority')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'BusinessDivisionSubdivisionID', 'Description', 'EstimatedHours', 'IssueTypeID', 'PurchaseOrderNumber', 'QueueID', 'Resolution', 'ServiceLevelAgreementID', 'SourceID', 'SubIssueTypeID', 'TicketCategoryID', 'TicketTypeID', 'Title', 'WorkTypeID', 'Status', 'Priority')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'BusinessDivisionSubdivisionID', 'Description', 'EstimatedHours', 'IssueTypeID', 'PurchaseOrderNumber', 'QueueID', 'Resolution', 'ServiceLevelAgreementID', 'SourceID', 'SubIssueTypeID', 'TicketCategoryID', 'TicketTypeID', 'Title', 'WorkTypeID', 'Status', 'Priority')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'PurchaseOrderNumber', 'Resolution', 'Title')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'PurchaseOrderNumber', 'Resolution', 'Title')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'PurchaseOrderNumber', 'Resolution', 'Title')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'PurchaseOrderNumber', 'Resolution', 'Title')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'PurchaseOrderNumber', 'Resolution', 'Title')]
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
    $EntityName = 'TicketCategoryFieldDefaults'
    
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
