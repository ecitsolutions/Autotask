<#

    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
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
    Param
    (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        # [PSObject[]]
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
            # Any userdefined fields?
            if ($entityInfo.HasUserDefinedFields -and $null -ne $object.UserDefinedFields) {
                #TODO: InputObject is not of this type. Has to change? Check older version to see what this object looks like.
                if ($object.UserDefinedFields.GetType().Name -eq 'Hashtable') {
                    # Expand User defined fields for easy filtering of collections and readability
                    # and convert array of userdefined fields to hashtable
                    $UserDefinedFields = [Collections.Generic.List[Autotask.UserdefinedField]]::New()
                    foreach ($UDF in $object.UserDefinedFields) {
                        $AtwsUDF = [Autotask.UserDefinedField]@{
                            Name = $UDF.Name
                            Value = $UDF.Value
                        }
                        $UserDefinedFields.Add($AtwsUDF)
                    }
                    # Replace hashtable with array of userdefinedfield
                    Add-Member -InputObject $object -MemberType NoteProperty -Name UserDefinedFields -Value $UserDefinedFields -Force
                }
            }

            foreach ($dateTimeParam in $dateTimeParams) {

                # Get the datetime value
                $value = $object.$dateTimeParam

                # Skip if parameter is empty
                if (-not ($value)) {
                    Continue
                }
                # Convert the datetime from LocalTime unless it is a date
                If ($object.$DateTimeParam -ne $object.$DateTimeParam.Date) {
                    # Convert the datetime back to CEST
                    #TODO: the new api update might handle this for us. Do we set timezone to the EST time? or leave it be.
                    #Has to check if the Autotask api handles timezone for us or not.
                    $object.$dateTimeParam = [TimeZoneInfo]::ConvertTime($value, [TimeZoneInfo]::Local, $EST)
                }
            }

            # Revert picklist labels to their values
            foreach ($field in $Picklists) {
                # Get an updated picklist as hashtable indexed by label
                $picklistValues = Get-AtwsPicklistValue -Entity $entityName -FieldName $field -Label -Hashtable
                if ($object.$field -in $picklistValues.Keys -and $picklistValues.count -gt 0) {
                    $object.$field = $picklistValues[$object.$field]
                }
            }
        }

        # If using pipeline the process block will run once per object in pipeline. Store them all
        if ($InputObject.Count -gt 1) {
            $result.addRange($InputObject)
        }else {
            $result.add($InputObject)
        }

    }

    end {
        Write-Debug -Message ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $result.count, $entityName)
        Return [array]$result
    }
}