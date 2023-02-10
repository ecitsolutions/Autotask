<#

    .COPYRIGHT
    Copyright (c) Hugo Klemmestad. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

#>

Function ConvertTo-AtwsFilter {
    <#
            .SYNOPSIS
            This function converts a parameter set of a Get-function to a parsable approximation of a PowerShell
            filter.
            .DESCRIPTION
            This function converts a parameter set of a Get-function to a parsable approximation of a PowerShell
            filter. Due to internal scope contraints the function needs to be dot.sourced in the calling function.
            This function is not stand alone. It uses several variables that only exist in the calling scope, 
            another reason it needs to be dot.sourced. This is not best practice, but it is still by design. 
            .INPUTS
            System.Collections.Generic.Dictionary`2[System.string,System.Object]]
            .OUTPUTS
            [string[]]
            .EXAMPLE
            $Element | ConvertTo-AtwsDate -ParameterName <ParameterName>
            Converts variable $Element with must contain a single DateTime value to a string representation of the 
            Date or the DateTime, based on the parameter name.
            .NOTES
            NAME: ConvertTo-AtwsFilter
      
    #>
    [cmdletbinding()]
    Param
    (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [System.Collections.Generic.Dictionary`2[System.string, System.Object]]
        $BoundParameters,
    
        [Parameter(
            Mandatory = $true
        )]
        [ValidateScript( { $Script:FieldInfoCache.Keys -contains $_ })]
        [string]
        $entityName
    )

    begin {
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
            
        $fields = Get-AtwsFieldInfo -Entity $entityName
        
        $Filter = [Collections.ArrayList]::new()
    }

    process {
        Write-Debug ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)
      
        
 
        foreach ($parameter in $BoundParameters.GetEnumerator()) {
            $field = $fields[$parameter.Key]
      
            # If Parameter value is null or an empty string for string types, add name to $IsNull array
            # and continue
            if (($field.Type -ne 'string' -and $null -eq $parameter.Value) -or ($field.Type -eq 'string' -and $parameter.Value.Length -eq 0)) {
                if ($IsNull -notcontains $parameter.Key) { 
                    [Array]$IsNull += $parameter.Key
                }
                Continue
            }
      
            if (($field) -or $parameter.Key -eq 'UserDefinedField') { 
                if ($parameter.Value.Count -gt 1) {
                    [void]$Filter.add('-begin')
                }
                foreach ($parameterValue in $parameter.Value) {   
                    $Operator = '-or'
                    $parameterName = $parameter.Key
                    if ($field.IsPickList) {
                        if ($field.PickListParentValueField) {
                            $parentField = $fields[$field.PickListParentValueField]
                            $parentLabel = $BoundParameters[$parentField.Name]
                            $parentValue = $parentField['PickListValues']['byLabel'][$parentLabel][0]
                            $pickListValue = $field['PickListValues'][$parentValue]['byLabel'][$parameterValue]               
                        }
                        else { 
                            $pickListValue = $field['PickListValues']['byLabel'][$parameterValue]
                        }
                        $value = $pickListValue
                    }
                    elseif ($parameterName -eq 'UserDefinedField') {
                        [void]$Filter.add('-udf')            
                        $parameterName = $parameterValue.Name
                        
                        if ($null -eq $parameter.Value -or $parameter.Value.Length -eq 0) {
                            [Array]$IsNull += 'UserDefinedField'
                        }
                        
                        $value = $parameterValue.Value
                        
                    }
                    elseif (($parameterValue.GetType().Name -eq 'DateTime') -and -not ($parameter.Value.Count -gt 1)) {
                        if ($parameterValue -eq $parameterValue.Date -and 
                            $parameter.Key -notin $GreaterThan -and 
                            $parameter.Key -notin $GreaterThanOrEquals -and 
                            $parameter.Key -notin $LessThan -and 
                            $parameter.Key -notin $LessThanOrEquals) {

                            # User is searching for a date, not a specific datetime
                            [void]$Filter.add($parameterName)
                            [void]$Filter.add('-ge')
                            [void]$Filter.add((ConvertTo-AtwsDate -DateTime $parameterValue))

                            # Force array, or the next time around we'll get a concatenated string
                            [Array]$LessThanOrEquals += $parameterName
                            $value = ConvertTo-AtwsDate -DateTime $parameterValue.AddDays(1)
                        }
                        else { 
                            $value = ConvertTo-AtwsDate -DateTime $parameterValue
                        }
                    }  
                    elseif ($field.Type -eq 'boolean') {
                        $value = switch ($parameterValue) {
                            { @('1', 'true') -contains $_ } { 1 }
                            { @('0', 'false') -contains $_ } { 0 }
                        }          
                    }
                    else {
                        $value = $parameterValue
                    }
                    [void]$Filter.add($parameterName)
                    if ($parameter.Key -in $NotEquals) { 
                        [void]$Filter.add('-ne')
                        $Operator = '-and'
                    }
                    elseif ($parameter.Key -in $GreaterThan)
                    { [void]$Filter.add('-gt') }
                    elseif ($parameter.Key -in $GreaterThanOrEquals)
                    { [void]$Filter.add('-ge') }
                    elseif ($parameter.Key -in $LessThan)
                    { [void]$Filter.add('-lt') }
                    elseif ($parameter.Key -in $LessThanOrEquals)
                    { [void]$Filter.add('-le') }
                    elseif ($parameter.Key -in $Like) { 
                        [void]$Filter.add('-like')
                        $value = $value -replace '\*', '%'
                    }
                    elseif ($parameter.Key -in $NotLike) { 
                        [void]$Filter.add('-notlike')
                        $value = $value -replace '\*', '%'
                    }
                    elseif ($parameter.Key -in $BeginsWith)
                    { [void]$Filter.add('-beginswith') }
                    elseif ($parameter.Key -in $EndsWith)
                    { [void]$Filter.add('-endswith') }
                    elseif ($parameter.Key -in $Contains)
                    { [void]$Filter.add('-contains') }
                    elseif ($parameter.Key -in $IsThisDay)
                    { [void]$Filter.add('-isthisday') }
                    elseif ($parameter.Key -in $IsNull -and $parameter.Key -eq 'UserDefinedField') {
                        [void]$Filter.add('-IsNull')
                        $IsNull = $IsNull.Where( { $_ -ne 'UserDefinedField' })
                    }
                    elseif ($parameter.Key -in $IsNotNull -and $parameter.Key -eq 'UserDefinedField') {
                        [void]$Filter.add('-IsNotNull')
                        $IsNotNull = $IsNotNull.Where( { $_ -ne 'UserDefinedField' })
                    }
                    else
                    { [void]$Filter.add('-eq') }
            
                    # Add Value to expression, unless this is a UserDefinedfield AND UserDefinedField has been
                    # specified for -IsNull or -IsNotNull
                    if ($Filter[-1] -notin @('-IsNull', '-IsNotNull'))
                    { [void]$Filter.add($value) }

                    if ($parameter.Value.Count -gt 1 -and $parameterValue -ne $parameter.Value[-1]) {
                        [void]$Filter.add($Operator)
                    }
                    elseif ($parameter.Value.Count -gt 1) {
                        [void]$Filter.add('-end')
                    }
            
                }
            
            }
        }
        # IsNull and IsNotNull are special. They are the only operators that does not require a value to work
        if ($IsNull.Count -gt 0) {
            if ($Filter.Count -gt 0) {
                [void]$Filter.add('-and')
            }
            foreach ($PropertyName in $IsNull) {
                [void]$Filter.add($PropertyName)
                [void]$Filter.add('-isnull')
            }
        }
        if ($IsNotNull.Count -gt 0) {
            if ($Filter.Count -gt 0) {
                [void]$Filter.add('-and')
            }
            foreach ($PropertyName in $IsNotNull) {
                [void]$Filter.add($PropertyName)
                [void]$Filter.add('-isnotnull')
            }
        }  
 
    }

    end {
        Return $Filter
    }
}