﻿#Requires -Version 4.0
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

Additional operators for [string] parameters are:
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
    [ValidateSet('CompletedByResourceID', 'TicketID')]
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

# Ticket Checklist Item ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Completed
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $Completed,

# Completed By Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CompletedByResourceID,

# Completed date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CompletedDateTime,

# Important
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $Important,

# Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,255)]
    [string[]]
    $ItemName,

# Knowledgebase Article ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $KnowledgebaseArticleID,

# Position
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $Position,

# Ticket ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $TicketID,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Completed', 'CompletedByResourceID', 'CompletedDateTime', 'Important', 'ItemName', 'KnowledgebaseArticleID', 'Position', 'TicketID')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Completed', 'CompletedByResourceID', 'CompletedDateTime', 'Important', 'ItemName', 'KnowledgebaseArticleID', 'Position', 'TicketID')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Completed', 'CompletedByResourceID', 'CompletedDateTime', 'Important', 'ItemName', 'KnowledgebaseArticleID', 'Position', 'TicketID')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'CompletedByResourceID', 'CompletedDateTime', 'ItemName', 'KnowledgebaseArticleID', 'Position', 'TicketID')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'CompletedByResourceID', 'CompletedDateTime', 'ItemName', 'KnowledgebaseArticleID', 'Position', 'TicketID')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'CompletedByResourceID', 'CompletedDateTime', 'ItemName', 'KnowledgebaseArticleID', 'Position', 'TicketID')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'CompletedByResourceID', 'CompletedDateTime', 'ItemName', 'KnowledgebaseArticleID', 'Position', 'TicketID')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ItemName')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ItemName')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ItemName')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ItemName')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ItemName')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CompletedDateTime')]
    [string[]]
    $IsThisDay
  )

    begin { 
        $entityName = 'TicketChecklistItem'
    
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
