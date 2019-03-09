<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>

Function Get-FieldInfo {
  <#
      .SYNOPSIS
      This function gets valid fields for an Autotask Entity
      .DESCRIPTION
      This function gets valid fields for an Autotask Entity
      .INPUTS
      None.
      .OUTPUTS
      [Autotask.Field[]]
      .EXAMPLE
      Get-FieldInfo -Entity Account
      Gets all valid built-in fields and user defined fields for the Account entity.
  #>
	
  [cmdletbinding(
      SupportsShouldProcess = $True,
      ConfirmImpact = 'Low',
      DefaultParameterSetName = 'by_Entity'
  )]
  Param
  (
    [Parameter(
        ParameterSetName = 'get_All'
    )]
    [Switch]
    $All,
    
    [Parameter(
        ParameterSetName = 'get_Static'
    )]
    [Switch]
    $Static, 
 
    [Parameter(
        ParameterSetName = 'get_Dynamic'
    )]
    [Switch]
    $Dynamic, 
     
    [Parameter(
        Mandatory = $True,
        ParameterSetName = 'by_Reference'
    )]
    [Switch]
    $ReferencingEntity,  
     
    [Parameter(
        ParameterSetName = 'by_Entity'
    )]
    [Alias('UDF')]
    [Switch]
    $UserDefinedFields, 
       
    [Parameter(
        Mandatory = $True,
        Position = 0,
        ParameterSetName = 'by_Entity'
    )]
    [Parameter(
        Mandatory = $True,
        Position = 0,
        ParameterSetName = 'by_Reference'
    )]
    [String]
    $Entity
  )
    
  Begin { 
  
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
    
    # If the current connection is for a new Autotask tenant, copy the blank 
    # cache from the included pre-cache
    If (-not ($Script:Cache.ContainsKey($Script:Atws.CI))) {
      # Create a cache object to store API version along with the cache
      $Script:Cache[$Script:Atws.CI] = New-Object -TypeName PSObject -Property @{
        ApiVersion = $Script:Cache['00'].ApiVersion
      }
      # Use Add-Member on the Hashtable, or the propertyvalue will be set to typename only
      # Clone the hashtable. We do NOT want a referenced copy!
      Add-Member -InputObject $Script:Cache[$Script:Atws.CI] -MemberType NoteProperty -Name FieldInfoCache -Value $Script:Cache['00'].FieldInfoCache.Clone()

    }
      
    # Initialize the short-hand variable reference for the fieldInfocache
    $Script:FieldInfoCache = $Script:Cache[$Script:Atws.CI].FieldInfoCache

    Write-Verbose -Message ('{0}: Loaded detailed Fieldinfo from diskcache' -F $MyInvocation.MyCommand.Name) 

    $CacheExpiry = (Get-Date).AddMinutes(-15)
  }
  
  Process { 
        
    # By ENTITY
    If ($PSCmdlet.ParameterSetName -eq 'by_Entity')
    {
      If (($script:FieldInfoCache[$Entity].HasPicklist -or $script:FieldInfoCache[$Entity].EntityInfo.HasUserDefinedFields) -and $script:FieldInfoCache[$Entity].RetrievalTime -lt $CacheExpiry) { 
        $Caption = $MyInvocation.MyCommand.Name
        $VerboseDescrition = '{0}: About to get built-in fields for {1}s' -F $Caption, $Entity
        $VerboseWarning = '{0}: About to get built-in fields for {1}s. Do you want to continue?' -F $Caption, $Entity

        If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
          $Result = $Script:atws.GetFieldInfo($Entity)
          $UDF = $Script:atws.GetUDFInfo($Entity)
        }
   
    
        If ($Result.Errors.Count -gt 0) {
          Foreach ($AtwsError in $Result.Errors) {
            Write-Error $AtwsError.Message
          }
          Return
        }
      
        # No errors
        # Test if value has changed
        If (Compare-PSObject -ReferenceObject $script:FieldInfoCache[$Entity].FieldInfo -DifferenceObject $Result) { 
     
          # No errors
          Write-Verbose ('{0}: Save or update FieldInfo cache for entity {1}' -F $MyInvocation.MyCommand.Name, $Entity)
          $script:FieldInfoCache[$Entity].FieldInfo = $Result
          
          Write-Warning ('Entity {0} has been modified in Autotask! Re-import module with -Force to refresh.' -F $Entity)
 
        }
        
        If ($script:FieldInfoCache[$Entity].EntityInfo.HasUserDefinedFields)
        { 
          If (Compare-PSObject -ReferenceObject $script:FieldInfoCache[$Entity].UDFInfo -DifferenceObject $UDF) { 
     
            # No errors
            Write-Verbose ('{0}: Save or update UDF cache for entity {1}' -F $MyInvocation.MyCommand.Name, $Entity)
            $script:FieldInfoCache[$Entity].UDFInfo = $UDF
          
            Write-Warning ('Entity {0} has been modified in Autotask! Re-import module with -Force to refresh.' -F $Entity)
 
          }
        }
        $script:FieldInfoCache[$Entity].RetrievalTime = Get-Date
      
        # Mark chache as dirty == dump to disk
        $CacheDirty = $True
      }
      Else {
        # Prepare an empty result set. If none of the conditions below are true, then the user tried to get
        # UDFs from an entity that does not support them. The result will be empty.
        $Result = @()  
        
        # If the user asked for UDFs and the entity supports UDFs, return the info. 
        If ($UserDefinedFields.IsPresent -and $script:FieldInfoCache[$Entity].EntityInfo.HasUserDefinedFields)
        {
          Write-Verbose ('{0}: Returning fieldinfo for entity {1} from cache' -F $MyInvocation.MyCommand.Name, $Entity)   
          $Result = $script:FieldInfoCache[$Entity].UDFInfo
        }
        # If the user askt for fieldinfo (default), return fieldinfo
        ElseIf ($PSCmdlet.ParameterSetName -eq 'by_Entity')
        { 
          Write-Verbose ('{0}: Returning fieldinfo for entity {1} from cache' -F $MyInvocation.MyCommand.Name, $Entity)   
          $Result = $script:FieldInfoCache[$Entity].FieldInfo
        }
      }
    }
    # ReferencingEntity
    ElseIf($PSCmdlet.ParameterSetName -eq 'by_Reference')
    {
      $Result = @()
      Foreach ($Object in $Script:FieldInfoCache.GetEnumerator())
      {
        $IsReferencing = $Object.Value.FieldInfo.Where({$_.ReferenceEntityType -eq $Entity})
        If($IsReferencing)
        {
          $Result += $Object.Name
        }
      }
    }
    # For all other options, check the cache version
    Else 
    { 
  
      # If the API version has been changed at the Autotask end we unfortunately have to load all
      # entities from scratch
      $CurrentApiVersion = $Script:Atws.GetWsdlVersion()
      If (-not ($Script:Cache[$Script:Atws.CI].ApiVersion -eq $CurrentApiVersion)) {
        
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
        $Script:Cache[$Script:Atws.CI].FieldInfoCache = $FieldInfoCache 
        $Script:Cache[$Script:Atws.CI].ApiVersion = $CurrentApiVersion
        $Script:Cache['00'].ApiVersion = $CurrentApiVersion
        $Base = $FieldInfoCache.Clone()
        
        # Clean Instance specific info from Base
        Foreach ($Object in $Base.GetEnumerator().Where({$_.Value.HasPickList -or $_.Value.EntityInfo.HasUserDefinedFields}))
        {
          Foreach ($PickList in $Object.FieldInfo.Where({$_.IsPickList}))
          {
            $PickList.PicklistValues = $Null
          }
          
          If ($Object.EntityInfo.HasUserDefinedFields)
          {
            $Object.UserDefinedFields = $Null
          }
        }
        
        $Script:Cache['00'].FieldInfoCache = $Base
        
        # Mark chache as dirty == dump to disk
        $CacheDirty = $True
        
        # Write-Warning to inform user that an update of static functions is due
        Write-Warning ('{0}: API version has been updated. You need to run Update-AtwsStaticFunctions with writepermissions to the module directory or update the module.' -F $MyInvocation.MyCommand.Name) 
        
      }
      # API version is the same, do we need to check picklists?
      ElseIf (@('get_All', 'get_Dynamic') -contains $PSCmdlet.ParameterSetName)
      { 
        # Prepare parameters for @splatting
        $ProgressParameters = @{
          Activity = 'All entities has been requested. Updating picklists.'
          Id = 9
        }
      
        $Entities = $script:FieldInfoCache.GetEnumerator().Where{$_.Value.HasPicklist -or $_.Value.EntityInfo.HasUserDefinedfields}
      
        Foreach ($Object in $Entities) {
      
          Write-Verbose -Message ('{0}: Importing detailed information about Entity {1}' -F $MyInvocation.MyCommand.Name, $Object.Key) 

          # Calculating progress percentage and displaying it
          $Index = $Entities.IndexOf($Object) + 1
          $PercentComplete = $Index / $Entities.Count * 100
          $Status = 'Entity {0}/{1} ({2:n0}%)' -F $Index, $Entities.Count, $PercentComplete
          $CurrentOperation = "GetFieldInfo('{0}')" -F $Object.Key
      
          Write-Progress -Status $Status -PercentComplete $PercentComplete -CurrentOperation $CurrentOperation @ProgressParameters
        
          # Is the Cache too old? I.E. older than 15 minutes?
          If($Object.Value.RetrievalTime -lt $CacheExpiry) {
          
            # Force a refresh by calling this function
            $null = Get-FieldInfo -Entity $Object.Key
            
          }
        }
      }
    

      # Cache has been loaded, has the right API version and everything is up to date
      # Return the correct set
      $Result = Switch ($PSCmdLet.ParameterSetName) 
      { 
        'get_All' 
        {
          $script:FieldInfoCache
        }
        'get_Static'
        {
          $script:FieldInfoCache.GetEnumerator() | Where-Object {-not $_.Value.HasPickList -and -not $_.Value.EntityInfo.HasUserDefinedFields}
        }
        'get_Dynamic'
        {
          $script:FieldInfoCache.GetEnumerator() | Where-Object {$_.Value.HasPickList -or $_.Value.EntityInfo.HasUserDefinedFields}
        }
      } 
    }
  }  
  End {
    If ($CacheDirty) { 
      Export-AtwsDiskCache
    }
    
       
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
            
    Return $Result
  }
    
    
}
