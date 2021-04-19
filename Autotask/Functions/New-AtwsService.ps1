#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function New-AtwsService
{


<#
.SYNOPSIS
This function creates a new Service through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.Service] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the Service with Id number 0 you could write 'New-AtwsService -Id 0' or you could write 'New-AtwsService -Filter {Id -eq 0}.

'New-AtwsService -Id 0,4' could be written as 'New-AtwsService -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new Service you need the following required fields:
 -Name
 -UnitPrice
 -PeriodType
 -AllocationCodeID

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Service]. This function outputs the Autotask.Service that was created by the API.
.EXAMPLE
$result = New-AtwsService -Name [Value] -UnitPrice [Value] -PeriodType [Value] -AllocationCodeID [Value]
Creates a new [Autotask.Service] through the Web Services API and returns the new object.
 .EXAMPLE
$result = Get-AtwsService -Id 124 | New-AtwsService 
Copies [Autotask.Service] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsService -Id 124 | New-AtwsService | Set-AtwsService -ParameterName <Parameter Value>
Copies [Autotask.Service] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsService to modify the object.
 .EXAMPLE
$result = Get-AtwsService -Id 124 | New-AtwsService | Set-AtwsService -ParameterName <Parameter Value> -Passthru
Copies [Autotask.Service] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsService to modify the object and returns the new object.

.LINK
Get-AtwsService
 .LINK
Set-AtwsService

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
    [Autotask.Service[]]
    $InputObject,

# allocation_code_id
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $AllocationCodeID,

# create_date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $CreateDate,

# create_by_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $CreatorResourceID,

# service_description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,400)]
    [string]
    $Description,

# Invoice Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,1000)]
    [string]
    $InvoiceDescription,

# active
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $IsActive,

# update_date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $LastModifiedDate,

# Markup Rate
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $MarkupRate,

# service_name
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,150)]
    [string]
    $Name,

# period_type
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Service -FieldName PeriodType -Label
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Service -FieldName PeriodType -Label) + (Get-AtwsPicklistValue -Entity Service -FieldName PeriodType -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $PeriodType,

# Service Level Agreement Id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity Service -FieldName ServiceLevelAgreementID -Label
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity Service -FieldName ServiceLevelAgreementID -Label) + (Get-AtwsPicklistValue -Entity Service -FieldName ServiceLevelAgreementID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $ServiceLevelAgreementID,

# Unit Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $UnitCost,

# unit_price
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [double]
    $UnitPrice,

# update_by_id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $UpdateResourceID,

# Vendor Account ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $VendorAccountID
  )

    begin {
        $entityName = 'Service'

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

            $entityInfo = Get-AtwsFieldInfo -Entity $entityName -EntityInfo

            $CopyNo = 1

            foreach ($object in $InputObject) {
                # Create a new object and copy properties
                $newObject = New-Object -TypeName Autotask.$entityName

                # Copy every non readonly property
                $fieldNames = [collections.generic.list[psobject]]::new()
                $WriteableFields = $entityInfo.WriteableFields
                $RequiredFields = $entityInfo.RequiredFields

                if ($WriteableFields.count -gt 1) { $fieldNames.AddRange($WriteableFields) } else { $fieldNames.Add($WriteableFields) }
                if ($RequiredFields.count -gt 1) { $fieldNames.AddRange($RequiredFields) } else { $fieldNames.Add($RequiredFields) }

                if ($PSBoundParameters.ContainsKey('UserDefinedFields')) {
                    $fieldNames += 'UserDefinedFields'
                }

                foreach ($field in $fieldNames) {
                    $newObject.$field = $object.$field
                }

                if ($newObject -is [Autotask.Ticket] -and $object.id -gt 0) {
                    Write-Verbose -Message ('{0}: Copy Object mode: Object is a Ticket. Title must be modified to avoid duplicate detection.' -F $MyInvocation.MyCommand.Name)
                    $title = '{0} (Copy {1})' -F $newObject.Title, $CopyNo
                    $copyNo++
                    $newObject.Title = $title
                }
                $processObject.Add($newObject)
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
