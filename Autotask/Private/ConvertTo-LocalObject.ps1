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

    Param
    (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [validateScript({
            if($_.GetType().FullName -like 'Autotask*'){
                $true
            }else {
                $False
            }
        })]
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
        $result = [Collections.ArrayList]::new()
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

            # Any userdefined fields?
            if ($object.UserDefinedFields.Count -gt 0) {
                # Expand User defined fields for easy filtering of collections and readability
                # and convert array of userdefined fields to hashtable
                $UserDefinedFields = @{}
                foreach ($UDF in $object.UserDefinedFields) {
                    # Make names you HAVE TO escape...
                    $UDFName = '#{0}' -F $UDF.Name
                    Add-Member -InputObject $object -MemberType NoteProperty -Name $UDFName -Value $UDF.Value -Force

                    # Add to hashtable
                    $UserDefinedFields[$UDF.Name] = $UDF.Value
                }
                # Replace custom array with hashtable
                Add-Member -InputObject $object -MemberType NoteProperty -Name UserDefinedFields -Value $UserDefinedFields -Force
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

                    # Convert the datetime from EST back to local time
                    $object.$dateTimeParam = [TimeZoneInfo]::ConvertTime($value, $EST, [TimeZoneInfo]::Local)
                }
            }


            # Restore picklist labels
            foreach ($field in $Picklists) {
                $picklistValues = Get-AtwsPicklistValue -Entity $entityName -FieldName $field
                if ($object.$field -in $picklistValues.Keys -and $picklistValues.count -gt 0) {
                    $value = $picklistValues[$object.$field]
                    if ($Script:Atws.Configuration.ConvertPicklistIdToLabel) {
                        $object.$field = $value
                    }
                    # Add Label property
                    $fieldName = '{0}Label' -F $field
                    Add-Member -InputObject $object -MemberType NoteProperty -Name $fieldName -Value $value -Force

                }
            }
        }

        # If using pipeline the process block will run once per object in pipeline. Store them all
        if ($InputObject.Count -gt 1) {
            $result.AddRange($InputObject)
        }else {
            $result.Add($InputObject)
        }

    }

    end {
        Write-Debug -Message ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $result.count, $entityName)
        Return [array]$result
    }
}