<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Get-AtwsBillingItem
{
  <#
      .SYNOPSIS
      This function get one or more BillingItem through the Autotask Web Services API.
      .DESCRIPTION
      This function creates a query based on any parameters you give and returns any resulting 
objects from the Autotask Web Services Api. By default the function returns any objects with properties 
that are Equal (-eq) to the value of the parameter. To give you more flexibility you can modify the operator
by using -NotEquals [ParameterName[]], -LessThan [ParameterName[]] and so on. 
Use Get-help Get-AtwsBillingItem for all possible operators.
      .INPUTS
      Nothing. This function only takes parameters.
      .OUTPUTS
      [Autotask.BillingItem[]]. This function outputs the Autotask.BillingItem that was returned by the API.
      .EXAMPLE
      Get-AtwsBillingItem  -Parameter1 [Parameter1 value] -Parameter2 [Parameter2 Value] -GreaterThan Parameter2
Returns all objects where a property by name of "Parameter1" is equal to [Parameter1 value] and where a property
by name of "Parameter2" is greater than [Parameter2 Value].
      For parameters, use Get-Help Get-AtwsBillingItem
      .NOTES
      NAME: Get-AtwsBillingItem
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
         [ValidateSet('Labor','Project Cost','Ticket Cost','Expense','Subscription','Setup Fee','Recurring Services','Recurring Services Adjustment','Recurring Service Bundle','Recurring Service Bundle Adjustment','Milestone','Contract Block','Contract Retainer','Contract Cost','Contract Incident')]

        [String]
         $Type
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Labor','Milestone Labor','Project Cost Deductions','Project Cost','Ticket Cost Deductions','Ticket Cost','Expense','Expense Deductions','Subscription','Subscription Cost','Setup Fee','Recurring Services','Recurring Services Adjustment','Recurring Service Bundle','Recurring Service Bundle Adjustment','Milestones','Block Purchase','Retainer Purchase')]

        [String]
         $SubType
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $ItemName
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
         [double]
         $Quantity
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [double]
         $Rate
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [double]
         $TotalAmount
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [double]
         $OurCost
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $ItemDate
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $ApprovedTime
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $InvoiceID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $ItemApproverID
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
         [Int]
         $TicketID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $TaskID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $ProjectID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $AllocationCodeID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $RoleID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $TimeEntryID
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
         [datetime]
         $WebServiceDate
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $NonBillable
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [double]
         $TaxDollars
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $PurchaseOrderNumber
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [double]
         $ExtendedPrice
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $ExpenseItemID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [long]
         $ContractCostID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [long]
         $ProjectCostID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [long]
         $TicketCostID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [long]
         $LineItemID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [long]
         $MilestoneID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [long]
         $ServiceID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [long]
         $ServiceBundleID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [long]
         $VendorID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [long]
         $InstalledProductID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [double]
         $InternalCurrencyExtendedPrice
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [double]
         $InternalCurrencyRate
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [double]
         $InternalCurrencyTaxDollars
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [double]
         $InternalCurrencyTotalAmount
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $AccountManagerWhenApprovedID
 ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('id','ItemName','Description','Quantity','Rate','TotalAmount','OurCost','ItemDate','ApprovedTime','InvoiceID','ItemApproverID','AccountID','TicketID','TaskID','ProjectID','AllocationCodeID','RoleID','TimeEntryID','ContractID','WebServiceDate','NonBillable','TaxDollars','PurchaseOrderNumber','ExtendedPrice','ExpenseItemID','ContractCostID','ProjectCostID','TicketCostID','LineItemID','MilestoneID','ServiceID','ServiceBundleID','VendorID','InstalledProductID','InternalCurrencyExtendedPrice','InternalCurrencyRate','InternalCurrencyTaxDollars','InternalCurrencyTotalAmount','AccountManagerWhenApprovedID')]
        [String[]]
        $NotEquals ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('id','ItemName','Description','Quantity','Rate','TotalAmount','OurCost','ItemDate','ApprovedTime','InvoiceID','ItemApproverID','AccountID','TicketID','TaskID','ProjectID','AllocationCodeID','RoleID','TimeEntryID','ContractID','WebServiceDate','NonBillable','TaxDollars','PurchaseOrderNumber','ExtendedPrice','ExpenseItemID','ContractCostID','ProjectCostID','TicketCostID','LineItemID','MilestoneID','ServiceID','ServiceBundleID','VendorID','InstalledProductID','InternalCurrencyExtendedPrice','InternalCurrencyRate','InternalCurrencyTaxDollars','InternalCurrencyTotalAmount','AccountManagerWhenApprovedID')]
        [String[]]
        $GreaterThan ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('id','ItemName','Description','Quantity','Rate','TotalAmount','OurCost','ItemDate','ApprovedTime','InvoiceID','ItemApproverID','AccountID','TicketID','TaskID','ProjectID','AllocationCodeID','RoleID','TimeEntryID','ContractID','WebServiceDate','NonBillable','TaxDollars','PurchaseOrderNumber','ExtendedPrice','ExpenseItemID','ContractCostID','ProjectCostID','TicketCostID','LineItemID','MilestoneID','ServiceID','ServiceBundleID','VendorID','InstalledProductID','InternalCurrencyExtendedPrice','InternalCurrencyRate','InternalCurrencyTaxDollars','InternalCurrencyTotalAmount','AccountManagerWhenApprovedID')]
        [String[]]
        $GreaterThanOrEqual ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('id','ItemName','Description','Quantity','Rate','TotalAmount','OurCost','ItemDate','ApprovedTime','InvoiceID','ItemApproverID','AccountID','TicketID','TaskID','ProjectID','AllocationCodeID','RoleID','TimeEntryID','ContractID','WebServiceDate','NonBillable','TaxDollars','PurchaseOrderNumber','ExtendedPrice','ExpenseItemID','ContractCostID','ProjectCostID','TicketCostID','LineItemID','MilestoneID','ServiceID','ServiceBundleID','VendorID','InstalledProductID','InternalCurrencyExtendedPrice','InternalCurrencyRate','InternalCurrencyTaxDollars','InternalCurrencyTotalAmount','AccountManagerWhenApprovedID')]
        [String[]]
        $LessThan ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('id','ItemName','Description','Quantity','Rate','TotalAmount','OurCost','ItemDate','ApprovedTime','InvoiceID','ItemApproverID','AccountID','TicketID','TaskID','ProjectID','AllocationCodeID','RoleID','TimeEntryID','ContractID','WebServiceDate','NonBillable','TaxDollars','PurchaseOrderNumber','ExtendedPrice','ExpenseItemID','ContractCostID','ProjectCostID','TicketCostID','LineItemID','MilestoneID','ServiceID','ServiceBundleID','VendorID','InstalledProductID','InternalCurrencyExtendedPrice','InternalCurrencyRate','InternalCurrencyTaxDollars','InternalCurrencyTotalAmount','AccountManagerWhenApprovedID')]
        [String[]]
        $LessThanOrEquals ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('ItemName','Description','PurchaseOrderNumber')]
        [String[]]
        $Like ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('ItemName','Description','PurchaseOrderNumber')]
        [String[]]
        $NotLike ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('ItemName','Description','PurchaseOrderNumber')]
        [String[]]
        $BeginsWith ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('ItemName','Description','PurchaseOrderNumber')]
        [String[]]
        $EndsWith ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('ItemName','Description','PurchaseOrderNumber')]
        [String[]]
        $Contains
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
        $Fields = $Atws.GetFieldInfo('BillingItem')
        
        Foreach ($Parameter in $PSBoundParameters.GetEnumerator())
        {
            $Field = $Fields | Where-Object {$_.Name -eq $Parameter.Key}
            If ($Field)
            { 
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
                If ($Parameter.Key -in $NotEquals)
                { $Filter += '-ne'}
                ElseIf ($Parameter.Key -in $GreaterThan)
                { $Filter += '-gt'}
                ElseIf ($Parameter.Key -in $GreaterThanOrEqual)
                { $Filter += '-ge'}
                ElseIf ($Parameter.Key -in $LessThan)
                { $Filter += '-lt'}
                ElseIf ($Parameter.Key -in $LessThanOrEquals)
                { $Filter += '-le'}
                ElseIf ($Parameter.Key -in $Like)
                { $Filter += '-like'}
                ElseIf ($Parameter.Key -in $NotLike)
                { $Filter += '-notlike'}
                ElseIf ($Parameter.Key -in $BeginsWith)
                { $Filter += '-beginswith'}
                ElseIf ($Parameter.Key -in $EndsWith)
                { $Filter += '-endswith'}
                ElseIf ($Parameter.Key -in $Contains)
                { $Filter += '-contains'}
                Else
                { $Filter += '-eq'}
                $Filter += $Value
            }
        }
        
    } #'NotEquals','GreaterThan','GreaterThanOrEqual','LessThan','LessThanOrEquals','Like','NotLike','BeginsWith','EndsWith

    Get-AtwsData -Entity BillingItem -Filter $Filter }   

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

  }


        
}
