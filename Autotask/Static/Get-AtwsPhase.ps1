#Requires -Version 4.0
#Version 1.6.2.17
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsPhase
{


<#
.SYNOPSIS
This function get one or more Phase through the Autotask Web Services API.
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

Phase
 Task

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Phase[]]. This function outputs the Autotask.Phase that was returned by the API.
.EXAMPLE
Get-AtwsPhase -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsPhase -PhaseName SomeName
Returns the object with PhaseName 'SomeName', if any.
 .EXAMPLE
Get-AtwsPhase -PhaseName 'Some Name'
Returns the object with PhaseName 'Some Name', if any.
 .EXAMPLE
Get-AtwsPhase -PhaseName 'Some Name' -NotEquals PhaseName
Returns any objects with a PhaseName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsPhase -PhaseName SomeName* -Like PhaseName
Returns any object with a PhaseName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsPhase -PhaseName SomeName* -NotLike PhaseName
Returns any object with a PhaseName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.

.LINK
New-AtwsPhase
 .LINK
Set-AtwsPhase

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
    [ValidateSet('CreatorResourceID', 'ParentPhaseID', 'ProjectID')]
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
    [ValidateSet('Phase:ParentPhaseID', 'Task:PhaseID')]
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

# Phase Creation Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CreateDate,

# Phase Creator
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CreatorResourceID,

# Phase Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,8000)]
    [string[]]
    $Description,

# Phase End Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $DueDate,

# Phase Estimated Hours
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $EstimatedHours,

# Phase External ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $ExternalID,

# Phase ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Phase Last Activity Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LastActivityDateTime,

# Parent Phase
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ParentPhaseID,

# Phase Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $PhaseNumber,

# Project
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $ProjectID,

# Is Scheduled
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $Scheduled,

# Phase Start Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $StartDate,

# Phase Title
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,255)]
    [string[]]
    $Title,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'CreatorResourceID', 'Description', 'DueDate', 'EstimatedHours', 'ExternalID', 'id', 'LastActivityDateTime', 'ParentPhaseID', 'PhaseNumber', 'ProjectID', 'Scheduled', 'StartDate', 'Title')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'CreatorResourceID', 'Description', 'DueDate', 'EstimatedHours', 'ExternalID', 'id', 'LastActivityDateTime', 'ParentPhaseID', 'PhaseNumber', 'ProjectID', 'Scheduled', 'StartDate', 'Title')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'CreatorResourceID', 'Description', 'DueDate', 'EstimatedHours', 'ExternalID', 'id', 'LastActivityDateTime', 'ParentPhaseID', 'PhaseNumber', 'ProjectID', 'Scheduled', 'StartDate', 'Title')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'CreatorResourceID', 'Description', 'DueDate', 'EstimatedHours', 'ExternalID', 'id', 'LastActivityDateTime', 'ParentPhaseID', 'PhaseNumber', 'ProjectID', 'StartDate', 'Title')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'CreatorResourceID', 'Description', 'DueDate', 'EstimatedHours', 'ExternalID', 'id', 'LastActivityDateTime', 'ParentPhaseID', 'PhaseNumber', 'ProjectID', 'StartDate', 'Title')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'CreatorResourceID', 'Description', 'DueDate', 'EstimatedHours', 'ExternalID', 'id', 'LastActivityDateTime', 'ParentPhaseID', 'PhaseNumber', 'ProjectID', 'StartDate', 'Title')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'CreatorResourceID', 'Description', 'DueDate', 'EstimatedHours', 'ExternalID', 'id', 'LastActivityDateTime', 'ParentPhaseID', 'PhaseNumber', 'ProjectID', 'StartDate', 'Title')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'ExternalID', 'PhaseNumber', 'Title')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'ExternalID', 'PhaseNumber', 'Title')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'ExternalID', 'PhaseNumber', 'Title')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'ExternalID', 'PhaseNumber', 'Title')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'ExternalID', 'PhaseNumber', 'Title')]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'DueDate', 'LastActivityDateTime', 'StartDate')]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'Phase'
    
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
