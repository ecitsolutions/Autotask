#Requires -Version 4.0
#Version 1.6.5
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsSubscription
{


<#
.SYNOPSIS
This function get one or more Subscription through the Autotask Web Services API.
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
 

Status
 

Entities that have fields that refer to the base entity of this CmdLet:

SubscriptionPeriod

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Subscription[]]. This function outputs the Autotask.Subscription that was returned by the API.
.EXAMPLE
Get-AtwsSubscription -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsSubscription -SubscriptionName SomeName
Returns the object with SubscriptionName 'SomeName', if any.
 .EXAMPLE
Get-AtwsSubscription -SubscriptionName 'Some Name'
Returns the object with SubscriptionName 'Some Name', if any.
 .EXAMPLE
Get-AtwsSubscription -SubscriptionName 'Some Name' -NotEquals SubscriptionName
Returns any objects with a SubscriptionName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsSubscription -SubscriptionName SomeName* -Like SubscriptionName
Returns any object with a SubscriptionName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsSubscription -SubscriptionName SomeName* -NotLike SubscriptionName
Returns any object with a SubscriptionName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsSubscription -PeriodType <PickList Label>
Returns any Subscriptions with property PeriodType equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsSubscription -PeriodType <PickList Label> -NotEquals PeriodType 
Returns any Subscriptions with property PeriodType NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsSubscription -PeriodType <PickList Label1>, <PickList Label2>
Returns any Subscriptions with property PeriodType equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsSubscription -PeriodType <PickList Label1>, <PickList Label2> -NotEquals PeriodType
Returns any Subscriptions with property PeriodType NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsSubscription -Id 1234 -SubscriptionName SomeName* -PeriodType <PickList Label1>, <PickList Label2> -Like SubscriptionName -NotEquals PeriodType -GreaterThan Id
An example of a more complex query. This command returns any Subscriptions with Id GREATER THAN 1234, a SubscriptionName that matches the simple pattern SomeName* AND that has a PeriodType that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsSubscription
 .LINK
Remove-AtwsSubscription
 .LINK
Set-AtwsSubscription

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
    [ValidateSet('BusinessDivisionSubdivisionID', 'InstalledProductID', 'MaterialCodeID', 'VendorID')]
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
    [ValidateSet('SubscriptionPeriod:SubscriptionID')]
    [string]
    $GetExternalEntityByThisEntityId,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# Subscription ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Material Code Id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $MaterialCodeID,

# Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string[]]
    $Description,

# Subscription Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('Name')]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [string[]]
    $SubscriptionName,

# Expiration Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $ExpirationDate,

# Effective Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $EffectiveDate,

# Total Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $TotalCost,

# Total Price
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $TotalPrice,

# Installed Product ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $InstalledProductID,

# Purchase Order Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $PurchaseOrderNumber,

# Period Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $PeriodType,

# Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Status,

# Vendor ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $VendorID,

# Business Division Subdivision ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BusinessDivisionSubdivisionID,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'MaterialCodeID', 'Description', 'SubscriptionName', 'ExpirationDate', 'EffectiveDate', 'TotalCost', 'TotalPrice', 'InstalledProductID', 'PurchaseOrderNumber', 'PeriodType', 'Status', 'VendorID', 'BusinessDivisionSubdivisionID')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'MaterialCodeID', 'Description', 'SubscriptionName', 'ExpirationDate', 'EffectiveDate', 'TotalCost', 'TotalPrice', 'InstalledProductID', 'PurchaseOrderNumber', 'PeriodType', 'Status', 'VendorID', 'BusinessDivisionSubdivisionID')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'MaterialCodeID', 'Description', 'SubscriptionName', 'ExpirationDate', 'EffectiveDate', 'TotalCost', 'TotalPrice', 'InstalledProductID', 'PurchaseOrderNumber', 'PeriodType', 'Status', 'VendorID', 'BusinessDivisionSubdivisionID')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'MaterialCodeID', 'Description', 'SubscriptionName', 'ExpirationDate', 'EffectiveDate', 'TotalCost', 'TotalPrice', 'InstalledProductID', 'PurchaseOrderNumber', 'PeriodType', 'Status', 'VendorID', 'BusinessDivisionSubdivisionID')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'MaterialCodeID', 'Description', 'SubscriptionName', 'ExpirationDate', 'EffectiveDate', 'TotalCost', 'TotalPrice', 'InstalledProductID', 'PurchaseOrderNumber', 'PeriodType', 'Status', 'VendorID', 'BusinessDivisionSubdivisionID')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'MaterialCodeID', 'Description', 'SubscriptionName', 'ExpirationDate', 'EffectiveDate', 'TotalCost', 'TotalPrice', 'InstalledProductID', 'PurchaseOrderNumber', 'PeriodType', 'Status', 'VendorID', 'BusinessDivisionSubdivisionID')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'MaterialCodeID', 'Description', 'SubscriptionName', 'ExpirationDate', 'EffectiveDate', 'TotalCost', 'TotalPrice', 'InstalledProductID', 'PurchaseOrderNumber', 'PeriodType', 'Status', 'VendorID', 'BusinessDivisionSubdivisionID')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'SubscriptionName', 'PurchaseOrderNumber', 'PeriodType')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'SubscriptionName', 'PurchaseOrderNumber', 'PeriodType')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'SubscriptionName', 'PurchaseOrderNumber', 'PeriodType')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'SubscriptionName', 'PurchaseOrderNumber', 'PeriodType')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'SubscriptionName', 'PurchaseOrderNumber', 'PeriodType')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ExpirationDate', 'EffectiveDate')]
    [string[]]
    $IsThisDay
  )

    begin { 
        $entityName = 'Subscription'
    
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
