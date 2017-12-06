<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Get-AtwsQuote
{
  <#
      .SYNOPSIS
      This function get a Quote through the Autotask Web Services API.
      .DESCRIPTION
      This function get a Quote through the Autotask Web Services API.
      .EXAMPLE
      Get-AtwsQuote [-ParameterName] [Parameter value]
      Use Get-Help Get-AtwsQuote
      .NOTES
      NAME: Get-AtwsQuote
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
         $OpportunityID
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
         [string]
         $Name
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [boolean]
         $eQuoteActive
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $EffectiveDate
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $ExpirationDate
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
         [Int]
         $CreatorResourceID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $ContactID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Norway')]

        [String]
         $TaxGroup
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $ProposalProjectID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $BillToLocationID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $ShipToLocationID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $SoldToLocationID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $ShippingType
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
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Net 30 days','Net 45 days','Net 60 days','Due upon receipt')]

        [String]
         $PaymentTerm
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $ExternalQuoteNumber
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
         $Comment
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
         [Int]
         $AccountID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [boolean]
         $PrimaryQuote
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $LastActivityDate
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $LastModifiedBy
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $QuoteTemplateID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Do Not Group','Group by Period Type Only','Group by Product Category Only','Group by Period Type, then Product Category','Group by Product Category, then Period Type')]

        [String]
         $GroupByID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $QuoteNumber
 ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('OpportunityID','id','Name','eQuoteActive','EffectiveDate','ExpirationDate','CreateDate','CreatorResourceID','ContactID','ProposalProjectID','BillToLocationID','ShipToLocationID','SoldToLocationID','ExternalQuoteNumber','PurchaseOrderNumber','Comment','Description','AccountID','PrimaryQuote','LastActivityDate','LastModifiedBy','QuoteTemplateID','QuoteNumber')]
        [String[]]
        $NotEquals ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('OpportunityID','id','Name','eQuoteActive','EffectiveDate','ExpirationDate','CreateDate','CreatorResourceID','ContactID','ProposalProjectID','BillToLocationID','ShipToLocationID','SoldToLocationID','ExternalQuoteNumber','PurchaseOrderNumber','Comment','Description','AccountID','PrimaryQuote','LastActivityDate','LastModifiedBy','QuoteTemplateID','QuoteNumber')]
        [String[]]
        $GreaterThan ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('OpportunityID','id','Name','eQuoteActive','EffectiveDate','ExpirationDate','CreateDate','CreatorResourceID','ContactID','ProposalProjectID','BillToLocationID','ShipToLocationID','SoldToLocationID','ExternalQuoteNumber','PurchaseOrderNumber','Comment','Description','AccountID','PrimaryQuote','LastActivityDate','LastModifiedBy','QuoteTemplateID','QuoteNumber')]
        [String[]]
        $GreaterThanOrEqual ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('OpportunityID','id','Name','eQuoteActive','EffectiveDate','ExpirationDate','CreateDate','CreatorResourceID','ContactID','ProposalProjectID','BillToLocationID','ShipToLocationID','SoldToLocationID','ExternalQuoteNumber','PurchaseOrderNumber','Comment','Description','AccountID','PrimaryQuote','LastActivityDate','LastModifiedBy','QuoteTemplateID','QuoteNumber')]
        [String[]]
        $LessThan ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('OpportunityID','id','Name','eQuoteActive','EffectiveDate','ExpirationDate','CreateDate','CreatorResourceID','ContactID','ProposalProjectID','BillToLocationID','ShipToLocationID','SoldToLocationID','ExternalQuoteNumber','PurchaseOrderNumber','Comment','Description','AccountID','PrimaryQuote','LastActivityDate','LastModifiedBy','QuoteTemplateID','QuoteNumber')]
        [String[]]
        $LessThanOrEquals ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('Name','ExternalQuoteNumber','PurchaseOrderNumber','Comment','Description')]
        [String[]]
        $Like ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('Name','ExternalQuoteNumber','PurchaseOrderNumber','Comment','Description')]
        [String[]]
        $NotLike ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('Name','ExternalQuoteNumber','PurchaseOrderNumber','Comment','Description')]
        [String[]]
        $BeginsWith ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('Name','ExternalQuoteNumber','PurchaseOrderNumber','Comment','Description')]
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
        $Fields = $Atws.GetFieldInfo('Quote')
        
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

    Get-AtwsData -Entity Quote -Filter $Filter }   

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

  }


        
}
