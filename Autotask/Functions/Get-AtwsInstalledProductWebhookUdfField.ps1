#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsInstalledProductWebhookUdfField
{


<#
.SYNOPSIS
This function get one or more InstalledProductWebhookUdfField through the Autotask Web Services API.
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
UdfFieldID

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.InstalledProductWebhookUdfField[]]. This function outputs the Autotask.InstalledProductWebhookUdfField that was returned by the API.
.EXAMPLE
Get-AtwsInstalledProductWebhookUdfField -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsInstalledProductWebhookUdfField -InstalledProductWebhookUdfFieldName SomeName
Returns the object with InstalledProductWebhookUdfFieldName 'SomeName', if any.
 .EXAMPLE
Get-AtwsInstalledProductWebhookUdfField -InstalledProductWebhookUdfFieldName 'Some Name'
Returns the object with InstalledProductWebhookUdfFieldName 'Some Name', if any.
 .EXAMPLE
Get-AtwsInstalledProductWebhookUdfField -InstalledProductWebhookUdfFieldName 'Some Name' -NotEquals InstalledProductWebhookUdfFieldName
Returns any objects with a InstalledProductWebhookUdfFieldName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsInstalledProductWebhookUdfField -InstalledProductWebhookUdfFieldName SomeName* -Like InstalledProductWebhookUdfFieldName
Returns any object with a InstalledProductWebhookUdfFieldName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsInstalledProductWebhookUdfField -InstalledProductWebhookUdfFieldName SomeName* -NotLike InstalledProductWebhookUdfFieldName
Returns any object with a InstalledProductWebhookUdfFieldName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsInstalledProductWebhookUdfField -UdfFieldID <PickList Label>
Returns any InstalledProductWebhookUdfFields with property UdfFieldID equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsInstalledProductWebhookUdfField -UdfFieldID <PickList Label> -NotEquals UdfFieldID 
Returns any InstalledProductWebhookUdfFields with property UdfFieldID NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsInstalledProductWebhookUdfField -UdfFieldID <PickList Label1>, <PickList Label2>
Returns any InstalledProductWebhookUdfFields with property UdfFieldID equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsInstalledProductWebhookUdfField -UdfFieldID <PickList Label1>, <PickList Label2> -NotEquals UdfFieldID
Returns any InstalledProductWebhookUdfFields with property UdfFieldID NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsInstalledProductWebhookUdfField -Id 1234 -InstalledProductWebhookUdfFieldName SomeName* -UdfFieldID <PickList Label1>, <PickList Label2> -Like InstalledProductWebhookUdfFieldName -NotEquals UdfFieldID -GreaterThan Id
An example of a more complex query. This command returns any InstalledProductWebhookUdfFields with Id GREATER THAN 1234, a InstalledProductWebhookUdfFieldName that matches the simple pattern SomeName* AND that has a UdfFieldID that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsInstalledProductWebhookUdfField
 .LINK
Remove-AtwsInstalledProductWebhookUdfField
 .LINK
Set-AtwsInstalledProductWebhookUdfField

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
    [ValidateSet('WebhookID')]
    [string]
    $GetReferenceEntityById,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# Configuration Item Webhook UDF Field ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Is Display Always Field
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $IsDisplayAlwaysField,

# Is Subscribed Field
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $IsSubscribedField,

# UDF Field ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProductWebhookUdfField -FieldName UdfFieldID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InstalledProductWebhookUdfField -FieldName UdfFieldID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $UdfFieldID,

# Webhook ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $WebhookID,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('IsDisplayAlwaysField', 'WebhookID', 'id', 'IsSubscribedField', 'UdfFieldID')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('IsDisplayAlwaysField', 'WebhookID', 'id', 'IsSubscribedField', 'UdfFieldID')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('IsDisplayAlwaysField', 'WebhookID', 'id', 'IsSubscribedField', 'UdfFieldID')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'WebhookID', 'UdfFieldID')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'WebhookID', 'UdfFieldID')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'WebhookID', 'UdfFieldID')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'WebhookID', 'UdfFieldID')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $IsThisDay
  )

    begin {
        $entityName = 'InstalledProductWebhookUdfField'

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

        $result = [Collections.ArrayList]::new()
        $iterations = [Collections.Arraylist]::new()
    }


    process {
        # Parameterset Get_All has a single parameter: -All
        # Set the Filter manually to get every single object of this type
        if ($PSCmdlet.ParameterSetName -eq 'Get_all') {
            $Filter = @('id', '-ge', 0)
            [void]$iterations.Add($Filter)
        }
        # So it is not -All. If Filter does not exist it has to be By_parameters
        elseif (-not ($Filter)) {

            Write-Debug ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)

           
            # Extract the parameter content, sort it ascending (we assume it is an Id field)
            # and deduplicate
            $count = $PSBoundParameters.Values[0].count

            # Check number of values. If it is less than or equal to 200 we pass PSBoundParameters as is
            if ($count -le 200) {
                [string[]]$Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $entityName
                [void]$iterations.Add($Filter)
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
                    [string[]]$Filter = ConvertTo-AtwsFilter -BoundParameters $BoundParameters -EntityName $entityName
                    [void]$iterations.Add($Filter)
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
            [void]$iterations.Add($Filter)
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
                    $response = Get-AtwsData -Entity $entityName -Filter $Filter `
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
                # If multiple items use .addrange(). If a single item use .add()
                if ($response.count -gt 1) {
                    [void]$result.AddRange($response)
                }
                else {
                    [void]$result.Add($response)
                }
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
