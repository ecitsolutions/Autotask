#Requires -Version 4.0
#Version 1.6.2.10
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function New-AtwsAccount
{


<#
.SYNOPSIS
This function creates a new Account through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.Account] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the Account with Id number 0 you could write 'New-AtwsAccount -Id 0' or you could write 'New-AtwsAccount -Filter {Id -eq 0}.

'New-AtwsAccount -Id 0,4' could be written as 'New-AtwsAccount -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new Account you need the following required fields:
 -AccountName
 -Phone
 -AccountType
 -OwnerResourceID

Entities that have fields that refer to the base entity of this CmdLet:

Account
 AccountAlert
 AccountLocation
 AccountNote
 AccountPhysicalLocation
 AccountTeam
 AccountToDo
 BillingItem
 Contact
 Contract
 ContractServiceUnit
 ExpenseItem
 InstalledProduct
 Invoice
 NotificationHistory
 Opportunity
 Product
 ProductVendor
 Project
 PurchaseOrder
 Quote
 SalesOrder
 Service
 ServiceCall
 Subscription
 SurveyResults
 Ticket

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Account]. This function outputs the Autotask.Account that was created by the API.
.EXAMPLE
$Result = New-AtwsAccount -AccountName [Value] -Phone [Value] -AccountType [Value] -OwnerResourceID [Value]
Creates a new [Autotask.Account] through the Web Services API and returns the new object.
 .EXAMPLE
$Result = Get-AtwsAccount -Id 124 | New-AtwsAccount 
Copies [Autotask.Account] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsAccount -Id 124 | New-AtwsAccount | Set-AtwsAccount -ParameterName <Parameter Value>
Copies [Autotask.Account] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsAccount to modify the object.
 .EXAMPLE
$Result = Get-AtwsAccount -Id 124 | New-AtwsAccount | Set-AtwsAccount -ParameterName <Parameter Value> -Passthru
Copies [Autotask.Account] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsAccount to modify the object and returns the new object.

.LINK
Get-AtwsAccount
 .LINK
Set-AtwsAccount

#>

  [CmdLetBinding(DefaultParameterSetName='By_parameters', ConfirmImpact='Low')]
  Param
  (
# An array of objects to create
    [Parameter(
      ParameterSetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.Account[]]
    $InputObject,

# User defined fields already setup i Autotask
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Alias('UDF')]
    [ValidateNotNullOrEmpty()]
    [Autotask.UserDefinedField[]]
    $UserDefinedFields,

# Client Name
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [Alias('Name')]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1,100)]
    [string]
    $AccountName,

# Address 1
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,128)]
    [string]
    $Address1,

# Address 2
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,128)]
    [string]
    $Address2,

# City
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,30)]
    [string]
    $City,

# County
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,40)]
    [string]
    $State,

# Postal Code
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,10)]
    [string]
    $PostalCode,

# Country
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,100)]
    [string]
    $Country,

# Phone
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1,25)]
    [string]
    $Phone,

# Alternate Phone 1
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,25)]
    [string]
    $AlternatePhone1,

# Alternate Phone 2
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,25)]
    [string]
    $AlternatePhone2,

# Fax
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,25)]
    [string]
    $Fax,

# Web
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string]
    $WebAddress,

# Client Type
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String]
    $AccountType,

# Key Account Icon
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $KeyAccountIcon,

# Client Owner
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $OwnerResourceID,

# Territory Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $TerritoryID,

# Market Segment
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $MarketSegmentID,

# Competitor
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $CompetitorID,

# Parent Client
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $ParentAccountID,

# Stock Symbol
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,10)]
    [string]
    $StockSymbol,

# Stock Market
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,10)]
    [string]
    $StockMarket,

# SIC Code
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,32)]
    [string]
    $SICCode,

# Asset Value
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $AssetValue,

# Client Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string]
    $AccountNumber,

# Create Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $CreateDate,

# Last Activity Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $LastActivityDate,

# Account Active
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean]
    $Active,

# TaskFire Active
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean]
    $TaskFireActive,

# Client Portal Active
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean]
    $ClientPortalActive,

# Tax Region ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $TaxRegionID,

# Tax Exempt
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean]
    $TaxExempt,

# Tax ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string]
    $TaxID,

# Additional Address Information
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,100)]
    [string]
    $AdditionalAddressInformation,

# Country ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $CountryID,

# Bill To Address to Use
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $BillToAddressToUse,

# Bill To Attention
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string]
    $BillToAttention,

# Bill To Address Line 1
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,150)]
    [string]
    $BillToAddress1,

# Bill To Address Line 2
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,150)]
    [string]
    $BillToAddress2,

# Bill To City
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string]
    $BillToCity,

# Bill To County
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,128)]
    [string]
    $BillToState,

# Bill To Postal Code
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string]
    $BillToZipCode,

# Bill To Country ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $BillToCountryID,

# Bill To Additional Address Information
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,100)]
    [string]
    $BillToAdditionalAddressInformation,

# Transmission Method
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $InvoiceMethod,

# Invoice non contract items to Parent Client
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean]
    $InvoiceNonContractItemsToParentAccount,

# Quote Template ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $QuoteTemplateID,

# Quote Email Message ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $QuoteEmailMessageID,

# Invoice Template ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $InvoiceTemplateID,

# Invoice Email Message ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $InvoiceEmailMessageID,

# Currency ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $CurrencyID,

# Bill To Account Physical Location ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $BillToAccountPhysicalLocationID,

# Survey Account Rating
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $SurveyAccountRating
  )
 
  Begin
  { 
    $EntityName = 'Account'
           
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
    $ProcessObject = @()
  }

  Process
  {
    $Fields = Get-AtwsFieldInfo -Entity $EntityName
    
    If ($InputObject)
    {
      Write-Verbose ('{0}: Copy Object mode: Setting ID property to zero' -F $MyInvocation.MyCommand.Name)  
      
      $CopyNo = 1

      Foreach ($Object in $InputObject) 
      { 
        # Create a new object and copy properties
        $NewObject = New-Object Autotask.$EntityName
        
        # Copy every non readonly property
        $FieldNames = $Fields.Where({$_.Name -ne 'id'}).Name
        If ($PSBoundParameters.ContainsKey('UserDefinedFields')) {
          $FieldNames += 'UserDefinedFields'
        }
        Foreach ($Field in $FieldNames)
        {
          $NewObject.$Field = $Object.$Field
        }
        If ($NewObject -is [Autotask.Ticket])
        {
          Write-Verbose ('{0}: Copy Object mode: Object is a Ticket. Title must be modified to avoid duplicate detection.' -F $MyInvocation.MyCommand.Name)  
          $Title = '{0} (Copy {1})' -F $NewObject.Title, $CopyNo
          $CopyNo++
          $NewObject.Title = $Title
        }
        $ProcessObject += $NewObject
      }   
    }
    Else
    {
      Write-Debug ('{0}: Creating empty [Autotask.{1}]' -F $MyInvocation.MyCommand.Name, $EntityName) 
      $ProcessObject += New-Object Autotask.$EntityName    
    }
    
    Foreach ($Parameter in $PSBoundParameters.GetEnumerator())
    {
      $Field = $Fields | Where-Object {$_.Name -eq $Parameter.Key}
      If ($Field -or $Parameter.Key -eq 'UserDefinedFields')
      { 
        If ($Field.IsPickList)
        {
          If($Field.PickListParentValueField)
          {
            $ParentField = $Fields.Where{$_.Name -eq $Field.PickListParentValueField}
            $ParentLabel = $PSBoundParameters.$($ParentField.Name)
            $ParentValue = $ParentField.PickListValues | Where-Object {$_.Label -eq $ParentLabel}
            $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $Parameter.Value -and $_.ParentValue -eq $ParentValue.Value}                
          }
          Else 
          { 
            $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $Parameter.Value}
          }
          $Value = $PickListValue.Value
        }
        Else
        {
          $Value = $Parameter.Value
        } 

        Foreach ($Object in $ProcessObject) 
        { 
          $Object.$($Parameter.Key) = $Value
        }
      }
    }    

    $Result = New-AtwsData -Entity $ProcessObject
  }

  End
  {
    Write-Debug ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $Result.count, $EntityName)
    Return $Result
  }

}
