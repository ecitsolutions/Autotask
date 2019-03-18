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
  $EntityName
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
foreach ($Import in @($PrivateFunction))
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

If ($Credential)
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
  
  
  # Connect to the API using required, additional parameters, using internal function name
  . Connect-AtwsWebServices -Credential $Credential -ApiTrackingIdentifier $ApiTrackingIdentifier
  
  $DynamicCache = '{0}\WindowsPowershell\Cache\{1}\Dynamic' -f $([environment]::GetFolderPath('MyDocuments')), $Script:Atws.CI
  If (Test-Path $DynamicCache) {
    $DynamicFunction = @( Get-ChildItem -Path $DynamicCache\*.ps1 -ErrorAction SilentlyContinue )     
  }
}

# Loop through all script files and source them
foreach ($Import in @($PublicFunction + $StaticFunction + $DynamicFunction))
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