#Requires -Version 4.0
<#

    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

#>

Function Get-AtwsConnectionObject {
    <#
      .SYNOPSIS
      This function returns a Web Proxy Object with the active connection to Autotask Web Api from the current namespace.
      .DESCRIPTION
      This function returns a Web Proxy Object with the active connection to Autotask Web API from the current namespace.
      Advanced users may use this object for direct access to API methods or hardcoded queries. It may also be useful for 
      debugging.
      .INPUTS
      Nothing.
      .OUTPUTS
      [Web.Services.Protocols.SoapHttpClientProtocol]
      .EXAMPLE
      $Atws = Get-AtwsConnectionObject
      Gets a Web Proxy Object with the active connection to Autotask Web Api from the current namespace.
      .NOTES
      NAME: Get-AtwsConnectionObject
      
  #>
	
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param()
  
    begin {
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
        # Enable modern -Debug behavior before the first Write-Debug
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
        if (-not($script:atws.integrationsValue)) {
            Throw [ApplicationException] 'Not connected to Autotask WebAPI. Re-import module with valid credentials.'
        }    
    
    }

    process {
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to return the Web Proxy Object for the current connection Autotask Web API. This will expose your credentials in clear text in your terminals variable scope.' -F $caption
        $verboseWarning = '{0}: About to return the Web Proxy Object for the current connection Autotask Web API. This will expose your credentials in clear text in your terminals variable scope. Do you want to continue?' -F $caption
    
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
            Return $Script:Atws
        }
    }

    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    }
}