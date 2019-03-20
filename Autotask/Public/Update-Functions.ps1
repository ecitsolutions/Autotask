
Function Update-Functions {
  [CmdLetBinding(
      SupportsShouldProcess = $True,
      ConfirmImpact = 'High'
  )]
  Param(
    [ValidateSet('Dynamic','Static')]
    [String]
    $FunctionSet = 'Static'
  )
  
  Begin { 
    # Prepare parameters for @splatting
    $ProgressId = 6
    $ProgressParameters = @{
      Activity = 'Creating and importing functions for all static Autotask entities (no picklists).'
      Id       = $ProgressId
    }
                
    Write-Verbose -Message ('{0}: Making sure cache is loaded.' -F $MyInvocation.MyCommand.Name)
    
    If (-not ($Script:Cache)) {
      Import-AtwsDiskCache
    }
   
  } 
  
  Process {
           
    # Prepare parameters for @splatting
    $ParentProgressParameters = @{
      Activity = 'Going through cache entries.'
      Id       = 6
    }
      
    # Prepare Index for progressbar
    $ParentIndex = 0
    
    Foreach ($Tenant in $Script:Cache.GetEnumerator()) { 
      
      # Calculating progress percentage and displaying it
      $ParentIndex++
      $PercentComplete = $ParentIndex / $Script:Cache.Count * 100
      
      # Add parameters for @splatting
      $ParentProgressParameters['PercentComplete'] = $PercentComplete
      $ParentProgressParameters['Status'] = 'Entity {0}/{1} ({2:n0}%)' -F $ParentIndex, $Script:Cache.Count, $PercentComplete
      $ParentProgressParameters['CurrentOperation'] = 'Importing {0}' -F $Entity.Key
      
      Write-Progress @ParentProgressParameters
        
        
      If ($Tenant.Key -eq '00') {
        $RootPath = $MyInvocation.MyCommand.Module.ModuleBase
      }
      ElseIf ($FunctionSet -eq 'Dynamic') {
        $RootPath = '{0}\WindowsPowershell\Cache\{1}' -f $([environment]::GetFolderPath('MyDocuments')), $Tenant.Key
        
        # Create Rootpath directory if it doesn't exist
        If (-not (Test-Path "$RootPath\Dynamic")) {
          $Null = New-Item -Path "$RootPath\Dynamic" -ItemType Directory -Force
          
        }
      }
      Else {
        # Do not create static functions pr tenant
        Continue
      }
      
      $Entities = Switch ($FunctionSet) {
        'Static' {
          $Tenant.Value.FieldInfoCache.GetEnumerator() | Where-Object {-not $_.Value.HasPickList}
        }
        'Dynamic' {
          $Tenant.Value.FieldInfoCache.GetEnumerator() | Where-Object {$_.Value.HasPickList}
        }
      }
      
      # Prepare parameters for @splatting
      $ProgressParameters = @{
        Activity = 'Creating and importing functions for all static Autotask entities (no picklists).'
        Id       = 10
        ParentId = 6
      }
      
      
      $Caption = $MyInvocation.MyCommand.Name
      $VerboseDescription = '{0}: Creating and overwriting {1} functions for {2} entities' -F $Caption, $FunctionSet, $Entities.count
      $VerboseWarning = '{0}: About to create and oiverwrite {1} functions for {2} entities. Do you want to continue?' -F $Caption, $FunctionSet, $Entities.count
       
      If ($PSCmdlet.ShouldProcess($VerboseDescription, $VerboseWarning, $Caption)) { 
        # Prepare Index for progressbar
        $Index = 0
    
        Foreach ($CacheEntry in $Entities) {
          # EntityInfo()
          $Entity = $CacheEntry.Value.EntityInfo
      
          Write-Verbose -Message ('{0}: Creating functions for entity {1}' -F $MyInvocation.MyCommand.Name, $Entity.Name) 
      
          # Calculating progress percentage and displaying it
          $Index++
          $PercentComplete = $Index / $Entities.Count * 100
      
          # Add parameters for @splatting
          $ProgressParameters['PercentComplete'] = $PercentComplete
          $ProgressParameters['Status'] = 'Entity {0}/{1} ({2:n0}%)' -F $Index, $Entities.Count, $PercentComplete
          $ProgressParameters['CurrentOperation'] = 'Importing {0}' -F $Entity.Name
      
          Write-Progress @ProgressParameters
      
          $Caption = $MyInvocation.MyCommand.Name
          $VerboseDescription = '{0}: Creating and Invoking functions for entity {1}' -F $Caption, $Entity.Name
          $VerboseWarning = '{0}: About to create and Invoke functions for entity {1}. Do you want to continue?' -F $Caption, $Entity.Name
       
          $FunctionDefinition = Get-AtwsFunctionDefinition -Entity $Entity -FieldInfo $CacheEntry.Value.FieldInfo
        
        
          Foreach ($Function in $FunctionDefinition.GetEnumerator()) {
  
            Write-Verbose -Message ('{0}: Writing file for function  {1}' -F $MyInvocation.MyCommand.Name, $Function.Key)
                        
            $FilePath = '{0}\{1}\{2}.ps1' -F $RootPath, $FunctionSet, $Function.Key
          
            $VerboseDescrition = '{0}: Overwriting {1}' -F $Caption, $FilePath
            $VerboseWarning = '{0}: About to overwrite {1}. Do you want to continue?' -F $Caption, $FilePath

            If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) {
              Set-Content -Path $FilePath -Value $Function.Value -Force -Encoding UTF8
            }
          } # Foreach $Function
        } # Foreach $Cacheentry
      } # Shouldprocess
    } # Foreach $TenantS
  } # Process
  End {
    $Caption = $MyInvocation.MyCommand.Name
    $VerboseDescrition = '{0}: Overwriting existing module info cache with updated data.' -F $Caption
    $VerboseWarning = '{0}: About to overwrite existing module info cache with updated data. This cannot be undone. Do you want to continue?' -F $Caption
          
    If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
      # Save updated base info for connection to new tenants.
      $BaseEntityInfo = @{}
      $BaseEntityInfo['00'] = $script:Cache['00']
        
      $BaseEntityInfoPath = '{0}\AutotaskFieldInfoCache.xml' -F $MyInvocation.MyCommand.Module.ModuleBase
      $BaseEntityInfo | Export-Clixml -Path $BaseEntityInfoPath -Force
    
      Write-Verbose -Message ('{0}: Updated central module fieldinfocache.' -F $MyInvocation.MyCommand.Name)
    }
  }
}
