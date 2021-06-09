<#

    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

#>

Function Get-AtwsThresholdAndUsageInfo {
    <#
      .SYNOPSIS
      This function collects information about a specific Autotask invoice object and returns a generic
      powershell object with all relevant information as a starting point for import into other systems.
      .DESCRIPTION
      The function accepts an invoice object or an invoice id and makes a special API call to get a 
      complete invoice description, including billingitems. For some types of billingitems additional
      information may be collected. All information is collected and stored in a PSObject which is
      returned.
      .INPUTS
      Nothing
      .OUTPUTS
      [String]
      .EXAMPLE
      Get-AtwsThresholdAndUsageInfo
      
  #>
	
    [cmdletbinding()]
    Param
    (
    )
  
    begin {
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
        if (-not($Script:Atws.integrationsValue)) {
            # Not connected. Try to connect, prompt for credentials if necessary
            Write-Verbose ('{0}: Not connected. Calling Connect-AtwsWebApi without parameters for possible autoload of default connection profile.' -F $MyInvocation.MyCommand.Name)
            Connect-AtwsWebAPI
        }    
    }

    process {
        try { 
            Write-Verbose ('{0}: Calling GetThresholdAndUsageInfo()' -F $MyInvocation.MyCommand.Name)

            $result = $Script:Atws.GetThresholdAndUsageInfo($Script:Atws.integrationsValue)
        }
        catch {
            Write-Warning ('{0}: FAILED on GetThresholdAndUsageInfo(). No data returned.' -F $MyInvocation.MyCommand.Name)
              
            # try the next ID
            Continue
        }


        # Handle any errors
        if ($result.Errors.Count -gt 0) {
            foreach ($AtwsError in $result.Errors) {
                Write-Error $AtwsError.Message
            }
            Return
        }
    
        Write-Verbose ('{0}: Creating a return object with threshold and usage info.' -F $MyInvocation.MyCommand.Name)
    
        $ThresholdInfo = New-Object -TypeName PSObject
        foreach ($string in $result.EntityReturnInfoResults.Message -Split ';') {
            $Substring = $string -split ':'
            if ($Substring[0].length -gt 0) {
                Add-Member -InputObject $ThresholdInfo -MemberType NoteProperty -Name $Substring[0].Trim() -Value $Substring[1].Trim()
            }
        }
    }

    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

        Return $ThresholdInfo
    }
}