<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Get-AtwsProject
{
  <#
      .SYNOPSIS
      This function get a Project through the Autotask Web Services API.
      .DESCRIPTION
      This function get a Project through the Autotask Web Services API.
      .EXAMPLE
      Get-AtwsProject [-ParameterName] [Parameter value]
      Use Get-Help Get-AtwsProject
      .NOTES
      NAME: Get-AtwsProject
  #>
	  [CmdLetBinding(DefaultParameterSetName='Filter')]
    Param
    (
                [Parameter(
          Mandatory = $true,
          ValueFromRemainingArguments = $true,
          ParameterSetName = 'Filter')]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Filter ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [long]
         $id
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $ProjectName
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $AccountID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Proposal','Template','Internal','Client','Baseline')]

        [String]
         $Type
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $ExtPNumber
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $ProjectNumber
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $Description
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $CreateDateTime
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $CreatorResourceID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $StartDateTime
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $EndDateTime
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $Duration
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [float]
         $ActualHours
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [float]
         $ActualBilledHours
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [float]
         $EstimatedTime
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [float]
         $LaborEstimatedRevenue
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [float]
         $LaborEstimatedCosts
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [float]
         $LaborEstimatedMarginPercentage
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [float]
         $ProjectCostsRevenue
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [float]
         $ProjectCostsBudget
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [float]
         $ProjectCostEstimatedMarginPercentage
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [float]
         $ChangeOrdersRevenue
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [float]
         $SGDA
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [float]
         $OriginalEstimatedRevenue
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [float]
         $EstimatedSalesCost
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Inactive','New','In Progress','On Hold','Change Order','Waiting Parts','Waiting Customer','Complete')]

        [String]
         $Status
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $ContractID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $ProjectLeadResourceID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $CompanyOwnerResourceID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $CompletedPercentage
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $CompletedDateTime
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $StatusDetail
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $StatusDateTime
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Administration','Inaktive brukere','Konsulentteam','Overvåkning','Prosjekt','Salg','Service & Support','Tjenester')]

        [String]
         $Department
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Småprosjekter','Drift','Totalleveranser','Dokumenthåndtering')]

        [String]
         $LineOfBusiness
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $PurchaseOrderNumber
 ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','ProjectName','AccountID','ExtPNumber','ProjectNumber','Description','CreateDateTime','CreatorResourceID','StartDateTime','EndDateTime','Duration','ActualHours','ActualBilledHours','EstimatedTime','LaborEstimatedRevenue','LaborEstimatedCosts','LaborEstimatedMarginPercentage','ProjectCostsRevenue','ProjectCostsBudget','ProjectCostEstimatedMarginPercentage','ChangeOrdersRevenue','SGDA','OriginalEstimatedRevenue','EstimatedSalesCost','ContractID','ProjectLeadResourceID','CompanyOwnerResourceID','CompletedPercentage','CompletedDateTime','StatusDetail','StatusDateTime','PurchaseOrderNumber')]
        [String[]]
        $NotEquals ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','ProjectName','AccountID','ExtPNumber','ProjectNumber','Description','CreateDateTime','CreatorResourceID','StartDateTime','EndDateTime','Duration','ActualHours','ActualBilledHours','EstimatedTime','LaborEstimatedRevenue','LaborEstimatedCosts','LaborEstimatedMarginPercentage','ProjectCostsRevenue','ProjectCostsBudget','ProjectCostEstimatedMarginPercentage','ChangeOrdersRevenue','SGDA','OriginalEstimatedRevenue','EstimatedSalesCost','ContractID','ProjectLeadResourceID','CompanyOwnerResourceID','CompletedPercentage','CompletedDateTime','StatusDetail','StatusDateTime','PurchaseOrderNumber')]
        [String[]]
        $GreaterThan ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','ProjectName','AccountID','ExtPNumber','ProjectNumber','Description','CreateDateTime','CreatorResourceID','StartDateTime','EndDateTime','Duration','ActualHours','ActualBilledHours','EstimatedTime','LaborEstimatedRevenue','LaborEstimatedCosts','LaborEstimatedMarginPercentage','ProjectCostsRevenue','ProjectCostsBudget','ProjectCostEstimatedMarginPercentage','ChangeOrdersRevenue','SGDA','OriginalEstimatedRevenue','EstimatedSalesCost','ContractID','ProjectLeadResourceID','CompanyOwnerResourceID','CompletedPercentage','CompletedDateTime','StatusDetail','StatusDateTime','PurchaseOrderNumber')]
        [String[]]
        $GreaterThanOrEqual ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','ProjectName','AccountID','ExtPNumber','ProjectNumber','Description','CreateDateTime','CreatorResourceID','StartDateTime','EndDateTime','Duration','ActualHours','ActualBilledHours','EstimatedTime','LaborEstimatedRevenue','LaborEstimatedCosts','LaborEstimatedMarginPercentage','ProjectCostsRevenue','ProjectCostsBudget','ProjectCostEstimatedMarginPercentage','ChangeOrdersRevenue','SGDA','OriginalEstimatedRevenue','EstimatedSalesCost','ContractID','ProjectLeadResourceID','CompanyOwnerResourceID','CompletedPercentage','CompletedDateTime','StatusDetail','StatusDateTime','PurchaseOrderNumber')]
        [String[]]
        $LessThan ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','ProjectName','AccountID','ExtPNumber','ProjectNumber','Description','CreateDateTime','CreatorResourceID','StartDateTime','EndDateTime','Duration','ActualHours','ActualBilledHours','EstimatedTime','LaborEstimatedRevenue','LaborEstimatedCosts','LaborEstimatedMarginPercentage','ProjectCostsRevenue','ProjectCostsBudget','ProjectCostEstimatedMarginPercentage','ChangeOrdersRevenue','SGDA','OriginalEstimatedRevenue','EstimatedSalesCost','ContractID','ProjectLeadResourceID','CompanyOwnerResourceID','CompletedPercentage','CompletedDateTime','StatusDetail','StatusDateTime','PurchaseOrderNumber')]
        [String[]]
        $LessThanOrEquals ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('ProjectName','ExtPNumber','ProjectNumber','Description','StatusDetail','PurchaseOrderNumber')]
        [String[]]
        $Like ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('ProjectName','ExtPNumber','ProjectNumber','Description','StatusDetail','PurchaseOrderNumber')]
        [String[]]
        $NotLike ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('ProjectName','ExtPNumber','ProjectNumber','Description','StatusDetail','PurchaseOrderNumber')]
        [String[]]
        $BeginsWith ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('ProjectName','ExtPNumber','ProjectNumber','Description','StatusDetail','PurchaseOrderNumber')]
        [String[]]
        $EndsWith
    )



          

  Begin
  { 
    If (-not($global:atws.Url))
    {
      Throw [ApplicationException] 'Not connected to Autotask WebAPI. Run Connect-AutotaskWebAPI first.'
    }
    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

  }   

  Process
  {     

    If (-not($Filter))
    {
        $Fields = $Atws.GetFieldInfo('Project')
        
        Foreach ($Parameter in $PSBoundParameters.GetEnumerator())
        {
            $Field = $Fields | Where-Object {$_.Name -eq $Parameter.Key}
            If ($Field.IsPickList)
            {
              $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $Parameter.Value}
              $Value = $PickListValue.Value
            }
            Else
            {
              $Value = $Parameter.Value
            }
            $Filter += $Parameter.Key
            $Filter += '-eq'
            $Filter += $Value
        }
        
    }

    Get-AtwsData -Entity Project -Filter $Filter }   

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

  }


        
}
