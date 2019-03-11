Function Update-AtwsDiskCache {
  <#
      .SYNOPSIS
      This function reads all entities with detailed fieldinfo and writes everything to disk.
      .DESCRIPTION
      This function reads all entities with detailed fieldinfo and writes everything to disk.
      .INPUTS
      None.
      .OUTPUTS
      Nothing (writes data to disk)
      .EXAMPLE
      Import-AtwsAPIVersionToCache
      Gets all valid built-in fields and user defined fields for the Account entity.
  #>
	
  [cmdletbinding(
      SupportsShouldProcess = $True,
      ConfirmImpact = 'Low'
  )]
  Param
  (
  )
  
  Begin
  {
    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
    # Check if we are connected before trying anything
    If (-not($Script:Atws)) {
      Throw [ApplicationException] 'Not connected to Autotask WebAPI. Re-import module with valid credentials.'
    }
    
    # Has cache been loaded?
    If (-not($script:Cache)) {
      # Load it.
      Import-AtwsDiskCache
    }
    # Load current API version from API
    $CurrentApiVersion = $Script:Atws.GetWsdlVersion()
  }

  Process 
  { 
    # Prepare parameters for @splatting
    $ProgressParameters = @{
      Activity = ('New API version {0} has been published, old version is {1}. recreating diskcache.' -F $CurrentApiVersion, $Script:Cache[$Script:Atws.CI].ApiVersion)
      Id = 9
    }
                 
    $script:FieldInfoCache = @{}
    $Entities = $Script:Atws.getEntityInfo()
        
    Foreach ($Object in $Entities) { 
    
      Write-Verbose -Message ('{0}: Importing detailed information about Entity {1}' -F $MyInvocation.MyCommand.Name, $Object.Name) 

      # Calculating progress percentage and displaying it
      $Index = $Entities.IndexOf($Object) + 1
      $PercentComplete = $Index / $Entities.Count * 100
      $Status = 'Entity {0}/{1} ({2:n0}%)' -F $Index, $Entities.Count, $PercentComplete
      $CurrentOperation = "GetFieldInfo('{0}')" -F $Object.Name
      
      Write-Progress -Status $Status -PercentComplete $PercentComplete -CurrentOperation $CurrentOperation @ProgressParameters
          
      $Caption = $MyInvocation.MyCommand.Name
      $VerboseDescrition = '{0}: Retreiving detailed field information about entity {1}' -F $Caption, $Object.Name
      $VerboseWarning = '{0}: About to post a SOAP query to Autotask Web API for detailed field info for entity {1}. Do you want to continue?' -F $Caption, $Object.Name
          
      If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
        # Retrieving FieldInfo for current Entity
        $FieldInfo = $Script:Atws.GetFieldInfo($Object.Name)
            
        # Check if entity has picklists
        $HasPickList = $False
        If ($FieldInfo.Where({$_.IsPicklist})) {
          $HasPickList = $True
        }
                       
        # Create Cache entry
        $CacheEntry = New-Object -TypeName PSObject -Property @{
          HasPickList   = $HasPickList
          RetrievalTime = Get-Date
        }
            
        # Check if entity has userdefined fields
        If ($Object.HasUserDefinedFields) {
          $UDF = $Script:Atws.GetUDFInfo($Object.Name)
          Add-Member -InputObject $CacheEntry -MemberType NoteProperty -Name UDFInfo -Value $UDF -Force
        }
                        
        # Add complext objects as properties
        Add-Member -InputObject $CacheEntry -MemberType NoteProperty -Name EntityInfo -Value $Object -Force
        Add-Member -InputObject $CacheEntry -MemberType NoteProperty -Name FieldInfo -Value $FieldInfo -Force
            
        $Script:FieldInfoCache[$Object.Name] = $CacheEntry
      }
    }
        
    # Add cache to $Cache object and save to disk
    $Script:Cache[$Script:Atws.CI] = New-Object -TypeName PSObject -Property @{
      ApiVersion = $CurrentApiVersion
    }
    # Use Add-member to store complete object, not its typename
    Add-Member -InputObject $Script:Cache[$Script:Atws.CI] -MemberType NoteProperty -Name FieldInfoCache -Value $FieldInfoCache 
    
    # Add new base reference
    $Script:Cache['00'] =New-Object -TypeName PSObject -Property @{
      ApiVersion = $CurrentApiVersion
    }
    
    # Clone current fieldinfo cache to new object
    $Base = $FieldInfoCache.Clone()
        
    # Clean Instance specific info from Base
    Foreach ($Object in $Base.GetEnumerator().Where({$_.Value.HasPickList -or $_.Value.EntityInfo.HasUserDefinedFields}))
    {
      Foreach ($PickList in $Object.Value.FieldInfo.Where({$_.IsPickList}))
      {
        $PickList.PicklistValues = $Null
      }
          
      If ($Object.Value.EntityInfo.HasUserDefinedFields)
      {
        $Object.UserDefinedFields = $Null
      }
    }
        
    # Use Add-member to store complete object, not its typename
    Add-Member -InputObject $Script:Cache['00'] -MemberType NoteProperty -Name FieldInfoCache -Value $Base 
      
  }
  
  End 
  { 
    # Write updated cache to disk
    Export-AtwsDiskCache
  }
}