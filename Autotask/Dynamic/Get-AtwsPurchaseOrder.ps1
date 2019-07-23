#Requires -Version 4.0
#Version 1.6.2.15
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsPurchaseOrder
{


<#
.SYNOPSIS
This function get one or more PurchaseOrder through the Autotask Web Services API.
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

Properties with picklists are:

Status
 

TaxGroup
 

PaymentTerm
 

UseItemDescriptionsFrom
 

Entities that have fields that refer to the base entity of this CmdLet:

PurchaseOrderItem

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.PurchaseOrder[]]. This function outputs the Autotask.PurchaseOrder that was returned by the API.
.EXAMPLE
Get-AtwsPurchaseOrder -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsPurchaseOrder -PurchaseOrderName SomeName
Returns the object with PurchaseOrderName 'SomeName', if any.
 .EXAMPLE
Get-AtwsPurchaseOrder -PurchaseOrderName 'Some Name'
Returns the object with PurchaseOrderName 'Some Name', if any.
 .EXAMPLE
Get-AtwsPurchaseOrder -PurchaseOrderName 'Some Name' -NotEquals PurchaseOrderName
Returns any objects with a PurchaseOrderName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsPurchaseOrder -PurchaseOrderName SomeName* -Like PurchaseOrderName
Returns any object with a PurchaseOrderName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsPurchaseOrder -PurchaseOrderName SomeName* -NotLike PurchaseOrderName
Returns any object with a PurchaseOrderName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsPurchaseOrder -Status <PickList Label>
Returns any PurchaseOrders with property Status equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsPurchaseOrder -Status <PickList Label> -NotEquals Status 
Returns any PurchaseOrders with property Status NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsPurchaseOrder -Status <PickList Label1>, <PickList Label2>
Returns any PurchaseOrders with property Status equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsPurchaseOrder -Status <PickList Label1>, <PickList Label2> -NotEquals Status
Returns any PurchaseOrders with property Status NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsPurchaseOrder -Id 1234 -PurchaseOrderName SomeName* -Status <PickList Label1>, <PickList Label2> -Like PurchaseOrderName -NotEquals Status -GreaterThan Id
An example of a more complex query. This command returns any PurchaseOrders with Id GREATER THAN 1234, a PurchaseOrderName that matches the simple pattern SomeName* AND that has a Status that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsPurchaseOrder
 .LINK
Set-AtwsPurchaseOrder

#>

  [CmdLetBinding(SupportsShouldProcess = $True, DefaultParameterSetName='Filter', ConfirmImpact='None')]
  Param
  (
# A filter that limits the number of objects that is returned from the API
    [Parameter(
      Mandatory = $true,
      ValueFromRemainingArguments = $true,
      ParameterSetName = 'Filter'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $Filter,

# Follow this external ID and return any external objects
    [Parameter(
      ParameterSetName = 'Filter'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Alias('GetRef')]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('CreatorResourceID', 'PurchaseForAccountID', 'ShippingType', 'VendorID')]
    [String]
    $GetReferenceEntityById,

# Return entities of selected type that are referencing to this entity.
    [Parameter(
      ParameterSetName = 'Filter'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Alias('External')]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('PurchaseOrderItem:OrderID')]
    [String]
    $GetExternalEntityByThisEntityId,

# Return all objects in one query
    [Parameter(
      ParameterSetName = 'Get_all'
    )]
    [Switch]
    $All,

# Do not add descriptions for all picklist attributes with values
    [Parameter(
      ParameterSetName = 'Filter'
    )]
    [Parameter(
      ParameterSetName = 'Get_all'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Switch]
    $NoPickListLabel,

# Order ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Vendor Account ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $VendorID,

# Order Status ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $Status,

# Creator Resource ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CreatorResourceID,

# Create Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CreateDateTime,

# Submit Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $SubmitDateTime,

# Cancel Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CancelDateTime,

# Addressee Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [string[]]
    $ShipToName,

# Address Line 1
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,128)]
    [string[]]
    $ShipToAddress1,

# Address Line 2
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [string[]]
    $ShipToAddress2,

# City
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,30)]
    [string[]]
    $ShipToCity,

# State
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,25)]
    [string[]]
    $ShipToState,

# Postal Code
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,10)]
    [string[]]
    $ShipToPostalCode,

# General Memo
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,4000)]
    [string[]]
    $GeneralMemo,

# Phone
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $Phone,

# Fax
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string[]]
    $Fax,

# Vendor Invoice Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $VendorInvoiceNumber,

# External Purchase Order Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $ExternalPONumber,

# Purchase For Account ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $PurchaseForAccountID,

# Shipping Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ShippingType,

# Expected Ship Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ShippingDate,

# Freight Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $Freight,

# Tax Group ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $TaxGroup,

# Payment Term ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $PaymentTerm,

# Show Tax Category
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $ShowTaxCategory,

# Show Each Tax In Tax Group
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $ShowEachTaxInGroup,

# Latest Estimated Arrival Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LatestEstimatedArrivalDate,

# Use Item Descriptions From
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $UseItemDescriptionsFrom,

# Internal Currency Freight Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $InternalCurrencyFreight,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'VendorID', 'Status', 'CreatorResourceID', 'CreateDateTime', 'SubmitDateTime', 'CancelDateTime', 'ShipToName', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'GeneralMemo', 'Phone', 'Fax', 'VendorInvoiceNumber', 'ExternalPONumber', 'PurchaseForAccountID', 'ShippingType', 'ShippingDate', 'Freight', 'TaxGroup', 'PaymentTerm', 'ShowTaxCategory', 'ShowEachTaxInGroup', 'LatestEstimatedArrivalDate', 'UseItemDescriptionsFrom', 'InternalCurrencyFreight')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'VendorID', 'Status', 'CreatorResourceID', 'CreateDateTime', 'SubmitDateTime', 'CancelDateTime', 'ShipToName', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'GeneralMemo', 'Phone', 'Fax', 'VendorInvoiceNumber', 'ExternalPONumber', 'PurchaseForAccountID', 'ShippingType', 'ShippingDate', 'Freight', 'TaxGroup', 'PaymentTerm', 'ShowTaxCategory', 'ShowEachTaxInGroup', 'LatestEstimatedArrivalDate', 'UseItemDescriptionsFrom', 'InternalCurrencyFreight')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'VendorID', 'Status', 'CreatorResourceID', 'CreateDateTime', 'SubmitDateTime', 'CancelDateTime', 'ShipToName', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'GeneralMemo', 'Phone', 'Fax', 'VendorInvoiceNumber', 'ExternalPONumber', 'PurchaseForAccountID', 'ShippingType', 'ShippingDate', 'Freight', 'TaxGroup', 'PaymentTerm', 'ShowTaxCategory', 'ShowEachTaxInGroup', 'LatestEstimatedArrivalDate', 'UseItemDescriptionsFrom', 'InternalCurrencyFreight')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'VendorID', 'Status', 'CreatorResourceID', 'CreateDateTime', 'SubmitDateTime', 'CancelDateTime', 'ShipToName', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'GeneralMemo', 'Phone', 'Fax', 'VendorInvoiceNumber', 'ExternalPONumber', 'PurchaseForAccountID', 'ShippingType', 'ShippingDate', 'Freight', 'TaxGroup', 'PaymentTerm', 'LatestEstimatedArrivalDate', 'UseItemDescriptionsFrom', 'InternalCurrencyFreight')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'VendorID', 'Status', 'CreatorResourceID', 'CreateDateTime', 'SubmitDateTime', 'CancelDateTime', 'ShipToName', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'GeneralMemo', 'Phone', 'Fax', 'VendorInvoiceNumber', 'ExternalPONumber', 'PurchaseForAccountID', 'ShippingType', 'ShippingDate', 'Freight', 'TaxGroup', 'PaymentTerm', 'LatestEstimatedArrivalDate', 'UseItemDescriptionsFrom', 'InternalCurrencyFreight')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'VendorID', 'Status', 'CreatorResourceID', 'CreateDateTime', 'SubmitDateTime', 'CancelDateTime', 'ShipToName', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'GeneralMemo', 'Phone', 'Fax', 'VendorInvoiceNumber', 'ExternalPONumber', 'PurchaseForAccountID', 'ShippingType', 'ShippingDate', 'Freight', 'TaxGroup', 'PaymentTerm', 'LatestEstimatedArrivalDate', 'UseItemDescriptionsFrom', 'InternalCurrencyFreight')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'VendorID', 'Status', 'CreatorResourceID', 'CreateDateTime', 'SubmitDateTime', 'CancelDateTime', 'ShipToName', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'GeneralMemo', 'Phone', 'Fax', 'VendorInvoiceNumber', 'ExternalPONumber', 'PurchaseForAccountID', 'ShippingType', 'ShippingDate', 'Freight', 'TaxGroup', 'PaymentTerm', 'LatestEstimatedArrivalDate', 'UseItemDescriptionsFrom', 'InternalCurrencyFreight')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('ShipToName', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'GeneralMemo', 'Phone', 'Fax', 'VendorInvoiceNumber', 'ExternalPONumber')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('ShipToName', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'GeneralMemo', 'Phone', 'Fax', 'VendorInvoiceNumber', 'ExternalPONumber')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('ShipToName', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'GeneralMemo', 'Phone', 'Fax', 'VendorInvoiceNumber', 'ExternalPONumber')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('ShipToName', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'GeneralMemo', 'Phone', 'Fax', 'VendorInvoiceNumber', 'ExternalPONumber')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('ShipToName', 'ShipToAddress1', 'ShipToAddress2', 'ShipToCity', 'ShipToState', 'ShipToPostalCode', 'GeneralMemo', 'Phone', 'Fax', 'VendorInvoiceNumber', 'ExternalPONumber')]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('CreateDateTime', 'SubmitDateTime', 'CancelDateTime', 'ShippingDate', 'LatestEstimatedArrivalDate')]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'PurchaseOrder'
    
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
  }


  Process
  {
    If ($PSCmdlet.ParameterSetName -eq 'Get_all')
    { 
      $Filter = @('id', '-ge', 0)
    }
    ElseIf (-not ($Filter)) {
    
      Write-Debug ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)
      
      # Convert named parameters to a filter definition that can be parsed to QueryXML
      $Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $EntityName
    }
    Else {
      
      Write-Debug ('{0}: Query based on manual filter, parsing' -F $MyInvocation.MyCommand.Name)
              
      $Filter = . Update-AtwsFilter -FilterString $Filter
    } 

    $Caption = $MyInvocation.MyCommand.Name
    $VerboseDescrition = '{0}: About to query the Autotask Web API for {1}(s).' -F $Caption, $EntityName
    $VerboseWarning = '{0}: About to query the Autotask Web API for {1}(s). Do you want to continue?' -F $Caption, $EntityName
    
    If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
      $Result = Get-AtwsData -Entity $EntityName -Filter $Filter
    

      Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $Result.Count)
    
      # Should we return an indirect object?
      if ( ($Result) -and ($GetReferenceEntityById))
      {
        Write-Debug ('{0}: User has asked for external reference objects by {1}' -F $MyInvocation.MyCommand.Name, $GetReferenceEntityById)
      
        $Field = $Fields.Where({$_.Name -eq $GetReferenceEntityById})
        $ResultValues = $Result | Where-Object {$null -ne $_.$GetReferenceEntityById}
        If ($ResultValues.Count -lt $Result.Count)
        {
          Write-Warning ('{0}: Only {1} of the {2}s in the primary query had a value in the property {3}.' -F $MyInvocation.MyCommand.Name, 
            $ResultValues.Count,
            $EntityName,
          $GetReferenceEntityById) -WarningAction Continue
        }
        $Filter = 'id -eq {0}' -F $($ResultValues.$GetReferenceEntityById -join ' -or id -eq ')
        $Result = Get-Atwsdata -Entity $Field.ReferenceEntityType -Filter $Filter
      }
      ElseIf ( ($Result) -and ($GetExternalEntityByThisEntityId))
      {
        Write-Debug ('{0}: User has asked for {1} that are referencing this result' -F $MyInvocation.MyCommand.Name, $GetExternalEntityByThisEntityId)
        $ReferenceInfo = $GetExternalEntityByThisEntityId -Split ':'
        $Filter = '{0} -eq {1}' -F $ReferenceInfo[1], $($Result.id -join (' -or {0}id -eq ' -F $ReferenceInfo[1]))
        $Result = Get-Atwsdata -Entity $ReferenceInfo[0] -Filter $Filter
      }
      # Do the user want labels along with index values for Picklists?
      ElseIf ( ($Result) -and -not ($NoPickListLabel))
      {
        Foreach ($Field in $Fields.Where{$_.IsPickList})
        {
          $FieldName = '{0}Label' -F $Field.Name
          Foreach ($Item in $Result)
          {
            $Value = ($Field.PickListValues.Where{$_.Value -eq $Item.$($Field.Name)}).Label
            Add-Member -InputObject $Item -MemberType NoteProperty -Name $FieldName -Value $Value -Force
          
          }
        }
      }
    }
  }

  End
  {
    Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    If ($Result)
    {
      Return $Result
    }
  }


}
