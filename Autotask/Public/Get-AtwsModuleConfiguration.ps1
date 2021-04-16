<#

    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

#>

Function Get-AtwsModuleConfiguration {
    <#
            .SYNOPSIS
            This function loads from disk the internal configuration object that stores all module options.
            .DESCRIPTION
            This function loads from disk the internal configuration object that stores all module options.
            The default path is the current PowerShell configuration directory, 
            .INPUTS
            Nothing.
            .OUTPUTS
            [PSObject]
            .EXAMPLE
            Get-AtwsModuleConfiguration
            .EXAMPLE
            Get-AtwsModuleConfiguration -Name Sandbox
            .EXAMPLE
            Get-AtwsModuleConfiguration -Path AtwsConfig.clixml
            .NOTES
            NAME: Save-AtwsModuleConfiguration
    #>
	
    [Alias('Get-AtwsProfile')]
    [cmdletbinding(
        ConfirmImpact = 'Low'
    )]
    Param
    (
        [ArgumentCompleter( {
                param($Cmd, $Param, $Word, $Ast, $FakeBound)
                $(Get-ChildItem -Path $(Split-Path -Parent $profile) -Filter "*.clixml").FullName
            })]
        [ValidateScript( { 
                Test-Path $_
            })]
        [IO.FileInfo]
        $Path = $(Join-Path -Path $(Split-Path -Parent $profile) -ChildPath AtwsConfig.clixml),

        [ArgumentCompleter( {
                param($Cmd, $Param, $Word, $Ast, $FakeBound)
                if (Test-Path $FakeBound.Path) {
                    [IO.FileInfo]$filepath = $FakeBound.Path
                }
                else {
                    [IO.FileInfo]$filepath = $(Join-Path -Path $(Split-Path -Parent $profile) -ChildPath AtwsConfig.clixml)
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
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
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

        if ($settings.ContainsKey($Name)) {
            $configuration = $settings[$Name]
            if (-not(Test-AtwsModuleConfiguration -Configuration $configuration)) {
                $message = "Configuration named '$Name' was successfully read from disk, but the configuration settings did not validate OK. The configuration will be deleted."

                throw (New-Object System.Configuration.Provider.ProviderException $message)
            }
        }
        else {
            $configuration = New-AtwsModuleConfiguration
        }

    }
  
    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        return $configuration
    }
 
}
