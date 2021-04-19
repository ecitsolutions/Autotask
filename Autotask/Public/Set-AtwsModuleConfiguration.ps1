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
            Nothing.
        .OUTPUTS
            Nothing.
        .EXAMPLE
            Set-AtwsModuleConfiguration -Credential $Credential -ApiTrackingIdentifier $string
        .NOTES
            NAME: Set-AtwsModuleConfiguration
            .LINK
            Get-AtwsModuleConfiguration
            New-AtwsModuleConfiguration
            Remove-AtwsModuleConfiguration
            Save-AtwsModuleConfiguration

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
        $ErrorLimit,

        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Username_and_password'
        )]
        [Parameter(
            ParameterSetName = 'Credentials'
        )]
        [ArgumentCompleter( {
                param($Cmd, $Param, $Word, $Ast, $FakeBound)
                $(Get-ChildItem -Path $(Split-Path -Parent $profile) -Filter "*.clixml").FullName
            })]
        [ValidateScript( { 
                Test-Path $_
            })]
        [IO.FileInfo]
        $Path = $(Join-Path -Path $(Split-Path -Parent $profile) -ChildPath AtwsConfig.clixml),

        # Use this paramter to save to another configuration name.
        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Username_and_password'
        )]
        [Parameter(
            ParameterSetName = 'Credentials'
        )]
        [ArgumentCompleter( {
                param($Cmd, $Param, $Word, $Ast, $FakeBound)
                if (Test-Path $FakeBound.Path) {
                    [IO.FileInfo]$filepath = $FakeBound.Path
                }
                else {
                    [IO.FileInfo]$filepath = $(Join-Path -Path $Script:AtwsModuleConfigurationPath -ChildPath AtwsConfig.clixml)
                }
                $tempsettings = Import-Clixml -Path $filepath.Fullname
                if ($tempsettings -is [hashtable]) {
                    $tempsettings.keys
                }
            })]
        [ValidateNotNullOrEmpty()] 
        [String]
        $Name = 'Default'
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
    
    }
  
    process {

        # Read existing configuration from disk
        if (Test-Path $Path) {
            Try { 
                # Try to save to the path
                $settings = Import-Clixml -Path $Path.Fullname
            }
            catch {
                $message = "{0}`nStacktrace:`n{1}" -f $_, $_.ScriptStackTrace
                throw (New-Object System.Configuration.Provider.ProviderException $message)
        
                return
            }
        }

        # Create an empty setting table
        if (-not ($settings -is [hashtable])) {
            $settings = @{}
        }

        # Get current configuration
        if ($Script:Atws.integrationsValue) {
            # We are connected. Use active configuration.
            $configuration = $Script:Atws.Configuration
        }
        # Not connected. Do we have an existing configuration from disk with this name?
        elseIf ($settings.containskey($Name)) {
            # Use saved configuration
            $configuration = $settings[$Name]
        }
        else {
            $message = "Not connected and no configuration by name '{0}' exists. Create a new configuration with New-AtwsModuleConfiguration. You may save it using Save-AtwsModuleConfiuguration." -f $Name
            throw (New-Object System.Configuration.Provider.ProviderException $message)
        
            return           
        }

        foreach ($parameter in $PSBoundParameters.GetEnumerator()) { 

            $caption = $MyInvocation.MyCommand.Name
            $verboseDescription = '{0}: Setting {1} to {2} as requested.' -F $caption, $parameter.key, $parameter.value
            $verboseWarning = '{0}: About to set {1} to {2}. Do you want to continue?' -F $caption, $parameter.key, $parameter.value

            if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) {
                # Only run code if parameter has been used
                switch ($parameter.key) { 
                    'Credential' {
                        $configuration.Username = $Credential.UserName
                        $configuration.SecurePassword = $Credential.Password
                    }
                    'Username' {
                        $configuration.Username = $UserName

                    }
                    'SecurePassword' {
                        $configuration.SecurePassword = $SecurePassword
                    }
                    'ApiTrackingIdentifier' { 
                        $configuration.SecureTrackingIdentifier = $SecureTrackingIdentifier
                    }
                    'ConvertPicklistIdToLabel' {
                        $configuration.ConvertPicklistIdToLabel = $ConvertPicklistIdToLabel.IsPresent
                    }
                    'Prefix' { 
                        if ($Prefix -ne $Script:Atws.Configuration.Prefix) { 
                            Write-Warning "The module prefix cannot be changed while the module is loaded. A module reload is necessary."
                            $Script:configuration.Prefix = $Prefix
                        }
                    }
                    'RefreshCache' { 
                        if ($Script:Atws.configuration) {
                            $Script:Atws.configuration.RefreshCache = $RefreshCache.IsPresent
                        }
                    }
                    'DebugPref' { 
                        $DebugPreference = $DebugPref
                        if ($Script:Atws.configuration) {
                            $Script:Atws.configuration.DebugPref = $DebugPref
                        }
                    }
                    'VerbosePref' {
                        $VerbosePreference = $VerbosePref
                        if ($Script:Atws.configuration) {
                            $Script:Atws.configuration.VerbosePref = $VerbosePref
                        }
                    }
                    'ErrorLimit' {
                        $configuration.ErrorLimit = $ErrorLimit
                    }
                }
            }
        }

        # Are we connected? Update current settings
        if ($Script:Atws.integrationsValue) {
            $Script:Atws.Configuration = $configuration

            # Prepare securestring password to be converted to plaintext
            $SecurePasswordString = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($configuration.SecurePassword)
            
            $Script:Atws.ClientCredentials.UserName | Add-Member -Force -NotePropertyName UserName -NotePropertyValue $configuration.Username
            
            $BSTRstring = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($SecurePasswordString)
            $Script:Atws.ClientCredentials.UserName | Add-Member -Force -NotePropertyName Password -NotePropertyValue $BSTRstring

            # Set the integrationcode property to the API tracking identifier provided by the user
            $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Configuration.SecureTrackingIdentifier)
            $Script:Atws.IntegrationsValue.IntegrationCode = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($BSTR)
        }
        else {
            # We loaded these settings from disk. Save to disk again.
            Save-AtwsModuleConfiguration -Name $Name -Configuration $configuration
        }
    }
  
    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        #TODO: Introduce PipelineSupport from Get-, -Set, -New, and Save-AtwsModuleConfiguration. Not doing this for now as it works as it is, jsut requires a few more lines.
        # #Returning object so it can be passed to Save-AtwsModuleConfiguration
        # Write-Verbose ("You may use Save-AtwsModuleConfiguration to seve this configuration to disk.")
        # return $configuration
    }
 
}
