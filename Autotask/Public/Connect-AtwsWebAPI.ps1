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
                $requiredProperties = @('Username', 'Securepassword', 'SecureTrackingIdentifier', 'ConvertPicklistIdToLabel', 'Prefix', 'RefreshCache', 'DebugPref', 'VerbosePref', 'ErrorLimit')
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
        [alias('Configuration', 'Profile')]
        $AtwsModuleConfiguration,
    
        [Parameter(
            ParameterSetName = 'ConfigurationFile'
        )]
        [ArgumentCompleter( {
                param($Cmd, $Param, $Word, $Ast, $FakeBound)
                $(Get-ChildItem -Path $Script:AtwsModuleConfigurationPath -Filter "*.clixml").FullName
            })]
        [ValidateScript( { 
                Test-Path $_
            })]
        [Alias('Path', 'ProfilePath')]
        [IO.FileInfo]
        $AtwsModuleConfigurationPath = $(Join-Path -Path $Script:AtwsModuleConfigurationPath -ChildPath AtwsConfig.clixml),

        # Name of the Configuration inside the Config file.
        [Parameter(
            ParameterSetName = 'ConfigurationFile'
        )]
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
        [alias('ProfileName', 'Name')]
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
            elseif ($ENV:FUNCTIONS_WORKER_RUNTIME) {
                # We are probably on Azure and in an azure function to boot.    
                # Can be used locally, too, but that is a secret...

                try {
                    $UserName = $ENV:AtwsUserName
                    $PassWord = $ENV:AtwsPassword
                    $SecurePass = $PassWord | ConvertTo-SecureString -AsPlainText -Force
                    $Credential = [System.Management.Automation.PSCredential]::new($UserName, $SecurePass )
                    
                    $TrackingIdentifier = $ENV:AtwsTrackingIdentifier
                    $SecureTrackingIdentifier = $TrackingIdentifier | ConvertTo-SecureString -AsPlainText -Force

                }
                catch {
                    $message = 'Unable to get needed variables and convert them from Azure Function Application Settings. Fix and try again.'
                    throw (New-Object System.Configuration.Provider.ProviderException $message)
                }
                Write-Verbose "We are ettempting to call New-AtwsModuleConfiguration as we now have needed variables from Azure Functions application settings."
                
                $ConfigurationData = New-AtwsModuleConfiguration -Credential $Credential -SecureTrackingIdentifier $SecureTrackingIdentifier 

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
                    $SecureIdentifier = $SecureIdentifier | ConvertTo-SecureString -AsPlainText -Force
                }
                catch {
                    $message = "Could not a variable with name 'AtwsDefaultSecureIdentifier'. Create and run again."
                    throw (New-Object System.Configuration.Provider.ProviderException $message) 
                    return
                }

                $ConfigurationData = New-AtwsModuleConfiguration -Credential $Credential -SecureTrackingIdentifier $SecureIdentifier

            }
            elseif ($PSCmdlet.ParameterSetName -eq 'ConfigurationFile') {
                
                if (Test-Path $AtwsModuleConfigurationPath) {
                    # Read the file.
                    $settings = Import-Clixml -Path $AtwsModuleConfigurationPath
                    if (-not $settings.ContainsKey($AtwsModuleConfigurationName)) {
                        $message = "Configuration file with path: $Path could not be validated. A profile with name: $AtwsModuleConfigurationName does not exist."
                        throw (New-Object System.Configuration.Provider.ProviderException $message) 
                    }elseif($settings.keys.count -eq 0){
                        $message = "Configuration file with path: $Path could not be validated. There are no profiles in this file. Delete it."
                        throw (New-Object System.Configuration.Provider.ProviderException $message) 
                    }

                    $ConfigurationData = $settings[$AtwsModuleConfigurationName]
                    
                    if (-not (Test-AtwsModuleConfiguration -Configuration $ConfigurationData )) {
                        $message = "Configuration file $Path could not be validated. A connection could not be made."
                        throw (New-Object System.Configuration.Provider.ProviderException $message) 
                    }
                }else {
                    $message = "Configuration file with path: $Path could not be validated. A connection could not be made. Run Connect-AtwsWebAPI First!!"
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
