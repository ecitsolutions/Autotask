<#
    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

    .SYNOPSIS
    Test if the module can be imported without error
    .DESCRIPTION
    Test the various ways this module can be imported. Requires valid Autotask credentials and an Api Tracking identifier.
#>

$ModuleName = 'Autotask'

$ModulePath = '{0}\{1}' -F $(Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)), $ModuleName


Describe "$ModuleName Module Manifest tests" -Tag 'Manifest' {

  Context 'Module Setup' {
    It "has the root module $ModuleName.psm1" {
      "$ModulePath\$ModuleName.psm1" | Should -Exist
    }

    It "has the a manifest file of $ModuleName.psd1" {
      "$ModulePath\$ModuleName.psd1" | Should -Exist
      "$ModulePath\$ModuleName.psd1" | Should -FileContentMatch "$ModuleName.psm1"
    }
    
    It "$ModulePath\Dynamic folder has functions" {
      "$ModulePath\Dynamic\*.ps1" | Should -Exist
    }
    It "$module\Static folder has functions" {
      "$ModulePath\Static\*.ps1" | Should -Exist
    }
    It "$module\Private folder has functions" {
      "$ModulePath\Private\*.ps1" | Should -Exist
    }
    It "$module\Public folder has functions" {
      "$ModulePath\Public\*.ps1" | Should -Exist
    }

    It "$ModuleName is valid PowerShell code" {
      $psFile = Get-Content -Path "$ModulePath\$ModuleName.psm1" `
        -ErrorAction Stop
      $errors = $null
      $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
      $errors.Count | Should -Be 0
    }

  } # Context 'Module Setup'

}

Describe "$ModuleName Module function tests" -Tag 'Functions' { 

  Foreach ($directory in 'Dynamic', 'Static', 'Private', 'Public') { 
    
    $subdir = '{0}\{1}' -F $ModulePath, $directory 

    $functions = (Get-ChildItem -Path $subdir -Exclude *-AtwsDefinition.ps1).BaseName

    foreach ($function in $functions) {
  
      Context "Test Function $function" {
      
        It "$function.ps1 should have help block" {
          "$subdir\$function.ps1" | Should -FileContentMatch '<#'
          "$subdir\$function.ps1" | Should -FileContentMatch '#>'
        }

        It "$function.ps1 should have a SYNOPSIS section in the help block" {
          "$subdir\$function.ps1" | Should -FileContentMatch '.SYNOPSIS'
        }
    
        It "$function.ps1 should have a DESCRIPTION section in the help block" {
          "$subdir\$function.ps1" | Should -FileContentMatch '.DESCRIPTION'
        }

        It "$function.ps1 should have a EXAMPLE section in the help block" {
          "$subdir\$function.ps1" | Should -FileContentMatch '.EXAMPLE'
        }
    
        It "$function.ps1 should be an advanced function" {
          "$subdir\$function.ps1" | Should -FileContentMatch 'function'
          "$subdir\$function.ps1" | Should -FileContentMatch 'cmdletbinding'
          "$subdir\$function.ps1" | Should -FileContentMatch 'param'
        }
      
        It "$function.ps1 should contain Write-Verbose blocks" {
          "$subdir\$function.ps1" | Should -FileContentMatch 'Write-Verbose'
        }

        It "$function.ps1 should contain Write-Debug blocks" {
          "$subdir\$function.ps1" | Should -FileContentMatch 'Write-Debug'
        }

        It "$function.ps1 is valid PowerShell code" {
          $psFile = Get-Content -Path "$subdir\$function.ps1" `
            -ErrorAction Stop
          $errors = $null
          $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
          $errors.Count | Should -Be 0
        }
    
      } # Context "Test Function $function"

    } # foreach ($function in $functions)

  }

}