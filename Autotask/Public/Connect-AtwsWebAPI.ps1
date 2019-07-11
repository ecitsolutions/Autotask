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
      Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $String
      .NOTES
      NAME: Connect-AtwsWebAPI
  #>
	
  [cmdletbinding(
      SupportsShouldProcess = $True,
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
    [String]
    $ApiTrackingIdentifier,
    
    [Parameter(
        ParameterSetName = 'Default'
    )]
    [Parameter(
        ParameterSetName = 'NoDiskCache'
    )]
    [Alias('Picklist')]
    [Switch]
    $UsePicklistLabels,
    
    [Parameter(
        ParameterSetName = 'Default'
    )]
    [Parameter(
        ParameterSetName = 'NoDiskCache'
    )]
    [ValidatePattern('[a-zA-Z0-9]')]
    [ValidateLength(1, 8)]
    [String]
    $Prefix,

    [Parameter(
        ParameterSetName = 'Default'
    )]
    [Switch]
    $RefreshCache,

    
    [Parameter(
        ParameterSetName = 'NoDiskCache'
    )]
    [Switch]
    $NoDiskCache
  )
    
  Begin { 
    
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
    # The module is already loaded. It has to be, or this function would not be in
    # the users scope.
    $ModuleName = $MyInvocation.MyCommand.Module.Name
    
    # Store parameters to global variables. Force-reloading the module destroys this scope.
    $Global:AtwsCredential = $Credential
    $Global:AtwsApiTrackingIdentifier = $ApiTrackingIdentifier
    
    # Set Refresh pattern 
    If ($RefreshCache.IsPresent) {
      $Global:AtwsRefreshCachePattern = '*'
    }
    
    # Set No disk cache preference
    If ($NoDiskCache.IsPresent) {
      $Global:AtwsNoDiskCache = $True
    }
    
    # Set Picklist preference
    If ($UsePicklistLabels.IsPresent) {
      $Global:AtwsUsePicklistLabels = $True
    }
    
    
    $ImportParams = @{
      Global = $True
      Version = $MyInvocation.MyCommand.Module.Version
      Force = $True
      ErrorAction = 'Stop'
    }
    
    If ($Prefix) {
      $ImportParams['Prefix'] = $Prefix    
    }



  }
  
  Process {
  
    Try 
    { 
      # First try to re-import the module by name
      
      # Unfortunately -Debug and -Verbose is not inherited into the module load, so we have to do a bit of awkward checking
      If ($DebugPreference -eq 'Continue' -and $VerbosePreference -eq 'Continue') {
        Import-Module -Name $ModuleName @ImportParams -Debug -Verbose
      }
      ElseIf ($DebugPreference -eq 'Continue' -and $VerbosePreference -ne 'Continue') {
        $ImportParams['Verbose'] = $False 
        Import-Module -Name $ModuleName @ImportParams -Debug 
      }
      ElseIf ($DebugPreference -ne 'Continue' -and $VerbosePreference -eq 'Continue') {
        Import-Module -Name $ModuleName @ImportParams -Verbose 
      }
      Else {
        Import-Module -Name $ModuleName @ImportParams 
      }
    }
    Catch 
    {
      # If import by name fails the module has most likely been loaded directly from disk (path)
      # Retry loading the module from its base directory
      $ModulePath = $MyInvocation.MyCommand.Module.ModuleBase
      $ImportParams['ErrorAction'] = 'Continue'
      
      # Unfortunately -Debug and -Verbose is not inherited into the module load, so we have to do a bit of awkward checking
      If ($DebugPreference -eq 'Continue' -and $VerbosePreference -eq 'Continue') {
        Import-Module -Name $ModulePath @ImportParams -Debug -Verbose
      }
      ElseIf ($DebugPreference -eq 'Continue' -and $VerbosePreference -ne 'Continue') {
        $ImportParams['Verbose'] = $False 
        Import-Module -Name $ModulePath @ImportParams -Debug 
      }
      ElseIf ($DebugPreference -ne 'Continue' -and $VerbosePreference -eq 'Continue') {
        Import-Module -Name $ModulePath @ImportParams -Verbose 
      }
      Else {
        Import-Module -Name $ModulePath @ImportParams 
      }

    }
  }
  
  End {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
  }
 
  }
