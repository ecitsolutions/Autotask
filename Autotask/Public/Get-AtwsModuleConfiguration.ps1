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
            Related commands:
            Save-AtwsModuleConfiguration
            New-AtwsModuleConfiguration
            Set-AtwsModuleConfiguration
            Remove-AtwsModuleConfiguration
    #>
	
    [Alias('Get-AtwsProfile')]
    [cmdletbinding(
        ConfirmImpact = 'Low'
    )]
    Param
    (
        [Parameter(Position = 1)]
        [ArgumentCompleter( {
                param($Cmd, $Param, $Word, $Ast, $FakeBound)
                $(Get-ChildItem -Path $Global:AtwsModuleConfigurationPath -Filter "*.clixml").FullName
            })]
        [ValidateScript( { 
                Test-Path $_
            })]
        [Alias('ProfilePath')]
        [IO.FileInfo]
        $Path = $(Join-Path -Path $Global:AtwsModuleConfigurationPath -ChildPath AtwsConfig.clixml),

        [Parameter(Position = 0)]
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
        [Alias('ProfileName')]
        [String]
        $Name = 'Default',

        [switch]
        $All
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

        if ($all.IsPresent) {
            $configuration = $settings
        }
        elseIf ($settings.ContainsKey($Name)) {
            $configuration = $settings[$Name]
            if (-not(Test-AtwsModuleConfiguration -Configuration $configuration)) {
                Write-Verbose ("{0}: Configuration named '{1}' was successfully read from disk, but the configuration settings did not validate OK. Trying to fix it." -f $MyInvocation.MyCommand.Name, $Name)

                # Maybe some idiot has added new configuration options. Try to add default values to any missing properties
                try {
                    $configuration = $configuration | Set-AtwsModuleConfiguration -Name $Name -Path $Path -PassThru
                }
                catch { 
                    $message = "Configuration named '$Name' was successfully read from disk, but the configuration settings did not validate OK, nor could it be fixed. The configuration will be deleted."

                    Remove-AtwsModuleConfiguration -Path $Path -Name $Name 

                    throw (New-Object System.Configuration.Provider.ProviderException $message)
                }
            }
        }
        else {
            $message = "There are no configuration profiles named '$Name'."
            throw (New-Object System.Configuration.Provider.ProviderException $message)
        }

    }
  
    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        return $configuration
    }
 
}
