#Requires -Version 4.0
#Version 1.6.2.13
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsInvoice
{


<#
.SYNOPSIS
This function get one or more Invoice through the Autotask Web Services API.
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

TaxGroup
 

PaymentTerm
 

Entities that have fields that refer to the base entity of this CmdLet:

BillingItem

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Invoice[]]. This function outputs the Autotask.Invoice that was returned by the API.
.EXAMPLE
Get-AtwsInvoice -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsInvoice -InvoiceName SomeName
Returns the object with InvoiceName 'SomeName', if any.
 .EXAMPLE
Get-AtwsInvoice -InvoiceName 'Some Name'
Returns the object with InvoiceName 'Some Name', if any.
 .EXAMPLE
Get-AtwsInvoice -InvoiceName 'Some Name' -NotEquals InvoiceName
Returns any objects with a InvoiceName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsInvoice -InvoiceName SomeName* -Like InvoiceName
Returns any object with a InvoiceName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsInvoice -InvoiceName SomeName* -NotLike InvoiceName
Returns any object with a InvoiceName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsInvoice -TaxGroup <PickList Label>
Returns any Invoices with property TaxGroup equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsInvoice -TaxGroup <PickList Label> -NotEquals TaxGroup 
Returns any Invoices with property TaxGroup NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsInvoice -TaxGroup <PickList Label1>, <PickList Label2>
Returns any Invoices with property TaxGroup equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsInvoice -TaxGroup <PickList Label1>, <PickList Label2> -NotEquals TaxGroup
Returns any Invoices with property TaxGroup NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsInvoice -Id 1234 -InvoiceName SomeName* -TaxGroup <PickList Label1>, <PickList Label2> -Like InvoiceName -NotEquals TaxGroup -GreaterThan Id
An example of a more complex query. This command returns any Invoices with Id GREATER THAN 1234, a InvoiceName that matches the simple pattern SomeName* AND that has a TaxGroup that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
Set-AtwsInvoice

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
    [ValidateSet('AccountID', 'CreatorResourceID', 'InvoiceEditorTemplateID', 'VoidedByResourceID')]
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
    [ValidateSet('BillingItem:InvoiceID')]
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

# Invoice ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Client ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $AccountID,

# Creator Resource ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CreatorResourceID,

# Invoice Date Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $InvoiceDateTime,

# Create Date Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CreateDateTime,

# Invoice Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $InvoiceNumber,

# Comments
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,4000)]
    [string[]]
    $Comments,

# Invoice Total
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $InvoiceTotal,

# Total Tax Value
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $TotalTaxValue,

# From Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $FromDate,

# To Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $ToDate,

# Order Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,20)]
    [string[]]
    $OrderNumber,

# Payment Term ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $PaymentTerm,

# Web Service Use Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $WebServiceDate,

# Is Voided
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $IsVoided,

# Voided Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $VoidedDate,

# Voided By Resource ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $VoidedByResourceID,

# Paid Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $PaidDate,

# Tax Region Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,200)]
    [string[]]
    $TaxRegionName,

# Batch ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BatchID,

# Invoice Editor Template ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $InvoiceEditorTemplateID,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'CreatorResourceID', 'InvoiceDateTime', 'CreateDateTime', 'InvoiceNumber', 'Comments', 'InvoiceTotal', 'TotalTaxValue', 'FromDate', 'ToDate', 'OrderNumber', 'PaymentTerm', 'WebServiceDate', 'IsVoided', 'VoidedDate', 'VoidedByResourceID', 'PaidDate', 'TaxRegionName', 'BatchID', 'InvoiceEditorTemplateID')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'CreatorResourceID', 'InvoiceDateTime', 'CreateDateTime', 'InvoiceNumber', 'Comments', 'InvoiceTotal', 'TotalTaxValue', 'FromDate', 'ToDate', 'OrderNumber', 'PaymentTerm', 'WebServiceDate', 'IsVoided', 'VoidedDate', 'VoidedByResourceID', 'PaidDate', 'TaxRegionName', 'BatchID', 'InvoiceEditorTemplateID')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'CreatorResourceID', 'InvoiceDateTime', 'CreateDateTime', 'InvoiceNumber', 'Comments', 'InvoiceTotal', 'TotalTaxValue', 'FromDate', 'ToDate', 'OrderNumber', 'PaymentTerm', 'WebServiceDate', 'IsVoided', 'VoidedDate', 'VoidedByResourceID', 'PaidDate', 'TaxRegionName', 'BatchID', 'InvoiceEditorTemplateID')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'CreatorResourceID', 'InvoiceDateTime', 'CreateDateTime', 'InvoiceNumber', 'Comments', 'InvoiceTotal', 'TotalTaxValue', 'FromDate', 'ToDate', 'OrderNumber', 'PaymentTerm', 'WebServiceDate', 'VoidedDate', 'VoidedByResourceID', 'PaidDate', 'TaxRegionName', 'BatchID', 'InvoiceEditorTemplateID')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'CreatorResourceID', 'InvoiceDateTime', 'CreateDateTime', 'InvoiceNumber', 'Comments', 'InvoiceTotal', 'TotalTaxValue', 'FromDate', 'ToDate', 'OrderNumber', 'PaymentTerm', 'WebServiceDate', 'VoidedDate', 'VoidedByResourceID', 'PaidDate', 'TaxRegionName', 'BatchID', 'InvoiceEditorTemplateID')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'CreatorResourceID', 'InvoiceDateTime', 'CreateDateTime', 'InvoiceNumber', 'Comments', 'InvoiceTotal', 'TotalTaxValue', 'FromDate', 'ToDate', 'OrderNumber', 'PaymentTerm', 'WebServiceDate', 'VoidedDate', 'VoidedByResourceID', 'PaidDate', 'TaxRegionName', 'BatchID', 'InvoiceEditorTemplateID')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'CreatorResourceID', 'InvoiceDateTime', 'CreateDateTime', 'InvoiceNumber', 'Comments', 'InvoiceTotal', 'TotalTaxValue', 'FromDate', 'ToDate', 'OrderNumber', 'PaymentTerm', 'WebServiceDate', 'VoidedDate', 'VoidedByResourceID', 'PaidDate', 'TaxRegionName', 'BatchID', 'InvoiceEditorTemplateID')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('InvoiceNumber', 'Comments', 'OrderNumber', 'TaxRegionName')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('InvoiceNumber', 'Comments', 'OrderNumber', 'TaxRegionName')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('InvoiceNumber', 'Comments', 'OrderNumber', 'TaxRegionName')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('InvoiceNumber', 'Comments', 'OrderNumber', 'TaxRegionName')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('InvoiceNumber', 'Comments', 'OrderNumber', 'TaxRegionName')]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('InvoiceDateTime', 'CreateDateTime', 'FromDate', 'ToDate', 'WebServiceDate', 'VoidedDate', 'PaidDate')]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'Invoice'
    
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
    
      # Datetimeparameters
      $Fields = Get-AtwsFieldInfo -Entity $EntityName
    
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
