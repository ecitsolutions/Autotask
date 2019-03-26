#Requires -Version 4.0
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Set-TimeEntry
{


<#
.SYNOPSIS
This function sets parameters on the TimeEntry specified by the -InputObject parameter or pipeline through the use of the Autotask Web Services API. Any property of the TimeEntry that is not marked as READ ONLY by Autotask can be speficied with a parameter. You can specify multiple paramters.
.DESCRIPTION
This function one or more objects of type [Autotask.TimeEntry] as input. You can pipe the objects to the function or pass them using the -InputObject parameter. You specify the property you want to set and the value you want to set it to using parameters. The function modifies all objects and updates the online data through the Autotask Web Services API. The function supports all properties of an [Autotask.TimeEntry] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values.

Entities that have fields that refer to the base entity of this CmdLet:

BillingItem
 BillingItemApprovalLevel
 NotificationHistory

.INPUTS
[Autotask.TimeEntry[]]. This function takes one or more objects as input. Pipeline is supported.
.OUTPUTS
Nothing or [Autotask.TimeEntry]. This function optionally returns the updated objects if you use the -PassThru parameter.
.EXAMPLE
Set-TimeEntry -InputObject $TimeEntry [-ParameterName] [Parameter value]
Passes one or more [Autotask.TimeEntry] object(s) as a variable to the function and sets the property by name 'ParameterName' on ALL the objects before they are passed to the Autotask Web Service API and updated.
 .EXAMPLE
$TimeEntry | Set-TimeEntry -ParameterName <Parameter value>
Same as the first example, but now the objects are passed to the funtion through the pipeline, not passed as a parameter. The end result is identical.
 .EXAMPLE
Get-TimeEntry -Id 0 | Set-TimeEntry -ParameterName <Parameter value>
Gets the instance with Id 0 directly from the Web Services API, modifies a parameter and updates Autotask. This approach works with all valid parameters for the Get function.
 .EXAMPLE
Get-TimeEntry -Id 0,4,8 | Set-TimeEntry -ParameterName <Parameter value>
Gets multiple instances by Id, modifies them all and updates Autotask.
 .EXAMPLE
$Result = Get-TimeEntry -Id 0,4,8 | Set-TimeEntry -ParameterName <Parameter value> -PassThru
Gets multiple instances by Id, modifies them all, updates Autotask and returns the updated objects.

.LINK
New-TimeEntry
 .LINK
Get-TimeEntry

#>

  [CmdLetBinding(DefaultParameterSetName='InputObject', ConfirmImpact='Medium')]
  Param
  (
# An object that will be modified by any parameters and updated in Autotask
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.TimeEntry[]]
    $InputObject,

# The object.ids of objects that should be modified by any parameters and updated in Autotask
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int[]]
    $Id,

# Return any updated objects through the pipeline
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Switch]
    $PassThru,

# Task ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $TaskID,

# Ticket ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $TicketID,

# Internal Allocation Code ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $InternalAllocationCodeID,

# Date
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $DateWorked,

# Start Date Time
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $StartDateTime,

# End Date Time
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $EndDateTime,

# Hours Worked
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $HoursWorked,

# Offset Hours
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $OffsetHours,

# Summary Notes
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,8000)]
    [string]
    $SummaryNotes,

# Internal Notes
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,8000)]
    [string]
    $InternalNotes,

# Role ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $RoleID,

# Resource ID
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $ResourceID,

# Allocation Code ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $AllocationCodeID,

# Contract ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $ContractID,

# Show On Invoice
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean]
    $ShowOnInvoice,

# Non-Billable
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean]
    $NonBillable,

# Billing Approval Resource ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $BillingApprovalResourceID,

# Billing Approval Date Time
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $BillingApprovalDateTime,

# Contract Service ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long]
    $ContractServiceID,

# Contract Service Bundle ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long]
    $ContractServiceBundleID
  )
 
  Begin
  { 
    $EntityName = 'TimeEntry'
    
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
        
    # Set up TimeZone offset handling
    If (-not($script:ESToffset))
    {
      $Now = Get-Date
      $ESTzone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Eastern Standard Time")
      $ESTtime = [System.TimeZoneInfo]::ConvertTimeFromUtc($Now.ToUniversalTime(), $ESTzone)

      $script:ESToffset = (New-TimeSpan -Start $ESTtime -End $Now).TotalHours
    }
    
    # Collect fresh copies of InputObject if passed any IDs
    If ($Id.Count -gt 0 -and $Id.Count -le 200) {
      $Filter = 'Id -eq {0}' -F ($Id -join ' -or Id -eq ')
      $InputObject = Get-AtwsData -Entity $EntityName -Filter $Filter
    }
    ElseIf ($Id.Count -gt 200) {
      Throw [ApplicationException] 'Too many objects, the module can process a maximum of 200 objects when using the Id parameter.'
    }
  }

  Process
  {
    $Fields = Get-FieldInfo -Entity $EntityName

    Foreach ($Parameter in $PSBoundParameters.GetEnumerator())
    {
      $Field = $Fields | Where-Object {$_.Name -eq $Parameter.Key}
      If ($Field -or $Parameter.Key -eq 'UserDefinedFields')
      { 
        If ($Field.IsPickList)
        {
          $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $Parameter.Value}
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
        Foreach ($Object in $InputObject) 
        { 
          $Object.$($Parameter.Key) = $Value
        }
      }
    }
   
    $ModifiedObjects = Set-AtwsData -Entity $InputObject

  }

  End
  {
    Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    
    If ($PassThru.IsPresent)
    {
      # Datetimeparameters
      $DateTimeParams = $Fields.Where({$_.Type -eq 'datetime'}).Name
    
      # Expand UDFs by default
      Foreach ($Item in $ModifiedObjects)
      {
        # Any userdefined fields?
        If ($Item.UserDefinedFields.Count -gt 0)
        { 
          # Expand User defined fields for easy filtering of collections and readability
          Foreach ($UDF in $Item.UserDefinedFields)
          {
            # Make names you HAVE TO escape...
            $UDFName = '#{0}' -F $UDF.Name
            Add-Member -InputObject $Item -MemberType NoteProperty -Name $UDFName -Value $UDF.Value
          }  
        }
      
        # Adjust TimeZone on all DateTime properties
        Foreach ($DateTimeParam in $DateTimeParams) {
      
          # Get the datetime value
          $ParameterValue = $Item.$DateTimeParam
                
          # Skip if parameter is empty
          If (-not ($ParameterValue)) {
            Continue
          }
          
          $TimePresent = $ParameterValue.Hour -gt 0 -or $ParameterValue.Minute -gt 0 -or $ParameterValue.Second -gt 0 -or $ParameterValue.Millisecond -gt 0 
          
          # If this is a DATE it should not be touched
          If ($DateTimeParam -like "*DateTime" -or $TimePresent) {

              # This is DATETIME 
              # We need to adjust the timezone difference 

              # Yes, you really have to ADD the difference
              $ParameterValue = $ParameterValue.AddHours($script:ESToffset)
            
              # Store the value back to the object (not the API!)
              $Item.$DateTimeParam = $ParameterValue
          }
        }
      }
      
      Return $ModifiedObjects
    }
  }


}
