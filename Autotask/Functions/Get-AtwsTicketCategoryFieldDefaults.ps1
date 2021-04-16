#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
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

Additional operators for [string] parameters are:
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
    [ValidateSet('BusinessDivisionSubdivisionID', 'TicketCategoryID', 'WorkTypeID')]
    [string]
    $GetReferenceEntityById,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# Business Division Subdivision ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BusinessDivisionSubdivisionID,

# Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,8000)]
    [string[]]
    $Description,

# Estimated Hours
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $EstimatedHours,

# Ticket Category Field Defaults ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Issue Type ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity TicketCategoryFieldDefaults -FieldName IssueTypeID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity TicketCategoryFieldDefaults -FieldName IssueTypeID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $IssueTypeID,

# Priority
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity TicketCategoryFieldDefaults -FieldName Priority -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity TicketCategoryFieldDefaults -FieldName Priority -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $Priority,

# Purchase Order Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $PurchaseOrderNumber,

# Queue ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity TicketCategoryFieldDefaults -FieldName QueueID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity TicketCategoryFieldDefaults -FieldName QueueID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $QueueID,

# Resolution
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,8000)]
    [string[]]
    $Resolution,

# Service Level Agreement ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity TicketCategoryFieldDefaults -FieldName ServiceLevelAgreementID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity TicketCategoryFieldDefaults -FieldName ServiceLevelAgreementID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $ServiceLevelAgreementID,

# Source ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity TicketCategoryFieldDefaults -FieldName SourceID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity TicketCategoryFieldDefaults -FieldName SourceID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $SourceID,

# Status
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity TicketCategoryFieldDefaults -FieldName Status -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity TicketCategoryFieldDefaults -FieldName Status -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $Status,

# Sub-Issue Type ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity TicketCategoryFieldDefaults -FieldName SubIssueTypeID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity TicketCategoryFieldDefaults -FieldName SubIssueTypeID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $SubIssueTypeID,

# Ticket Category ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $TicketCategoryID,

# Ticket Type ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity TicketCategoryFieldDefaults -FieldName TicketTypeID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity TicketCategoryFieldDefaults -FieldName TicketTypeID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $TicketTypeID,

# Title
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string[]]
    $Title,

# Work Type ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $WorkTypeID,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('BusinessDivisionSubdivisionID', 'Description', 'EstimatedHours', 'id', 'IssueTypeID', 'Priority', 'PurchaseOrderNumber', 'QueueID', 'Resolution', 'ServiceLevelAgreementID', 'SourceID', 'Status', 'SubIssueTypeID', 'TicketCategoryID', 'TicketTypeID', 'Title', 'WorkTypeID')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('BusinessDivisionSubdivisionID', 'Description', 'EstimatedHours', 'id', 'IssueTypeID', 'Priority', 'PurchaseOrderNumber', 'QueueID', 'Resolution', 'ServiceLevelAgreementID', 'SourceID', 'Status', 'SubIssueTypeID', 'TicketCategoryID', 'TicketTypeID', 'Title', 'WorkTypeID')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('BusinessDivisionSubdivisionID', 'Description', 'EstimatedHours', 'id', 'IssueTypeID', 'Priority', 'PurchaseOrderNumber', 'QueueID', 'Resolution', 'ServiceLevelAgreementID', 'SourceID', 'Status', 'SubIssueTypeID', 'TicketCategoryID', 'TicketTypeID', 'Title', 'WorkTypeID')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('BusinessDivisionSubdivisionID', 'Description', 'EstimatedHours', 'id', 'IssueTypeID', 'Priority', 'PurchaseOrderNumber', 'QueueID', 'Resolution', 'ServiceLevelAgreementID', 'SourceID', 'Status', 'SubIssueTypeID', 'TicketCategoryID', 'TicketTypeID', 'Title', 'WorkTypeID')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('BusinessDivisionSubdivisionID', 'Description', 'EstimatedHours', 'id', 'IssueTypeID', 'Priority', 'PurchaseOrderNumber', 'QueueID', 'Resolution', 'ServiceLevelAgreementID', 'SourceID', 'Status', 'SubIssueTypeID', 'TicketCategoryID', 'TicketTypeID', 'Title', 'WorkTypeID')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('BusinessDivisionSubdivisionID', 'Description', 'EstimatedHours', 'id', 'IssueTypeID', 'Priority', 'PurchaseOrderNumber', 'QueueID', 'Resolution', 'ServiceLevelAgreementID', 'SourceID', 'Status', 'SubIssueTypeID', 'TicketCategoryID', 'TicketTypeID', 'Title', 'WorkTypeID')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('BusinessDivisionSubdivisionID', 'Description', 'EstimatedHours', 'id', 'IssueTypeID', 'Priority', 'PurchaseOrderNumber', 'QueueID', 'Resolution', 'ServiceLevelAgreementID', 'SourceID', 'Status', 'SubIssueTypeID', 'TicketCategoryID', 'TicketTypeID', 'Title', 'WorkTypeID')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'PurchaseOrderNumber', 'Resolution', 'Title')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'PurchaseOrderNumber', 'Resolution', 'Title')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'PurchaseOrderNumber', 'Resolution', 'Title')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'PurchaseOrderNumber', 'Resolution', 'Title')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'PurchaseOrderNumber', 'Resolution', 'Title')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $IsThisDay
  )

    begin {
        $entityName = 'TicketCategoryFieldDefaults'

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
            $count = $count = $PSCmdlet.MyInvocation.BoundParameters.Values[0].Length[0]


            # If the count is less than or equal to 200 we pass PSBoundParameters as is
            if ($count -le 200) {
                [collections.generic.list[string]]$Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $entityName
                $iterations.Add($Filter)
            }
            # More than 200 values. This will cause a SQL query nested too much. Break a single parameter
            # into segments and create multiple queries with max 200 values
            else {
                #Workaround as normal Array indexing does not work on bound parameter keys.
                $f = $false
                $Param = $PSCmdlet.MyInvocation.BoundParameters.GetEnumerator().ForEach{
                    if (-not $f) {
                        $_.Key
                        $f = $true
                    }
                }[0]
        
                # Deduplicate the value list or the same ID may be included in more than 1 query
                $outerLoop = $PSCmdlet.MyInvocation.BoundParameters.$($Param) | Sort-Object -Unique

                Write-Verbose ('{0}: Received {1} objects containing {2} unique values for parameter {3}' -f $MyInvocation.MyCommand.Name, $count, $outerLoop.Count, $param)
                  
                $iterated = [System.Collections.Generic.List[psobject]]::new()
                for ($s = 0; $s -lt $outerLoop.count; $s += 200) {
                    $e = $s + 199
                    if ($e -ge $outerLoop.count) {
                        $e = $outerLoop.count - 1
                    }
                  
                    # Make writable of BoundParameters
                    $BoundParameters = $PSCmdlet.MyInvocation.BoundParameters

                    # make a selection
                    $BoundParameters.$($param) = $outerLoop[$s .. $e]
                    $BoundParameters.$($param).ForEach{ $iterated.Add($_) }

                    Write-Verbose ('{0}: Asking for {1} values {2} to {3}' -f $MyInvocation.MyCommand.Name, $param, $s, $e)

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
                    $reason = ("{0}: {1}" -f $_.CategoryInfo.Category, $_.CategoryInfo.Reason)
                    $message = "Autotask API Responded with error:`r`n`r`n{0}`r`n`r`n{1} {2}" -f $_.Exception.Message, $reason, $_.ScriptStackTrace
                    throw [System.Configuration.Provider.ProviderException]::new($message)
                }
                # Add response to result - if there are any response to add
                if ($response.count -gt 0) { 
                    $result.AddRange($response)
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
