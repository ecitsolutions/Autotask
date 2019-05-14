<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>

Function Get-AtwsFieldInfo {
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
      Get-AtwsFieldInfo -Entity Account
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
        ParameterSetName = 'by_Entity'
    )]
    [Switch]
    $EntityInfo, 
       
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
    $Entity,

    [Parameter(
        ParameterSetName = 'by_Entity'
    )]
    [Parameter(
        ParameterSetName = 'get_Dynamic'
    )]
    [Parameter(
        ParameterSetName = 'get_All'
    )]
    [Switch]
    $UpdateCache
  )
    
  Begin { 
    
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
    # Check if we are connected before trying anything
    If (-not($Script:Atws)) {
      Throw [ApplicationException] 'Not connected to Autotask WebAPI. Re-import module with valid credentials.'
    }
    
    # Has cache been loaded?
    If (-not($script:Cache)) {
      # Load it.
      Import-AtwsDiskCache
    }
         
   

    $CacheExpiry = (Get-Date).AddMinutes(-15)
  }
  
  Process { 
        
    Function Update-AtwsEntity
    {
      [CmdLetBinding()]
      Param
      (
        [Parameter(
            Mandatory = $True
        )]
        [String]
        $Entity
      )
      Begin 
      {
        Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
            
        $CacheDirty = $False
      }

      Process
      {
        $Caption = $MyInvocation.MyCommand.Name
        $VerboseDescrition = '{0}: About to get built-in fields for {1}s' -F $Caption, $Entity
        $VerboseWarning = '{0}: About to get built-in fields for {1}s. Do you want to continue?' -F $Caption, $Entity

        If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
        
          Write-Verbose -Message ("{0}: Calling .GetFieldInfo('{1}')" -F $MyInvocation.MyCommand.Name, $Entity) 
          
          $Result = $Script:atws.GetFieldInfo($Entity)
                 
          If ($Result.Errors.Count -gt 0) {
            Foreach ($AtwsError in $Result.Errors) {
              Write-Error $AtwsError.Message
            }
            Return
          }
        }
      
        # No errors
        # Test if value has changed
        If (-not (Compare-PSObject -ReferenceObject $script:FieldInfoCache[$Entity].FieldInfo -DifferenceObject $Result)) { 
     
          # No errors
          Write-Verbose ('{0}: Save or update FieldInfo cache for entity {1}' -F $MyInvocation.MyCommand.Name, $Entity)
          $script:FieldInfoCache[$Entity].FieldInfo = $Result
          
          $CacheDirty = $True
          
        }
        
        If ($script:FieldInfoCache[$Entity].EntityInfo.HasUserDefinedFields)
        { 
          $Caption = $MyInvocation.MyCommand.Name
          $VerboseDescrition = '{0}: About to get userdefined fields for {1}s' -F $Caption, $Entity
          $VerboseWarning = '{0}: About to get userdefined fields for {1}s. Do you want to continue?' -F $Caption, $Entity

          If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
            $UDF = $Script:atws.GetUDFInfo($Entity)
                 
            If ($Result.Errors.Count -gt 0) {
              Foreach ($AtwsError in $Result.Errors) {
                Write-Error $AtwsError.Message
              }
              Return
            }
          
          }
          
          # UDF info will be empty the first time around
          If (-not ($script:FieldInfoCache[$Entity].UDFInfo)) {
            $script:FieldInfoCache[$Entity].UDFInfo = $UDF
            $CacheDirty = $True
          }
          ElseIf (-not(Compare-PSObject -ReferenceObject $script:FieldInfoCache[$Entity].UDFInfo -DifferenceObject $UDF)) { 
     
            # No errors
            Write-Verbose ('{0}: Save or update UDF cache for entity {1}' -F $MyInvocation.MyCommand.Name, $Entity)
            $script:FieldInfoCache[$Entity].UDFInfo = $UDF
          
            $CacheDirty = $True
      
          }
        }
        $script:FieldInfoCache[$Entity].RetrievalTime = Get-Date
      }

      End
      {
        Return $CacheDirty
      }
    }


    # By ENTITY
    If ($PSCmdlet.ParameterSetName -eq 'by_Entity')
    {
      Write-Verbose -Message ('{0}: Looking up detailed Fieldinfo for entity {1}' -F $MyInvocation.MyCommand.Name, $Entity) 
            
      If (($script:FieldInfoCache[$Entity].HasPicklist -or $script:FieldInfoCache[$Entity].EntityInfo.HasUserDefinedFields) -and ($script:FieldInfoCache[$Entity].RetrievalTime -lt $CacheExpiry -or $UpdateCache.IsPresent)) { 
        
        $CacheDirty = Update-AtwsEntity -Entity $Entity
        
        Write-Debug -Message ('{0}: Entity {1} has picklists and/or userdefined fields; cache was outdated or -UpdateCache was present.' -F $MyInvocation.MyCommand.Name, $Entity) 
      }
      
      # Prepare an empty result set. If none of the conditions below are true, then the user tried to get
      # UDFs from an entity that does not support them. The result will be empty.
      $Result = @()  
        
      # If the user asked for UDFs and the entity supports UDFs, return the info. 
      If ($UserDefinedFields.IsPresent -and $script:FieldInfoCache[$Entity].EntityInfo.HasUserDefinedFields)
      {
        Write-Debug ('{0}: Returning UDF info for entity {1} from cache' -F $MyInvocation.MyCommand.Name, $Entity)   
        $Result = $script:FieldInfoCache[$Entity].UDFInfo
      }
      ElseIf ($EntityInfo.IsPresent)
      {
        Write-Debug ('{0}: Returning EntityInfo info for entity {1} from cache' -F $MyInvocation.MyCommand.Name, $Entity)   
        $Result = $script:FieldInfoCache[$Entity].EntityInfo
      }
      ElseIf (-not ($UserDefinedFields.IsPresent))
      { 
        Write-Debug ('{0}: Returning fieldinfo for entity {1} from cache' -F $MyInvocation.MyCommand.Name, $Entity)   
        $Result = $script:FieldInfoCache[$Entity].FieldInfo
      }
    }
    # ReferencingEntity
    ElseIf($PSCmdlet.ParameterSetName -eq 'by_Reference')
    {
      $Result = @()
      Foreach ($Object in $Script:FieldInfoCache.GetEnumerator())
      {
        $IsReferencing = $Object.Value.FieldInfo.Where({$_.ReferenceEntityType -eq $Entity})
        # Include the fieldname. Or we will never be able to make this work
        Foreach($Ref in $IsReferencing)
        {
          $Result += '{0}:{1}' -F $Object.Name, $Ref.Name
        }
      }
    }
    # For all other options
    Else 
    { 
  
      If ($UpdateCache.IsPresent)
      { 
        # Prepare parameters for @splatting
        $ProgressParameters = @{
          Activity = 'All entities has been requested. Updating picklists.'
          Id = 9
        }
      
        $Entities = $script:FieldInfoCache.GetEnumerator().Where{$_.Value.HasPicklist -or $_.Value.EntityInfo.HasUserDefinedfields}
      
        Foreach ($Object in $Entities) {
      
          Write-Debug -Message ('{0}: Importing detailed information about Entity {1}' -F $MyInvocation.MyCommand.Name, $Object.Key) 

          # Calculating progress percentage and displaying it
          $Index = $Entities.IndexOf($Object) + 1
          $PercentComplete = $Index / $Entities.Count * 100
          $Status = 'Entity {0}/{1} ({2:n0}%)' -F $Index, $Entities.Count, $PercentComplete
          $CurrentOperation = "GetFieldInfo('{0}')" -F $Object.Key
      
          Write-Progress -Status $Status -PercentComplete $PercentComplete -CurrentOperation $CurrentOperation @ProgressParameters
        
          # Is the Cache too old? I.E. older than 15 minutes?
          If($Object.Value.RetrievalTime -lt $CacheExpiry) {
          
            # Force a refresh by calling this function
            $CacheDirty = Update-AtwsEntity -Entity $Entity
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
          $script:FieldInfoCache.GetEnumerator() | Where-Object {-not $_.Value.HasPickList}
        }
        'get_Dynamic'
        {
          $script:FieldInfoCache.GetEnumerator() | Where-Object {$_.Value.HasPickList}
        }
      } 
    }
  }  
  End {
    If ($CacheDirty -and $Script:UseDiskCache) { 
      # If not called during module load, give this warning
      If ($PSCmdLet.MyInvocation.ScriptName -notlike '*.psm1') { 
        Write-Warning ('One or more entities has been modified in Autotask! Re-import module with -Force to refresh.')
      }
      Export-AtwsDiskCache
    }
    
       
    Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
            
    Return $Result
  }
    
    
}
