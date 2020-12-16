<#

    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

    #TODO: Research på spørring på dato med tiddsoner.
    # CSU hvor dato begynner før og slutter etter nå.
#>

Function ConvertTo-AtwsDate {
    <#
      .SYNOPSIS
      This function converts a datetime object to a string representation of the datetime object that is
      compatible with the Autotask Web Services API.
      .DESCRIPTION
      There are two challenges with the Autotask Web Services API: There is a single DateTime property type
      that is used for both date fields and datetime fields. This becomes a challenge when you factor in
      that the API always uses the EST timezone, but most users expect DateTime to be treated in their local
      Timezone. This function takes both the DateTime object and the parameter name, because the parameter
      name is the only clue as to whether this property should be treated as a Date or a full DateTime value.
      .INPUTS
      [DateTime]
      .OUTPUTS
      [string]
      .EXAMPLE
      $Element | ConvertTo-AtwsDate -ParameterName <ParameterName>
      Converts variable $Element with must contain a single DateTime value to a string representation of the
      Date or the DateTime, based on the parameter name.
      .NOTES
      NAME: ConvertTo-AtwsDate

  #>
    [cmdletbinding()]
    Param
    (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [DateTime]
        $DateTime
    )

    begin {
        Write-Debug ('{0}: Input Value: {1}' -F $MyInvocation.MyCommand.Name, $DateTime)
    }

    process {
        <# In memoria of superflouous code
        # Use local time for DateTime
        $OffsetSpan = (Get-TimeZone).BaseUtcOffset

        # Create the correct text string
        $Offset = '{0:00}:{1:00}' -F $OffsetSpan.Hours, $OffsetSpan.Minutes
        if ($OffsetSpan.Hours -ge 0) {
            $Offset = '+{0}' -F $Offset
        }
        $value = '{0}{1}' -F $(Get-Date $DateTime -Format s), $Offset
        #>
        $value = $DateTime.ToString('yyyy-MM-ddTHH:mm:ss.ffffz')

        Write-Verbose ('{0}: Converting datetime to {1}' -F $MyInvocation.MyCommand.Name, $value)

    }

    end {
        Write-Debug ('{0}: Output value: {1}' -F $MyInvocation.MyCommand.Name, $value)

        return $value
    }
}