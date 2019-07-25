#Requires -Version 4.0
#Version 1.6.2.17
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsInventoryTransfer
{


<#
.SYNOPSIS
This function get one or more InventoryTransfer through the Autotask Web Services API.
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


Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.InventoryTransfer[]]. This function outputs the Autotask.InventoryTransfer that was returned by the API.
.EXAMPLE
Get-AtwsInventoryTransfer -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsInventoryTransfer -InventoryTransferName SomeName
Returns the object with InventoryTransferName 'SomeName', if any.
 .EXAMPLE
Get-AtwsInventoryTransfer -InventoryTransferName 'Some Name'
Returns the object with InventoryTransferName 'Some Name', if any.
 .EXAMPLE
Get-AtwsInventoryTransfer -InventoryTransferName 'Some Name' -NotEquals InventoryTransferName
Returns any objects with a InventoryTransferName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsInventoryTransfer -InventoryTransferName SomeName* -Like InventoryTransferName
Returns any object with a InventoryTransferName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsInventoryTransfer -InventoryTransferName SomeName* -NotLike InventoryTransferName
Returns any object with a InventoryTransferName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.

.LINK
New-AtwsInventoryTransfer

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
    [ValidateSet('FromLocationID', 'ProductID', 'ToLocationID', 'TransferByResourceID')]
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

# Inventory Transfer ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Product ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $ProductID,

# Transfer From Inventory Location ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $FromLocationID,

# Transfer To Inventory Location ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $ToLocationID,

# Quantity Transferred
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $QuantityTransferred,

# Transfer By Resource ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $TransferByResourceID,

# Transfer Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $TransferDate,

# Notes
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,4000)]
    [string[]]
    $Notes,

# Serial Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $SerialNumber,

# Update Note
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string[]]
    $UpdateNote,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ProductID', 'FromLocationID', 'ToLocationID', 'QuantityTransferred', 'TransferByResourceID', 'TransferDate', 'Notes', 'SerialNumber', 'UpdateNote')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ProductID', 'FromLocationID', 'ToLocationID', 'QuantityTransferred', 'TransferByResourceID', 'TransferDate', 'Notes', 'SerialNumber', 'UpdateNote')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ProductID', 'FromLocationID', 'ToLocationID', 'QuantityTransferred', 'TransferByResourceID', 'TransferDate', 'Notes', 'SerialNumber', 'UpdateNote')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ProductID', 'FromLocationID', 'ToLocationID', 'QuantityTransferred', 'TransferByResourceID', 'TransferDate', 'Notes', 'SerialNumber', 'UpdateNote')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ProductID', 'FromLocationID', 'ToLocationID', 'QuantityTransferred', 'TransferByResourceID', 'TransferDate', 'Notes', 'SerialNumber', 'UpdateNote')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ProductID', 'FromLocationID', 'ToLocationID', 'QuantityTransferred', 'TransferByResourceID', 'TransferDate', 'Notes', 'SerialNumber', 'UpdateNote')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'ProductID', 'FromLocationID', 'ToLocationID', 'QuantityTransferred', 'TransferByResourceID', 'TransferDate', 'Notes', 'SerialNumber', 'UpdateNote')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Notes', 'SerialNumber', 'UpdateNote')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Notes', 'SerialNumber', 'UpdateNote')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Notes', 'SerialNumber', 'UpdateNote')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Notes', 'SerialNumber', 'UpdateNote')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Notes', 'SerialNumber', 'UpdateNote')]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('TransferDate')]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'InventoryTransfer'
    
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
      $Result = Get-AtwsData -Entity $EntityName -Filter $Filter -NoPickListLabel:$NoPickListLabel.IsPresent
    
      Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $Result.Count)

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
