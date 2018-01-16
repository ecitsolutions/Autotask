Function Remove-AtwsDefinition
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
    If ($Id.Count -gt 0)
    {
      $Filter = 'id -eq {0}' -F ($Id -join ' -or id -eq ')
      $InputObject = Get-AtwsData -Entity $EntityName -Filter $Filter
    }

    If ($InputObject)
    { 
      Remove-AtwsData -Entity $InputObject -Connection $Prefix
    }
  }

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
  }

}