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
    # The function set to generate, either 'Dynamic' or 'Static'
    Param(
        [ValidateSet('Dynamic', 'Static')]
        [string]
        $FunctionSet = 'Static'
    )
  
    begin { 
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
        if (-not($Script:Atws.integrationsValue)) {
            Throw [ApplicationException] 'Not connected to Autotask WebAPI. Re-import module with valid credentials.'
        }
    
        # Prepare parameters for @splatting
        $ProgressId = 6
        $ProgressParameters = @{
            Activity = 'Creating and importing functions for all static Autotask entities (no picklists).'
            Id       = $ProgressId
        }
                
        Write-Verbose -Message ('{0}: Making sure cache is loaded.' -F $MyInvocation.MyCommand.Name)
    
        if (-not ($Script:Atws.Cache.Count -gt 0)) {
            Import-AtwsDiskCache
        }
   
    } 
  
    process {
           
        # Prepare parameters for @splatting
        $ParentProgressParameters = @{
            Activity = 'Going through cache entries.'
            Id       = 6
        }
      
        # Prepare Index for progressbar
        $ParentIndex = 0
    
        foreach ($Tenant in $Script:Atws.Cache.GetEnumerator()) { 
      
            # Calculating progress percentage and displaying it
            $ParentIndex++
            $PercentComplete = $ParentIndex / $Script:Atws.Cache.Count * 100
      
            # Add parameters for @splatting
            $ParentProgressParameters['PercentComplete'] = $PercentComplete
            $ParentProgressParameters['Status'] = 'Entity {0}/{1} ({2:n0}%)' -F $ParentIndex, $Script:Atws.Cache.Count, $PercentComplete
            $ParentProgressParameters['CurrentOperation'] = 'Importing {0}' -F $Entity.Key
      
            Write-AtwsProgress @ParentProgressParameters
        
        
            if ($Tenant.Key -eq '00') {
                $RootPath = $MyInvocation.MyCommand.Module.ModuleBase
            }
            elseif ($FunctionSet -eq 'Dynamic' -and $My.ContainsKey('DynamicCache') -and -not $My['IsBeta']) {
                $RootPath = $Script:Atws.DynamicCache
        
                # Create Rootpath directory if it doesn't exist
                if (-not (Test-Path $RootPath)) {
                    $null = New-Item -Path "$RootPath" -ItemType Directory -Force
                }
            }
            else {
                # Do not create static functions pr tenant
                Continue
            }
      
            $Entities = switch ($FunctionSet) {
                'Static' {
                    $Tenant.Value.FieldInfoCache.GetEnumerator() | Where-Object { -not $_.Value.HasPickList }
                }
                'Dynamic' {
                    $Tenant.Value.FieldInfoCache.GetEnumerator() | Where-Object { $_.Value.HasPickList }
                }
            }
      
            # Prepare parameters for @splatting
            $ProgressParameters = @{
                Activity = 'Creating and importing functions for all {0} Autotask entities.' -F $FunctionSet
                Id       = 10
                ParentId = 6
            }
      
      
            $caption = $MyInvocation.MyCommand.Name
            $verboseDescription = '{0}: Creating and overwriting {1} functions for {2} entities' -F $caption, $FunctionSet, $Entities.count
            $verboseWarning = '{0}: About to create and overwrite {1} functions for {2} entities. Do you want to continue?' -F $caption, $FunctionSet, $Entities.count
       
            if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
                # Prepare Index for progressbar
                $Index = 0
        
                Write-Verbose -Message ('{0}: Creating functions for {1} entities.' -F $MyInvocation.MyCommand.Name, $Entities.count) 
            
                foreach ($CacheEntry in $Entities) {
                    # EntityInfo()
                    $Entity = $CacheEntry.Value.EntityInfo
      
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
       
                    $FunctionDefinition = Get-AtwsFunctionDefinition -Entity $Entity -FieldInfo $CacheEntry.Value.FieldInfo
        
        
                    foreach ($Function in $FunctionDefinition.GetEnumerator()) {
  
                        Write-Debug -Message ('{0}: Writing file for function  {1}' -F $MyInvocation.MyCommand.Name, $Function.Key)
                        
                        $FilePath = '{0}\{1}\{2}.ps1' -F $RootPath, $FunctionSet, $Function.Key
          
                        $verboseDescription = '{0}: Overwriting {1}' -F $caption, $FilePath
                        $verboseWarning = '{0}: About to overwrite {1}. Do you want to continue?' -F $caption, $FilePath

                        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) {
                            Set-Content -Path $FilePath -Value $Function.Value -Force -Encoding UTF8
                        }
                    } # foreach $Function
                } # foreach $Cacheentry
            } # Shouldprocess
        } # foreach $TenantS
        
        if ($progressParameters['CurrentOperation']) { 
            Write-AtwsProgress @progressParameters -Completed
        }
    } # Process
    end {
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: Overwriting existing module info cache with updated data.' -F $caption
        $verboseWarning = '{0}: About to overwrite existing module info cache with updated data. This cannot be undone. Do you want to continue?' -F $caption
          
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
            # Save updated base info for connection to new tenants.
            $BaseEntityInfo = @{ }
            $BaseEntityInfo['00'] = $Script:Atws.Cache['00']
        
            $BaseEntityInfoPath = '{0}\Private\AutotaskFieldInfoCache.xml' -F $MyInvocation.MyCommand.Module.ModuleBase
            $BaseEntityInfo | Export-Clixml -Path $BaseEntityInfoPath -Force
    
            Write-Verbose -Message ('{0}: Updated central module fieldinfocache.' -F $MyInvocation.MyCommand.Name)
        }
    
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        
    }
}
