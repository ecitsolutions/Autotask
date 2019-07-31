#Requires -Version 4.0
#Version 1.6.2.17
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Remove-AtwsChecklistLibrary
{


<#
.SYNOPSIS
This function deletes a ChecklistLibrary through the Autotask Web Services API.
.DESCRIPTION
This function deletes a ChecklistLibrary through the Autotask Web Services API.

Entities that have fields that refer to the base entity of this CmdLet:

ChecklistLibraryChecklistItem
 TicketChecklistLibrary

.INPUTS
[Autotask.ChecklistLibrary[]]. This function takes objects as input. Pipeline is supported.
.OUTPUTS
Nothing. This fuction just deletes the Autotask.ChecklistLibrary that was passed to the function.
.EXAMPLE
Remove-AtwsChecklistLibrary  [-ParameterName] [Parameter value]

.LINK
New-AtwsChecklistLibrary
 .LINK
Get-AtwsChecklistLibrary
 .LINK
Set-AtwsChecklistLibrary

#>

  [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName='Input_Object', ConfirmImpact='Low')]
  Param
  (
# Any objects that should be deleted
    [Parameter(
      ParametersetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.ChecklistLibrary[]]
    $InputObject,

# The unique id of an object to delete
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [long[]]
    $Id
  )
 
    begin { 
        $entityName = 'ChecklistLibrary'
    
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

    }

    process {

        # Collect copies of InputObject if passed any IDs
        # Has to collect in batches, or we are going to get the 
        # dreaded 'too nested SQL' error
        If ($Id.count -gt 0) { 
            $InputObject = @()
            for ($i = 0; $i -lt $Id.count; $i += 200) {
                $j = $i + 199
                if ($j -ge $Id.count) {
                    $j = $Id.count - 1
                } 
            
                # Create a filter with the current batch
                $Filter = 'Id -eq {0}' -F ($Id[$i .. $j] -join ' -or Id -eq ')
            
                $InputObject += Get-AtwsData -Entity $entityName -Filter $Filter
            }

        }

        Write-Verbose ('{0}: Deleting {1} object(s) from Autotask' -F $MyInvocation.MyCommand.Name, $InputObject.Count)

        if ($InputObject) { 
      
            $caption = $MyInvocation.MyCommand.Name
            $verboseDescription = '{0}: About to delete {1} {2}(s). This action cannot be undone.' -F $caption, $InputObject.Count, $entityName
            $verboseWarning = '{0}: About to delete {1} {2}(s). This action cannot be undone. Do you want to continue?' -F $caption, $InputObject.Count, $entityName

            if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
                Remove-AtwsData -Entity $InputObject
            }
        }
    }

    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    }


}
