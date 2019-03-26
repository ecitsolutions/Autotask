#Requires -Version 4.0
<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md  for license information.

#>

Function Uninstall-OldModuleVersion {
  [CmdLetBinding(
      SupportsShouldProcess = $True,
      ConfirmImpact = 'Medium'
  )]
  Param(
    [Alias('Name')]
    [String]
    $ModuleName = $MyInvocation.MyCommand.ModuleName
  )

  Begin {
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

    $Latest = Get-InstalledModule -Name $ModuleName
    $AllVersions = Get-InstalledModule -Name $ModuleName -AllVersions
  }

  Process {
    # If there is only a single module version installed, do nothing
    If ($AllVersions.count -gt 1) { 

      # Prepare for removal, use confirmimpact to verify potentially destructive action
      $Caption = $MyInvocation.MyCommand.Name
      $VerboseDescription = '{0}: Uninstalling {1} old versions of module {2}' -F $Caption, $AllVersions.count, $ModuleName
      $VerboseWarning = '{0}: About to uninstall {1} old versions of module {2}. Do you want to continue?' -F $Caption, $AllVersions.count, $ModuleName
          
      If ($PSCmdlet.ShouldProcess($VerboseDescription, $VerboseWarning, $Caption)) { 

        $Activity = 'Uninstalling {0} old versions of module {1}' -F $AllVersions.count, $ModuleName

        foreach ($Version in $AllVersions) {

          # Progress bar
          $Index = $AllVersions.IndexOf($Version) + 1
          $PercentComplete = $Index / $AllVersions.Count * 100
          $Status = 'Module {0}/{1} ({2:n0}%)' -F $Index, $AllVersions.Count, $PercentComplete
          $CurrentOperation = "Uninstalling version {0}" -F $Version.version

          Write-Progress -Activity $Activity -Status $Status -PercentComplete $PercentComplete -CurrentOperation $CurrentOperation

          If ($Version.version -ne $latest.version) {
            Write-Verbose "Uninstalling $($sm.name) - $($sm.version) [latest is $($latest.version)]"
            $Version | Uninstall-Module -Force
          }
        }
      }
    }
  }

  End {
    Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
  }
}