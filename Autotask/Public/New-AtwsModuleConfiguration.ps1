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
        $Credential = $(Get-Credential -Message 'Your Autotask API user'),
    
        [securestring]
        $SecureTrackingIdentifier = $(Read-Host -AsSecureString -Prompt 'API Tracking Identifier:'),
    
        [Alias('Picklist', 'UsePickListLabel')]
        [switch]
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
        $Prefix,

        [switch]
        $RefreshCache = $false,

        [string]
        $DebugPref = $DebugPreference,

        [string]
        $VerbosePref = $VerbosePreference,

        [ValidateRange(0, 100)]
        [int]
        $ErrorLimit = 10,
    
        [ArgumentCompleter( {
                param($Cmd, $Param, $Word, $Ast, $FakeBound)
                if (Test-Path $FakeBound.AtwsModuleConfigurationPath) {
                    [IO.FileInfo]$filepath = $FakeBound.AtwsModuleConfigurationPath
                }
                else {
                    [IO.FileInfo]$filepath = $(Join-Path -Path $Global:AtwsModuleConfigurationPath -ChildPath AtwsConfig.clixml)
                }
                $tempsettings = Import-Clixml -Path $filepath.Fullname
                if ($tempsettings -is [hashtable]) {
                    $tempsettings.keys
                }
            })]
        [alias('ProfileName', 'AtwsModuleConfigurationName')]
        [String]
        $Name,
        
        [ArgumentCompleter( {
                param($Cmd, $Param, $Word, $Ast, $FakeBound)
                $(Get-ChildItem -Path $Global:AtwsModuleConfigurationPath -Filter "*.clixml").FullName
            })]
        [IO.FileInfo]
        $Path = $(Join-Path -Path $Global:AtwsModuleConfigurationPath -ChildPath AtwsConfig.clixml),

        [ValidateSet('Disabled', 'Inline', 'LabelField')]
        [string]
        $PickListExpansion = 'LabelField',

        [ValidateSet('Disabled', 'Inline', 'Hashtable')]
        [string]
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
                DebugPref                = $DebugPreference
                VerbosePref              = $VerbosePreference
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
