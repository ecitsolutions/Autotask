
Function Import-AtwsCmdLet
{
  [CmdLetBinding(
      SupportsShouldProcess = $True,
      ConfirmImpact = 'Medium'
  )]
  Param
  (
    [Parameter(Mandatory = $True)]
    [String]    
    $ModuleName,
    
    [Switch]
    $NoDiskCache,
    
    [Switch]
    $RefreshCache,
    
    [String]
    $Prefix = 'Atws'
  )
  
  Begin
  { 
    If (-not($global:AtwsConnection[$Prefix].Url))
    {
      Throw [ApplicationException] 'Not connected to Autotask WebAPI. Run Connect-AutotaskWebAPI first.'
    }
    Else
    {
      $local:Atws = $global:AtwsConnection[$Prefix]
    }
    
    Write-Verbose -Message ('{0}: Calling  API.EntityInfo() to get list over available entities.' -F $MyInvocation.MyCommand.Name)
    
    $Caption = $MyInvocation.MyCommand.Name
    $VerboseDescrition = '{0}: Calling API.EntityInfo()' -F $Caption
    $VerboseWarning = '{0}: About to call API.EntityInfo(). Do you want to continue?' -F $Caption

    If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption))
    {
      $Entities = $Atws.getEntityInfo()
    }
    Else
    {
      $Entities = @()
    }
    
    # A hashtable to keep track of fieldinfo pr entity. Keep it in the script and called functions
    $Script:FieldTable = @{}
    
    # An array to contain text that will be converted to a scriptblock
    $ModuleFunctions = @()
    
    $CacheInfo = Get-AtwsCacheInfo -Prefix $Prefix 
  } 
  
  Process
  {

    If ($CacheInfo.CacheDirty -or $NoDiskCache.IsPresent -or $RefreshCache.IsPresent) { 
      Write-Verbose -Message ('{0}: Generating new functions (CacheDirty: {1}, NoDiskCache: {2}, RefreshCache: {3}) ' -F $MyInvocation.MyCommand.Name, $CacheInfo.CacheDirty.ToString(), $NoDiskCache.IsPresent.ToString(), $RefreshCache.IsPresent.ToString())
      
      $Activity = 'Downloading detailed information about all Autotask entity types'
      $ParentId = 1
      
      

      Foreach ($Entity in $Entities) { 
        Write-Verbose -Message ('{0}: Importing detailed information about Entity {1}' -F $MyInvocation.MyCommand.Name, $Entity.Name) 
        
        $FieldTable[$Entity.Name] = Get-AtwsFieldInfo -Entity $Entity.Name

        # Calculating progress percentage and displaying it
        $Index = $Entities.IndexOf($Entity) + 1
        $PercentComplete = $Index / $Entities.Count * 100
        $Status = 'Entity {0}/{1} ({2:n0}%)' -F $Index, $Entities.Count, $PercentComplete
        $CurrentOperation = "GetFieldInfo('{0}')" -F $Entity.Name
        Write-Progress -ParentId $ParentId -Activity $Activity -Status $Status -PercentComplete $PercentComplete -CurrentOperation $CurrentOperation
      
        $VerboseDescrition = '{0}: Creating and Invoking functions for entity {1}' -F $Caption, $Entity.Name
        $VerboseWarning = '{0}: About to create and Invoke functions for entity {1}. Do you want to continue?' -F $Caption, $Entity.Name
      }
      
      $Activity = 'Creating and importing functions for all Autotask entities.'
            
      Foreach ($Entity in $Entities) {
        Write-Verbose -Message ('{0}: Creating functions for entity {1}' -F $MyInvocation.MyCommand.Name, $Entity.Name) 
      
        # Calculating progress percentage and displaying it
        $Index = $Entities.IndexOf($Entity) + 1
        $PercentComplete = $Index / $Entities.Count * 100
        $Status = 'Entity {0}/{1} ({2:n0}%)' -F $Index, $Entities.Count, $PercentComplete
        $CurrentOperation = 'Importing {0}' -F $Entity.Name
        
        Write-Progress -ParentId $ParentId -Activity $Activity -Status $Status -PercentComplete $PercentComplete -CurrentOperation $CurrentOperation
      
        $VerboseDescrition = '{0}: Creating and Invoking functions for entity {1}' -F $Caption, $Entity.Name
        $VerboseWarning = '{0}: About to create and Invoke functions for entity {1}. Do you want to continue?' -F $Caption, $Entity.Name
       
        $FunctionDefinition = Get-AtwsFunctionDefinition -Entity $Entity -Prefix $Prefix -FieldInfo $FieldTable[$Entity.Name] 
        
        If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
          Foreach ($Function in $FunctionDefinition.GetEnumerator()) {
  
            If (-Not $NoDiskCache.IsPresent) {
              Write-Verbose -Message ('{0}: Writing file for function  {1}' -F $MyInvocation.MyCommand.Name, $Function.Key)
                        
              $FilePath = '{0}\{1}.ps1' -F $CacheInfo.CacheDir, $Function.Key
          
              $VerboseDescrition = '{0}: Overwriting {1}' -F $Caption, $FilePath
              $VerboseWarning = '{0}: About to overwrite {1}. Do you want to continue?' -F $Caption, $FilePath

              If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) {
                Set-Content -Path $FilePath -Value $Function.Value -Force -Encoding UTF8
              }
            }
                 
            $ModuleFunctions += $Function.Value
          }
          
        }
      }        
      
                
      Write-Verbose -Message ('{0}: Writing Moduleversion info to  {1}' -F $MyInvocation.MyCommand.Name, $CacheInfo.CachePath)
                
      $ModuleVersionInfo = New-Object -TypeName PSObject -Property @{
        APIversion    = $CacheInfo.APIversion
        ModuleVersion = $CacheInfo.ModuleVersion
        CI            = $CacheInfo.CI
      }
      
      # Write Cache info to disk
      Export-Clixml -InputObject $ModuleVersionInfo -Path $CacheInfo.CachePath -Encoding UTF8
      Write-Progress -ParentId $ParentId -Activity $Activity -Completed

    }
    Else {
      Write-Verbose -Message ('{0}: Reading function definitions from {1}' -F $MyInvocation.MyCommand.Name, $CacheInfo.CachePath)
      $CacheFiles = '{0}\*.ps1' -F $CacheInfo.CacheDir
      Foreach ($File in Get-ChildItem -Path $CacheFiles) { 
        $ModuleFunctions += Get-Content -Path $File.FullName -Encoding UTF8 -Raw
      }
    }
    
    Write-Verbose -Message ('{0}: Including private functions in dynamic mocule' -F $MyInvocation.MyCommand.Name)   
    $PrivateFunctions = @(
      'Get-CallerPreference',
      'ConvertTo-PSObject',
      'Get-AtwsFieldInfo',
      'Get-AtwsInvoiceInfo'
    ) 
    Foreach ($FunctionName in $PrivateFunctions) {
    
      # Prepare a new function name with current prefix
      $NewFunctionName = $FunctionName -replace 'Atws', $Prefix
      
      # Select the sourcefile of the private function to include
      $FunctionFile = $PrivateFunction.Where({$_.BaseName -eq $FunctionName})
      
      # Read the source file, replace #Prefix and functionname and include in dynamic module
      $ModuleFunctions += (Get-Content $FunctionFile.FullName) -replace '#Prefix', $Prefix -replace $FunctionName,$NewFunctionName
    }

  }
  End
  {
    Write-Verbose -Message ('{0}: Importing Autotask Dynamic Module' -F $MyInvocation.MyCommand.Name)
    
    # Have PowerShell convert all of our dynamically generated code to a scriptblock
    # (no error checks! Well, you probably notice if something goes wrong...)
    $FunctionScriptBlock = [ScriptBlock]::Create($($ModuleFunctions))
        
    # Simply import the scriptblock as a module. Simple as that. I cannot decide if this is 
    # awesome or scary as h...!
    New-Module -Name $ModuleName -ScriptBlock $FunctionScriptBlock  | Import-Module -Global         
    
  }
}
