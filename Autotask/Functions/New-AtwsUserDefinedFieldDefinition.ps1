#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function New-AtwsUserDefinedFieldDefinition
{


<#
.SYNOPSIS
This function creates a new UserDefinedFieldDefinition through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.UserDefinedFieldDefinition] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the UserDefinedFieldDefinition with Id number 0 you could write 'New-AtwsUserDefinedFieldDefinition -Id 0' or you could write 'New-AtwsUserDefinedFieldDefinition -Filter {Id -eq 0}.

'New-AtwsUserDefinedFieldDefinition -Id 0,4' could be written as 'New-AtwsUserDefinedFieldDefinition -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new UserDefinedFieldDefinition you need the following required fields:
 -Name
 -UdfType
 -DataType

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.UserDefinedFieldDefinition]. This function outputs the Autotask.UserDefinedFieldDefinition that was created by the API.
.EXAMPLE
$result = New-AtwsUserDefinedFieldDefinition -Name [Value] -UdfType [Value] -DataType [Value]
Creates a new [Autotask.UserDefinedFieldDefinition] through the Web Services API and returns the new object.
 .EXAMPLE
$result = Get-AtwsUserDefinedFieldDefinition -Id 124 | New-AtwsUserDefinedFieldDefinition 
Copies [Autotask.UserDefinedFieldDefinition] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsUserDefinedFieldDefinition -Id 124 | New-AtwsUserDefinedFieldDefinition | Set-AtwsUserDefinedFieldDefinition -ParameterName <Parameter Value>
Copies [Autotask.UserDefinedFieldDefinition] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsUserDefinedFieldDefinition to modify the object.
 .EXAMPLE
$result = Get-AtwsUserDefinedFieldDefinition -Id 124 | New-AtwsUserDefinedFieldDefinition | Set-AtwsUserDefinedFieldDefinition -ParameterName <Parameter Value> -Passthru
Copies [Autotask.UserDefinedFieldDefinition] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsUserDefinedFieldDefinition to modify the object and returns the new object.

.LINK
Get-AtwsUserDefinedFieldDefinition
 .LINK
Set-AtwsUserDefinedFieldDefinition

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
    [Autotask.UserDefinedFieldDefinition[]]
    $InputObject,

# Create Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $CreateDate,

# Crm to Project Udf Id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
    $CrmToProjectUdfId,

# Data Type
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity UserDefinedFieldDefinition -FieldName DataType -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity UserDefinedFieldDefinition -FieldName DataType -Label) + (Get-AtwsPicklistValue -Entity UserDefinedFieldDefinition -FieldName DataType -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $DataType,

# Default Value
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,1024)]
    [string]
    $DefaultValue,

# Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [string]
    $Description,

# Display Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity UserDefinedFieldDefinition -FieldName DisplayFormat -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity UserDefinedFieldDefinition -FieldName DisplayFormat -Label) + (Get-AtwsPicklistValue -Entity UserDefinedFieldDefinition -FieldName DisplayFormat -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $DisplayFormat,

# Active
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $IsActive,

# Encrypted
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $IsEncrypted,

# Field Mapping
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $IsFieldMapping,

# Is Private
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $IsPrivate,

# Protected
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $IsProtected,

# Required
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $IsRequired,

# Visible to Client Portal
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $IsVisibleToClientPortal,

# Merge Variable Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string]
    $MergeVariableName,

# Name
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,45)]
    [string]
    $Name,

# Number of Decimal Places
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $NumberOfDecimalPlaces,

# Sort Order
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $SortOrder,

# Udf Type
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity UserDefinedFieldDefinition -FieldName UdfType -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity UserDefinedFieldDefinition -FieldName UdfType -Label) + (Get-AtwsPicklistValue -Entity UserDefinedFieldDefinition -FieldName UdfType -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $UdfType
  )

    begin {
        $entityName = 'UserDefinedFieldDefinition'

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

            # Check if any objects already has value in its ID property. All IDs must be zero, or the API will update
            # the existing object. Will only happen if you try to clone an existing object by passing it to New-*
            $sum = ($InputObject | Measure-Object -Property id).sum

            # If $sum has value we must reset object IDs or we will modify existing objects, not create new ones
            if ($sum -gt 0) {
                foreach ($object in $InputObject) {
                    $object.Id = $null
                    $processObject.add($object)
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
