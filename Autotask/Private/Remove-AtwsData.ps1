﻿<#

    .COPYRIGHT
    Copyright (c) Hugo Klemmestad. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

#>

Function Remove-AtwsData {
    <#
      .SYNOPSIS
      This function updates one or more Autotask entities with new or modified properties.
      .DESCRIPTION
      This function updates one or more Autotask entities with new or modified properties
      .INPUTS
      Autotask.Entity[]. One or more Autotask entities to delete.
      .OUTPUTS
      Nothing.
      .EXAMPLE
      Remove-AtwsData -Entity $Entity
      Passes all Autotask entities in $Entity to the Autotask webservices API and deletes them.
      .NOTES
      NAME: Remove-AtwsData
      .LINK
      Get-AtwsData
      Set-AtwsData
  #>
 
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [PSObject[]]
        $Entity
    )
    
    begin { 
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
        Write-Verbose ('{0}: Start of Function' -F $MyInvocation.MyCommand.Name)

        # Check if we are connected before trying anything
        if (-not($Script:Atws.integrationsValue)) {
            # Not connected. Try to connect, prompt for credentials if necessary
            Write-Verbose ('{0}: Not connected. Calling Connect-AtwsWebApi without parameters for possible autoload of default connection profile.' -F $MyInvocation.MyCommand.Name)
            Connect-AtwsWebAPI
        }

    }
  
    process {   
    
        Write-Verbose ('{0}: Deleting {1} [Autotask.{2}] object(s) with Id {3}' -F $MyInvocation.MyCommand.Name, $Entity.Count, $Entity[0].GetType().Name, ($Entity.Id -join ','))        
          

        # delete() function can take up to 200 objects at a time
        for ($i = 0; $i -lt $Entity.count; $i += 200) {
            $j = $i + 199
            if ($j -ge $Entity.count) {
                $j = $Entity.count - 1
            } 
            Write-Debug -Message ('{0}: Creating chunk from index {1} to index {2}' -F $MyInvocation.MyCommand.Name, $i, $j)        
            
            # Explicit selection of list type. ArrayList supports .remove()
            [Collections.ArrayList]$workingSet = $Entity[$i .. $j]

            # We are going to try multiple times if the first attempt fails
            Do { 
                # Reset error list
                $errors = @()
        
                # We are deleting...
                $result = $atws.delete($Script:Atws.integrationsValue, $workingSet)
                
                # Do we have any errors? We get two lines pr error. Or so I did during testing.
                for ($t = 0; $t -lt $result.errors.Count; $t += 2) {
                    # Count the errors, we have a limit
                    $errorCount++
              
                    # First line is the error message
                    $message = $result.errors[$t].Message
              
                    if ($result.errors.Count -gt $t) { 
                        # Next line may include the element index, first element = 1
                        if ($result.errors[$t + 1].Message -match '\[(\d+)\]') { 
                
                            [int]$index = $Matches[1]
                        }
                        else {
                            $index = 1
                        }
                    }
              
                    # Powershell arrays has first element = 0
                    $index--
            
                    # Get the element
                    $element = $workingSet[$index]
            
                    # Remove element from Workingset
                    $errors += $element
            
                    # Notify caller of skipped element
                    Write-Warning ('Element with index {0} of type {1} with Id {2} was skipped because {3}' -F $Entity.IndexOf($element), $element.GetType().Name, $element.id, $message)
                }

                # .remove() any errors from the workingSet 
                foreach ($element in $errors) {
                    $workingSet.Remove($element)
                }
            
                # Keep on trying until there are no errors, the workingSet is empty (every element failed)
                # or the error limit has been reached
            } Until ($result.errors.Count -eq 0 -or $workingSet.Count -eq 0 -or $errorCount -ge $Script:Atws.Configuration.ErrorLimit)

            # We have tried multiple times! Still errors?
            if ($result.errors.Count -gt 0) {
                # Still errors. Throw an exception.
                foreach ($atwsError in $result.Errors) {
                    $message = 'Number of errors exceeds configured errorlimit ({0}). Last errormessage: {1}' -f $Script:Atws.Configuration.ErrorLimit, $atwsError.Message
                    $exception = New-Object System.Configuration.Provider.ProviderException $message
                    $errorCategory = [System.Management.Automation.ErrorCategory]::NotSpecified
                    $errorRecord = [System.Management.Automation.ErrorRecord]::new($exception, 'TooManyErrors', $errorCategory, $atwsError)
                    $PSCmdlet.ThrowTerminatingError($errorRecord)
                }
                return
            }
        }
    }
  
    end {
        Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)    
    }
}

