#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function New-AtwsAccountPhysicalLocation
{


<#
.SYNOPSIS
This function creates a new AccountPhysicalLocation through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.AccountPhysicalLocation] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the AccountPhysicalLocation with Id number 0 you could write 'New-AtwsAccountPhysicalLocation -Id 0' or you could write 'New-AtwsAccountPhysicalLocation -Filter {Id -eq 0}.

'New-AtwsAccountPhysicalLocation -Id 0,4' could be written as 'New-AtwsAccountPhysicalLocation -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new AccountPhysicalLocation you need the following required fields:
 -AccountID
 -Name

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.AccountPhysicalLocation]. This function outputs the Autotask.AccountPhysicalLocation that was created by the API.
.EXAMPLE
$result = New-AtwsAccountPhysicalLocation -AccountID [Value] -Name [Value]
Creates a new [Autotask.AccountPhysicalLocation] through the Web Services API and returns the new object.
 .EXAMPLE
$result = Get-AtwsAccountPhysicalLocation -Id 124 | New-AtwsAccountPhysicalLocation 
Copies [Autotask.AccountPhysicalLocation] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsAccountPhysicalLocation -Id 124 | New-AtwsAccountPhysicalLocation | Set-AtwsAccountPhysicalLocation -ParameterName <Parameter Value>
Copies [Autotask.AccountPhysicalLocation] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsAccountPhysicalLocation to modify the object.
 .EXAMPLE
$result = Get-AtwsAccountPhysicalLocation -Id 124 | New-AtwsAccountPhysicalLocation | Set-AtwsAccountPhysicalLocation -ParameterName <Parameter Value> -Passthru
Copies [Autotask.AccountPhysicalLocation] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsAccountPhysicalLocation to modify the object and returns the new object.

.LINK
Remove-AtwsAccountPhysicalLocation
 .LINK
Get-AtwsAccountPhysicalLocation
 .LINK
Set-AtwsAccountPhysicalLocation

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
    [Autotask.AccountPhysicalLocation[]]
    $InputObject,

# Account ID
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $AccountID,

# Active
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $Active,

# Address1
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [string]
    $Address1,

# Address2
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [string]
    $Address2,

# Alternate Phone 1
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string]
    $AlternatePhone1,

# Alternate Phone 2
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string]
    $AlternatePhone2,

# City
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $City,

# Country ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $CountryID,

# Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,500)]
    [string]
    $Description,

# Fax
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string]
    $Fax,

# Is Tax Exempt
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $IsTaxExempt,

# Name
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,100)]
    [string]
    $Name,

# Override Account Tax Settings
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $OverrideAccountTaxSettings,

# Phone
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string]
    $Phone,

# Postal Code
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,20)]
    [string]
    $PostalCode,

# Primary
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $Primary,

# Round Trip Distance
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [decimal]
    $RoundtripDistance,

# State
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,25)]
    [string]
    $State,

# Tax Region ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $TaxRegionID
  )

    begin {
        $entityName = 'AccountPhysicalLocation'

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
