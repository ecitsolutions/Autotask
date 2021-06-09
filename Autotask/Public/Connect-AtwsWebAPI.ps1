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
            Nothing
        .OUTPUTS
            Nothing
        .EXAMPLE
            Connect-AtwsWebAPI
            If there doesn't exist any saved Default connection profile it prompts for a username and password and authenticates to Autotask. Otherwise it loads the connection profile named "Default" and connects.
        .EXAMPLE
            Connect-AtwsWebAPI -ProfileName Sandbox
            Loads the connection profile named 'Sandbox' and connects. If there are no saved connection profile called 'Sandbox' it throws an exception and exits.
        .EXAMPLE
            Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $ApiKey
            Connects to Autotask using the credentials passed as parameters
        .EXAMPLE
            New-AtwsModuleConfiguration -Credential $Credential -ApiTrackingIdentifier $ApiKey -Dateconversion Disabled | Connect-AtwsWebAPI
            Creates a new module configuration object with date conversion between EST (the Autotask API always uses EST no matter which data center you are connected to) and local time disabled.
        .NOTES
            Related commands:
            New-AtwsModuleConfiguration
            Save-AtwsModuleConfiguration
            Set-AtwsModuleConfiguration
            Get-AtwsModuleConfiguration
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
        # The username and password for your Autotask API user
        $Credential,
    
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Parameters'
        )]
        [string]
        # The API tracking identifier from your Autotask API user
        $ApiTrackingIdentifier,
    
        [Parameter(
            ParameterSetName = 'Parameters'
        )]
        [Alias('Picklist', 'UsePickListLabels')]
        [switch]
        # Have the module substitute all picklist ids for their textlabel at runtime
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
        # Not used. Kept for backwards compatility. Will be removed soon.
        $Prefix,

        [Parameter(
            ParameterSetName = 'Parameters'
        )]
        [switch]
        # Not used. Kept for backwards compatility. Will be removed soon.
        $RefreshCache,

    
        [Parameter(
            ParameterSetName = 'Parameters'
        )]
        [switch]
        # Not used. Kept for backwards compatility. Will be removed soon.
        $NoDiskCache,
    
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'ConfigurationObject'
        )]
        [ValidateScript( { 
                $requiredProperties = @('Username', 'Securepassword', 'SecureTrackingIdentifier', 'ConvertPicklistIdToLabel', 'Prefix', 'RefreshCache', 'DebugPref', 'VerbosePref', 'ErrorLimit', 'DateConversion', 'PicklistExpansion', 'UdfExpansion')
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
        # A module configuration object created with New-AtwsModuleConfiguration
        $AtwsModuleConfiguration,
    
        [Parameter(
            ParameterSetName = 'ConfigurationFile'
        )]
        [ArgumentCompleter( {
                param($Cmd, $Param, $Word, $Ast, $FakeBound)
                $(Get-ChildItem -Path $Global:AtwsModuleConfigurationPath -Filter "*.clixml").FullName
            })]
        [ValidateScript( { 
                Test-Path $_
            })]
        [Alias('Path')]
        [IO.FileInfo]
        # The path to an alternate clixml file with connection profiles
        $ProfilePath = $(Join-Path -Path $Global:AtwsModuleConfigurationPath -ChildPath AtwsConfig.clixml),

        # Name of the Configuration inside the Config file.
        [Parameter(
            ParameterSetName = 'ConfigurationFile'
        )]
        [ArgumentCompleter( {
                param($Cmd, $Param, $Word, $Ast, $FakeBound)
                if ($FakeBound.ProfilePath) {
                    [IO.FileInfo]$filepath = $FakeBound.ProfilePath
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
        [alias('Name')]
        # The name for the connection profile you want to use. Default is "Default".
        [string]
        $ProfileName = 'Default'
    )
    
    begin { 
    
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
        Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

    }
  
    process {
        # Make sure we have a valid configuration before we proceed
        # If we didn't get a prepared configuration object, create one from the parameters
        try {
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
                Write-Verbose ('{0}: Calling New-AtwsModuleConfiguration with $parameters splatting' -F $MyInvocation.MyCommand.Name)
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
                Write-Verbose ('{0}: Calling New-AtwsModuleConfiguration with variables from Azure Functions application settings.' -F $MyInvocation.MyCommand.Name)
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
                Write-Verbose ('{0}: Calling New-AtwsModuleConfiguration with variables from Azure Automation resources.' -F $MyInvocation.MyCommand.Name)
                # There are no $DebugPreferences on Azure Automation. Set explicitly to SlientlyContinue to avoid validation error
                $ConfigurationData = New-AtwsModuleConfiguration -Credential $Credential -SecureTrackingIdentifier $SecureIdentifier -DebugPref SilentlyContinue

            }
            elseif ($PSCmdlet.ParameterSetName -eq 'ConfigurationFile') {
                Write-Verbose ('{0}: Calling Get-AtwsModuleConfiguration with profilename {1} and path {2}.' -F $MyInvocation.MyCommand.Name, $ProfileName, $ProfilePath)
            
                if (-not (Test-Path $ProfilePath)) {
                    # Create a new configuration. Prompt for credentials
                    $ConfigurationData = New-AtwsModuleConfiguration 

                    # Prepare shouldProcess comments
                    $caption = 'Save connection credentials'
                    $warning = 'Do you want to save these credentials as your Default connection profile? It will be encrypted using SecureString and encoded in CliXML. See Get-Help Set-AtwsModuleConfiguration for how to modify it.'
                    $question = 'Is it OK to save your credentials to your $Profile folder?'

                    Write-Warning $warning 
                    # Lets do it and say we didn't!
                    if ($PSCmdlet.ShouldContinue($question, $caption)) {
                        Save-AtwsModuleConfiguration -Configuration $ConfigurationData
                    }
                }
                else { 
                    $ConfigurationData = Get-AtwsModuleConfiguration -Name $ProfileName -Path $ProfilePath
                }
            }
            elseif (Test-AtwsModuleConfiguration -Configuration $AtwsModuleConfiguration) {
                # We got a configuration object and it passed validation
                Write-Verbose ('{0}: Calling New-AtwsModuleConfiguration with a configuration object passed on the command line.' -F $MyInvocation.MyCommand.Name)

                $ConfigurationData = $AtwsModuleConfiguration
            }
            else {
                Write-Warning ('{0}: Tried to call New-AtwsModuleConfiguration with a configuration object passed on the command line, but the configuration did not validate properly.' -F $MyInvocation.MyCommand.Name)

            }
        }
        catch {
            # Write a debug message with detailed information to developers
            $reason = ("{0}: {1}" -f $_.CategoryInfo.Category, $_.CategoryInfo.Reason)
            $message = "{2}: {0}`r`n`r`nLine:{1}`r`n`r`nScript stacktrace:`r`n{3}" -f $_.Exception.Message, $_.InvocationInfo.Line, $reason, $_.ScriptStackTrace
            Write-Debug $message

            # Pass on the error
            $PSCmdlet.ThrowTerminatingError($_)
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
