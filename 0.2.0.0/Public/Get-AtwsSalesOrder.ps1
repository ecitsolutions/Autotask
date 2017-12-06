<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Get-AtwsSalesOrder
{
  <#
      .SYNOPSIS
      This function get a SalesOrder through the Autotask Web Services API.
      .DESCRIPTION
      This function get a SalesOrder through the Autotask Web Services API.
      .EXAMPLE
      Get-AtwsSalesOrder [-ParameterName] [Parameter value]
      Use Get-Help Get-AtwsSalesOrder
      .NOTES
      NAME: Get-AtwsSalesOrder
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
         $id
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
         [string]
         $Title
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Open','In Progress','Partially Fulfilled','Fulfilled','Canceled')]

        [String]
         $Status
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $Contact
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $OwnerResourceID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $SalesOrderDate
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $PromisedDueDate
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $BillToAddress1
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $BillToAddress2
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $BillToCity
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $BillToState
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $BillToPostalCode
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $BillToCountry
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $ShipToAddress1
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $ShipToAddress2
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $ShipToCity
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $ShipToState
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $ShipToPostalCode
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $ShipToCountry
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $OpportunityID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $AdditionalBillToAddressInformation
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $AdditionalShipToAddressInformation
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $BillToCountryID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $ShipToCountryID
 ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','AccountID','Title','Contact','OwnerResourceID','SalesOrderDate','PromisedDueDate','BillToAddress1','BillToAddress2','BillToCity','BillToState','BillToPostalCode','BillToCountry','ShipToAddress1','ShipToAddress2','ShipToCity','ShipToState','ShipToPostalCode','ShipToCountry','OpportunityID','AdditionalBillToAddressInformation','AdditionalShipToAddressInformation','BillToCountryID','ShipToCountryID')]
        [String[]]
        $NotEquals ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','AccountID','Title','Contact','OwnerResourceID','SalesOrderDate','PromisedDueDate','BillToAddress1','BillToAddress2','BillToCity','BillToState','BillToPostalCode','BillToCountry','ShipToAddress1','ShipToAddress2','ShipToCity','ShipToState','ShipToPostalCode','ShipToCountry','OpportunityID','AdditionalBillToAddressInformation','AdditionalShipToAddressInformation','BillToCountryID','ShipToCountryID')]
        [String[]]
        $GreaterThan ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','AccountID','Title','Contact','OwnerResourceID','SalesOrderDate','PromisedDueDate','BillToAddress1','BillToAddress2','BillToCity','BillToState','BillToPostalCode','BillToCountry','ShipToAddress1','ShipToAddress2','ShipToCity','ShipToState','ShipToPostalCode','ShipToCountry','OpportunityID','AdditionalBillToAddressInformation','AdditionalShipToAddressInformation','BillToCountryID','ShipToCountryID')]
        [String[]]
        $GreaterThanOrEqual ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','AccountID','Title','Contact','OwnerResourceID','SalesOrderDate','PromisedDueDate','BillToAddress1','BillToAddress2','BillToCity','BillToState','BillToPostalCode','BillToCountry','ShipToAddress1','ShipToAddress2','ShipToCity','ShipToState','ShipToPostalCode','ShipToCountry','OpportunityID','AdditionalBillToAddressInformation','AdditionalShipToAddressInformation','BillToCountryID','ShipToCountryID')]
        [String[]]
        $LessThan ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','AccountID','Title','Contact','OwnerResourceID','SalesOrderDate','PromisedDueDate','BillToAddress1','BillToAddress2','BillToCity','BillToState','BillToPostalCode','BillToCountry','ShipToAddress1','ShipToAddress2','ShipToCity','ShipToState','ShipToPostalCode','ShipToCountry','OpportunityID','AdditionalBillToAddressInformation','AdditionalShipToAddressInformation','BillToCountryID','ShipToCountryID')]
        [String[]]
        $LessThanOrEquals ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('Title','BillToAddress1','BillToAddress2','BillToCity','BillToState','BillToPostalCode','BillToCountry','ShipToAddress1','ShipToAddress2','ShipToCity','ShipToState','ShipToPostalCode','ShipToCountry','AdditionalBillToAddressInformation','AdditionalShipToAddressInformation')]
        [String[]]
        $Like ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('Title','BillToAddress1','BillToAddress2','BillToCity','BillToState','BillToPostalCode','BillToCountry','ShipToAddress1','ShipToAddress2','ShipToCity','ShipToState','ShipToPostalCode','ShipToCountry','AdditionalBillToAddressInformation','AdditionalShipToAddressInformation')]
        [String[]]
        $NotLike ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('Title','BillToAddress1','BillToAddress2','BillToCity','BillToState','BillToPostalCode','BillToCountry','ShipToAddress1','ShipToAddress2','ShipToCity','ShipToState','ShipToPostalCode','ShipToCountry','AdditionalBillToAddressInformation','AdditionalShipToAddressInformation')]
        [String[]]
        $BeginsWith ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('Title','BillToAddress1','BillToAddress2','BillToCity','BillToState','BillToPostalCode','BillToCountry','ShipToAddress1','ShipToAddress2','ShipToCity','ShipToState','ShipToPostalCode','ShipToCountry','AdditionalBillToAddressInformation','AdditionalShipToAddressInformation')]
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
        $Fields = $Atws.GetFieldInfo('SalesOrder')
        
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

    Get-AtwsData -Entity SalesOrder -Filter $Filter }   

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

  }


        
}
