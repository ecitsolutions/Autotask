#Requires -Version 4.0
#Version 1.6.8
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function New-AtwsQuote
{


<#
.SYNOPSIS
This function creates a new Quote through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.Quote] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the Quote with Id number 0 you could write 'New-AtwsQuote -Id 0' or you could write 'New-AtwsQuote -Filter {Id -eq 0}.

'New-AtwsQuote -Id 0,4' could be written as 'New-AtwsQuote -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new Quote you need the following required fields:
 -OpportunityID
 -Name
 -EffectiveDate
 -ExpirationDate
 -BillToLocationID
 -ShipToLocationID
 -SoldToLocationID

Entities that have fields that refer to the base entity of this CmdLet:

NotificationHistory
 QuoteItem

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Quote]. This function outputs the Autotask.Quote that was created by the API.
.EXAMPLE
$result = New-AtwsQuote -OpportunityID [Value] -Name [Value] -EffectiveDate [Value] -ExpirationDate [Value] -BillToLocationID [Value] -ShipToLocationID [Value] -SoldToLocationID [Value]
Creates a new [Autotask.Quote] through the Web Services API and returns the new object.
 .EXAMPLE
$result = Get-AtwsQuote -Id 124 | New-AtwsQuote 
Copies [Autotask.Quote] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsQuote -Id 124 | New-AtwsQuote | Set-AtwsQuote -ParameterName <Parameter Value>
Copies [Autotask.Quote] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsQuote to modify the object.
 .EXAMPLE
$result = Get-AtwsQuote -Id 124 | New-AtwsQuote | Set-AtwsQuote -ParameterName <Parameter Value> -Passthru
Copies [Autotask.Quote] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsQuote to modify the object and returns the new object.

.LINK
Get-AtwsQuote
 .LINK
Set-AtwsQuote

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
    [Autotask.Quote[]]
    $InputObject,

# opportunity_id
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $OpportunityID,

# quote_name
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [string]
    $Name,

# equote_active
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $eQuoteActive,

# effective_date
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $EffectiveDate,

# expiration_date
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $ExpirationDate,

# create_date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $CreateDate,

# create_by_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $CreatorResourceID,

# contact_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ContactID,

# tax_region_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string]
    $TaxGroup,

# project_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ProposalProjectID,

# bill_to_location_id
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $BillToLocationID,

# ship_to_location_id
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $ShipToLocationID,

# sold_to_location_id
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $SoldToLocationID,

# shipping_type_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string]
    $ShippingType,

# payment_type_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string]
    $PaymentType,

# payment_term_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string]
    $PaymentTerm,

# external_quote_number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $ExternalQuoteNumber,

# purchase_order_number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $PurchaseOrderNumber,

# quote_comment
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,1000)]
    [string]
    $Comment,

# quote_description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string]
    $Description,

# AccountID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $AccountID,

# calculate_tax_separately
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $CalculateTaxSeparately,

# group_by_product_category
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $GroupByProductCategory,

# show_each_tax_in_tax_group
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $ShowEachTaxInGroup,

# Show Tax Category
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $ShowTaxCategory,

# is_primary_quote
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $PrimaryQuote,

# Last Activity Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $LastActivityDate,

# Last Modified By
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $LastModifiedBy,

# Quote Template ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $QuoteTemplateID,

# Group By ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string]
    $GroupByID,

# Quote Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $QuoteNumber,

# Ext Approval Contact Response
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string]
    $ExtApprovalContactResponse,

# Ext Approval Response Signature
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,250)]
    [string]
    $ExtApprovalResponseSignature,

# Ext Approval Response Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $ExtApprovalResponseDate,

# Approval Status
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string]
    $ApprovalStatus,

# Approval Status Changed Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $ApprovalStatusChangedDate,

# Approval Status Changed By Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ApprovalStatusChangedByResourceID,

# Impersonator Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ImpersonatorCreatorResourceID
  )
 
    begin { 
        $entityName = 'Quote'
           
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
        
        $processObject = @()
    }

    process {
    
        if ($InputObject) {
            Write-Verbose -Message ('{0}: Copy Object mode: Setting ID property to zero' -F $MyInvocation.MyCommand.Name)  

            $fields = Get-AtwsFieldInfo -Entity $entityName
      
            $CopyNo = 1

            foreach ($object in $InputObject) { 
                # Create a new object and copy properties
                $newObject = New-Object -TypeName Autotask.$entityName
        
                # Copy every non readonly property
                $fieldNames = $fields.Where( { $_.Name -ne 'id' }).Name

                if ($PSBoundParameters.ContainsKey('UserDefinedFields')) { 
                    $fieldNames += 'UserDefinedFields' 
                }

                foreach ($field in $fieldNames) { 
                    $newObject.$field = $object.$field 
                }

                if ($newObject -is [Autotask.Ticket]) {
                    Write-Verbose -Message ('{0}: Copy Object mode: Object is a Ticket. Title must be modified to avoid duplicate detection.' -F $MyInvocation.MyCommand.Name)  
                    $title = '{0} (Copy {1})' -F $newObject.Title, $CopyNo
                    $copyNo++
                    $newObject.Title = $title
                }
                $processObject += $newObject
            }   
        }
        else {
            Write-Debug -Message ('{0}: Creating empty [Autotask.{1}]' -F $MyInvocation.MyCommand.Name, $entityName) 
            $processObject += New-Object -TypeName Autotask.$entityName    
        }
        
        # Prepare shouldProcess comments
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to create {1} {2}(s). This action cannot be undone.' -F $caption, $processObject.Count, $entityName
        $verboseWarning = '{0}: About to create {1} {2}(s). This action may not be undoable. Do you want to continue?' -F $caption, $processObject.Count, $entityName

        # Lets don't and say we did!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
            
            # Process parameters and update objects with their values
            $processObject = $processObject | Update-AtwsObjectsWithParameters -BoundParameters $PSBoundParameters -EntityName $EntityName
            
            $result = Set-AtwsData -Entity $processObject -Create
        }
    }

    end {
        Write-Debug -Message ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $result.count, $entityName)
        Return $result
    }

}
