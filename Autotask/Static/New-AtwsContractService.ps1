#Requires -Version 4.0
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function New-AtwsContractService
{


<#
.SYNOPSIS
This function creates a new ContractService through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.ContractService] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the ContractService with Id number 0 you could write 'New-AtwsContractService -Id 0' or you could write 'New-AtwsContractService -Filter {Id -eq 0}.

'New-AtwsContractService -Id 0,4' could be written as 'New-AtwsContractService -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new ContractService you need the following required fields:
 -ContractID
 -ServiceID

Entities that have fields that refer to the base entity of this CmdLet:

ContractCost
 ContractServiceAdjustment
 ContractServiceUnit
 InstalledProduct
 ProjectCost
 Ticket
 TicketCost
 TimeEntry

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.ContractService]. This function outputs the Autotask.ContractService that was created by the API.
.EXAMPLE
$Result = New-AtwsContractService -ContractID [Value] -ServiceID [Value]
Creates a new [Autotask.ContractService] through the Web Services API and returns the new object.
 .EXAMPLE
$Result = Get-AtwsContractService -Id 124 | New-AtwsContractService 
Copies [Autotask.ContractService] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsContractService -Id 124 | New-AtwsContractService | Set-AtwsContractService -ParameterName <Parameter Value>
Copies [Autotask.ContractService] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsContractService to modify the object.
 .EXAMPLE
$Result = Get-AtwsContractService -Id 124 | New-AtwsContractService | Set-AtwsContractService -ParameterName <Parameter Value> -Passthru
Copies [Autotask.ContractService] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsContractService to modify the object and returns the new object.

.LINK
Get-AtwsContractService
 .LINK
Set-AtwsContractService

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
    [Autotask.ContractService[]]
    $InputObject,

# Contract ID
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $ContractID,

# Service ID
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $ServiceID,

# Unit Price
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $UnitPrice,

# Adjusted Price
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $AdjustedPrice,

# Invoice Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,1000)]
    [string]
    $InvoiceDescription,

# Quote Item Id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long]
    $QuoteItemID,

# Internal Currency Unit Price
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $InternalCurrencyUnitPrice,

# Internal Currency Adjusted Price
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $InternalCurrencyAdjustedPrice,

# Internal Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,100)]
    [string]
    $InternalDescription,

# Unit Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $UnitCost
  )
 
  Begin
  { 
    $EntityName = 'ContractService'
           
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
          
          If ($Field.Name -like "*DateTime" -or $TimePresent) 
          { 
            # Yes, you really have to ADD the difference
            $Value = $Parameter.Value.AddHours($script:ESToffset)
          }  
          Else 
          {
            $Value = $Parameter.Value
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
