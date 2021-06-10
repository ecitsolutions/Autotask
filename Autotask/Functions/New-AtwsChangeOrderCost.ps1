#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function New-AtwsChangeOrderCost
{


<#
.SYNOPSIS
This function creates a new ChangeOrderCost through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.ChangeOrderCost] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the ChangeOrderCost with Id number 0 you could write 'New-AtwsChangeOrderCost -Id 0' or you could write 'New-AtwsChangeOrderCost -Filter {Id -eq 0}.

'New-AtwsChangeOrderCost -Id 0,4' could be written as 'New-AtwsChangeOrderCost -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new ChangeOrderCost you need the following required fields:
 -CostType
 -DatePurchased
 -Name
 -TaskID

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.ChangeOrderCost]. This function outputs the Autotask.ChangeOrderCost that was created by the API.
.EXAMPLE
$result = New-AtwsChangeOrderCost -CostType [Value] -DatePurchased [Value] -Name [Value] -TaskID [Value]
Creates a new [Autotask.ChangeOrderCost] through the Web Services API and returns the new object.
 .EXAMPLE
$result = Get-AtwsChangeOrderCost -Id 124 | New-AtwsChangeOrderCost 
Copies [Autotask.ChangeOrderCost] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsChangeOrderCost -Id 124 | New-AtwsChangeOrderCost | Set-AtwsChangeOrderCost -ParameterName <Parameter Value>
Copies [Autotask.ChangeOrderCost] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsChangeOrderCost to modify the object.
 .EXAMPLE
$result = Get-AtwsChangeOrderCost -Id 124 | New-AtwsChangeOrderCost | Set-AtwsChangeOrderCost -ParameterName <Parameter Value> -Passthru
Copies [Autotask.ChangeOrderCost] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsChangeOrderCost to modify the object and returns the new object.

.NOTES
Related commands:
Remove-AtwsChangeOrderCost
 Get-AtwsChangeOrderCost
 Set-AtwsChangeOrderCost

#>

  [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName='By_parameters', ConfirmImpact='Low',
  HelpURI='https://github.com/ecitsolutions/Autotask/blob/master/Docs/New-AtwsChangeOrderCost.md')]
  Param
  (
# An array of objects to create
    [Parameter(
      ParametersetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.ChangeOrderCost[]]
    $InputObject,

# Allocation Code ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $AllocationCodeID,

# Billable Amount
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $BillableAmount,

# Billable To Account
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

# Business Division Subdivision ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $BusinessDivisionSubdivisionID,

# Change Order Hours
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $ChangeOrderHours,

# Contract Service Bundle ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ContractServiceBundleID,

# Contract Service ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ContractServiceID,

# Cost Type
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity ChangeOrderCost -FieldName CostType -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity ChangeOrderCost -FieldName CostType -Label) + (Get-AtwsPicklistValue -Entity ChangeOrderCost -FieldName CostType -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $CostType,

# Create Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $CreateDate,

# Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $CreatorResourceID,

# Date Purchased
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $DatePurchased,

# Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string]
    $Description,

# Extended Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $ExtendedCost,

# Internal Currency Billable Amount
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $InternalCurrencyBillableAmount,

# Internal Currency Unit Price
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $InternalCurrencyUnitPrice,

# Internal Purchase Order Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $InternalPurchaseOrderNumber,

# Name
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [string]
    $Name,

# Notes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string]
    $Notes,

# Product ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ProductID,

# Purchase Order Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $PurchaseOrderNumber,

# Status
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity ChangeOrderCost -FieldName Status -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity ChangeOrderCost -FieldName Status -Label) + (Get-AtwsPicklistValue -Entity ChangeOrderCost -FieldName Status -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $Status,

# Status Last Modified By
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $StatusLastModifiedBy,

# Status Last Modified Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $StatusLastModifiedDate,

# Task ID
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $TaskID,

# Unit Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $UnitCost,

# Unit Price
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $UnitPrice,

# Unit Quantity
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $UnitQuantity
  )

    begin {
        $entityName = 'ChangeOrderCost'

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

        $processObject = [collections.generic.list[psobject]]::new()
        $result = [collections.generic.list[psobject]]::new()
    }

    process {

        if ($InputObject) {
            Write-Verbose -Message ('{0}: Copy Object mode: Setting ID property to zero' -F $MyInvocation.MyCommand.Name)

            # Copy the input array to the processObject collection
            if ($InputObject.count -gt 1) { 
                [collections.generic.list[psobject]]$processObject = $InputObject
            }
            else {
                $processObject.add($InputObject[0])
            }

            # If any objects has the ID property set to a value, the sum of all IDs will be larger than zero
            $sum = ($processObject | Measure-Object -Property Id -Sum).Sum

            # If $sum has value we must reset object IDs or we will modify existing objects, not create new ones
            if ($sum -gt 0) {
                foreach ($object in $processObject) {
                    $object.Id = $null
                }
            }
        }
        else {
            Write-Debug -Message ('{0}: Creating empty [Autotask.{1}]' -F $MyInvocation.MyCommand.Name, $entityName)
            $processObject.add((New-Object -TypeName Autotask.$entityName))
        }

        # Prepare shouldProcess comments
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to create {1} {2}(s). This action cannot be undone.' -F $caption, $processObject.Count, $entityName
        $verboseWarning = '{0}: About to create {1} {2}(s). This action may not be undoable. Do you want to continue?' -F $caption, $processObject.Count, $entityName

        # Lets don't and say we did!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) {

            # Process parameters and update objects with their values
            $processObject = $processObject | Update-AtwsObjectsWithParameters -BoundParameters $PSBoundParameters -EntityName $EntityName

            try {
                # Force list even if result is only 1 object to be compatible with addrange()
                [collections.generic.list[psobject]]$response = Set-AtwsData -Entity $processObject -Create
            }
            catch {
                # Write a debug message with detailed information to developers
                $ex = $_.Exception
                $reason = ("{0}: {1}" -f $_.CategoryInfo.Category, $_.CategoryInfo.Reason)
                $message = "{2}: {0}`r`n`r`nLine:{1}`r`n`r`nScript stacktrace:`r`n{3}" -f $ex.Message, $_.InvocationInfo.Line, $reason, $_.ScriptStackTrace
                while ($ex.InnerException) { 
                    $ex = $ex.InnerException
                    $message = "InnerException: {0}`n{1}" -F $ex.Message, $message
                }

                Write-Debug $message

                # Pass on the error
                $PSCmdlet.ThrowTerminatingError($_)
                return
            }
            # If using pipeline this block (process) will run once pr item in the pipeline. make sure to return them all
            if ($response.Count -gt 0) {
                $result.AddRange($response)
            }
        }
    }

    end {
        Write-Debug -Message ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $result.count, $entityName)
        Return [array]$result
    }

}
