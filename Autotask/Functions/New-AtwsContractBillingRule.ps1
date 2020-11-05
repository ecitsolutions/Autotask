#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function New-AtwsContractBillingRule
{


<#
.SYNOPSIS
This function creates a new ContractBillingRule through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.ContractBillingRule] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the ContractBillingRule with Id number 0 you could write 'New-AtwsContractBillingRule -Id 0' or you could write 'New-AtwsContractBillingRule -Filter {Id -eq 0}.

'New-AtwsContractBillingRule -Id 0,4' could be written as 'New-AtwsContractBillingRule -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new ContractBillingRule you need the following required fields:
 -ContractID
 -ProductID
 -Active
 -StartDate
 -DetermineUnits
 -CreateChargesAsBillable
 -IncludeItemsInChargeDescription
 -EnableDailyProrating

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.ContractBillingRule]. This function outputs the Autotask.ContractBillingRule that was created by the API.
.EXAMPLE
$result = New-AtwsContractBillingRule -ContractID [Value] -ProductID [Value] -Active [Value] -StartDate [Value] -DetermineUnits [Value] -CreateChargesAsBillable [Value] -IncludeItemsInChargeDescription [Value] -EnableDailyProrating [Value]
Creates a new [Autotask.ContractBillingRule] through the Web Services API and returns the new object.
 .EXAMPLE
$result = Get-AtwsContractBillingRule -Id 124 | New-AtwsContractBillingRule 
Copies [Autotask.ContractBillingRule] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsContractBillingRule -Id 124 | New-AtwsContractBillingRule | Set-AtwsContractBillingRule -ParameterName <Parameter Value>
Copies [Autotask.ContractBillingRule] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsContractBillingRule to modify the object.
 .EXAMPLE
$result = Get-AtwsContractBillingRule -Id 124 | New-AtwsContractBillingRule | Set-AtwsContractBillingRule -ParameterName <Parameter Value> -Passthru
Copies [Autotask.ContractBillingRule] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsContractBillingRule to modify the object and returns the new object.

.LINK
Remove-AtwsContractBillingRule
 .LINK
Get-AtwsContractBillingRule
 .LINK
Set-AtwsContractBillingRule

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
    [Autotask.ContractBillingRule[]]
    $InputObject,

# Active
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [boolean]
    $Active,

# Contract ID
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $ContractID,

# Create Charges As Billable
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [boolean]
    $CreateChargesAsBillable,

# Daily Prorated Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $DailyProratedCost,

# Daily Prorated Price
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $DailyProratedPrice,

# Determine Units
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity ContractBillingRule -FieldName DetermineUnits -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity ContractBillingRule -FieldName DetermineUnits -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $DetermineUnits,

# Enable Daily Prorating
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [boolean]
    $EnableDailyProrating,

# End Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $EndDate,

# Execution Method
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity ContractBillingRule -FieldName ExecutionMethod -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity ContractBillingRule -FieldName ExecutionMethod -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $ExecutionMethod,

# Include Items In Charge Description
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [boolean]
    $IncludeItemsInChargeDescription,

# Invoice Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string]
    $InvoiceDescription,

# Maximum Units
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $MaximumUnits,

# Minimum Units
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $MinimumUnits,

# Product ID
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $ProductID,

# Start Date
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $StartDate
  )
 
    begin { 
        $entityName = 'ContractBillingRule'
           
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
        
        $processObject = [Collections.ArrayList]::new()
    }

    process {
    
        if ($InputObject) {
            Write-Verbose -Message ('{0}: Copy Object mode: Setting ID property to zero' -F $MyInvocation.MyCommand.Name)  

            $entityInfo = Get-AtwsFieldInfo -Entity $entityName -EntityInfo
      
            $CopyNo = 1

            foreach ($object in $InputObject) { 
                # Create a new object and copy properties
                $newObject = New-Object -TypeName Autotask.$entityName
        
                # Copy every non readonly property
                $fieldNames = $entityInfo.WritableFields

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
                [void]$processObject.Add($newObject)
            }   
        }
        else {
            Write-Debug -Message ('{0}: Creating empty [Autotask.{1}]' -F $MyInvocation.MyCommand.Name, $entityName) 
            [void]$processObject.add((New-Object -TypeName Autotask.$entityName))   
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
