#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function New-AtwsContract
{


<#
.SYNOPSIS
This function creates a new Contract through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.Contract] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the Contract with Id number 0 you could write 'New-AtwsContract -Id 0' or you could write 'New-AtwsContract -Filter {Id -eq 0}.

'New-AtwsContract -Id 0,4' could be written as 'New-AtwsContract -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new Contract you need the following required fields:
 -AccountID
 -ContractName
 -ContractType
 -EndDate
 -StartDate
 -Status
 -TimeReportingRequiresStartAndStopTimes

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Contract]. This function outputs the Autotask.Contract that was created by the API.
.EXAMPLE
$result = New-AtwsContract -AccountID [Value] -ContractName [Value] -ContractType [Value] -EndDate [Value] -StartDate [Value] -Status [Value] -TimeReportingRequiresStartAndStopTimes [Value]
Creates a new [Autotask.Contract] through the Web Services API and returns the new object.
 .EXAMPLE
$result = Get-AtwsContract -Id 124 | New-AtwsContract 
Copies [Autotask.Contract] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsContract -Id 124 | New-AtwsContract | Set-AtwsContract -ParameterName 'Parameter Value'
Copies [Autotask.Contract] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsContract to modify the object.
 .EXAMPLE
$result = Get-AtwsContract -Id 124 | New-AtwsContract | Set-AtwsContract -ParameterName 'Parameter Value' -Passthru
Copies [Autotask.Contract] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsContract to modify the object and returns the new object.

.NOTES
Related commands:
Get-AtwsContract
 Set-AtwsContract

#>

  [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName='By_parameters', ConfirmImpact='Low',
  HelpURI='https://github.com/ecitsolutions/Autotask/blob/master/Docs/New-AtwsContract.md')]
  Param
  (
# An array of objects to create
    [Parameter(
      ParametersetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.Contract[]]
    $InputObject,

# User defined fields already setup i Autotask
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('UDF')]
    [ValidateNotNullOrEmpty()]
    [Autotask.UserDefinedField[]]
    $UserDefinedFields,

# Account
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $AccountID,

# Billing Preference
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Contract -FieldName BillingPreference -Label -Quoted
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

# Bill To Account Contact ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $BillToAccountContactID,

# Bill To Account ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $BillToAccountID,

# Business Division Subdivision ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $BusinessDivisionSubdivisionID,

# Contract Compilance
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $Compliance,

# Contact ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ContactID,

# Contract Contact
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,250)]
    [string]
    $ContactName,

# Category
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Contract -FieldName ContractCategory -Label -Quoted
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
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ContractExclusionSetID,

# Contract Name
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [Alias('Name')]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [string]
    $ContractName,

# Contract Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $ContractNumber,

# Contract Period Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Contract -FieldName ContractPeriodType -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Contract -FieldName ContractPeriodType -Label) + (Get-AtwsPicklistValue -Entity Contract -FieldName ContractPeriodType -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $ContractPeriodType,

# Contract Type
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Contract -FieldName ContractType -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Contract -FieldName ContractType -Label) + (Get-AtwsPicklistValue -Entity Contract -FieldName ContractType -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $ContractType,

# Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string]
    $Description,

# End Date
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $EndDate,

# Estimated Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $EstimatedCost,

# Estimated Hours
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $EstimatedHours,

# Estimated Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $EstimatedRevenue,

# Exclusion Contract ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
    $ExclusionContractID,

# Internal Currency Contract Overage Billing Rate
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $InternalCurrencyOverageBillingRate,

# Internal Currency Contract Setup Fee
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $InternalCurrencySetupFee,

# Default Contract
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $IsDefaultContract,

# opportunity_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $OpportunityID,

# Contract Overage Billing Rate
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $OverageBillingRate,

# purchase_order_number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $PurchaseOrderNumber,

# Renewed Contract Id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
    $RenewedContractID,

# Service Level Agreement ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Contract -FieldName ServiceLevelAgreementID -Label -Quoted
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
      ParametersetName = 'By_parameters'
    )]
    [double]
    $SetupFee,

# Contract Setup Fee Allocation Code ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
    $SetupFeeAllocationCodeID,

# Start Date
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $StartDate,

# Status
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Contract -FieldName Status -Label -Quoted
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
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Contract -FieldName TimeReportingRequiresStartAndStopTimes -Label -Quoted
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
