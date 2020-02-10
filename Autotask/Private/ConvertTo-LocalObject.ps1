<#

    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

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
        $InputObject,
        
        [switch]
        $NoPicklistLabel
    )

    begin {
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {
            $DebugPreference = 'Continue'
        }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
        
        # Set up TimeZone offset handling
        $EST = Try {
            # Attempt the windows naming convention first, should definitely hit the most use cases
            Get-TimeZone -Id 'Eastern Standard Time' -ErrorAction Stop
        }
        catch {
            # Probably not on windows. Lets try unix
            Get-TimeZone -Id 'America/New_York'
        }
        $result = @()
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
            if ($object.UserDefinedFields.Count -gt 0) { 
                # Expand User defined fields for easy filtering of collections and readability
                foreach ($UDF in $object.UserDefinedFields) {
                    # Make names you HAVE TO escape...
                    $UDFName = '#{0}' -F $UDF.Name
                    Add-Member -InputObject $object -MemberType NoteProperty -Name $UDFName -Value $UDF.Value -Force
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
                    if ($object.$($field.Name) -in $field.PicklistValues.Value) {
                        $object.$($field.Name) = ($field.PickListValues.Where{ $_.Value -eq $object.$($field.Name) }).Label
                    }
                }
            }
            
            if (-not $NoPickListLabel.IsPresent) { 
                Foreach ($field in $Picklists)
                {
                    $fieldName = '{0}Label' -F $field.Name
                    $value = ($field.PickListValues.Where{$_.Value -eq $object.$($field.Name)}).Label
                    Add-Member -InputObject $object -MemberType NoteProperty -Name $fieldName -Value $value -Force
                }
            }
        }
        
        # If using pipeline the process block will run once per object in pipeline. Store them all
        $result += $InputObject
        
    }

    end {
        Write-Debug -Message ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $result.count, $entityName)
        Return $result
    }
}