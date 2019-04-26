#Requires -Version 4.0
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function New-AtwsTimeEntry
{


<#
.SYNOPSIS
This function creates a new TimeEntry through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.TimeEntry] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the TimeEntry with Id number 0 you could write 'New-AtwsTimeEntry -Id 0' or you could write 'New-AtwsTimeEntry -Filter {Id -eq 0}.

'New-AtwsTimeEntry -Id 0,4' could be written as 'New-AtwsTimeEntry -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new TimeEntry you need the following required fields:
 -DateWorked
 -ResourceID

Entities that have fields that refer to the base entity of this CmdLet:

BillingItem
 BillingItemApprovalLevel
 NotificationHistory

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.TimeEntry]. This function outputs the Autotask.TimeEntry that was created by the API.
.EXAMPLE
$Result = New-AtwsTimeEntry -DateWorked [Value] -ResourceID [Value]
Creates a new [Autotask.TimeEntry] through the Web Services API and returns the new object.
 .EXAMPLE
$Result = Get-AtwsTimeEntry -Id 124 | New-AtwsTimeEntry 
Copies [Autotask.TimeEntry] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsTimeEntry -Id 124 | New-AtwsTimeEntry | Set-AtwsTimeEntry -ParameterName <Parameter Value>
Copies [Autotask.TimeEntry] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsTimeEntry to modify the object.
 .EXAMPLE
$Result = Get-AtwsTimeEntry -Id 124 | New-AtwsTimeEntry | Set-AtwsTimeEntry -ParameterName <Parameter Value> -Passthru
Copies [Autotask.TimeEntry] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsTimeEntry to modify the object and returns the new object.

.LINK
Remove-AtwsTimeEntry
 .LINK
Get-AtwsTimeEntry
 .LINK
Set-AtwsTimeEntry

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
    [Autotask.TimeEntry[]]
    $InputObject,

# Task ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $TaskID,

# Ticket ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $TicketID,

# Internal Allocation Code ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $InternalAllocationCodeID,

# TaskTypeLink
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $Type,

# Date
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $DateWorked,

# Start Date Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $StartDateTime,

# End Date Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $EndDateTime,

# Hours Worked
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $HoursWorked,

# Hours To Bill
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $HoursToBill,

# Offset Hours
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $OffsetHours,

# Summary Notes
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,8000)]
    [string]
    $SummaryNotes,

# Internal Notes
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,8000)]
    [string]
    $InternalNotes,

# Role ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $RoleID,

# Create Date Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $CreateDateTime,

# Resource ID
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $ResourceID,

# Created User ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $CreatorUserID,

# Last Modified By User ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $LastModifiedUserID,

# Last Modified Datetime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $LastModifiedDateTime,

# Allocation Code ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $AllocationCodeID,

# Contract ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $ContractID,

# Show On Invoice
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean]
    $ShowOnInvoice,

# Non-Billable
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean]
    $NonBillable,

# Billing Approval Level Most Recent
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $BillingApprovalLevelMostRecent,

# Billing Approval Resource ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $BillingApprovalResourceID,

# Billing Approval Date Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $BillingApprovalDateTime,

# Contract Service ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long]
    $ContractServiceID,

# Contract Service Bundle ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long]
    $ContractServiceBundleID,

# Impersonator Creator Resource ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $ImpersonatorCreatorResourceID,

# Impersonator Updater Resource ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $ImpersonatorUpdaterResourceID
  )
 
  Begin
  { 
    $EntityName = 'TimeEntry'
           
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
    
    # The API documentation explicitly states that you can only use the objects returned 
    # by the .create() function to get the new objects ID.
    # so to return objects with accurately represents what has been created we have to 
    # get them again by id
    
    $NewObjectFilter = 'id -eq {0}' -F ($Result.Id -join ' -or id -eq ')
    
    $Result = Get-AtwsData -Entity $EntityName -Filter $NewObjectFilter
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
