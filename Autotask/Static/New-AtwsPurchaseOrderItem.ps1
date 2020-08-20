#Requires -Version 4.0
#Version 1.6.10
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function New-AtwsPurchaseOrderItem
{


<#
.SYNOPSIS
This function creates a new PurchaseOrderItem through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.PurchaseOrderItem] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the PurchaseOrderItem with Id number 0 you could write 'New-AtwsPurchaseOrderItem -Id 0' or you could write 'New-AtwsPurchaseOrderItem -Filter {Id -eq 0}.

'New-AtwsPurchaseOrderItem -Id 0,4' could be written as 'New-AtwsPurchaseOrderItem -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new PurchaseOrderItem you need the following required fields:
 -OrderID
 -InventoryLocationID
 -Quantity
 -UnitCost

Entities that have fields that refer to the base entity of this CmdLet:

PurchaseOrderReceive

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.PurchaseOrderItem]. This function outputs the Autotask.PurchaseOrderItem that was created by the API.
.EXAMPLE
$result = New-AtwsPurchaseOrderItem -OrderID [Value] -InventoryLocationID [Value] -Quantity [Value] -UnitCost [Value]
Creates a new [Autotask.PurchaseOrderItem] through the Web Services API and returns the new object.
 .EXAMPLE
$result = Get-AtwsPurchaseOrderItem -Id 124 | New-AtwsPurchaseOrderItem 
Copies [Autotask.PurchaseOrderItem] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsPurchaseOrderItem -Id 124 | New-AtwsPurchaseOrderItem | Set-AtwsPurchaseOrderItem -ParameterName <Parameter Value>
Copies [Autotask.PurchaseOrderItem] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsPurchaseOrderItem to modify the object.
 .EXAMPLE
$result = Get-AtwsPurchaseOrderItem -Id 124 | New-AtwsPurchaseOrderItem | Set-AtwsPurchaseOrderItem -ParameterName <Parameter Value> -Passthru
Copies [Autotask.PurchaseOrderItem] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsPurchaseOrderItem to modify the object and returns the new object.

.LINK
Get-AtwsPurchaseOrderItem
 .LINK
Set-AtwsPurchaseOrderItem

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
    [Autotask.PurchaseOrderItem[]]
    $InputObject,

# Inventory Order ID
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $OrderID,

# Product ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ProductID,

# Inventory Location ID
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $InventoryLocationID,

# Quantity Ordered
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $Quantity,

# Memo
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,4000)]
    [string]
    $Memo,

# Product Unit Cost
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [double]
    $UnitCost,

# Sales Order ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
    $SalesOrderID,

# Estimated Arrival Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $EstimatedArrivalDate,

# Cost ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $CostID,

# Contract ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
    $ContractID,

# Project ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
    $ProjectID,

# Ticket ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
    $TicketID,

# Internal Currency Product Unit Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $InternalCurrencyUnitCost
  )
 
    begin { 
        $entityName = 'PurchaseOrderItem'
           
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

                if ($newObject -is [Autotask.Ticket] -and $object.id -gt 0) {
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
