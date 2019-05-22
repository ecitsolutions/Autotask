<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md  for license information.

#>

Function New-AtwsData 
{
  [cmdletbinding(
      SupportsShouldProcess = $True,
      ConfirmImpact = 'Medium'
  )]
  [OutputType([Object[]])]
  param
  (
    [Parameter(
        Mandatory = $True,
        Position = 0
    )]
    [PSObject[]]
    $Entity
  )
   
  Begin 
  { 
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
     
    If (-not($Script:Atws.Url))
    {
      Throw [ApplicationException] 'Not connected to Autotask WebAPI. Re-import module with valid credentials.'
    }

    $EndResult = @()
  }
    
  Process { 
    Write-Verbose -Message ('{0}: Creating a new object of type Autotask.{1}' -F $MyInvocation.MyCommand.Name, $Entity.Name) 

    $Caption = 'New-Atws{0}' -F $Entity.GetType().Name    
    $VerboseDescription = '{0}: About to create an Autotask.{1}. This action cannot be undone (but the object can usually be deleted).' -F $Caption, $Entity.GetType().Name
    $VerboseWarning = '{0}: About to create an Autotask.{1}. This action cannot be undone (but the object can usually be deleted). Do you want to continue?' -F $Caption, $Entity.GetType().Name
    
    Write-Debug -Message ('{0}: Running ShouldProcess with WhatifPreference {1} and ConfirmPreference {2}' -F $MyInvocation.MyCommand.Name, $WhatIfPreference, $ConfirmPreference)    
    If ($PSCmdlet.ShouldProcess($VerboseDescription, $VerboseWarning, $Caption)) 
    { 
      # create() function can take up to 200 objects at a time
      For ($i = 0; $i -lt $Entity.count; $i += 200) 
      {
        $j = $i + 199
        If ($j -gt ($Entity.count - 1)) 
        {
          $j = $Entity.count - 1
        } 
        Write-Debug -Message ('{0}: Creating chunk from index {1} to index {2}' -F $MyInvocation.MyCommand.Name, $i, $j)        
        
        # the .Create() method takes datetime in local time and correctly 
        # translates to CEST without our assistance. .Update() is not as nice...
        
        $Result = $Atws.Create($Entity[$i .. $j])
        
        
        If ($Result.Errors.Count -eq 0) 
        {
          # Check for duplicates
          $Duplicates = $Result.EntityReturnInfoResults | Where-Object {$_.DuplicateStatus.Found -and -not $_.DuplicateStauts.Ignored}
           
          Foreach ($Duplicate in $Duplicates)
          {
            Write-Warning ('{0}: Duplicate found for Object Id {1} on {2}' -F $MyInvocation.MyCommand.Name, $Duplicate.EntityId, $Duplicate.DuplicateStatus.MatchInfo)
          }
          
          # The API documentation explicitly states that you can only use the objects returned 
          # by the .create() function to get the new objects ID.
          # so to return objects with accurately represents what has been created we have to 
          # get them again by id
          # But not all objects support queries, for instance service adjustments
          
          $EntityInfo = Get-AtwsFieldInfo -Entity $Result.EntityResultType -EntityInfo
          
          If ($Result.EntityResults.Count -gt 0 -and $EntityInfo.CanQuery)
          {
            $NewObjectFilter = 'id -eq {0}' -F ($Result.EntityResults.Id -join ' -or id -eq ')
                        
            $EndResult += Get-AtwsData -Entity $Result.Entityresulttype -Filter $NewObjectFilter
          }
        }
        Else 
        {
          Foreach ($AtwsError in $Result.Errors) 
          {
            Write-Error -Message $AtwsError.Message
          }
        }
      }
    }
  }
  End {
   
    Write-Debug -Message ('{0}: End of function' -F $MyInvocation.MyCommand.Name) 
    Return $EndResult  
  }
}
