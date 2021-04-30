<#

    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

#>

Function New-AtwsModuleConfiguration {
    <#
            .SYNOPSIS
            This function creates an internal configuration object to store all module options. If 
            given a profile name the configuration object will be saved to disk, not returned.
            .DESCRIPTION
            This function creates an internal configuration object to store all module options. It 
            requires a credential object and API key to authenticate to Autotask, all other parameters
            has default values and are optional. If you pass an optional profile name the 
            configuration object will be saved to disk, not returned.
            .INPUTS
            Nothing.
            .OUTPUTS
            [PSObject]
            .EXAMPLE
            New-AtwsModuleConfiguration -Credential $Credential -SecureTrackingIdentifier $string
            .EXAMPLE
            New-AtwsModuleConfiguration -Credential $Credential -SecureTrackingIdentifier $string -Name ProfileName
            .NOTES
            NAME: New-AtwsModuleConfiguration
            .LINK
            Get-AtwsModuleConfiguration
            Set-AtwsModuleConfiguration
            Remove-AtwsModuleConfiguration
            Save-AtwsModuleConfiguration
    #>
	
    [cmdletbinding(
        ConfirmImpact = 'Low',
        DefaultParameterSetName = 'Default'
    )]
    Param
    (
        [ValidateNotNullOrEmpty()]    
        [pscredential]
        # An API user to Autotask. If you do not supply a value you will be prompted interactively.
        $Credential = $(Get-Credential -Message 'Your Autotask API user'),
    
        [securestring]
        # The API identifier from your resource in Autotask. Must be encrypted as SecureString. If you do not supply a value you will be prompted for a cleartext password.
        $SecureTrackingIdentifier = $(Read-Host -AsSecureString -Prompt 'API Tracking Identifier'),
    
        [Alias('Picklist', 'UsePickListLabel')]
        [switch]
        # Please ignore. It is only here for backwards compatibility. Use -PicklistConversion.
        $ConvertPicklistIdToLabel = $false,
    
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
        # Please ignore. It is only here for backwards compatibility. Will be removed soon.
        $Prefix,

        [switch]
        # Please ignore. It is only here for backwards compatibility. Will be removed soon.
        $RefreshCache = $false,

        [string]
        # You may save a default debug preference so you may have a separate profile for debugging.
        $DebugPref = $Global:DebugPreference,

        [string]
        # You may save a default verbose preference so you may have a separate profile for debugging.
        $VerbosePref = $Global:VerbosePreference,

        [ValidateRange(0, 100)]
        [int]
        # For bulk operations. When you post 100+ objects with changes to the API it is annoying if the operation
        # fails on all of them just because 1 of them could not be updated. How many such errors can you live with
        # before the whole operation should fail?
        $ErrorLimit = 10,
    
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
        [alias('ProfileName', 'AtwsModuleConfigurationName')]
        [String]
        # The name you want to use on the connection profile. Default name is 'Default'. 
        $Name,
        
        [ArgumentCompleter( {
                param($Cmd, $Param, $Word, $Ast, $FakeBound)
                $(Get-ChildItem -Path $Global:AtwsModuleConfigurationPath -Filter "*.clixml").FullName
            })]
        [IO.FileInfo]
        [alias('ProfilePath')]
        # Full path to an alternate configuration file you want the profile to be saved to. Optional.
        $Path = $(Join-Path -Path $Global:AtwsModuleConfigurationPath -ChildPath AtwsConfig.clixml),

        [ValidateSet('Disabled', 'Inline', 'LabelField')]
        [string]
        # How do you want picklist items to be expanded: Not at all (Disabled), have the text label
        # replace the index value (Inline) or a separate property with "Label" as suffix (LabelField)
        $PickListExpansion = 'LabelField',

        [ValidateSet('Disabled', 'Inline', 'Hashtable')]
        [string]
        # How do you want UDFs to be expanded: Not at all (Disabled), as new properties with
        # a hashtag as prefix (Inline) or as a hashtable on a single property .UDF ()
        $UdfExpansion = 'Inline',

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
        $DateConversion = 'Local'
    )
    
    begin { 
    
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
    }
  
    process {
        Try { 
            $configuration = [PSCustomObject]@{
                Username                 = $Credential.UserName
                SecurePassword           = $Credential.Password
                SecureTrackingIdentifier = $SecureTrackingIdentifier
                ConvertPicklistIdToLabel = $ConvertPicklistIdToLabel.IsPresent
                Prefix                   = $Prefix
                RefreshCache             = $RefreshCache.IsPresent
                DebugPref                = $DebugPref
                VerbosePref              = $VerbosePref
                ErrorLimit               = $ErrorLimit
                PickListExpansion        = $PickListExpansion
                UdfExpansion             = $UdfExpansion
                DateConversion           = $DateConversion
            }
        
            if (Test-AtwsModuleConfiguration -Configuration $configuration) {
                Write-Verbose ('{0}: Module configuration validated OK.' -F $MyInvocation.MyCommand.Name)
            }
            else {
                Write-Warning ('{0}: Module configuration could not be validated!' -F $MyInvocation.MyCommand.Name)
            }
        }
        catch {
            $message = "{0}`nStacktrace:`n{1}" -f $_, $_.ScriptStackTrace
            throw (New-Object System.Configuration.Provider.ProviderException $message)
        
            return
        }
    }
  
    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        
        if ($Name) {
            Save-AtwsModuleConfiguration -Name $Name -Configuration $configuration -Path $Path
        }
        else { 
            return $configuration
        }
    }
 
}
