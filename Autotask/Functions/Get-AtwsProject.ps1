#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsProject
{


<#
.SYNOPSIS
This function get one or more Project through the Autotask Web Services API.
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
Type
Status
Department
LineOfBusiness

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Project[]]. This function outputs the Autotask.Project that was returned by the API.
.EXAMPLE
Get-AtwsProject -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsProject -ProjectName SomeName
Returns the object with ProjectName 'SomeName', if any.
 .EXAMPLE
Get-AtwsProject -ProjectName 'Some Name'
Returns the object with ProjectName 'Some Name', if any.
 .EXAMPLE
Get-AtwsProject -ProjectName 'Some Name' -NotEquals ProjectName
Returns any objects with a ProjectName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsProject -ProjectName SomeName* -Like ProjectName
Returns any object with a ProjectName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsProject -ProjectName SomeName* -NotLike ProjectName
Returns any object with a ProjectName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsProject -Type <PickList Label>
Returns any Projects with property Type equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsProject -Type <PickList Label> -NotEquals Type 
Returns any Projects with property Type NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsProject -Type <PickList Label1>, <PickList Label2>
Returns any Projects with property Type equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsProject -Type <PickList Label1>, <PickList Label2> -NotEquals Type
Returns any Projects with property Type NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsProject -Id 1234 -ProjectName SomeName* -Type <PickList Label1>, <PickList Label2> -Like ProjectName -NotEquals Type -GreaterThan Id
An example of a more complex query. This command returns any Projects with Id GREATER THAN 1234, a ProjectName that matches the simple pattern SomeName* AND that has a Type that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsProject
 .LINK
Set-AtwsProject

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
    [Collections.Generic.List[string]]
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
    [ValidateSet('AccountID', 'BusinessDivisionSubdivisionID', 'CompanyOwnerResourceID', 'ContractID', 'CreatorResourceID', 'ImpersonatorCreatorResourceID', 'LastActivityResourceID', 'OpportunityID', 'ProjectLeadResourceID')]
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
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[Int]]]
    $AccountID,

# Actual Billed Hours
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $ActualBilledHours,

# Actual Hours
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $ActualHours,

# Business Division Subdivision ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $BusinessDivisionSubdivisionID,

# Change Orders Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $ChangeOrdersRevenue,

# Account Owner
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $CompanyOwnerResourceID,

# Completed date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[datetime]]]
    $CompletedDateTime,

# Completed Percentage
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $CompletedPercentage,

# Contract
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $ContractID,

# Created DateTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[datetime]]]
    $CreateDateTime,

# Created By
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $CreatorResourceID,

# Department
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Project -FieldName Department -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Project -FieldName Department -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $Department,

# Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [Collections.Generic.List[string]]
    $Description,

# Duration
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $Duration,

# End Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[datetime]]]
    $EndDateTime,

# Estimated Sales Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $EstimatedSalesCost,

# Estimated Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $EstimatedTime,

# Ext Project Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [Collections.Generic.List[string]]
    $ExtPNumber,

# id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[long]]]
    $id,

# Impersonator Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $ImpersonatorCreatorResourceID,

# Labor Estimated Costs
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $LaborEstimatedCosts,

# Labor Estimated Margin Percentage
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $LaborEstimatedMarginPercentage,

# Labor Estimated Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $LaborEstimatedRevenue,

# Last Activity Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[datetime]]]
    $LastActivityDateTime,

# Last Activity Person Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $LastActivityPersonType,

# Last Activity By
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $LastActivityResourceID,

# Line Of Business
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Project -FieldName LineOfBusiness -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Project -FieldName LineOfBusiness -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $LineOfBusiness,

# Opportunity ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $OpportunityID,

# Original Estimated Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $OriginalEstimatedRevenue,

# Project Cost Estimated Margin Percentage
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $ProjectCostEstimatedMarginPercentage,

# Project Estimated costs
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $ProjectCostsBudget,

# Project Cost Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $ProjectCostsRevenue,

# Project Lead
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $ProjectLeadResourceID,

# Project Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('Name')]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [Collections.Generic.List[string]]
    $ProjectName,

# Project Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [Collections.Generic.List[string]]
    $ProjectNumber,

# purchase_order_number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [Collections.Generic.List[string]]
    $PurchaseOrderNumber,

# SG&A
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $SGDA,

# Start Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[datetime]]]
    $StartDateTime,

# Status
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Project -FieldName Status -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Project -FieldName Status -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $Status,

# Status Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[datetime]]]
    $StatusDateTime,

# Status Detail
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [Collections.Generic.List[string]]
    $StatusDetail,

# Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Project -FieldName Type -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Project -FieldName Type -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $Type,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ProjectName', 'ChangeOrdersRevenue', 'StartDateTime', 'CreatorResourceID', 'SGDA', 'LaborEstimatedMarginPercentage', 'EstimatedSalesCost', 'OriginalEstimatedRevenue', 'Department', 'id', 'CompletedPercentage', 'ImpersonatorCreatorResourceID', 'StatusDetail', 'ExtPNumber', 'PurchaseOrderNumber', 'LaborEstimatedCosts', 'ActualHours', 'ProjectCostsRevenue', 'LastActivityDateTime', 'LineOfBusiness', 'Status', 'LastActivityPersonType', 'StatusDateTime', 'EstimatedTime', 'CreateDateTime', 'CompletedDateTime', 'LastActivityResourceID', 'ProjectCostEstimatedMarginPercentage', 'OpportunityID', 'ProjectCostsBudget', 'ChangeOrdersBudget', 'AccountID', 'ExtProjectType', 'Type', 'ActualBilledHours', 'ProjectNumber', 'BusinessDivisionSubdivisionID', 'CompanyOwnerResourceID', 'EndDateTime', 'Duration', 'Description', 'ContractID', 'LaborEstimatedRevenue', 'ProjectLeadResourceID')]
    [Collections.Generic.List[string]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ProjectName', 'ChangeOrdersRevenue', 'StartDateTime', 'CreatorResourceID', 'SGDA', 'LaborEstimatedMarginPercentage', 'EstimatedSalesCost', 'OriginalEstimatedRevenue', 'Department', 'id', 'CompletedPercentage', 'ImpersonatorCreatorResourceID', 'StatusDetail', 'ExtPNumber', 'PurchaseOrderNumber', 'LaborEstimatedCosts', 'ActualHours', 'ProjectCostsRevenue', 'LastActivityDateTime', 'LineOfBusiness', 'Status', 'LastActivityPersonType', 'StatusDateTime', 'EstimatedTime', 'CreateDateTime', 'CompletedDateTime', 'LastActivityResourceID', 'ProjectCostEstimatedMarginPercentage', 'OpportunityID', 'ProjectCostsBudget', 'ChangeOrdersBudget', 'AccountID', 'ExtProjectType', 'Type', 'ActualBilledHours', 'ProjectNumber', 'BusinessDivisionSubdivisionID', 'CompanyOwnerResourceID', 'EndDateTime', 'Duration', 'Description', 'ContractID', 'LaborEstimatedRevenue', 'ProjectLeadResourceID')]
    [Collections.Generic.List[string]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ProjectName', 'ChangeOrdersRevenue', 'StartDateTime', 'CreatorResourceID', 'SGDA', 'LaborEstimatedMarginPercentage', 'EstimatedSalesCost', 'OriginalEstimatedRevenue', 'Department', 'id', 'CompletedPercentage', 'ImpersonatorCreatorResourceID', 'StatusDetail', 'ExtPNumber', 'PurchaseOrderNumber', 'LaborEstimatedCosts', 'ActualHours', 'ProjectCostsRevenue', 'LastActivityDateTime', 'LineOfBusiness', 'Status', 'LastActivityPersonType', 'StatusDateTime', 'EstimatedTime', 'CreateDateTime', 'CompletedDateTime', 'LastActivityResourceID', 'ProjectCostEstimatedMarginPercentage', 'OpportunityID', 'ProjectCostsBudget', 'ChangeOrdersBudget', 'AccountID', 'ExtProjectType', 'Type', 'ActualBilledHours', 'ProjectNumber', 'BusinessDivisionSubdivisionID', 'CompanyOwnerResourceID', 'EndDateTime', 'Duration', 'Description', 'ContractID', 'LaborEstimatedRevenue', 'ProjectLeadResourceID')]
    [Collections.Generic.List[string]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ProjectName', 'AccountID', 'Type', 'ExtProjectType', 'ExtPNumber', 'ProjectNumber', 'Description', 'CreateDateTime', 'CreatorResourceID', 'StartDateTime', 'EndDateTime', 'Duration', 'ActualHours', 'ActualBilledHours', 'EstimatedTime', 'LaborEstimatedRevenue', 'LaborEstimatedCosts', 'LaborEstimatedMarginPercentage', 'ProjectCostsRevenue', 'ProjectCostsBudget', 'ProjectCostEstimatedMarginPercentage', 'ChangeOrdersRevenue', 'ChangeOrdersBudget', 'SGDA', 'OriginalEstimatedRevenue', 'EstimatedSalesCost', 'Status', 'ContractID', 'ProjectLeadResourceID', 'CompanyOwnerResourceID', 'CompletedPercentage', 'CompletedDateTime', 'StatusDetail', 'StatusDateTime', 'Department', 'LineOfBusiness', 'PurchaseOrderNumber', 'BusinessDivisionSubdivisionID', 'LastActivityResourceID', 'LastActivityDateTime', 'LastActivityPersonType', 'ImpersonatorCreatorResourceID', 'OpportunityID')]
    [Collections.Generic.List[string]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ProjectName', 'AccountID', 'Type', 'ExtProjectType', 'ExtPNumber', 'ProjectNumber', 'Description', 'CreateDateTime', 'CreatorResourceID', 'StartDateTime', 'EndDateTime', 'Duration', 'ActualHours', 'ActualBilledHours', 'EstimatedTime', 'LaborEstimatedRevenue', 'LaborEstimatedCosts', 'LaborEstimatedMarginPercentage', 'ProjectCostsRevenue', 'ProjectCostsBudget', 'ProjectCostEstimatedMarginPercentage', 'ChangeOrdersRevenue', 'ChangeOrdersBudget', 'SGDA', 'OriginalEstimatedRevenue', 'EstimatedSalesCost', 'Status', 'ContractID', 'ProjectLeadResourceID', 'CompanyOwnerResourceID', 'CompletedPercentage', 'CompletedDateTime', 'StatusDetail', 'StatusDateTime', 'Department', 'LineOfBusiness', 'PurchaseOrderNumber', 'BusinessDivisionSubdivisionID', 'LastActivityResourceID', 'LastActivityDateTime', 'LastActivityPersonType', 'ImpersonatorCreatorResourceID', 'OpportunityID')]
    [Collections.Generic.List[string]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ProjectName', 'AccountID', 'Type', 'ExtProjectType', 'ExtPNumber', 'ProjectNumber', 'Description', 'CreateDateTime', 'CreatorResourceID', 'StartDateTime', 'EndDateTime', 'Duration', 'ActualHours', 'ActualBilledHours', 'EstimatedTime', 'LaborEstimatedRevenue', 'LaborEstimatedCosts', 'LaborEstimatedMarginPercentage', 'ProjectCostsRevenue', 'ProjectCostsBudget', 'ProjectCostEstimatedMarginPercentage', 'ChangeOrdersRevenue', 'ChangeOrdersBudget', 'SGDA', 'OriginalEstimatedRevenue', 'EstimatedSalesCost', 'Status', 'ContractID', 'ProjectLeadResourceID', 'CompanyOwnerResourceID', 'CompletedPercentage', 'CompletedDateTime', 'StatusDetail', 'StatusDateTime', 'Department', 'LineOfBusiness', 'PurchaseOrderNumber', 'BusinessDivisionSubdivisionID', 'LastActivityResourceID', 'LastActivityDateTime', 'LastActivityPersonType', 'ImpersonatorCreatorResourceID', 'OpportunityID')]
    [Collections.Generic.List[string]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ProjectName', 'AccountID', 'Type', 'ExtProjectType', 'ExtPNumber', 'ProjectNumber', 'Description', 'CreateDateTime', 'CreatorResourceID', 'StartDateTime', 'EndDateTime', 'Duration', 'ActualHours', 'ActualBilledHours', 'EstimatedTime', 'LaborEstimatedRevenue', 'LaborEstimatedCosts', 'LaborEstimatedMarginPercentage', 'ProjectCostsRevenue', 'ProjectCostsBudget', 'ProjectCostEstimatedMarginPercentage', 'ChangeOrdersRevenue', 'ChangeOrdersBudget', 'SGDA', 'OriginalEstimatedRevenue', 'EstimatedSalesCost', 'Status', 'ContractID', 'ProjectLeadResourceID', 'CompanyOwnerResourceID', 'CompletedPercentage', 'CompletedDateTime', 'StatusDetail', 'StatusDateTime', 'Department', 'LineOfBusiness', 'PurchaseOrderNumber', 'BusinessDivisionSubdivisionID', 'LastActivityResourceID', 'LastActivityDateTime', 'LastActivityPersonType', 'ImpersonatorCreatorResourceID', 'OpportunityID')]
    [Collections.Generic.List[string]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ProjectName', 'ExtPNumber', 'ProjectNumber', 'Description', 'StatusDetail', 'PurchaseOrderNumber')]
    [Collections.Generic.List[string]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ProjectName', 'ExtPNumber', 'ProjectNumber', 'Description', 'StatusDetail', 'PurchaseOrderNumber')]
    [Collections.Generic.List[string]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ProjectName', 'ExtPNumber', 'ProjectNumber', 'Description', 'StatusDetail', 'PurchaseOrderNumber')]
    [Collections.Generic.List[string]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ProjectName', 'ExtPNumber', 'ProjectNumber', 'Description', 'StatusDetail', 'PurchaseOrderNumber')]
    [Collections.Generic.List[string]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ProjectName', 'ExtPNumber', 'ProjectNumber', 'Description', 'StatusDetail', 'PurchaseOrderNumber')]
    [Collections.Generic.List[string]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDateTime', 'StartDateTime', 'EndDateTime', 'CompletedDateTime', 'StatusDateTime', 'LastActivityDateTime')]
    [Collections.Generic.List[string]]
    $IsThisDay
  )

    begin {
        $entityName = 'Project'

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
