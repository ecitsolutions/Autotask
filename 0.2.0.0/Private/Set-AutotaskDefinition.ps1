Function Set-AutotaskDefinition
{ 
  Begin
  { 
    $EntityName = '#EntityName'
    $Prefix = '#Prefix'
        
    If ($Verbose)
    {
      # Make sure the -Verbose parameter is inherited
      $VerbosePreference = 'Continue'
    }

    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

  }

  Process
  {
    $Fields = Get-AtwsFieldInfo -Entity $EntityName -Connection $Prefix

    Foreach ($Parameter in $PSBoundParameters.GetEnumerator())
    {
      $Field = $Fields | Where-Object {$_.Name -eq $Parameter.Key}
      If ($Field)
      { 
        If ($Field.IsPickList)
        {
          $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $Parameter.Value}
          $Value = $PickListValue.Value
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
   
    $ModifiedObjects = Set-AtwsData -Entity $InputObject -Connection $Prefix


  }

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    
    If ($PassThru.IsPresent)
    {
      Return $ModifiedObjects
    }
  }

}
