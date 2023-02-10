<#
    .COPYRIGHT
    Copyright (c) Hugo Klemmestad. All rights reserved. Licensed under the MIT license.
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

            Related commands:
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
    [Alias('Set-AtwsProfile')]
    Param
    ( 
        [Parameter(
            ParameterSetName = 'Credentials'
        )]
        [ValidateNotNullOrEmpty()] 
        [pscredential]
        # An API user to Autotask. Optional.
        $Credential,

        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Username_and_password'
        )]
        [ValidateNotNullOrEmpty()] 
        [string]
        # A new username to use for the connection. Optional.
        $Username,
    
        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Username_and_password'
        )]
        [ValidateNotNullOrEmpty()]
        [securestring]
        # A new password for this connection. Must be encrypted as SecureString. Optional.
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
        # The API identifier from your resource in Autotask. Must be encrypted as SecureString. Optional.
        $SecureTrackingIdentifier, 
        
        [Parameter(
            ValueFromPipelineByPropertyName = $false,
            ParameterSetName = 'Username_and_password'
        )]
        [Parameter(
            ParameterSetName = 'Credentials'
        )]
        [ValidateNotNullOrEmpty()]
        [string]
        # The API identifier from your resource in Autotask. Must be encrypted as SecureString. Optional.
        $TrackingIdentifier,
    
        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Username_and_password'
        )]
        [Parameter(
            ParameterSetName = 'Credentials'
        )]
        [switch]
        # Please ignore. It is only here for backwards compatibility. Use -PicklistConversion
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
        # Please ignore. It is only here for backwards functionality. Will be removed soon.
        $Prefix,

        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Username_and_password'
        )]
        [Parameter(
            ParameterSetName = 'Credentials'
        )]
        [switch]
        # Please ignore. It is only here for backwards compatibility. Will be removed soon.
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
        # You may save a default debug preference so you may have a separate profile for debugging.
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
        # You may save a default verbose preference so you may have a separate profile for debugging.
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
        # For bulk operations. When you post 100+ objects with changes to the API it is annoying if the operation
        # fails on all of them just because 1 of them could not be updated. How many such errors can you live with
        # before the whole operation should fail? Default = 10. Optional.
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
                $(Get-ChildItem -Path $Global:AtwsModuleConfigurationPath -Filter "*.clixml").FullName
            })]
        [ValidateScript( { 
                Test-Path $_
            })]
        [IO.FileInfo]
        [alias('ProfilePath')]
        # Full path to an alternate configuration file you want the profile to be saved to. Optional.
        $Path = $(Join-Path -Path $Global:AtwsModuleConfigurationPath -ChildPath AtwsConfig.clixml),

        # Use this parameter to save to another configuration name.
        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Username_and_password'
        )]
        [Parameter(
            ParameterSetName = 'Credentials'
        )]
        [ArgumentCompleter( {
                param($Cmd, $Param, $Word, $Ast, $FakeBound)
                if ($FakeBound.Path) {
                    [IO.FileInfo]$filepath = $FakeBound.Path
                }
                else {
                    [IO.FileInfo]$filepath = $(Join-Path -Path $Global:AtwsModuleConfigurationPath -ChildPath AtwsConfig.clixml)
                }
                $tempsettings = Import-Clixml -Path $filepath.Fullname
                if ($tempsettings -is [hashtable]) {
                    foreach ($item in ($tempsettings.keys | Sort-Object)) {
                        "'{0}'" -F $($item -replace "'", "''")
                    }
                }
            })]
        [ValidateNotNullOrEmpty()] 
        [String]
        [alias('ProfileName')]
        # The name you want to use on the connection profile. Default name is 'Default'. 
        $Name = 'Default',

        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Username_and_password'
        )]
        [Parameter(
            ParameterSetName = 'Credentials'
        )]
        [ValidateSet('Disabled', 'Inline', 'LabelField')]
        [string]
        # How do you want picklist items to be expanded: Not at all (Disabled), have the text label
        # replace the index value (Inline) or a separate property with "Label" as suffix (LabelField)
        $PickListExpansion = 'LabelField',

        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Username_and_password'
        )]
        [Parameter(
            ParameterSetName = 'Credentials'
        )]
        [ValidateSet('Disabled', 'Inline', 'Hashtable')]
        [string]
        # How do you want UDFs to be expanded: Not at all (Disabled), as new properties with
        # a hashtag as prefix (Inline) or as a hashtable on a single property .UDF ()
        $UdfExpansion = 'Inline',

        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Username_and_password'
        )]
        [Parameter(
            ParameterSetName = 'Credentials'
        )]
        [ArgumentCompleter( {
                param($Cmd, $Param, $Word, $Ast, $FakeBound)
                'Disabled'
                'Local'
                (Get-TimeZone -ListAvailable).Id | Sort-Object
            })]
        [ValidateScript( {
                # Allow disabled and local before testing timezone conversion
                if ($_ -in 'Disabled', 'Local') { return $true }
                # Allow any valid TimeZone on current system
                try { $null = [System.Timezoneinfo]::FindSystemTimeZoneById($_) }
                catch { return $false }
                return $true
            })]
        [string]
        # The Autotask API always uses Eastern Standard Time for all DateTime objects. This option
        # controls which timezone DateTime objects will be converted to when they are retrieved. The
        # default setting is 'Local', which imply that all DateTime objects will be converted to 
        # the current, local timezone setting on the system where the code runs. Other options are
        # 'Disabled' - do not perform any timezone conversion at all; and 'specific/timezone', i.e.
        # any timezone your local system supports. Useful if your companys locations span multiple
        # timezones.
        $DateConversion = 'Local', 

        [switch]
        # Return the changed configuration as a new configuration object. Useful if you want to change
        # an option (or more) in the current running configuration and save it to a new profile name
        # in one go.
        $PassThru
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

        # Only run code if parameter has been used
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
                    'SecureTrackingIdentifier' { 
                        $configuration.SecureTrackingIdentifier = $SecureTrackingIdentifier
                    }
                    'TrackingIdentifier' { 
                        $configuration.SecureTrackingIdentifier = ConvertTo-SecureString $TrackingIdentifier -AsPlainText -Force
                    }
                    'ConvertPicklistIdToLabel' {
                        $configuration.ConvertPicklistIdToLabel = $ConvertPicklistIdToLabel.IsPresent
                        if ($ConvertPicklistIdToLabel.IsPresent) {
                            Add-Member -InputObject $configuration -MemberType NoteProperty -Name PicklistExpansion -Value 'Inline' -Force
                        }
                    }
                    'RefreshCache' { 
                        $configuration.RefreshCache = $RefreshCache.IsPresent
                    }
                    'DebugPref' { 
                        $configuration.DebugPref = $DebugPref
                    }
                    'VerbosePref' {
                        $configuration.VerbosePref = $VerbosePref
                    }
                    'ErrorLimit' {
                        $configuration.ErrorLimit = $ErrorLimit
                    }
                    'PicklistExpansion' {
                        Add-Member -InputObject $configuration -MemberType NoteProperty -Name PicklistExpansion -Value $PicklistExpansion -Force
                    }
                    'UdfExpansion' {
                        Add-Member -InputObject $configuration -MemberType NoteProperty -Name UdfExpansion -Value $UdfExpansion -Force
                    }
                    'DateConversion' {
                        Add-Member -InputObject $configuration -MemberType NoteProperty -Name DateConversion -Value $DateConversion -Force
                    }
                }
            }
        }

        # Are there any required properties where we have default values that does not have a value? 
        $requiredProperties = @(
            'DebugPref', 'VerbosePref', 'ErrorLimit', 'PicklistExpansion', 'UdfExpansion', 'DateConversion'
        )
        foreach ($p in $requiredProperties) {
            if ($configuration.PSObject.Properties.name -notcontains $p) {
                $value = Get-Variable -Name $p -ValueOnly
                Add-Member -InputObject $configuration -MemberType NoteProperty -Name $p -Value $value -Force
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
        if ($PassThru.IsPresent) { 
            return $configuration
        }
    }
 
}
