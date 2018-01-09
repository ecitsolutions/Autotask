<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Get-AutotaskAccount
{
  <#
      .SYNOPSIS
      This function get one or more Account through the Autotask Web Services API.
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
      .INPUTS
      Nothing. This function only takes parameters.
      .OUTPUTS
      [Autotask.Account[]]. This function outputs the Autotask.Account that was returned by the API.
      .EXAMPLE
      Get-AutotaskAccount  -Parameter1 [Parameter1 value] -Parameter2 [Parameter2 Value] -GreaterThan Parameter2
Returns all objects where a property by name of "Parameter1" is equal to [Parameter1 value] and where a property by name of "Parameter2" is greater than [Parameter2 Value].
      For parameters, use Get-Help Get-AutotaskAccount
      .NOTES
      NAME: Get-AutotaskAccount
  #>
	  [CmdLetBinding(DefaultParameterSetName='Filter')]
    Param
    (
           [Parameter(
      Mandatory = $true
,
      ValueFromRemainingArguments = $true
,
      ParameterSetName = 'Filter'

   )]
   [ValidateNotNullOrEmpty()]
   [String[]]
   $Filter ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [long[]]
   $id ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [string[]]
   $AccountName ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [string[]]
   $Address1 ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [string[]]
   $Address2 ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [string[]]
   $City ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [string[]]
   $State ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [string[]]
   $PostalCode ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [string[]]
   $Country ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [string[]]
   $Phone ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [string[]]
   $AlternatePhone1 ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [string[]]
   $AlternatePhone2 ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [string[]]
   $Fax ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [string[]]
   $WebAddress ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [ValidateSet('Customer', 'Lead', 'Prospect', 'Dead', 'Cancellation', 'Vendor', 'Partner')]
   [String[]]
   $AccountType ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [ValidateSet('Block Hour Client', 'Blue', 'Bronze', 'Canceled', 'Delinquent', 'Gold', 'Jeopardy Company', 'Residential', 'Silver', 'T&M', 'Target')]
   [String[]]
   $KeyAccountIcon ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [Int[]]
   $OwnerResourceID ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [ValidateSet('Local', 'Annet', 'Hallingdal', 'Hole', 'Jevnaker/Hadeland', 'Krodsherad', 'Modum', 'Oslo området', 'Ringerike')]
   [String[]]
   $TerritoryID ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [ValidateSet('Commercial', 'Residential', 'Not For Profit')]
   [String[]]
   $MarketSegmentID ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [Int[]]
   $CompetitorID ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [Int[]]
   $ParentAccountID ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [string[]]
   $AccountNumber ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [datetime[]]
   $CreateDate ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [datetime[]]
   $LastActivityDate ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [boolean[]]
   $Active ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [boolean[]]
   $TaskFireActive ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [boolean[]]
   $ClientPortalActive ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [Int[]]
   $TaxRegionID ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [boolean[]]
   $TaxExempt ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [string[]]
   $TaxID ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [string[]]
   $AdditionalAddressInformation ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [Int[]]
   $CountryID ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [ValidateSet('NONE', 'ACCOUNT', 'ACCOUNTBILLING', 'PARENT', 'PARENTBILLING')]
   [String[]]
   $BillToAddressToUse ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [string[]]
   $BillToAttention ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [string[]]
   $BillToAddress1 ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [string[]]
   $BillToAddress2 ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [string[]]
   $BillToCity ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [string[]]
   $BillToState ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [string[]]
   $BillToZipCode ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [Int[]]
   $BillToCountryID ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [string[]]
   $BillToAdditionalAddressInformation ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [ValidateSet('None', 'Print', 'Email', 'PrintAndEmail')]
   [String[]]
   $InvoiceMethod ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [boolean[]]
   $InvoiceNonContractItemsToParentAccount ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [Int[]]
   $QuoteTemplateID ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [Int[]]
   $QuoteEmailMessageID ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [Int[]]
   $InvoiceTemplateID ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [Int[]]
   $InvoiceEmailMessageID ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [Int[]]
   $CurrencyID ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [String[]]
   $NotEquals ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [String[]]
   $GreaterThan ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [String[]]
   $GreaterThanOrEqual ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [String[]]
   $LessThan ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [String[]]
   $LessThanOrEquals ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [String[]]
   $Like ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [String[]]
   $NotLike ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [String[]]
   $BeginsWith ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [String[]]
   $EndsWith ,

   [Parameter(
      ParameterSetName = 'By_parameters'

   )]
   [String[]]
   $Contains
    )

       
        
  Begin
  { 
    $EntityName = 'Account'

    If ($Verbose)
    {
      # Make sure the -Verbose parameter is inherited
      $VerbosePreference = 'Continue'
    }
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
      $Fields = $Atws.GetFieldInfo($EntityName)
        
      Foreach ($Parameter in $PSBoundParameters.GetEnumerator())
      {
        $Field = $Fields | Where-Object {$_.Name -eq $Parameter.Key}
        If ($Field)
        { 
          If ($Parameter.Value.Count -gt 1)
          {
            $Filter += '-begin'
          }
          Foreach ($ParameterValue in $Parameter.Value)
          {   
            $Operator = '-or'
            If ($Field.IsPickList)
            {
              $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $ParameterValue}
              $Value = $PickListValue.Value
            }
            Else
            {
              $Value = $ParameterValue
            }
            $Filter += $Parameter.Key
            If ($Parameter.Key -in $NotEquals)
            { 
              $Filter += '-ne'
              $Operator = '-and'
            }
            ElseIf ($Parameter.Key -in $GreaterThan)
            { $Filter += '-gt'}
            ElseIf ($Parameter.Key -in $GreaterThanOrEqual)
            { $Filter += '-ge'}
            ElseIf ($Parameter.Key -in $LessThan)
            { $Filter += '-lt'}
            ElseIf ($Parameter.Key -in $LessThanOrEquals)
            { $Filter += '-le'}
            ElseIf ($Parameter.Key -in $Like)
            { 
              $Filter += '-like'
              $Value = $Value -replace '*','%'
            }
            ElseIf ($Parameter.Key -in $NotLike)
            { 
              $Filter += '-notlike'
              $Value = $Value -replace '*','%'
            }
            ElseIf ($Parameter.Key -in $BeginsWith)
            { $Filter += '-beginswith'}
            ElseIf ($Parameter.Key -in $EndsWith)
            { $Filter += '-endswith'}
            ElseIf ($Parameter.Key -in $Contains)
            { $Filter += '-contains'}
            Else
            { $Filter += '-eq'}
            $Filter += $Value
            If ($Parameter.Value.Count -gt 1 -and $ParameterValue -ne $Parameter.Value[-1])
            {
              $Filter += $Operator
            }
            ElseIf ($Parameter.Value.Count -gt 1)
            {
              $Filter += '-end'
            }
          }
            
        }
      }
        
    } #'NotEquals','GreaterThan','GreaterThanOrEqual','LessThan','LessThanOrEquals','Like','NotLike','BeginsWith','EndsWith

    Get-AtwsData -Entity $EntityName -Filter $Filter
  }

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
  }


      


        
}
