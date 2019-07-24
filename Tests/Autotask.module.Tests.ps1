$here = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

$module = 'Autotask'

$moduledir = '{0}\{1}' -F $here, $module


Describe -Tags ('Unit', 'Acceptance') "$module Module Tests" {

  Context 'Module Setup' {
    It "has the root module $module.psm1" {
      "$moduledir\$module.psm1" | Should -Exist
    }

    It "has the a manifest file of $module.psd1" {
      "$moduledir\$module.psd1" | Should -Exist
      "$moduledir\$module.psd1" | Should -FileContentMatch "$module.psm1"
    }
    
    It "$module\Dynamic folder has functions" {
      "$moduledir\Dynamic\*.ps1" | Should -Exist
    }
    It "$module\Static folder has functions" {
      "$moduledir\Static\*.ps1" | Should -Exist
    }
    It "$module\Private folder has functions" {
      "$moduledir\Private\*.ps1" | Should -Exist
    }
    It "$module\Public folder has functions" {
      "$moduledir\Public\*.ps1" | Should -Exist
    }

    It "$module is valid PowerShell code" {
      $psFile = Get-Content -Path "$moduledir\$module.psm1" `
        -ErrorAction Stop
      $errors = $null
      $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
      $errors.Count | Should -Be 0
    }

  } # Context 'Module Setup'


  Foreach ($directory in 'Dynamic', 'Static', 'Private', 'Public') { 
    
    $subdir = '{0}\{1}' -F $moduledir, $directory 

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
<# 
      $testdir = '{0}\Tests\{1}' -F $here, $directory

      Context "$function has tests" {
        It "$($function).Tests.ps1 should exist" {
          "$testdir\$($function).Tests.ps1" | Should -Exist
        }
      }
#>  
    } # foreach ($function in $functions)

  }

}