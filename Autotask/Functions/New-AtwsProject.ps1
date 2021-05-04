#Requires -Version 5.0
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

# Account ID
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $AccountID,

# Actual Billed Hours
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $ActualBilledHours,

# Actual Hours
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $ActualHours,

# Business Division Subdivision ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $BusinessDivisionSubdivisionID,

# Changed Orders
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $ChangeOrdersBudget,

# Change Orders Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $ChangeOrdersRevenue,

# Account Owner
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $CompanyOwnerResourceID,

# Completed date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $CompletedDateTime,

# Completed Percentage
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $CompletedPercentage,

# Contract
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ContractID,

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

# Department
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Project -FieldName Department -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Project -FieldName Department -Label) + (Get-AtwsPicklistValue -Entity Project -FieldName Department -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $Department,

# Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string]
    $Description,

# Duration
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $Duration,

# End Date
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $EndDateTime,

# Estimated Sales Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $EstimatedSalesCost,

# Estimated Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $EstimatedTime,

# Ext Project Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $ExtPNumber,

# Ext Project Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ExtProjectType,

# Impersonator Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ImpersonatorCreatorResourceID,

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

# Labor Estimated Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $LaborEstimatedRevenue,

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
    $LastActivityPersonType,

# Last Activity By
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $LastActivityResourceID,

# Line Of Business
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Project -FieldName LineOfBusiness -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Project -FieldName LineOfBusiness -Label) + (Get-AtwsPicklistValue -Entity Project -FieldName LineOfBusiness -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $LineOfBusiness,

# Opportunity ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $OpportunityID,

# Original Estimated Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $OriginalEstimatedRevenue,

# Project Cost Estimated Margin Percentage
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $ProjectCostEstimatedMarginPercentage,

# Project Estimated costs
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $ProjectCostsBudget,

# Project Cost Revenue
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $ProjectCostsRevenue,

# Project Lead
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ProjectLeadResourceID,

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

# Project Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $ProjectNumber,

# purchase_order_number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $PurchaseOrderNumber,

# SG&A
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $SGDA,

# Start Date
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $StartDateTime,

# Status
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Project -FieldName Status -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Project -FieldName Status -Label) + (Get-AtwsPicklistValue -Entity Project -FieldName Status -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $Status,

# Status Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $StatusDateTime,

# Status Detail
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string]
    $StatusDetail,

# Type
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Project -FieldName Type -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Project -FieldName Type -Label) + (Get-AtwsPicklistValue -Entity Project -FieldName Type -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $Type
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

        $result = [collections.generic.list[psobject]]::new()
    }

    process {

        if ($InputObject) {
            Write-Verbose -Message ('{0}: Copy Object mode: Setting ID property to zero' -F $MyInvocation.MyCommand.Name)

            #Measure-Object should work here, but returns 0 as Count/Sum. 
            #Count throws error if we cast a null value to its method, but here we know that we dont have a null value.
            $sum = ($InputObject | Measure-Object -Property Id -Sum).Sum

            # If $sum has value we must reset object IDs or we will modify existing objects, not create new ones
            if ($sum -gt 0) {
                foreach ($object in $InputObject) {
                    $object.Id = $null
                }
            }
        }
        else {
            Write-Debug -Message ('{0}: Creating empty [Autotask.{1}]' -F $MyInvocation.MyCommand.Name, $entityName)
            $inputObject = @($(New-Object -TypeName Autotask.$entityName))
        }

        # Prepare shouldProcess comments
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to create {1} {2}(s). This action cannot be undone.' -F $caption, $inputObject.Count, $entityName
        $verboseWarning = '{0}: About to create {1} {2}(s). This action may not be undoable. Do you want to continue?' -F $caption, $inputObject.Count, $entityName

        # Lets don't and say we did!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) {

            # Process parameters and update objects with their values
            $inputObject = $inputObject | Update-AtwsObjectsWithParameters -BoundParameters $PSBoundParameters -EntityName $EntityName

            try {
                # Force list even if result is only 1 object to be compatible with addrange()
                [collections.generic.list[psobject]]$response = Set-AtwsData -Entity $inputObject -Create
            }
            catch {
                # Write a debug message with detailed information to developers
                $reason = ("{0}: {1}" -f $_.CategoryInfo.Category, $_.CategoryInfo.Reason)
                $message = "{2}: {0}`r`n`r`nLine:{1}`r`n`r`nScript stacktrace:`r`n{3}" -f $_.Exception.Message, $_.InvocationInfo.Line, $reason, $_.ScriptStackTrace
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
