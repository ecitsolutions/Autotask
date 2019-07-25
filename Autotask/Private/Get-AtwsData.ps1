<#
    .COPYRIGHT
    Copyright (c) Office Center H�nefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>

Function Get-AtwsData 
{
  <#
      .SYNOPSIS
      This function queries the Autotask Web API for entities matching a specified type and filter.
      .DESCRIPTION
      This function queries the Autotask Web API for entities matching a specified type and filter.
      Valid operators: 
      -and, -or

      Valid comparison operators:
      -eq, -ne, -lt, -le, -gt, -ge, -isnull, -isnotnull, -isthisday

      Valid text comparison operators:
      -contains, -like, -notlike, -beginswith, -endswith, -soundslike
         
      Special operators to nest conditions: 
      -begin, -end

      .INPUTS
      Nothing.
      .OUTPUTS
      Autotask.Entity[]. One or more Autotask entities returned from Autotask Web API.
      .EXAMPLE
      Get-AtwsData -Entity Ticket -Filter {id -gt 0}
      Gets all tickets with an id greater than 0 from Autotask Web API
      .NOTES
      NAME: Get-AtwsData
      .LINK
      Set-AtwsData
      New-AtwsData
      Remove-AtwsData
  #>
  
  [cmdletbinding()]
  [OutputType([PSObject[]])]
  param
  (
    [Parameter(
        Mandatory = $True,
        Position = 0
    )]
    [String]
    $Entity,
          
    [Parameter(
        Mandatory = $True,
        ValueFromRemainingArguments = $true,
        Position = 1
    )]
    [String[]]
    $Filter,
    
    [String]
    $GetReferenceEntityById,
    
    [String]
    $GetExternalEntityByThisEntityId,
    
    [Switch]
    $NoPickListLabel
  )
  Begin
  { 
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
       
    If (-not($Script:Atws.Url))
    {
      Throw [ApplicationException] 'Not connected to Autotask WebAPI. Re-import module with valid credentials.'
    }
    
    $Result = @()
    
    # Set up TimeZone offset handling
    If (-not($script:ESTzone)) {
      $script:ESTzone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Eastern Standard Time")
    }
    
    If (-not($script:ESToffset)) {
      $Now = Get-Date
      $ESTtime = [System.TimeZoneInfo]::ConvertTimeFromUtc($Now.ToUniversalTime(), $ESTzone)

      $script:ESToffset = (New-TimeSpan -Start $ESTtime -End $Now).TotalHours
    }
  }
  
  Process
  {
    # $Filter is usually passed as a flat string. Make sure it is formatted properly
    If ($Filter.Count -eq 1 -and $Filter -match ' ' )
    { 
      $Filter = . Update-AtwsFilter -FilterString $Filter
    }
    
    # Squash into a flat array with entity first
    [Array]$Query = @($Entity) + $Filter
  
    Write-Debug ('{0}: Converting query string into QueryXml. String as array looks like: {1}' -F $MyInvocation.MyCommand.Name, $($Query -join ', '))
    [xml]$QueryXml = ConvertTo-QueryXML @Query

    Write-Debug ('{0}: QueryXml looks like: {1}' -F $MyInvocation.MyCommand.Name, $QueryXml.InnerXml.ToString())
    
    Write-Verbose ('{0}: Adding looping construct to query to handle more than 500 results.' -F $MyInvocation.MyCommand.Name)
    
    # Native XML is rather tedious...
    $field = $QueryXml.CreateElement('field')
    $expression = $QueryXml.CreateElement('expression')
    $expression.SetAttribute('op','greaterthan')
    $expression.InnerText = 0
    $field.InnerText = 'id'
    [void]$field.AppendChild($expression)
    
    $FirstPass = $True
    Do 
    {
      Write-Verbose ('{0}: Passing QueryXML to Autotask API' -F $MyInvocation.MyCommand.Name)

      # Get the first batch - the API returns max 500 items
      $lastquery = $atws.query($QueryXml.InnerXml)

      # Handle any errors
      If ($lastquery.Errors.Count -gt 0)
      {
        Foreach ($AtwsError in $lastquery.Errors)
        {
          Write-Error $AtwsError.Message
        }
        Return
      }

      # Add all returned objects to the Result
      $result += $lastquery.EntityResults

      # Results are sorted by object Id. The Id of the last object is the highest object id in the result
      $UpperBound = $lastquery.EntityResults[$lastquery.EntityResults.GetUpperBound(0)].id

      # Add the higest Id (so far) to the id -gt ? condition
      $expression.InnerText = $UpperBound

      # If this is the first pass we append the expression to the query
      If ($FirstPass)
      {
        # Insert looping construct into query
        [void]$QueryXml.queryxml.query.AppendChild($field)
        $FirstPass = $False        
      }
    }
    # The last query we have to make will have between 0 and 499 items
    Until ($lastquery.EntityResults.Count -lt 500)
     
    
    # Datetimeparameters
    $Fields = Get-AtwsFieldInfo -Entity $Entity
    $DateTimeParams = $Fields.Where({$_.Type -eq 'datetime'}).Name

    # Picklists
    $Picklists = $Fields.Where{$_.IsPickList}

    # Expand UDFs by default
    # Normalize dates (convert to local time). EVery datetime field ever returned
    # By the API is in CEST.
    Foreach ($Item in $Result)
    {
      # Any userdefined fields?
      If ($Item.UserDefinedFields.Count -gt 0)
      { 
        # Expand User defined fields for easy filtering of collections and readability
        Foreach ($UDF in $Item.UserDefinedFields)
        {
          # Make names you HAVE TO escape...
          $UDFName = '#{0}' -F $UDF.Name
          Add-Member -InputObject $Item -MemberType NoteProperty -Name $UDFName -Value $UDF.Value -Force
        }  
      }
      
      # Adjust TimeZone on all DateTime properties
      # Dates RETURNED by the API are always in CEST. Add timezone difference
      # to get local time
      Foreach ($DateTimeParam in $DateTimeParams) {
      
        # Get the datetime value
        $Value = $Item.$DateTimeParam
                
        # Skip if parameter is empty
        If (-not ($Value)) {
          Continue
        }
        # Yes, you really have to ADD the difference
        $Item.$DateTimeParam  = $Value.AddHours($script:ESToffset)
      }

      If ($Script:UsePickListLabels) { 
        # Restore picklist labels
        Foreach ($Field in $Picklists)
        {
          If ($Item.$($Field.Name) -in $Field.PicklistValues.Value) {
            $Item.$($Field.Name) = ($Field.PickListValues.Where{$_.Value -eq $Item.$($Field.Name)}).Label
          }
        }
      }
      # Do the user want labels along with index values for Picklists?      
      ElseIf (-not $NoPickListLabel.IsPresent) {
        $Value = ($Field.PickListValues.Where{$_.Value -eq $Item.$($Field.Name)}).Label
        Add-Member -InputObject $Item -MemberType NoteProperty -Name $Field.Name -Value $Value -Force
      }
    }
  }
  
  End
  { 
    # Some last minute changes
    If ($Result) { 
      # Should we return an indirect object?
      if ($GetReferenceEntityById)
      {
        Write-Debug ('{0}: User has asked for external reference objects by {1}' -F $MyInvocation.MyCommand.Name, $GetReferenceEntityById)
      
        $Field = $Fields.Where({$_.Name -eq $GetReferenceEntityById})
        $ResultValues = $Result | Where-Object {$null -ne $_.$GetReferenceEntityById}
        If ($ResultValues.Count -lt $Result.Count)
        {
          Write-Warning ('{0}: Only {1} of the {2}s in the primary query had a value in the property {3}.' -F $MyInvocation.MyCommand.Name, 
            $ResultValues.Count,
            $Entity,
          $GetReferenceEntityById) -WarningAction Continue
        }
        $Filter = 'id -eq {0}' -F $($ResultValues.$GetReferenceEntityById -join ' -or id -eq ')
        $Result = Get-Atwsdata -Entity $Field.ReferenceEntityType -Filter $Filter
      }
      ElseIf ($GetExternalEntityByThisEntityId)
      {
        Write-Debug ('{0}: User has asked for {1} that are referencing this result' -F $MyInvocation.MyCommand.Name, $GetExternalEntityByThisEntityId)
        $ReferenceInfo = $GetExternalEntityByThisEntityId -Split ':'
        $Filter = '{0} -eq {1}' -F $ReferenceInfo[1], $($Result.id -join (' -or {0}id -eq ' -F $ReferenceInfo[1]))
        $Result = Get-Atwsdata -Entity $ReferenceInfo[0] -Filter $Filter
      }

      Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
      Return $result
    }
  }
  
}