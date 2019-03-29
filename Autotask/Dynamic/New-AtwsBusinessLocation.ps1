#Requires -Version 4.0
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function New-AtwsBusinessLocation
{


<#
.SYNOPSIS
This function creates a new BusinessLocation through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.BusinessLocation] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the BusinessLocation with Id number 0 you could write 'New-AtwsBusinessLocation -Id 0' or you could write 'New-AtwsBusinessLocation -Filter {Id -eq 0}.

'New-AtwsBusinessLocation -Id 0,4' could be written as 'New-AtwsBusinessLocation -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new BusinessLocation you need the following required fields:
 -Name
 -DateFormat
 -TimeFormat
 -NumberFormat
 -TimeZoneID

Entities that have fields that refer to the base entity of this CmdLet:

Department

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.BusinessLocation]. This function outputs the Autotask.BusinessLocation that was created by the API.
.EXAMPLE
$Result = New-AtwsBusinessLocation -Name [Value] -DateFormat [Value] -TimeFormat [Value] -NumberFormat [Value] -TimeZoneID [Value]
Creates a new [Autotask.BusinessLocation] through the Web Services API and returns the new object.
 .EXAMPLE
$Result = Get-AtwsBusinessLocation -Id 124 | New-AtwsBusinessLocation 
Copies [Autotask.BusinessLocation] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsBusinessLocation -Id 124 | New-AtwsBusinessLocation | Set-AtwsBusinessLocation -ParameterName <Parameter Value>
Copies [Autotask.BusinessLocation] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsBusinessLocation to modify the object.
 .EXAMPLE
$Result = Get-AtwsBusinessLocation -Id 124 | New-AtwsBusinessLocation | Set-AtwsBusinessLocation -ParameterName <Parameter Value> -Passthru
Copies [Autotask.BusinessLocation] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsBusinessLocation to modify the object and returns the new object.

.LINK
Get-AtwsBusinessLocation
 .LINK
Set-AtwsBusinessLocation

#>

  [CmdLetBinding(DefaultParameterSetName='By_parameters', ConfirmImpact='Medium')]
  Param
  (
# An array of objects to create
    [Parameter(
      ParameterSetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.BusinessLocation[]]
    $InputObject,

# Name
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1,100)]
    [string]
    $Name,

# Address1
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,100)]
    [string]
    $Address1,

# Address2
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,100)]
    [string]
    $Address2,

# City
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string]
    $City,

# State
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,25)]
    [string]
    $State,

# Postal Code
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,20)]
    [string]
    $PostalCode,

# Additional Address Info
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,100)]
    [string]
    $AdditionalAddressInfo,

# Country ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $CountryID,

# Holiday Set ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $HolidaySetID,

# No Hours On Holidays
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean]
    $NoHoursOnHolidays,

# Default
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean]
    $Default,

# First Day Of Week
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $FirstDayOfWeek,

# Date Format
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1,50)]
    [string]
    $DateFormat,

# Time Format
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1,50)]
    [string]
    $TimeFormat,

# Number Format
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1,50)]
    [string]
    $NumberFormat,

# Time Zone ID
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $TimeZoneID,

# SundayBusinessHoursStartTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $SundayBusinessHoursStartTime,

# SundayBusinessHoursEndTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $SundayBusinessHoursEndTime,

# SundayExtendedHoursStartTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $SundayExtendedHoursStartTime,

# SundayExtendedHoursEndTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $SundayExtendedHoursEndTime,

# MondayBusinessHoursStartTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $MondayBusinessHoursStartTime,

# MondayBusinessHoursEndTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $MondayBusinessHoursEndTime,

# MondayExtendedHoursStartTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $MondayExtendedHoursStartTime,

# MondayExtendedHoursEndTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $MondayExtendedHoursEndTime,

# TuesdayBusinessHoursStartTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $TuesdayBusinessHoursStartTime,

# TuesdayBusinessHoursEndTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $TuesdayBusinessHoursEndTime,

# TuesdayExtendedHoursStartTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $TuesdayExtendedHoursStartTime,

# TuesdayExtendedHoursEndTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $TuesdayExtendedHoursEndTime,

# WednesdayBusinessHoursStartTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $WednesdayBusinessHoursStartTime,

# WednesdayBusinessHoursEndTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $WednesdayBusinessHoursEndTime,

# WednesdayExtendedHoursStartTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $WednesdayExtendedHoursStartTime,

# WednesdayExtendedHoursEndTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $WednesdayExtendedHoursEndTime,

# ThursdayBusinessHoursStartTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $ThursdayBusinessHoursStartTime,

# ThursdayBusinessHoursEndTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $ThursdayBusinessHoursEndTime,

# ThursdayExtendedHoursStartTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $ThursdayExtendedHoursStartTime,

# ThursdayExtendedHoursEndTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $ThursdayExtendedHoursEndTime,

# FridayBusinessHoursStartTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $FridayBusinessHoursStartTime,

# FridayBusinessHoursEndTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $FridayBusinessHoursEndTime,

# FridayExtendedHoursStartTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $FridayExtendedHoursStartTime,

# FridayExtendedHoursEndTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $FridayExtendedHoursEndTime,

# SaturdayBusinessHoursStartTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $SaturdayBusinessHoursStartTime,

# SaturdayBusinessHoursEndTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $SaturdayBusinessHoursEndTime,

# SaturdayExtendedHoursStartTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $SaturdayExtendedHoursStartTime,

# SaturdayExtendedHoursEndTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $SaturdayExtendedHoursEndTime
  )
 
  Begin
  { 
    $EntityName = 'BusinessLocation'
           
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
    $ProcessObject = @()
    
    # Set up TimeZone offset handling
    If (-not($script:ESToffset))
    {
      $Now = Get-Date
      $ESTzone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Eastern Standard Time")
      $ESTtime = [System.TimeZoneInfo]::ConvertTimeFromUtc($Now.ToUniversalTime(), $ESTzone)

      $script:ESToffset = (New-TimeSpan -Start $ESTtime -End $Now).TotalHours
    }

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
        Foreach ($Field in $Fields.Where({$_.Name -ne 'id'}).Name)
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
        ElseIf ($Field.Type -eq 'datetime')
        {
          $TimePresent = $Parameter.Value.Hour -gt 0 -or $Parameter.Value.Minute -gt 0 -or $Parameter.Value.Second -gt 0 -or $Parameter.Value.Millisecond -gt 0 
          
          If ($Field.Name -like "*DateTime" -or $TimePresent) { 
            # Yes, you really have to ADD the difference
            $Value = $Parameter.Value.AddHours($script:ESToffset)
          }        
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
    Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

    If ($PSCmdLet.ParameterSetName -eq 'Input_Object')
    {
      # Verify copy mode
      Foreach ($Object in $Result)
      {
        If ($InputObject.Id -contains $Object.Id)
        {
          Write-Warning ('{0}: Autotask detected new object as duplicate of {1} with Id {2} and tried to update object, not create a new copy. ' -F $MyInvocation.MyCommand.Name, $EntityName, $Object.Id)
        }
      }
    }

    Return $Result
  }


}
