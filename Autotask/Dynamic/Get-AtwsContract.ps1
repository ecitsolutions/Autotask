#Requires -Version 4.0
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

  [CmdLetBinding(DefaultParameterSetName='Filter', ConfirmImpact='None')]
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
    [ValidateSet('AccountID', 'OpportunityID', 'ExclusionContractID', 'ContactID', 'BusinessDivisionSubdivisionID')]
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
    [ValidateSet('Project:ContractID', 'ContractFactor:ContractID', 'Contract:ExclusionContractID', 'ContractExclusionAllocationCode:ContractID', 'ContractService:ContractID', 'ContractRetainer:ContractID', 'ContractNote:ContractID', 'BillingItem:ContractID', 'ContractMilestone:ContractID', 'InstalledProduct:ContractID', 'ContractServiceUnit:ContractID', 'ContractServiceBundleAdjustment:ContractID', 'Ticket:ContractID', 'ContractTicketPurchase:ContractID', 'ContractCost:ContractID', 'ContractServiceAdjustment:ContractID', 'ContractBlock:ContractID', 'TimeEntry:ContractID', 'PurchaseOrderItem:ContractID', 'AccountToDo:ContractID', 'ContractRoleCost:ContractID', 'ContractServiceBundle:ContractID', 'ContractServiceBundleUnit:ContractID', 'ContractExclusionRole:ContractID', 'ContractRate:ContractID')]
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
    [long[]]
    $id,

# Client
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int[]]
    $AccountID,

# Billing Preference
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $BillingPreference,

# Contract Compilance
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean[]]
    $Compliance,

# Contract Contact
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,250)]
    [string[]]
    $ContactName,

# Category
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $ContractCategory,

# Contract Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Alias('Name')]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1,100)]
    [string[]]
    $ContractName,

# Contract Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string[]]
    $ContractNumber,

# Contract Period Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,1)]
    [string[]]
    $ContractPeriodType,

# Contract Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int[]]
    $ContractType,

# Default Contract
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean[]]
    $IsDefaultContract,

# Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,2000)]
    [string[]]
    $Description,

# End Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime[]]
    $EndDate,

# Estimated Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double[]]
    $EstimatedCost,

# Estimated Hours
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double[]]
    $EstimatedHours,

# Estimated Revenue
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double[]]
    $EstimatedRevenue,

# Contract Overage Billing Rate
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double[]]
    $OverageBillingRate,

# Start Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime[]]
    $StartDate,

# Status
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int[]]
    $Status,

# Service Level Agreement ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $ServiceLevelAgreementID,

# Contract Setup Fee
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double[]]
    $SetupFee,

# purchase_order_number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string[]]
    $PurchaseOrderNumber,

# Time Reporting Requires Start and Stop Times
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int[]]
    $TimeReportingRequiresStartAndStopTimes,

# opportunity_id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $OpportunityID,

# Renewed Contract Id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long[]]
    $RenewedContractID,

# Contract Setup Fee Allocation Code ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long[]]
    $SetupFeeAllocationCodeID,

# Exclusion Contract ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long[]]
    $ExclusionContractID,

# Internal Currency Contract Overage Billing Rate
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double[]]
    $InternalCurrencyOverageBillingRate,

# Internal Currency Contract Setup Fee
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double[]]
    $InternalCurrencySetupFee,

# Contact ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $ContactID,

# Business Division Subdivision ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $BusinessDivisionSubdivisionID,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'BillingPreference', 'Compliance', 'ContactName', 'ContractCategory', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'ContractType', 'IsDefaultContract', 'Description', 'EndDate', 'EstimatedCost', 'EstimatedHours', 'EstimatedRevenue', 'OverageBillingRate', 'StartDate', 'Status', 'ServiceLevelAgreementID', 'SetupFee', 'PurchaseOrderNumber', 'TimeReportingRequiresStartAndStopTimes', 'OpportunityID', 'RenewedContractID', 'SetupFeeAllocationCodeID', 'ExclusionContractID', 'InternalCurrencyOverageBillingRate', 'InternalCurrencySetupFee', 'ContactID', 'BusinessDivisionSubdivisionID', 'UserDefinedField')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'BillingPreference', 'Compliance', 'ContactName', 'ContractCategory', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'ContractType', 'IsDefaultContract', 'Description', 'EndDate', 'EstimatedCost', 'EstimatedHours', 'EstimatedRevenue', 'OverageBillingRate', 'StartDate', 'Status', 'ServiceLevelAgreementID', 'SetupFee', 'PurchaseOrderNumber', 'TimeReportingRequiresStartAndStopTimes', 'OpportunityID', 'RenewedContractID', 'SetupFeeAllocationCodeID', 'ExclusionContractID', 'InternalCurrencyOverageBillingRate', 'InternalCurrencySetupFee', 'ContactID', 'BusinessDivisionSubdivisionID', 'UserDefinedField')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'BillingPreference', 'Compliance', 'ContactName', 'ContractCategory', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'ContractType', 'IsDefaultContract', 'Description', 'EndDate', 'EstimatedCost', 'EstimatedHours', 'EstimatedRevenue', 'OverageBillingRate', 'StartDate', 'Status', 'ServiceLevelAgreementID', 'SetupFee', 'PurchaseOrderNumber', 'TimeReportingRequiresStartAndStopTimes', 'OpportunityID', 'RenewedContractID', 'SetupFeeAllocationCodeID', 'ExclusionContractID', 'InternalCurrencyOverageBillingRate', 'InternalCurrencySetupFee', 'ContactID', 'BusinessDivisionSubdivisionID', 'UserDefinedField')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'BillingPreference', 'ContactName', 'ContractCategory', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'ContractType', 'Description', 'EndDate', 'EstimatedCost', 'EstimatedHours', 'EstimatedRevenue', 'OverageBillingRate', 'StartDate', 'Status', 'ServiceLevelAgreementID', 'SetupFee', 'PurchaseOrderNumber', 'TimeReportingRequiresStartAndStopTimes', 'OpportunityID', 'RenewedContractID', 'SetupFeeAllocationCodeID', 'ExclusionContractID', 'InternalCurrencyOverageBillingRate', 'InternalCurrencySetupFee', 'ContactID', 'BusinessDivisionSubdivisionID', 'UserDefinedField')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'BillingPreference', 'ContactName', 'ContractCategory', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'ContractType', 'Description', 'EndDate', 'EstimatedCost', 'EstimatedHours', 'EstimatedRevenue', 'OverageBillingRate', 'StartDate', 'Status', 'ServiceLevelAgreementID', 'SetupFee', 'PurchaseOrderNumber', 'TimeReportingRequiresStartAndStopTimes', 'OpportunityID', 'RenewedContractID', 'SetupFeeAllocationCodeID', 'ExclusionContractID', 'InternalCurrencyOverageBillingRate', 'InternalCurrencySetupFee', 'ContactID', 'BusinessDivisionSubdivisionID', 'UserDefinedField')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'BillingPreference', 'ContactName', 'ContractCategory', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'ContractType', 'Description', 'EndDate', 'EstimatedCost', 'EstimatedHours', 'EstimatedRevenue', 'OverageBillingRate', 'StartDate', 'Status', 'ServiceLevelAgreementID', 'SetupFee', 'PurchaseOrderNumber', 'TimeReportingRequiresStartAndStopTimes', 'OpportunityID', 'RenewedContractID', 'SetupFeeAllocationCodeID', 'ExclusionContractID', 'InternalCurrencyOverageBillingRate', 'InternalCurrencySetupFee', 'ContactID', 'BusinessDivisionSubdivisionID', 'UserDefinedField')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'BillingPreference', 'ContactName', 'ContractCategory', 'ContractName', 'ContractNumber', 'ContractPeriodType', 'ContractType', 'Description', 'EndDate', 'EstimatedCost', 'EstimatedHours', 'EstimatedRevenue', 'OverageBillingRate', 'StartDate', 'Status', 'ServiceLevelAgreementID', 'SetupFee', 'PurchaseOrderNumber', 'TimeReportingRequiresStartAndStopTimes', 'OpportunityID', 'RenewedContractID', 'SetupFeeAllocationCodeID', 'ExclusionContractID', 'InternalCurrencyOverageBillingRate', 'InternalCurrencySetupFee', 'ContactID', 'BusinessDivisionSubdivisionID', 'UserDefinedField')]
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
        
    # Set up TimeZone offset handling
    If (-not($script:ESTzone)) {
      $script:ESTzone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Eastern Standard Time")
    }
    
    If (-not($script:ESToffset)) {
      $Now = Get-Date
      $ESTtime = [System.TimeZoneInfo]::ConvertTimeFromUtc($Now.ToUniversalTime(), $ESTzone)

      $script:ESToffset = (New-TimeSpan -Start $ESTtime -End $Now).TotalHours
    }
  }


  Process
  {
    If ($PSCmdlet.ParameterSetName -eq 'Get_all')
    { $Filter = @('id', '-ge', 0)}
    ElseIf (-not ($Filter)) {
      Write-Debug ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)
      
      $Fields = Get-AtwsFieldInfo -Entity $EntityName
 
      Foreach ($Parameter in $PSBoundParameters.GetEnumerator()) {
        $Field = $Fields | Where-Object {$_.Name -eq $Parameter.Key}
        If ($Field -or $Parameter.Key -eq 'UserDefinedField') { 
          If ($Parameter.Value.Count -gt 1) {
            $Filter += '-begin'
          }
          Foreach ($ParameterValue in $Parameter.Value) {   
            $Operator = '-or'
            $ParameterName = $Parameter.Key
            If ($Field.IsPickList) {
              If ($Field.PickListParentValueField) {
                $ParentField = $Fields.Where{$_.Name -eq $Field.PickListParentValueField}
                $ParentLabel = $PSBoundParameters.$($ParentField.Name)
                $ParentValue = $ParentField.PickListValues | Where-Object {$_.Label -eq $ParentLabel}
                $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $ParameterValue -and $_.ParentValue -eq $ParentValue.Value}                
              }
              Else { 
                $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $ParameterValue}
              }
              $Value = $PickListValue.Value
            }
            ElseIf ($ParameterName -eq 'UserDefinedField') {
              $Filter += '-udf'              
              $ParameterName = $ParameterValue.Name
              $Value = $ParameterValue.Value
            }
            ElseIf ($ParameterValue.GetType().Name -eq 'DateTime')  {
              $Value = ConvertTo-AtwsDate -ParameterName $ParameterName -DateTime $ParameterValue
            }            
            Else {
              $Value = $ParameterValue
            }
            $Filter += $ParameterName
            If ($Parameter.Key -in $NotEquals) { 
              $Filter += '-ne'
              $Operator = '-and'
            }
            ElseIf ($Parameter.Key -in $GreaterThan)
            { $Filter += '-gt'}
            ElseIf ($Parameter.Key -in $GreaterThanOrEquals)
            { $Filter += '-ge'}
            ElseIf ($Parameter.Key -in $LessThan)
            { $Filter += '-lt'}
            ElseIf ($Parameter.Key -in $LessThanOrEquals)
            { $Filter += '-le'}
            ElseIf ($Parameter.Key -in $Like) { 
              $Filter += '-like'
              $Value = $Value -replace '\*', '%'
            }
            ElseIf ($Parameter.Key -in $NotLike) { 
              $Filter += '-notlike'
              $Value = $Value -replace '\*', '%'
            }
            ElseIf ($Parameter.Key -in $BeginsWith)
            { $Filter += '-beginswith'}
            ElseIf ($Parameter.Key -in $EndsWith)
            { $Filter += '-endswith'}
            ElseIf ($Parameter.Key -in $Contains)
            { $Filter += '-contains'}
            ElseIf ($Parameter.Key -in $IsThisDay)
            { $Filter += '-isthisday'}
            ElseIf ($Parameter.Key -in $IsNull -and $Parameter.Key -eq 'UserDefinedField')
            {
              $Filter += '-IsNull'
              $IsNull = $IsNull.Where({$_ -ne 'UserDefinedField'})
            }
            ElseIf ($Parameter.Key -in $IsNotNull -and $Parameter.Key -eq 'UserDefinedField')
            {
              $Filter += '-IsNotNull'
              $IsNotNull = $IsNotNull.Where({$_ -ne 'UserDefinedField'})
            }
            Else
            { $Filter += '-eq'}
            
            # Add Value to expression, unless this is a UserDefinedfield AND UserDefinedField has been
            # specified for -IsNull or -IsNotNull
            If ($Filter[-1] -notin @('-IsNull','-IsNotNull'))
            {$Filter += $Value}

            If ($Parameter.Value.Count -gt 1 -and $ParameterValue -ne $Parameter.Value[-1]) {
              $Filter += $Operator
            }
            ElseIf ($Parameter.Value.Count -gt 1) {
              $Filter += '-end'
            }
            
          }
            
        }
      }
      # IsNull and IsNotNull are special. They are the only operators that does not require a value to work
      If ($IsNull.Count -gt 0) {
        If ($Filter.Count -gt 0) {
          $Filter += '-and'
        }
        Foreach ($PropertyName in $IsNull) {
          $Filter += $PropertyName
          $Filter += '-isnull'
        }
      }
      If ($IsNotNull.Count -gt 0) {
        If ($Filter.Count -gt 0) {
          $Filter += '-and'
        }
        Foreach ($PropertyName in $IsNotNull) {
          $Filter += $PropertyName
          $Filter += '-isnotnull'
        }
      }  
    }
    Else {
      Write-Debug ('{0}: Passing -Filter raw to Get function' -F $MyInvocation.MyCommand.Name)
    } 

    $Result = Get-AtwsData -Entity $EntityName -Filter $Filter

    Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $Result.Count)
    
    # Datetimeparameters
    $DateTimeParams = $Fields.Where({$_.Type -eq 'datetime'}).Name
    
    # Expand UDFs by default
    Foreach ($Item in $Result)
    {
      # Any userdefined fields?
      If ($Item.UserDefinedFields.Count -gt 0)
      { 
        # Expand User defined fields for easy filtering of collections and readability
        Foreach ($UDF in $Item.UserDefinedFields)
        {
          # Make names you HAVE TO escape...
          $UDFName = '#{0}' -F $UDF.Name
          Add-Member -InputObject $Item -MemberType NoteProperty -Name $UDFName -Value $UDF.Value
        }  
      }
      
      # Adjust TimeZone on all DateTime properties
      Foreach ($DateTimeParam in $DateTimeParams) {
      
        # Get the datetime value
        $ParameterValue = $Item.$DateTimeParam
                
        # Skip if parameter is empty
        If (-not ($ParameterValue)) {
          Continue
        }
        
        $TimePresent = $ParameterValue.Hour -gt 0 -or $ParameterValue.Minute -gt 0 -or $ParameterValue.Second -gt 0 -or $ParameterValue.Millisecond -gt 0 
                
        # If this is a DATE it should not be touched
        If ($DateTimeParam -like "*DateTime" -or $TimePresent) {

          # This is DATETIME 
          # We need to adjust the timezone difference 

          # Yes, you really have to ADD the difference
          $ParameterValue = $ParameterValue.AddHours($script:ESToffset)
            
          # Store the value back to the object (not the API!)
          $Item.$DateTimeParam = $ParameterValue
        }
      }
    }
    
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

  End
  {
    Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    If ($Result)
    {
      Return $Result
    }
  }


}
