#Requires -Version 4.0
#Version 1.6.2.17
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsTicketChecklistItem
{


<#
.SYNOPSIS
This function get one or more TicketChecklistItem through the Autotask Web Services API.
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

KnowledgebaseArticleID
 

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.TicketChecklistItem[]]. This function outputs the Autotask.TicketChecklistItem that was returned by the API.
.EXAMPLE
Get-AtwsTicketChecklistItem -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsTicketChecklistItem -TicketChecklistItemName SomeName
Returns the object with TicketChecklistItemName 'SomeName', if any.
 .EXAMPLE
Get-AtwsTicketChecklistItem -TicketChecklistItemName 'Some Name'
Returns the object with TicketChecklistItemName 'Some Name', if any.
 .EXAMPLE
Get-AtwsTicketChecklistItem -TicketChecklistItemName 'Some Name' -NotEquals TicketChecklistItemName
Returns any objects with a TicketChecklistItemName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsTicketChecklistItem -TicketChecklistItemName SomeName* -Like TicketChecklistItemName
Returns any object with a TicketChecklistItemName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsTicketChecklistItem -TicketChecklistItemName SomeName* -NotLike TicketChecklistItemName
Returns any object with a TicketChecklistItemName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsTicketChecklistItem -K <PickList Label>
Returns any TicketChecklistItems with property K equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsTicketChecklistItem -K <PickList Label> -NotEquals K 
Returns any TicketChecklistItems with property K NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsTicketChecklistItem -K <PickList Label1>, <PickList Label2>
Returns any TicketChecklistItems with property K equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsTicketChecklistItem -K <PickList Label1>, <PickList Label2> -NotEquals K
Returns any TicketChecklistItems with property K NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsTicketChecklistItem -Id 1234 -TicketChecklistItemName SomeName* -K <PickList Label1>, <PickList Label2> -Like TicketChecklistItemName -NotEquals K -GreaterThan Id
An example of a more complex query. This command returns any TicketChecklistItems with Id GREATER THAN 1234, a TicketChecklistItemName that matches the simple pattern SomeName* AND that has a K that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsTicketChecklistItem
 .LINK
Remove-AtwsTicketChecklistItem
 .LINK
Set-AtwsTicketChecklistItem

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
    [ValidateSet('CompletedByResourceID', 'TicketID')]
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

# Ticket Checklist Item ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Completed
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $Completed,

# Completed By Resource ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CompletedByResourceID,

# Completed date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CompletedDateTime,

# Important
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $Important,

# Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,255)]
    [string[]]
    $ItemName,

# Knowledgebase Article ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $KnowledgebaseArticleID,

# Position
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $Position,

# Ticket ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $TicketID,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Completed', 'CompletedByResourceID', 'CompletedDateTime', 'Important', 'ItemName', 'KnowledgebaseArticleID', 'Position', 'TicketID')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Completed', 'CompletedByResourceID', 'CompletedDateTime', 'Important', 'ItemName', 'KnowledgebaseArticleID', 'Position', 'TicketID')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Completed', 'CompletedByResourceID', 'CompletedDateTime', 'Important', 'ItemName', 'KnowledgebaseArticleID', 'Position', 'TicketID')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'CompletedByResourceID', 'CompletedDateTime', 'ItemName', 'KnowledgebaseArticleID', 'Position', 'TicketID')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'CompletedByResourceID', 'CompletedDateTime', 'ItemName', 'KnowledgebaseArticleID', 'Position', 'TicketID')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'CompletedByResourceID', 'CompletedDateTime', 'ItemName', 'KnowledgebaseArticleID', 'Position', 'TicketID')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'CompletedByResourceID', 'CompletedDateTime', 'ItemName', 'KnowledgebaseArticleID', 'Position', 'TicketID')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('ItemName')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('ItemName')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('ItemName')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('ItemName')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('ItemName')]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('CompletedDateTime')]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'TicketChecklistItem'
    
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
