<#

    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

#>

Function Remove-AtwsModuleConfiguration {
    <#
            .SYNOPSIS
            This function deletes from disk a named configuration object that stores all module options.
            .DESCRIPTION
            This function loads from disk the current list of configuration objects that have been saved.
            Any configuration with the name given will be deleted.
            .INPUTS
            Nothing.
            .OUTPUTS
            Nothing
            .EXAMPLE
            Remove-AtwsModuleConfiguration -Name Sandbox
            .EXAMPLE
            Remove-AtwsModuleConfiguration -Name Default -Path AtwsConfig.clixml
            .NOTES
            NAME: Remove-AtwsModuleConfiguration
            .LINK
            Get-AtwsModuleConfiguration
            Set-AtwsModuleConfiguration
            New-AtwsModuleConfiguration
            Save-AtwsModuleConfiguration
    #>
	
    [cmdletbinding(
        ConfirmImpact = 'High',
        SupportsShouldProcess = $True
    )]
    [Alias('Remove-AtwsProfile')]
    Param
    (
        [ArgumentCompleter( {
                param($Cmd, $Param, $Word, $Ast, $FakeBound)
                $(Get-ChildItem -Path $Global:AtwsModuleConfigurationPath -Filter "*.clixml").FullName
            })]
        [ValidateScript( { 
                Test-Path $_
            })]
        [IO.FileInfo]
        $Path = $(Join-Path -Path $Global:AtwsModuleConfigurationPath -ChildPath AtwsConfig.clixml),

        [ArgumentCompleter( {
                param($Cmd, $Param, $Word, $Ast, $FakeBound)
                if (Test-Path $FakeBound.Path) {
                    [IO.FileInfo]$filepath = $FakeBound.Path
                }
                else {
                    [IO.FileInfo]$filepath = $(Join-Path -Path $Global:AtwsModuleConfigurationPath -ChildPath AtwsConfig.clixml)
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
            $caption = $MyInvocation.MyCommand.Name
            $verboseDescription = '{0}: Deleting configuration with profile name {1} from configuration file {2} as requested.' -F $caption, $Name, $Path.FullName
            $verboseWarning = '{0}: About to delete configuration with profile name {1} from configuration file {2}. Do you want to continue?' -F $caption, $Name, $Path.FullName

            if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) {
                $settings.Remove($Name)
                try { 
                    # Try to save to the path
                    Export-Clixml -InputObject $settings -Path $Path.Fullname
                }
                catch {
                    $message = "{0}`nStacktrace:`n{1}" -f $_, $_.ScriptStackTrace
                    throw (New-Object System.Configuration.Provider.ProviderException $message)
        
                    return
                }
            }
        }
        else {
            $message = "{0}: Missing configuration profile: No configuration profile with name {1} was found in configuration file {2}" -f $MyInvocation.MyCommand.Name, $Name, $Path.FullName
            throw (New-Object System.Configuration.Provider.ProviderException $message)
        }

    }
  
    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    }
 
}
