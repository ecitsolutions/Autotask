#Requires -Version 4.0
#Version 1.6.2.16
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

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

Additional operators for [String] parameters are:
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
    [ValidateSet('BusinessDivisionSubdivisionID', 'InstalledProductID', 'MaterialCodeID', 'VendorID')]
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
    [ValidateSet('SubscriptionPeriod:SubscriptionID')]
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

# Subscription ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Material Code Id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $MaterialCodeID,

# Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string[]]
    $Description,

# Subscription Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Alias('Name')]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [string[]]
    $SubscriptionName,

# Expiration Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $ExpirationDate,

# Effective Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $EffectiveDate,

# Total Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $TotalCost,

# Total Price
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $TotalPrice,

# Installed Product ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $InstalledProductID,

# Purchase Order Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $PurchaseOrderNumber,

# Period Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $PeriodType,

# Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $Status,

# Vendor ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $VendorID,

# Business Division Subdivision ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $BusinessDivisionSubdivisionID,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'MaterialCodeID', 'Description', 'SubscriptionName', 'ExpirationDate', 'EffectiveDate', 'TotalCost', 'TotalPrice', 'InstalledProductID', 'PurchaseOrderNumber', 'PeriodType', 'Status', 'VendorID', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'MaterialCodeID', 'Description', 'SubscriptionName', 'ExpirationDate', 'EffectiveDate', 'TotalCost', 'TotalPrice', 'InstalledProductID', 'PurchaseOrderNumber', 'PeriodType', 'Status', 'VendorID', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'MaterialCodeID', 'Description', 'SubscriptionName', 'ExpirationDate', 'EffectiveDate', 'TotalCost', 'TotalPrice', 'InstalledProductID', 'PurchaseOrderNumber', 'PeriodType', 'Status', 'VendorID', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'MaterialCodeID', 'Description', 'SubscriptionName', 'ExpirationDate', 'EffectiveDate', 'TotalCost', 'TotalPrice', 'InstalledProductID', 'PurchaseOrderNumber', 'PeriodType', 'Status', 'VendorID', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'MaterialCodeID', 'Description', 'SubscriptionName', 'ExpirationDate', 'EffectiveDate', 'TotalCost', 'TotalPrice', 'InstalledProductID', 'PurchaseOrderNumber', 'PeriodType', 'Status', 'VendorID', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'MaterialCodeID', 'Description', 'SubscriptionName', 'ExpirationDate', 'EffectiveDate', 'TotalCost', 'TotalPrice', 'InstalledProductID', 'PurchaseOrderNumber', 'PeriodType', 'Status', 'VendorID', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'MaterialCodeID', 'Description', 'SubscriptionName', 'ExpirationDate', 'EffectiveDate', 'TotalCost', 'TotalPrice', 'InstalledProductID', 'PurchaseOrderNumber', 'PeriodType', 'Status', 'VendorID', 'BusinessDivisionSubdivisionID')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'SubscriptionName', 'PurchaseOrderNumber', 'PeriodType')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'SubscriptionName', 'PurchaseOrderNumber', 'PeriodType')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'SubscriptionName', 'PurchaseOrderNumber', 'PeriodType')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'SubscriptionName', 'PurchaseOrderNumber', 'PeriodType')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description', 'SubscriptionName', 'PurchaseOrderNumber', 'PeriodType')]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('ExpirationDate', 'EffectiveDate')]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'Subscription'
    
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
