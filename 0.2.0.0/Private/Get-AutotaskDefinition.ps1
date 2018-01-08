Function Get-AutotaskDefinition
{ 
  Begin
  { 
    $EntityName = '#EntityName'

    If ($Verbose)
    {
      # Make sure the -Verbose parameter is inherited
      $VerbosePreference = 'Continue'
    }
    If (-not($global:atws.Url))
    {
      Throw [ApplicationException] 'Not connected to Autotask WebAPI. Run Connect-AutotaskWebAPI first.'
    }
    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

  }

  Process
  {
    If (-not($Filter))
    {
      $Fields = $Atws.GetFieldInfo($EntityName)
        
      Foreach ($Parameter in $PSBoundParameters.GetEnumerator())
      {
        $Field = $Fields | Where-Object {$_.Name -eq $Parameter.Key}
        If ($Field)
        { 
          If ($Parameter.Value.Count -gt 1)
          {
            $Filter += '-begin'
          }
          Foreach ($ParameterValue in $Parameter.Value)
          {   
            $Operator = '-or'
            If ($Field.IsPickList)
            {
              $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $ParameterValue}
              $Value = $PickListValue.Value
            }
            Else
            {
              $Value = $ParameterValue
            }
            $Filter += $Parameter.Key
            If ($Parameter.Key -in $NotEquals)
            { 
              $Filter += '-ne'
              $Operator = '-and'
            }
            ElseIf ($Parameter.Key -in $GreaterThan)
            { $Filter += '-gt'}
            ElseIf ($Parameter.Key -in $GreaterThanOrEqual)
            { $Filter += '-ge'}
            ElseIf ($Parameter.Key -in $LessThan)
            { $Filter += '-lt'}
            ElseIf ($Parameter.Key -in $LessThanOrEquals)
            { $Filter += '-le'}
            ElseIf ($Parameter.Key -in $Like)
            { 
              $Filter += '-like'
              $Value = $Value -replace '*','%'
            }
            ElseIf ($Parameter.Key -in $NotLike)
            { 
              $Filter += '-notlike'
              $Value = $Value -replace '*','%'
            }
            ElseIf ($Parameter.Key -in $BeginsWith)
            { $Filter += '-beginswith'}
            ElseIf ($Parameter.Key -in $EndsWith)
            { $Filter += '-endswith'}
            ElseIf ($Parameter.Key -in $Contains)
            { $Filter += '-contains'}
            Else
            { $Filter += '-eq'}
            $Filter += $Value
            If ($Parameter.Value.Count -gt 1 -and $ParameterValue -ne $Parameter.Value[-1])
            {
              $Filter += $Operator
            }
            ElseIf ($Parameter.Value.Count -gt 1)
            {
              $Filter += '-end'
            }
          }
            
        }
      }
        
    } #'NotEquals','GreaterThan','GreaterThanOrEqual','LessThan','LessThanOrEquals','Like','NotLike','BeginsWith','EndsWith

    Get-AtwsData -Entity $EntityName -Filter $Filter
  }

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
  }

}
