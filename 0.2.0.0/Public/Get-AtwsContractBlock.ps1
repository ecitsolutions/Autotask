<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Get-AtwsContractBlock
{
  <#
      .SYNOPSIS
      This function get a ContractBlock through the Autotask Web Services API.
      .DESCRIPTION
      This function get a ContractBlock through the Autotask Web Services API.
      .EXAMPLE
      Get-AtwsContractBlock [-ParameterName] [Parameter value]
      Use Get-Help Get-AtwsContractBlock
      .NOTES
      NAME: Get-AtwsContractBlock
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
         [Int]
         $ContractID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Inactive','Active')]

        [String]
         $Status
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('True','False')]

        [String]
         $IsPaid
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
         [datetime]
         $StartDate
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $EndDate
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [double]
         $Hours
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [double]
         $HourlyRate
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $InvoiceNumber
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $PaymentNumber
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Company Check','Visa','Master Card','American Express','Cash','Personal Check','Other','Company Credit Card')]

        [String]
         $PaymentType
 ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','ContractID','DatePurchased','StartDate','EndDate','Hours','HourlyRate','InvoiceNumber','PaymentNumber')]
        [String[]]
        $NotEquals ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','ContractID','DatePurchased','StartDate','EndDate','Hours','HourlyRate','InvoiceNumber','PaymentNumber')]
        [String[]]
        $GreaterThan ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','ContractID','DatePurchased','StartDate','EndDate','Hours','HourlyRate','InvoiceNumber','PaymentNumber')]
        [String[]]
        $GreaterThanOrEqual ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','ContractID','DatePurchased','StartDate','EndDate','Hours','HourlyRate','InvoiceNumber','PaymentNumber')]
        [String[]]
        $LessThan ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','ContractID','DatePurchased','StartDate','EndDate','Hours','HourlyRate','InvoiceNumber','PaymentNumber')]
        [String[]]
        $LessThanOrEquals ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('IsPaid','InvoiceNumber','PaymentNumber')]
        [String[]]
        $Like ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('IsPaid','InvoiceNumber','PaymentNumber')]
        [String[]]
        $NotLike ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('IsPaid','InvoiceNumber','PaymentNumber')]
        [String[]]
        $BeginsWith ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('IsPaid','InvoiceNumber','PaymentNumber')]
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
        $Fields = $Atws.GetFieldInfo('ContractBlock')
        
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

    Get-AtwsData -Entity ContractBlock -Filter $Filter }   

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

  }


        
}
