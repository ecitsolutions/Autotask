#Requires -Version 4.0
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function New-AtwsProject
{


<#
.SYNOPSIS
This function creates a new Project through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.Project] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the Project with Id number 0 you could write 'New-AtwsProject -Id 0' or you could write 'New-AtwsProject -Filter {Id -eq 0}.

'New-AtwsProject -Id 0,4' could be written as 'New-AtwsProject -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new Project you need the following required fields:
 -ProjectName
 -AccountID
 -Type
 -StartDateTime
 -EndDateTime
 -Status

Entities that have fields that refer to the base entity of this CmdLet:

BillingItem
 ExpenseItem
 NotificationHistory
 Phase
 ProjectCost
 ProjectNote
 PurchaseOrderItem
 Quote
 Task
 Ticket

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Project]. This function outputs the Autotask.Project that was created by the API.
.EXAMPLE
$Result = New-AtwsProject -ProjectName [Value] -AccountID [Value] -Type [Value] -StartDateTime [Value] -EndDateTime [Value] -Status [Value]
Creates a new [Autotask.Project] through the Web Services API and returns the new object.
 .EXAMPLE
$Result = Get-AtwsProject -Id 124 | New-AtwsProject 
Copies [Autotask.Project] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsProject -Id 124 | New-AtwsProject | Set-AtwsProject -ParameterName <Parameter Value>
Copies [Autotask.Project] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsProject to modify the object.
 .EXAMPLE
$Result = Get-AtwsProject -Id 124 | New-AtwsProject | Set-AtwsProject -ParameterName <Parameter Value> -Passthru
Copies [Autotask.Project] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsProject to modify the object and returns the new object.

.LINK
Get-AtwsProject
 .LINK
Set-AtwsProject

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
    [Autotask.Project[]]
    $InputObject,

# Project Name
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [Alias('Name')]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1,100)]
    [string]
    $ProjectName,

# Account ID
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $AccountID,

# Type
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $Type,

# Ext Project Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $ExtProjectType,

# Ext Project Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string]
    $ExtPNumber,

# Project Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string]
    $ProjectNumber,

# Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,2000)]
    [string]
    $Description,

# Created DateTime
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $CreateDateTime,

# Created By
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $CreatorResourceID,

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

# Duration
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $Duration,

# Actual Hours
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [float]
    $ActualHours,

# Actual Billed Hours
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [float]
    $ActualBilledHours,

# Estimated Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [float]
    $EstimatedTime,

# Labor Estimated Revenue
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [float]
    $LaborEstimatedRevenue,

# Labor Estimated Costs
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [float]
    $LaborEstimatedCosts,

# Labor Estimated Margin Percentage
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [float]
    $LaborEstimatedMarginPercentage,

# Project Cost Revenue
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [float]
    $ProjectCostsRevenue,

# Project Estimated costs
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [float]
    $ProjectCostsBudget,

# Project Cost Estimated Margin Percentage
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [float]
    $ProjectCostEstimatedMarginPercentage,

# Change Orders Revenue
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [float]
    $ChangeOrdersRevenue,

# Changed Orders
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [float]
    $ChangeOrdersBudget,

# SG&A
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [float]
    $SGDA,

# Original Estimated Revenue
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [float]
    $OriginalEstimatedRevenue,

# Estimated Sales Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [float]
    $EstimatedSalesCost,

# Status
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $Status,

# Contract
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $ContractID,

# Project Lead
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $ProjectLeadResourceID,

# Account Owner
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $CompanyOwnerResourceID,

# Completed Percentage
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $CompletedPercentage,

# Completed date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $CompletedDateTime,

# Status Detail
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,2000)]
    [string]
    $StatusDetail,

# Status Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $StatusDateTime,

# Department
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $Department,

# Line Of Business
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $LineOfBusiness,

# purchase_order_number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string]
    $PurchaseOrderNumber,

# Business Division Subdivision ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $BusinessDivisionSubdivisionID,

# Last Activity By
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $LastActivityResourceID,

# Last Activity Date Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $LastActivityDateTime,

# Last Activity Person Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $LastActivityPersonType
  )
 
  Begin
  { 
    $EntityName = 'Project'
           
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
