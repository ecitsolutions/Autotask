<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md  for license information.

#>

Function Connect-AtwsWebAPI {
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
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Low',
        DefaultParameterSetName = 'Default'
    )]
    Param
    (
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Default'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'NoDiskCache'
        )]
        [ValidateNotNullOrEmpty()]    
        [pscredential]
        $Credential,
    
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Default'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'NoDiskCache'
        )]
        [string]
        $ApiTrackingIdentifier,
    
        [Parameter(
            ParameterSetName = 'Default'
        )]
        [Parameter(
            ParameterSetName = 'NoDiskCache'
        )]
        [Alias('Picklist')]
        [switch]
        $UsePicklistLabels,
    
        [Parameter(
            ParameterSetName = 'Default'
        )]
        [Parameter(
            ParameterSetName = 'NoDiskCache'
        )]
        [ValidatePattern('[a-zA-Z0-9]')]
        [ValidateLength(1, 8)]
        [string]
        $Prefix,

        [Parameter(
            ParameterSetName = 'Default'
        )]
        [switch]
        $RefreshCache,

    
        [Parameter(
            ParameterSetName = 'NoDiskCache'
        )]
        [switch]
        $NoDiskCache
    )
    
    begin { 
    
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
        # The module is already loaded. It has to be, or this function would not be in
        # the users scope.
        $moduleName = $MyInvocation.MyCommand.Module.Name
    
        # Store parameters to global variables. Force-reloading the module destroys this scope.
        $Global:AtwsCredential = $Credential
        $Global:AtwsApiTrackingIdentifier = $ApiTrackingIdentifier
    
        # Set Refresh pattern 
        if ($RefreshCache.IsPresent) {
            $Global:AtwsRefreshCachePattern = '*'
        }
    
        # Set No disk cache preference
        if ($NoDiskCache.IsPresent) {
            $Global:AtwsNoDiskCache = $true
        }
    
        # Set Picklist preference
        if ($UsePicklistLabels.IsPresent) {
            $Global:AtwsUsePicklistLabels = $true
        }
    
    
        $importParams = @{
            Global      = $true
            Version     = $MyInvocation.MyCommand.Module.Version
            Force       = $true
            ErrorAction = 'Stop'
        }
    
        if ($Prefix) {
            $importParams['Prefix'] = $Prefix    
        }



    }
  
    process {
  
        try { 
            # First try to re-import the module by name
      
            # Unfortunately -Debug and -Verbose is not inherited into the module load, so we have to do a bit of awkward checking
            if ($DebugPreference -eq 'Continue' -and $VerbosePreference -eq 'Continue') {
                Import-Module -Name $moduleName @importParams -Debug -Verbose
            }
            elseif ($DebugPreference -eq 'Continue' -and $VerbosePreference -ne 'Continue') {
                $importParams['Verbose'] = $false 
                Import-Module -Name $moduleName @importParams -Debug 
            }
            elseif ($DebugPreference -ne 'Continue' -and $VerbosePreference -eq 'Continue') {
                Import-Module -Name $moduleName @importParams -Verbose 
            }
            else {
                Import-Module -Name $moduleName @importParams 
            }
        }
        catch {
            # If import by name fails the module has most likely been loaded directly from disk (path)
            # Retry loading the module from its base directory
            $modulePath = $MyInvocation.MyCommand.Module.ModuleBase
            $importParams['ErrorAction'] = 'Continue'
      
            # Unfortunately -Debug and -Verbose is not inherited into the module load, so we have to do a bit of awkward checking
            if ($DebugPreference -eq 'Continue' -and $VerbosePreference -eq 'Continue') {
                Import-Module -Name $modulePath @importParams -Debug -Verbose
            }
            elseif ($DebugPreference -eq 'Continue' -and $VerbosePreference -ne 'Continue') {
                $importParams['Verbose'] = $false 
                Import-Module -Name $modulePath @importParams -Debug 
            }
            elseif ($DebugPreference -ne 'Continue' -and $VerbosePreference -eq 'Continue') {
                Import-Module -Name $modulePath @importParams -Verbose 
            }
            else {
                Import-Module -Name $modulePath @importParams 
            }

        }
    }
  
    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    }
 
}
