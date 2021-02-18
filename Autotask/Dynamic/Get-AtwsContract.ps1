#Requires -Version 4.0
#Version 1.6.13
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

AccountToDo
 BillingItem
 Contract
 ContractBillingRule
 ContractBlock
 ContractCost
 ContractExclusionAllocationCode
 ContractExclusionRole
 ContractFactor
 ContractMilestone
 ContractNote
 ContractRate
 ContractRetainer
 ContractRoleCost
 ContractService
 ContractServiceAdjustment
 ContractServiceBundle
 ContractServiceBundleAdjustment
 ContractServiceBundleUnit
 ContractServiceUnit
 ContractTicketPurchase
 InstalledProduct
 Project
 PurchaseOrderItem
 Ticket
 TimeEntry

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
Get-AtwsContract -BillingPreference <PickList Label>
Returns any Contracts with property BillingPreference equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsContract -BillingPreference <PickList Label> -NotEquals BillingPreference 
Returns any Contracts with property BillingPreference NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsContract -BillingPreference <PickList Label1>, <PickList Label2>
Returns any Contracts with property BillingPreference equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsContract -BillingPreference <PickList Label1>, <PickList Label2> -NotEquals BillingPreference
Returns any Contracts with property BillingPreference NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsContract -Id 1234 -ContractName SomeName* -BillingPreference <PickList Label1>, <PickList Label2> -Like ContractName -NotEquals BillingPreference -GreaterThan Id
An example of a more complex query. This command returns any Contracts with Id GREATER THAN 1234, a ContractName that matches the simple pattern SomeName* AND that has a BillingPreference that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsContract
 .LINK
Set-AtwsContract

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
    [ValidateSet('AccountID', 'BillToAccountContactID', 'BillToAccountID', 'BusinessDivisionSubdivisionID', 'ContactID', 'ContractExclusionSetID', 'ExclusionContractID', 'OpportunityID')]
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
    [ValidateSet('AccountToDo:ContractID', 'BillingItem:ContractID', 'Contract:ExclusionContractID', 'ContractBillingRule:ContractID', 'ContractBlock:ContractID', 'ContractCost:ContractID', 'ContractExclusionAllocationCode:ContractID', 'ContractExclusionRole:ContractID', 'ContractFactor:ContractID', 'ContractMilestone:ContractID', 'ContractNote:ContractID', 'ContractRate:ContractID', 'ContractRetainer:ContractID', 'ContractRoleCost:ContractID', 'ContractService:ContractID', 'ContractServiceAdjustment:ContractID', 'ContractServiceBundle:ContractID', 'ContractServiceBundleAdjustment:ContractID', 'ContractServiceBundleUnit:ContractID', 'ContractServiceUnit:ContractID', 'ContractTicketPurchase:ContractID', 'InstalledProduct:ContractID', 'Project:ContractID', 'PurchaseOrderItem:ContractID', 'Ticket:ContractID', 'TimeEntry:ContractID')]
    [string]
    $GetExternalEntityByThisEntityId,

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

# Contract ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Client
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
    [string[]]
    $BillingPreference,

# Contract Compilance
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $Compliance,

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
    [string[]]
    $ContractCategory,

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
    [string[]]
    $ContractPeriodType,

# Contract Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $ContractType,

# Default Contract
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $IsDefaultContract,

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

# Contract Overage Billing Rate
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $OverageBillingRate,

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
    [string[]]
    $Status,

# Service Level Agreement ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $ServiceLevelAgreementID,

# Contract Setup Fee
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $SetupFee,

# purchase_order_number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $PurchaseOrderNumber,

# Time Reporting Requires Start and Stop Times
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $TimeReportingRequiresStartAndStopTimes,

# opportunity_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $OpportunityID,

# Renewed Contract Id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $RenewedContractID,

# Contract Setup Fee Allocation Code ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $SetupFeeAllocationCodeID,

# Exclusion Contract ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $ExclusionContractID,

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

# Contact ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ContactID,

# Business Division Subdivision ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BusinessDivisionSubdivisionID,

# Bill To Client ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BillToAccountID,

# Bill To Client Contact ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BillToAccountContactID,

# Contract Exclusion Set ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ContractExclusionSetID,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'BillingPreference', 'Compliance', 'ContactName', 'ContractCategory', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'ContractType', 'IsDefaultContract', 'Description', 'EndDate', 'EstimatedCost', 'EstimatedHours', 'EstimatedRevenue', 'OverageBillingRate', 'StartDate', 'Status', 'ServiceLevelAgreementID', 'SetupFee', 'PurchaseOrderNumber', 'TimeReportingRequiresStartAndStopTimes', 'OpportunityID', 'RenewedContractID', 'SetupFeeAllocationCodeID', 'ExclusionContractID', 'InternalCurrencyOverageBillingRate', 'InternalCurrencySetupFee', 'ContactID', 'BusinessDivisionSubdivisionID', 'BillToAccountID', 'BillToAccountContactID', 'ContractExclusionSetID', 'UserDefinedField')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'BillingPreference', 'Compliance', 'ContactName', 'ContractCategory', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'ContractType', 'IsDefaultContract', 'Description', 'EndDate', 'EstimatedCost', 'EstimatedHours', 'EstimatedRevenue', 'OverageBillingRate', 'StartDate', 'Status', 'ServiceLevelAgreementID', 'SetupFee', 'PurchaseOrderNumber', 'TimeReportingRequiresStartAndStopTimes', 'OpportunityID', 'RenewedContractID', 'SetupFeeAllocationCodeID', 'ExclusionContractID', 'InternalCurrencyOverageBillingRate', 'InternalCurrencySetupFee', 'ContactID', 'BusinessDivisionSubdivisionID', 'BillToAccountID', 'BillToAccountContactID', 'ContractExclusionSetID', 'UserDefinedField')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'BillingPreference', 'Compliance', 'ContactName', 'ContractCategory', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'ContractType', 'IsDefaultContract', 'Description', 'EndDate', 'EstimatedCost', 'EstimatedHours', 'EstimatedRevenue', 'OverageBillingRate', 'StartDate', 'Status', 'ServiceLevelAgreementID', 'SetupFee', 'PurchaseOrderNumber', 'TimeReportingRequiresStartAndStopTimes', 'OpportunityID', 'RenewedContractID', 'SetupFeeAllocationCodeID', 'ExclusionContractID', 'InternalCurrencyOverageBillingRate', 'InternalCurrencySetupFee', 'ContactID', 'BusinessDivisionSubdivisionID', 'BillToAccountID', 'BillToAccountContactID', 'ContractExclusionSetID', 'UserDefinedField')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'BillingPreference', 'ContactName', 'ContractCategory', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'ContractType', 'Description', 'EndDate', 'EstimatedCost', 'EstimatedHours', 'EstimatedRevenue', 'OverageBillingRate', 'StartDate', 'Status', 'ServiceLevelAgreementID', 'SetupFee', 'PurchaseOrderNumber', 'TimeReportingRequiresStartAndStopTimes', 'OpportunityID', 'RenewedContractID', 'SetupFeeAllocationCodeID', 'ExclusionContractID', 'InternalCurrencyOverageBillingRate', 'InternalCurrencySetupFee', 'ContactID', 'BusinessDivisionSubdivisionID', 'BillToAccountID', 'BillToAccountContactID', 'ContractExclusionSetID', 'UserDefinedField')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'BillingPreference', 'ContactName', 'ContractCategory', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'ContractType', 'Description', 'EndDate', 'EstimatedCost', 'EstimatedHours', 'EstimatedRevenue', 'OverageBillingRate', 'StartDate', 'Status', 'ServiceLevelAgreementID', 'SetupFee', 'PurchaseOrderNumber', 'TimeReportingRequiresStartAndStopTimes', 'OpportunityID', 'RenewedContractID', 'SetupFeeAllocationCodeID', 'ExclusionContractID', 'InternalCurrencyOverageBillingRate', 'InternalCurrencySetupFee', 'ContactID', 'BusinessDivisionSubdivisionID', 'BillToAccountID', 'BillToAccountContactID', 'ContractExclusionSetID', 'UserDefinedField')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'BillingPreference', 'ContactName', 'ContractCategory', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'ContractType', 'Description', 'EndDate', 'EstimatedCost', 'EstimatedHours', 'EstimatedRevenue', 'OverageBillingRate', 'StartDate', 'Status', 'ServiceLevelAgreementID', 'SetupFee', 'PurchaseOrderNumber', 'TimeReportingRequiresStartAndStopTimes', 'OpportunityID', 'RenewedContractID', 'SetupFeeAllocationCodeID', 'ExclusionContractID', 'InternalCurrencyOverageBillingRate', 'InternalCurrencySetupFee', 'ContactID', 'BusinessDivisionSubdivisionID', 'BillToAccountID', 'BillToAccountContactID', 'ContractExclusionSetID', 'UserDefinedField')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'BillingPreference', 'ContactName', 'ContractCategory', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'ContractType', 'Description', 'EndDate', 'EstimatedCost', 'EstimatedHours', 'EstimatedRevenue', 'OverageBillingRate', 'StartDate', 'Status', 'ServiceLevelAgreementID', 'SetupFee', 'PurchaseOrderNumber', 'TimeReportingRequiresStartAndStopTimes', 'OpportunityID', 'RenewedContractID', 'SetupFeeAllocationCodeID', 'ExclusionContractID', 'InternalCurrencyOverageBillingRate', 'InternalCurrencySetupFee', 'ContactID', 'BusinessDivisionSubdivisionID', 'BillToAccountID', 'BillToAccountContactID', 'ContractExclusionSetID', 'UserDefinedField')]
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
