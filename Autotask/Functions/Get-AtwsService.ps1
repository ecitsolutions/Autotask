#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsService
{


<#
.SYNOPSIS
This function get one or more Service through the Autotask Web Services API.
.DESCRIPTION
This function creates a query based on any parameters you give and returns any resulting objects from the Autotask Web Services Api. By default the function returns any objects with properties that are Equal (-eq) to the value of the parameter. To give you more flexibility you can modify the operator by using -NotEquals [ParameterName[]], -LessThan [ParameterName[]] and so on.

Possible operators for all parameters are:
 -NotEquals
 -GreaterThan
 -GreaterThanOrEqual
 -LessThan
 -LessThanOrEquals 

Additional operators for [string] parameters are:
 -Like (supports * or % as wildcards)
 -NotLike
 -BeginsWith
 -EndsWith
 -Contains

Properties with picklists are:
PeriodType
ServiceLevelAgreementID

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Service[]]. This function outputs the Autotask.Service that was returned by the API.
.EXAMPLE
Get-AtwsService -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsService -ServiceName SomeName
Returns the object with ServiceName 'SomeName', if any.
 .EXAMPLE
Get-AtwsService -ServiceName 'Some Name'
Returns the object with ServiceName 'Some Name', if any.
 .EXAMPLE
Get-AtwsService -ServiceName 'Some Name' -NotEquals ServiceName
Returns any objects with a ServiceName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsService -ServiceName SomeName* -Like ServiceName
Returns any object with a ServiceName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsService -ServiceName SomeName* -NotLike ServiceName
Returns any object with a ServiceName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsService -PeriodType <PickList Label>
Returns any Services with property PeriodType equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsService -PeriodType <PickList Label> -NotEquals PeriodType 
Returns any Services with property PeriodType NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsService -PeriodType <PickList Label1>, <PickList Label2>
Returns any Services with property PeriodType equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsService -PeriodType <PickList Label1>, <PickList Label2> -NotEquals PeriodType
Returns any Services with property PeriodType NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsService -Id 1234 -ServiceName SomeName* -PeriodType <PickList Label1>, <PickList Label2> -Like ServiceName -NotEquals PeriodType -GreaterThan Id
An example of a more complex query. This command returns any Services with Id GREATER THAN 1234, a ServiceName that matches the simple pattern SomeName* AND that has a PeriodType that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsService
 .LINK
Set-AtwsService

#>

  [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName='Filter', ConfirmImpact='None')]
  Param
  (
# A filter that limits the number of objects that is returned from the API
    [Parameter(
      Mandatory = $true,
      ValueFromRemainingArguments = $true,
      ParametersetName = 'Filter'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Filter,

# Follow this external ID and return any external objects
    [Parameter(
      ParametersetName = 'Filter'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('GetRef')]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('VendorAccountID', 'UpdateResourceID', 'AllocationCodeID')]
    [string]
    $GetReferenceEntityById,

# Return entities of selected type that are referencing to this entity.
    [Parameter(
      ParametersetName = 'Filter'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('External')]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('QuoteItem', 'ContractServiceAdjustment', 'InstalledProduct', 'ServiceBundleService', 'ContractServiceUnit', 'ContractService', 'PriceListService', 'BillingItem')]
    [string]
    $GetExternalEntityByThisEntityId,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# allocation_code_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $AllocationCodeID,

# create_date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CreateDate,

# create_by_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CreatorResourceID,

# service_description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,400)]
    [string[]]
    $Description,

# service_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Invoice Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,1000)]
    [string[]]
    $InvoiceDescription,

# active
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $IsActive,

# update_date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LastModifiedDate,

# Markup Rate
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $MarkupRate,

# service_name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,150)]
    [string[]]
    $Name,

# period_type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Service -FieldName PeriodType -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Service -FieldName PeriodType -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $PeriodType,

# Service Level Agreement Id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Service -FieldName ServiceLevelAgreementID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity Service -FieldName ServiceLevelAgreementID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $ServiceLevelAgreementID,

# Unit Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $UnitCost,

# unit_price
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[double][]]
    $UnitPrice,

# update_by_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $UpdateResourceID,

# Vendor Account ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $VendorAccountID,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'UpdateResourceID', 'UnitCost', 'LastModifiedDate', 'CreatorResourceID', 'ServiceLevelAgreementID', 'CreateDate', 'AllocationCodeID', 'IsActive', 'Description', 'Name', 'UnitPrice', 'MarkupRate', 'VendorAccountID', 'InvoiceDescription', 'PeriodType')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'UpdateResourceID', 'UnitCost', 'LastModifiedDate', 'CreatorResourceID', 'ServiceLevelAgreementID', 'CreateDate', 'AllocationCodeID', 'IsActive', 'Description', 'Name', 'UnitPrice', 'MarkupRate', 'VendorAccountID', 'InvoiceDescription', 'PeriodType')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'UpdateResourceID', 'UnitCost', 'LastModifiedDate', 'CreatorResourceID', 'ServiceLevelAgreementID', 'CreateDate', 'AllocationCodeID', 'IsActive', 'Description', 'Name', 'UnitPrice', 'MarkupRate', 'VendorAccountID', 'InvoiceDescription', 'PeriodType')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'UnitPrice', 'PeriodType', 'AllocationCodeID', 'CreatorResourceID', 'UpdateResourceID', 'CreateDate', 'LastModifiedDate', 'VendorAccountID', 'UnitCost', 'InvoiceDescription', 'ServiceLevelAgreementID', 'MarkupRate')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'UnitPrice', 'PeriodType', 'AllocationCodeID', 'CreatorResourceID', 'UpdateResourceID', 'CreateDate', 'LastModifiedDate', 'VendorAccountID', 'UnitCost', 'InvoiceDescription', 'ServiceLevelAgreementID', 'MarkupRate')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'UnitPrice', 'PeriodType', 'AllocationCodeID', 'CreatorResourceID', 'UpdateResourceID', 'CreateDate', 'LastModifiedDate', 'VendorAccountID', 'UnitCost', 'InvoiceDescription', 'ServiceLevelAgreementID', 'MarkupRate')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'UnitPrice', 'PeriodType', 'AllocationCodeID', 'CreatorResourceID', 'UpdateResourceID', 'CreateDate', 'LastModifiedDate', 'VendorAccountID', 'UnitCost', 'InvoiceDescription', 'ServiceLevelAgreementID', 'MarkupRate')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'PeriodType', 'InvoiceDescription')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'PeriodType', 'InvoiceDescription')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'PeriodType', 'InvoiceDescription')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'PeriodType', 'InvoiceDescription')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'PeriodType', 'InvoiceDescription')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'LastModifiedDate')]
    [string[]]
    $IsThisDay
  )

    begin { 
        $entityName = 'Service'
    
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
    
    }


    process {
        # Parameterset Get_All has a single parameter: -All
        # Set the Filter manually to get every single object of this type 
        if ($PSCmdlet.ParameterSetName -eq 'Get_all') { 
            $Filter = @('id', '-ge', 0)
        }
        # So it is not -All. If Filter does not exist it has to be By_parameters
        elseif (-not ($Filter)) {
    
            Write-Debug ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)
      
            # Convert named parameters to a filter definition that can be parsed to QueryXML
            [string[]]$Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $entityName
        }
        # Not parameters, nor Get_all. There are only three parameter sets, so now we know
        # that we were passed a Filter
        else {
      
            Write-Debug ('{0}: Query based on manual filter, parsing' -F $MyInvocation.MyCommand.Name)
            
            # Parse the filter string and expand variables in _this_ scope (dot-sourcing)
            # or the variables will not be available and expansion will fail
            $Filter = . Update-AtwsFilter -Filterstring $Filter
        } 

        # Prepare shouldProcess comments
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to query the Autotask Web API for {1}(s).' -F $caption, $entityName
        $verboseWarning = '{0}: About to query the Autotask Web API for {1}(s). Do you want to continue?' -F $caption, $entityName
    
        # Lets do it and say we didn't!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
    
            # Make the query and pass the optional parameters to Get-AtwsData
            $result = Get-AtwsData -Entity $entityName -Filter $Filter `
                -NoPickListLabel:$NoPickListLabel.IsPresent `
                -GetReferenceEntityById $GetReferenceEntityById `
                -GetExternalEntityByThisEntityId $GetExternalEntityByThisEntityId
    
            Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $result.Count)

        }
    }

    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        if ($result) {
            Return $result
        }
    }


}
