﻿#Requires -Version 4.0
#Version 1.6.2.9
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Set-AtwsAccount
{


<#
.SYNOPSIS
This function sets parameters on the Account specified by the -InputObject parameter or pipeline through the use of the Autotask Web Services API. Any property of the Account that is not marked as READ ONLY by Autotask can be speficied with a parameter. You can specify multiple paramters.
.DESCRIPTION
This function one or more objects of type [Autotask.Account] as input. You can pipe the objects to the function or pass them using the -InputObject parameter. You specify the property you want to set and the value you want to set it to using parameters. The function modifies all objects and updates the online data through the Autotask Web Services API. The function supports all properties of an [Autotask.Account] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values.

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
[Autotask.Account[]]. This function takes one or more objects as input. Pipeline is supported.
.OUTPUTS
Nothing or [Autotask.Account]. This function optionally returns the updated objects if you use the -PassThru parameter.
.EXAMPLE
Set-AtwsAccount -InputObject $Account [-ParameterName] [Parameter value]
Passes one or more [Autotask.Account] object(s) as a variable to the function and sets the property by name 'ParameterName' on ALL the objects before they are passed to the Autotask Web Service API and updated.
 .EXAMPLE
$Account | Set-AtwsAccount -ParameterName <Parameter value>
Same as the first example, but now the objects are passed to the funtion through the pipeline, not passed as a parameter. The end result is identical.
 .EXAMPLE
Get-AtwsAccount -Id 0 | Set-AtwsAccount -ParameterName <Parameter value>
Gets the instance with Id 0 directly from the Web Services API, modifies a parameter and updates Autotask. This approach works with all valid parameters for the Get function.
 .EXAMPLE
Get-AtwsAccount -Id 0,4,8 | Set-AtwsAccount -ParameterName <Parameter value>
Gets multiple instances by Id, modifies them all and updates Autotask.
 .EXAMPLE
$Result = Get-AtwsAccount -Id 0,4,8 | Set-AtwsAccount -ParameterName <Parameter value> -PassThru
Gets multiple instances by Id, modifies them all, updates Autotask and returns the updated objects.

.LINK
New-AtwsAccount
 .LINK
Get-AtwsAccount

#>

  [CmdLetBinding(DefaultParameterSetName='InputObject', ConfirmImpact='Low')]
  Param
  (
# An object that will be modified by any parameters and updated in Autotask
    [Parameter(
      ParameterSetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.Account[]]
    $InputObject,

# The object.ids of objects that should be modified by any parameters and updated in Autotask
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [long[]]
    $Id,

# Return any updated objects through the pipeline
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Switch]
    $PassThru,

# User defined fields already setup i Autotask
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Alias('UDF')]
    [Autotask.UserDefinedField[]]
    $UserDefinedFields,

# Client Name
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Alias('Name')]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1,100)]
    [string]
    $AccountName,

# Address 1
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(1,128)]
    [string]
    $Address1,

# Address 2
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(1,128)]
    [string]
    $Address2,

# City
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(1,30)]
    [string]
    $City,

# County
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(1,40)]
    [string]
    $State,

# Postal Code
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(1,10)]
    [string]
    $PostalCode,

# Country
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(1,100)]
    [string]
    $Country,

# Phone
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1,25)]
    [string]
    $Phone,

# Alternate Phone 1
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(1,25)]
    [string]
    $AlternatePhone1,

# Alternate Phone 2
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(1,25)]
    [string]
    $AlternatePhone2,

# Fax
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(1,25)]
    [string]
    $Fax,

# Web
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(1,255)]
    [string]
    $WebAddress,

# Client Type
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [String]
    $AccountType,

# Key Account Icon
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [String]
    $KeyAccountIcon,

# Client Owner
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $OwnerResourceID,

# Territory Name
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [String]
    $TerritoryID,

# Market Segment
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [String]
    $MarketSegmentID,

# Competitor
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [String]
    $CompetitorID,

# Parent Client
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Int]
    $ParentAccountID,

# Stock Symbol
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(1,10)]
    [string]
    $StockSymbol,

# Stock Market
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(1,10)]
    [string]
    $StockMarket,

# SIC Code
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(1,32)]
    [string]
    $SICCode,

# Asset Value
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [double]
    $AssetValue,

# Client Number
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(1,50)]
    [string]
    $AccountNumber,

# Account Active
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [boolean]
    $Active,

# Tax Region ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Int]
    $TaxRegionID,

# Tax Exempt
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [boolean]
    $TaxExempt,

# Tax ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(1,50)]
    [string]
    $TaxID,

# Additional Address Information
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(1,100)]
    [string]
    $AdditionalAddressInformation,

# Country ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Int]
    $CountryID,

# Bill To Attention
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(1,50)]
    [string]
    $BillToAttention,

# Transmission Method
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [String]
    $InvoiceMethod,

# Invoice non contract items to Parent Client
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [boolean]
    $InvoiceNonContractItemsToParentAccount,

# Quote Template ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Int]
    $QuoteTemplateID,

# Quote Email Message ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Int]
    $QuoteEmailMessageID,

# Invoice Template ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Int]
    $InvoiceTemplateID,

# Invoice Email Message ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Int]
    $InvoiceEmailMessageID,

# Currency ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Int]
    $CurrencyID,

# Bill To Account Physical Location ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Int]
    $BillToAccountPhysicalLocationID
  )
 
  Begin
  { 
    $EntityName = 'Account'
    
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
        
    # Set up TimeZone offset handling
    If (-not($script:LocalToEST))
    {
      $Now = Get-Date
      $ESTzone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Eastern Standard Time")
      $ESTtime = [System.TimeZoneInfo]::ConvertTimeFromUtc($Now.ToUniversalTime(), $ESTzone)

      # Time difference in hours from localtime to API time
      $script:LocalToEST = (New-TimeSpan -Start $Now -End $ESTtime).TotalHours
    }
    
    # Collect fresh copies of InputObject if passed any IDs
    If ($Id.Count -gt 0 -and $Id.Count -le 200) {
      $Filter = 'Id -eq {0}' -F ($Id -join ' -or Id -eq ')
      $InputObject = Get-AtwsData -Entity $EntityName -Filter $Filter
    }
    ElseIf ($Id.Count -gt 200) {
      Throw [ApplicationException] 'Too many objects, the module can process a maximum of 200 objects when using the Id parameter.'
    }
  }

  Process
  {
    $Fields = Get-AtwsFieldInfo -Entity $EntityName
    
    # Loop through parameters and update any inputobjects with the given parameter values    
    Foreach ($Parameter in $PSBoundParameters.GetEnumerator())
    {
      $Field = $Fields | Where-Object {$_.Name -eq $Parameter.Key}
      If ($Field -or $Parameter.Key -eq 'UserDefinedFields')
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
        Foreach ($Object in $InputObject) 
        { 
          $Object.$($Parameter.Key) = $Value
        }
      }
    }
    
    # Normalize dates, i.e. set them to CEST. The .Update() method of the API reads all datetime fields as CEST
    # We can safely ignore readonly fields, even if we have modified them previously. The API ignores them.
    $DateTimeParams = $Fields.Where({$_.Type -eq 'datetime' -and -not $_.IsReadOnly}).Name
   
    # Adjust TimeZone on all DateTime properties
    Foreach ($Object in $InputObject) 
    { 
      Foreach ($DateTimeParam in $DateTimeParams) {
      
        # Get the datetime value
        $Value = $Object.$DateTimeParam
                
        # Skip if parameter is empty
        If (-not ($Value)) {
          Continue
        }
        # Convert the datetime back to CEST
        $Object.$DateTimeParam = $Value.AddHours($script:LocalToEST)
      }
    }
    
    $ModifiedObjects = Set-AtwsData -Entity $InputObject
    
    # Revert changes back on any inputobject
    Foreach ($Object in $InputObject) 
    { 
      Foreach ($DateTimeParam in $DateTimeParams) {
      
        # Get the datetime value
        $Value = $Object.$DateTimeParam
                
        # Skip if parameter is empty
        If (-not ($Value)) {
          Continue
        }
        # Revert the datetime back from CEST
        $Object.$DateTimeParam = $Value.AddHours($script:LocalToEST * -1)
      }
    }
    
  }

  End
  {
    Write-Debug ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $ModifiedObjects.count, $EntityName)
    Return $ModifiedObjects
  }

}
