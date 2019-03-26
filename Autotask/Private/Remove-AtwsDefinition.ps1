Function Remove-AtwsDefinition
{ 
  Begin
  { 
    $EntityName = '#EntityName'
    
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

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
    Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
  }

}