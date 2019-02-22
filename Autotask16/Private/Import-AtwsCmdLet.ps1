
Function Import-AtwsCmdLet
{
  [CmdLetBinding(
      SupportsShouldProcess = $True,
      ConfirmImpact = 'Medium'
  )]
  Param
  (
    [Switch]
    $RefreshCache
  )
  
  Begin
  { 
           
    Write-Verbose -Message ('{0}: Loading a list over available entities.' -F $MyInvocation.MyCommand.Name)
    
    $Caption = $MyInvocation.MyCommand.Name
    $VerboseDescription = '{0}: Calling API.EntityInfo()' -F $Caption
    $VerboseWarning = '{0}: About to call API.EntityInfo(). Do you want to continue?' -F $Caption

    If ($PSCmdlet.ShouldProcess($VerboseDescription, $VerboseWarning, $Caption))
    {
      $Entities = Get-FieldInfo -All
    }
    Else
    {
      $Entities = @{}
    }

  } 
  
  Process
  {
  
    $Activity = 'Creating and importing functions for all Autotask entities.'
            
    # Prepare Index for progressbar
    $Index = 0
    Foreach ($CacheEntry in $Entities.GetEnumerator()) {
      # EntityInfo()
      $Entity = $CacheEntry.Value.EntityInfo
      
      Write-Verbose -Message ('{0}: Creating functions for entity {1}' -F $MyInvocation.MyCommand.Name, $Entity.Name) 
      
      # Calculating progress percentage and displaying it
      $Index++
      $PercentComplete = $Index / $Entities.Count * 100
      $Status = 'Entity {0}/{1} ({2:n0}%)' -F $Index, $Entities.Count, $PercentComplete
      $CurrentOperation = 'Importing {0}' -F $Entity.Name
        
      Write-Progress -Activity $Activity -Status $Status -PercentComplete $PercentComplete -CurrentOperation $CurrentOperation
      
       
      $VerboseDescription = '{0}: Creating and Invoking functions for entity {1}' -F $Caption, $Entity.Name
      $VerboseWarning = '{0}: About to create and Invoke functions for entity {1}. Do you want to continue?' -F $Caption, $Entity.Name
       
      $FunctionDefinition = Get-AtwsFunctionDefinition -Entity $Entity -FieldInfo $CacheEntry.Value.FieldInfo
        
      If ($PSCmdlet.ShouldProcess($VerboseDescription, $VerboseWarning, $Caption)) { 
      
         Foreach ($Function in $FunctionDefinition.GetEnumerator()) {
          . ([ScriptBlock]::Create($Function.Value))
          Export-ModuleMember -Function $Function.Key
        }
      }
    }        

  }
  End
  {
    Write-Verbose -Message ('{0}: Imported {1} dynamic functions' -F $MyInvocation.MyCommand.Name, $Index)
  }
}
