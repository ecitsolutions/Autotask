<#
    Description
#>

[CmdletBinding()]
Param(
  [Parameter(
      Mandatory = $true,
      Position = 0
  )]
  [ValidateNotNullOrEmpty()]    
  [pscredential]
  $Credential,
    
  [Parameter(
      Mandatory = $true,
      Position = 1  
  )]
  [String]
  $ApiTrackingIdentifier
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

# Explicitly export public functions
Export-ModuleMember -Function $PublicFunction.Basename

# Connect to the API using required, additional parameters
. Connect-AtwsWebApi -Credential $Credential -ApiTrackingIdentifier $ApiTrackingIdentifier

# Generate all functions and source them. The function exports them in-line, thats why we need to source it.
. Import-AtwsCmdLet


# Restore Previous preference
If ($OldPreference -ne $VerbosePreference) {
  $VerbosePreference = $OldPreference
}