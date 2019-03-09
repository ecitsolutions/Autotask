
Function Update-StaticFunctions
{
  [CmdLetBinding(
      SupportsShouldProcess = $True,
      ConfirmImpact = 'Medium'
  )]
  Param()
  
  Begin
  { 
    # Prepare parameters for @splatting
    $ProgressId = 6
    $ProgressParameters = @{
      Activity = 'Creating and importing functions for all static Autotask entities (no picklists).'
      Id = $ProgressId
    }
                
    Write-Verbose -Message ('{0}: Loading a list over available entities.' -F $MyInvocation.MyCommand.Name)
    
    $Caption = $MyInvocation.MyCommand.Name
    $VerboseDescription = '{0}: Calling API.EntityInfo()' -F $Caption
    $VerboseWarning = '{0}: About to call API.EntityInfo(). Do you want to continue?' -F $Caption

    If ($PSCmdlet.ShouldProcess($VerboseDescription, $VerboseWarning, $Caption))
    {
      $Entities = Get-FieldInfo -Static
    }
    Else
    {
      $Entities = @{}
    }
  } 
  
  Process
  {
            
    # Prepare Index for progressbar
    $Index = 0
    
    Foreach ($CacheEntry in $Entities.GetEnumerator()) {
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
      
       
      $VerboseDescription = '{0}: Creating and Invoking functions for entity {1}' -F $Caption, $Entity.Name
      $VerboseWarning = '{0}: About to create and Invoke functions for entity {1}. Do you want to continue?' -F $Caption, $Entity.Name
       
      $FunctionDefinition = Get-AtwsFunctionDefinition -Entity $Entity -FieldInfo $CacheEntry.Value.FieldInfo
        
      If ($PSCmdlet.ShouldProcess($VerboseDescription, $VerboseWarning, $Caption))
      { 
        Foreach ($Function in $FunctionDefinition.GetEnumerator())
        {
  
          Write-Verbose -Message ('{0}: Writing file for function  {1}' -F $MyInvocation.MyCommand.Name, $Function.Key)
                        
          $FilePath = '{0}\Public\{1}.ps1' -F $MyInvocation.MyCommand.Module.ModuleBase, $Function.Key
          
          $VerboseDescrition = '{0}: Overwriting {1}' -F $Caption, $FilePath
          $VerboseWarning = '{0}: About to overwrite {1}. Do you want to continue?' -F $Caption, $FilePath

          If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption))
          {
            Set-Content -Path $FilePath -Value $Function.Value -Force -Encoding UTF8
          }
         
        }
        
        $BaseEntityInfo = @{}
        $BaseEntityInfo['00'] = $script:Cache['00']
        
        $BaseEntityInfoPath = '{0}\AutotaskFieldInfoCache.xml' -F $MyInvocation.MyCommand.Module.ModuleBase
        $BaseEntityInfo | Export-Clixml -Path $BaseEntityInfoPath -Force
        
   
      }
    }        

  }
  End
  {
    Write-Verbose -Message ('{0}: Imported {1} dynamic functions' -F $MyInvocation.MyCommand.Name, $Index)
  }
}
