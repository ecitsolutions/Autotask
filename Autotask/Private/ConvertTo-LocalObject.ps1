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
            NAME: ConvertTo-LocalObject

    #>
    [cmdletbinding()]
    [OutputType([Collections.Generic.List[psobject]])]
    Param
    (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [Collections.Generic.List[psobject]]
        $InputObject
    )

    begin {
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {
            $DebugPreference = 'Continue'
        }

        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

        # Set up TimeZone offset handling and make sure the if statement will
        # default to Windows if platform information is not available
        $timezoneid = if ($IsMacOS -or $IsLinux) { 'America/New_York' }
        else { 'Eastern Standard Time' }
        $EST = [System.Timezoneinfo]::FindSystemTimeZoneById($timezoneid)
        $timezone = [TimeZoneInfo]::Local
        if ($Script:Atws.configuration.DateConversion -notin 'Disabled', 'Local') {
            $timezone = [System.Timezoneinfo]::FindSystemTimeZoneById($Script:Atws.configuration.DateConversion)
        }
        $result = [collections.generic.list[psobject]]::new()
    }

    process {

        # Get the entity name from input
        $entityName = $InputObject[0].GetType().Name

        # Get updated field info about this entity
        $entityInfo = Get-AtwsFieldInfo -Entity $entityName -EntityInfo

        # Normalize dates, i.e. set them to CEST. The .Update() method of the API reads all datetime fields as CEST
        # We can safely ignore readonly fields, even if we have modified them previously. The API ignores them.
        $DateTimeParams = $entityInfo.DatetimeFields

        # Prepare picklists
        $Picklists = $entityInfo.PicklistFields

        # Loop through all objects and make adjustments
        foreach ($object in $InputObject) {

            if ($Script:Atws.configuration.UdfExpansion -ne 'Disabled') { 
                # Any userdefined fields?
                if ($object.UserDefinedFields.Count -gt 0) { 
                    # Expand User defined fields for easy filtering of collections and readability
                    if ($Script:Atws.configuration.UdfExpansion -eq 'Inline') {
                        # Expand with a separate field pr UDF
                        foreach ($UDF in $object.UserDefinedFields) {
                            # Make names you HAVE TO escape...
                            $UDFName = '#{0}' -F $UDF.Name
                            Add-Member -InputObject $object -MemberType NoteProperty -Name $UDFName -Value $UDF.Value -Force
                        }  
                    }
                    else { # UdfExpansion -eq 'Hashtable'
                        # Expand as hashtable
                        $UserDefinedFields = @{}
                        foreach ($UDF in $object.UserDefinedFields) {
                            # Add to hashtable
                            $UserDefinedFields[$UDF.Name] = $UDF.Value
                        }
                        # Replace custom array with hashtable
                        Add-Member -InputObject $object -MemberType NoteProperty -Name UDF -Value $UserDefinedFields -Force
                    }
                }
            }
            # Adjust TimeZone on all DateTime properties
            if ($Script:Atws.configuration.DateConversion -ne 'Disabled') { 
                foreach ($DateTimeParam in $DateTimeParams) {

                    # Get the datetime value
                    $value = $object.$DateTimeParam

                    # Skip if parameter is empty
                    if (-not ($value)) {
                        Continue
                    }
                    # Convert the datetime to LocalTime unless it is a date and isn't local time already
                    If ($object.$DateTimeParam -ne $object.$DateTimeParam.Date -and $object.$DateTimeParam.Kind -notin 'Local', 'Utc') {

                        # Convert the datetime from EST back to local time
                        $object.$dateTimeParam = [TimeZoneInfo]::ConvertTime($value, $EST, $timezone)
                    }
                }
            }
            
            # Restore picklist labels
            if ($Script:Atws.configuration.PickListExpansion -ne 'Disabled') { 
                foreach ($field in $Picklists) {
                    if ($object.$field) {
                        $picklistValues = Get-AtwsPicklistValue -Entity $entityName -FieldName $field
                        if ($object.$field -in $picklistValues.Keys -and $picklistValues.count -gt 0) {
                            $value = $picklistValues[$object.$field.tostring()]
                            if ($Script:Atws.Configuration.PickListExpansion -eq 'Inline') {
                                $object.$field = $value
                            }
                            else { # PicklistsExpansion -eq 'LabelField'
                                # Add Label property
                                $fieldName = '{0}Label' -F $field
                                Add-Member -InputObject $object -MemberType NoteProperty -Name $fieldName -Value $value -Force
                            }
                        }
                    }
                }
            }
            
        }
        
        # If using pipeline the process block will run once per object in pipeline. Store them all
        $result.AddRange($InputObject)
    }

    end {
        Write-Debug -Message ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $result.count, $entityName)
        Return $result
    }
}