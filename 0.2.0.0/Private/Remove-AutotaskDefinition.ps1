Function Remove-AutotaskDefinition
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