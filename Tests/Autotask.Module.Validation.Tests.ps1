<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.

    .SYNOPSIS
    Test if the module can be imported without error
    .DESCRIPTION
    Test the various ways this module can be imported. Requires valid Autotask credentials and an Api Tracking identifier.
#>

[cmdletbinding(
    SupportsShouldProcess = $True,
    ConfirmImpact = 'Low',
    DefaultParameterSetName = 'Default'
)]

Param
(
    [Parameter(
        Mandatory = $True,
        ParameterSetName = 'Default'
    )]
    [ValidateNotNullOrEmpty()]    
    [pscredential]
    $Credential,
    
    [Parameter(
        Mandatory = $True,
        ParameterSetName = 'Default'
    )]
    [String]
    $ApiTrackingIdentifier,

    [Parameter(
        Mandatory = $false,
        ParameterSetName = 'Default'
    )]
    [String]
    $ModuleName = 'Autotask',

    [Parameter(
        Mandatory = $false,
        ParameterSetName = 'Default'
    )]
    [ValidateSCript( {
            Test-Path $_
        })]
    [String]
    $RootPath = $(Split-Path -Parent -Path (Split-Path -Parent -Path $MyInvocation.MyCommand.Path))
)

$modulePath = '{0}\{1}' -F $RootPath, $ModuleName


describe "$ModuleName Module Manifest tests" -Tag 'Manifest' {

  context 'Module Setup' {
    it "has the root module $moduleName.psm1" {
      "$modulePath\$moduleName.psm1" | Should -Exist
    }

    it "has the a manifest file of $moduleName.psd1" {
      "$modulePath\$moduleName.psd1" | Should -Exist
      "$modulePath\$moduleName.psd1" | Should -FileContentMatch "$moduleName.psm1"
    }
    
    it "$modulePath\Functions folder has functions" {
      "$modulePath\Functions\*.ps1" | Should -Exist
    }
    it "$modulePath\Private folder has functions" {
      "$modulePath\Private\*.ps1" | Should -Exist
    }
    it "$modulePath\Public folder has functions" {
      "$modulePath\Public\*.ps1" | Should -Exist
    }

    it "$ModuleName is valid PowerShell code" {
      $psFile = Get-Content -Path "$modulePath\$moduleName.psm1" `
        -ErrorAction Stop
      $errors = $null
      $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
      $errors.Count | Should -Be 0
    }

  } # context 'Module Setup'

}

describe "$ModuleName Module function tests" -Tag 'Functions' { 

    foreach ($directory in 'Functions', 'Public') { 
    
    $subdir = '{0}\{1}' -F $modulePath, $directory 

    $functions = (Get-ChildItem -Path $subdir\*.ps1 -Exclude *-AtwsDefinition.ps1).BaseName

    foreach ($function in $functions) {
  
      context "Test Function $function" {
      
        it "$function.ps1 should have help block" {
          "$subdir\$function.ps1" | Should -FileContentMatch '<#'
          "$subdir\$function.ps1" | Should -FileContentMatch '#>'
        }

        it "$function.ps1 should have a SYNOPSIS section in the help block" {
          "$subdir\$function.ps1" | Should -FileContentMatch '.SYNOPSIS'
        }
    
        it "$function.ps1 should have a DESCRIPTION section in the help block" {
          "$subdir\$function.ps1" | Should -FileContentMatch '.DESCRIPTION'
        }

        it "$function.ps1 should have a EXAMPLE section in the help block" {
          "$subdir\$function.ps1" | Should -FileContentMatch '.EXAMPLE'
        }
    
        it "$function.ps1 should be an advanced function" {
          "$subdir\$function.ps1" | Should -FileContentMatch 'function'
          "$subdir\$function.ps1" | Should -FileContentMatch 'cmdletbinding'
          "$subdir\$function.ps1" | Should -FileContentMatch 'param'
        }
      
        it "$function.ps1 should contain Write-Verbose blocks" {
          "$subdir\$function.ps1" | Should -FileContentMatch 'Write-Verbose|ShouldProcess'
        }

        it "$function.ps1 should contain Write-Debug blocks" {
          "$subdir\$function.ps1" | Should -FileContentMatch 'Write-Debug'
        }

        it "$function.ps1 is valid PowerShell code" {
          $psFile = Get-Content -Path "$subdir\$function.ps1" `
            -ErrorAction Stop
          $errors = $null
          $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
          $errors.Count | Should -Be 0
        }
    
      } # context "Test Function $function"

    } # foreach ($function in $functions)

  }

}


Describe "$ModuleName Module function tests" -Tag 'Functions' { 

    foreach ($directory in 'Private') { 
    
        $subdir = '{0}\{1}' -F $modulePath, $directory 

        $functions = (Get-ChildItem -Path $subdir\*.ps1 -Exclude *-AtwsDefinition.ps1).BaseName

        foreach ($function in $functions) {
  
            Context "Test Function $function" {
      
                It "$function.ps1 should be an advanced function" {
                    "$subdir\$function.ps1" | Should -FileContentMatch 'function'
                    "$subdir\$function.ps1" | Should -FileContentMatch 'cmdletbinding'
                    "$subdir\$function.ps1" | Should -FileContentMatch 'param'
                }
      
                It "$function.ps1 is valid PowerShell code" {
                    $psFile = Get-Content -Path "$subdir\$function.ps1" `
                        -ErrorAction Stop
                    $errors = $null
                    $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
                    $errors.Count | Should -Be 0
                }
    
            } # context "Test Function $function"

        } # foreach ($function in $functions)

    }

}