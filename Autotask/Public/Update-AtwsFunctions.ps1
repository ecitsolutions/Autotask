<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md  for license information.

#>
Function Update-AtwsFunctions {
 <#
      .SYNOPSIS
      This function updates the on-disk versions of all the cmdlets in this module.
      .DESCRIPTION
      This function loops through all entities in the entity cache and recreates the PowerShell code
      for each cmdlet both in the module directory and in the current users personal disk cache.
      .INPUTS
      Nothing.
      .OUTPUTS
      Powershell script files
      .EXAMPLE
      Update-AtwsFunctions
      Updates the default function set which is the static functions, i.e. any function that does not
      have any picklists.
      .EXAMPLE
      Update-AtwsFunctions -FunctionSet Static
      Updates the default function set which is the static functions, i.e. any function that does not
      have any picklists.
      .EXAMPLE
      Update-AtwsFunctions -FunctionSet Dynamic
      Updates the dynamic functions, i.e. any function that does have one or more fields that have picklists
      or the entity has userdefined fields.
      .NOTES
      NAME: Get-AtwsConnectionObject
      
  #>
  [CmdLetBinding(
      SupportsShouldProcess = $true,
      ConfirmImpact = 'High'
  )]
  Param(
    [ValidateSet('Dynamic','Static')]
    [string]
    $FunctionSet = 'Static'
  )
  
  begin { 
    # Enable modern -Debug behavior
    if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
    if (-not($Script:Atws.Url))
    {
      Throw [ApplicationException] 'Not connected to Autotask WebAPI. Re-import module with valid credentials.'
    }
    
    # Prepare parameters for @splatting
    $ProgressId = 6
    $ProgressParameters = @{
      Activity = 'Creating and importing functions for all static Autotask entities (no picklists).'
      Id       = $ProgressId
    }
                
    Write-Verbose -Message ('{0}: Making sure cache is loaded.' -F $MyInvocation.MyCommand.Name)
    
    if (-not ($Script:Cache)) {
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
    
    foreach ($Tenant in $Script:Cache.GetEnumerator()) { 
      
      # Calculating progress percentage and displaying it
      $ParentIndex++
      $PercentComplete = $ParentIndex / $Script:Cache.Count * 100
      
      # Add parameters for @splatting
      $ParentProgressParameters['PercentComplete'] = $PercentComplete
      $ParentProgressParameters['Status'] = 'Entity {0}/{1} ({2:n0}%)' -F $ParentIndex, $Script:Cache.Count, $PercentComplete
      $ParentProgressParameters['CurrentOperation'] = 'Importing {0}' -F $Entity.Key
      
      Write-Progress @ParentProgressParameters
        
        
      if ($Tenant.Key -eq '00') {
        $RootPath = $MyInvocation.MyCommand.Module.ModuleBase
      }
      elseif ($FunctionSet -eq 'Dynamic') {
        $RootPath = '{0}\WindowsPowershell\Cache\{1}' -f $([environment]::GetFolderPath('MyDocuments')), $Tenant.Key
        
        # Create Rootpath directory if it doesn't exist
        if (-not (Test-Path "$RootPath\Dynamic")) {
          $null = New-Item -Path "$RootPath\Dynamic" -ItemType Directory -Force
          
        }
      }
      else {
        # Do not create static functions pr tenant
        Continue
      }
      
      $Entities = switch ($FunctionSet) {
        'Static' {
          $Tenant.Value.FieldInfoCache.GetEnumerator() | Where-Object {-not $_.Value.HasPickList}
        }
        'Dynamic' {
          $Tenant.Value.FieldInfoCache.GetEnumerator() | Where-Object {$_.Value.HasPickList}
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
      
          Write-Progress @ProgressParameters
      
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
  } # Process
  end {
    $caption = $MyInvocation.MyCommand.Name
    $verboseDescription = '{0}: Overwriting existing module info cache with updated data.' -F $caption
    $verboseWarning = '{0}: About to overwrite existing module info cache with updated data. This cannot be undone. Do you want to continue?' -F $caption
          
    if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
      # Save updated base info for connection to new tenants.
      $BaseEntityInfo = @{}
      $BaseEntityInfo['00'] = $script:Cache['00']
        
      $BaseEntityInfoPath = '{0}\Private\AutotaskFieldInfoCache.xml' -F $MyInvocation.MyCommand.Module.ModuleBase
      $BaseEntityInfo | Export-Clixml -Path $BaseEntityInfoPath -Force
    
      Write-Verbose -Message ('{0}: Updated central module fieldinfocache.' -F $MyInvocation.MyCommand.Name)
    }
    
    Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        
  }
}
