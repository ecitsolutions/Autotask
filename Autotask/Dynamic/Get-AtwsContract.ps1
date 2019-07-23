#Requires -Version 4.0
#Version 1.6.2.15
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

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

Additional operators for [String] parameters are:
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
    [ValidateSet('AccountID', 'BillToAccountContactID', 'BillToAccountID', 'BusinessDivisionSubdivisionID', 'ContactID', 'ContractExclusionSetID', 'ExclusionContractID', 'OpportunityID')]
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
    [ValidateSet('AccountToDo:ContractID', 'BillingItem:ContractID', 'Contract:ExclusionContractID', 'ContractBillingRule:ContractID', 'ContractBlock:ContractID', 'ContractCost:ContractID', 'ContractExclusionAllocationCode:ContractID', 'ContractExclusionRole:ContractID', 'ContractFactor:ContractID', 'ContractMilestone:ContractID', 'ContractNote:ContractID', 'ContractRate:ContractID', 'ContractRetainer:ContractID', 'ContractRoleCost:ContractID', 'ContractService:ContractID', 'ContractServiceAdjustment:ContractID', 'ContractServiceBundle:ContractID', 'ContractServiceBundleAdjustment:ContractID', 'ContractServiceBundleUnit:ContractID', 'ContractServiceUnit:ContractID', 'ContractTicketPurchase:ContractID', 'InstalledProduct:ContractID', 'Project:ContractID', 'PurchaseOrderItem:ContractID', 'Ticket:ContractID', 'TimeEntry:ContractID')]
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

# A single user defined field can be used pr query
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Alias('UDF')]
    [ValidateNotNullOrEmpty()]
    [Autotask.UserDefinedField]
    $UserDefinedField,

# Contract ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Client
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $AccountID,

# Billing Preference
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $BillingPreference,

# Contract Compilance
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $Compliance,

# Contract Contact
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,250)]
    [string[]]
    $ContactName,

# Category
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $ContractCategory,

# Contract Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Alias('Name')]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [string[]]
    $ContractName,

# Contract Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $ContractNumber,

# Contract Period Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $ContractPeriodType,

# Contract Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $ContractType,

# Default Contract
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $IsDefaultContract,

# Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string[]]
    $Description,

# End Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $EndDate,

# Estimated Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $EstimatedCost,

# Estimated Hours
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $EstimatedHours,

# Estimated Revenue
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $EstimatedRevenue,

# Contract Overage Billing Rate
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $OverageBillingRate,

# Start Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $StartDate,

# Status
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $Status,

# Service Level Agreement ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $ServiceLevelAgreementID,

# Contract Setup Fee
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $SetupFee,

# purchase_order_number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $PurchaseOrderNumber,

# Time Reporting Requires Start and Stop Times
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $TimeReportingRequiresStartAndStopTimes,

# opportunity_id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $OpportunityID,

# Renewed Contract Id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $RenewedContractID,

# Contract Setup Fee Allocation Code ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $SetupFeeAllocationCodeID,

# Exclusion Contract ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $ExclusionContractID,

# Internal Currency Contract Overage Billing Rate
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $InternalCurrencyOverageBillingRate,

# Internal Currency Contract Setup Fee
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $InternalCurrencySetupFee,

# Contact ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ContactID,

# Business Division Subdivision ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BusinessDivisionSubdivisionID,

# Bill To Client ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BillToAccountID,

# Bill To Client Contact ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BillToAccountContactID,

# Contract Exclusion Set ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ContractExclusionSetID,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'BillingPreference', 'Compliance', 'ContactName', 'ContractCategory', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'ContractType', 'IsDefaultContract', 'Description', 'EndDate', 'EstimatedCost', 'EstimatedHours', 'EstimatedRevenue', 'OverageBillingRate', 'StartDate', 'Status', 'ServiceLevelAgreementID', 'SetupFee', 'PurchaseOrderNumber', 'TimeReportingRequiresStartAndStopTimes', 'OpportunityID', 'RenewedContractID', 'SetupFeeAllocationCodeID', 'ExclusionContractID', 'InternalCurrencyOverageBillingRate', 'InternalCurrencySetupFee', 'ContactID', 'BusinessDivisionSubdivisionID', 'BillToAccountID', 'BillToAccountContactID', 'ContractExclusionSetID', 'UserDefinedField')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'BillingPreference', 'Compliance', 'ContactName', 'ContractCategory', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'ContractType', 'IsDefaultContract', 'Description', 'EndDate', 'EstimatedCost', 'EstimatedHours', 'EstimatedRevenue', 'OverageBillingRate', 'StartDate', 'Status', 'ServiceLevelAgreementID', 'SetupFee', 'PurchaseOrderNumber', 'TimeReportingRequiresStartAndStopTimes', 'OpportunityID', 'RenewedContractID', 'SetupFeeAllocationCodeID', 'ExclusionContractID', 'InternalCurrencyOverageBillingRate', 'InternalCurrencySetupFee', 'ContactID', 'BusinessDivisionSubdivisionID', 'BillToAccountID', 'BillToAccountContactID', 'ContractExclusionSetID', 'UserDefinedField')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'BillingPreference', 'Compliance', 'ContactName', 'ContractCategory', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'ContractType', 'IsDefaultContract', 'Description', 'EndDate', 'EstimatedCost', 'EstimatedHours', 'EstimatedRevenue', 'OverageBillingRate', 'StartDate', 'Status', 'ServiceLevelAgreementID', 'SetupFee', 'PurchaseOrderNumber', 'TimeReportingRequiresStartAndStopTimes', 'OpportunityID', 'RenewedContractID', 'SetupFeeAllocationCodeID', 'ExclusionContractID', 'InternalCurrencyOverageBillingRate', 'InternalCurrencySetupFee', 'ContactID', 'BusinessDivisionSubdivisionID', 'BillToAccountID', 'BillToAccountContactID', 'ContractExclusionSetID', 'UserDefinedField')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'BillingPreference', 'ContactName', 'ContractCategory', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'ContractType', 'Description', 'EndDate', 'EstimatedCost', 'EstimatedHours', 'EstimatedRevenue', 'OverageBillingRate', 'StartDate', 'Status', 'ServiceLevelAgreementID', 'SetupFee', 'PurchaseOrderNumber', 'TimeReportingRequiresStartAndStopTimes', 'OpportunityID', 'RenewedContractID', 'SetupFeeAllocationCodeID', 'ExclusionContractID', 'InternalCurrencyOverageBillingRate', 'InternalCurrencySetupFee', 'ContactID', 'BusinessDivisionSubdivisionID', 'BillToAccountID', 'BillToAccountContactID', 'ContractExclusionSetID', 'UserDefinedField')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'BillingPreference', 'ContactName', 'ContractCategory', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'ContractType', 'Description', 'EndDate', 'EstimatedCost', 'EstimatedHours', 'EstimatedRevenue', 'OverageBillingRate', 'StartDate', 'Status', 'ServiceLevelAgreementID', 'SetupFee', 'PurchaseOrderNumber', 'TimeReportingRequiresStartAndStopTimes', 'OpportunityID', 'RenewedContractID', 'SetupFeeAllocationCodeID', 'ExclusionContractID', 'InternalCurrencyOverageBillingRate', 'InternalCurrencySetupFee', 'ContactID', 'BusinessDivisionSubdivisionID', 'BillToAccountID', 'BillToAccountContactID', 'ContractExclusionSetID', 'UserDefinedField')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'BillingPreference', 'ContactName', 'ContractCategory', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'ContractType', 'Description', 'EndDate', 'EstimatedCost', 'EstimatedHours', 'EstimatedRevenue', 'OverageBillingRate', 'StartDate', 'Status', 'ServiceLevelAgreementID', 'SetupFee', 'PurchaseOrderNumber', 'TimeReportingRequiresStartAndStopTimes', 'OpportunityID', 'RenewedContractID', 'SetupFeeAllocationCodeID', 'ExclusionContractID', 'InternalCurrencyOverageBillingRate', 'InternalCurrencySetupFee', 'ContactID', 'BusinessDivisionSubdivisionID', 'BillToAccountID', 'BillToAccountContactID', 'ContractExclusionSetID', 'UserDefinedField')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'BillingPreference', 'ContactName', 'ContractCategory', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'ContractType', 'Description', 'EndDate', 'EstimatedCost', 'EstimatedHours', 'EstimatedRevenue', 'OverageBillingRate', 'StartDate', 'Status', 'ServiceLevelAgreementID', 'SetupFee', 'PurchaseOrderNumber', 'TimeReportingRequiresStartAndStopTimes', 'OpportunityID', 'RenewedContractID', 'SetupFeeAllocationCodeID', 'ExclusionContractID', 'InternalCurrencyOverageBillingRate', 'InternalCurrencySetupFee', 'ContactID', 'BusinessDivisionSubdivisionID', 'BillToAccountID', 'BillToAccountContactID', 'ContractExclusionSetID', 'UserDefinedField')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('ContactName', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'Description', 'PurchaseOrderNumber', 'UserDefinedField')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('ContactName', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'Description', 'PurchaseOrderNumber', 'UserDefinedField')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('ContactName', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'Description', 'PurchaseOrderNumber', 'UserDefinedField')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('ContactName', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'Description', 'PurchaseOrderNumber', 'UserDefinedField')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('ContactName', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'Description', 'PurchaseOrderNumber', 'UserDefinedField')]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('EndDate', 'StartDate', 'UserDefinedField')]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'Contract'
    
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
      $Result = Get-AtwsData -Entity $EntityName -Filter $Filter
    

      Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $Result.Count)
    
      # Should we return an indirect object?
      if ( ($Result) -and ($GetReferenceEntityById))
      {
        Write-Debug ('{0}: User has asked for external reference objects by {1}' -F $MyInvocation.MyCommand.Name, $GetReferenceEntityById)
      
        $Field = $Fields.Where({$_.Name -eq $GetReferenceEntityById})
        $ResultValues = $Result | Where-Object {$null -ne $_.$GetReferenceEntityById}
        If ($ResultValues.Count -lt $Result.Count)
        {
          Write-Warning ('{0}: Only {1} of the {2}s in the primary query had a value in the property {3}.' -F $MyInvocation.MyCommand.Name, 
            $ResultValues.Count,
            $EntityName,
          $GetReferenceEntityById) -WarningAction Continue
        }
        $Filter = 'id -eq {0}' -F $($ResultValues.$GetReferenceEntityById -join ' -or id -eq ')
        $Result = Get-Atwsdata -Entity $Field.ReferenceEntityType -Filter $Filter
      }
      ElseIf ( ($Result) -and ($GetExternalEntityByThisEntityId))
      {
        Write-Debug ('{0}: User has asked for {1} that are referencing this result' -F $MyInvocation.MyCommand.Name, $GetExternalEntityByThisEntityId)
        $ReferenceInfo = $GetExternalEntityByThisEntityId -Split ':'
        $Filter = '{0} -eq {1}' -F $ReferenceInfo[1], $($Result.id -join (' -or {0}id -eq ' -F $ReferenceInfo[1]))
        $Result = Get-Atwsdata -Entity $ReferenceInfo[0] -Filter $Filter
      }
      # Do the user want labels along with index values for Picklists?
      ElseIf ( ($Result) -and -not ($NoPickListLabel))
      {
        Foreach ($Field in $Fields.Where{$_.IsPickList})
        {
          $FieldName = '{0}Label' -F $Field.Name
          Foreach ($Item in $Result)
          {
            $Value = ($Field.PickListValues.Where{$_.Value -eq $Item.$($Field.Name)}).Label
            Add-Member -InputObject $Item -MemberType NoteProperty -Name $FieldName -Value $Value -Force
          
          }
        }
      }
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
