#Requires -Version 4.0
#Version 1.6.2.12
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function New-AtwsAppointment
{


<#
.SYNOPSIS
This function creates a new Appointment through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.Appointment] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the Appointment with Id number 0 you could write 'New-AtwsAppointment -Id 0' or you could write 'New-AtwsAppointment -Filter {Id -eq 0}.

'New-AtwsAppointment -Id 0,4' could be written as 'New-AtwsAppointment -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new Appointment you need the following required fields:
 -ResourceID
 -Title
 -StartDateTime
 -EndDateTime

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Appointment]. This function outputs the Autotask.Appointment that was created by the API.
.EXAMPLE
$Result = New-AtwsAppointment -ResourceID [Value] -Title [Value] -StartDateTime [Value] -EndDateTime [Value]
Creates a new [Autotask.Appointment] through the Web Services API and returns the new object.
 .EXAMPLE
$Result = Get-AtwsAppointment -Id 124 | New-AtwsAppointment 
Copies [Autotask.Appointment] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsAppointment -Id 124 | New-AtwsAppointment | Set-AtwsAppointment -ParameterName <Parameter Value>
Copies [Autotask.Appointment] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsAppointment to modify the object.
 .EXAMPLE
$Result = Get-AtwsAppointment -Id 124 | New-AtwsAppointment | Set-AtwsAppointment -ParameterName <Parameter Value> -Passthru
Copies [Autotask.Appointment] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsAppointment to modify the object and returns the new object.

.LINK
Remove-AtwsAppointment
 .LINK
Get-AtwsAppointment
 .LINK
Set-AtwsAppointment

#>

  [CmdLetBinding(SupportsShouldProcess = $True, DefaultParameterSetName='By_parameters', ConfirmImpact='Low')]
  Param
  (
# An array of objects to create
    [Parameter(
      ParameterSetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.Appointment[]]
    $InputObject,

# Resource
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $ResourceID,

# Appointment Title
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,256)]
    [string]
    $Title,

# Start Date
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $StartDateTime,

# End Date
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $EndDateTime,

# Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,8000)]
    [string]
    $Description,

# Created By
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $CreatorResourceID,

# Create Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $CreateDateTime,

# Update Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $UpdateDateTime
  )
 
  Begin
  { 
    $EntityName = 'Appointment'
           
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
     
    $Caption = $MyInvocation.MyCommand.Name
    $VerboseDescrition = '{0}: About to create {1} {2}(s). This action cannot be undone.' -F $Caption, $ProcessObject.Count, $EntityName
    $VerboseWarning = '{0}: About to create {1} {2}(s). This action may not be undoable. Do you want to continue?' -F $Caption, $ProcessObject.Count, $EntityName

    If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
      $Result = New-AtwsData -Entity $ProcessObject
    }
  }

  End
  {
    Write-Debug ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $Result.count, $EntityName)
    Return $Result
  }

}
