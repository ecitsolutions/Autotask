<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Get-AtwsQuoteItem
{
  <#
      .SYNOPSIS
      This function get a QuoteItem through the Autotask Web Services API.
      .DESCRIPTION
      This function get a QuoteItem through the Autotask Web Services API.
      .EXAMPLE
      Get-AtwsQuoteItem [-ParameterName] [Parameter value]
      Use Get-Help Get-AtwsQuoteItem
      .NOTES
      NAME: Get-AtwsQuoteItem
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
         [Int]
         $QuoteID
 ,

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
         [ValidateSet('Product','Cost','Labor','Expense','Shipping','Discount','Service','ServiceBundle','ContractSetupFee')]

        [String]
         $Type
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $ProductID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $CostID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $LaborID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $ExpenseID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $ShippingID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $ServiceID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $ServiceBundleID
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
         [double]
         $UnitPrice
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
         $Quantity
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [double]
         $UnitDiscount
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [double]
         $PercentageDiscount
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [boolean]
         $IsTaxable
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [boolean]
         $IsOptional
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('One-Time','Monthly','Quarterly','Yearly','Semi-Annual')]

        [String]
         $PeriodType
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
         $LineDiscount
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $TaxCategoryID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [double]
         $TotalEffectiveTax
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [double]
         $MarkupRate
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [double]
         $InternalCurrencyUnitPrice
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [double]
         $InternalCurrencyUnitDiscount
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [double]
         $InternalCurrencyLineDiscount
 ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('QuoteID','id','ProductID','CostID','LaborID','ExpenseID','ShippingID','ServiceID','ServiceBundleID','Name','UnitPrice','UnitCost','Quantity','UnitDiscount','PercentageDiscount','IsTaxable','IsOptional','Description','LineDiscount','TaxCategoryID','TotalEffectiveTax','MarkupRate','InternalCurrencyUnitPrice','InternalCurrencyUnitDiscount','InternalCurrencyLineDiscount')]
        [String[]]
        $NotEquals ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('QuoteID','id','ProductID','CostID','LaborID','ExpenseID','ShippingID','ServiceID','ServiceBundleID','Name','UnitPrice','UnitCost','Quantity','UnitDiscount','PercentageDiscount','IsTaxable','IsOptional','Description','LineDiscount','TaxCategoryID','TotalEffectiveTax','MarkupRate','InternalCurrencyUnitPrice','InternalCurrencyUnitDiscount','InternalCurrencyLineDiscount')]
        [String[]]
        $GreaterThan ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('QuoteID','id','ProductID','CostID','LaborID','ExpenseID','ShippingID','ServiceID','ServiceBundleID','Name','UnitPrice','UnitCost','Quantity','UnitDiscount','PercentageDiscount','IsTaxable','IsOptional','Description','LineDiscount','TaxCategoryID','TotalEffectiveTax','MarkupRate','InternalCurrencyUnitPrice','InternalCurrencyUnitDiscount','InternalCurrencyLineDiscount')]
        [String[]]
        $GreaterThanOrEqual ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('QuoteID','id','ProductID','CostID','LaborID','ExpenseID','ShippingID','ServiceID','ServiceBundleID','Name','UnitPrice','UnitCost','Quantity','UnitDiscount','PercentageDiscount','IsTaxable','IsOptional','Description','LineDiscount','TaxCategoryID','TotalEffectiveTax','MarkupRate','InternalCurrencyUnitPrice','InternalCurrencyUnitDiscount','InternalCurrencyLineDiscount')]
        [String[]]
        $LessThan ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('QuoteID','id','ProductID','CostID','LaborID','ExpenseID','ShippingID','ServiceID','ServiceBundleID','Name','UnitPrice','UnitCost','Quantity','UnitDiscount','PercentageDiscount','IsTaxable','IsOptional','Description','LineDiscount','TaxCategoryID','TotalEffectiveTax','MarkupRate','InternalCurrencyUnitPrice','InternalCurrencyUnitDiscount','InternalCurrencyLineDiscount')]
        [String[]]
        $LessThanOrEquals ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('Name','PeriodType','Description')]
        [String[]]
        $Like ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('Name','PeriodType','Description')]
        [String[]]
        $NotLike ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('Name','PeriodType','Description')]
        [String[]]
        $BeginsWith ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('Name','PeriodType','Description')]
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
        $Fields = $Atws.GetFieldInfo('QuoteItem')
        
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

    Get-AtwsData -Entity QuoteItem -Filter $Filter }   

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

  }


        
}
