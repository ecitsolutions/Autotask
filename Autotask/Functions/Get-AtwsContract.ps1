#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsContract
{


<#
.SYNOPSIS
This function get one or more Contract through the Autotask Web Services API.
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
BillingPreference
ContractCategory
ContractPeriodType
ContractType
Status
ServiceLevelAgreementID
TimeReportingRequiresStartAndStopTimes

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Contract[]]. This function outputs the Autotask.Contract that was returned by the API.
.EXAMPLE
Get-AtwsContract -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsContract -ContractName SomeName
Returns the object with ContractName 'SomeName', if any.
 .EXAMPLE
Get-AtwsContract -ContractName 'Some Name'
Returns the object with ContractName 'Some Name', if any.
 .EXAMPLE
Get-AtwsContract -ContractName 'Some Name' -NotEquals ContractName
Returns any objects with a ContractName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsContract -ContractName SomeName* -Like ContractName
Returns any object with a ContractName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsContract -ContractName SomeName* -NotLike ContractName
Returns any object with a ContractName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsContract -BillingPreference 'PickList Label'
Returns any Contracts with property BillingPreference equal to the 'PickList Label'. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsContract -BillingPreference 'PickList Label' -NotEquals BillingPreference 
Returns any Contracts with property BillingPreference NOT equal to the 'PickList Label'.
 .EXAMPLE
Get-AtwsContract -BillingPreference 'PickList Label1', 'PickList Label2'
Returns any Contracts with property BillingPreference equal to EITHER 'PickList Label1' OR 'PickList Label2'.
 .EXAMPLE
Get-AtwsContract -BillingPreference 'PickList Label1', 'PickList Label2' -NotEquals BillingPreference
Returns any Contracts with property BillingPreference NOT equal to NEITHER 'PickList Label1' NOR 'PickList Label2'.
 .EXAMPLE
Get-AtwsContract -Id 1234 -ContractName SomeName* -BillingPreference 'PickList Label1', 'PickList Label2' -Like ContractName -NotEquals BillingPreference -GreaterThan Id
An example of a more complex query. This command returns any Contracts with Id GREATER THAN 1234, a ContractName that matches the simple pattern SomeName* AND that has a BillingPreference that is NOT equal to NEITHER 'PickList Label1' NOR 'PickList Label2'.

.NOTES
Related commands:
New-AtwsContract
 Set-AtwsContract

#>

  [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName='Filter', ConfirmImpact='None',
  HelpURI='https://github.com/ecitsolutions/Autotask/blob/master/Docs/Get-AtwsContract.md')]
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
    [ValidateSet('AccountID', 'BillToAccountContactID', 'BillToAccountID', 'BusinessDivisionSubdivisionID', 'ContactID', 'ContractExclusionSetID', 'ExclusionContractID', 'OpportunityID')]
    [string]
    $GetReferenceEntityById,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# A single user defined field can be used pr query
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('UDF')]
    [ValidateNotNullOrEmpty()]
    [Autotask.UserDefinedField]
    $UserDefinedField,

# Account
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $AccountID,

# Billing Preference
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Contract -FieldName BillingPreference -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Contract -FieldName BillingPreference -Label) + (Get-AtwsPicklistValue -Entity Contract -FieldName BillingPreference -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $BillingPreference,

# Bill To Account Contact ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BillToAccountContactID,

# Bill To Account ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BillToAccountID,

# Business Division Subdivision ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BusinessDivisionSubdivisionID,

# Contract Compilance
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $Compliance,

# Contact ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ContactID,

# Contract Contact
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,250)]
    [string[]]
    $ContactName,

# Category
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Contract -FieldName ContractCategory -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Contract -FieldName ContractCategory -Label) + (Get-AtwsPicklistValue -Entity Contract -FieldName ContractCategory -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $ContractCategory,

# Contract Exclusion Set ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ContractExclusionSetID,

# Contract Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('Name')]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [string[]]
    $ContractName,

# Contract Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $ContractNumber,

# Contract Period Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Contract -FieldName ContractPeriodType -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Contract -FieldName ContractPeriodType -Label) + (Get-AtwsPicklistValue -Entity Contract -FieldName ContractPeriodType -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $ContractPeriodType,

# Contract Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Contract -FieldName ContractType -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Contract -FieldName ContractType -Label) + (Get-AtwsPicklistValue -Entity Contract -FieldName ContractType -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $ContractType,

# Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string[]]
    $Description,

# End Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $EndDate,

# Estimated Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $EstimatedCost,

# Estimated Hours
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $EstimatedHours,

# Estimated Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $EstimatedRevenue,

# Exclusion Contract ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $ExclusionContractID,

# Contract ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Internal Currency Contract Overage Billing Rate
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $InternalCurrencyOverageBillingRate,

# Internal Currency Contract Setup Fee
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $InternalCurrencySetupFee,

# Default Contract
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $IsDefaultContract,

# opportunity_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $OpportunityID,

# Contract Overage Billing Rate
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $OverageBillingRate,

# purchase_order_number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $PurchaseOrderNumber,

# Renewed Contract Id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $RenewedContractID,

# Service Level Agreement ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Contract -FieldName ServiceLevelAgreementID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Contract -FieldName ServiceLevelAgreementID -Label) + (Get-AtwsPicklistValue -Entity Contract -FieldName ServiceLevelAgreementID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $ServiceLevelAgreementID,

# Contract Setup Fee
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $SetupFee,

# Contract Setup Fee Allocation Code ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $SetupFeeAllocationCodeID,

# Start Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $StartDate,

# Status
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Contract -FieldName Status -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Contract -FieldName Status -Label) + (Get-AtwsPicklistValue -Entity Contract -FieldName Status -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $Status,

# Time Reporting Requires Start and Stop Times
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Contract -FieldName TimeReportingRequiresStartAndStopTimes -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Contract -FieldName TimeReportingRequiresStartAndStopTimes -Label) + (Get-AtwsPicklistValue -Entity Contract -FieldName TimeReportingRequiresStartAndStopTimes -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $TimeReportingRequiresStartAndStopTimes,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'BillingPreference', 'BillToAccountContactID', 'BillToAccountID', 'BusinessDivisionSubdivisionID', 'Compliance', 'ContactID', 'ContactName', 'ContractCategory', 'ContractExclusionSetID', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'ContractType', 'Description', 'EndDate', 'EstimatedCost', 'EstimatedHours', 'EstimatedRevenue', 'ExclusionContractID', 'id', 'InternalCurrencyOverageBillingRate', 'InternalCurrencySetupFee', 'IsDefaultContract', 'OpportunityID', 'OverageBillingRate', 'PurchaseOrderNumber', 'RenewedContractID', 'ServiceLevelAgreementID', 'SetupFee', 'SetupFeeAllocationCodeID', 'StartDate', 'Status', 'TimeReportingRequiresStartAndStopTimes')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'BillingPreference', 'BillToAccountContactID', 'BillToAccountID', 'BusinessDivisionSubdivisionID', 'Compliance', 'ContactID', 'ContactName', 'ContractCategory', 'ContractExclusionSetID', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'ContractType', 'Description', 'EndDate', 'EstimatedCost', 'EstimatedHours', 'EstimatedRevenue', 'ExclusionContractID', 'id', 'InternalCurrencyOverageBillingRate', 'InternalCurrencySetupFee', 'IsDefaultContract', 'OpportunityID', 'OverageBillingRate', 'PurchaseOrderNumber', 'RenewedContractID', 'ServiceLevelAgreementID', 'SetupFee', 'SetupFeeAllocationCodeID', 'StartDate', 'Status', 'TimeReportingRequiresStartAndStopTimes')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'BillingPreference', 'BillToAccountContactID', 'BillToAccountID', 'BusinessDivisionSubdivisionID', 'Compliance', 'ContactID', 'ContactName', 'ContractCategory', 'ContractExclusionSetID', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'ContractType', 'Description', 'EndDate', 'EstimatedCost', 'EstimatedHours', 'EstimatedRevenue', 'ExclusionContractID', 'id', 'InternalCurrencyOverageBillingRate', 'InternalCurrencySetupFee', 'IsDefaultContract', 'OpportunityID', 'OverageBillingRate', 'PurchaseOrderNumber', 'RenewedContractID', 'ServiceLevelAgreementID', 'SetupFee', 'SetupFeeAllocationCodeID', 'StartDate', 'Status', 'TimeReportingRequiresStartAndStopTimes')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'BillingPreference', 'BillToAccountContactID', 'BillToAccountID', 'BusinessDivisionSubdivisionID', 'ContactID', 'ContactName', 'ContractCategory', 'ContractExclusionSetID', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'ContractType', 'Description', 'EndDate', 'EstimatedCost', 'EstimatedHours', 'EstimatedRevenue', 'ExclusionContractID', 'id', 'InternalCurrencyOverageBillingRate', 'InternalCurrencySetupFee', 'OpportunityID', 'OverageBillingRate', 'PurchaseOrderNumber', 'RenewedContractID', 'ServiceLevelAgreementID', 'SetupFee', 'SetupFeeAllocationCodeID', 'StartDate', 'Status', 'TimeReportingRequiresStartAndStopTimes', 'UserDefinedField')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'BillingPreference', 'BillToAccountContactID', 'BillToAccountID', 'BusinessDivisionSubdivisionID', 'ContactID', 'ContactName', 'ContractCategory', 'ContractExclusionSetID', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'ContractType', 'Description', 'EndDate', 'EstimatedCost', 'EstimatedHours', 'EstimatedRevenue', 'ExclusionContractID', 'id', 'InternalCurrencyOverageBillingRate', 'InternalCurrencySetupFee', 'OpportunityID', 'OverageBillingRate', 'PurchaseOrderNumber', 'RenewedContractID', 'ServiceLevelAgreementID', 'SetupFee', 'SetupFeeAllocationCodeID', 'StartDate', 'Status', 'TimeReportingRequiresStartAndStopTimes', 'UserDefinedField')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'BillingPreference', 'BillToAccountContactID', 'BillToAccountID', 'BusinessDivisionSubdivisionID', 'ContactID', 'ContactName', 'ContractCategory', 'ContractExclusionSetID', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'ContractType', 'Description', 'EndDate', 'EstimatedCost', 'EstimatedHours', 'EstimatedRevenue', 'ExclusionContractID', 'id', 'InternalCurrencyOverageBillingRate', 'InternalCurrencySetupFee', 'OpportunityID', 'OverageBillingRate', 'PurchaseOrderNumber', 'RenewedContractID', 'ServiceLevelAgreementID', 'SetupFee', 'SetupFeeAllocationCodeID', 'StartDate', 'Status', 'TimeReportingRequiresStartAndStopTimes', 'UserDefinedField')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'BillingPreference', 'BillToAccountContactID', 'BillToAccountID', 'BusinessDivisionSubdivisionID', 'ContactID', 'ContactName', 'ContractCategory', 'ContractExclusionSetID', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'ContractType', 'Description', 'EndDate', 'EstimatedCost', 'EstimatedHours', 'EstimatedRevenue', 'ExclusionContractID', 'id', 'InternalCurrencyOverageBillingRate', 'InternalCurrencySetupFee', 'OpportunityID', 'OverageBillingRate', 'PurchaseOrderNumber', 'RenewedContractID', 'ServiceLevelAgreementID', 'SetupFee', 'SetupFeeAllocationCodeID', 'StartDate', 'Status', 'TimeReportingRequiresStartAndStopTimes', 'UserDefinedField')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ContactName', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'Description', 'PurchaseOrderNumber', 'UserDefinedField')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ContactName', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'Description', 'PurchaseOrderNumber', 'UserDefinedField')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ContactName', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'Description', 'PurchaseOrderNumber', 'UserDefinedField')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ContactName', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'Description', 'PurchaseOrderNumber', 'UserDefinedField')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ContactName', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'Description', 'PurchaseOrderNumber', 'UserDefinedField')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('EndDate', 'StartDate', 'UserDefinedField')]
    [string[]]
    $IsThisDay
  )

    begin {
        $entityName = 'Contract'

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
