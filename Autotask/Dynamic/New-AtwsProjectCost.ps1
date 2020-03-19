#Requires -Version 4.0
#Version 1.6.5
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function New-AtwsProjectCost
{


<#
.SYNOPSIS
This function creates a new ProjectCost through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.ProjectCost] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the ProjectCost with Id number 0 you could write 'New-AtwsProjectCost -Id 0' or you could write 'New-AtwsProjectCost -Filter {Id -eq 0}.

'New-AtwsProjectCost -Id 0,4' could be written as 'New-AtwsProjectCost -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new ProjectCost you need the following required fields:
 -ProjectID
 -Name
 -DatePurchased
 -CostType
 -UnitQuantity

Entities that have fields that refer to the base entity of this CmdLet:

BillingItem

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.ProjectCost]. This function outputs the Autotask.ProjectCost that was created by the API.
.EXAMPLE
$result = New-AtwsProjectCost -ProjectID [Value] -Name [Value] -DatePurchased [Value] -CostType [Value] -UnitQuantity [Value]
Creates a new [Autotask.ProjectCost] through the Web Services API and returns the new object.
 .EXAMPLE
$result = Get-AtwsProjectCost -Id 124 | New-AtwsProjectCost 
Copies [Autotask.ProjectCost] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsProjectCost -Id 124 | New-AtwsProjectCost | Set-AtwsProjectCost -ParameterName <Parameter Value>
Copies [Autotask.ProjectCost] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsProjectCost to modify the object.
 .EXAMPLE
$result = Get-AtwsProjectCost -Id 124 | New-AtwsProjectCost | Set-AtwsProjectCost -ParameterName <Parameter Value> -Passthru
Copies [Autotask.ProjectCost] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsProjectCost to modify the object and returns the new object.

.LINK
Remove-AtwsProjectCost
 .LINK
Get-AtwsProjectCost
 .LINK
Set-AtwsProjectCost

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
    [Autotask.ProjectCost[]]
    $InputObject,

# Project
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [long]
    $ProjectID,

# Product
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
    $ProductID,

# Allocation Code
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
    $AllocationCodeID,

# Name
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [string]
    $Name,

# Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string]
    $Description,

# Date Purchased
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $DatePurchased,

# Cost Type
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string]
    $CostType,

# Purchase Order Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $PurchaseOrderNumber,

# Internal Purchase Order Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $InternalPurchaseOrderNumber,

# Unit Quantity
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [double]
    $UnitQuantity,

# Unit Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $UnitCost,

# Unit Price
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $UnitPrice,

# Extended Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $ExtendedCost,

# Estimated Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $EstimatedCost,

# Billable Amount
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $BillableAmount,

# Billable To Client
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $BillableToAccount,

# Billed
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $Billed,

# Status
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string]
    $Status,

# Last Modified By
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
    $StatusLastModifiedBy,

# Last Modified Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $StatusLastModifiedDate,

# Create Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $CreateDate,

# Created By
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
    $CreatorResourceID,

# Contract Service ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
    $ContractServiceID,

# Contract Service Bundle ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
    $ContractServiceBundleID,

# Internal Currency Billable Amount
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $InternalCurrencyBillableAmount,

# Internal Currency Unit Price
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $InternalCurrencyUnitPrice,

# Business Division Subdivision ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $BusinessDivisionSubdivisionID,

# Notes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string]
    $Notes
  )
 
    begin { 
        $entityName = 'ProjectCost'
           
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
