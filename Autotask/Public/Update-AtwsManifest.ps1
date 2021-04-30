<#

    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

#>
Function Update-AtwsManifest {
    <#
        .SYNOPSIS
            This function recreates the module manifest and nuspec with default settings.
        .DESCRIPTION
            This function recreates a module manifest and nuspec for the current module and has an option
            for increasing the version number to the next available based on current API version
            and module version. There is also an option for creating a manifest for a beta module.
        .INPUTS
            Nothing, only parameters.
        .OUTPUTS
            A PowerShell module manifest and nuspec file for the current module.
        .EXAMPLE
            Update-AtwsManifest
            Recreates a manifest and a nuspec file for the current module and overwrites the existing files
            with them.
        .EXAMPLE
            Update-AtwsManifest -UpdateVersion
            Recreates a manifest and a nuspec file for the current module, updates the version number in both
            and overwrites the existing files with them.
        .NOTES
            NAME: Update-AtwsFunctions
    #>
    [CmdLetBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    Param(
        # Optional flag that causes the function to increase the version number a single increment.
        [ValidateSet('Major','Minor','Build')]
        [string]
        $UpdateVersion,

        # Optional flag that causes the function to save the manifest files with suffix "Beta".
        [switch]
        $Beta
    )
  
    begin { 
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
       
        if (-not($Script:Atws.integrationsValue)) {
            # Not connected. Try to connect, prompt for credentials if necessary
            Write-Verbose ('{0}: Not connected. Calling Connect-AtwsWebApi without parameters for possible autoload of default connection profile.' -F $MyInvocation.MyCommand.Name)
            Connect-AtwsWebAPI
        }
    
        # Get info from current module
        $ModuleInfo = $MyInvocation.MyCommand.Module
        $ModuleName = $ModuleInfo.Name
        $GUID = 'abd8b426-797b-4702-b66d-5f871d0701dc'
   
        # Create the parameter hashtable 
        $ManifestParams = @{ }
    
        # Get valid parameters
        $Command = Get-Command -Name New-ModuleManifest
    
        # Pre-populate with previous values
        foreach ($parameter in $Command.Parameters.GetEnumerator()) {
            $Name = $parameter.Key
            if ($ModuleInfo.$Name) {
                $ManifestParams[$Name] = $ModuleInfo.$Name
            }
        }
    } 
  
    process {
    
        # Overwrite parameters that need new values
        $ManifestParams['Path'] = Join-Path $ModuleInfo.ModuleBase ('{0}.psd1' -F $ModuleName)
    
        if (($UpdateVersion) -or $Beta.IsPresent) { 
    
            # Figure out the new module version number
            [Version]$Moduleversion = $ModuleInfo.Version
            $Major = $Moduleversion.Major
            $Minor = $Moduleversion.Minor
            $Build = $Moduleversion.Build

            switch ($UpdateVersion) {
                'Major' {$Major++}
                'Minor' {$Minor++}
                'Build' {$Build++}
            }

            if ($Major -gt $Moduleversion.Major) {
                $Minor = 0
                $Build = 0
            }
            elseif ($Minor -gt $Moduleversion.Minor) {
                $Build = 0
            }
    
            if ([Version]::new($Major, $Minor, $Build) -eq $ModuleInfo.Version) {
                # It is the same version number. Increase the prerelease if applicable
                if ($ModuleInfo.PrivateData.PSData.Prerelease) {
                    # This is already a prerelease. Beta-revision is everthing after 'beta'
                    [int]$BetaRevision = $ModuleInfo.PrivateData.PSData.Prerelease -replace 'beta', ''
                }
            }
            
            if ($Beta.IsPresent) {
                # If there is a betarevision, increase it. Else it is 1
                if ($BetaRevision) {
                    $BetaRevision++
                }
                else {
                    $BetaRevision = 1
                }
                # Save prerelease text for Update-Manifest
                $Prerelease = 'beta{0}' -f $BetaRevision
            }
    
            # Save the new version number to the parameter set
            $Moduleversion = [Version]::new($Major, $Minor, $Build)
        }
        else {
            # Use existing version if no update has been requested
            $Moduleversion = $ModuleInfo.Version
        }
    
        # Explicitly set important parameters
        $ManifestParams['RootModule'] = '{0}.psm1' -F $ModuleName
        $ManifestParams['Moduleversion'] = $Moduleversion
    
        # Make sure the GUID matches module manifest (Beta or Release)
        $ManifestParams['GUID'] = $GUID
    
        # Information to export
        Push-Location
        Set-Location $ModuleInfo.ModuleBase
        $Functions = Get-ChildItem -Path ./Public/*.ps1, ./Functions/*.ps1 | Select-Object -ExpandProperty BaseName
        Pop-Location
        
    <# 
        if ($Beta.IsPresent) {
        # Make sure the beta version does not clobber the release version through 
        # automatic module import
        $ManifestParams['FunctionsToExport'] = '*'
        }
        else { 
        }
    #>
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
        $ManifestParams['PrivateData'] = $PrivateData

        # There should not be any default prefix anymore
        if ($ManifestParams.Keys -contains 'DefaultCommandPrefix') {
            $ManifestParams.Remove('DefaultCommandPrefix')
        }
    
        Write-Verbose ('{0}: New manifest prepared' -F $MyInvocation.MyCommand.Name)
    }
    end {
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: Overwriting existing module manifest and nuspec information file in {1}' -F $caption, $ModuleInfo.ModuleBase
        $verboseWarning = '{0}: About to overwrite existing module manifest and nuspec information file in {1}. Do you want to continue?' -F $caption, $ModuleInfo.ModuleBase
          
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
            # Create the new manifest
            New-ModuleManifest @ManifestParams

            if ($Prerelease) {
                Update-ModuleManifest -Path $ManifestParams['Path'] -Prerelease $Prerelease
            }
    
        }
    
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        
    }
}
