<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

#>
Function Build-AtwsModule {
    <#
        .SYNOPSIS
            This function rebuilds the module based on updated info form the Autotask API
        .DESCRIPTION
            This functions first verifies that you have write permissions to the module directory,
            then proceeds with refreshing the entity cache from online data and rebuilds all
            entity functions based on the updated entity cache.
        .INPUTS
            Nothing.
        .OUTPUTS
            Script files in module directory.
        .EXAMPLE
            Build-AtwsModule
        .NOTES
            NAME: Build-AtwsModule
    #>

    [CmdLetBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'High'
    )]
   
    Param(
        [switch]    
        $Force
    )
  
    begin { 
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
        if (-not($Script:Atws.integrationsValue)) {
            Throw [ApplicationException] 'Not connected to Autotask WebAPI. Connect with Connect-AtwsWebAPI. For help use "get-help Connect-AtwsWebAPI".'
        }

        if ($Force.IsPresent -and -not $Confirm) {
            $ConfirmPreference = 'none'
        }

        # Prepare parameters for @splatting
        $ProgressId = 6
        $ProgressParameters = @{
            Activity = 'Creating and importing functions for all static Autotask entities (no picklists).'
            Id       = $ProgressId
        }
    } 
  
    process {
           
        
        $RootPath = $MyInvocation.MyCommand.Module.ModuleBase
        $manifest = Join-Path $RootPath -ChildPath 'Autotask.psd1'
        
        Try { [io.file]::OpenWrite($manifest).close() }
        Catch { 
            Write-Warning "You do not have write access to the directory $RootPath" 
            return
        }
        
        # Rebuild ramcache
        Update-AtwsRamCache

        # Rebuild all functions
        Update-AtwsFunctions
    
    } # Process
    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)        
    }
}
