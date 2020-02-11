<#

    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

#>

Function New-AtwsModuleConfiguration {
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
            Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $string
            .NOTES
            NAME: Connect-AtwsWebAPI
    #>
	
  [cmdletbinding(
    SupportsShouldProcess = $true,
    ConfirmImpact = 'Low',
    DefaultParameterSetName = 'Default'
  )]
  Param
  (
    [Parameter()]
    [ValidateNotNullOrEmpty()]    
    [pscredential]
    $Credential = $(Get-Credential -Message 'Your Autotask API user'),
    
    [Parameter()]
    [securestring]
    $ApiTrackingIdentifier = $(Read-Host -AsSecureString -Prompt 'API Tracking Identifier:'),
    
    [Parameter()]
    [Alias('Picklist')]
    [switch]
    $UsePicklistLabels = $false,
    
    [Parameter()]
    [ValidatePattern('[a-zA-Z0-9]')]
    [ValidateLength(1, 8)]
    [string]
    $Prefix,

    [Parameter()]
    [switch]
    $RefreshCache = $false,

    
    [Parameter()]
    [switch]
    $NoDiskCache = $false
  )
    
  begin { 
    
    # Enable modern -Debug behavior
    if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
  }
  
  process {
    $configuration = [PSCustomObject]@{
      Username                 = $Credential.UserName
      SecurePassword           = $Credential.Password
      SecureTrackingIdentifier = $ApiTrackingIdentifier
      UsePicklistLabels        = $UsePicklistLabels.IsPresent
      Prefix                   = $Prefix
      RefreshCache             = $RefreshCache.IsPresent
      UseDiskCache             = $NoDiskCache.IsPresent -xor $true
    }
    if (Test-AtwsModuleConfiguration -Configuration $configuration) {
      Write-Verbose ('{0}: Module configuration validated OK.' -F $MyInvocation.MyCommand.Name)
    }
    else {
      Write-Warning ('{0}: Module configuration could not be validated!' -F $MyInvocation.MyCommand.Name)
    }
  }
  
  end {
    Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    return $configuration
  }
 
}
