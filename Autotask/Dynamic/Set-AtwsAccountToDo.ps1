#Requires -Version 4.0
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Set-AtwsAccountToDo
{


<#
.SYNOPSIS
This function sets parameters on the AccountToDo specified by the -InputObject parameter or pipeline through the use of the Autotask Web Services API. Any property of the AccountToDo that is not marked as READ ONLY by Autotask can be speficied with a parameter. You can specify multiple paramters.
.DESCRIPTION
This function one or more objects of type [Autotask.AccountToDo] as input. You can pipe the objects to the function or pass them using the -InputObject parameter. You specify the property you want to set and the value you want to set it to using parameters. The function modifies all objects and updates the online data through the Autotask Web Services API. The function supports all properties of an [Autotask.AccountToDo] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values.

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
[Autotask.AccountToDo[]]. This function takes one or more objects as input. Pipeline is supported.
.OUTPUTS
Nothing or [Autotask.AccountToDo]. This function optionally returns the updated objects if you use the -PassThru parameter.
.EXAMPLE
Set-AtwsAccountToDo -InputObject $AccountToDo [-ParameterName] [Parameter value]
Passes one or more [Autotask.AccountToDo] object(s) as a variable to the function and sets the property by name 'ParameterName' on ALL the objects before they are passed to the Autotask Web Service API and updated.
 .EXAMPLE
$AccountToDo | Set-AtwsAccountToDo -ParameterName <Parameter value>
Same as the first example, but now the objects are passed to the funtion through the pipeline, not passed as a parameter. The end result is identical.
 .EXAMPLE
Get-AtwsAccountToDo -Id 0 | Set-AtwsAccountToDo -ParameterName <Parameter value>
Gets the instance with Id 0 directly from the Web Services API, modifies a parameter and updates Autotask. This approach works with all valid parameters for the Get function.
 .EXAMPLE
Get-AtwsAccountToDo -Id 0,4,8 | Set-AtwsAccountToDo -ParameterName <Parameter value>
Gets multiple instances by Id, modifies them all and updates Autotask.
 .EXAMPLE
$Result = Get-AtwsAccountToDo -Id 0,4,8 | Set-AtwsAccountToDo -ParameterName <Parameter value> -PassThru
Gets multiple instances by Id, modifies them all, updates Autotask and returns the updated objects.

.LINK
New-AtwsAccountToDo
 .LINK
Remove-AtwsAccountToDo
 .LINK
Get-AtwsAccountToDo

#>

  [CmdLetBinding(DefaultParameterSetName='InputObject', ConfirmImpact='Low')]
  Param
  (
# An object that will be modified by any parameters and updated in Autotask
    [Parameter(
      ParameterSetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.AccountToDo[]]
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

# Client
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [long]
    $AccountID,

# Contact
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long]
    $ContactID,

# Opportunity
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long]
    $OpportunityID,

# Ticket
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long]
    $TicketID,

# Contract
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long]
    $ContractID,

# Assigned To Resource
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [long]
    $AssignedToResourceID,

# Start Date Time
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $StartDateTime,

# End Date Time
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $EndDateTime,

# Action Type
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $ActionType,

# Description
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,32000)]
    [string]
    $ActivityDescription,

# Completed Date
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $CompletedDate
  )
 
  Begin
  { 
    $EntityName = 'AccountToDo'
    
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
    $Fields = Get-AtwsFieldInfo -Entity $EntityName

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
    
    # The API documentation explicitly states that you can only use the objects returned 
    # by the .create() function to get the new objects ID.
    # so to return objects with accurately represents what has been created we have to 
    # get them again by id
    
    $NewObjectFilter = 'id -eq {0}' -F ($ModifiedObjects.Id -join ' -or id -eq ')
    
    $ModifiedObjects = Get-AtwsData -Entity $EntityName -Filter $NewObjectFilter

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
