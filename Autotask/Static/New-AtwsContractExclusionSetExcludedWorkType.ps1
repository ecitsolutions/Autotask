﻿#Requires -Version 4.0
#Version 1.6.2.8
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function New-AtwsContractExclusionSetExcludedWorkType
{


<#
.SYNOPSIS
This function creates a new ContractExclusionSetExcludedWorkType through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.ContractExclusionSetExcludedWorkType] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the ContractExclusionSetExcludedWorkType with Id number 0 you could write 'New-AtwsContractExclusionSetExcludedWorkType -Id 0' or you could write 'New-AtwsContractExclusionSetExcludedWorkType -Filter {Id -eq 0}.

'New-AtwsContractExclusionSetExcludedWorkType -Id 0,4' could be written as 'New-AtwsContractExclusionSetExcludedWorkType -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new ContractExclusionSetExcludedWorkType you need the following required fields:
 -ContractExclusionSetID
 -ExcludedWorkTypeID

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.ContractExclusionSetExcludedWorkType]. This function outputs the Autotask.ContractExclusionSetExcludedWorkType that was created by the API.
.EXAMPLE
$Result = New-AtwsContractExclusionSetExcludedWorkType -ContractExclusionSetID [Value] -ExcludedWorkTypeID [Value]
Creates a new [Autotask.ContractExclusionSetExcludedWorkType] through the Web Services API and returns the new object.
 .EXAMPLE
$Result = Get-AtwsContractExclusionSetExcludedWorkType -Id 124 | New-AtwsContractExclusionSetExcludedWorkType 
Copies [Autotask.ContractExclusionSetExcludedWorkType] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsContractExclusionSetExcludedWorkType -Id 124 | New-AtwsContractExclusionSetExcludedWorkType | Set-AtwsContractExclusionSetExcludedWorkType -ParameterName <Parameter Value>
Copies [Autotask.ContractExclusionSetExcludedWorkType] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsContractExclusionSetExcludedWorkType to modify the object.
 .EXAMPLE
$Result = Get-AtwsContractExclusionSetExcludedWorkType -Id 124 | New-AtwsContractExclusionSetExcludedWorkType | Set-AtwsContractExclusionSetExcludedWorkType -ParameterName <Parameter Value> -Passthru
Copies [Autotask.ContractExclusionSetExcludedWorkType] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsContractExclusionSetExcludedWorkType to modify the object and returns the new object.

.LINK
Remove-AtwsContractExclusionSetExcludedWorkType
 .LINK
Get-AtwsContractExclusionSetExcludedWorkType

#>

  [CmdLetBinding(DefaultParameterSetName='By_parameters', ConfirmImpact='Low')]
  Param
  (
# An array of objects to create
    [Parameter(
      ParameterSetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.ContractExclusionSetExcludedWorkType[]]
    $InputObject,

# Contract Exclusion Set ID
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $ContractExclusionSetID,

# Excluded Work Type ID
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $ExcludedWorkTypeID
  )
 
  Begin
  { 
    $EntityName = 'ContractExclusionSetExcludedWorkType'
           
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
    $ProcessObject = @()
  }

  Process
  {
    $Fields = Get-AtwsFieldInfo -Entity $EntityName
    
    If ($InputObject)
    {
      Write-Verbose ('{0}: Copy Object mode: Setting ID property to zero' -F $MyInvocation.MyCommand.Name)  
      
      $CopyNo = 1

      Foreach ($Object in $InputObject) 
      { 
        # Create a new object and copy properties
        $NewObject = New-Object Autotask.$EntityName
        
        # Copy every non readonly property
        $FieldNames = $Fields.Where({$_.Name -ne 'id'}).Name
        If ($PSBoundParameters.ContainsKey('UserDefinedFields')) {
          $FieldNames += 'UserDefinedFields'
        }
        Foreach ($Field in $FieldNames)
        {
          $NewObject.$Field = $Object.$Field
        }
        If ($NewObject -is [Autotask.Ticket])
        {
          Write-Verbose ('{0}: Copy Object mode: Object is a Ticket. Title must be modified to avoid duplicate detection.' -F $MyInvocation.MyCommand.Name)  
          $Title = '{0} (Copy {1})' -F $NewObject.Title, $CopyNo
          $CopyNo++
          $NewObject.Title = $Title
        }
        $ProcessObject += $NewObject
      }   
    }
    Else
    {
      Write-Debug ('{0}: Creating empty [Autotask.{1}]' -F $MyInvocation.MyCommand.Name, $EntityName) 
      $ProcessObject += New-Object Autotask.$EntityName    
    }
    
    Foreach ($Parameter in $PSBoundParameters.GetEnumerator())
    {
      $Field = $Fields | Where-Object {$_.Name -eq $Parameter.Key}
      If ($Field -or $Parameter.Key -eq 'UserDefinedFields')
      { 
        If ($Field.IsPickList)
        {
          If($Field.PickListParentValueField)
          {
            $ParentField = $Fields.Where{$_.Name -eq $Field.PickListParentValueField}
            $ParentLabel = $PSBoundParameters.$($ParentField.Name)
            $ParentValue = $ParentField.PickListValues | Where-Object {$_.Label -eq $ParentLabel}
            $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $Parameter.Value -and $_.ParentValue -eq $ParentValue.Value}                
          }
          Else 
          { 
            $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $Parameter.Value}
          }
          $Value = $PickListValue.Value
        }
        Else
        {
          $Value = $Parameter.Value
        } 

        Foreach ($Object in $ProcessObject) 
        { 
          $Object.$($Parameter.Key) = $Value
        }
      }
    }    

    $Result = New-AtwsData -Entity $ProcessObject
  }

  End
  {
    Write-Debug ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $Result.count, $EntityName)
    Return $Result
  }

}