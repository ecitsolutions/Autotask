<#
    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md  for license information.
#>

[CmdletBinding()]
Param(
    [Parameter(
        Position = 0
    )]
    [pscredential]
    $Credential = $Global:AtwsCredential,
    
    [Parameter(
        Position = 1  
    )]
    [string]
    $ApiTrackingIdentifier = $Global:AtwsApiTrackingIdentifier,

    [Parameter(
        Position = 2,
        ValueFromRemainingArguments = $true
    )]
    [string[]]
    $entityName = $Global:AtwsRefreshCachePattern
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

# Am I being loaded as the Beta version?
if ($MyInvocation.MyCommand.Name -eq 'AutotaskBeta.psm1') {
    $Script:IsBeta = $true
}



# Read our own manifest to access configuration data
$manifestFileName = $MyInvocation.MyCommand.Name -replace 'pdm1$', 'psd1'
$manifestDirectory = Split-Path $MyInvocation.MyCommand.Path -Parent

Write-Debug ('{0}: Loading Manifest file {1} from {2}' -F $MyInvocation.MyCommand.Name, $manifestFileName, $manifestDirectory)

Import-LocalizedData -BindingVariable My -FileName $manifestFileName -BaseDirectory $manifestDirectory

# Add module path to manifest variable
$My['ModuleBase'] = $manifestDirectory

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

# Loop through all script files and source them
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
if (($Credential) -or ($ApiTrackingIdentifier)) {
    Write-Verbose ('{0}: Credentials detected. Connecting to Autotask API' -F $MyInvocation.MyCommand.Name)
    
    # Remove Global variables (if used) for security
    $MyGlobalVars = Get-Variable -Scope Global -ErrorAction SilentlyContinue
    $targetVarNames = 'AtwsCredential', 'AtwsApiTrackingIdentifier', 'AtwsRefreshCachePattern', 'AtwsUsePicklistLabels', 'AtwsNoDiskCache'
    $connectArgs = @{
        Credential            = $Credential
        ApiTrackingIdentifier = $ApiTrackingIdentifier
    }
    switch ($MyGlobalVars | Where-Object { $_.Name -in $targetVarNames }) {
        { $_.Name -eq 'AtwsCredential' } {
            Write-Debug ('{0}: Credentials for {1} detected.' -F $MyInvocation.MyCommand.Name, $AtwsCredential.UserName)

            # Remove Global Object, credentials are now stored in a variable internal to the module
      
            Remove-Variable -Name $_.Name -Scope Global
    
            continue
        }
        { $_.Name -eq 'AtwsApiTrackingIdentifier' } {
            Write-Debug ('{0}: API tracking identifier for {1} detected.' -F $MyInvocation.MyCommand.Name, $AtwsCredential.UserName)

            # Remove Global Object, credentials are now stored in a variable internal to the module
    
            Remove-Variable -Name AtwsApiTrackingIdentifier -Scope Global
    
            continue
        }
        { $_.Name -eq 'AtwsRefreshCachePattern' } {
            Write-Debug ('{0}: Refreshing disk cache by force' -F $MyInvocation.MyCommand.Name)

            # Remove Global Object
    
            Remove-Variable -Name AtwsRefreshCachePattern -Scope Global
    
            continue
        }
        { $_.Name -eq 'AtwsUsePicklistLabels' } {
            Write-Debug ('{0}: Converting picklistvalues to their labels are turned ON' -F $MyInvocation.MyCommand.Name)

            $Script:UsePickListLabels = $true
    
            # Remove Global Object
    
            Remove-Variable -Name AtwsUsePicklistLabels -Scope Global

            continue
        }
        { $_.Name -eq 'AtwsNoDiskCache' } {
            Write-Debug ('{0}: Force No disk cache detected. All functions are loaded from the scripts supplied by the module.' -F $MyInvocation.MyCommand.Name)
            Write-Verbose ('{0}: Force No disk cache detected. All functions are loaded from the scripts supplied by the module.' -F $MyInvocation.MyCommand.Name)
        
            # Remove Global Object, credentials are now stored in a variable internal to the module
            Remove-Variable -Name AtwsNoDiskCache -Scope Global
  
            # Add the NoDiskCache switch to the splatted arguments we will use to connect
            $connectArgs['NoDiskCache'] = $true
        }
        default { }
    }
    # Connect to the API using required, additional parameters, using internal function name
    . Connect-AtwsWebServices @connectArgs
    if (!$connectArgs['NoDiskCache']) {
        if ($isBeta) { 
            $dynamicCache = '{0}\WindowsPowershell\Cache\{1}\Beta' -f $([environment]::GetFolderPath('MyDocuments')), $Script:Atws.CI
        }
        else {
            $dynamicCache = '{0}\WindowsPowershell\Cache\{1}\Dynamic' -f $([environment]::GetFolderPath('MyDocuments')), $Script:Atws.CI
        }
        if (Test-Path $dynamicCache) {
            $FunctionCount = $dynamicFunction.Count
            $dynamicFunction = @( Get-ChildItem -Path $dynamicCache\*atws*.ps1 -ErrorAction SilentlyContinue )
            Write-Debug ('{0}: Personal disk cache: Found {1} script files in {2}' -F $MyInvocation.MyCommand.Name, $dynamicFunction.Count, $dynamicCache)
      
            $Versionstring = "#Version {0}" -F $My.ModuleVersion
            $ScriptVersion = Select-String -Pattern $Versionstring -Path $dynamicFunction.FullName
            if ($ScriptVersion.Count -ne $FunctionCount) {
                Write-Debug ('{0}: Personal disk cache: Wrong number of script files or scripts are not the right version in {1}, refreshing all entities.' -F $MyInvocation.MyCommand.Name, $dynamicCache)
  
                # Clear out old cache, it will be recreated
                $null = Remove-Item -Path $dynamicFunction.fullname -Force -ErrorAction SilentlyContinue
  
                # Refresh  ALL dynamic entities.
                $entityName = '*' 
            }

            $OldFunctions = @(Get-ChildItem -Path $dynamicCache\*.ps1 -Exclude *Atws* -ErrorAction SilentlyContinue)
            if ($OldFunctions.Count -gt 0) {

                Write-Debug ('{0}: Personal disk cache: Found {1} old script files in {2}. Deleting.' -F $MyInvocation.MyCommand.Name, $OldFunctions.Count, $dynamicCache)
        
                $null = Remove-Item -Path $OldFunctions.fullname -Force -ErrorAction SilentlyContinue
            }
        }
        else {

            Write-Debug ('{0}: Personal disk cache {1} does not exist. Forcing load of all dynamic entities.' -F $MyInvocation.MyCommand.Name, $dynamicCache)
    
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
    Write-Debug ('{0}: Exporting {1} Public functions.' -F $MyInvocation.MyCommand.Name, $publicFunction.Count) 
    Export-ModuleMember -Function $publicFunction.Basename

    # Explicitly export static functions
    Write-Debug ('{0}: Exporting {1} Static functions.' -F $MyInvocation.MyCommand.Name, $staticFunction.Count)
    Export-ModuleMember -Function $staticFunction.Basename

    # Explicitly export dynamic functions
    Write-Debug ('{0}: Exporting {1} Dynamic functions.' -F $MyInvocation.MyCommand.Name, $dynamicFunction.Count)
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