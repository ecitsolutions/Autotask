
Function Update-Manifest {
  [CmdLetBinding(
      SupportsShouldProcess = $True,
      ConfirmImpact = 'High'
  )]
  Param(
    [Switch]
    $UpdateVersion,
    
    [Switch]
    $Beta
  )
  
  Begin { 
    # Get info from current module
    $ModuleInfo = $MyInvocation.MyCommand.Module
    
    If ($Beta.IsPresent) {
      $ModuleName = '{0}Beta' -F $ModuleInfo.Name
      $GUID = 'ff62b403-3520-4b98-a12b-343bb6b79255'
      
      # Path to RootModule
      $PSMName = '{0}\{1}.psm1' -F $ModuleInfo.ModuleBase, $ModuleInfo.Name
      $PSMDest = '{0}\{1}.psm1' -F $ModuleInfo.ModuleBase, $ModuleName
      
      # Update Beta rootmodule
      $Null = Copy-Item -Path $PSMName -Destination $PSMDest -Force
    }
    Else {
      $ModuleName = $ModuleInfo.Name
      $GUID = 'abd8b426-797b-4702-b66d-5f871d0701dc'
    }
    
    
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
    $NuspecSourcePath = '{0}\{1}.nuspec' -F $ModuleInfo.ModuleBase, $ModuleInfo.Name
    $NuspecPath = '{0}\{1}.nuspec' -F $ModuleInfo.ModuleBase, $ModuleName
    $Nuspec.Load($NuspecSourcePath)
  } 
  
  Process {
    
    # Overwrite parameters that need new values
    $ManifestParams['Path'] = '{0}\{1}.psd1' -F $ModuleInfo.ModuleBase, $ModuleName
    
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
    
    # Explicitly set important parameters
    $ManifestParams['RootModule'] = '{0}.psm1' -F $ModuleName
    $ManifestParams['Moduleversion'] = $Moduleversion
    
    # Make sure the GUID matches module manifest (Beta or Release)
    $ManifestParams['GUID'] = $GUID
    
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
    If ($Beta.IsPresent) {
      $ManifestParams['DefaultCommandPrefix'] = 'Beta'
    }
    Else { 
      $ManifestParams['DefaultCommandPrefix'] = 'Atws'
    }
    
    # Update nuspec
    $Nuspec.DocumentElement.metadata.id = $ModuleName
    $Nuspec.DocumentElement.metadata.version = $ManifestParams['Moduleversion'].ToString()
    $Nuspec.DocumentElement.metadata.description = $ManifestParams['Description']
    $Nuspec.DocumentElement.metadata.authors = $ManifestParams['Author']
    $Nuspec.DocumentElement.metadata.tags = $ManifestParams['Tags'] -join ', '
    $Nuspec.DocumentElement.metadata.releasenotes = $ManifestParams['ReleaseNotes']
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
