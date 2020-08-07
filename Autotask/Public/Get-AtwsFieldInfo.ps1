<#

    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.

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
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Low',
        DefaultParameterSetName = 'by_Entity'
    )]
    Param
    (
        [Parameter(
            ParameterSetName = 'get_All'
        )]
        [switch]
        $All,
    
        [Parameter(
            ParameterSetName = 'get_Static'
        )]
        [switch]
        $Static, 
 
        [Parameter(
            ParameterSetName = 'get_Dynamic'
        )]
        [switch]
        $Dynamic, 
     
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'by_Reference'
        )]
        [switch]
        $ReferencingEntity,  
     
        [Parameter(
            ParameterSetName = 'by_Entity'
        )]
        [Alias('UDF')]
        [switch]
        $UserDefinedFields, 
    
        [Parameter(
            ParameterSetName = 'by_Entity'
        )]
        [switch]
        $EntityInfo, 
       
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ParameterSetName = 'by_Entity'
        )]
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ParameterSetName = 'by_Reference'
        )]
        [string]
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
        [switch]
        $UpdateCache
    )
    
    begin { 
    
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
        
        $cacheExpiry = (Get-Date).AddMinutes(-15)
    }
  
    process { 

        # By ENTITY
        if ($PSCmdlet.ParameterSetName -eq 'by_Entity') {
            Write-Verbose -Message ('{0}: Looking up detailed Fieldinfo for entity {1}' -F $MyInvocation.MyCommand.Name, $Entity) 
            
            if (($script:FieldInfoCache[$Entity].HasPicklist -or $script:FieldInfoCache[$Entity].EntityInfo.HasUserDefinedFields) -and ($script:FieldInfoCache[$Entity].RetrievalTime -lt $cacheExpiry -or $UpdateCache.IsPresent) -and ($Script:Atws)) { 
        
                Update-AtwsEntity -Entity $Entity
        
                Write-Debug -Message ('{0}: Entity {1} has picklists and/or userdefined fields; cache was outdated or -UpdateCache was present.' -F $MyInvocation.MyCommand.Name, $Entity) 
            }
      
            # Prepare an empty result set. If none of the conditions below are true, then the user tried to get
            # UDFs from an entity that does not support them. The result will be empty.
            $result = @()  
        
            # If the user asked for UDFs and the entity supports UDFs, return the info. 
            if ($UserDefinedFields.IsPresent -and $script:FieldInfoCache[$Entity].EntityInfo.HasUserDefinedFields) {
                Write-Debug ('{0}: Returning UDF info for entity {1} from cache' -F $MyInvocation.MyCommand.Name, $Entity)   
                $result = $script:FieldInfoCache[$Entity].UDFInfo
            }
            elseif ($EntityInfo.IsPresent) {
                Write-Debug ('{0}: Returning EntityInfo info for entity {1} from cache' -F $MyInvocation.MyCommand.Name, $Entity)   
                $result = $script:FieldInfoCache[$Entity]
            }
            elseif (-not ($UserDefinedFields.IsPresent)) { 
                Write-Debug ('{0}: Returning fieldinfo for entity {1} from cache' -F $MyInvocation.MyCommand.Name, $Entity)   
                $result = $script:FieldInfoCache[$Entity].FieldInfo
            }
        }
        # ReferencingEntity
        elseIf ($PSCmdlet.ParameterSetName -eq 'by_Reference') {
            $result = @()
            foreach ($object in $Script:FieldInfoCache.GetEnumerator()) {
                $isReferencing = $object.Value.FieldInfo.Where( { $_.ReferenceEntityType -eq $Entity })
                # Include the fieldname. Or we will never be able to make this work
                foreach ($ref in $isReferencing) {
                    $result += '{0}:{1}' -F $object.Name, $ref.Name
                }
            }
        }
        # For all other options
        else { 
  
            if ($UpdateCache.IsPresent) { 
                # Prepare parameters for @splatting
                $progressParameters = @{
                    Activity = 'All entities has been requested. Updating picklists.'
                    Id       = 9
                }
      
                $entities = $script:FieldInfoCache.GetEnumerator().Where{ $_.Value.HasPicklist -or $_.Value.EntityInfo.HasUserDefinedfields }
      
                foreach ($object in $entities) {
      
                    Write-Debug -Message ('{0}: Importing detailed information about Entity {1}' -F $MyInvocation.MyCommand.Name, $object.Key) 

                    # Calculating progress percentage and displaying it
                    $index = $entities.IndexOf($object) + 1
                    $percentComplete = $index / $entities.Count * 100
                    $status = 'Entity {0}/{1} ({2:n0}%)' -F $index, $entities.Count, $percentComplete
                    $currentOperation = "GetFieldInfo('{0}')" -F $object.Key
      
                    Write-AtwsProgress -Status $status -PercentComplete $percentComplete -CurrentOperation $currentOperation @ProgressParameters
        
                    # Is the Cache too old? I.E. older than 15 minutes?
                    If ($object.Value.RetrievalTime -lt $cacheExpiry) {
          
                        # Force a refresh by calling this function
                        Update-AtwsEntity -Entity $Entity
                    }
                }
                if ($currentOperation) { 
                    Write-AtwsProgress -Status $status -PercentComplete $percentComplete -CurrentOperation $currentOperation @ProgressParameters -Completed
                }
            }
    

            # Cache has been loaded, has the right API version and everything is up to date
            # Return the correct set
            $result = switch ($PSCmdLet.ParameterSetName) { 
                'get_All' {
                    $script:FieldInfoCache
                }
                'get_Static' {
                    $script:FieldInfoCache.GetEnumerator() | Where-Object { -not $_.Value.HasPickList }
                }
                'get_Dynamic' {
                    $script:FieldInfoCache.GetEnumerator() | Where-Object { $_.Value.HasPickList }
                }
            } 
        }
    }  
    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
               
        return $result
    }
       
}
