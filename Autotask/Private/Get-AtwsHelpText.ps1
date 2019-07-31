<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsHelpText {
     <#
      .SYNOPSIS

      .DESCRIPTION

      .INPUTS

      .OUTPUTS

      .EXAMPLE

      .NOTES
      NAME: 
      .LINK

  #>
    [CmdLetBinding()]
    [OutputType([string])]
    Param
    (   
        [Parameter(Mandatory)]
        [Autotask.EntityInfo]
        $Entity,
        
        [Parameter(Mandatory)]
        [ValidateSet('Get', 'Set', 'New', 'Remove')]
        [string]
        $Verb,
        
        [Parameter(Mandatory)]
        [Autotask.Field[]]
        $fieldInfo, 
    
        [Parameter(Mandatory)]
        [string]
        $FunctionName
    )

    begin {
        Write-Verbose ('{0}: Creating help text for {1}, verb "{2}"' -F $MyInvocation.MyCommand.Name, $Entity.Name, $Verb)
        $RequiredParameters = $fieldInfo.Where( { $_.IsRequired -and $_.Name -ne 'id' }).Name
        $PickListParameters = $fieldInfo.Where( { $_.IsPickList }).Name
        $IncomingEntities = ($Script:FieldInfoCache.GetEnumerator() | Where-Object { $_.Value.FieldInfo.ReferenceEntityType -eq $Entity.Name }).Key | Sort-Object
    
        # Get other valid verbs
        $Verbs = @()
        if ($Entity.CanCreate -and $Verb -ne 'New') {
            $Verbs += 'New'
        }
        if ($Entity.CanDelete -and $Verb -ne 'Remove') {
            $Verbs += 'Remove'
        }
        if ($Entity.CanQuery -and $Verb -ne 'Get') {
            $Verbs += 'Get'
        }
        if ($Entity.CanUpdate -and $Verb -ne 'Set') {
            $Verbs += 'Set'
        }
        # Make sure Examples and links are arrays
        $Examples = @()
        $Links = @()
    }
      
    process {
  
        # Start function and get parameter definition 
        switch ($Verb) {
            'New' {
                $Synopsis = 'This function creates a new {0} through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.' -F $Entity.Name
                $RequiredParameterstring = $RequiredParameters -join "`n -"
                $Description = "The function supports all properties of an [Autotask.{0}] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.`n`nIf you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the {0} with Id number 0 you could write '{2} -Id 0' or you could write '{2} -Filter {{Id -eq 0}}.`n`n'{2} -Id 0,4' could be written as '{2} -Filter {{id -eq 0 -or id -eq 4}}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. `n`nTo create a new {0} you need the following required fields:`n -{1}" -F $Entity.Name, $RequiredParameterstring, $FunctionName
                $Inputs = 'Nothing. This function only takes parameters.'
                $Outputs = '[Autotask.{0}]. This function outputs the Autotask.{0} that was created by the API.' -F $Entity.Name
                $Examples += "`$result = {0} -{1} [Value]`nCreates a new [Autotask.{2}] through the Web Services API and returns the new object." -F $FunctionName, $($RequiredParameters -join ' [Value] -'), $Entity.Name
                $Examples += "`$result = {0} -Id 124 | {1} `nCopies [Autotask.{2}] by Id 124 to a new object through the Web Services API and returns the new object." -F $($FunctionName -replace '^New', 'Get'), $FunctionName, $Entity.Name
                $Examples += "{0} -Id 124 | {1} | {3} -ParameterName <Parameter Value>`nCopies [Autotask.{2}] by Id 124 to a new object through the Web Services API, passes the new object to the {3} to modify the object." -F $($FunctionName -replace '^New', 'Get'), $FunctionName, $Entity.Name, $($FunctionName -replace '^New', 'Set')
                $Examples += "`$result = {0} -Id 124 | {1} | {3} -ParameterName <Parameter Value> -Passthru`nCopies [Autotask.{2}] by Id 124 to a new object through the Web Services API, passes the new object to the {3} to modify the object and returns the new object." -F $($FunctionName -replace '^New', 'Get'), $FunctionName, $Entity.Name, $($FunctionName -replace '^New', 'Set')

            }
            'Remove' {
                $Synopsis = 'This function deletes a {0} through the Autotask Web Services API.' -F $Entity.Name
                $Description = $Synopsis
                $Inputs = '[Autotask.{0}[]]. This function takes objects as input. Pipeline is supported.' -F $Entity.Name
                $Outputs = 'Nothing. This fuction just deletes the Autotask.{0} that was passed to the function.' -F $Entity.Name
                $Examples += '{0}  [-ParameterName] [Parameter value]' -F $FunctionName          
            }
            'Get' {
                $Synopsis = 'This function get one or more {0} through the Autotask Web Services API.' -F $Entity.Name
                $Description = "This function creates a query based on any parameters you give and returns any resulting objects from the Autotask Web Services Api. By default the function returns any objects with properties that are Equal (-eq) to the value of the parameter. To give you more flexibility you can modify the operator by using -NotEquals [ParameterName[]], -LessThan [ParameterName[]] and so on.`n`nPossible operators for all parameters are:`n -NotEquals`n -GreaterThan`n -GreaterThanOrEqual`n -LessThan`n -LessThanOrEquals `n`nAdditional operators for [string] parameters are:`n -Like (supports * or % as wildcards)`n -NotLike`n -BeginsWith`n -EndsWith`n -Contains`n`nProperties with picklists are:`n{0}" -F ($(
                        foreach ($PickList in $PickListParameters) {
                            $pickListValues = $fieldInfo.Where( { $_.Name -eq $PickList }).PickListValues | Select-Object Value, Label | ForEach-Object { '{0} - {1}' -F $_.Value, $_.Label }
                            "`n{0}`n {1}" -F $PickList, $($pickListValues -join "`n ")
                        } 
                    ) -join "`n")
       
                $Inputs = 'Nothing. This function only takes parameters.'
                $Outputs = '[Autotask.{0}[]]. This function outputs the Autotask.{0} that was returned by the API.' -F $Entity.Name
                $Examples += "{0} -Id 0`nReturns the object with Id 0, if any." -F $FunctionName
                $Examples += "{0} -{1}Name SomeName`nReturns the object with {1}Name 'SomeName', if any." -F $FunctionName, $Entity.Name
                $Examples += "{0} -{1}Name 'Some Name'`nReturns the object with {1}Name 'Some Name', if any." -F $FunctionName, $Entity.Name 
                $Examples += "{0} -{1}Name 'Some Name' -NotEquals {1}Name`nReturns any objects with a {1}Name that is NOT equal to 'Some Name', if any." -F $FunctionName, $Entity.Name
                $Examples += "{0} -{1}Name SomeName* -Like {1}Name`nReturns any object with a {1}Name that matches the simple pattern 'SomeName*'. Supported wildcards are * and %." -F $FunctionName, $Entity.Name        
                $Examples += "{0} -{1}Name SomeName* -NotLike {1}Name`nReturns any object with a {1}Name that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %." -F $FunctionName, $Entity.Name  
                if ($PickListParameters.Count -gt 0) {         
                    $Examples += "{0} -{1} <PickList Label>`nReturns any {2}s with property {1} equal to the <PickList Label>. '-PickList' is any parameter on ." -F $FunctionName, $PickListParameters[0], $Entity.Name
                    $Examples += "{0} -{1} <PickList Label> -NotEquals {1} `nReturns any {2}s with property {1} NOT equal to the <PickList Label>." -F $FunctionName, $PickListParameters[0], $Entity.Name
                    $Examples += "{0} -{1} <PickList Label1>, <PickList Label2>`nReturns any {2}s with property {1} equal to EITHER <PickList Label1> OR <PickList Label2>." -F $FunctionName, $PickListParameters[0], $Entity.Name
                    $Examples += "{0} -{1} <PickList Label1>, <PickList Label2> -NotEquals {1}`nReturns any {2}s with property {1} NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>." -F $FunctionName, $PickListParameters[0], $Entity.Name
                    $Examples += "{0} -Id 1234 -{2}Name SomeName* -{1} <PickList Label1>, <PickList Label2> -Like {2}Name -NotEquals {1} -GreaterThan Id`nAn example of a more complex query. This command returns any {2}s with Id GREATER THAN 1234, a {2}Name that matches the simple pattern SomeName* AND that has a {1} that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>." -F $FunctionName, $PickListParameters[0], $Entity.Name
                }
        
            }
            'Set' {
                $Synopsis = 'This function sets parameters on the {0} specified by the -InputObject parameter or pipeline through the use of the Autotask Web Services API. Any property of the {0} that is not marked as READ ONLY by Autotask can be speficied with a parameter. You can specify multiple paramters.' -F $Entity.Name
                $Description = 'This function one or more objects of type [Autotask.{0}] as input. You can pipe the objects to the function or pass them using the -InputObject parameter. You specify the property you want to set and the value you want to set it to using parameters. The function modifies all objects and updates the online data through the Autotask Web Services API. The function supports all properties of an [Autotask.{0}] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values.' -F $Entity.Name
                $Inputs = '[Autotask.{0}[]]. This function takes one or more objects as input. Pipeline is supported.' -F $Entity.Name
                $Outputs = 'Nothing or [Autotask.{0}]. This function optionally returns the updated objects if you use the -PassThru parameter.' -F $Entity.Name
                $Examples += "{0} -InputObject `${1} [-ParameterName] [Parameter value]`nPasses one or more [Autotask.{1}] object(s) as a variable to the function and sets the property by name 'ParameterName' on ALL the objects before they are passed to the Autotask Web Service API and updated." -F $FunctionName, $Entity.Name      
                $Examples += "`${1} | {0} -ParameterName <Parameter value>`nSame as the first example, but now the objects are passed to the funtion through the pipeline, not passed as a parameter. The end result is identical." -F $FunctionName, $Entity.Name              
                $Examples += "{1} -Id 0 | {0} -ParameterName <Parameter value>`nGets the instance with Id 0 directly from the Web Services API, modifies a parameter and updates Autotask. This approach works with all valid parameters for the Get function." -F $FunctionName, $($FunctionName -replace '^S', 'G')
                $Examples += "{1} -Id 0,4,8 | {0} -ParameterName <Parameter value>`nGets multiple instances by Id, modifies them all and updates Autotask." -F $FunctionName, $($FunctionName -replace '^S', 'G') 
                $Examples += "`$result = {1} -Id 0,4,8 | {0} -ParameterName <Parameter value> -PassThru`nGets multiple instances by Id, modifies them all, updates Autotask and returns the updated objects." -F $FunctionName, $($FunctionName -replace '^S', 'G')   
            }
        }
        # Add links to related functions
        foreach ($Word in $Verbs) { 
            $Links += ($FunctionName -replace "^$Verb", $Word)
        }
    }
  
    end {
        return @"
`n
<#
.SYNOPSIS
$Synopsis
.DESCRIPTION
$Description

Entities that have fields that refer to the base entity of this CmdLet:

$(
  foreach ($Name in $IncomingEntities)
  { 
  "$Name`n"
  }
)
.INPUTS
$Inputs
.OUTPUTS
$Outputs
$(
  foreach ($Example in $Examples)
  { @"
.EXAMPLE
$Example`n
"@
  }
)
$(
  foreach ($Link in $Links)
  { @"
.LINK
$Link`n
"@
  }
)
#>`n
"@
    }
}