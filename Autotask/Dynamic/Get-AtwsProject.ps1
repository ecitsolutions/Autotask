#Requires -Version 4.0
#Version 1.6.2.11
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

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

Additional operators for [String] parameters are:
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

BillingItem
 ExpenseItem
 NotificationHistory
 Phase
 ProjectCost
 ProjectNote
 PurchaseOrderItem
 Quote
 Task
 Ticket

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
    [ValidateSet('AccountID', 'BusinessDivisionSubdivisionID', 'CompanyOwnerResourceID', 'ContractID', 'CreatorResourceID', 'LastActivityResourceID', 'ProjectLeadResourceID')]
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
    [ValidateSet('BillingItem:ProjectID', 'ExpenseItem:ProjectID', 'NotificationHistory:ProjectID', 'Phase:ProjectID', 'ProjectCost:ProjectID', 'ProjectNote:ProjectID', 'PurchaseOrderItem:ProjectID', 'Quote:ProposalProjectID', 'Task:ProjectID', 'Ticket:ProjectID')]
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

# id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Project Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Alias('Name')]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [string[]]
    $ProjectName,

# Account ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $AccountID,

# Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $Type,

# Ext Project Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $ExtPNumber,

# Project Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $ProjectNumber,

# Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string[]]
    $Description,

# Created DateTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CreateDateTime,

# Created By
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CreatorResourceID,

# Start Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $StartDateTime,

# End Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $EndDateTime,

# Duration
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $Duration,

# Actual Hours
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[float][]]
    $ActualHours,

# Actual Billed Hours
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[float][]]
    $ActualBilledHours,

# Estimated Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[float][]]
    $EstimatedTime,

# Labor Estimated Revenue
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[float][]]
    $LaborEstimatedRevenue,

# Labor Estimated Costs
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[float][]]
    $LaborEstimatedCosts,

# Labor Estimated Margin Percentage
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[float][]]
    $LaborEstimatedMarginPercentage,

# Project Cost Revenue
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[float][]]
    $ProjectCostsRevenue,

# Project Estimated costs
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[float][]]
    $ProjectCostsBudget,

# Project Cost Estimated Margin Percentage
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[float][]]
    $ProjectCostEstimatedMarginPercentage,

# Change Orders Revenue
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[float][]]
    $ChangeOrdersRevenue,

# SG&A
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[float][]]
    $SGDA,

# Original Estimated Revenue
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[float][]]
    $OriginalEstimatedRevenue,

# Estimated Sales Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[float][]]
    $EstimatedSalesCost,

# Status
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $Status,

# Contract
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ContractID,

# Project Lead
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ProjectLeadResourceID,

# Account Owner
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CompanyOwnerResourceID,

# Completed Percentage
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CompletedPercentage,

# Completed date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CompletedDateTime,

# Status Detail
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string[]]
    $StatusDetail,

# Status Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $StatusDateTime,

# Department
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $Department,

# Line Of Business
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $LineOfBusiness,

# purchase_order_number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $PurchaseOrderNumber,

# Business Division Subdivision ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BusinessDivisionSubdivisionID,

# Last Activity By
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $LastActivityResourceID,

# Last Activity Date Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LastActivityDateTime,

# Last Activity Person Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $LastActivityPersonType,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ProjectName', 'AccountID', 'Type', 'ExtPNumber', 'ProjectNumber', 'Description', 'CreateDateTime', 'CreatorResourceID', 'StartDateTime', 'EndDateTime', 'Duration', 'ActualHours', 'ActualBilledHours', 'EstimatedTime', 'LaborEstimatedRevenue', 'LaborEstimatedCosts', 'LaborEstimatedMarginPercentage', 'ProjectCostsRevenue', 'ProjectCostsBudget', 'ProjectCostEstimatedMarginPercentage', 'ChangeOrdersRevenue', 'SGDA', 'OriginalEstimatedRevenue', 'EstimatedSalesCost', 'Status', 'ContractID', 'ProjectLeadResourceID', 'CompanyOwnerResourceID', 'CompletedPercentage', 'CompletedDateTime', 'StatusDetail', 'StatusDateTime', 'Department', 'LineOfBusiness', 'PurchaseOrderNumber', 'BusinessDivisionSubdivisionID', 'LastActivityResourceID', 'LastActivityDateTime', 'LastActivityPersonType')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ProjectName', 'AccountID', 'Type', 'ExtPNumber', 'ProjectNumber', 'Description', 'CreateDateTime', 'CreatorResourceID', 'StartDateTime', 'EndDateTime', 'Duration', 'ActualHours', 'ActualBilledHours', 'EstimatedTime', 'LaborEstimatedRevenue', 'LaborEstimatedCosts', 'LaborEstimatedMarginPercentage', 'ProjectCostsRevenue', 'ProjectCostsBudget', 'ProjectCostEstimatedMarginPercentage', 'ChangeOrdersRevenue', 'SGDA', 'OriginalEstimatedRevenue', 'EstimatedSalesCost', 'Status', 'ContractID', 'ProjectLeadResourceID', 'CompanyOwnerResourceID', 'CompletedPercentage', 'CompletedDateTime', 'StatusDetail', 'StatusDateTime', 'Department', 'LineOfBusiness', 'PurchaseOrderNumber', 'BusinessDivisionSubdivisionID', 'LastActivityResourceID', 'LastActivityDateTime', 'LastActivityPersonType')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ProjectName', 'AccountID', 'Type', 'ExtPNumber', 'ProjectNumber', 'Description', 'CreateDateTime', 'CreatorResourceID', 'StartDateTime', 'EndDateTime', 'Duration', 'ActualHours', 'ActualBilledHours', 'EstimatedTime', 'LaborEstimatedRevenue', 'LaborEstimatedCosts', 'LaborEstimatedMarginPercentage', 'ProjectCostsRevenue', 'ProjectCostsBudget', 'ProjectCostEstimatedMarginPercentage', 'ChangeOrdersRevenue', 'SGDA', 'OriginalEstimatedRevenue', 'EstimatedSalesCost', 'Status', 'ContractID', 'ProjectLeadResourceID', 'CompanyOwnerResourceID', 'CompletedPercentage', 'CompletedDateTime', 'StatusDetail', 'StatusDateTime', 'Department', 'LineOfBusiness', 'PurchaseOrderNumber', 'BusinessDivisionSubdivisionID', 'LastActivityResourceID', 'LastActivityDateTime', 'LastActivityPersonType')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ProjectName', 'AccountID', 'Type', 'ExtPNumber', 'ProjectNumber', 'Description', 'CreateDateTime', 'CreatorResourceID', 'StartDateTime', 'EndDateTime', 'Duration', 'ActualHours', 'ActualBilledHours', 'EstimatedTime', 'LaborEstimatedRevenue', 'LaborEstimatedCosts', 'LaborEstimatedMarginPercentage', 'ProjectCostsRevenue', 'ProjectCostsBudget', 'ProjectCostEstimatedMarginPercentage', 'ChangeOrdersRevenue', 'SGDA', 'OriginalEstimatedRevenue', 'EstimatedSalesCost', 'Status', 'ContractID', 'ProjectLeadResourceID', 'CompanyOwnerResourceID', 'CompletedPercentage', 'CompletedDateTime', 'StatusDetail', 'StatusDateTime', 'Department', 'LineOfBusiness', 'PurchaseOrderNumber', 'BusinessDivisionSubdivisionID', 'LastActivityResourceID', 'LastActivityDateTime', 'LastActivityPersonType')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ProjectName', 'AccountID', 'Type', 'ExtPNumber', 'ProjectNumber', 'Description', 'CreateDateTime', 'CreatorResourceID', 'StartDateTime', 'EndDateTime', 'Duration', 'ActualHours', 'ActualBilledHours', 'EstimatedTime', 'LaborEstimatedRevenue', 'LaborEstimatedCosts', 'LaborEstimatedMarginPercentage', 'ProjectCostsRevenue', 'ProjectCostsBudget', 'ProjectCostEstimatedMarginPercentage', 'ChangeOrdersRevenue', 'SGDA', 'OriginalEstimatedRevenue', 'EstimatedSalesCost', 'Status', 'ContractID', 'ProjectLeadResourceID', 'CompanyOwnerResourceID', 'CompletedPercentage', 'CompletedDateTime', 'StatusDetail', 'StatusDateTime', 'Department', 'LineOfBusiness', 'PurchaseOrderNumber', 'BusinessDivisionSubdivisionID', 'LastActivityResourceID', 'LastActivityDateTime', 'LastActivityPersonType')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ProjectName', 'AccountID', 'Type', 'ExtPNumber', 'ProjectNumber', 'Description', 'CreateDateTime', 'CreatorResourceID', 'StartDateTime', 'EndDateTime', 'Duration', 'ActualHours', 'ActualBilledHours', 'EstimatedTime', 'LaborEstimatedRevenue', 'LaborEstimatedCosts', 'LaborEstimatedMarginPercentage', 'ProjectCostsRevenue', 'ProjectCostsBudget', 'ProjectCostEstimatedMarginPercentage', 'ChangeOrdersRevenue', 'SGDA', 'OriginalEstimatedRevenue', 'EstimatedSalesCost', 'Status', 'ContractID', 'ProjectLeadResourceID', 'CompanyOwnerResourceID', 'CompletedPercentage', 'CompletedDateTime', 'StatusDetail', 'StatusDateTime', 'Department', 'LineOfBusiness', 'PurchaseOrderNumber', 'BusinessDivisionSubdivisionID', 'LastActivityResourceID', 'LastActivityDateTime', 'LastActivityPersonType')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ProjectName', 'AccountID', 'Type', 'ExtPNumber', 'ProjectNumber', 'Description', 'CreateDateTime', 'CreatorResourceID', 'StartDateTime', 'EndDateTime', 'Duration', 'ActualHours', 'ActualBilledHours', 'EstimatedTime', 'LaborEstimatedRevenue', 'LaborEstimatedCosts', 'LaborEstimatedMarginPercentage', 'ProjectCostsRevenue', 'ProjectCostsBudget', 'ProjectCostEstimatedMarginPercentage', 'ChangeOrdersRevenue', 'SGDA', 'OriginalEstimatedRevenue', 'EstimatedSalesCost', 'Status', 'ContractID', 'ProjectLeadResourceID', 'CompanyOwnerResourceID', 'CompletedPercentage', 'CompletedDateTime', 'StatusDetail', 'StatusDateTime', 'Department', 'LineOfBusiness', 'PurchaseOrderNumber', 'BusinessDivisionSubdivisionID', 'LastActivityResourceID', 'LastActivityDateTime', 'LastActivityPersonType')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('ProjectName', 'ExtPNumber', 'ProjectNumber', 'Description', 'StatusDetail', 'PurchaseOrderNumber')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('ProjectName', 'ExtPNumber', 'ProjectNumber', 'Description', 'StatusDetail', 'PurchaseOrderNumber')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('ProjectName', 'ExtPNumber', 'ProjectNumber', 'Description', 'StatusDetail', 'PurchaseOrderNumber')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('ProjectName', 'ExtPNumber', 'ProjectNumber', 'Description', 'StatusDetail', 'PurchaseOrderNumber')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('ProjectName', 'ExtPNumber', 'ProjectNumber', 'Description', 'StatusDetail', 'PurchaseOrderNumber')]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('CreateDateTime', 'StartDateTime', 'EndDateTime', 'CompletedDateTime', 'StatusDateTime', 'LastActivityDateTime')]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'Project'
    
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
    
      # Datetimeparameters
      $Fields = Get-AtwsFieldInfo -Entity $EntityName
    
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
