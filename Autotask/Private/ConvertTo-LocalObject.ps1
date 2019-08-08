<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md  for license information.

#>

Function ConvertTo-LocalObject {
    <#
      .SYNOPSIS
      This function adjusts the timezone and converts picklist fields from their label to their index value.
      .DESCRIPTION
      This function adjusts the timezone and converts picklist fields from their label to their index value.
      .INPUTS
      [PSObject[]]
      .OUTPUTS
      [PSObject[]]
      .EXAMPLE
      $Element | ConvertFrom-LocalTimeAndLabels
      Updates the properties of object $Element with the values of any parameter with the same name as a property-
      .NOTES
      NAME: Update-AtwsObjectsWithParameters
      
  #>
    [cmdletbinding()]
    
    Param
    (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [PSObject[]]
        $InputObject
    )

    begin {
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {
            $DebugPreference = 'Continue'
        }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
        
        # Set up TimeZone offset handling
        $EST = Get-TimeZone -Id 'Eastern Standard Time'
        
    }

    process {

        # Get the entity name from input
        $entityName = $InputObject[0].GetType().Name       
        
        # Get updated field info about this entity
        $fields = Get-AtwsFieldInfo -Entity $entityName
    
        # Normalize dates, i.e. set them to CEST. The .Update() method of the API reads all datetime fields as CEST
        # We can safely ignore readonly fields, even if we have modified them previously. The API ignores them.
        $DateTimeParams = $fields.Where( { $_.Type -eq 'datetime' }).Name
    
        # Prepare picklists
        $Picklists = $fields.Where{ $_.IsPickList }
    
        # Loop through all objects and make adjustments
        foreach ($object in $InputObject) { 

            # Any userdefined fields?
            if ($Item.UserDefinedFields.Count -gt 0) { 
                # Expand User defined fields for easy filtering of collections and readability
                foreach ($UDF in $Item.UserDefinedFields) {
                    # Make names you HAVE TO escape...
                    $UDFName = '#{0}' -F $UDF.Name
                    Add-Member -InputObject $Item -MemberType NoteProperty -Name $UDFName -Value $UDF.Value -Force
                }  
            }

            # Adjust TimeZone on all DateTime properties
            foreach ($DateTimeParam in $DateTimeParams) {
    
                # Get the datetime value
                $value = $object.$DateTimeParam
                
                # Skip if parameter is empty
                if (-not ($value)) {
                    Continue
                }
                # Convert the datetime to LocalTime unless it is a date
                If ($object.$DateTimeParam -ne $object.$DateTimeParam.Date) { 

                    # Convert the datetime back to CEST
                    $object.$dateTimeParam = [TimeZoneInfo]::ConvertTime($value, $EST, [TimeZoneInfo]::Local)
                }
            }
    
            if ($Script:UsePickListLabels) { 
                # Restore picklist labels
                foreach ($field in $Picklists) {
                    if ($Item.$($field.Name) -in $field.PicklistValues.Value) {
                        $Item.$($field.Name) = ($field.PickListValues.Where{ $_.Value -eq $Item.$($field.Name) }).Label
                    }
                }
            }
        }
        
    }

    end {
        Write-Debug -Message ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $InputObject.count, $entityName)
        Return $InputObject
    }
}