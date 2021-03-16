#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsTicketChangeRequestApproval
{


<#
.SYNOPSIS
This function get one or more TicketChangeRequestApproval through the Autotask Web Services API.
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


Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.TicketChangeRequestApproval[]]. This function outputs the Autotask.TicketChangeRequestApproval that was returned by the API.
.EXAMPLE
Get-AtwsTicketChangeRequestApproval -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsTicketChangeRequestApproval -TicketChangeRequestApprovalName SomeName
Returns the object with TicketChangeRequestApprovalName 'SomeName', if any.
 .EXAMPLE
Get-AtwsTicketChangeRequestApproval -TicketChangeRequestApprovalName 'Some Name'
Returns the object with TicketChangeRequestApprovalName 'Some Name', if any.
 .EXAMPLE
Get-AtwsTicketChangeRequestApproval -TicketChangeRequestApprovalName 'Some Name' -NotEquals TicketChangeRequestApprovalName
Returns any objects with a TicketChangeRequestApprovalName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsTicketChangeRequestApproval -TicketChangeRequestApprovalName SomeName* -Like TicketChangeRequestApprovalName
Returns any object with a TicketChangeRequestApprovalName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsTicketChangeRequestApproval -TicketChangeRequestApprovalName SomeName* -NotLike TicketChangeRequestApprovalName
Returns any object with a TicketChangeRequestApprovalName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.

.LINK
New-AtwsTicketChangeRequestApproval
 .LINK
Remove-AtwsTicketChangeRequestApproval

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
    [ValidateSet('ContactID', 'ResourceID', 'TicketID')]
    [string]
    $GetReferenceEntityById,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# Approve Reject Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ApproveRejectDateTime,

# Approve Reject Note
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string[]]
    $ApproveRejectNote,

# Contact ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ContactID,

# Change Request Ticket Vote ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $id,

# Is Approved
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $IsApproved,

# Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ResourceID,

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
    [ValidateSet('ApproveRejectDateTime', 'ContactID', 'ResourceID', 'TicketID', 'id', 'ApproveRejectNote', 'IsApproved')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ApproveRejectDateTime', 'ContactID', 'ResourceID', 'TicketID', 'id', 'ApproveRejectNote', 'IsApproved')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ApproveRejectDateTime', 'ContactID', 'ResourceID', 'TicketID', 'id', 'ApproveRejectNote', 'IsApproved')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TicketID', 'ResourceID', 'ContactID', 'ApproveRejectDateTime', 'ApproveRejectNote')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TicketID', 'ResourceID', 'ContactID', 'ApproveRejectDateTime', 'ApproveRejectNote')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TicketID', 'ResourceID', 'ContactID', 'ApproveRejectDateTime', 'ApproveRejectNote')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TicketID', 'ResourceID', 'ContactID', 'ApproveRejectDateTime', 'ApproveRejectNote')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ApproveRejectNote')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ApproveRejectNote')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ApproveRejectNote')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ApproveRejectNote')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ApproveRejectNote')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ApproveRejectDateTime')]
    [string[]]
    $IsThisDay
  )

    begin {
        $entityName = 'TicketChangeRequestApproval'

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
