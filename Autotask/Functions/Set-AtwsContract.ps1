#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Set-AtwsContract
{


<#
.SYNOPSIS
This function sets parameters on the Contract specified by the -InputObject parameter or pipeline through the use of the Autotask Web Services API. Any property of the Contract that is not marked as READ ONLY by Autotask can be speficied with a parameter. You can specify multiple paramters.
.DESCRIPTION
This function one or more objects of type [Autotask.Contract] as input. You can pipe the objects to the function or pass them using the -InputObject parameter. You specify the property you want to set and the value you want to set it to using parameters. The function modifies all objects and updates the online data through the Autotask Web Services API. The function supports all properties of an [Autotask.Contract] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values.

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
[Autotask.Contract[]]. This function takes one or more objects as input. Pipeline is supported.
.OUTPUTS
Nothing or [Autotask.Contract]. This function optionally returns the updated objects if you use the -PassThru parameter.
.EXAMPLE
Set-AtwsContract -InputObject $Contract [-ParameterName] [Parameter value]
Passes one or more [Autotask.Contract] object(s) as a variable to the function and sets the property by name 'ParameterName' on ALL the objects before they are passed to the Autotask Web Service API and updated.
 .EXAMPLE
$Contract | Set-AtwsContract -ParameterName <Parameter value>
Same as the first example, but now the objects are passed to the funtion through the pipeline, not passed as a parameter. The end result is identical.
 .EXAMPLE
Get-AtwsContract -Id 0 | Set-AtwsContract -ParameterName <Parameter value>
Gets the instance with Id 0 directly from the Web Services API, modifies a parameter and updates Autotask. This approach works with all valid parameters for the Get function.
 .EXAMPLE
Get-AtwsContract -Id 0,4,8 | Set-AtwsContract -ParameterName <Parameter value>
Gets multiple instances by Id, modifies them all and updates Autotask.
 .EXAMPLE
$result = Get-AtwsContract -Id 0,4,8 | Set-AtwsContract -ParameterName <Parameter value> -PassThru
Gets multiple instances by Id, modifies them all, updates Autotask and returns the updated objects.

.LINK
New-AtwsContract
 .LINK
Get-AtwsContract

#>

  [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName='InputObject', ConfirmImpact='Low')]
  Param
  (
# An object that will be modified by any parameters and updated in Autotask
    [Parameter(
      ParametersetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.Contract[]]
    $InputObject,

# The object.ids of objects that should be modified by any parameters and updated in Autotask
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [long[]]
    $Id,

# Return any updated objects through the pipeline
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [switch]
    $PassThru,

# User defined fields already setup i Autotask
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('UDF')]
    [Autotask.UserDefinedField[]]
    $UserDefinedFields,

# Billing Preference
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Contract -FieldName BillingPreference -Label
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Contract -FieldName BillingPreference -Label) + (Get-AtwsPicklistValue -Entity Contract -FieldName BillingPreference -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $BillingPreference,

# Bill To Client Contact ID
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [Nullable[Int]]
    $BillToAccountContactID,

# Bill To Client ID
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [Nullable[Int]]
    $BillToAccountID,

# Business Division Subdivision ID
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [Nullable[Int]]
    $BusinessDivisionSubdivisionID,

# Contract Compilance
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [Nullable[boolean]]
    $Compliance,

# Contact ID
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [Nullable[Int]]
    $ContactID,

# Contract Contact
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ValidateLength(0,250)]
    [string]
    $ContactName,

# Category
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Contract -FieldName ContractCategory -Label
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Contract -FieldName ContractCategory -Label) + (Get-AtwsPicklistValue -Entity Contract -FieldName ContractCategory -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $ContractCategory,

# Contract Exclusion Set ID
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [Nullable[Int]]
    $ContractExclusionSetID,

# Contract Name
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [Alias('Name')]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [string]
    $ContractName,

# Contract Number
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ValidateLength(0,50)]
    [string]
    $ContractNumber,

# Description
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ValidateLength(0,2000)]
    [string]
    $Description,

# End Date
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime]]
    $EndDate,

# Estimated Cost
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [Nullable[double]]
    $EstimatedCost,

# Estimated Hours
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [Nullable[double]]
    $EstimatedHours,

# Estimated Revenue
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [Nullable[double]]
    $EstimatedRevenue,

# Default Contract
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [Nullable[boolean]]
    $IsDefaultContract,

# opportunity_id
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [Nullable[Int]]
    $OpportunityID,

# Contract Overage Billing Rate
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [Nullable[double]]
    $OverageBillingRate,

# purchase_order_number
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ValidateLength(0,50)]
    [string]
    $PurchaseOrderNumber,

# Renewed Contract Id
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [Nullable[long]]
    $RenewedContractID,

# Service Level Agreement ID
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Contract -FieldName ServiceLevelAgreementID -Label
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Contract -FieldName ServiceLevelAgreementID -Label) + (Get-AtwsPicklistValue -Entity Contract -FieldName ServiceLevelAgreementID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $ServiceLevelAgreementID,

# Contract Setup Fee
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [Nullable[double]]
    $SetupFee,

# Contract Setup Fee Allocation Code ID
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [Nullable[long]]
    $SetupFeeAllocationCodeID,

# Start Date
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime]]
    $StartDate,

# Status
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Contract -FieldName Status -Label
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Contract -FieldName Status -Label) + (Get-AtwsPicklistValue -Entity Contract -FieldName Status -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $Status,

# Time Reporting Requires Start and Stop Times
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Contract -FieldName TimeReportingRequiresStartAndStopTimes -Label
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Contract -FieldName TimeReportingRequiresStartAndStopTimes -Label) + (Get-AtwsPicklistValue -Entity Contract -FieldName TimeReportingRequiresStartAndStopTimes -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $TimeReportingRequiresStartAndStopTimes
  )

    begin {
        $entityName = 'Contract'

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

        $ModifiedObjects = [collections.generic.list[psobject]]::new()
    }

    process {
        # Collect fresh copies of InputObject if passed any IDs
        # Has to collect in batches, or we are going to get the
        # dreaded 'too nested SQL' error
        If ($Id.count -gt 0) {
            for ($i = 0; $i -lt $Id.count; $i += 200) {
                $j = $i + 199
                if ($j -ge $Id.count) {
                    $j = $Id.count - 1
                }

                # Create a filter with the current batch
                $Filter = 'Id -eq {0}' -F ($Id[$i .. $j] -join ' -or Id -eq ')

                $InputObject += Get-AtwsData -Entity $entityName -Filter $Filter
            }

            # Remove the ID parameter so we do not try to set it on every object
            $null = $PSBoundParameters.Remove('id')
        }

        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to modify {1} {2}(s). This action cannot be undone.' -F $caption, $InputObject.Count, $entityName
        $verboseWarning = '{0}: About to modify {1} {2}(s). This action cannot be undone. Do you want to continue?' -F $caption, $InputObject.Count, $entityName

        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) {

            Write-Verbose $verboseDescription

            # Process parameters and update objects with their values
            $processObject = $InputObject | Update-AtwsObjectsWithParameters -BoundParameters $PSBoundParameters -EntityName $EntityName

            try {
                # If using pipeline this block (process) will run once pr item in the pipeline. make sure to return them all
                # Force correct type. Makes sure AddRange() works even if it is a single object returned.
                [collections.generic.list[psobject]]$Data = Set-AtwsData -Entity $processObject
                $ModifiedObjects.AddRange($Data)
            }
            catch {
                # Write-Host?! And no throwing of exceptions? Not sure what I have been thinking here...
                write-host "ERROR: " -ForegroundColor Red -NoNewline
                write-host $_.Exception.Message
                write-host ("{0}: {1}" -f $_.CategoryInfo.Category,$_.CategoryInfo.Reason) -ForegroundColor Cyan
                $_.ScriptStackTrace -split '\n' | ForEach-Object {
                    Write-host "  |  " -ForegroundColor Cyan -NoNewline
                    Write-host $_
                }
            }
        }

    }

    end {
        Write-Debug ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $ModifiedObjects.count, $entityName)
        if ($PassThru.IsPresent) {
            Return [array]$ModifiedObjects
        }
    }

}
