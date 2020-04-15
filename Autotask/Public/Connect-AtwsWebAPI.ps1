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
        [Alias('Picklist','UsePickListLabels')]
        [switch]
        $ConvertPicklistIdToLabel,
    
        [Parameter(
            ParameterSetName = 'Default'
        )]
        [Parameter(
            ParameterSetName = 'NoDiskCache'
        )]
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
                $requiredProperties = @('Username', 'Securepassword', 'SecureTrackingIdentifier', 'ConvertPicklistIdToLabel', 'Prefix', 'RefreshCache', 'NoDiskCache', 'DebugPref', 'VerbosePref')
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
        try { 
            # If we didn't get a prepared configuration object, create one from the parameters
            if ($PSCmdlet.ParameterSetName -ne 'ConfigurationObject') {
                $Parameters = @{
                    Credential               = $Credential
                    SecureTrackingIdentifier = ConvertTo-SecureString $ApiTrackingIdentifier -AsPlainText -Force
                    ConvertPicklistIdToLabel = $ConvertPicklistIdToLabel.IsPresent
                    Prefix                   = $Prefix
                    RefreshCache             = $RefreshCache.IsPresent
                    NoDiskCache              = $NoDiskCache.IsPresent
                    DebugPref                = $DebugPreference
                    VerbosePref              = $VerbosePreference
                }
                # We cannot reuse $configuration variable without triggering the validationscript
                # again
                $ConfigurationData = New-AtwsModuleConfiguration @Parameters
            }
            elseif (Test-AtwsModuleConfiguration -Configuration $Configuration) {
                # We got a configuration object and it passed validation
                $ConfigurationData = $Configuration
            }
        }
        catch {
            $message = "{0}`nStacktrace:`n{1}" -f $_, $_.ScriptStackTrace
            throw (New-Object System.Configuration.Provider.ProviderException $message)
            
            return
        }

        # Question 1: Is the current module in $env:PSModulePath
        $notInPath = $true
        $separator = if ($IsMacOS -or $IsLinux) { ':' } else { ';' }
        foreach ($dir in $env:PSModulePath -split $separator) { # Separator can be both ; and : depending on platform
            if ($My.ModuleBase -like "$dir*") {
                $notInPath = $false
            }
        }
  
        if ($notInPath) { 
            # Import the module from its base directory
            $moduleName = $My.ModuleBase
        }
        else {
            # Import by module name
            $moduleName = $MyInvocation.MyCommand.ModuleName
        }
      
        # Reload the module with configuration 
        Try { 
            Import-Module -Name $moduleName @importParams -ArgumentList $ConfigurationData
        }
        catch { 
            Write-Host ('ERROR: {0}' -f $_.Exception.Message) -ForegroundColor Red
        }
        
    }
  
    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    }
 
}
