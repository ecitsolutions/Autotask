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

# Prepare parameters for @splatting
$ProgressId = 1
$Activity = 'Loading module'


Write-Progress -Activity $Activity -Id $ProgressId -Status 'Importing scripts' -PercentComplete 10 -CurrentOperation 'Sourcing files'

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

Write-Progress -Activity $Activity -Id $ProgressId -Status 'Importing scripts' -PercentComplete 30 -CurrentOperation 'Importing static functions'


# Explicitly export public functions
Export-ModuleMember -Function $PublicFunction.Basename

Write-Progress -Activity $Activity -Id $ProgressId -Status 'Dynamic Functions' -PercentComplete 50 -CurrentOperation 'Connecting to API'

# Connect to the API using required, additional parameters, using internal function name
. Connect-WebApi -Credential $Credential -ApiTrackingIdentifier $ApiTrackingIdentifier

Write-Progress -Activity $Activity -Id $ProgressId -Status 'Dynamic Functions' -PercentComplete 80 -CurrentOperation 'Generating code'

# Generate all functions and source them. The function exports them in-line, thats why we need to source it.
. Import-AtwsCmdLet

Write-Progress -Activity $Activity -Id $ProgressId -Status 'Dynamic Functions' -PercentComplete 100 -CurrentOperation 'Generating code'

Write-Progress -Activity $Activity -Id $ProgressId -Status 'Dynamic Functions' -PercentComplete 100 -CurrentOperation 'Generating code' -completed

# Restore Previous preference
If ($OldPreference -ne $VerbosePreference) {
  $VerbosePreference = $OldPreference
}