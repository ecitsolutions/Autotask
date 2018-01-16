Class AutotaskFunctionDefinition
{
  [String]$Verb
  [String]$EntityName
  [PSObject[]]$FieldInfo
  [String]$FunctionName
  [String]$Synopsis
  [String]$Description
  [String]$Inputs
  [String]$Outputs
  [String]$Examples
  [STring]$DefaultParameterSetName

  AutotaskFunctionDefinition([String]$Verb, [string]$EntityName,[PSObject[]]$FieldInfo, [String]$FunctionName)
  {
    $This.Verb = $Verb
    $This.EntityName = $EntityName
    $This.FunctionName = $FunctionName

    # Start function and get parameter definition 
    Switch ($Verb) {
      'New' 
      {
        $This.Synopsis = 'This function creates a new {0} through the Autotask Web Services API.' -F $EntityName
        $RequiredParameters = $FieldInfo.Where({
            $_.IsRequired -and $_.Name -ne 'id'
        }).Name
        $This.Description = "To create a new {0} you need the following required fields:`n -{1}" -F $EntityName, $($RequiredParameters -join "`n -")
        $This.Inputs = 'Nothing. This function only takes parameters.'
        $This.Outputs = '[Autotask.{0}]. This function outputs the Autotask.{1} that was created by the API.' -F $EntityName, $EntityName
        $This.Examples = "{0} -{1} [Value]" -F $FunctionName, $($RequiredParameters -join ' [Value] -')
        $This.DefaultParameterSetName = 'By_parameters'
      }
      'Remove' 
      {
        $This.Synopsis = 'This function deletes a {0} through the Autotask Web Services API.' -F $EntityName
        $This.Description = $This.Synopsis
        $This.Inputs = '[Autotask.{0}[]]. This function takes objects as input. Pipeline is supported.' -F $EntityName
        $This.Outputs = 'Nothing. This fuction just deletes the Autotask.{0} that was passed to the function.' -F $EntityName
        $This.Examples = '{0}  [-ParameterName] [Parameter value]' -F $FunctionName          
        $This.DefaultParameterSetName = 'Input_Object'
      }
      'Get' 
      {
        $This.Synopsis = 'This function get one or more {0} through the Autotask Web Services API.' -F $EntityName
        $This.Description = "This function creates a query based on any parameters you give and returns any resulting objects from the Autotask Web Services Api. By default the function returns any objects with properties that are Equal (-eq) to the value of the parameter. To give you more flexibility you can modify the operator by using -NotEquals [ParameterName[]], -LessThan [ParameterName[]] and so on.`n`nPossible operators for all parameters are:`n -NotEquals`n -GreaterThan`n -GreaterThanOrEqual`n -LessThan`n -LessThanOrEquals `n`nAdditional operators for [String] parameters are:`n -Like (supports * or % as wildcards)`n -NotLike`n -BeginsWith`n -EndsWith`n -Contains" 
        $This.Inputs = 'Nothing. This function only takes parameters.'
        $This.Outputs = '[Autotask.{0}[]]. This function outputs the Autotask.{1} that was returned by the API.' -F $EntityName, $EntityName
        $This.Examples = "{0}  -Parameter1 [Parameter1 value] -Parameter2 [Parameter2 Value] -GreaterThan Parameter2`nReturns all objects where a property by name of ""Parameter1"" is equal to [Parameter1 value] and where a property by name of ""Parameter2"" is greater than [Parameter2 Value]." -F $FunctionName
        $This.DefaultParameterSetName = 'Filter'
      }
      'Set' 
      {
        $This.Synopsis = 'This function sets parameters on the {0} specified by the -InputObject parameter through the Autotask Web Services API.' -F $EntityName
        $This.Description = 'This function one or more objects of type [Autotask.{0}] as input. You can pipe the objects to the function or pass them using the -InputObject parameter. You specify the property you want to set and the value you want to set it to using parameters. The function modifies all objects and updates the online
        data through the Autotask Web Services API.' -F $EntityName
        $This.Inputs = '[Autotask.{0}[]]. This function takes objects as input. Pipeline is supported.' -F $EntityName
        $This.Outputs = 'Nothing or [Autotask.{0}]. This function optionally returns the updated objects if you use the -PassThru parameter.' -F $EntityName, $EntityName
        $This.Examples = '{0}  [-ParameterName] [Parameter value]' -F $FunctionName          
        $This.DefaultParameterSetName = 'InputObject'
      }
    }
  }
  [String]ToString()
  {
    $Text = @"
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function {0}
{
  <#
      .SYNOPSIS
      {1}
      .DESCRIPTION
      {2}
      .INPUTS
      {3}
      .OUTPUTS
      {4}
      .EXAMPLE
      {5}
      For parameters, use Get-Help {6}
      .NOTES
      NAME: {7}
  #>

"@ -f $This.FunctionName, $This.Synopsis, $This.Description, $This.Inputs, $This.Outputs, $This.Examples, $This.FunctionName, $This.FunctionName
  Return $Text
  }
}