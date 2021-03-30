<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

#>

Function Connect-AtwsWebAPI {
    <#
        .SYNOPSIS
            This function connects to the Autotask Web Services API, authenticates a user and creates a 
            SOAP webservices proxy object. 
        .DESCRIPTION
            The function takes a credential object and uses it to authenticate and connect to the Autotask
            Web Services API. This is done by creating a webservices proxy. The proxy object imports the SOAP 
            WSDL definition file, creates all entity classes in PowerShell and exposes the basic methods
            (query(), create(), update(), remove(), GetEntityInfo(), GetFieldInfo() and a few more). 
        .INPUTS
            A PSCredential object. Required. It will prompt for credentials if the object is not provided.
        .OUTPUTS
            A webserviceproxy object is created.
        .EXAMPLE
            Connect-AtwsWebAPI
            Prompts for a username and password and authenticates to Autotask
        .EXAMPLE
            Connect-AtwsWebAPI
        .NOTES
            NAME: Connect-AtwsWebAPI
        .LINK
            Get-AtwsData
  #>
	
    [cmdletbinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Low',
        DefaultParameterSetName = 'ConfigurationFile'
    )]
    Param
    (
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Parameters'
        )]
        [ValidateNotNullOrEmpty()]    
        [pscredential]
        $Credential,
    
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Parameters'
        )]
        [string]
        $ApiTrackingIdentifier,
    
        [Parameter(
            ParameterSetName = 'Parameters'
        )]
        [Alias('Picklist', 'UsePickListLabels')]
        [switch]
        $ConvertPicklistIdToLabel,
    
        [Parameter(
            ParameterSetName = 'Parameters'
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
            ParameterSetName = 'Parameters'
        )]
        [switch]
        $RefreshCache,

    
        [Parameter(
            ParameterSetName = 'Parameters'
        )]
        [switch]
        $NoDiskCache,
    
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'ConfigurationObject'
        )]
        [ValidateScript( { 
                $requiredProperties = @('Username', 'Securepassword', 'SecureTrackingIdentifier', 'ConvertPicklistIdToLabel', 'Prefix', 'RefreshCache', 'DebugPref', 'VerbosePref')
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
        [alias('Configuration')]
        $AtwsModuleConfiguration,
    
        [Parameter(
            ParameterSetName = 'ConfigurationFile'
        )]
        [ArgumentCompleter( {
                param($Cmd, $Param, $Word, $Ast, $FakeBound)
                $(Get-ChildItem -Path $(Split-Path -Parent $profile) -Filter "*.clixml").FullName
            })]
        [ValidateScript( { 
                Test-Path $_
            })]
        [Alias('Path')]
        [IO.FileInfo]
        $AtwsModuleConfigurationPath = $(Join-Path -Path $(Split-Path -Parent $profile) -ChildPath AtwsConfig.clixml),

        [Parameter(
            ParameterSetName = 'ConfigurationFile'
        )]
        [alias('Name')]
        [string]
        $AtwsModuleConfigurationName = 'Default'
    )
    
    begin { 
    
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
        Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

    }
  
    process {
        # Make sure we have a valid configuration before we proceed
        try { 
            # If we didn't get a prepared configuration object, create one from the parameters
            if ($PSCmdlet.ParameterSetName -eq 'Parameters') {
                $Parameters = @{
                    Credential               = $Credential
                    SecureTrackingIdentifier = ConvertTo-SecureString $ApiTrackingIdentifier -AsPlainText -Force
                    ConvertPicklistIdToLabel = $ConvertPicklistIdToLabel.IsPresent
                    Prefix                   = $Prefix
                    RefreshCache             = $RefreshCache.IsPresent
                    DebugPref                = $DebugPreference
                    VerbosePref              = $VerbosePreference
                }
                # We cannot reuse $configuration variable without triggering the validationscript
                # again
                $ConfigurationData = New-AtwsModuleConfiguration @Parameters
            }
            elseif ($env:AtwsDefaultCredential) {
                # We are probably on Azure and in an azure function to boot.
                # Can be used locally, too, but that is a secret...
                if (-not ($env:AtwsDefaultSecureIdentifier)) {
                    # We really need that secure identifier...
                    $message = "Could not a variable with name 'AtwsDefaultSecureIdentifier'. Create and run again."
                    throw (New-Object System.Configuration.Provider.ProviderException $message) 
                    return
                }

                $ConfigurationData = New-AtwsModuleConfiguration -Credential $env:AtwsDefaultCredential -SecureTrackingIdentifier $env:AtwsDefaultSecureIdentifier

            }
            elseif ($env:AUTOMATION_ASSET_ACCOUNTID ) {
                # We are on Azure. Try to get credentials and api key
                try {
                    $Credential = Get-AutomationPSCredential -Name 'AtwsDefaultCredential'
                }
                catch {
                    $message = "Could not find credentials with name 'AtwsDefaultCredential'. Create and run again."
                    throw (New-Object System.Configuration.Provider.ProviderException $message) 
                    return
                }
                # Now try for API key
                try {
                    $SecureIdentifier = Get-AutomationVariable -Name 'AtwsDefaultSecureIdentifier'
                }
                catch {
                    $message = "Could not a variable with name 'AtwsDefaultSecureIdentifier'. Create and run again."
                    throw (New-Object System.Configuration.Provider.ProviderException $message) 
                    return
                }

                $ConfigurationData = New-AtwsModuleConfiguration -Credential $Credential -SecureTrackingIdentifier $SecureIdentifier

            }
            elseif ($PSCmdlet.ParameterSetName -eq 'ConfigurationFile') {
                
                
                # Read the file. It should exist or parametervalidation should have killed us.
                $settings = Import-Clixml -Path $AtwsModuleConfigurationPath
                $ConfigurationData = $settings[$Name]
                if (-not (Test-AtwsModuleConfiguration -Configuration $ConfigurationData)) {
                    $message = "Configuration file $Path could not be validated. A connection could not be made."
                    throw (New-Object System.Configuration.Provider.ProviderException $message) 
                }
            }
            elseif (Test-AtwsModuleConfiguration -Configuration $AtwsModuleConfiguration) {
                # We got a configuration object and it passed validation
                $ConfigurationData = $AtwsModuleConfiguration
            }
        }
        catch {
            $message = "{0}`nStacktrace:`n{1}" -f $_, $_.ScriptStackTrace
            throw (New-Object System.Configuration.Provider.ProviderException $message)
            
            return
        }

        ## Connect to the API
        #  or die trying
        . Connect-AtwsWebServices -Configuration $ConfigurationData -Erroraction Stop
        
    }
  
    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    }
 
}
