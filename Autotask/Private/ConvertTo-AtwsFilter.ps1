<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md  for license information.

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
        
        # Set up TimeZone offset handling
        if (-not($script:ESTzone)) {
            $script:ESTzone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Eastern Standard Time")
        }
    
        if (-not($script:ESToffset)) {
            $now = Get-Date
            $ESTtime = [System.TimeZoneInfo]::ConvertTimeFromUtc($now.ToUniversalTime(), $ESTzone)

            $script:ESToffset = (New-TimeSpan -Start $ESTtime -End $now).TotalHours
        }
    
        $fields = Get-AtwsFieldInfo -Entity $entityName
        
        [string[]]$Filter = @()
    }

    process {
        Write-Debug ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)
      
        
 
        foreach ($parameter in $BoundParameters.GetEnumerator()) {
            $field = $fields | Where-Object { $_.Name -eq $parameter.Key }
      
            # If Parameter value is null or an empty string for string types, add name to $IsNull array
            # and continue
            if (($field.Type -ne 'string' -and $null -eq $parameter.Value) -or ($field.Type -eq 'string' -and $parameter.Value.Length -eq 0)) {
                if ($IsNull -notcontains $parameter.Key) { 
                    $IsNull += $parameter.Key
                }
                Continue
            }
      
            if ($field -or $parameter.Key -eq 'UserDefinedField') { 
                if ($parameter.Value.Count -gt 1) {
                    $Filter += '-begin'
                }
                foreach ($parameterValue in $parameter.Value) {   
                    $Operator = '-or'
                    $parameterName = $parameter.Key
                    if ($field.IsPickList) {
                        if ($field.PickListParentValueField) {
                            $parentField = $fields.Where{ $_.Name -eq $field.PickListParentValueField }
                            $parentLabel = $PSBoundParameters.$($parentField.Name)
                            $parentValue = $parentField.PickListValues | Where-Object { $_.Label -eq $parentLabel }
                            $pickListValue = $field.PickListValues | Where-Object { $_.Label -eq $parameterValue -and $_.ParentValue -eq $parentValue.Value }                
                        }
                        else { 
                            $pickListValue = $field.PickListValues | Where-Object { $_.Label -eq $parameterValue }
                        }
                        $value = $pickListValue.Value
                    }
                    elseif ($parameterName -eq 'UserDefinedField') {
                        $Filter += '-udf'              
                        $parameterName = $parameterValue.Name
                        
                        if ($null -eq $parameter.Value -or $parameter.Value.Length -eq 0) {
                            $IsNull += 'UserDefinedField'
                        }
                        
                        $value = $parameterValue.Value
                        
                    }
                    elseif ($parameterValue.GetType().Name -eq 'DateTime') {
                        if ($parameterValue -eq $parameterValue.Date -and 
                            $parameter.Key -notin $GreaterThan -and 
                            $parameter.Key -notin $GreaterThanOrEquals -and 
                            $parameter.Key -notin $LessThan -and 
                            $parameter.Key -notin $LessThanOrEquals) {

                            # User is searching for a date, not a specific datetime
                            $Filter += $parameterName
                            $Filter += '-ge'
                            $Filter += ConvertTo-AtwsDate -DateTime $parameterValue

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
                        {@('1','true') -contains $_}  { 1 }
                        {@('0','false') -contains $_} { 0 }
                      }          
                    }       
                    else {
                        $value = $parameterValue
                    }
                    $Filter += $parameterName
                    if ($parameter.Key -in $NotEquals) { 
                        $Filter += '-ne'
                        $Operator = '-and'
                    }
                    elseif ($parameter.Key -in $GreaterThan)
                    { $Filter += '-gt' }
                    elseif ($parameter.Key -in $GreaterThanOrEquals)
                    { $Filter += '-ge' }
                    elseif ($parameter.Key -in $LessThan)
                    { $Filter += '-lt' }
                    elseif ($parameter.Key -in $LessThanOrEquals)
                    { $Filter += '-le' }
                    elseif ($parameter.Key -in $Like) { 
                        $Filter += '-like'
                        $value = $value -replace '\*', '%'
                    }
                    elseif ($parameter.Key -in $NotLike) { 
                        $Filter += '-notlike'
                        $value = $value -replace '\*', '%'
                    }
                    elseif ($parameter.Key -in $BeginsWith)
                    { $Filter += '-beginswith' }
                    elseif ($parameter.Key -in $EndsWith)
                    { $Filter += '-endswith' }
                    elseif ($parameter.Key -in $Contains)
                    { $Filter += '-contains' }
                    elseif ($parameter.Key -in $IsThisDay)
                    { $Filter += '-isthisday' }
                    elseif ($parameter.Key -in $IsNull -and $parameter.Key -eq 'UserDefinedField') {
                        $Filter += '-IsNull'
                        $IsNull = $IsNull.Where( { $_ -ne 'UserDefinedField' })
                    }
                    elseif ($parameter.Key -in $IsNotNull -and $parameter.Key -eq 'UserDefinedField') {
                        $Filter += '-IsNotNull'
                        $IsNotNull = $IsNotNull.Where( { $_ -ne 'UserDefinedField' })
                    }
                    else
                    { $Filter += '-eq' }
            
                    # Add Value to expression, unless this is a UserDefinedfield AND UserDefinedField has been
                    # specified for -IsNull or -IsNotNull
                    if ($Filter[-1] -notin @('-IsNull', '-IsNotNull'))
                    { $Filter += $value }

                    if ($parameter.Value.Count -gt 1 -and $parameterValue -ne $parameter.Value[-1]) {
                        $Filter += $Operator
                    }
                    elseif ($parameter.Value.Count -gt 1) {
                        $Filter += '-end'
                    }
            
                }
            
            }
        }
        # IsNull and IsNotNull are special. They are the only operators that does not require a value to work
        if ($IsNull.Count -gt 0) {
            if ($Filter.Count -gt 0) {
                $Filter += '-and'
            }
            foreach ($PropertyName in $IsNull) {
                $Filter += $PropertyName
                $Filter += '-isnull'
            }
        }
        if ($IsNotNull.Count -gt 0) {
            if ($Filter.Count -gt 0) {
                $Filter += '-and'
            }
            foreach ($PropertyName in $IsNotNull) {
                $Filter += $PropertyName
                $Filter += '-isnotnull'
            }
        }  
 
    }

    end {
        Return $Filter
    }
}