Remove-Module Autotask
Import-Module "C:\VS_git\Autotask\0.1.0.0\Autotask.psm1" -RequiredVersion "0.1.0.0"

InModuleScope Autotask {
    Describe '(UNIT TEST)Connect-AutotaskWebAPI' {
        Context 'Should NOT fail checks' {
            ## Mocks that makes external modules succeed
            #Mock -CommandName Connect-AutotaskWebAPI -MockWith { return $True }
            Mock -CommandName Connect-AutotaskWebAPI -MockWith { return $True }
            It 'Does not Throw' {
                { New-User @NewUserParams -ErrorAction Stop } | Should Not Throw
            }

            It 'Shoud not return Null or Empty' {
                New-User @NewUserParams | Should Not BeNullOrEmpty
            }
        }

        Context 'Should FAIL tests' {
            ## Mocks that makes external modules succeed
            It 'Should Throw on New-ADUser' {
                Mock -CommandName New-ADUser -MockWith { return $False } # FAIL
            
                { New-ADUser @NewUserParams -ErrorAction Stop } | Should Throw
            }

            It 'Should Throw on Get-ADUser' {
                Mock -CommandName New-ADUser -MockWith { return $True }
            
            }
        }
    }

    Describe 'CSV New-User' {
        
    }
}
