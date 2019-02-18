Function Set-AtwsDefinition
{ 
  Begin
  { 
    $EntityName = '#EntityName'
        
    # Lookup Verbose, WhatIf and other preferences from calling context
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState 

    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
        
    # Set up TimeZone offset handling
    If (-not($script:ESToffset))
    {
      $Now = Get-Date
      $ESTzone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Eastern Standard Time")
      $ESTtime = [System.TimeZoneInfo]::ConvertTimeFromUtc($Now.ToUniversalTime(), $ESTzone)

      $script:ESToffset = (New-TimeSpan -Start $ESTtime -End $Now).TotalHours
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
    $Fields = Get-AtwsFieldInfo -Entity $EntityName -Connection $Prefix

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
        ElseIf ($Field.Type -eq 'datetime')
        {
          # Yes, you really have to ADD the difference
          $Value = $Parameter.Value.AddHours($script:ESToffset)
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
   
    $ModifiedObjects = Set-AtwsData -Entity $InputObject

  }

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    
    If ($PassThru.IsPresent)
    {
      # Datetimeparameters
      $DateTimeParams = $Fields.Where({$_.Type -eq 'datetime'}).Name
    
      # Expand UDFs by default
      Foreach ($Item in $ModifiedObjects)
      {
        # Any userdefined fields?
        If ($Item.UserDefinedFields.Count -gt 0)
        { 
          # Expand User defined fields for easy filtering of collections and readability
          Foreach ($UDF in $Item.UserDefinedFields)
          {
            # Make names you HAVE TO escape...
            $UDFName = '#{0}' -F $UDF.Name
            Add-Member -InputObject $Item -MemberType NoteProperty -Name $UDFName -Value $UDF.Value
          }  
        }
      
        # Adjust TimeZone on all DateTime properties
        Foreach ($DateTimeParam in $DateTimeParams) {
      
          # Get the datetime value
          $ParameterValue = $Item.$DateTimeParam
                
          # Skip if parameter is empty
          If (-not ($ParameterValue)) {
            Continue
          }
        
          # If all TIME parameters are zero, then this is a DATE and should not be touched
          If ($ParameterValue.Hour -ne 0 -or 
              $ParameterValue.Minute -ne 0 -or
              $ParameterValue.Second -ne 0 -or
              $ParameterValue.Millisecond -ne 0) {

              # This is DATETIME 
              # We need to adjust the timezone difference 

              # Yes, you really have to ADD the difference
              $ParameterValue = $ParameterValue.AddHours($script:ESToffset)
            
              # Store the value back to the object (not the API!)
              $Item.$DateTimeParam = $ParameterValue
          }
        }
      }
      
      Return $ModifiedObjects
    }
  }

}
