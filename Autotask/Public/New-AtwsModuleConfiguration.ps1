<#

    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

#>

Function New-AtwsModuleConfiguration {
    <#
            .SYNOPSIS
            This function re-loads the module with the correct parameters for full functionality
            .DESCRIPTION
            This function is a wrapper that is included for backwards compatibility with previous module behavior.
            These parameters should be passed to Import-Module -Variable directly, but previously the module 
            consisted of two, nested modules. Now there is a single module with all functionality.
            .INPUTS
            A PSCredential object. Required. 
            A string used as ApiTrackingIdentifier. Required. 
            .OUTPUTS
            Nothing.
            .EXAMPLE
            Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $string
            .NOTES
            NAME: Connect-AtwsWebAPI
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
        $VerbosePref = $VerbosePreference
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
        return $configuration
    }
 
}
