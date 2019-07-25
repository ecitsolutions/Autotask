#Requires -Version 4.0
#Version 1.6.2.17
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsServiceCall
{


<#
.SYNOPSIS
This function get one or more ServiceCall through the Autotask Web Services API.
.DESCRIPTION
This function creates a query based on any parameters you give and returns any resulting objects from the Autotask Web Services Api. By default the function returns any objects with properties that are Equal (-eq) to the value of the parameter. To give you more flexibility you can modify the operator by using -NotEquals [ParameterName[]], -LessThan [ParameterName[]] and so on.

Possible operators for all parameters are:
 -NotEquals
 -GreaterThan
 -GreaterThanOrEqual
 -LessThan
 -LessThanOrEquals 

Additional operators for [String] parameters are:
 -Like (supports * or % as wildcards)
 -NotLike
 -BeginsWith
 -EndsWith
 -Contains

Properties with picklists are:

Status
 

Entities that have fields that refer to the base entity of this CmdLet:

ServiceCallTask
 ServiceCallTicket

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.ServiceCall[]]. This function outputs the Autotask.ServiceCall that was returned by the API.
.EXAMPLE
Get-AtwsServiceCall -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsServiceCall -ServiceCallName SomeName
Returns the object with ServiceCallName 'SomeName', if any.
 .EXAMPLE
Get-AtwsServiceCall -ServiceCallName 'Some Name'
Returns the object with ServiceCallName 'Some Name', if any.
 .EXAMPLE
Get-AtwsServiceCall -ServiceCallName 'Some Name' -NotEquals ServiceCallName
Returns any objects with a ServiceCallName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsServiceCall -ServiceCallName SomeName* -Like ServiceCallName
Returns any object with a ServiceCallName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsServiceCall -ServiceCallName SomeName* -NotLike ServiceCallName
Returns any object with a ServiceCallName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsServiceCall -S <PickList Label>
Returns any ServiceCalls with property S equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsServiceCall -S <PickList Label> -NotEquals S 
Returns any ServiceCalls with property S NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsServiceCall -S <PickList Label1>, <PickList Label2>
Returns any ServiceCalls with property S equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsServiceCall -S <PickList Label1>, <PickList Label2> -NotEquals S
Returns any ServiceCalls with property S NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsServiceCall -Id 1234 -ServiceCallName SomeName* -S <PickList Label1>, <PickList Label2> -Like ServiceCallName -NotEquals S -GreaterThan Id
An example of a more complex query. This command returns any ServiceCalls with Id GREATER THAN 1234, a ServiceCallName that matches the simple pattern SomeName* AND that has a S that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsServiceCall
 .LINK
Remove-AtwsServiceCall
 .LINK
Set-AtwsServiceCall

#>

  [CmdLetBinding(SupportsShouldProcess = $True, DefaultParameterSetName='Filter', ConfirmImpact='None')]
  Param
  (
# A filter that limits the number of objects that is returned from the API
    [Parameter(
      Mandatory = $true,
      ValueFromRemainingArguments = $true,
      ParameterSetName = 'Filter'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $Filter,

# Follow this external ID and return any external objects
    [Parameter(
      ParameterSetName = 'Filter'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Alias('GetRef')]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('AccountID', 'AccountPhysicalLocationID')]
    [String]
    $GetReferenceEntityById,

# Return entities of selected type that are referencing to this entity.
    [Parameter(
      ParameterSetName = 'Filter'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Alias('External')]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('ServiceCallTask:ServiceCallID', 'ServiceCallTicket:ServiceCallID')]
    [String]
    $GetExternalEntityByThisEntityId,

# Return all objects in one query
    [Parameter(
      ParameterSetName = 'Get_all'
    )]
    [Switch]
    $All,

# Do not add descriptions for all picklist attributes with values
    [Parameter(
      ParameterSetName = 'Filter'
    )]
    [Parameter(
      ParameterSetName = 'Get_all'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Switch]
    $NoPickListLabel,

# Service Call ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Client ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $AccountID,

# Start Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $StartDateTime,

# End Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $EndDateTime,

# Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string[]]
    $Description,

# Complete
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int16][]]
    $Complete,

# Created By
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CreatorResourceID,

# Create Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CreateDateTime,

# Last Modified Date Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LastModifiedDateTime,

# Duration
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $Duration,

# Status
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $Status,

# Canceled By
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CanceledByResource,

# Canceled Date Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CanceledDateTime,

# Cancelation Notice Hours
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $CancelationNoticeHours,

# Account Physical Location
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $AccountPhysicalLocationID,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'StartDateTime', 'EndDateTime', 'Description', 'Complete', 'CreatorResourceID', 'CreateDateTime', 'LastModifiedDateTime', 'Duration', 'Status', 'CanceledByResource', 'CanceledDateTime', 'CancelationNoticeHours', 'AccountPhysicalLocationID')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'StartDateTime', 'EndDateTime', 'Description', 'Complete', 'CreatorResourceID', 'CreateDateTime', 'LastModifiedDateTime', 'Duration', 'Status', 'CanceledByResource', 'CanceledDateTime', 'CancelationNoticeHours', 'AccountPhysicalLocationID')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'StartDateTime', 'EndDateTime', 'Description', 'Complete', 'CreatorResourceID', 'CreateDateTime', 'LastModifiedDateTime', 'Duration', 'Status', 'CanceledByResource', 'CanceledDateTime', 'CancelationNoticeHours', 'AccountPhysicalLocationID')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'StartDateTime', 'EndDateTime', 'Description', 'Complete', 'CreatorResourceID', 'CreateDateTime', 'LastModifiedDateTime', 'Duration', 'Status', 'CanceledByResource', 'CanceledDateTime', 'CancelationNoticeHours', 'AccountPhysicalLocationID')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'StartDateTime', 'EndDateTime', 'Description', 'Complete', 'CreatorResourceID', 'CreateDateTime', 'LastModifiedDateTime', 'Duration', 'Status', 'CanceledByResource', 'CanceledDateTime', 'CancelationNoticeHours', 'AccountPhysicalLocationID')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'StartDateTime', 'EndDateTime', 'Description', 'Complete', 'CreatorResourceID', 'CreateDateTime', 'LastModifiedDateTime', 'Duration', 'Status', 'CanceledByResource', 'CanceledDateTime', 'CancelationNoticeHours', 'AccountPhysicalLocationID')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'AccountID', 'StartDateTime', 'EndDateTime', 'Description', 'Complete', 'CreatorResourceID', 'CreateDateTime', 'LastModifiedDateTime', 'Duration', 'Status', 'CanceledByResource', 'CanceledDateTime', 'CancelationNoticeHours', 'AccountPhysicalLocationID')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Description')]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('StartDateTime', 'EndDateTime', 'CreateDateTime', 'LastModifiedDateTime', 'CanceledDateTime')]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'ServiceCall'
    
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
  }


  Process
  {
    If ($PSCmdlet.ParameterSetName -eq 'Get_all')
    { 
      $Filter = @('id', '-ge', 0)
    }
    ElseIf (-not ($Filter)) {
    
      Write-Debug ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)
      
      # Convert named parameters to a filter definition that can be parsed to QueryXML
      $Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $EntityName
    }
    Else {
      
      Write-Debug ('{0}: Query based on manual filter, parsing' -F $MyInvocation.MyCommand.Name)
              
      $Filter = . Update-AtwsFilter -FilterString $Filter
    } 

    $Caption = $MyInvocation.MyCommand.Name
    $VerboseDescrition = '{0}: About to query the Autotask Web API for {1}(s).' -F $Caption, $EntityName
    $VerboseWarning = '{0}: About to query the Autotask Web API for {1}(s). Do you want to continue?' -F $Caption, $EntityName
    
    If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
    
      # Make the query and pass the optional parameters to Get-AtwsData
      $Result = Get-AtwsData -Entity $EntityName -Filter $Filter `
        -NoPickListLabel:$NoPickListLabel.IsPresent `
        -GetReferenceEntityById $GetReferenceEntityById `
        -GetExternalEntityByThisEntityId $GetExternalEntityByThisEntityId
    
      Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $Result.Count)

    }
  }

  End
  {
    Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    If ($Result)
    {
      Return $Result
    }
  }


}
