#
# Module manifest for module 'Autotask'
#
# Generated by: Hugo Klemmestad
#
# Generated on: 1/18/2021
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'Autotask.psm1'

# Version number of this module.
ModuleVersion = '1.6.11'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = 'abd8b426-797b-4702-b66d-5f871d0701dc'

# Author of this module
Author = 'Hugo Klemmestad'

# Company or vendor of this module
CompanyName = 'ECIT Solutions AS'

# Copyright statement for this module
Copyright = 'Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.'

# Description of the functionality provided by this module
Description = 'This module connects to the Autotask web services API. It downloads information about entities and fields and generates Powershell functions with parameter validation to support Intellisense script editing. To download first all entities and then detailed information about all fields and selection lists is quite time consuming. To speed up module load time and get to coding faster the module caches both script functions and the field info cache to disk.'

# Minimum version of the PowerShell engine required by this module
PowerShellVersion = '4.0'

# Name of the PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# ClrVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = '*'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
# VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = 'Autotask', 'Function', 'SOAP'

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/ecitsolutions/Autotask'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = 'https://github.com/ecitsolutions/Autotask/blob/master/README.md'

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

