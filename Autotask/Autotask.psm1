<#
    .COPYRIGHT
    Copyright (c) Hugo Klemmestad. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.
#>

[CmdletBinding(
    PositionalBinding = $false
)]
Param(
    [Parameter(
        Position = 0
    )]
    [pscustomobject]
    $Credential,

    [Parameter(
        Position = 1
    )]
    [string]
    $ApiTrackingIdentifier,

    [Parameter(
        Position = 2,
        ValueFromRemainingArguments = $true
    )]
    [string[]]
    $entityName
)

Write-Debug ('{0}: Start of module import' -F $MyInvocation.MyCommand.Name)

# Special consideration for -Verbose, as there is no $PSCmdLet context to check if Import-Module was called using -Verbose
# and $VerbosePreference is not inherited from Import-Module for some reason.

# Remove comments
$parentCommand = ($MyInvocation.Line -split '#')[0]

# Store Previous preference
$oldVerbosePreference = $VerbosePreference
if ($parentCommand -like '*-Verbose*') {
    Write-Debug ('{0}: Verbose preference detected. Verbose messages ON.' -F $MyInvocation.MyCommand.Name)
    $VerbosePreference = 'Continue'
}
$oldDebugPreference = $DebugPreference
if ($parentCommand -like '*-Debug*') {
    Write-Debug ('{0}: Debug preference detected. Debug messages ON.' -F $MyInvocation.MyCommand.Name)
    $DebugPreference = 'Continue'
}

# Read our own manifest to access configuration data
$manifestFileName = $MyInvocation.MyCommand.Name -replace 'pdm1$', 'psd1'
$manifestDirectory = Split-Path $MyInvocation.MyCommand.Path -Parent

Write-Debug ('{0}: Loading Manifest file {1} from {2}' -F $MyInvocation.MyCommand.Name, $manifestFileName, $manifestDirectory)

Import-LocalizedData -BindingVariable My -FileName $manifestFileName -BaseDirectory $manifestDirectory

# Add module path to manifest variable
$My['ModuleBase'] = $manifestDirectory

# The location $profile is only available on desktop and possibly Azure Runbooks. Not on 
# Azure Functions. Find a valid location for a configuration profile 
if ($profile) {
    # Use $profile if it exsist
    $Global:AtwsModuleConfigurationPath = $(Split-Path -Parent $profile)
    New-Variable -Name AtwsModuleTest -Value $(Split-Path -Parent $profile) -Option Constant
}
elseIf ($env:TEMP) {
    # Use $temp. The file will most likely never be used if not on desktop anyway
    $Global:AtwsModuleConfigurationPath = $env:TEMP 
}
elseIf ($env:TMPDIR) {
    # Use $temp. The file will most likely never be used if not on desktop anyway
    $Global:AtwsModuleConfigurationPath = $env:TMPDIR
}
else {
    # Use $temp. The file will most likely never be used if not on desktop anyway
    $Global:AtwsModuleConfigurationPath = $env:PWD
}

# Get all function files as file objects
# Private functions can only be called internally in other functions in the module

$privateFunction = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
Write-Debug ('{0}: Found {1} script files in {2}\Private' -F $MyInvocation.MyCommand.Name, $privateFunction.Count, $PSScriptRoot)

# Public functions will be exported with Prefix prepended to the Noun of the function name

$publicFunction = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
Write-Debug ('{0}: Found {1} script files in {2}\Public' -F $MyInvocation.MyCommand.Name, $publicFunction.Count, $PSScriptRoot)

# Entity functions will be exported with Prefix prepended to the Noun of the function name
$entityFunction = @( Get-ChildItem -Path $PSScriptRoot\Functions\*.ps1 -ErrorAction SilentlyContinue )
Write-Debug ('{0}: Found {1} script files in {2}\Functions' -F $MyInvocation.MyCommand.Name, $entityFunction.Count, $PSScriptRoot)

Write-Verbose ('{0}: Importing {1} Private, {2} Public functions and {3} entity functions.' -F $MyInvocation.MyCommand.Name, $privateFunction.Count, $publicFunction.Count, $entityFunction.count)

# Loop through all supporting script files and source them
foreach ($import in @($privateFunction + $publicFunction + $entityFunction)) {
    Write-Debug ('{0}: Importing {1}' -F $MyInvocation.MyCommand.Name, $import)
    try {
        . $import.fullname
    }
    catch {
        throw "Could not import function $($import.fullname): $_"
    }
}

# Explicitly export public functions
Write-Verbose ('{0}: Exporting {1} Public functions.' -F $MyInvocation.MyCommand.Name, $publicFunction.Count)
Export-ModuleMember -Function $publicFunction.Basename

# Explicitly export entity functions
Write-Verbose ('{0}: Exporting {1} Entity functions.' -F $MyInvocation.MyCommand.Name, $publicFunction.Count)
Export-ModuleMember -Function $entityFunction.Basename

# Set to $true for explicit export of private functions. For debugging purposes only
if ($false){
    # Explicitly export private functions
    Write-Verbose ('{0}: Exporting {1} Private functions.' -F $MyInvocation.MyCommand.Name, $privateFunction.Count)
    Export-ModuleMember -Function $privateFunction.Basename
}

# Backwards compatibility since we are now trying to use consistent naming
Set-Alias -Scope Global -Name 'Connect-AutotaskWebAPI' -Value 'Connect-AtwsWebAPI'

# Import service reference and bindings
# Load support for TLS 1.2 if the Service Point Manager haven't loaded it yet
# This is now a REQUIREMENT to talk to the API endpoints
$Protocol = [System.Net.ServicePointManager]::SecurityProtocol
if ($Protocol.Tostring() -notlike '*Tls12*') {
    [System.Net.ServicePointManager]::SecurityProtocol += [System.Net.SecurityProtocolType]::Tls1
    2
}

# Path to web service reference
$code = '{0}\Private\Reference.cs' -f $My['ModuleBase']

# List of needed assemblies for Powershell 5.1
$assemblies = @(
    'System.ServiceModel'
    'System.ServiceModel.Duplex'
    'System.ServiceModel.Http'
    'System.ServiceModel.NetTcp'
    'System.ServiceModel.Security'
    'System.Diagnostics.Debug'
    'System.Xml'
    'System.Xml.ReaderWriter'
    'System.Runtime.Serialization'
)
# For Powershell versions 6 and higher, add these assemblies
if ($PSVersionTable.PSVersion.Major -ge 6) {
    $assemblies += @(
        'netstandard'
        'System.Xml.XmlSerializer'
        'System.Runtime.Serialization.Xml'
        'System.ServiceModel.Primitives'
        'System.Private.ServiceModel'
        'System.Diagnostics.Tools'
    )
}

# For Powershell versions 7.3.1 and higher, add this assembly
$threshold = New-Object System.Version("7.3.0")
if ($PSVersionTable.PSVersion -gt $threshold) {
    $assemblies += @(
        'Microsoft.Bcl.AsyncInterfaces'
    )
}

# Compile webserviceinfo (Reference.cs) and instantiate a SOAP client
if ([appdomain]::CurrentDomain.GetAssemblies().exportedtypes.name -notcontains "ATWSSoap") {
    Add-Type -TypeDefinition (Get-Content -raw $code) -ReferencedAssemblies $assemblies
}
# Load the cache from disk
Initialize-AtwsRamCache

# See if they tried to pass any variables
if ($Credential) {
    Write-Verbose ('{0}: Parameters detected. Connecting to Autotask API' -F $MyInvocation.MyCommand.Name)

    Try {
        if ($Credential -is [pscredential]) {
            ## Legacy
            #  The user passed credentials directly
            $Parameters = @{
                Credential               = $Credential
                SecureTrackingIdentifier = ConvertTo-SecureString $ApiTrackingIdentifier -AsPlainText -Force
                DebugPref                = $DebugPreference
                VerbosePref              = $VerbosePreference
            }
            $Configuration = New-AtwsModuleConfiguration @Parameters
        }
        elseif (Test-AtwsModuleConfiguration -Configuration $Credential) {
            ## First parameter was a valid configuration object
            $Configuration = $Credential

            # Switch to configured debug and verbose preferences
            $VerbosePreference = $Configuration.VerbosePref
            $DebugPreference = $Configuration.DebugPref
        }
        else {
            throw (New-Object System.Management.Automation.ParameterBindingException)
        }

        ## Connect to the API
        #  or die trying
        . Connect-AtwsWebServices -Configuration $Configuration -Erroraction Stop
    }
    catch {
        $message = "{0}`n`nStacktrace:`n{1}" -f $_, $_.ScriptStackTrace
        throw (New-Object System.Configuration.Provider.ProviderException $message)

        return
    }

    # From now on we should have module variable atws available
}
else {
    Write-Verbose 'No Credentials were passed with -ArgumentList. Loading module without any connection to Autotask Web Services. Use Connect-AtwsWebAPI to connect.'
}

# Clean out old cache data
# On Windows we store the cache in the WindowsPowerhell folder in My documents
# On macOS and Linux we use a dot-folder in the users $HOME folder as is customary
# if ([Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([Runtime.InteropServices.OSPlatform]::Windows)) {
#     $PersonalCacheDir = Join-Path $([environment]::GetFolderPath('MyDocuments')) 'WindowsPowershell\Cache'
# }
# else {
#     $PersonalCacheDir = Join-Path $([environment]::GetFolderPath('MyDocuments')) '.config\powershell\atwsCache'
# }

# Restore Previous preference
if ($oldVerbosePreference -ne $VerbosePreference) {
    Write-Debug ('{0}: Restoring old Verbose preference' -F $MyInvocation.MyCommand.Name)
    $VerbosePreference = $oldVerbosePreference
}
if ($oldDebugPreference -ne $DebugPreference) {
    Write-Debug ('{0}: Restoring old Debug preference' -F $MyInvocation.MyCommand.Name)
    $DebugPreference = $oldDebugPreference
}