<#

    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

#>

Function Save-AtwsModuleConfiguration {
    <#
            .SYNOPSIS
            This function saves to disk the internal configuration object that stores all module options.
            .DESCRIPTION
            This function saves to disk the internal configuration object that stores all module options.
            The default path is the current PowerShell configuration directory, 
            .INPUTS
            Nothing.
            .OUTPUTS
            [PSObject]
            .EXAMPLE
            Save-AtwsModuleConfiguration
            .EXAMPLE
            Save-AtwsModuleConfiguration -Path AtwsConfig.clixml
            .NOTES
            NAME: Save-AtwsModuleConfiguration
            .LINK
            Get-AtwsModuleConfiguration
            Set-AtwsModuleConfiguration
            New-AtwsModuleConfiguration
            Remove-AtwsModuleConfiguration
    #>
	
    [cmdletbinding(
        ConfirmImpact = 'Low'
    )]
    [Alias('Save-AtwsProfile')]
    Param
    (
        [Parameter(
            ValueFromPipeline = $true
        )]
        [ValidateScript( {
                # Validate the configuration object before accepting it
                Test-AtwsModuleConfiguration -Configuration $_
            })]
        [PSObject]
        $Configuration = $Script:Atws.Configuration,
    
        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter( {
                param($Cmd, $Param, $Word, $Ast, $FakeBound)
                if (Test-Path $FakeBound.AtwsModuleConfigurationPath) {
                    [IO.FileInfo]$filepath = $FakeBound.AtwsModuleConfigurationPath
                }
                else {
                    [IO.FileInfo]$filepath = $(Join-Path -Path $Script:AtwsModuleConfigurationPath -ChildPath AtwsConfig.clixml)
                }
                $tempsettings = Import-Clixml -Path $filepath.Fullname
                if ($tempsettings -is [hashtable]) {
                    $tempsettings.keys
                }
            })]
        [String]
        $Name = 'Default',
        
        [ArgumentCompleter( {
                param($Cmd, $Param, $Word, $Ast, $FakeBound)
                $(Get-ChildItem -Path $Script:AtwsModuleConfigurationPath -Filter "*.clixml").FullName
            })]
        [IO.FileInfo]
        $Path = $(Join-Path -Path $Script:AtwsModuleConfigurationPath -ChildPath AtwsConfig.clixml)
    )
    
    begin { 
    
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

        # Read existing configuration from disk
        if ($Path.Exists) {
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
    
    }
  
    process {
        Try { 
            # Save settings in correct slot
            $settings[$Name] = $Configuration
            
            # Try to save to the path
            Export-Clixml -InputObject $settings -Path $Path.Fullname
        }
        catch {
            $message = "{0}`nStacktrace:`n{1}" -f $_, $_.ScriptStackTrace
            throw (New-Object System.Configuration.Provider.ProviderException $message)
        
            return
        }
    }
  
    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    }
 
}
