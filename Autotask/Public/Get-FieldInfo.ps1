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
        $CacheDirty = $False
      }

      Process
      {
        $Caption = $MyInvocation.MyCommand.Name
        $VerboseDescrition = '{0}: About to get built-in fields for {1}s' -F $Caption, $Entity
        $VerboseWarning = '{0}: About to get built-in fields for {1}s. Do you want to continue?' -F $Caption, $Entity

        If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
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
        If (Compare-PSObject -ReferenceObject $script:FieldInfoCache[$Entity].FieldInfo -DifferenceObject $Result) { 
     
          # No errors
          Write-Verbose ('{0}: Save or update FieldInfo cache for entity {1}' -F $MyInvocation.MyCommand.Name, $Entity)
          $script:FieldInfoCache[$Entity].FieldInfo = $Result
          
          $CacheDirty = $True
          
          Write-Warning ('Entity {0} has been modified in Autotask! Re-import module with -Force to refresh.' -F $Entity)
 
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
          
          If (Compare-PSObject -ReferenceObject $script:FieldInfoCache[$Entity].UDFInfo -DifferenceObject $UDF) { 
     
            # No errors
            Write-Verbose ('{0}: Save or update UDF cache for entity {1}' -F $MyInvocation.MyCommand.Name, $Entity)
            $script:FieldInfoCache[$Entity].UDFInfo = $UDF
          
            $CacheDirty = $True
          
            Write-Warning ('Entity {0} has been modified in Autotask! Re-import module with -Force to refresh.' -F $Entity)
 
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
      If (($script:FieldInfoCache[$Entity].HasPicklist -or $script:FieldInfoCache[$Entity].EntityInfo.HasUserDefinedFields) -and ($script:FieldInfoCache[$Entity].RetrievalTime -lt $CacheExpiry -or $UpdateCache.IsPresent)) { 
        
        $CacheDirty = Update-AtwsEntity -Entity $Entity
        
        Write-Verbose -Message ('{0}: Loaded detailed Fieldinfo for entity {1}' -F $MyInvocation.MyCommand.Name, $Entity) 
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
    If ($CacheDirty) { 
      Export-AtwsDiskCache
    }
    
       
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
            
    Return $Result
  }
    
    
}
