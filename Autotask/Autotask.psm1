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

# Special consideration for -Verbose, as there is no $PSCmdLet context to check if Import-Module was called using -Verbose
# and $VerbosePreference is not inherited from Import-Module for some reason.

# Remove comments
$ParentCommand = ($MyInvocation.Line -split '#')[0]

# Store Previous preference
$OldPreference = $VerbosePreference
If ($ParentCommand -like '*-Verbose*') {
  $VerbosePreference = 'Continue'
}


# Get all function files as file objects
# Private functions can only be called internally in other functions in the module 
$PrivateFunction = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue ) 

# Public functions will be exported with Prefix prepended to the Noun of the function name
$PublicFunction = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue ) 

# Static functions will be exported with Prefix prepended to the Noun of the function name
$StaticFunction = @( Get-ChildItem -Path $PSScriptRoot\Static\*.ps1 -ErrorAction SilentlyContinue ) 

# Static functions will be exported with Prefix prepended to the Noun of the function name
$DynamicFunction = @( Get-ChildItem -Path $PSScriptRoot\Dynamic\*.ps1 -ErrorAction SilentlyContinue ) 

# Loop through all script files and source them
foreach ($Import in @($PrivateFunction + $PublicFunction))
{
  Write-Verbose "Importing $Import"
  try
  {
    . $Import.fullname
  }
  catch
  {
    throw "Could not import function $($Import.fullname): $_"
  }
}

# If they tried to pass any variables
If (($Credential) -or ($ApiTrackingIdentifier))
{
  # Remove Global variables (if used) for security
  If (Get-Variable -Name AtwsCredential -Scope Global -ErrorAction SilentlyContinue)
  {
    Remove-Variable -Name AtwsCredential -Scope Global
  }
  If (Get-Variable -Name AtwsApiTrackingIdentifier -Scope Global -ErrorAction SilentlyContinue)
  {
    Remove-Variable -Name AtwsApiTrackingIdentifier -Scope Global
  }
  If (Get-Variable -Name AtwsRefreshCachePattern -Scope Global -ErrorAction SilentlyContinue)
  {
    Remove-Variable -Name AtwsRefreshCachePattern -Scope Global
  }
  
  # Connect to the API using required, additional parameters, using internal function name
  . Connect-AtwsWebServices -Credential $Credential -ApiTrackingIdentifier $ApiTrackingIdentifier
  
  $DynamicCache = '{0}\WindowsPowershell\Cache\{1}\Dynamic' -f $([environment]::GetFolderPath('MyDocuments')), $Script:Atws.CI
  If (Test-Path $DynamicCache) {
    $DynamicFunction = @( Get-ChildItem -Path $DynamicCache\*atws*.ps1 -ErrorAction SilentlyContinue )     
  }
  Else {
    # No personal dynamic cache. Refresh  ALL dynamic entities.
    $EntityName = '*'
  }
  
  # Verify that picklists are available in disk cache
  # Status is always a picklist
  # if there is none, refresh ALL entities with picklists
  
  $FieldList = Get-AtwsFieldInfo -Entity Ticket
  $Status = $FieldList.Where{$_.Name -eq 'Status'}
  If ($Status.PickListValues.Count -lt 1) {
    $EntityName = '*'
  }
  
  # Refresh any entities the caller has ordered'
  # We only consider entities that are dynamic
  If ($EntityName)
  { 
    $Entities = Get-AtwsFieldInfo -Dynamic
    $EntitiesToProcess = @()
    
    Foreach ($String in $EntityName)
    {
      $EntitiesToProcess += $Entities.GetEnumerator().Where({$_.Key -like $String})
    }
    # Prepare Index for progressbar
    $Index = 0
    $ProgressParameters = @{
      Activity = 'Updating diskcache for requested entities.'
      Id = 10
    }
    Foreach ($EntityToProcess in $EntitiesToProcess)
    {
      $Index++
      $PercentComplete = $Index / $EntitiesToProcess.Count * 100
      
      # Add parameters for @splatting
      $ProgressParameters['PercentComplete'] = $PercentComplete
      $ProgressParameters['Status'] = 'Entity {0}/{1} ({2:n0}%)' -F $Index, $EntitiesToProcess.Count, $PercentComplete
      $ProgressParameters['CurrentOperation'] = 'Getting fieldinfo for {0}' -F $EntityToProcess.Name
      
      Write-Progress @ProgressParameters
      
      $null = Get-AtwsFieldInfo -Entity $EntityToProcess.Key -UpdateCache
    }
    
    # Recreate functions that have been updated
    Import-AtwsCmdLet -Entities $EntitiesToProcess
    
    # Re-read Dynamic functions
    $DynamicFunction = @( Get-ChildItem -Path $DynamicCache\*atws*.ps1 -ErrorAction SilentlyContinue ) 
  }
}
Else {
  Write-Warning 'No Credentials were passed with -ArgumentList. Loading module without any connection to Autotask Web Services. Use Connect-AtwsWebAPI (default prefix is Atws) to connect.'
}

# Loop through all script files and source them
foreach ($Import in @($StaticFunction + $DynamicFunction))
{
  Write-Verbose "Importing $Import"
  try
  {
    . $Import.fullname
  }
  catch
  {
    throw "Could not import function $($Import.fullname): $_"
  }
}

# Explicitly export public functions
Export-ModuleMember -Function $PublicFunction.Basename

# Explicitly export static functions
Export-ModuleMember -Function $StaticFunction.Basename

# Explicitly export dynamic functions
Export-ModuleMember -Function $DynamicFunction.Basename


# Backwards compatibility since we are now using built-in module prefix support
Set-Alias -Scope Global -Name 'Connect-AutotaskWebAPI' -Value 'Connect-AtwsWebAPI'


# Restore Previous preference
If ($OldPreference -ne $VerbosePreference) {
  $VerbosePreference = $OldPreference
}