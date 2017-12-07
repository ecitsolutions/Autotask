<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function New-AtwsData {
    [cmdletbinding(
        SupportsShouldProcess = $True,
        ConfirmImpact = 'Medium'
    )]
    param
    (
        [Parameter(
            Mandatory = $True,
            Position = 0
        )]
        [PSObject[]]
        $Entity
    )
   
    Begin { 
        If (-not($global:atws.Url)) {   
            Throw [ApplicationException] 'Not connected to Autotask WebAPI. Run Connect-AutotaskWebAPI first.'
        }
        $EndResult = @()
    }
    
    Process { 
        Write-Verbose ('{0}: Creating a new object of type Autotask.{1}' -F $MyInvocation.MyCommand.Name, $Entity) 

        $Caption = 'New-Atws{0}' -F $Entity.GetType().Name    
        $VerboseDescrition = '{0}: About to create an Autotask.{1}. This action cannot be undone (but the object can usually be deleted).' -F $Caption, $Entity.GetType().Name
        $VerboseWarning = '{0}: About to create an Autotask.{1}. This action cannot be undone (but the object can usually be deleted). Do you want to continue?' -F $Caption, $Entity.GetType().Name
    
        Write-Verbose ('{0}: Running ShouldProcess with WhatifPreference {1} and ConfirmPreference {2}' -F $MyInvocation.MyCommand.Name, $WhatIfPreference, $ConfirmPreference)    
        If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
            # create() function can take up to 200 objects at a time
            For ($i = 0; $i -lt $Entity.count; $i += 200) {
                $j = $i + 199
                If ($j -gt ($Entity.count - 1)) {
                    $j = $Entity.count - 1
                } 
                Write-Verbose ('{0}: Creating chunk from index {1} to index {2}' -F $MyInvocation.MyCommand.Name, $i, $j)        
                $Result = $Atws.Create($Entity[$i .. $j])
                If ($Result.Errors.Count -eq 0) {
                    $EndResult += $Result.EntityResults
                }
                Else {
                    Foreach ($AtwsError in $Result.Errors) {
                        Write-Error $AtwsError.Message
                    }
                }
            }
        }
    }
    End {
        Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name) 
        Return $EndResult  
    }
}