#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Set-AtwsResource
{


<#
.SYNOPSIS
This function sets parameters on the Resource specified by the -InputObject parameter or pipeline through the use of the Autotask Web Services API. Any property of the Resource that is not marked as READ ONLY by Autotask can be speficied with a parameter. You can specify multiple paramters.
.DESCRIPTION
This function one or more objects of type [Autotask.Resource] as input. You can pipe the objects to the function or pass them using the -InputObject parameter. You specify the property you want to set and the value you want to set it to using parameters. The function modifies all objects and updates the online data through the Autotask Web Services API. The function supports all properties of an [Autotask.Resource] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values.

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
[Autotask.Resource[]]. This function takes one or more objects as input. Pipeline is supported.
.OUTPUTS
Nothing or [Autotask.Resource]. This function optionally returns the updated objects if you use the -PassThru parameter.
.EXAMPLE
Set-AtwsResource -InputObject $Resource [-ParameterName] [Parameter value]
Passes one or more [Autotask.Resource] object(s) as a variable to the function and sets the property by name 'ParameterName' on ALL the objects before they are passed to the Autotask Web Service API and updated.
 .EXAMPLE
$Resource | Set-AtwsResource -ParameterName <Parameter value>
Same as the first example, but now the objects are passed to the funtion through the pipeline, not passed as a parameter. The end result is identical.
 .EXAMPLE
Get-AtwsResource -Id 0 | Set-AtwsResource -ParameterName <Parameter value>
Gets the instance with Id 0 directly from the Web Services API, modifies a parameter and updates Autotask. This approach works with all valid parameters for the Get function.
 .EXAMPLE
Get-AtwsResource -Id 0,4,8 | Set-AtwsResource -ParameterName <Parameter value>
Gets multiple instances by Id, modifies them all and updates Autotask.
 .EXAMPLE
$result = Get-AtwsResource -Id 0,4,8 | Set-AtwsResource -ParameterName <Parameter value> -PassThru
Gets multiple instances by Id, modifies them all, updates Autotask and returns the updated objects.

.LINK
Get-AtwsResource

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
    [Autotask.Resource[]]
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

# Accounting Reference ID
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ValidateLength(0,100)]
    [string]
    $AccountingReferenceID,

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
    [Nullable[boolean]]
    $Active,

# Default Service Desk Role
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
    $DefaultServiceDeskRoleID,

# Email
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
    [ValidateLength(0,254)]
    [string]
    $Email,

# Add Email 1
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ValidateLength(0,254)]
    [string]
    $Email2,

# Add Email 2
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ValidateLength(0,254)]
    [string]
    $Email3,

# Email Type
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
      Get-AtwsPicklistValue -Entity Resource -FieldName EmailTypeCode -Label
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Resource -FieldName EmailTypeCode -Label) + (Get-AtwsPicklistValue -Entity Resource -FieldName EmailTypeCode -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $EmailTypeCode,

# Add Email 1 Type
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
      Get-AtwsPicklistValue -Entity Resource -FieldName EmailTypeCode2 -Label
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Resource -FieldName EmailTypeCode2 -Label) + (Get-AtwsPicklistValue -Entity Resource -FieldName EmailTypeCode2 -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $EmailTypeCode2,

# Add Email 2 Type
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
      Get-AtwsPicklistValue -Entity Resource -FieldName EmailTypeCode3 -Label
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Resource -FieldName EmailTypeCode3 -Label) + (Get-AtwsPicklistValue -Entity Resource -FieldName EmailTypeCode3 -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $EmailTypeCode3,

# First Name
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
    [ValidateLength(0,50)]
    [string]
    $FirstName,

# Gender
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
      Get-AtwsPicklistValue -Entity Resource -FieldName Gender -Label
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Resource -FieldName Gender -Label) + (Get-AtwsPicklistValue -Entity Resource -FieldName Gender -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $Gender,

# Greeting
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
      Get-AtwsPicklistValue -Entity Resource -FieldName Greeting -Label
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Resource -FieldName Greeting -Label) + (Get-AtwsPicklistValue -Entity Resource -FieldName Greeting -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $Greeting,

# Home Phone
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ValidateLength(0,25)]
    [string]
    $HomePhone,

# Pay Roll Identifier
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ValidateLength(0,32)]
    [string]
    $Initials,

# Last Name
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
    [ValidateLength(0,50)]
    [string]
    $LastName,

# Middle Initial
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
    $MiddleName,

# Mobile Phone
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ValidateLength(0,25)]
    [string]
    $MobilePhone,

# Number Format
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
      Get-AtwsPicklistValue -Entity Resource -FieldName NumberFormat -Label
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Resource -FieldName NumberFormat -Label) + (Get-AtwsPicklistValue -Entity Resource -FieldName NumberFormat -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $NumberFormat,

# Office Extension
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ValidateLength(0,10)]
    [string]
    $OfficeExtension,

# Office Phone
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ValidateLength(0,25)]
    [string]
    $OfficePhone,

# Password
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ValidateLength(0,64)]
    [string]
    $Password,

# Payroll Type
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
      Get-AtwsPicklistValue -Entity Resource -FieldName PayrollType -Label
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Resource -FieldName PayrollType -Label) + (Get-AtwsPicklistValue -Entity Resource -FieldName PayrollType -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $PayrollType,

# Resource Type
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
      Get-AtwsPicklistValue -Entity Resource -FieldName ResourceType -Label
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Resource -FieldName ResourceType -Label) + (Get-AtwsPicklistValue -Entity Resource -FieldName ResourceType -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $ResourceType,

# Suffix
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
      Get-AtwsPicklistValue -Entity Resource -FieldName Suffix -Label
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Resource -FieldName Suffix -Label) + (Get-AtwsPicklistValue -Entity Resource -FieldName Suffix -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $Suffix,

# Title
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
    $Title,

# Travel Availability Pct
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
      Get-AtwsPicklistValue -Entity Resource -FieldName TravelAvailabilityPct -Label
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Resource -FieldName TravelAvailabilityPct -Label) + (Get-AtwsPicklistValue -Entity Resource -FieldName TravelAvailabilityPct -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $TravelAvailabilityPct,

# UserName
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
    [ValidateLength(0,32)]
    [string]
    $UserName
  )

    begin {
        $entityName = 'Resource'

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
