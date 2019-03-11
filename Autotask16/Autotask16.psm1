<#
    Description
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
  
  # Explicitly export public functions
  Export-ModuleMember -Function $PublicFunction.Basename
   
  # Connect to the API using required, additional parameters, using internal function name
  . Connect-AtwsWebServices -Credential $Credential -ApiTrackingIdentifier $ApiTrackingIdentifier
  
  
  # Refresh any entities the caller has ordered'
  # We only consider entities that are dynamic
  If ($EntityName)
  { 
    $Entities = Get-FieldInfo -Dynamic
    $EntitiesToProcess = @()
    Foreach ($String in $EntityName)
    {
      $EntitiesToProcess += $Entities.GetEnumerator().Where({$_.Key -like $String})
      Foreach ($EntityToProcess in $EntitiesToProcess)
      {
        $null = Get-FieldInfo -Entity $EntityToProcess.Key -UpdateCache
      }
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
      
      $null = Get-FieldInfo -Entity $EntityToProcess.Key -UpdateCache
    }
  }
  
  
  # Generate all functions and source them. The function exports them in-line, thats why we need to source it.
  . Import-AtwsCmdLet

}
Else
{
  # Not connected; only export connect wrapper
  Export-ModuleMember -Function 'Connect-WebAPI'
}

# Restore Previous preference
If ($OldPreference -ne $VerbosePreference) {
  $VerbosePreference = $OldPreference
}