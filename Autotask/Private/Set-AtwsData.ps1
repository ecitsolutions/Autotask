<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>

Function Set-AtwsData {
  <#
      .SYNOPSIS
      This function updates one or more Autotask entities with new or modified properties.
      .DESCRIPTION
      This function updates one or more Autotask entities with new or modified properties
      .INPUTS
      Autotask.Entity[]. One or more Autotask entities to update
      .OUTPUTS
      Autotask.Entity[]. The updated entities are re-downloaded from the API.
      .EXAMPLE
      Set-AtwsData -Entity $Entity
      Passes all Autotask entities in $Entity to the Autotask webservices API
      .NOTES
      NAME: Set-AtwsData
      .LINK
      Get-AtwsData
      New-AtwsData
      Remove-AtwsData
  #>
 
  [cmdletbinding(
      SupportsShouldProcess = $True,
      ConfirmImpact = 'Medium'
  )]
  [OutputType([PSObject[]])]
  param
  (
    [Parameter(
        Mandatory = $True,
        ValueFromPipeline = $True
    )]
    [ValidateNotNullOrEmpty()]
    [PSObject[]]
    $Entity,
    
    [ValidateRange(0,100)]
    [Int]
    $ErrorLimit = 10
  )
    
    
  Begin { 
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
    If (-not($Script:Atws.Url)) {
      Throw [ApplicationException] 'Not connected to Autotask WebAPI. Re-import module with valid credentials.'
    }
    
    $EndResult = @()
    $ErrorCount = 0
  }
  
  Process { 
    Write-Verbose ('{0}: Updating Autotask {1} with id {2}' -F $MyInvocation.MyCommand.Name, $Entity[0].GetType().Name, $($Entity.id -join ', '))


    $Caption = 'Set-Atws{0}' -F $Entity[0].GetType().Name
    $VerboseDescrition = '{0}: About to modify {1} {2}(s). This action cannot be undone.' -F $Caption, $Entity.Count, $Entity[0].GetType().name
    $VerboseWarning = '{0}: About to modify {1} {2}(s). This action cannot be undone. Do you want to continue?' -F $Caption, $Entity.Count, $Entity[0].GetType().Name

    If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
      # update() function can take up to 200 objects at a time
      For ($i = 0; $i -lt $Entity.count; $i += 200) {
        $j = $i + 199
        If ($j -ge $Entity.count) {
          $j = $Entity.count - 1
        } 
        Write-Debug -Message ('{0}: Creating chunk from index {1} to index {2}' -F $MyInvocation.MyCommand.Name, $i, $j)        
        
        [Collections.ArrayList]$WorkingSet = $Entity[$i .. $j]
        
        # First try
        $Result = $atws.update($WorkingSet)
        
        # If we have errors, try to exclude objects errors
        If ($Result.Errors.Count -gt 0) {
          Do { 
            $Errors = @()
            For ($t = 0; $t -lt $Result.Errors.Count; $t += 2) {
              # Count the errors, we have a limit
              $ErrorCount++
              
              # First line is the error message
              $Message = $Result.Errors[$t].Message
              
              If ($Result.Errors.Count -gt $t) { 
                # Next line may include the element index, first element = 1
                If ($Result.Errors[$t + 1].Message -match '\[(\d+)\]') { 
                
                  [int]$Index = $Matches[1]
                }
                Else {
                  $Index = 1
                }
              }
              
              # Powershell arrays has first element = 0
              $Index--
            
              # Get the element
              $Element = $WorkingSet[$Index]
            
              # Remove Element from Workingset
              $Errors += $Element
              
            
              # Notify caller of skipped element
              Write-Warning ('Element with index {0} of type {1} with Id {2} was skipped because {3}' -F $Entity.IndexOf($Element), $Element.GetType().Name, $Element.id, $Message)
            
            }

            Foreach ($Element in $Errors) {
              $WorkingSet.Remove($Element)
            }
          
            # Try updating a second time
            $Result = $atws.update($WorkingSet)
          } Until ($Result.Errors.Count -eq 0 -or $WorkingSet.Count -eq 0 -or $ErrorCount -ge $ErrorLimit)
        }
    
        # We have tried multiple times! Still errors?
        If ($Result.Errors.Count -eq 0) {
          $EndResult += $Result.EntityResults
        }
        Else {
          
          Write-Error ($Result.Errors.Message -join "`n")
          Break
        }
      }
    }
  }
  End {
    Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name) 
    
    Return $EndResult  
        
  }
}

