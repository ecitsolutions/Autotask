﻿<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Get-AtwsTicketCost
{
  <#
      .SYNOPSIS
      This function get a TicketCost through the Autotask Web Services API.
      .DESCRIPTION
      This function get a TicketCost through the Autotask Web Services API.
      .EXAMPLE
      Get-AtwsTicketCost [-ParameterName] [Parameter value]
      Use Get-Help Get-AtwsTicketCost
      .NOTES
      NAME: Get-AtwsTicketCost
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
         [long]
         $TicketID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [long]
         $ProductID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [long]
         $AllocationCodeID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $Name
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
         $DatePurchased
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Operational','Capitalized')]

        [String]
         $CostType
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
         [string]
         $InternalPurchaseOrderNumber
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [double]
         $UnitQuantity
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [double]
         $UnitCost
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [double]
         $UnitPrice
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [double]
         $ExtendedCost
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [double]
         $BillableAmount
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [boolean]
         $BillableToAccount
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [boolean]
         $Billed
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Pending','Waiting Approval','Need to Order/Fulfill','On Order','Ready to Deliver/Ship','Delivered/Shipped Full','Canceled')]

        [String]
         $Status
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [long]
         $StatusLastModifiedBy
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $StatusLastModifiedDate
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $CreateDate
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [long]
         $CreatorResourceID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [long]
         $ContractServiceID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [long]
         $ContractServiceBundleID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [double]
         $InternalCurrencyBillableAmount
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [double]
         $InternalCurrencyUnitPrice
 ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','TicketID','ProductID','AllocationCodeID','Name','Description','DatePurchased','PurchaseOrderNumber','InternalPurchaseOrderNumber','UnitQuantity','UnitCost','UnitPrice','ExtendedCost','BillableAmount','BillableToAccount','Billed','StatusLastModifiedBy','StatusLastModifiedDate','CreateDate','CreatorResourceID','ContractServiceID','ContractServiceBundleID','InternalCurrencyBillableAmount','InternalCurrencyUnitPrice')]
        [String[]]
        $NotEquals ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','TicketID','ProductID','AllocationCodeID','Name','Description','DatePurchased','PurchaseOrderNumber','InternalPurchaseOrderNumber','UnitQuantity','UnitCost','UnitPrice','ExtendedCost','BillableAmount','BillableToAccount','Billed','StatusLastModifiedBy','StatusLastModifiedDate','CreateDate','CreatorResourceID','ContractServiceID','ContractServiceBundleID','InternalCurrencyBillableAmount','InternalCurrencyUnitPrice')]
        [String[]]
        $GreaterThan ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','TicketID','ProductID','AllocationCodeID','Name','Description','DatePurchased','PurchaseOrderNumber','InternalPurchaseOrderNumber','UnitQuantity','UnitCost','UnitPrice','ExtendedCost','BillableAmount','BillableToAccount','Billed','StatusLastModifiedBy','StatusLastModifiedDate','CreateDate','CreatorResourceID','ContractServiceID','ContractServiceBundleID','InternalCurrencyBillableAmount','InternalCurrencyUnitPrice')]
        [String[]]
        $GreaterThanOrEqual ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','TicketID','ProductID','AllocationCodeID','Name','Description','DatePurchased','PurchaseOrderNumber','InternalPurchaseOrderNumber','UnitQuantity','UnitCost','UnitPrice','ExtendedCost','BillableAmount','BillableToAccount','Billed','StatusLastModifiedBy','StatusLastModifiedDate','CreateDate','CreatorResourceID','ContractServiceID','ContractServiceBundleID','InternalCurrencyBillableAmount','InternalCurrencyUnitPrice')]
        [String[]]
        $LessThan ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','TicketID','ProductID','AllocationCodeID','Name','Description','DatePurchased','PurchaseOrderNumber','InternalPurchaseOrderNumber','UnitQuantity','UnitCost','UnitPrice','ExtendedCost','BillableAmount','BillableToAccount','Billed','StatusLastModifiedBy','StatusLastModifiedDate','CreateDate','CreatorResourceID','ContractServiceID','ContractServiceBundleID','InternalCurrencyBillableAmount','InternalCurrencyUnitPrice')]
        [String[]]
        $LessThanOrEquals ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('Name','Description','PurchaseOrderNumber','InternalPurchaseOrderNumber')]
        [String[]]
        $Like ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('Name','Description','PurchaseOrderNumber','InternalPurchaseOrderNumber')]
        [String[]]
        $NotLike ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('Name','Description','PurchaseOrderNumber','InternalPurchaseOrderNumber')]
        [String[]]
        $BeginsWith ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('Name','Description','PurchaseOrderNumber','InternalPurchaseOrderNumber')]
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
        $Fields = $Atws.GetFieldInfo('TicketCost')
        
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

    Get-AtwsData -Entity TicketCost -Filter $Filter }   

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

  }


        
}