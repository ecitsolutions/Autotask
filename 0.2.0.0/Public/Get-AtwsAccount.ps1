<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Get-AtwsAccount
{
  <#
      .SYNOPSIS
      This function get one or more Account through the Autotask Web Services API.
      .DESCRIPTION
      This function creates a query based on any parameters you give and returns any resulting 
objects from the Autotask Web Services Api. By default the function returns any objects with properties 
that are Equal (-eq) to the value of the parameter. To give you more flexibility you can modify the operator
by using -NotEquals [ParameterName[]], -LessThan [ParameterName[]] and so on. 
Use Get-help Get-AtwsAccount for all possible operators.
      .INPUTS
      Nothing. This function only takes parameters.
      .OUTPUTS
      [Autotask.Account[]]. This function outputs the Autotask.Account that was returned by the API.
      .EXAMPLE
      Get-AtwsAccount  -Parameter1 [Parameter1 value] -Parameter2 [Parameter2 Value] -GreaterThan Parameter2
Returns all objects where a property by name of "Parameter1" is equal to [Parameter1 value] and where a property
by name of "Parameter2" is greater than [Parameter2 Value].
      For parameters, use Get-Help Get-AtwsAccount
      .NOTES
      NAME: Get-AtwsAccount
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
         $AccountName
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $Address1
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $Address2
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $City
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $State
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $PostalCode
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $Country
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $Phone
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $AlternatePhone1
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $AlternatePhone2
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $Fax
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $WebAddress
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Customer','Lead','Prospect','Dead','Cancellation','Vendor','Partner')]

        [String]
         $AccountType
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Block Hour Client','Blue','Bronze','Canceled','Delinquent','Gold','Jeopardy Company','Residential','Silver','T&M','Target')]

        [String]
         $KeyAccountIcon
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
         [ValidateSet('Local','Annet','Hallingdal','Hole','Jevnaker/Hadeland','Krodsherad','Modum','Oslo området','Ringerike')]

        [String]
         $TerritoryID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Commercial','Residential','Not For Profit')]

        [String]
         $MarketSegmentID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $CompetitorID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $ParentAccountID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $AccountNumber
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
         [datetime]
         $LastActivityDate
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [boolean]
         $Active
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [boolean]
         $TaskFireActive
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [boolean]
         $ClientPortalActive
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $TaxRegionID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [boolean]
         $TaxExempt
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $TaxID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $AdditionalAddressInformation
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $CountryID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('NONE','ACCOUNT','ACCOUNTBILLING','PARENT','PARENTBILLING')]

        [String]
         $BillToAddressToUse
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $BillToAttention
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
         $BillToZipCode
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
         [string]
         $BillToAdditionalAddressInformation
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('None','Print','Email','PrintAndEmail')]

        [String]
         $InvoiceMethod
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [boolean]
         $InvoiceNonContractItemsToParentAccount
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
         [Int]
         $QuoteEmailMessageID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $InvoiceTemplateID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $InvoiceEmailMessageID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $CurrencyID
 ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('id','AccountName','Address1','Address2','City','State','PostalCode','Country','Phone','AlternatePhone1','AlternatePhone2','Fax','WebAddress','OwnerResourceID','ParentAccountID','AccountNumber','CreateDate','LastActivityDate','Active','TaskFireActive','ClientPortalActive','TaxRegionID','TaxExempt','TaxID','AdditionalAddressInformation','CountryID','BillToAttention','BillToAddress1','BillToAddress2','BillToCity','BillToState','BillToZipCode','BillToCountryID','BillToAdditionalAddressInformation','InvoiceNonContractItemsToParentAccount','QuoteTemplateID','QuoteEmailMessageID','InvoiceTemplateID','InvoiceEmailMessageID','CurrencyID')]
        [String[]]
        $NotEquals ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('id','AccountName','Address1','Address2','City','State','PostalCode','Country','Phone','AlternatePhone1','AlternatePhone2','Fax','WebAddress','OwnerResourceID','ParentAccountID','AccountNumber','CreateDate','LastActivityDate','Active','TaskFireActive','ClientPortalActive','TaxRegionID','TaxExempt','TaxID','AdditionalAddressInformation','CountryID','BillToAttention','BillToAddress1','BillToAddress2','BillToCity','BillToState','BillToZipCode','BillToCountryID','BillToAdditionalAddressInformation','InvoiceNonContractItemsToParentAccount','QuoteTemplateID','QuoteEmailMessageID','InvoiceTemplateID','InvoiceEmailMessageID','CurrencyID')]
        [String[]]
        $GreaterThan ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('id','AccountName','Address1','Address2','City','State','PostalCode','Country','Phone','AlternatePhone1','AlternatePhone2','Fax','WebAddress','OwnerResourceID','ParentAccountID','AccountNumber','CreateDate','LastActivityDate','Active','TaskFireActive','ClientPortalActive','TaxRegionID','TaxExempt','TaxID','AdditionalAddressInformation','CountryID','BillToAttention','BillToAddress1','BillToAddress2','BillToCity','BillToState','BillToZipCode','BillToCountryID','BillToAdditionalAddressInformation','InvoiceNonContractItemsToParentAccount','QuoteTemplateID','QuoteEmailMessageID','InvoiceTemplateID','InvoiceEmailMessageID','CurrencyID')]
        [String[]]
        $GreaterThanOrEqual ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('id','AccountName','Address1','Address2','City','State','PostalCode','Country','Phone','AlternatePhone1','AlternatePhone2','Fax','WebAddress','OwnerResourceID','ParentAccountID','AccountNumber','CreateDate','LastActivityDate','Active','TaskFireActive','ClientPortalActive','TaxRegionID','TaxExempt','TaxID','AdditionalAddressInformation','CountryID','BillToAttention','BillToAddress1','BillToAddress2','BillToCity','BillToState','BillToZipCode','BillToCountryID','BillToAdditionalAddressInformation','InvoiceNonContractItemsToParentAccount','QuoteTemplateID','QuoteEmailMessageID','InvoiceTemplateID','InvoiceEmailMessageID','CurrencyID')]
        [String[]]
        $LessThan ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('id','AccountName','Address1','Address2','City','State','PostalCode','Country','Phone','AlternatePhone1','AlternatePhone2','Fax','WebAddress','OwnerResourceID','ParentAccountID','AccountNumber','CreateDate','LastActivityDate','Active','TaskFireActive','ClientPortalActive','TaxRegionID','TaxExempt','TaxID','AdditionalAddressInformation','CountryID','BillToAttention','BillToAddress1','BillToAddress2','BillToCity','BillToState','BillToZipCode','BillToCountryID','BillToAdditionalAddressInformation','InvoiceNonContractItemsToParentAccount','QuoteTemplateID','QuoteEmailMessageID','InvoiceTemplateID','InvoiceEmailMessageID','CurrencyID')]
        [String[]]
        $LessThanOrEquals ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('AccountName','Address1','Address2','City','State','PostalCode','Country','Phone','AlternatePhone1','AlternatePhone2','Fax','WebAddress','AccountNumber','TaxID','AdditionalAddressInformation','BillToAttention','BillToAddress1','BillToAddress2','BillToCity','BillToState','BillToZipCode','BillToAdditionalAddressInformation')]
        [String[]]
        $Like ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('AccountName','Address1','Address2','City','State','PostalCode','Country','Phone','AlternatePhone1','AlternatePhone2','Fax','WebAddress','AccountNumber','TaxID','AdditionalAddressInformation','BillToAttention','BillToAddress1','BillToAddress2','BillToCity','BillToState','BillToZipCode','BillToAdditionalAddressInformation')]
        [String[]]
        $NotLike ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('AccountName','Address1','Address2','City','State','PostalCode','Country','Phone','AlternatePhone1','AlternatePhone2','Fax','WebAddress','AccountNumber','TaxID','AdditionalAddressInformation','BillToAttention','BillToAddress1','BillToAddress2','BillToCity','BillToState','BillToZipCode','BillToAdditionalAddressInformation')]
        [String[]]
        $BeginsWith ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('AccountName','Address1','Address2','City','State','PostalCode','Country','Phone','AlternatePhone1','AlternatePhone2','Fax','WebAddress','AccountNumber','TaxID','AdditionalAddressInformation','BillToAttention','BillToAddress1','BillToAddress2','BillToCity','BillToState','BillToZipCode','BillToAdditionalAddressInformation')]
        [String[]]
        $EndsWith ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('AccountName','Address1','Address2','City','State','PostalCode','Country','Phone','AlternatePhone1','AlternatePhone2','Fax','WebAddress','AccountNumber','TaxID','AdditionalAddressInformation','BillToAttention','BillToAddress1','BillToAddress2','BillToCity','BillToState','BillToZipCode','BillToAdditionalAddressInformation')]
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
        $Fields = $Atws.GetFieldInfo('Account')
        
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

    Get-AtwsData -Entity Account -Filter $Filter }   

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

  }


        
}
