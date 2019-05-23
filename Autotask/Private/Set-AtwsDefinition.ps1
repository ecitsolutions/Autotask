Function Set-AtwsDefinition
{ 
  Begin
  { 
    $EntityName = '#EntityName'
    
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
        
    # Set up TimeZone offset handling
    If (-not($script:LocalToEST))
    {
      $Now = Get-Date
      $ESTzone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Eastern Standard Time")
      $ESTtime = [System.TimeZoneInfo]::ConvertTimeFromUtc($Now.ToUniversalTime(), $ESTzone)

      # Time difference in hours from localtime to API time
      $script:LocalToEST = (New-TimeSpan -Start $Now -End $ESTtime).TotalHours
    }
    
    # Collect fresh copies of InputObject if passed any IDs
    If ($Id.Count -gt 0 -and $Id.Count -le 200) {
      $Filter = 'Id -eq {0}' -F ($Id -join ' -or Id -eq ')
      $InputObject = Get-AtwsData -Entity $EntityName -Filter $Filter
    }
    ElseIf ($Id.Count -gt 200) {
      Throw [ApplicationException] 'Too many objects, the module can process a maximum of 200 objects when using the Id parameter.'
    }
  }

  Process
  {
    $Fields = Get-AtwsFieldInfo -Entity $EntityName
    
    # Loop through parameters and update any inputobjects with the given parameter values    
    Foreach ($Parameter in $PSBoundParameters.GetEnumerator())
    {
      $Field = $Fields | Where-Object {$_.Name -eq $Parameter.Key}
      If ($Field -or $Parameter.Key -eq 'UserDefinedFields')
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
    
    # Normalize dates, i.e. set them to CEST. The .Update() method of the API reads all datetime fields as CEST
    # We can safely ignore readonly fields, even if we have modified them previously. The API ignores them.
    $DateTimeParams = $Fields.Where({$_.Type -eq 'datetime' -and -not $_.IsReadOnly}).Name
    
    # Do Picklists more human readable
    $Picklists = $Fields.Where{$_.IsPickList}
    
    # Adjust TimeZone on all DateTime properties
    Foreach ($Object in $InputObject) 
    { 
      Foreach ($DateTimeParam in $DateTimeParams) {
      
        # Get the datetime value
        $Value = $Object.$DateTimeParam
                
        # Skip if parameter is empty
        If (-not ($Value)) {
          Continue
        }
        # Convert the datetime back to CEST
        $Object.$DateTimeParam = $Value.AddHours($script:LocalToEST)
      }
      
      # Revert picklist labels to their values
      Foreach ($Field in $Picklists)
      {
        If ($Object.$($Field.Name) -in $Field.PicklistValues.Label) {
          $Object.$($Field.Name) = ($Field.PickListValues.Where{$_.Label -eq $Object.$($Field.Name)}).Value
        }
      }
    }
    
    $ModifiedObjects = Set-AtwsData -Entity $InputObject
    
    # Revert changes back on any inputobject
    Foreach ($Object in $InputObject) 
    { 
      Foreach ($DateTimeParam in $DateTimeParams) {
      
        # Get the datetime value
        $Value = $Object.$DateTimeParam
                
        # Skip if parameter is empty
        If (-not ($Value)) {
          Continue
        }
        # Revert the datetime back from CEST
        $Object.$DateTimeParam = $Value.AddHours($script:LocalToEST * -1)
      }
      
      If ($Script:UsePickListLabels) { 
        # Restore picklist labels
        Foreach ($Field in $Picklists)
        {
          If ($Object.$($Field.Name) -in $Field.PicklistValues.Value) {
            $Object.$($Field.Name) = ($Field.PickListValues.Where{$_.Value -eq $Object.$($Field.Name)}).Label
          }
        }
      }
    }
    
  }

  End
  {
    Write-Debug ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $ModifiedObjects.count, $EntityName)
    If ($PassThru.IsPresent) { 
      Return $ModifiedObjects
    }
  }
}
