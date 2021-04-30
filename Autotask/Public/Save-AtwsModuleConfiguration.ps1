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
            ValueFromPipeline = $true,
            Position = 2
        )]
        [ValidateScript( {
                # Validate the configuration object before accepting it
                Test-AtwsModuleConfiguration -Configuration $_
            })]
        [PSObject]
        # A configuration object created with New-AtwsModuleConfiguration. Defaults to currently active configuration settings, if any.
        $Configuration = $(
            if ($script.Atws.integrationsValue) {
                $Script:Atws.Configuration
            }
            else {
                Get-AtwsModuleConfiguration
            }
        ),
    
        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
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
        [String]
        [alias('ProfileName')]
        # A name for your configuration profile. You can specify this name to Connect-AtwsWebApi and swich to
        # another configuration set at runtime, any time you like.
        $Name = 'Default',
        
        [Parameter(Position = 1)]
        [ArgumentCompleter( {
                param($Cmd, $Param, $Word, $Ast, $FakeBound)
                $(Get-ChildItem -Path $Global:AtwsModuleConfigurationPath -Filter "*.clixml").FullName
            })]
        [IO.FileInfo]
        [alias('ProfilePath')]
        $Path = $(Join-Path -Path $Global:AtwsModuleConfigurationPath -ChildPath AtwsConfig.clixml)
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
