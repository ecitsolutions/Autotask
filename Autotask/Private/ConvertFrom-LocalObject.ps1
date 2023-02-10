<#

    .COPYRIGHT
    Copyright (c) Hugo Klemmestad. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

#>

Function ConvertFrom-LocalObject {
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
        $result = [Collections.Generic.List[PSObject]]::new()

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

        # Adjust TimeZone on all DateTime properties
        foreach ($object in $InputObject) {

            # Adjust TimeZone on all DateTime properties
            if ($Script:Atws.configuration.DateConversion -ne 'Disabled') { 
                foreach ($dateTimeParam in $dateTimeParams) {

                    # Get the datetime value
                    $value = $object.$dateTimeParam

                    # Skip if parameter is empty
                    if (-not ($value)) {
                        Continue
                    }
                    # Convert the datetime from LocalTime unless it is a date
                    If ($object.$DateTimeParam -ne $object.$DateTimeParam.Date) {
                        # Convert the datetime back to EST
                        $object.$dateTimeParam = [TimeZoneInfo]::ConvertTime($value, $timezone, $EST)
                    }
                }
            }
            if ($Script:Atws.configuration.PickListExpansion -eq 'Inline') { 
                # Revert picklist labels to their values
                foreach ($field in $Picklists) {
                    # Get an updated picklist as hashtable indexed by label
                    $picklistValues = Get-AtwsPicklistValue -Entity $entityName -FieldName $field -Label -Hashtable
                    if ($object.$field -in $picklistValues.Keys -and $picklistValues.count -gt 0) {
                        $object.$field = $picklistValues[$object.$field]
                    }
                }
            }
        }

        # If using pipeline the process block will run once per object in pipeline. Store them all
        $result.addRange($InputObject)
    }

    end {
        Write-Debug -Message ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $result.count, $entityName)
        Return $result
    }
}