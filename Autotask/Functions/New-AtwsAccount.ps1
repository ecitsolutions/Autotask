#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
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


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Account]. This function outputs the Autotask.Account that was created by the API.
.EXAMPLE
$result = New-AtwsAccount -AccountName [Value] -Phone [Value] -AccountType [Value] -OwnerResourceID [Value]
Creates a new [Autotask.Account] through the Web Services API and returns the new object.
 .EXAMPLE
$result = Get-AtwsAccount -Id 124 | New-AtwsAccount 
Copies [Autotask.Account] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsAccount -Id 124 | New-AtwsAccount | Set-AtwsAccount -ParameterName <Parameter Value>
Copies [Autotask.Account] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsAccount to modify the object.
 .EXAMPLE
$result = Get-AtwsAccount -Id 124 | New-AtwsAccount | Set-AtwsAccount -ParameterName <Parameter Value> -Passthru
Copies [Autotask.Account] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsAccount to modify the object and returns the new object.

.LINK
Get-AtwsAccount
 .LINK
Set-AtwsAccount

#>

  [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName='By_parameters', ConfirmImpact='Low')]
  Param
  (
# An array of objects to create
    [Parameter(
      ParametersetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.Account[]]
    $InputObject,

# User defined fields already setup i Autotask
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('UDF')]
    [ValidateNotNullOrEmpty()]
    [Autotask.UserDefinedField[]]
    $UserDefinedFields,

# Client Name
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [Alias('Name')]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [string]
    $AccountName,

# Client Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $AccountNumber,

# Client Type
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Account -FieldName AccountType -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Account -FieldName AccountType -Label) + (Get-AtwsPicklistValue -Entity Account -FieldName AccountType -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $AccountType,

# Account Active
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $Active,

# Additional Address Information
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string]
    $AdditionalAddressInformation,

# Address 1
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [string]
    $Address1,

# Address 2
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [string]
    $Address2,

# Alternate Phone 1
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string]
    $AlternatePhone1,

# Alternate Phone 2
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string]
    $AlternatePhone2,

# API Vendor ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Account -FieldName ApiVendorID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Account -FieldName ApiVendorID -Label) + (Get-AtwsPicklistValue -Entity Account -FieldName ApiVendorID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $ApiVendorID,

# Asset Value
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $AssetValue,

# Bill To Account Physical Location ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $BillToAccountPhysicalLocationID,

# Bill To Additional Address Information
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string]
    $BillToAdditionalAddressInformation,

# Bill To Address Line 1
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,150)]
    [string]
    $BillToAddress1,

# Bill To Address Line 2
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,150)]
    [string]
    $BillToAddress2,

# Bill To Address to Use
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Account -FieldName BillToAddressToUse -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Account -FieldName BillToAddressToUse -Label) + (Get-AtwsPicklistValue -Entity Account -FieldName BillToAddressToUse -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $BillToAddressToUse,

# Bill To Attention
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $BillToAttention,

# Bill To City
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $BillToCity,

# Bill To Country ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $BillToCountryID,

# Bill To County
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [string]
    $BillToState,

# Bill To Postal Code
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $BillToZipCode,

# City
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,30)]
    [string]
    $City,

# Client Portal Active
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $ClientPortalActive,

# Competitor
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Account -FieldName CompetitorID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Account -FieldName CompetitorID -Label) + (Get-AtwsPicklistValue -Entity Account -FieldName CompetitorID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $CompetitorID,

# Country
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string]
    $Country,

# Country ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $CountryID,

# Create Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $CreateDate,

# Created By Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $CreatedByResourceID,

# Currency ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $CurrencyID,

# Enabled For Comanaged
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $EnabledForComanaged,

# Fax
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string]
    $Fax,

# Impersonator Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ImpersonatorCreatorResourceID,

# Invoice Email Message ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $InvoiceEmailMessageID,

# Transmission Method
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Account -FieldName InvoiceMethod -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Account -FieldName InvoiceMethod -Label) + (Get-AtwsPicklistValue -Entity Account -FieldName InvoiceMethod -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $InvoiceMethod,

# Invoice non contract items to Parent Client
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $InvoiceNonContractItemsToParentAccount,

# Invoice Template ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $InvoiceTemplateID,

# Key Account Icon
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Account -FieldName KeyAccountIcon -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Account -FieldName KeyAccountIcon -Label) + (Get-AtwsPicklistValue -Entity Account -FieldName KeyAccountIcon -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $KeyAccountIcon,

# Last Activity Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $LastActivityDate,

# Last Modified Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $LastTrackedModifiedDateTime,

# Market Segment
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Account -FieldName MarketSegmentID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Account -FieldName MarketSegmentID -Label) + (Get-AtwsPicklistValue -Entity Account -FieldName MarketSegmentID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $MarketSegmentID,

# Client Owner
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $OwnerResourceID,

# Parent Client
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ParentAccountID,

# Phone
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,25)]
    [string]
    $Phone,

# Postal Code
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,10)]
    [string]
    $PostalCode,

# Purchase Order Template ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Account -FieldName PurchaseOrderTemplateID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Account -FieldName PurchaseOrderTemplateID -Label) + (Get-AtwsPicklistValue -Entity Account -FieldName PurchaseOrderTemplateID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $PurchaseOrderTemplateID,

# Quote Email Message ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $QuoteEmailMessageID,

# Quote Template ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $QuoteTemplateID,

# SIC Code
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,32)]
    [string]
    $SICCode,

# County
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,40)]
    [string]
    $State,

# Stock Market
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,10)]
    [string]
    $StockMarket,

# Stock Symbol
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,10)]
    [string]
    $StockSymbol,

# Survey Account Rating
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $SurveyAccountRating,

# TaskFire Active
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $TaskFireActive,

# Tax Exempt
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $TaxExempt,

# Tax ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $TaxID,

# Tax Region ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $TaxRegionID,

# Territory Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Account -FieldName TerritoryID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Account -FieldName TerritoryID -Label) + (Get-AtwsPicklistValue -Entity Account -FieldName TerritoryID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $TerritoryID,

# Web
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string]
    $WebAddress
  )

    begin {
        $entityName = 'Account'

        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {
            $DebugPreference = 'Continue'
        }
        else {
            # Respect configured preference
            $DebugPreference = $Script:Atws.Configuration.DebugPref
        }

        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

        if (!($PSCmdlet.MyInvocation.BoundParameters['Verbose'].IsPresent)) {
            # No local override of central preference. Load central preference
            $VerbosePreference = $Script:Atws.Configuration.VerbosePref
        }

        $result = [collections.generic.list[psobject]]::new()
    }

    process {

        if ($InputObject) {
            Write-Verbose -Message ('{0}: Copy Object mode: Setting ID property to zero' -F $MyInvocation.MyCommand.Name)

            #Measure-Object should work here, but returns 0 as Count/Sum. 
            #Count throws error if we cast a null value to its method, but here we know that we dont have a null value.
            $sum = ($InputObject | Measure-Object -Property Id -Sum).Sum

            # If $sum has value we must reset object IDs or we will modify existing objects, not create new ones
            if ($sum -gt 0) {
                foreach ($object in $InputObject) {
                    $object.Id = $null
                }
            }
        }
        else {
            Write-Debug -Message ('{0}: Creating empty [Autotask.{1}]' -F $MyInvocation.MyCommand.Name, $entityName)
            $inputObject = @($(New-Object -TypeName Autotask.$entityName))
        }

        # Prepare shouldProcess comments
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to create {1} {2}(s). This action cannot be undone.' -F $caption, $inputObject.Count, $entityName
        $verboseWarning = '{0}: About to create {1} {2}(s). This action may not be undoable. Do you want to continue?' -F $caption, $inputObject.Count, $entityName

        # Lets don't and say we did!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) {

            # Process parameters and update objects with their values
            $inputObject = $inputObject | Update-AtwsObjectsWithParameters -BoundParameters $PSBoundParameters -EntityName $EntityName

            try {
                # Force list even if result is only 1 object to be compatible with addrange()
                [collections.generic.list[psobject]]$response = Set-AtwsData -Entity $inputObject -Create
            }
            catch {
                # Write a debug message with detailed information to developers
                $reason = ("{0}: {1}" -f $_.CategoryInfo.Category, $_.CategoryInfo.Reason)
                $message = "{2}: {0}`r`n`r`nLine:{1}`r`n`r`nScript stacktrace:`r`n{3}" -f $_.Exception.Message, $_.InvocationInfo.Line, $reason, $_.ScriptStackTrace
                Write-Debug $message

                # Pass on the error
                $PSCmdlet.ThrowTerminatingError($_)
                return
            }
            # If using pipeline this block (process) will run once pr item in the pipeline. make sure to return them all
            if ($response.Count -gt 0) {
                $result.AddRange($response)
            }
        }
    }

    end {
        Write-Debug -Message ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $result.count, $entityName)
        Return [array]$result
    }

}
