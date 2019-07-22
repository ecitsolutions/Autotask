#Requires -Version 4.0
<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md  for license information.

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
	
  [cmdletbinding(SupportsShouldProcess = $True, ConfirmImpact = 'High')]
  Param()
  
  Begin {
    
    # Enable modern -Debug behavior before the first Write-Debug
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
    If (-not($Script:Atws.Url)) {
      Throw [ApplicationException] 'Not connected to Autotask WebAPI. Re-import module with valid credentials.'
    }    
    
  }

  Process {
    $Caption = $MyInvocation.MyCommand.Name
    $VerboseDescrition = '{0}: About to return the Web Proxy Object for the current connection Autotask Web API in namespace {1}' -F $Caption, $Script:NameSpace
    $VerboseWarning = '{0}: About to return the Web Proxy Object for the current connection Autotask Web API in namespace {1}. Do you want to continue?' -F $Caption, $Script:NameSpace
    
    If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
      Return $Script:Atws
    }
  }

  End {
    Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
  }
}