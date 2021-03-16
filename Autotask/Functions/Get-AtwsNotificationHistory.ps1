#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsNotificationHistory
{


<#
.SYNOPSIS
This function get one or more NotificationHistory through the Autotask Web Services API.
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
NotificationHistoryTypeID
EntityTitle
EntityNumber

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.NotificationHistory[]]. This function outputs the Autotask.NotificationHistory that was returned by the API.
.EXAMPLE
Get-AtwsNotificationHistory -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsNotificationHistory -NotificationHistoryName SomeName
Returns the object with NotificationHistoryName 'SomeName', if any.
 .EXAMPLE
Get-AtwsNotificationHistory -NotificationHistoryName 'Some Name'
Returns the object with NotificationHistoryName 'Some Name', if any.
 .EXAMPLE
Get-AtwsNotificationHistory -NotificationHistoryName 'Some Name' -NotEquals NotificationHistoryName
Returns any objects with a NotificationHistoryName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsNotificationHistory -NotificationHistoryName SomeName* -Like NotificationHistoryName
Returns any object with a NotificationHistoryName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsNotificationHistory -NotificationHistoryName SomeName* -NotLike NotificationHistoryName
Returns any object with a NotificationHistoryName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsNotificationHistory -NotificationHistoryTypeID <PickList Label>
Returns any NotificationHistorys with property NotificationHistoryTypeID equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsNotificationHistory -NotificationHistoryTypeID <PickList Label> -NotEquals NotificationHistoryTypeID 
Returns any NotificationHistorys with property NotificationHistoryTypeID NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsNotificationHistory -NotificationHistoryTypeID <PickList Label1>, <PickList Label2>
Returns any NotificationHistorys with property NotificationHistoryTypeID equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsNotificationHistory -NotificationHistoryTypeID <PickList Label1>, <PickList Label2> -NotEquals NotificationHistoryTypeID
Returns any NotificationHistorys with property NotificationHistoryTypeID NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsNotificationHistory -Id 1234 -NotificationHistoryName SomeName* -NotificationHistoryTypeID <PickList Label1>, <PickList Label2> -Like NotificationHistoryName -NotEquals NotificationHistoryTypeID -GreaterThan Id
An example of a more complex query. This command returns any NotificationHistorys with Id GREATER THAN 1234, a NotificationHistoryName that matches the simple pattern SomeName* AND that has a NotificationHistoryTypeID that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.


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
    [ValidateSet('AccountID', 'InitiatingContactID', 'InitiatingResourceID', 'OpportunityID', 'ProjectID', 'QuoteID', 'TaskID', 'TicketID', 'TimeEntryID')]
    [string]
    $GetReferenceEntityById,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# Client
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $AccountID,

# Entity Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity NotificationHistory -FieldName EntityNumber -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity NotificationHistory -FieldName EntityNumber -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $EntityNumber,

# Entity Title
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity NotificationHistory -FieldName EntityTitle -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity NotificationHistory -FieldName EntityTitle -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $EntityTitle,

# ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Initiating Contact
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $InitiatingContactID,

# Initiating Resource
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $InitiatingResourceID,

# Is Template Active
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $IsActive,

# Is Template Deleted
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $IsDeleted,

# Is Template Job
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $IsTemplateJob,

# Notification History Type Id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity NotificationHistory -FieldName NotificationHistoryTypeID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity NotificationHistory -FieldName NotificationHistoryTypeID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $NotificationHistoryTypeID,

# Notification Sent Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $NotificationSentTime,

# Opportunity
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $OpportunityID,

# Project
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $ProjectID,

# Quote
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $QuoteID,

# Recipient Display Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,200)]
    [string[]]
    $RecipientDisplayName,

# Recipient Email Address
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string[]]
    $RecipientEmailAddress,

# Task
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $TaskID,

# Template Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $TemplateName,

# Ticket
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $TicketID,

# Time Entry
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $TimeEntryID,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('OpportunityID', 'ProjectID', 'TaskID', 'RecipientEmailAddress', 'NotificationHistoryTypeID', 'TemplateName', 'RecipientDisplayName', 'InitiatingContactID', 'IsActive', 'NotificationSentTime', 'EntityTitle', 'EntityNumber', 'id', 'InitiatingResourceID', 'TimeEntryID', 'QuoteID', 'IsDeleted', 'TicketID', 'IsTemplateJob', 'AccountID')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('OpportunityID', 'ProjectID', 'TaskID', 'RecipientEmailAddress', 'NotificationHistoryTypeID', 'TemplateName', 'RecipientDisplayName', 'InitiatingContactID', 'IsActive', 'NotificationSentTime', 'EntityTitle', 'EntityNumber', 'id', 'InitiatingResourceID', 'TimeEntryID', 'QuoteID', 'IsDeleted', 'TicketID', 'IsTemplateJob', 'AccountID')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('OpportunityID', 'ProjectID', 'TaskID', 'RecipientEmailAddress', 'NotificationHistoryTypeID', 'TemplateName', 'RecipientDisplayName', 'InitiatingContactID', 'IsActive', 'NotificationSentTime', 'EntityTitle', 'EntityNumber', 'id', 'InitiatingResourceID', 'TimeEntryID', 'QuoteID', 'IsDeleted', 'TicketID', 'IsTemplateJob', 'AccountID')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'NotificationSentTime', 'TemplateName', 'NotificationHistoryTypeID', 'EntityTitle', 'EntityNumber', 'InitiatingResourceID', 'InitiatingContactID', 'RecipientEmailAddress', 'RecipientDisplayName', 'AccountID', 'QuoteID', 'OpportunityID', 'ProjectID', 'TaskID', 'TicketID', 'TimeEntryID')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'NotificationSentTime', 'TemplateName', 'NotificationHistoryTypeID', 'EntityTitle', 'EntityNumber', 'InitiatingResourceID', 'InitiatingContactID', 'RecipientEmailAddress', 'RecipientDisplayName', 'AccountID', 'QuoteID', 'OpportunityID', 'ProjectID', 'TaskID', 'TicketID', 'TimeEntryID')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'NotificationSentTime', 'TemplateName', 'NotificationHistoryTypeID', 'EntityTitle', 'EntityNumber', 'InitiatingResourceID', 'InitiatingContactID', 'RecipientEmailAddress', 'RecipientDisplayName', 'AccountID', 'QuoteID', 'OpportunityID', 'ProjectID', 'TaskID', 'TicketID', 'TimeEntryID')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'NotificationSentTime', 'TemplateName', 'NotificationHistoryTypeID', 'EntityTitle', 'EntityNumber', 'InitiatingResourceID', 'InitiatingContactID', 'RecipientEmailAddress', 'RecipientDisplayName', 'AccountID', 'QuoteID', 'OpportunityID', 'ProjectID', 'TaskID', 'TicketID', 'TimeEntryID')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('TemplateName', 'EntityTitle', 'EntityNumber', 'RecipientEmailAddress', 'RecipientDisplayName')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('TemplateName', 'EntityTitle', 'EntityNumber', 'RecipientEmailAddress', 'RecipientDisplayName')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('TemplateName', 'EntityTitle', 'EntityNumber', 'RecipientEmailAddress', 'RecipientDisplayName')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('TemplateName', 'EntityTitle', 'EntityNumber', 'RecipientEmailAddress', 'RecipientDisplayName')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('TemplateName', 'EntityTitle', 'EntityNumber', 'RecipientEmailAddress', 'RecipientDisplayName')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('NotificationSentTime')]
    [string[]]
    $IsThisDay
  )

    begin {
        $entityName = 'NotificationHistory'

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

        $result = [collections.generic.list[psobject]]::new()
        $iterations = [collections.generic.list[psobject]]::new()
    }


    process {
        # Parameterset Get_All has a single parameter: -All
        # Set the Filter manually to get every single object of this type
        if ($PSCmdlet.ParameterSetName -eq 'Get_all') {
            $Filter = @('id', '-ge', 0)
            $iterations.Add($Filter)
        }
        # So it is not -All. If Filter does not exist it has to be By_parameters
        elseif (-not ($Filter)) {

            Write-Debug ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)

           
            # Count the values of the first parameter passed. We will not try do to this on more than 1 parameter, nor on any 
            # other parameter than the first. This is lazy, but efficient.
            $count = $PSBoundParameters.Values[0].count

            # If the count is less than or equal to 200 we pass PSBoundParameters as is
            if ($count -le 200) {
                [collections.generic.list[string]]$Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $entityName
                $iterations.Add($Filter)
            }
            # More than 200 values. This will cause a SQL query nested too much. Break a single parameter
            # into segments and create multiple queries with max 200 values
            else {
                # Deduplicate the value list or the same ID may be included in more than 1 query
                $outerLoop = $PSBoundParameters.Values[0] | Sort-Object -Unique

                Write-Verbose ('{0}: Received {1} objects containing {2} unique values for parameter {3}' -f $MyInvocation.MyCommand.Name, $count, $outerLoop.Count, $param)

                # Make a writable copy of PSBoundParameters
                $BoundParameters = $PSBoundParameters
                for ($i = 0; $i -lt $outerLoop.count; $i += 200) {
                    $j = $i + 199
                    if ($j -ge $outerLoop.count) {
                        $j = $outerLoop.count - 1
                    }

                    # make a selection
                    $BoundParameters[$param] = $outerLoop[$i .. $j]

                    Write-Verbose ('{0}: Asking for {1} values {2} to {3}' -f $MyInvocation.MyCommand.Name, $param, $i, $j)

                    # Convert named parameters to a filter definition that can be parsed to QueryXML
                    [collections.generic.list[string]]$Filter = ConvertTo-AtwsFilter -BoundParameters $BoundParameters -EntityName $entityName
                    $iterations.Add($Filter)
                }
            }
        }
        # Not parameters, nor Get_all. There are only three parameter sets, so now we know
        # that we were passed a Filter
        else {

            Write-Debug ('{0}: Query based on manual filter, parsing' -F $MyInvocation.MyCommand.Name)

            # Parse the filter string and expand variables in _this_ scope (dot-sourcing)
            # or the variables will not be available and expansion will fail
            $Filter = . Update-AtwsFilter -Filterstring $Filter
            $iterations.Add($Filter)
        }

        # Prepare shouldProcess comments
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to query the Autotask Web API for {1}(s).' -F $caption, $entityName
        $verboseWarning = '{0}: About to query the Autotask Web API for {1}(s). Do you want to continue?' -F $caption, $entityName

        # Lets do it and say we didn't!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) {
            foreach ($Filter in $iterations) {

                try {
                    # Make the query and pass the optional parameters to Get-AtwsData
                    # Force list even if result is only 1 object to be compatible with addrange()
                    [collections.generic.list[psobject]]$response = Get-AtwsData -Entity $entityName -Filter $Filter `
                        -NoPickListLabel:$NoPickListLabel.IsPresent `
                        -GetReferenceEntityById $GetReferenceEntityById
                }
                catch {
                    write-host "ERROR: " -ForegroundColor Red -NoNewline
                    write-host $_.Exception.Message
                    write-host ("{0}: {1}" -f $_.CategoryInfo.Category,$_.CategoryInfo.Reason) -ForegroundColor Cyan
                    $_.ScriptStackTrace -split '\n' | ForEach-Object {
                        Write-host "  |  " -ForegroundColor Cyan -NoNewline
                        Write-host $_
                    }
                }
                # Add response to result
                $result.AddRange($response)

                Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $result.Count)
            }
        }
    }

    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        if ($result) {
            Return [array]$result
        }
    }


}
