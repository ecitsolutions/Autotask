<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

#>

Function Set-AtwsModuleConfiguration {
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
            Set-AtwsModuleConfiguration -Credential $Credential -ApiTrackingIdentifier $string
        .NOTES
            NAME: Set-AtwsModuleConfiguration
    #>
	
    [cmdletbinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    Param
    (
        [ValidateNotNullOrEmpty()]    
        [pscredential]
        $Credential,
    
        [string]
        $ApiTrackingIdentifier,
    
        [Alias('Picklist', 'UsePickListLabel')]
        [switch]
        $ConvertPicklistIdToLabel,
    
        [ValidateScript( {
                # It can be empty, but if it isn't it should be max 8 characters and only letters and numbers
                if ($_.length -eq 0 -or ($_ -match '[a-zA-Z0-9]' -and $_.length -gt 0 -and $_.length -le 8)) {
                    $true
                }
                else {
                    $false
                }
            })]
        [string]
        $Prefix,

        [switch]
        $RefreshCache,

        [ValidateSet('Stop', 'Inquire', 'Continue', 'SilentlyContinue')]
        [string]
        $DebugPref,
        
        [ValidateSet('Stop', 'Inquire', 'Continue', 'SilentlyContinue')]
        [string]
        $VerbosePref
    )
    
    begin { 
    
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {
            $DebugPreference = 'Continue' 
        }
        else {
            # Respect configured preference
            $DebugPreference = $Script:Atws.Configuration.DebugPref
        }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

        if (!($PSCmdlet.MyInvocation.BoundParameters['Verbose'].IsPresent)) {
            # No local override of central preference. Load central preference
            $VerbosePreference = $Script:Atws.Configuration.VerbosePref
        }

        if (-not($Script:Atws.integrationsValue)) {
            Throw [ApplicationException] 'Not connected to Autotask WebAPI. Connect with Connect-AtwsWebAPI. For help use "get-help Connect-AtwsWebAPI".'
        }
    
    }
  
    process {

        switch ($PSCmdlet.MyInvocation.BoundParameters) { 
            'Credential' {
                $Script:Atws.Configuration.Username = $Credential.UserName
                $Script:Atws.Configuration.SecurePassword = $Credential.Password
                $Script:Atws.ClientCredentials.UserName.UserName = $Credential.UserName
                $Script:Atws.ClientCredentials.UserName.Password = $Credential.GetNetworkCredential().Password
            }
            'ApiTrackingIdentifier' { 
                $Script:Atws.integrationsValue.IntegrationCode = $ApiTrackingIdentifier
            }
            'ConvertPicklistIdToLabel' {
                $Script:Atws.Configuration.ConvertPicklistIdToLabel = $ConvertPicklistIdToLabel.IsPresent
            }
            'Prefix' { 
                if ($Prefix -ne $Script:Atws.Configuration.Prefix) { 
                    Write-Warning "The module prefix cannot be changed while the module is loaded. A module reload is necessary."
                    $Script:Atws.Configuration.Prefix = $Prefix
                }
            }
            'RefreshCache' { 
                if ($RefreshCache.IsPresent) { 
                    $Script:Atws.Configuration.RefreshCache = $true
                    $reloadModule = $true                }
                else {
                    $Script:Atws.Configuration.RefreshCache = $false
                }
            }
            'DebugPref' { 
                $DebugPreference = $DebugPref
                $Script:Atws.Configuration.DebugPref = $DebugPref
            }
            'VerbosePref' {
                $VerbosePreference = $VerbosePref
                $Script:Atws.Configuration.VerbosePref = $VerbosePref
            }
        }
        
    }
  
    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    }
 
}
