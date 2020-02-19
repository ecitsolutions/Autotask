#Requires -Version 4.0
#Version 1.6.5
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function New-AtwsProject
{


<#
.SYNOPSIS
This function creates a new Project through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.Project] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the Project with Id number 0 you could write 'New-AtwsProject -Id 0' or you could write 'New-AtwsProject -Filter {Id -eq 0}.

'New-AtwsProject -Id 0,4' could be written as 'New-AtwsProject -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new Project you need the following required fields:
 -ProjectName
 -AccountID
 -Type
 -StartDateTime
 -EndDateTime
 -Status

Entities that have fields that refer to the base entity of this CmdLet:

BillingItem
 ExpenseItem
 NotificationHistory
 Phase
 ProjectCost
 ProjectNote
 PurchaseOrderItem
 Quote
 Task
 Ticket

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Project]. This function outputs the Autotask.Project that was created by the API.
.EXAMPLE
$result = New-AtwsProject -ProjectName [Value] -AccountID [Value] -Type [Value] -StartDateTime [Value] -EndDateTime [Value] -Status [Value]
Creates a new [Autotask.Project] through the Web Services API and returns the new object.
 .EXAMPLE
$result = Get-AtwsProject -Id 124 | New-AtwsProject 
Copies [Autotask.Project] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsProject -Id 124 | New-AtwsProject | Set-AtwsProject -ParameterName <Parameter Value>
Copies [Autotask.Project] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsProject to modify the object.
 .EXAMPLE
$result = Get-AtwsProject -Id 124 | New-AtwsProject | Set-AtwsProject -ParameterName <Parameter Value> -Passthru
Copies [Autotask.Project] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsProject to modify the object and returns the new object.

.LINK
Get-AtwsProject
 .LINK
Set-AtwsProject

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
    [Autotask.Project[]]
    $InputObject,

# Project Name
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [Alias('Name')]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [string]
    $ProjectName,

# Account ID
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $AccountID,

# Type
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string]
    $Type,

# Ext Project Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ExtProjectType,

# Ext Project Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $ExtPNumber,

# Project Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $ProjectNumber,

# Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string]
    $Description,

# Created DateTime
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $CreateDateTime,

# Created By
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $CreatorResourceID,

# Start Date
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $StartDateTime,

# End Date
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $EndDateTime,

# Duration
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $Duration,

# Actual Hours
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $ActualHours,

# Actual Billed Hours
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $ActualBilledHours,

# Estimated Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $EstimatedTime,

# Labor Estimated Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $LaborEstimatedRevenue,

# Labor Estimated Costs
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $LaborEstimatedCosts,

# Labor Estimated Margin Percentage
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $LaborEstimatedMarginPercentage,

# Project Cost Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $ProjectCostsRevenue,

# Project Estimated costs
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $ProjectCostsBudget,

# Project Cost Estimated Margin Percentage
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $ProjectCostEstimatedMarginPercentage,

# Change Orders Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $ChangeOrdersRevenue,

# Changed Orders
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $ChangeOrdersBudget,

# SG&A
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $SGDA,

# Original Estimated Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $OriginalEstimatedRevenue,

# Estimated Sales Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $EstimatedSalesCost,

# Status
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string]
    $Status,

# Contract
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ContractID,

# Project Lead
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ProjectLeadResourceID,

# Account Owner
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $CompanyOwnerResourceID,

# Completed Percentage
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $CompletedPercentage,

# Completed date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $CompletedDateTime,

# Status Detail
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string]
    $StatusDetail,

# Status Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $StatusDateTime,

# Department
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string]
    $Department,

# Line Of Business
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string]
    $LineOfBusiness,

# purchase_order_number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $PurchaseOrderNumber,

# Business Division Subdivision ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $BusinessDivisionSubdivisionID,

# Last Activity By
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $LastActivityResourceID,

# Last Activity Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $LastActivityDateTime,

# Last Activity Person Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $LastActivityPersonType
  )
 
    begin { 
        $entityName = 'Project'
           
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
