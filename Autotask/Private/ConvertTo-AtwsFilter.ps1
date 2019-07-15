<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md  for license information.

#>

Function ConvertTo-AtwsFilter {
  <#
      .SYNOPSIS
      This function converts a parameter set of a Get-function to a parsable approximation of a PowerShell
      filter.
      .DESCRIPTION
      This function converts a parameter set of a Get-function to a parsable approximation of a PowerShell
      filter. Due to internal scope contraints the function needs to be dot.sourced in the calling function.
      This function is not stand alone. It uses several variables that only exist in the calling scope, 
      another reason it needs to be dot.sourced. This is not best practice, but it is still by design. 
      .INPUTS
      System.Collections.Generic.Dictionary`2[System.String,System.Object]]
      .OUTPUTS
      [String[]]
      .EXAMPLE
      $Element | ConvertTo-AtwsDate -ParameterName <ParameterName>
      Converts variable $Element with must contain a single DateTime value to a string representation of the 
      Date or the DateTime, based on the parameter name.
      .NOTES
      NAME: ConvertTo-AtwsFilter
      
  #>
  [cmdletbinding()]
  Param
  (
    [Parameter(
        Mandatory = $True,
        ValueFromPipeline = $True
    )]
    [System.Collections.Generic.Dictionary`2[System.String,System.Object]]
    $BoundParameters,
    
    [Parameter(
        Mandatory = $True
    )]
    [ValidateScript({ $Script:FieldInfoCache.Keys -contains $_ })]
    [String]
    $EntityName
  )

  Begin {
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
        
    # Set up TimeZone offset handling
    If (-not($script:ESTzone)) {
      $script:ESTzone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Eastern Standard Time")
    }
    
    If (-not($script:ESToffset)) {
      $Now = Get-Date
      $ESTtime = [System.TimeZoneInfo]::ConvertTimeFromUtc($Now.ToUniversalTime(), $ESTzone)

      $script:ESToffset = (New-TimeSpan -Start $ESTtime -End $Now).TotalHours
    }
    
    [String[]]$Filter = @()
  }

  Process {
    Write-Debug ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)
      
    $Fields = Get-AtwsFieldInfo -Entity $EntityName
 
    Foreach ($Parameter in $BoundParameters.GetEnumerator()) {
      $Field = $Fields | Where-Object {$_.Name -eq $Parameter.Key}
      
      # If Parameter value is null or an empty string for string types, add name to $IsNull array
      # and continue
      If (($Field.Type -ne 'String' -and $Null -eq $Parameter.Value) -or ($Field.Type -eq 'String' -and $Parameter.Value.Length -eq 0)) {
        If ($IsNull -notcontains $Parameter.Key) { 
          $IsNull += $Parameter.Key
        }
        Continue
      }
      
      If ($Field -or $Parameter.Key -eq 'UserDefinedField') { 
        If ($Parameter.Value.Count -gt 1) {
          $Filter += '-begin'
        }
        Foreach ($ParameterValue in $Parameter.Value) {   
          $Operator = '-or'
          $ParameterName = $Parameter.Key
          If ($Field.IsPickList) {
            If ($Field.PickListParentValueField) {
              $ParentField = $Fields.Where{$_.Name -eq $Field.PickListParentValueField}
              $ParentLabel = $PSBoundParameters.$($ParentField.Name)
              $ParentValue = $ParentField.PickListValues | Where-Object {$_.Label -eq $ParentLabel}
              $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $ParameterValue -and $_.ParentValue -eq $ParentValue.Value}                
            }
            Else { 
              $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $ParameterValue}
            }
            $Value = $PickListValue.Value
          }
          ElseIf ($ParameterName -eq 'UserDefinedField') {
            $Filter += '-udf'              
            $ParameterName = $ParameterValue.Name
            $Value = $ParameterValue.Value
          }
          ElseIf ($ParameterValue.GetType().Name -eq 'DateTime')  {
            If ($ParameterValue -eq $ParameterValue.Date -and 
              $Parameter.Key -notin $GreaterThan -and 
              $Parameter.Key -notin $GreaterThanOrEquals -and 
              $Parameter.Key -notin $LessThan -and 
            $Parameter.Key -notin $LessThanOrEquals) 
            {
              # User is searching for a date, not a specific datetime
              $Filter += $ParameterName
              $Filter += '-ge'
              $Filter += ConvertTo-AtwsDate -ParameterName $ParameterName -DateTime $ParameterValue
              [Array]$LessThanOrEquals += $ParameterName
              $Value = ConvertTo-AtwsDate -ParameterName $ParameterName -DateTime $ParameterValue.AddDays(1)
            }
            Else { 
              $Value = ConvertTo-AtwsDate -ParameterName $ParameterName -DateTime $ParameterValue
            }
          }            
          Else {
            $Value = $ParameterValue
          }
          $Filter += $ParameterName
          If ($Parameter.Key -in $NotEquals) { 
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
          ElseIf ($Parameter.Key -in $Like) { 
            $Filter += '-like'
            $Value = $Value -replace '\*', '%'
          }
          ElseIf ($Parameter.Key -in $NotLike) { 
            $Filter += '-notlike'
            $Value = $Value -replace '\*', '%'
          }
          ElseIf ($Parameter.Key -in $BeginsWith)
          { $Filter += '-beginswith'}
          ElseIf ($Parameter.Key -in $EndsWith)
          { $Filter += '-endswith'}
          ElseIf ($Parameter.Key -in $Contains)
          { $Filter += '-contains'}
          ElseIf ($Parameter.Key -in $IsThisDay)
          { $Filter += '-isthisday'}
          ElseIf ($Parameter.Key -in $IsNull -and $Parameter.Key -eq 'UserDefinedField')
          {
            $Filter += '-IsNull'
            $IsNull = $IsNull.Where({$_ -ne 'UserDefinedField'})
          }
          ElseIf ($Parameter.Key -in $IsNotNull -and $Parameter.Key -eq 'UserDefinedField')
          {
            $Filter += '-IsNotNull'
            $IsNotNull = $IsNotNull.Where({$_ -ne 'UserDefinedField'})
          }
          Else
          { $Filter += '-eq'}
            
          # Add Value to expression, unless this is a UserDefinedfield AND UserDefinedField has been
          # specified for -IsNull or -IsNotNull
          If ($Filter[-1] -notin @('-IsNull','-IsNotNull'))
          {$Filter += $Value}

          If ($Parameter.Value.Count -gt 1 -and $ParameterValue -ne $Parameter.Value[-1]) {
            $Filter += $Operator
          }
          ElseIf ($Parameter.Value.Count -gt 1) {
            $Filter += '-end'
          }
            
        }
            
      }
    }
    # IsNull and IsNotNull are special. They are the only operators that does not require a value to work
    If ($IsNull.Count -gt 0) {
      If ($Filter.Count -gt 0) {
        $Filter += '-and'
      }
      Foreach ($PropertyName in $IsNull) {
        $Filter += $PropertyName
        $Filter += '-isnull'
      }
    }
    If ($IsNotNull.Count -gt 0) {
      If ($Filter.Count -gt 0) {
        $Filter += '-and'
      }
      Foreach ($PropertyName in $IsNotNull) {
        $Filter += $PropertyName
        $Filter += '-isnotnull'
      }
    }  
 
  }

  End {
    Return $Filter
  }
}