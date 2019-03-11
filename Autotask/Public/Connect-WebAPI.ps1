<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md  for license information.

#>

Function Connect-WebAPI {
  <#
      .SYNOPSIS
      This function re-loads the module with the correct parameters for full functionality
      .DESCRIPTION
      This function is a wrapper that is included for backwards compatibility with previous module behavior.
      These parameters should be passed to Import-Module -Variable directly, but previously the module 
      consisted of two, nested modules. Now there is a single module with all functionality.
      .INPUTS
      A PSCredential object. Required. 
      A string used as ApiTrackingIdentifier. Required. 
      .OUTPUTS
      Nothing.
      .EXAMPLE
      Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $String
      .NOTES
      NAME: Connect-AtwsWebAPI
  #>
	
  [cmdletbinding()]
  Param
  (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]    
    [pscredential]
    $Credential,
    
    [Parameter(Mandatory = $true)]
    [String]
    $ApiTrackingIdentifier
  )
    
  Begin { 
    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
    # The module is already loaded. It has to be, or this function would not be in
    # the users scope.
    $ModuleName = $MyInvocation.MyCommand.Module.Name
    
    # Store parameters to global variables. Force-reloading the module destroys this scope.
    $Global:AtwsCredential = $Credential
    $Global:AtwsApiTrackingIdentifier = $ApiTrackingIdentifier
  }
  
  Process { 
    Try 
    { 
      # First try to re-import the module by name
      Import-Module -Name $ModuleName -Global -Force -Variable $Global:Credential, $Global:ApiTrackingIdentifier -ErrorAction Stop
    }
    Catch 
    {
      # If import by name fails the module has most likely been loaded directly from disk (path)
      # Retry loading the module from its base directory
      $Module = Get-Module -Name $ModuleName
      $ModulePath = $Module.ModuleBase
      Import-Module $ModulePath -Global -Force -Variable $Global:AtwsCredential, $Global:AtwsApiTrackingIdentifier
    }
  }
  
  End {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
  }
 
}
