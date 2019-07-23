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
    [String]
    $ApiTrackingIdentifier = $Global:AtwsApiTrackingIdentifier,

    [Parameter(
        Position = 2,
        ValueFromRemainingArguments = $True
    )]
    [String[]]
    $EntityName = $Global:AtwsRefreshCachePattern
)

Write-Debug ('{0}: Start of module import' -F $MyInvocation.MyCommand.Name)


# Special consideration for -Verbose, as there is no $PSCmdLet context to check if Import-Module was called using -Verbose
# and $VerbosePreference is not inherited from Import-Module for some reason.

# Remove comments
$ParentCommand = ($MyInvocation.Line -split '#')[0]

# Store Previous preference
$OldVerbosePreference = $VerbosePreference
If ($ParentCommand -like '*-Verbose*') {
    Write-Debug ('{0}: Verbose preference detected. Verbose messages ON.' -F $MyInvocation.MyCommand.Name)
    $VerbosePreference = 'Continue'
}
$OldDebugPreference = $DebugPreference
If ($ParentCommand -like '*-Debug*') {
    Write-Debug ('{0}: Debug preference detected. Debug messages ON.' -F $MyInvocation.MyCommand.Name)
    $DebugPreference = 'Continue'
}

# Am I being loaded as the Beta version?
If ($MyInvocation.MyCommand.Name -eq 'AutotaskBeta.psm1') {
    $Script:IsBeta = $True
}

# Read our own manifest to access configuration data
$ManifestFileName = $MyInvocation.MyCommand.Name -replace 'pdm1$', 'psd1'
$ManifestDirectory = Split-Path $MyInvocation.MyCommand.Path -Parent

Write-Debug ('{0}: Loading Manifest file {1} from {2}' -F $MyInvocation.MyCommand.Name, $ManifestFileName, $ManifestDirectory)


Import-LocalizedData -BindingVariable My -FileName $ManifestFileName -BaseDirectory $ManifestDirectory

# Get all function files as file objects
# Private functions can only be called internally in other functions in the module 

$PrivateFunction = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue ) 
Write-Debug ('{0}: Found {1} script files in {2}\Private' -F $MyInvocation.MyCommand.Name, $PrivateFunction.Count, $PSScriptRoot)

# Public functions will be exported with Prefix prepended to the Noun of the function name

$PublicFunction = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue ) 
Write-Debug ('{0}: Found {1} script files in {2}\Public' -F $MyInvocation.MyCommand.Name, $PublicFunction.Count, $PSScriptRoot)

# Static functions will be exported with Prefix prepended to the Noun of the function name

$StaticFunction = @( Get-ChildItem -Path $PSScriptRoot\Static\*.ps1 -ErrorAction SilentlyContinue ) 
Write-Debug ('{0}: Found {1} script files in {2}\Static' -F $MyInvocation.MyCommand.Name, $StaticFunction.Count, $PSScriptRoot)

# Static functions will be exported with Prefix prepended to the Noun of the function name

$DynamicFunction = @( Get-ChildItem -Path $PSScriptRoot\Dynamic\*.ps1 -ErrorAction SilentlyContinue ) 
Write-Debug ('{0}: Found {1} script files in {2}\Dynamic' -F $MyInvocation.MyCommand.Name, $DynamicFunction.Count, $PSScriptRoot)


Write-Verbose ('{0}: Importing {1} Private and {2} Public functions.' -F $MyInvocation.MyCommand.Name, $PrivateFunction.Count, $PublicFunction.Count)

# Loop through all script files and source them
foreach ($Import in @($PrivateFunction + $PublicFunction)) {
    Write-Debug ('{0}: Importing {1}' -F $MyInvocation.MyCommand.Name, $Import)
    try {
        . $Import.fullname
    }
    catch {
        throw "Could not import function $($Import.fullname): $_"
    }
}

# If they tried to pass any variables
If (($Credential) -or ($ApiTrackingIdentifier)) {
    Write-Verbose ('{0}: Credentials detected. Connecting to Autotask API' -F $MyInvocation.MyCommand.Name)
    
    # Remove Global variables (if used) for security
    $MyGlobalVars = Get-Variable -Scope Global -ErrorAction SilentlyContinue
    $TargetVarNames = 'AtwsCredential', 'AtwsApiTrackingIdentifier', 'AtwsRefreshCachePattern', 'AtwsUsePicklistLabels', 'AtwsNoDiskCache'
    $ConnectArgs = @{
        Credential            = $Credential
        ApiTrackingIdentifier = $ApiTrackingIdentifier
    }
    switch ($MyGlobalVars | Where-Object { $_.Name -in $TargetVarNames }) {
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

            $Script:UsePickListLabels = $True
    
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
            $ConnectArgs['NoDiskCache'] = $true
        }
        default { }
    }
    # Connect to the API using required, additional parameters, using internal function name
    . Connect-AtwsWebServices @ConnectArgs
    if (!$ConnectArgs['NoDiskCache']) {
        If ($IsBeta) { 
          $DynamicCache = '{0}\WindowsPowershell\Cache\{1}\Beta' -f $([environment]::GetFolderPath('MyDocuments')), $Script:Atws.CI
        }
        Else {
          $DynamicCache = '{0}\WindowsPowershell\Cache\{1}\Dynamic' -f $([environment]::GetFolderPath('MyDocuments')), $Script:Atws.CI
        }
        If (Test-Path $DynamicCache) {
            $FunctionCount = $DynamicFunction.Count
            $DynamicFunction = @( Get-ChildItem -Path $DynamicCache\*atws*.ps1 -ErrorAction SilentlyContinue )
            Write-Debug ('{0}: Personal disk cache: Found {1} script files in {2}' -F $MyInvocation.MyCommand.Name, $DynamicFunction.Count, $DynamicCache)
      
            $VersionString = "#Version {0}" -F $My.ModuleVersion
            $ScriptVersion = Select-String -Pattern $VersionString -Path $DynamicFunction.FullName
            If ($ScriptVersion.Count -ne $FunctionCount) {
                Write-Debug ('{0}: Personal disk cache: Wrong number of script files or scripts are not the right version in {1}, refreshing all entities.' -F $MyInvocation.MyCommand.Name, $DynamicCache)
  
                # Clear out old cache, it will be recreated
                $Null = Remove-Item -Path $DynamicFunction.fullname -Force -ErrorAction SilentlyContinue
  
                # Refresh  ALL dynamic entities.
                $EntityName = '*' 
            }

            $OldFunctions = @(Get-ChildItem -Path $DynamicCache\*.ps1 -Exclude *Atws* -ErrorAction SilentlyContinue)
            If ($OldFunctions.Count -gt 0) {

                Write-Debug ('{0}: Personal disk cache: Found {1} old script files in {2}. Deleting.' -F $MyInvocation.MyCommand.Name, $OldFunctions.Count, $DynamicCache)
        
                $Null = Remove-Item -Path $OldFunctions.fullname -Force -ErrorAction SilentlyContinue
            }
        }
        Else {

            Write-Debug ('{0}: Personal disk cache {1} does not exist. Forcing load of all dynamic entities.' -F $MyInvocation.MyCommand.Name, $DynamicCache)
    
            # No personal dynamic cache. Refresh  ALL dynamic entities.
            $EntityName = '*'
        }

        # Refresh any entities the caller has ordered
        # We only consider entities that are dynamic
        $Entities = Get-AtwsFieldInfo -Dynamic
        $EntitiesToProcess = @()

        Write-Debug ('{0}: {1} dynamic entities are eligible for refresh.' -F $MyInvocation.MyCommand.Name, $DynamicCache)

        Foreach ($String in $EntityName) {
            Write-Debug ('{0}: Selecting entities that match pattern "{1}"' -F $MyInvocation.MyCommand.Name, $String)
      
            $EntitiesToProcess += $Entities.GetEnumerator().Where( { $_.Key -like $String })
        }
        # Prepare Index for progressbar
        $Index = 0
        $ProgressParameters = @{
            Activity = 'Updating diskcache for requested entities.'
            Id       = 10
        }

        # Make sure we only check each possible entity once
        $EntitiesToProcess = $EntitiesToProcess | Sort-Object -Property Name -Unique

        Write-Debug ('{0}: {1} entities have been selected for refresh' -F $MyInvocation.MyCommand.Name, $EntitiesToProcess.Count)
  

        Foreach ($EntityToProcess in $EntitiesToProcess) {
            $Index++
            $PercentComplete = $Index / $EntitiesToProcess.Count * 100

            # Add parameters for @splatting
            $ProgressParameters['PercentComplete'] = $PercentComplete
            $ProgressParameters['Status'] = 'Entity {0}/{1} ({2:n0}%)' -F $Index, $EntitiesToProcess.Count, $PercentComplete
            $ProgressParameters['CurrentOperation'] = 'Getting fieldinfo for {0}' -F $EntityToProcess.Name

            Write-Progress @ProgressParameters

            $null = Get-AtwsFieldInfo -Entity $EntityToProcess.Key -UpdateCache
        }

        If ($EntitiesToProcess.Count -gt 0) { 
            Write-Debug ('{0}: Calling Import-AtwsCmdLet with {1} entities to process' -F $MyInvocation.MyCommand.Name, $EntitiesToProcess.Count)
  
            # Recreate functions that have been updated
            Import-AtwsCmdLet -Entities $EntitiesToProcess

            # Re-read Dynamic functions
            $DynamicFunction = @( Get-ChildItem -Path $DynamicCache\*atws*.ps1 -ErrorAction SilentlyContinue ) 

            Write-Debug ('{0}: Personal disk cache: Found {1} script files in {2}' -F $MyInvocation.MyCommand.Name, $DynamicFunction.Count, $DynamicCache)
        }
    }

    Write-Verbose ('{0}: Importing {1} Static and {2} Dynamic functions.' -F $MyInvocation.MyCommand.Name, $StaticFunction.Count, $DynamicFunction.Count)
  
    # Loop through all script files and source them
    foreach ($Import in @($StaticFunction + $DynamicFunction)) {
        Write-Debug ('{0}: Importing {1}' -F $MyInvocation.MyCommand.Name, $Import)

        try {
            . $Import.fullname
        }
        catch {
            throw "Could not import function $($Import.fullname): $_"
        }
    }
  
    # Explicitly export public functions
    Write-Debug ('{0}: Exporting {1} Public functions.' -F $MyInvocation.MyCommand.Name, $PublicFunction.Count) 
    Export-ModuleMember -Function $PublicFunction.Basename

    # Explicitly export static functions
    Write-Debug ('{0}: Exporting {1} Static functions.' -F $MyInvocation.MyCommand.Name, $StaticFunction.Count)
    Export-ModuleMember -Function $StaticFunction.Basename

    # Explicitly export dynamic functions
    Write-Debug ('{0}: Exporting {1} Dynamic functions.' -F $MyInvocation.MyCommand.Name, $DynamicFunction.Count)
    Export-ModuleMember -Function $DynamicFunction.Basename
}
Else {
    Write-Verbose 'No Credentials were passed with -ArgumentList. Loading module without any connection to Autotask Web Services. Use Connect-AtwsWebAPI to connect.'
    Export-ModuleMember -Function 'Connect-AtwsWebAPI'
}


# Backwards compatibility since we are now trying to use consistent naming
Set-Alias -Scope Global -Name 'Connect-AutotaskWebAPI' -Value 'Connect-AtwsWebAPI'


# Restore Previous preference
If ($OldVerbosePreference -ne $VerbosePreference) {
    Write-Debug ('{0}: Restoring old Verbose preference' -F $MyInvocation.MyCommand.Name)
    $VerbosePreference = $OldVerbosePreference
}
If ($OldDebugPreference -ne $DebugPreference) {
    Write-Debug ('{0}: Restoring old Debug preference' -F $MyInvocation.MyCommand.Name)
    $DebugPreference = $OldDebugPreference
}