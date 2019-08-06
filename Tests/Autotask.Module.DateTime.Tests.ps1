<#
        .COPYRIGHT
        Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
        See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

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

$loadedModule = Get-Module -Name $ModuleName
If (-not ($loadedModule)) { 
    # Import the module. Issues that need their own load version will have to do so in their context
    Import-Module $modulePath -Force -ArgumentList $Credential, $ApiTrackingIdentifier
}

describe "DateTime tests" {

    context 'RoundTrip - A date returned by the API is encoded correctly when used in a query' {
        $account0 = Get-AtwsAccount -id 0
        $account =  Get-AtwsAccount -id 0 -CreateDate $account0.CreateDate 
        it 'should be an account' {
            $account | Should -BeOfType Autotask.Account
        }

    } # context 'Module Setup'

    context 'DateTime' {
        $resource = Get-AtwsResource -UserType 'Full Access (system)' | Select-Object -First 1 # There should be at least 1
        $startDate = Get-Date 2030.01.01 -hour 8
        $endDate = Get-Date 2030.12.31 -hour 16
        $newEndDate = Get-Date 2030.12.01 -hour 16
        $todoParams = @{
            AccountId = 0 # Use system account
            AssignedToResourceId = $resource.id
            StartDateTime = $startDate
            EndDateTime = $endDate
            ActionType = 'Quick Note'
        }
        
        $todo = New-AtwsAccountToDo @todoParams
        
        it 'should have the same dates in the return object as specified' {
            $todo.StartDateTime | Should -Be $startDate
            $todo.EndDateTime | Should -Be $endDate
        }
        
        $newTodo = Set-AtwsAccountToDo -InputObject $todo -EndDateTime $newEndDate -PassThru
        
        it 'should not change an unchanged date' {
            $newTodo.StartDateTime | Should -Be $startDate
        }
        
        it 'should update a modified date' {
            $newTodo.EndDateTime | Should -Be $newEndDate
        }
        
        $getTodo = Get-AtwsAccountToDo -StartDateTime $startDate -id $todo.id
        it 'should get an object filtered with the same date as original was created' {
            $getTodo | Should -BeOfType Autotask.AccountTodo
        }
        
        # Clean up
        $todo | Remove-AtwsAccountToDo
    }
    
    Context 'Dates' {
    
    }
}
