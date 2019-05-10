
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
    
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}  
              
    Write-Debug -Message ('{0}: Start of functions.' -F $MyInvocation.MyCommand.Name)
       
  } 
  
  Process
  {
            
    # Prepare Index for progressbar
    $Index = 0
    
    Write-Verbose -Message ('{0}: Creating functions for {1} entities' -F $MyInvocation.MyCommand.Name, $Entities.count) 
        
    Foreach ($CacheEntry in $Entities.GetEnumerator()) {
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
      
      $Caption = $MyInvocation.MyCommand.Name
      $VerboseDescription = '{0}: Creating and Invoking functions for entity {1}' -F $Caption, $Entity.Name
      $VerboseWarning = '{0}: About to create and Invoke functions for entity {1}. Do you want to continue?' -F $Caption, $Entity.Name
       
      $FunctionDefinition = Get-AtwsFunctionDefinition -Entity $Entity -FieldInfo $CacheEntry.Value.FieldInfo
        
      If ($PSCmdlet.ShouldProcess($VerboseDescription, $VerboseWarning, $Caption)) { 
      
        Foreach ($Function in $FunctionDefinition.GetEnumerator()) {
       
          # Import the updated function and overwrite definition loaded from disk
          . ([ScriptBlock]::Create($Function.Value))
          
        }
      }
    }        

  }
  End
  {
    Write-Debug -Message ('{0}: Imported {1} dynamic functions' -F $MyInvocation.MyCommand.Name, $Index)
  }
}
