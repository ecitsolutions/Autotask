Function Remove-AtwsDefinition
{ 
  Begin
  { 
    $EntityName = '#EntityName'
    
    # Lookup Verbose, WhatIf and other preferences from calling context
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState 

    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

  }

  Process
  {
    If ($Id.Count -gt 0)
    {
      $Filter = 'id -eq {0}' -F ($Id -join ' -or id -eq ')
      $InputObject = Get-AtwsData -Entity $EntityName -Filter $Filter
    }

    If ($InputObject)
    { 
      Remove-AtwsData -Entity $InputObject
    }
  }

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
  }

}