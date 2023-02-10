#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) Hugo Klemmestad. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsInvoice
{


<#
.SYNOPSIS
This function get one or more Invoice through the Autotask Web Services API.
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
TaxGroup
PaymentTerm

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Invoice[]]. This function outputs the Autotask.Invoice that was returned by the API.
.EXAMPLE
Get-AtwsInvoice -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsInvoice -InvoiceName SomeName
Returns the object with InvoiceName 'SomeName', if any.
 .EXAMPLE
Get-AtwsInvoice -InvoiceName 'Some Name'
Returns the object with InvoiceName 'Some Name', if any.
 .EXAMPLE
Get-AtwsInvoice -InvoiceName 'Some Name' -NotEquals InvoiceName
Returns any objects with a InvoiceName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsInvoice -InvoiceName SomeName* -Like InvoiceName
Returns any object with a InvoiceName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsInvoice -InvoiceName SomeName* -NotLike InvoiceName
Returns any object with a InvoiceName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsInvoice -TaxGroup 'PickList Label'
Returns any Invoices with property TaxGroup equal to the 'PickList Label'. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsInvoice -TaxGroup 'PickList Label' -NotEquals TaxGroup 
Returns any Invoices with property TaxGroup NOT equal to the 'PickList Label'.
 .EXAMPLE
Get-AtwsInvoice -TaxGroup 'PickList Label1', 'PickList Label2'
Returns any Invoices with property TaxGroup equal to EITHER 'PickList Label1' OR 'PickList Label2'.
 .EXAMPLE
Get-AtwsInvoice -TaxGroup 'PickList Label1', 'PickList Label2' -NotEquals TaxGroup
Returns any Invoices with property TaxGroup NOT equal to NEITHER 'PickList Label1' NOR 'PickList Label2'.
 .EXAMPLE
Get-AtwsInvoice -Id 1234 -InvoiceName SomeName* -TaxGroup 'PickList Label1', 'PickList Label2' -Like InvoiceName -NotEquals TaxGroup -GreaterThan Id
An example of a more complex query. This command returns any Invoices with Id GREATER THAN 1234, a InvoiceName that matches the simple pattern SomeName* AND that has a TaxGroup that is NOT equal to NEITHER 'PickList Label1' NOR 'PickList Label2'.

.NOTES
Related commands:
Set-AtwsInvoice

#>

  [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName='Filter', ConfirmImpact='None',
  HelpURI='https://github.com/ecitsolutions/Autotask/blob/master/Docs/Get-AtwsInvoice.md')]
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
    [ValidateSet('AccountID', 'CreatorResourceID', 'InvoiceEditorTemplateID', 'VoidedByResourceID')]
    [string]
    $GetReferenceEntityById,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# Account ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $AccountID,

# Batch ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BatchID,

# Comments
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string[]]
    $Comments,

# Create Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CreateDateTime,

# Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CreatorResourceID,

# From Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $FromDate,

# Invoice ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Invoice Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $InvoiceDateTime,

# Invoice Editor Template ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $InvoiceEditorTemplateID,

# Invoice Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $InvoiceNumber,

# Invoice Total
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $InvoiceTotal,

# Is Voided
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $IsVoided,

# Order Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,20)]
    [string[]]
    $OrderNumber,

# Paid Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $PaidDate,

# Payment Term ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Invoice -FieldName PaymentTerm -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Invoice -FieldName PaymentTerm -Label) + (Get-AtwsPicklistValue -Entity Invoice -FieldName PaymentTerm -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $PaymentTerm,

# Tax Region Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,200)]
    [string[]]
    $TaxRegionName,

# To Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ToDate,

# Total Tax Value
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $TotalTaxValue,

# Voided By Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $VoidedByResourceID,

# Voided Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $VoidedDate,

# Web Service Use Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $WebServiceDate,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'BatchID', 'Comments', 'CreateDateTime', 'CreatorResourceID', 'DueDate', 'FromDate', 'id', 'InvoiceDateTime', 'InvoiceEditorTemplateID', 'InvoiceNumber', 'InvoiceTotal', 'IsVoided', 'OrderNumber', 'PaidDate', 'PaymentTerm', 'TaxGroup', 'TaxRegionName', 'ToDate', 'TotalTaxValue', 'VoidedByResourceID', 'VoidedDate', 'WebServiceDate')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'BatchID', 'Comments', 'CreateDateTime', 'CreatorResourceID', 'DueDate', 'FromDate', 'id', 'InvoiceDateTime', 'InvoiceEditorTemplateID', 'InvoiceNumber', 'InvoiceTotal', 'IsVoided', 'OrderNumber', 'PaidDate', 'PaymentTerm', 'TaxGroup', 'TaxRegionName', 'ToDate', 'TotalTaxValue', 'VoidedByResourceID', 'VoidedDate', 'WebServiceDate')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'BatchID', 'Comments', 'CreateDateTime', 'CreatorResourceID', 'DueDate', 'FromDate', 'id', 'InvoiceDateTime', 'InvoiceEditorTemplateID', 'InvoiceNumber', 'InvoiceTotal', 'IsVoided', 'OrderNumber', 'PaidDate', 'PaymentTerm', 'TaxGroup', 'TaxRegionName', 'ToDate', 'TotalTaxValue', 'VoidedByResourceID', 'VoidedDate', 'WebServiceDate')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'BatchID', 'Comments', 'CreateDateTime', 'CreatorResourceID', 'DueDate', 'FromDate', 'id', 'InvoiceDateTime', 'InvoiceEditorTemplateID', 'InvoiceNumber', 'InvoiceTotal', 'OrderNumber', 'PaidDate', 'PaymentTerm', 'TaxGroup', 'TaxRegionName', 'ToDate', 'TotalTaxValue', 'VoidedByResourceID', 'VoidedDate', 'WebServiceDate')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'BatchID', 'Comments', 'CreateDateTime', 'CreatorResourceID', 'DueDate', 'FromDate', 'id', 'InvoiceDateTime', 'InvoiceEditorTemplateID', 'InvoiceNumber', 'InvoiceTotal', 'OrderNumber', 'PaidDate', 'PaymentTerm', 'TaxGroup', 'TaxRegionName', 'ToDate', 'TotalTaxValue', 'VoidedByResourceID', 'VoidedDate', 'WebServiceDate')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'BatchID', 'Comments', 'CreateDateTime', 'CreatorResourceID', 'DueDate', 'FromDate', 'id', 'InvoiceDateTime', 'InvoiceEditorTemplateID', 'InvoiceNumber', 'InvoiceTotal', 'OrderNumber', 'PaidDate', 'PaymentTerm', 'TaxGroup', 'TaxRegionName', 'ToDate', 'TotalTaxValue', 'VoidedByResourceID', 'VoidedDate', 'WebServiceDate')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'BatchID', 'Comments', 'CreateDateTime', 'CreatorResourceID', 'DueDate', 'FromDate', 'id', 'InvoiceDateTime', 'InvoiceEditorTemplateID', 'InvoiceNumber', 'InvoiceTotal', 'OrderNumber', 'PaidDate', 'PaymentTerm', 'TaxGroup', 'TaxRegionName', 'ToDate', 'TotalTaxValue', 'VoidedByResourceID', 'VoidedDate', 'WebServiceDate')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Comments', 'InvoiceNumber', 'OrderNumber', 'TaxRegionName')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Comments', 'InvoiceNumber', 'OrderNumber', 'TaxRegionName')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Comments', 'InvoiceNumber', 'OrderNumber', 'TaxRegionName')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Comments', 'InvoiceNumber', 'OrderNumber', 'TaxRegionName')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Comments', 'InvoiceNumber', 'OrderNumber', 'TaxRegionName')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDateTime', 'DueDate', 'FromDate', 'InvoiceDateTime', 'PaidDate', 'ToDate', 'VoidedDate', 'WebServiceDate')]
    [string[]]
    $IsThisDay
  )

    begin {
        $entityName = 'Invoice'

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

            # What is the highest number of values for a parameter and is it higher than 200?
            $max = $PSBoundParameters.Values[0].length | Measure-Object -Maximum

            # If the count is less than or equal to 200 we pass PSBoundParameters as is
            if ($max.Maximum -le 200) {
                [collections.generic.list[string]]$Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $entityName
                $iterations.Add($Filter)
            }
            # More than 200 values. This will cause a SQL query nested too much error. Break a single parameter
            # into segments and create multiple queries with max 200 values
            else {
                
                # Find the parameter with the $max.Maximum number of items
                foreach ($param in $PSCmdlet.MyInvocation.BoundParameters.GetEnumerator() ) {
                    # When we have found the right parameter, stop iterating
                    if ($param.Value.length -eq $max.Maximum) { break }
                }
     
                # Deduplicate the value list or the same ID may be included in more than 1 query
                $outerLoop = $PSCmdlet.MyInvocation.BoundParameters.$($param.key) | Sort-Object -Unique

                Write-Verbose ('{0}: Received {1} objects containing {2} unique values for parameter {3}' -f $MyInvocation.MyCommand.Name, $count, $outerLoop.Count, $param.key)
                  
                for ($s = 0; $s -lt $outerLoop.count; $s += 200) {
                    $e = $s + 199
                    if ($e -ge $outerLoop.count) {
                        $e = $outerLoop.count - 1
                    }
                  
                    # Make writable of BoundParameters
                    $BoundParameters = $PSCmdlet.MyInvocation.BoundParameters

                    # make a selection
                    $BoundParameters.$($param.key) = $outerLoop[$s .. $e]

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
                    # Write a debug message with detailed information to developers
                    $reason = ("{0}: {1}" -f $_.CategoryInfo.Category, $_.CategoryInfo.Reason)
                    $message = "{2}: {0}`r`n`r`nLine:{1}`r`n`r`nScript stacktrace:`r`n{3}" -f $_.Exception.Message, $_.InvocationInfo.Line, $reason, $_.ScriptStackTrace
                    Write-Debug $message

                    # Pass on the error
                    $PSCmdlet.ThrowTerminatingError($_)
                    return
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
