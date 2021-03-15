<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

#>

Function Set-AtwsModuleConfiguration {
    <#
        .SYNOPSIS
            This function updates the runtime configuration of the module.
        .DESCRIPTION
            This function updates the runtime configuration of the module. Values that can be changed while the module is loaded
            are:
            - Credentials (both username and password may be changed separately)
            - API key
            - Whether parameters with picklist values should show labels in place of numbers (ConvertPicklistIdsToLabel)
            - Debug preference
            - Verbose preference
            - Errorlimit - how many errors should Set-Atws* or New-Atws* functions accept before the operation is aborted

            The parameters Prefix and RefreshCache does not have any effect on the current connection. They must be saved and loaded
            as part of a later connection to have any effect.
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
        ConfirmImpact = 'Medium',
        DefaultParameterSetName = 'Username_and_password'
    )]
    Param
    ( 
        [Parameter(
            ParameterSetName = 'Credentials'
        )]
        [ValidateNotNullOrEmpty()] 
        [pscredential]
        $Credential,

        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Username_and_password'
        )]
        [ValidateNotNullOrEmpty()] 
        [string]
        $Username,
    
        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Username_and_password'
        )]
        [ValidateNotNullOrEmpty()]
        [securestring]
        $SecurePassword,
    
        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Username_and_password'
        )]
        [Parameter(
            ParameterSetName = 'Credentials'
        )]
        [ValidateNotNullOrEmpty()]
        [securestring]
        $SecureTrackingIdentifier,
    
        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Username_and_password'
        )]
        [Parameter(
            ParameterSetName = 'Credentials'
        )]
        [switch]
        $ConvertPicklistIdToLabel,
    
        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Username_and_password'
        )]
        [Parameter(
            ParameterSetName = 'Credentials'
        )]
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

        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Username_and_password'
        )]
        [Parameter(
            ParameterSetName = 'Credentials'
        )]
        [switch]
        $RefreshCache,

        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Username_and_password'
        )]
        [Parameter(
            ParameterSetName = 'Credentials'
        )]
        [ValidateSet('Stop', 'Inquire', 'Continue', 'SilentlyContinue')]
        [string]
        $DebugPref,

        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Username_and_password'
        )]
        [Parameter(
            ParameterSetName = 'Credentials'
        )]
        [ValidateSet('Stop', 'Inquire', 'Continue', 'SilentlyContinue')]
        [string]
        $VerbosePref,

        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Username_and_password'
        )]
        [Parameter(
            ParameterSetName = 'Credentials'
        )]
        [ValidateRange(0, 100)]
        [int]
        $ErrorLimit
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

        foreach ($parameter in $PSBoundParameters.GetEnumerator()) { 

            $caption = $MyInvocation.MyCommand.Name
            $verboseDescription = '{0}: Saving new {1} as requested.' -F $caption, $parameter.key
            $verboseWarning = '{0}: About to save new {1}. Do you want to continue?' -F $caption, $parameter.key

            if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) {
                # Only run code if parameter has been use
                switch ($parameter.key) { 
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
                        $Script:Atws.Configuration.RefreshCache = $RefreshCache.IsPresent           
                    }
                    'DebugPref' { 
                        $DebugPreference = $DebugPref
                        $Script:Atws.Configuration.DebugPref = $DebugPref
                    }
                    'VerbosePref' {
                        $VerbosePreference = $VerbosePref
                        $Script:Atws.Configuration.VerbosePref = $VerbosePref
                    }
                    'ErrorLimit' {
                        $Script:Atws.Configuration.ErrorLimit = $ErrorLimit
                    }
                }
            }
        }
    }
  
    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    }
 
}
