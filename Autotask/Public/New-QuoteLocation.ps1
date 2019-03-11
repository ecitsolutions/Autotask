<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function New-QuoteLocation
{


<#
.SYNOPSIS
This function creates a new QuoteLocation through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.QuoteLocation] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the QuoteLocation with Id number 0 you could write 'New-QuoteLocation -Id 0' or you could write 'New-QuoteLocation -Filter {Id -eq 0}.

'New-QuoteLocation -Id 0,4' could be written as 'New-QuoteLocation -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new QuoteLocation you need the following required fields:
 -

Entities that have fields that refer to the base entity of this CmdLet:

Quote

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.QuoteLocation]. This function outputs the Autotask.QuoteLocation that was created by the API.
.EXAMPLE
$Result = New-QuoteLocation - [Value]
Creates a new [Autotask.QuoteLocation] through the Web Services API and returns the new object.
 .EXAMPLE
$Result = Get-QuoteLocation -Id 124 | New-QuoteLocation 
Copies [Autotask.QuoteLocation] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-QuoteLocation -Id 124 | New-QuoteLocation | Set-QuoteLocation -ParameterName <Parameter Value>
Copies [Autotask.QuoteLocation] by Id 124 to a new object through the Web Services API, passes the new object to the Set-QuoteLocation to modify the object.
 .EXAMPLE
$Result = Get-QuoteLocation -Id 124 | New-QuoteLocation | Set-QuoteLocation -ParameterName <Parameter Value> -Passthru
Copies [Autotask.QuoteLocation] by Id 124 to a new object through the Web Services API, passes the new object to the Set-QuoteLocation to modify the object and returns the new object.

.LINK
Get-QuoteLocation
 .LINK
Set-QuoteLocation

#>

  [CmdLetBinding(DefaultParameterSetName='By_parameters', ConfirmImpact='Medium')]
  Param
  (
# An array of objects to create
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.QuoteLocation[]]
    $InputObject,

# address_1
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string]
    $Address1,

# address_2
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string]
    $Address2,

# city
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string]
    $City,

# state_province
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string]
    $State,

# postal_code
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,20)]
    [string]
    $PostalCode
  )
 
  Begin
  { 
    $EntityName = 'QuoteLocation'
           
    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
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
    $Fields = Get-FieldInfo -Entity $EntityName
    
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
      Write-Verbose ('{0}: Creating empty [Autotask.{1}]' -F $MyInvocation.MyCommand.Name, $EntityName) 
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
          # Yes, you really have to ADD the difference
          $Value = $Parameter.Value.AddHours($script:ESToffset)
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
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

    If ($PSCmdLet.ParameterSetName -eq 'Input_Object')
    {
      # Verify copy mode
      Foreach ($Object in $Result)
      {
        If ($InputObject.Id -contains $Object.Id)
        {
          Write-Verbose ('{0}: Autotask detected new object as duplicate of {1} with Id {2} and tried to update object, not create a new copy. ' -F $MyInvocation.MyCommand.Name, $EntityName, $Object.Id)
        }
      }
    }

    Return $Result
  }


}
