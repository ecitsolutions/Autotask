#Requires -Version 4.0
<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md  for license information.

#>

Function Uninstall-AtwsOldModuleVersion {
 <#
      .SYNOPSIS
      This function uninstalls all module versions but the latest from this machine.
      .DESCRIPTION
      This function uses Get-InstalledModule to list all versions of this module, sorts them by
      version number and uninstalls all versions but the one with the highest version number.
      .INPUTS
      Nothing.
      .OUTPUTS
      Nothing
      .EXAMPLE
      Uninstall-AtwsOldModuleVersion
      Uninstalls all but the latest module version of this module
      .EXAMPLE
      Uninstall-AtwsOldModuleVersion -ModuleName modulename
      Uninstalls all but the latest module version of a module named "modulename".
      .NOTES
      NAME: Get-AtwsConnectionObject
      
  #>
  [CmdLetBinding(
      SupportsShouldProcess = $true,
      ConfirmImpact = 'Medium'
  )]
  Param(
    [Alias('Name')]
    [string]
    $ModuleName = $MyInvocation.MyCommand.ModuleName
  )

  begin {
    # Enable modern -Debug behavior
    if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

    $Latest = Get-InstalledModule -Name $ModuleName
    $AllVersions = Get-InstalledModule -Name $ModuleName -AllVersions
  }

  process {
    # If there is only a single module version installed, do nothing
    if ($AllVersions.count -gt 1) { 

      # Prepare for removal, use confirmimpact to verify potentially destructive action
      $caption = $MyInvocation.MyCommand.Name
      $verboseDescription = '{0}: Uninstalling {1} old versions of module {2}' -F $caption, $AllVersions.count, $ModuleName
      $verboseWarning = '{0}: About to uninstall {1} old versions of module {2}. Do you want to continue?' -F $caption, $AllVersions.count, $ModuleName
          
      if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 

        $Activity = 'Uninstalling {0} old versions of module {1}' -F $AllVersions.count, $ModuleName

        foreach ($Version in $AllVersions) {

          # Progress bar
          $Index = $AllVersions.IndexOf($Version) + 1
          $PercentComplete = $Index / $AllVersions.Count * 100
          $Status = 'Module {0}/{1} ({2:n0}%)' -F $Index, $AllVersions.Count, $PercentComplete
          $CurrentOperation = "Uninstalling version {0}" -F $Version.version

          Write-Progress -Activity $Activity -Status $Status -PercentComplete $PercentComplete -CurrentOperation $CurrentOperation

          if ($Version.version -ne $latest.version) {
            Write-Verbose "Uninstalling $($sm.name) - $($sm.version) [latest is $($latest.version)]"
            $Version | Uninstall-Module -Force
          }
        }
      }
    }
  }

  end {
    Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
  }
}