<#

    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

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
    $NoDiskCache,
    
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'ConfigurationObject'
    )]
    [ValidateScript( { 
        $requiredProperties = @('Username', 'Securepassword', 'SecureTrackingIdentifier', 'UsePicklistLabels', 'Prefix', 'RefreshCache', 'NoDiskCache')
        $members = Get-Member -InputObject $_ -MemberType NoteProperty
        $missingProperties = Compare-Object -ReferenceObject $requiredProperties -DifferenceObject $members.Name -PassThru -ErrorAction SilentlyContinue
        if (-not($missingProperties)) {
          $true               
        }
        else {
          $missingProperties | ForEach-Object {
            Throw [System.Management.Automation.ValidationMetadataException] "Property: '$_' missing"
          } 
        }
      })]
    [pscustomobject]
    $Configuration
  )
    
  begin { 
    
    # Enable modern -Debug behavior
    if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

    # the $My hashtable is created by autotask.psm1
    $importParams = @{
      Global      = $true
      Version     = $My.ModuleVersion
      Force       = $true
      ErrorAction = 'Stop'
    }

  }
  
  process {
    # Make sure we have a valid configuration before we proceed
    if ($PSCmdlet.ParameterSetName -ne 'ConfigurationObject') {
      $Parameters = @{
        Username                 = $Credential.UserName
        SecurePassword           = $Credential.Password
        SecureTrackingIdentifier = $ApiTrackingIdentifier.Password
        UsePicklistLabels        = $UsePicklistLabels.IsPresent
        Prefix                   = $Prefix
        RefreshCache             = $RefreshCache.IsPresent
        NoDiskCache              = $NoDiskCache.IsPresent
      }
      $Configuration = New-AtwsModuleConfiguration @Parameters
    }

    if (!(Test-AtwsModuleConfiguration -Configuration $Configuration)) {
      throw [System.Configuration.Provider.ProviderException]::New('The module configuration could not be validated.')
      return
    }

    # Question 1: Is the current module in $env:PSModulePath
    $notInPath = $true
    foreach ($dir in $env:PSModulePath -split ';') {
      if ($My.ModuleBase -like "$dir*") {
        $notInPath = $false
      }
    }
  
    if ($notInPath) { 
      # Import the module from its base directory
      $moduleName = $My.ModuleBase
    }
      
    # Unfortunately -Debug and -Verbose is not inherited into the module load, so we have to do a bit of awkward checking
    # It is a hack - we need the parameters to be explicitly shown in $MyInvocation
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
  
  end {
    Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
  }
 
}
