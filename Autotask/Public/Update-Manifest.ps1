
Function Update-Manifest {
  [CmdLetBinding(
      SupportsShouldProcess = $True,
      ConfirmImpact = 'High'
  )]
  Param(
    [Switch]
    $UpdateVersion
  )
  
  Begin { 
    # Get info from current module
    $ModuleInfo = $MyInvocation.MyCommand.Module
    
    # Create the parameter hashtable 
    $ManifestParams = @{}
    
    # Get valid parameters
    $Command = Get-Command -Name New-ModuleManifest
    
    # Pre-populate with previous values
    Foreach ($Parameter in $Command.Parameters.GetEnumerator()) {
      $Name = $Parameter.Key
      If ($ModuleInfo.$Name) {
        $ManifestParams[$Name] = $ModuleInfo.$Name
      }
    }
    
    # Read the nuspec
    $Nuspec = New-Object -TypeName XML
    $NuspecPath = '{0}\Autotask.nuspec' -F $ModuleInfo.ModuleBase
    $Nuspec.Load($NuspecPath)
  } 
  
  Process {
    
    # Overwrite parameters that need new values
    $ManifestParams['Path'] = '{0}\Autotask.psd1' -F $ModuleInfo.ModuleBase
    
    If ($UpdateVersion.IsPresent) { 
    
      # Figure out the new module version number
      [Version]$ApiVersion = '{0}.{1}' -F $Script:Atws.GetWsdlVersion(), $ModuleInfo.Version.Revision
    
      If ($ApiVersion -eq $ModuleInfo.Version) {
        # It is the same API version. Increase the revision number
        $Revision = $ModuleInfo.Version.Revision
        $Revision++
      }
      Else {
        # New API version. Then this is the first revision of the new API version
        $Revision = 1
      }
    
      # Save the new version number to the parameter set
      [Version]$Moduleversion = '{0}.{1}' -F $Script:Atws.GetWsdlVersion(), $Revision
    }
    Else {
      # Use existing version if no update has been requested
      $Moduleversion = $ModuleInfo.Version
    }
    $ManifestParams['Moduleversion'] = $Moduleversion
    
    # Information to export
    $Functions = @()
    $Moduleinfo.ExportedFunctions.Keys | ForEach-Object {$Functions += ($_ -replace $ModuleInfo.Prefix, '')}
    $ManifestParams['FunctionsToExport'] = $Functions
    $ManifestParams['CmdletsToExport'] = @()
    $ManifestParams['VariablesToExport'] = @()
    $ManifestParams['AliasesToExport'] = @()
    
    # Custom
    $ManifestParams['LicenseUri'] = $ModuleInfo.PrivateData.PSData.LicenseUri
    $ManifestParams['ProjectUri'] = $ModuleInfo.PrivateData.PSData.ProjectUri
    $ManifestParams['ReleaseNotes'] = $ModuleInfo.PrivateData.PSData.ReleaseNotes
    $ManifestParams['Tags'] = $ModuleInfo.PrivateData.PSData.Tags
            
    # Recreate PrivateData
    $ManifestParams['PrivateData'] = @{}

    # Default prefix is always Atws
    $ManifestParams['DefaultCommandPrefix'] = 'Atws'
    
    # Update nuspec
    $Nuspec.DocumentElement.metadata.version = $ManifestParams['Moduleversion'].ToString()
    $Nuspec.DocumentElement.metadata.description = $ManifestParams['Description']
    $Nuspec.DocumentElement.metadata.authors = $ManifestParams['Author']
    $Nuspec.DocumentElement.metadata.tags = $ManifestParams['Tags'] -join ', '
  }
  End {
    $Caption = $MyInvocation.MyCommand.Name
    $VerboseDescrition = '{0}: Overwriting existing module manifest and nuspec information file in {1}' -F $Caption, $ModuleInfo.ModuleBase
    $VerboseWarning = '{0}: About to overwrite existing module manifest and nuspec information file in {1}. Do you want to continue?' -F $Caption, $ModuleInfo.ModuleBase
          
    If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
      # Create the new manifest
      New-ModuleManifest @ManifestParams
    
      # Save the nuspec
      $Nuspec.Save($NuspecPath)
    }
  }
}
