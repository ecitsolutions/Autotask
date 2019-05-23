#Requires -Version 4.0
#Version 1.6.2.10
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsQuote
{


<#
.SYNOPSIS
This function get one or more Quote through the Autotask Web Services API.
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
 

ShippingType
 

PaymentType
 

PaymentTerm
 

GroupByID
 

Entities that have fields that refer to the base entity of this CmdLet:

NotificationHistory
 QuoteItem

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Quote[]]. This function outputs the Autotask.Quote that was returned by the API.
.EXAMPLE
Get-AtwsQuote -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsQuote -QuoteName SomeName
Returns the object with QuoteName 'SomeName', if any.
 .EXAMPLE
Get-AtwsQuote -QuoteName 'Some Name'
Returns the object with QuoteName 'Some Name', if any.
 .EXAMPLE
Get-AtwsQuote -QuoteName 'Some Name' -NotEquals QuoteName
Returns any objects with a QuoteName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsQuote -QuoteName SomeName* -Like QuoteName
Returns any object with a QuoteName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsQuote -QuoteName SomeName* -NotLike QuoteName
Returns any object with a QuoteName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsQuote -TaxGroup <PickList Label>
Returns any Quotes with property TaxGroup equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsQuote -TaxGroup <PickList Label> -NotEquals TaxGroup 
Returns any Quotes with property TaxGroup NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsQuote -TaxGroup <PickList Label1>, <PickList Label2>
Returns any Quotes with property TaxGroup equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsQuote -TaxGroup <PickList Label1>, <PickList Label2> -NotEquals TaxGroup
Returns any Quotes with property TaxGroup NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsQuote -Id 1234 -QuoteName SomeName* -TaxGroup <PickList Label1>, <PickList Label2> -Like QuoteName -NotEquals TaxGroup -GreaterThan Id
An example of a more complex query. This command returns any Quotes with Id GREATER THAN 1234, a QuoteName that matches the simple pattern SomeName* AND that has a TaxGroup that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsQuote
 .LINK
Set-AtwsQuote

#>

  [CmdLetBinding(DefaultParameterSetName='Filter', ConfirmImpact='None')]
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
    [ValidateSet('AccountID', 'BillToLocationID', 'ContactID', 'CreatorResourceID', 'LastModifiedBy', 'OpportunityID', 'ProposalProjectID', 'QuoteTemplateID', 'ShipToLocationID', 'SoldToLocationID')]
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
    [ValidateSet('NotificationHistory:QuoteID', 'QuoteItem:QuoteID')]
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

# opportunity_id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int[]]
    $OpportunityID,

# quote_id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [long[]]
    $id,

# quote_name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1,100)]
    [string[]]
    $Name,

# equote_active
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean[]]
    $eQuoteActive,

# effective_date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime[]]
    $EffectiveDate,

# expiration_date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime[]]
    $ExpirationDate,

# create_date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime[]]
    $CreateDate,

# create_by_id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $CreatorResourceID,

# contact_id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $ContactID,

# tax_region_id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $TaxGroup,

# project_id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $ProposalProjectID,

# bill_to_location_id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int[]]
    $BillToLocationID,

# ship_to_location_id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int[]]
    $ShipToLocationID,

# sold_to_location_id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int[]]
    $SoldToLocationID,

# shipping_type_id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $ShippingType,

# payment_type_id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $PaymentType,

# payment_term_id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $PaymentTerm,

# external_quote_number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string[]]
    $ExternalQuoteNumber,

# purchase_order_number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string[]]
    $PurchaseOrderNumber,

# quote_comment
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,1000)]
    [string[]]
    $Comment,

# quote_description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,2000)]
    [string[]]
    $Description,

# AccountID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $AccountID,

# is_primary_quote
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean[]]
    $PrimaryQuote,

# Last Activity Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime[]]
    $LastActivityDate,

# Last Modified By
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $LastModifiedBy,

# Quote Template ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $QuoteTemplateID,

# Group By ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $GroupByID,

# Quote Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $QuoteNumber,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('OpportunityID', 'id', 'Name', 'eQuoteActive', 'EffectiveDate', 'ExpirationDate', 'CreateDate', 'CreatorResourceID', 'ContactID', 'TaxGroup', 'ProposalProjectID', 'BillToLocationID', 'ShipToLocationID', 'SoldToLocationID', 'ShippingType', 'PaymentType', 'PaymentTerm', 'ExternalQuoteNumber', 'PurchaseOrderNumber', 'Comment', 'Description', 'AccountID', 'PrimaryQuote', 'LastActivityDate', 'LastModifiedBy', 'QuoteTemplateID', 'GroupByID', 'QuoteNumber')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('OpportunityID', 'id', 'Name', 'eQuoteActive', 'EffectiveDate', 'ExpirationDate', 'CreateDate', 'CreatorResourceID', 'ContactID', 'TaxGroup', 'ProposalProjectID', 'BillToLocationID', 'ShipToLocationID', 'SoldToLocationID', 'ShippingType', 'PaymentType', 'PaymentTerm', 'ExternalQuoteNumber', 'PurchaseOrderNumber', 'Comment', 'Description', 'AccountID', 'PrimaryQuote', 'LastActivityDate', 'LastModifiedBy', 'QuoteTemplateID', 'GroupByID', 'QuoteNumber')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('OpportunityID', 'id', 'Name', 'eQuoteActive', 'EffectiveDate', 'ExpirationDate', 'CreateDate', 'CreatorResourceID', 'ContactID', 'TaxGroup', 'ProposalProjectID', 'BillToLocationID', 'ShipToLocationID', 'SoldToLocationID', 'ShippingType', 'PaymentType', 'PaymentTerm', 'ExternalQuoteNumber', 'PurchaseOrderNumber', 'Comment', 'Description', 'AccountID', 'PrimaryQuote', 'LastActivityDate', 'LastModifiedBy', 'QuoteTemplateID', 'GroupByID', 'QuoteNumber')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('OpportunityID', 'id', 'Name', 'EffectiveDate', 'ExpirationDate', 'CreateDate', 'CreatorResourceID', 'ContactID', 'TaxGroup', 'ProposalProjectID', 'BillToLocationID', 'ShipToLocationID', 'SoldToLocationID', 'ShippingType', 'PaymentType', 'PaymentTerm', 'ExternalQuoteNumber', 'PurchaseOrderNumber', 'Comment', 'Description', 'AccountID', 'LastActivityDate', 'LastModifiedBy', 'QuoteTemplateID', 'GroupByID', 'QuoteNumber')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('OpportunityID', 'id', 'Name', 'EffectiveDate', 'ExpirationDate', 'CreateDate', 'CreatorResourceID', 'ContactID', 'TaxGroup', 'ProposalProjectID', 'BillToLocationID', 'ShipToLocationID', 'SoldToLocationID', 'ShippingType', 'PaymentType', 'PaymentTerm', 'ExternalQuoteNumber', 'PurchaseOrderNumber', 'Comment', 'Description', 'AccountID', 'LastActivityDate', 'LastModifiedBy', 'QuoteTemplateID', 'GroupByID', 'QuoteNumber')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('OpportunityID', 'id', 'Name', 'EffectiveDate', 'ExpirationDate', 'CreateDate', 'CreatorResourceID', 'ContactID', 'TaxGroup', 'ProposalProjectID', 'BillToLocationID', 'ShipToLocationID', 'SoldToLocationID', 'ShippingType', 'PaymentType', 'PaymentTerm', 'ExternalQuoteNumber', 'PurchaseOrderNumber', 'Comment', 'Description', 'AccountID', 'LastActivityDate', 'LastModifiedBy', 'QuoteTemplateID', 'GroupByID', 'QuoteNumber')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('OpportunityID', 'id', 'Name', 'EffectiveDate', 'ExpirationDate', 'CreateDate', 'CreatorResourceID', 'ContactID', 'TaxGroup', 'ProposalProjectID', 'BillToLocationID', 'ShipToLocationID', 'SoldToLocationID', 'ShippingType', 'PaymentType', 'PaymentTerm', 'ExternalQuoteNumber', 'PurchaseOrderNumber', 'Comment', 'Description', 'AccountID', 'LastActivityDate', 'LastModifiedBy', 'QuoteTemplateID', 'GroupByID', 'QuoteNumber')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'ExternalQuoteNumber', 'PurchaseOrderNumber', 'Comment', 'Description')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'ExternalQuoteNumber', 'PurchaseOrderNumber', 'Comment', 'Description')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'ExternalQuoteNumber', 'PurchaseOrderNumber', 'Comment', 'Description')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'ExternalQuoteNumber', 'PurchaseOrderNumber', 'Comment', 'Description')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'ExternalQuoteNumber', 'PurchaseOrderNumber', 'Comment', 'Description')]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('EffectiveDate', 'ExpirationDate', 'CreateDate', 'LastActivityDate')]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'Quote'
    
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

  End
  {
    Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    If ($Result)
    {
      Return $Result
    }
  }


}
