#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsTaskNote
{


<#
.SYNOPSIS
This function get one or more TaskNote through the Autotask Web Services API.
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
NoteType
Publish

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.TaskNote[]]. This function outputs the Autotask.TaskNote that was returned by the API.
.EXAMPLE
Get-AtwsTaskNote -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsTaskNote -TaskNoteName SomeName
Returns the object with TaskNoteName 'SomeName', if any.
 .EXAMPLE
Get-AtwsTaskNote -TaskNoteName 'Some Name'
Returns the object with TaskNoteName 'Some Name', if any.
 .EXAMPLE
Get-AtwsTaskNote -TaskNoteName 'Some Name' -NotEquals TaskNoteName
Returns any objects with a TaskNoteName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsTaskNote -TaskNoteName SomeName* -Like TaskNoteName
Returns any object with a TaskNoteName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsTaskNote -TaskNoteName SomeName* -NotLike TaskNoteName
Returns any object with a TaskNoteName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsTaskNote -NoteType <PickList Label>
Returns any TaskNotes with property NoteType equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsTaskNote -NoteType <PickList Label> -NotEquals NoteType 
Returns any TaskNotes with property NoteType NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsTaskNote -NoteType <PickList Label1>, <PickList Label2>
Returns any TaskNotes with property NoteType equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsTaskNote -NoteType <PickList Label1>, <PickList Label2> -NotEquals NoteType
Returns any TaskNotes with property NoteType NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsTaskNote -Id 1234 -TaskNoteName SomeName* -NoteType <PickList Label1>, <PickList Label2> -Like TaskNoteName -NotEquals NoteType -GreaterThan Id
An example of a more complex query. This command returns any TaskNotes with Id GREATER THAN 1234, a TaskNoteName that matches the simple pattern SomeName* AND that has a NoteType that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsTaskNote
 .LINK
Set-AtwsTaskNote

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
    [ValidateSet('ImpersonatorUpdaterResourceID', 'TaskID')]
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

# Creator Resource
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CreatorResourceID,

# Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,32000)]
    [string[]]
    $Description,

# Task Note ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# LastActivityDate
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LastActivityDate,

# Note Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity TaskNote -FieldName NoteType -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity TaskNote -FieldName NoteType -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $NoteType,

# Publish
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity TaskNote -FieldName Publish -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity TaskNote -FieldName Publish -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $Publish,

# Task
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $TaskID,

# Title
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,250)]
    [string[]]
    $Title,

# Impersonator Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ImpersonatorCreatorResourceID,

# Impersonator Updater Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ImpersonatorUpdaterResourceID,

# Create Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CreateDateTime,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Publish', 'ImpersonatorCreatorResourceID', 'ImpersonatorUpdaterResourceID', 'CreatorResourceID', 'NoteType', 'Description', 'TaskID', 'CreateDateTime', 'Title', 'id', 'LastActivityDate')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Publish', 'ImpersonatorCreatorResourceID', 'ImpersonatorUpdaterResourceID', 'CreatorResourceID', 'NoteType', 'Description', 'TaskID', 'CreateDateTime', 'Title', 'id', 'LastActivityDate')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Publish', 'ImpersonatorCreatorResourceID', 'ImpersonatorUpdaterResourceID', 'CreatorResourceID', 'NoteType', 'Description', 'TaskID', 'CreateDateTime', 'Title', 'id', 'LastActivityDate')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreatorResourceID', 'Description', 'id', 'LastActivityDate', 'NoteType', 'Publish', 'TaskID', 'Title', 'ImpersonatorCreatorResourceID', 'ImpersonatorUpdaterResourceID', 'CreateDateTime')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreatorResourceID', 'Description', 'id', 'LastActivityDate', 'NoteType', 'Publish', 'TaskID', 'Title', 'ImpersonatorCreatorResourceID', 'ImpersonatorUpdaterResourceID', 'CreateDateTime')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreatorResourceID', 'Description', 'id', 'LastActivityDate', 'NoteType', 'Publish', 'TaskID', 'Title', 'ImpersonatorCreatorResourceID', 'ImpersonatorUpdaterResourceID', 'CreateDateTime')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreatorResourceID', 'Description', 'id', 'LastActivityDate', 'NoteType', 'Publish', 'TaskID', 'Title', 'ImpersonatorCreatorResourceID', 'ImpersonatorUpdaterResourceID', 'CreateDateTime')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'Title')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'Title')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'Title')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'Title')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'Title')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('LastActivityDate', 'CreateDateTime')]
    [string[]]
    $IsThisDay
  )

    begin { 
        $entityName = 'TaskNote'
    
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {
            $DebugPreference = 'Continue' 
        }
        else {
            # Respect configured preference
            $DebugPreference = $Script:Atws.Configuration.DebugPref
        }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

        if (!($PSCmdlet.MyInvocation.BoundParameters['Verbose'].IsPresent)) {
            # No local override of central preference. Load central preference
            $VerbosePreference = $Script:Atws.Configuration.VerbosePref
        }
    
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
            [string[]]$Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $entityName
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
