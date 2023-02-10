<#

    .COPYRIGHT
    Copyright (c) Hugo Klemmestad. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

#>

Function Update-AtwsObjectsWithParameters {
    <#
            .SYNOPSIS
            This function updates an array of objects with the parameter set of a Set- or New-function.
            .DESCRIPTION
            This function updates an array of objects with the parameters passed to a Set- or New-function.
            .INPUTS
            [PSObject[]]
            .OUTPUTS
            [PSObject[]]
            .EXAMPLE
            $Element | Update-AtwsObjectsWithParameters -BoundParameters $PSBoundParameters -Entity $EntityName
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
        [Collections.Generic.List[psobject]]
        $InputObject,

        [Parameter(
            Mandatory = $true
        )]
        [System.Collections.Generic.Dictionary`2[System.string, System.Object]]
        $BoundParameters,

        [Parameter(
            Mandatory = $true
        )]
        [ValidateScript( { $Script:FieldInfoCache.Keys -contains $_ })]
        [string]
        $EntityName
    )

    begin {
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {
            $DebugPreference = 'Continue'
        }

        Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

        # Get updated field info about this entity
        $fields = Get-AtwsFieldInfo -Entity $entityName

        $result = [Collections.Generic.List[psobject]]::new()

    }

    process {
        Write-Debug ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)


        # Loop through parameters and update any inputobjects with the given parameter values
        foreach ($parameter in $BoundParameters.GetEnumerator()) {
            # Get field info for the field with the same name as the parameter
            $field = $fields[$parameter.Key]

            # Limit processing to parameter that match an existing field
            if (($field) -or $parameter.Key -eq 'UserDefinedFields') {
                if ($field.IsPickList -and -not ($parameter.Value -as [int])) {
                    if ($field.PickListParentValueField) {
                        # There is a parent field. The selection of this field depends on parent
                        $parentField = $fields[$field.PickListParentValueField]

                        # Get the Parent label and value
                        $parentLabel = $BoundParameters.$($parentField.Name)
                        $parentValue = $parentField['PickListValues']['byLabel'][$parentLabel]

                        # Select pickListValue based on label -and parentValue
                        $pickListValue = $field['PickListValues'][$parentValue]['byLabel'][$parameter.Value]
                    }
                    else {
                        # No parent field. Select pickListValue based on value
                        $pickListValue = $field['PickListValues']['byLabel'][$parameter.Value]
                    }
                    # Set value to the picklist index value, not the label
                    $value = $pickListValue
                }
                else {
                    # It isn't a picklist. Use the value of the parameter unmodified
                    $value = $parameter.Value
                }

                foreach ($object in $InputObject) {
                    $object.$($parameter.Key) = $value
                }
            }

        }

        $result += $InputObject

    }

    end {
        Write-Debug -Message ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $result.count, $entityName)
        Return $result
    }
}