#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function New-AtwsContractServiceAdjustment
{


<#
.SYNOPSIS
This function creates a new ContractServiceAdjustment through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.ContractServiceAdjustment] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the ContractServiceAdjustment with Id number 0 you could write 'New-AtwsContractServiceAdjustment -Id 0' or you could write 'New-AtwsContractServiceAdjustment -Filter {Id -eq 0}.

'New-AtwsContractServiceAdjustment -Id 0,4' could be written as 'New-AtwsContractServiceAdjustment -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new ContractServiceAdjustment you need the following required fields:
 -EffectiveDate

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.ContractServiceAdjustment]. This function outputs the Autotask.ContractServiceAdjustment that was created by the API.
.EXAMPLE
$result = New-AtwsContractServiceAdjustment -EffectiveDate [Value]
Creates a new [Autotask.ContractServiceAdjustment] through the Web Services API and returns the new object.
 .EXAMPLE
$result = Get-AtwsContractServiceAdjustment -Id 124 | New-AtwsContractServiceAdjustment 
Copies [Autotask.ContractServiceAdjustment] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsContractServiceAdjustment -Id 124 | New-AtwsContractServiceAdjustment | Set-AtwsContractServiceAdjustment -ParameterName <Parameter Value>
Copies [Autotask.ContractServiceAdjustment] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsContractServiceAdjustment to modify the object.
 .EXAMPLE
$result = Get-AtwsContractServiceAdjustment -Id 124 | New-AtwsContractServiceAdjustment | Set-AtwsContractServiceAdjustment -ParameterName <Parameter Value> -Passthru
Copies [Autotask.ContractServiceAdjustment] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsContractServiceAdjustment to modify the object and returns the new object.


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
    [Autotask.ContractServiceAdjustment[]]
    $InputObject,

# Adjusted Unit Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $AdjustedUnitCost,

# Adjusted Unit Price
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $AdjustedUnitPrice,

# Allow Repeat Service
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $AllowRepeatService,

# ContractID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ContractID,

# Contract Service Id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ContractServiceID,

# StartDate
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $EffectiveDate,

# Quote Item Id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $QuoteItemID,

# ServiceID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ServiceID,

# UnitChange
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $UnitChange
  )

    begin {
        $entityName = 'ContractServiceAdjustment'

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
            [collections.generic.list[psobject]]$processObject = $InputObject

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
