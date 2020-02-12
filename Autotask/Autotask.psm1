<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
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

# Explicit loading of namespace
$namespace = 'Autotask'
. ([scriptblock]::Create("using namespace $namespace"))

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

# Am I being loaded as the Beta version?
if ($MyInvocation.MyCommand.Name -eq 'AutotaskBeta.psm1') {
    $My['IsBeta'] = $true
}
else {
    $My['IsBeta'] = $false
}

# Get all function files as file objects
# Private functions can only be called internally in other functions in the module 

$privateFunction = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue ) 
Write-Debug ('{0}: Found {1} script files in {2}\Private' -F $MyInvocation.MyCommand.Name, $privateFunction.Count, $PSScriptRoot)

# Public functions will be exported with Prefix prepended to the Noun of the function name

$publicFunction = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue ) 
Write-Debug ('{0}: Found {1} script files in {2}\Public' -F $MyInvocation.MyCommand.Name, $publicFunction.Count, $PSScriptRoot)

# Static functions will be exported with Prefix prepended to the Noun of the function name

$staticFunction = @( Get-ChildItem -Path $PSScriptRoot\Static\*.ps1 -ErrorAction SilentlyContinue ) 
Write-Debug ('{0}: Found {1} script files in {2}\Static' -F $MyInvocation.MyCommand.Name, $staticFunction.Count, $PSScriptRoot)

# Static functions will be exported with Prefix prepended to the Noun of the function name

$dynamicFunction = @( Get-ChildItem -Path $PSScriptRoot\Dynamic\*.ps1 -ErrorAction SilentlyContinue ) 
Write-Debug ('{0}: Found {1} script files in {2}\Dynamic' -F $MyInvocation.MyCommand.Name, $dynamicFunction.Count, $PSScriptRoot)


Write-Verbose ('{0}: Importing {1} Private and {2} Public functions.' -F $MyInvocation.MyCommand.Name, $privateFunction.Count, $publicFunction.Count)

# Loop through all supporting script files and source them
foreach ($import in @($privateFunction + $publicFunction)) {
    Write-Debug ('{0}: Importing {1}' -F $MyInvocation.MyCommand.Name, $import)
    try {
        . $import.fullname
    }
    catch {
        throw "Could not import function $($import.fullname): $_"
    }
}

# If they tried to pass any variables
if ($Credential) {
    Write-Verbose ('{0}: Parameters detected. Connecting to Autotask API' -F $MyInvocation.MyCommand.Name)
    Try { 
        if ($Credential -is [pscredential]) {
            ## Legacy
            #  The user passed credentials directly
            $Parameters = @{
                Credential            = $Credential
                ApiTrackingIdentifier = ConvertTo-SecureString $ApiTrackingIdentifier -AsPlainText -Force
                DebugPref             = $DebugPreference
                VerbosePref           = $VerbosePreference
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
            throw [System.Management.Automation.ParameterBindingException]::New()
        }

        ## Connect to the API
        #  or die trying
        . Connect-AtwsWebServices -Configuration $Configuration -Erroraction Stop
    }
    catch {
        $message = "{0}`n`nStacktrace:`n{1}" -f $_, $_.ScriptStackTrace
        throw [System.Configuration.Provider.ProviderException]::New($message)
    
        return
    }
    
    # From now on we should have module variable atws available
    if ($Script:Atws.Configuration.UseDiskCache) {
        
        $dynamicCache = $My['DynamicCache']

        # Locate and load the connection specific script files
        if (Test-Path $dynamicCache) {
            # We have this many dynamic functions distributed with the module
            $FunctionCount = $dynamicFunction.Count
            
            # We have this many dynamic functions in the disc cache
            $dynamicFunction = @( Get-ChildItem -Path $dynamicCache\*atws*.ps1 -ErrorAction SilentlyContinue )
            
            Write-Debug ('{0}: Personal disk cache: Found {1} script files in {2}' -F $MyInvocation.MyCommand.Name, $dynamicFunction.Count, $dynamicCache)
            
            # This is the version string that should be inside every valid function
            $Versionstring = "#Version {0}" -F $My.ModuleVersion
            
            # This is the number of dynamic functions that have the correct version tag
            $ScriptVersion = Select-String -Pattern $Versionstring -Path $dynamicFunction.FullName
            
            # All function files MUST have the correct version and be of the correct version, or they will
            # recreated just to be safe.
            if ($ScriptVersion.Count -ne $FunctionCount) {
                Write-Warning ('{0}: Personal disk cache: Wrong number of script files or scripts are not the right version in {1}, refreshing all entities.' -F $MyInvocation.MyCommand.Name, $dynamicCache)
  
                # Clear out old cache, it will be recreated
                $null = Remove-Item -Path $dynamicFunction.fullname -Force -ErrorAction SilentlyContinue
  
                # Refresh  ALL dynamic entities.
                $entityName = '*' 
            }

            $OldFunctions = @(Get-ChildItem -Path $dynamicCache\*.ps1 -Exclude *Atws* -ErrorAction SilentlyContinue)
            if ($OldFunctions.Count -gt 0) {

                Write-Warning ('{0}: Personal disk cache: Found {1} old script files in {2}. Deleting.' -F $MyInvocation.MyCommand.Name, $OldFunctions.Count, $dynamicCache)
        
                $null = Remove-Item -Path $OldFunctions.fullname -Force -ErrorAction SilentlyContinue
            }
        }
        else {

            Write-Warning ('{0}: Personal disk cache {1} does not exist. Forcing load of all dynamic entities.' -F $MyInvocation.MyCommand.Name, $dynamicCache)
    
            # No personal dynamic cache. Refresh  ALL dynamic entities.
            $entityName = '*'
        }

        # Refresh any entities the caller has ordered
        # We only consider entities that are dynamic
        $Entities = Get-AtwsFieldInfo -Dynamic
        $entitiesToProcess = @()

        Write-Debug ('{0}: {1} dynamic entities are eligible for refresh.' -F $MyInvocation.MyCommand.Name, $dynamicCache)

        foreach ($string in $entityName) {
            Write-Debug ('{0}: Selecting entities that match pattern "{1}"' -F $MyInvocation.MyCommand.Name, $string)
      
            $entitiesToProcess += $Entities.GetEnumerator().Where( { $_.Key -like $string })
        }
        # Prepare index for progressbar
        $index = 0
        $progressParameters = @{
            Activity = 'Updating diskcache for requested entities.'
            Id       = 10
        }

        # Make sure we only check each possible entity once
        $entitiesToProcess = $entitiesToProcess | Sort-Object -Property Name -Unique

        Write-Debug ('{0}: {1} entities have been selected for refresh' -F $MyInvocation.MyCommand.Name, $entitiesToProcess.Count)
  

        foreach ($entityToProcess in $entitiesToProcess) {
            $index++
            $percentComplete = $index / $entitiesToProcess.Count * 100

            # Add parameters for @splatting
            $progressParameters['PercentComplete'] = $percentComplete
            $progressParameters['Status'] = 'Entity {0}/{1} ({2:n0}%)' -F $index, $entitiesToProcess.Count, $percentComplete
            $progressParameters['CurrentOperation'] = 'Getting fieldinfo for {0}' -F $entityToProcess.Name

            Write-Progress @progressParameters

            $null = Get-AtwsFieldInfo -Entity $entityToProcess.Key -UpdateCache
        }

        if ($entitiesToProcess.Count -gt 0) { 
            Write-Debug ('{0}: Calling Import-AtwsCmdLet with {1} entities to process' -F $MyInvocation.MyCommand.Name, $entitiesToProcess.Count)
  
            # Recreate functions that have been updated
            Import-AtwsCmdLet -Entities $entitiesToProcess

            # Re-read Dynamic functions
            $dynamicFunction = @( Get-ChildItem -Path $dynamicCache\*atws*.ps1 -ErrorAction SilentlyContinue ) 

            Write-Debug ('{0}: Personal disk cache: Found {1} script files in {2}' -F $MyInvocation.MyCommand.Name, $dynamicFunction.Count, $dynamicCache)
        }
    }

    Write-Verbose ('{0}: Importing {1} Static and {2} Dynamic functions.' -F $MyInvocation.MyCommand.Name, $staticFunction.Count, $dynamicFunction.Count)
  
    # Loop through all script files and source them
    foreach ($import in @($staticFunction + $dynamicFunction)) {
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

    # Explicitly export static functions
    Write-Verbose ('{0}: Exporting {1} Static functions.' -F $MyInvocation.MyCommand.Name, $staticFunction.Count)
    Export-ModuleMember -Function $staticFunction.Basename

    # Explicitly export dynamic functions
    Write-Verbose ('{0}: Exporting {1} Dynamic functions.' -F $MyInvocation.MyCommand.Name, $dynamicFunction.Count)
    Export-ModuleMember -Function $dynamicFunction.Basename
}
else {
    Write-Verbose 'No Credentials were passed with -ArgumentList. Loading module without any connection to Autotask Web Services. Use Connect-AtwsWebAPI to connect.'
    Export-ModuleMember -Function 'Connect-AtwsWebAPI'
}


# Backwards compatibility since we are now trying to use consistent naming
Set-Alias -Scope Global -Name 'Connect-AutotaskWebAPI' -Value 'Connect-AtwsWebAPI'


# Restore Previous preference
if ($oldVerbosePreference -ne $VerbosePreference) {
    Write-Debug ('{0}: Restoring old Verbose preference' -F $MyInvocation.MyCommand.Name)
    $VerbosePreference = $oldVerbosePreference
}
if ($oldDebugPreference -ne $DebugPreference) {
    Write-Debug ('{0}: Restoring old Debug preference' -F $MyInvocation.MyCommand.Name)
    $DebugPreference = $oldDebugPreference
}