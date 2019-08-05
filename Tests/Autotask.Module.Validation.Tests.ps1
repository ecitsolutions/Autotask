<#
    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

    .SYNOPSIS
    Test if the module can be imported without error
    .DESCRIPTION
    Test the various ways this module can be imported. Requires valid Autotask credentials and an Api Tracking identifier.
#>

$moduleName = 'Autotask'

$modulePath = '{0}\{1}' -F $(Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)), $moduleName


describe "$moduleName Module Manifest tests" -Tag 'Manifest' {

  context 'Module Setup' {
    it "has the root module $moduleName.psm1" {
      "$modulePath\$moduleName.psm1" | Should -Exist
    }

    it "has the a manifest file of $moduleName.psd1" {
      "$modulePath\$moduleName.psd1" | Should -Exist
      "$modulePath\$moduleName.psd1" | Should -FileContentMatch "$moduleName.psm1"
    }
    
    it "$modulePath\Dynamic folder has functions" {
      "$modulePath\Dynamic\*.ps1" | Should -Exist
    }
    it "$module\Static folder has functions" {
      "$modulePath\Static\*.ps1" | Should -Exist
    }
    it "$module\Private folder has functions" {
      "$modulePath\Private\*.ps1" | Should -Exist
    }
    it "$module\Public folder has functions" {
      "$modulePath\Public\*.ps1" | Should -Exist
    }

    it "$moduleName is valid PowerShell code" {
      $psFile = Get-Content -Path "$modulePath\$moduleName.psm1" `
        -ErrorAction Stop
      $errors = $null
      $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
      $errors.Count | Should -Be 0
    }

  } # context 'Module Setup'

}

describe "$moduleName Module function tests" -Tag 'Functions' { 

  foreach ($directory in 'Dynamic', 'Static', 'Private', 'Public') { 
    
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
          "$subdir\$function.ps1" | Should -FileContentMatch 'Write-Verbose'
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