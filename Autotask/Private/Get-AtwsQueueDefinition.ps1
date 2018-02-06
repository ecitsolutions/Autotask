<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsQueue 
{
  <#
      .SYNOPSIS
      This function get one or more Queues from the Autotask Web Services API.
      .DESCRIPTION
      This function gets all queue names from Autotask through the Ticket fieldinfo and filters them using the parameters you specify. By default the function returns any objects with properties that are Equal (-eq) to the value of the parameter. To give you more flexibility you can modify the operator by using -NotEquals [ParameterName[]], -LessThan [ParameterName[]] and so on.

      Possible operators for all parameters are:
      -NotEquals
      -GreaterThan
      -GreaterThanOrEqual
      -LessThan
      -LessThanOrEquals 

      Additional operators for QueueName are:
      -Like (supports * as wildcard)
      -NotLike

      .INPUTS
      Nothing. This function only takes parameters.
      .OUTPUTS
      [PSCustomObject]. This function outputs Autotask queues as custom Powershell objects.
      .EXAMPLE
      Get-AtwsQueue -Id 0
      Returns the object with Id 0, if any.
      .EXAMPLE
      Get-AtwsQueue -QueueName SomeName
      Returns the object with QueueName 'SomeName', if any.
      .EXAMPLE
      Get-AtwsQueue -QueueName 'Some Name'
      Returns the object with QueueName 'Some Name', if any.
      .EXAMPLE
      Get-AtwsQueue -QueueName 'Some Name' -NotEquals QueueName
      Returns any objects with a QueueName that is NOT equal to 'Some Name', if any.
      .EXAMPLE
      Get-AtwsQueue -QueueName SomeName* -Like QueueName
      Returns any object with a TaxName that matches the simple pattern 'SomeName*'. Supported wildcards are *.
      .EXAMPLE
      Get-AtwsQueue -QueueName SomeName* -NotLike QueueName
      Returns any object with a QueueName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are *.

  #>

  [CmdLetBinding(DefaultParameterSetName = 'Filter')]
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

    # Return all objects in one query
    [Parameter(
        ParameterSetName = 'Get_all'
    )]
    [Switch]
    $All,

    # Queue ID
    [Parameter(
        ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int[]]
    $id,

    # Queue Name
    [Parameter(
        ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Alias('Name')]
    [String[]]
    $QueueName,

    # Is the queue active
    [Parameter(
        ParameterSetName = 'By_parameters'
    )]
    [Boolean]
    $Active,
    
    # Is the queue a system queue
    [Parameter(
        ParameterSetName = 'By_parameters'
    )]
    [Boolean]
    $System,
    
    [Parameter(
        ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'QueueName')]
    [String[]]
    $GreaterThan,

    [Parameter(
        ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'QueueName')]
    [String[]]
    $NotEquals,

    [Parameter(
        ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'QueueName')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
        ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'QueueName')]
    [String[]]
    $LessThan,

    [Parameter(
        ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'QueueName')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
        ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('QueueName')]
    [String[]]
    $Like,

    [Parameter(
        ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('QueueName')]
    [String[]]
    $NotLike
  )
 
  Begin { 
    $Prefix = '#Prefix'

    # Lookup Verbose, WhatIf and other preferences from calling context
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState 

    Write-Verbose -Message ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

  }

  Process {
    If ($PSCmdlet.ParameterSetName -eq 'Get_all')
    { $Filter = @('$_.id', '-ge', 0)}
    ElseIf (-not ($Filter)) 
    {
      Write-Verbose -Message ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)
      
      $Fields = @('Id', 'QueueName', 'System', 'Active')
 
      Foreach ($Parameter in $PSBoundParameters.GetEnumerator()) 
      {
        If ($Fields -contains $Parameter.Key) 
        { 
          If ($Parameter.Value.Count -gt 1) {$Filter += '('}
          Foreach ($ParameterValue in $Parameter.Value) 
          {   
            $Operator = '-or'
            $ParameterName = $Parameter.Key
            $Value = $ParameterValue
            
            $Filter += '$_.{0}' -F $ParameterName
            If ($Parameter.Key -in $NotEquals) 
            { 
              $Filter += '-ne'
              $Operator = '-and'
            }
            ElseIf ($Parameter.Key -in $GreaterThan)
            { $Filter += '-gt'}
            ElseIf ($Parameter.Key -in $GreaterThanOrEquals)
            { $Filter += '-ge'}
            ElseIf ($Parameter.Key -in $LessThan)
            { $Filter += '-lt'}
            ElseIf ($Parameter.Key -in $LessThanOrEquals)
            { $Filter += '-le'}
            ElseIf ($Parameter.Key -in $Like) {$Filter += '-like'}
            ElseIf ($Parameter.Key -in $NotLike) {$Filter += '-notlike'}
            Else
            { $Filter += '-eq'}
            $Filter += $Value
            If ($Parameter.Value.Count -gt 1 -and $ParameterValue -ne $Parameter.Value[-1]) {$Filter += $Operator}
            ElseIf ($Parameter.Value.Count -gt 1) {$Filter += ')'}
          }
        }
      }
    }
    Else {Write-Verbose -Message ('{0}: Passing -Filter raw to Get function' -F $MyInvocation.MyCommand.Name, $Result.Count)} 

    $QueueInfo = Get-AtwsFieldInfo -Entity 'Ticket' -Connection $Prefix |
    Where-Object -FilterScript {$_.Name -eq 'QueueId'} |
    Select-Object -ExpandProperty PicklistValues |
    ForEach-Object -Process {
      New-Object -TypeName PSObject -Property @{
        Id        = $_.Value
        QueueName = $_.Label
        Active    = $_.IsActive
        System    = $_.IsSystem
      }
    }
    # Convert filter to a scriptblock and pass it to Where-Object
    $FilterScript = [ScriptBlock]::Create($($Filter -join ' '))
    $Result = $QueueInfo | Where-Object -FilterScript $FilterScript 

    Write-Verbose -Message ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $Result.Count)

  }


  End {
    Write-Verbose -Message ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    If ($Result) {Return $Result}
  }
}
