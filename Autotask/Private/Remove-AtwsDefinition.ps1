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

    Write-Verbose ('{0}: Deleting {1} object(s) from Autotask' -F $MyInvocation.MyCommand.Name, $InputObject.Count)

    If ($InputObject)
    { 
      
      $Caption = $MyInvocation.MyCommand.Name
      $VerboseDescrition = '{0}: About to delete {1} {2}(s). This action cannot be undone.' -F $Caption, $InputObject.Count, $EntityName
      $VerboseWarning = '{0}: About to delete {1} {2}(s). This action cannot be undone. Do you want to continue?' -F $Caption, $InputObject.Count, $EntityName

      If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
        Remove-AtwsData -Entity $InputObject
      }
    }
  }

  End
  {
    Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
  }

}