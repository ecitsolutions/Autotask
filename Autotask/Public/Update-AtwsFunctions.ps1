<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

#>
Function Update-AtwsFunctions {
    <#
        .SYNOPSIS
            This function recreates the autotask powershell functions.
        .DESCRIPTION
            Entities with picklists need customized parameter definitions to get the right validateset
            attributes. This function regenerates either static functions (those for entities that do not
            have any picklists or user defined fields) or dynamic functions (any function for an entity
            with either picklists or user defined fields).
        .INPUTS
            A string representing the function set to regenerate, either Static or Dynamic.
        .OUTPUTS
            Script files in module directory and the current user's dynamic cache.
        .EXAMPLE
            Update-AtwsFunctions -FunctionSet Static
            Regenerates all static functions in $Module.Modulebase/Static directory
        .EXAMPLE
            Update-AtwsFunctions -FunctionSet Dynamic
            Regenerates all static functions in $Module.Modulebase/Dynamic directory and the current user's
            dynamic cache directory.
        .NOTES
            NAME: Update-AtwsFunctions
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
            # Not connected. Try to connect, prompt for credentials if necessary
            Write-Verbose ('{0}: Not connected. Calling Connect-AtwsWebApi without parameters for possible autoload of default connection profile.' -F $MyInvocation.MyCommand.Name)
            Connect-AtwsWebAPI
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
        
        # Create Rootpath directory if it doesn't exist
        if (-not (Test-Path $RootPath)) {
            $null = New-Item -Path "$RootPath" -ItemType Directory -Force
        }
        
        $Entities = $Script:FieldInfoCache.keys | Where-Object {$_ -ne 'APIVersion'}
      
        # Prepare parameters for @splatting
        $ProgressParameters = @{
            Activity = 'Creating and importing functions for all {0} Autotask entities.' -F $FunctionSet
            Id       = 6
        }
      
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: Creating and overwriting {1} functions for {2} entities' -F $caption, $FunctionSet, $Entities.count
        $verboseWarning = '{0}: About to create and overwrite {1} functions for {2} entities. Do you want to continue?' -F $caption, $FunctionSet, $Entities.count
       
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
            # Prepare Index for progressbar
            $Index = 0
        
            Write-Verbose -Message ('{0}: Creating functions for {1} entities.' -F $MyInvocation.MyCommand.Name, $Entities.count) 
            
            foreach ($EntityName in $Entities) {

                # EntityInfo()
                $Entity = $Script:FieldInfoCache[$EntityName]
      
                Write-Debug -Message ('{0}: Creating functions for entity {1}' -F $MyInvocation.MyCommand.Name, $Entity.Name) 
      
                # Calculating progress percentage and displaying it
                $Index++
                $PercentComplete = $Index / $Entities.Count * 100
      
                # Add parameters for @splatting
                $ProgressParameters['PercentComplete'] = $PercentComplete
                $ProgressParameters['Status'] = 'Entity {0}/{1} ({2:n0}%)' -F $Index, $Entities.Count, $PercentComplete
                $ProgressParameters['CurrentOperation'] = 'Importing {0}' -F $Entity.Name
      
                Write-AtwsProgress @ProgressParameters
      
                $caption = $MyInvocation.MyCommand.Name
                $verboseDescription = '{0}: Creating and Invoking functions for entity {1}' -F $caption, $Entity.Name
                $verboseWarning = '{0}: About to create and Invoke functions for entity {1}. Do you want to continue?' -F $caption, $Entity.Name
       
                $FunctionDefinition = Get-AtwsFunctionDefinition -Entity $Entity
        
        
                foreach ($Function in $FunctionDefinition.GetEnumerator()) {
  
                    Write-Debug -Message ('{0}: Writing file for function  {1}' -F $MyInvocation.MyCommand.Name, $Function.Key)
                        
                    $FilePath = '{0}\Functions\{1}.ps1' -F $RootPath, $Function.Key
          
                    $verboseDescription = '{0}: Overwriting {1}' -F $caption, $FilePath
                    $verboseWarning = '{0}: About to overwrite {1}. Do you want to continue?' -F $caption, $FilePath

                    if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) {
                        Set-Content -Path $FilePath -Value $Function.Value -Force -Encoding UTF8
                    }
                } # foreach $Function
            } # foreach $Cacheentry
        } # Shouldprocess

        
        if ($progressParameters['CurrentOperation']) { 
            Write-AtwsProgress @progressParameters -Completed
        }
    } # Process
    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)        
    }
}
