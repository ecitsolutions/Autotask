
Function Import-AtwsCmdLet
{
  [CmdLetBinding(
      SupportsShouldProcess = $True,
      ConfirmImpact = 'Medium'
  )]
  Param(
    [PSObject[]]
    $Entities = $(Get-AtwsFieldInfo -Dynamic)
  )
  
  Begin
  { 
    # Prepare parameters for @splatting
    $ProgressId = 2
    $ProgressParameters = @{
      Activity = 'Creating and importing functions for all Autotask entities with picklists.'
      Id = $ProgressId
    }
                
    Write-Verbose -Message ('{0}: Start of functions.' -F $MyInvocation.MyCommand.Name)
    
    $RootPath = '{0}\WindowsPowershell\Cache\{1}' -f $([environment]::GetFolderPath('MyDocuments')), $Script:Atws.CI
    
    If (-not (Test-Path "$RootPath\Dynamic")) {
      $Null = New-Item -Path "$RootPath\Dynamic" -ItemType Directory -Force
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
      
      $Caption = $MyInvocation.MyCommand.Name
      $VerboseDescription = '{0}: Creating and Invoking functions for entity {1}' -F $Caption, $Entity.Name
      $VerboseWarning = '{0}: About to create and Invoke functions for entity {1}. Do you want to continue?' -F $Caption, $Entity.Name
       
      $FunctionDefinition = Get-AtwsFunctionDefinition -Entity $Entity -FieldInfo $CacheEntry.Value.FieldInfo
        
      If ($PSCmdlet.ShouldProcess($VerboseDescription, $VerboseWarning, $Caption)) { 
      
        Foreach ($Function in $FunctionDefinition.GetEnumerator()) {
          # Set path to powershell script file in user cache
          $FilePath = '{0}\Dynamic\{1}.ps1' -F $RootPath, $Function.Key
          
          # IMport the updated function
          . ([ScriptBlock]::Create($Function.Value))
          
          # Export the module member
          Export-ModuleMember -Function $Function.Key
          
          # Write the function to disk for faster load later
          Set-Content -Path $FilePath -Value $Function.Value -Force -Encoding UTF8           
        }
      }
    }        

  }
  End
  {
    Write-Verbose -Message ('{0}: Imported {1} dynamic functions' -F $MyInvocation.MyCommand.Name, $Index)
  }
}
