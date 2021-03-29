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
    #>
	
    [cmdletbinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Low'
    )]
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
        [IO.FileInfo]
        $Path = $(Join-Path -Path $(Split-Path -Parent $profile) -ChildPath AtwsConfig.clixml)
    )
    
    begin { 
    
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
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
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: Saving current configuration to {1} as requested.' -F $caption, $path.FullName
        $verboseWarning = '{0}: About to save current configuration to {1}. Do you want to continue?' -F $caption, $path.FullName

        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) {
            Try { 
                # Try to save to the path
                Export-Clixml -InputObject $Configuration -Path $Path.Fullname
            }
            catch {
                $message = "{0}`nStacktrace:`n{1}" -f $_, $_.ScriptStackTrace
                throw (New-Object System.Configuration.Provider.ProviderException $message)
        
                return
            }
        }
    }
  
    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    }
 
}
