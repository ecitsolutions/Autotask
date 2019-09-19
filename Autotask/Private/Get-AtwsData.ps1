<#
    .COPYRIGHT
    Copyright (c) Office Center H�nefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>

Function Get-AtwsData {
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
            Mandatory = $true,
            Position = 0
        )]
        [string]
        $Entity,
          
        [Parameter(
            Mandatory = $true,
            ValueFromRemainingArguments = $true,
            Position = 1
        )]
        [string[]]
        $Filter,
    
        [string]
        $GetReferenceEntityById,
    
        [string]
        $GetExternalEntityByThisEntityId,
    
        [switch]
        $NoPickListLabel
    )

    begin { 
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
       
        if (-not($Script:Atws.Url)) {
            Throw [ApplicationException] 'Not connected to Autotask WebAPI. Re-import module with valid credentials.'
        }
    
        $result = @()
    }
  
    process {
        # $Filter is usually passed as a flat string. Make sure it is formatted properly
        if ($Filter.Count -eq 1 -and $Filter -match ' ' ) { 
            $Filter = . Update-AtwsFilter -Filterstring $Filter
        }
    
        # Squash into a flat array with entity first
        [Array]$Query = @($Entity) + $Filter
  
        Write-Verbose ('{0}: Converting query string into QueryXml. string as array looks like: {1}' -F $MyInvocation.MyCommand.Name, $($Query -join ', '))
        [xml]$QueryXml = ConvertTo-QueryXML @Query

        Write-Debug ('{0}: QueryXml looks like: {1}' -F $MyInvocation.MyCommand.Name, $QueryXml.InnerXml.Tostring())
    
        Write-Verbose ('{0}: Adding looping construct to query to handle more than 500 results.' -F $MyInvocation.MyCommand.Name)
    
        # Native XML is rather tedious...
        $field = $QueryXml.CreateElement('field')
        $expression = $QueryXml.CreateElement('expression')
        $expression.SetAttribute('op', 'greaterthan')
        $expression.InnerText = 0
        $field.InnerText = 'id'
        [void]$field.AppendChild($expression)
    
        $FirstPass = $true
        Do {
            Write-Verbose ('{0}: Passing QueryXML to Autotask API' -F $MyInvocation.MyCommand.Name)

            # Get the first batch - the API returns max 500 items
            $lastquery = $Script:Atws.query($QueryXml.InnerXml)

            # Handle any errors
            if ($lastquery.Errors.Count -gt 0) {
                foreach ($atwsError in $lastquery.Errors) {
                    Write-Error $atwsError.Message
                }
                return
            }

            # Add all returned objects to the Result - if any
            if ($lastquery.EntityResults.Count -gt 0) { 
                $result += ConvertTo-LocalObject -InputObject $lastquery.EntityResults -NoPickListLabel:$NoPickListLabel.IsPresent
            }
            
            # Results are sorted by object Id. The Id of the last object is the highest object id in the result
            $upperBound = $lastquery.EntityResults[$lastquery.EntityResults.GetUpperBound(0)].id

            # Add the higest Id (so far) to the id -gt ? condition
            $expression.InnerText = $upperBound

            # If this is the first pass we append the expression to the query
            if ($FirstPass) {
                # Insert looping construct into query
                [void]$QueryXml.queryxml.query.AppendChild($field)
                $FirstPass = $false        
            }
        }
        # The last query we have to make will have between 0 and 499 items
        Until ($lastquery.EntityResults.Count -lt 500)
     
    }
  
    end { 
        # Some last minute changes
        if ($result) { 
            # Should we return an indirect object?
            if ($GetReferenceEntityById) {
                Write-Verbose ('{0}: User has asked for external reference objects by {1}' -F $MyInvocation.MyCommand.Name, $GetReferenceEntityById)
                $fields = Get-AtwsFieldInfo -Entity $result[0].GetType().Name
                $field = $fields.Where( { $_.Name -eq $GetReferenceEntityById })
                $resultValues = $result | Where-Object { $null -ne $_.$GetReferenceEntityById }
                if ($resultValues.Count -lt $result.Count) {
                    Write-Warning ('{0}: Only {1} of the {2}s in the primary query had a value in the property {3}.' -F $MyInvocation.MyCommand.Name, 
                        $resultValues.Count,
                        $Entity,
                        $GetReferenceEntityById) -WarningAction Continue
                }
                $Filter = 'id -eq {0}' -F $($resultValues.$GetReferenceEntityById -join ' -or id -eq ')
                $result = Get-Atwsdata -Entity $field.ReferenceEntityType -Filter $Filter
            }
            elseif ($GetExternalEntityByThisEntityId) {
                Write-Verbose ('{0}: User has asked for {1} that are referencing this result' -F $MyInvocation.MyCommand.Name, $GetExternalEntityByThisEntityId)
                $ReferenceInfo = $GetExternalEntityByThisEntityId -Split ':'
                $Filter = '{0} -eq {1}' -F $ReferenceInfo[1], $($result.id -join (' -or {0}id -eq ' -F $ReferenceInfo[1]))
                $result = Get-Atwsdata -Entity $ReferenceInfo[0] -Filter $Filter
            }

            Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
            Return $result
        }
    }
  
}