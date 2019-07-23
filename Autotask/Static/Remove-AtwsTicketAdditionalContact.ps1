#Requires -Version 4.0
#Version 1.6.2.15
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Remove-AtwsTicketAdditionalContact
{


<#
.SYNOPSIS
This function deletes a TicketAdditionalContact through the Autotask Web Services API.
.DESCRIPTION
This function deletes a TicketAdditionalContact through the Autotask Web Services API.

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
[Autotask.TicketAdditionalContact[]]. This function takes objects as input. Pipeline is supported.
.OUTPUTS
Nothing. This fuction just deletes the Autotask.TicketAdditionalContact that was passed to the function.
.EXAMPLE
Remove-AtwsTicketAdditionalContact  [-ParameterName] [Parameter value]

.LINK
New-AtwsTicketAdditionalContact
 .LINK
Get-AtwsTicketAdditionalContact

#>

  [CmdLetBinding(SupportsShouldProcess = $True, DefaultParameterSetName='Input_Object', ConfirmImpact='Low')]
  Param
  (
# Any objects that should be deleted
    [Parameter(
      ParameterSetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.TicketAdditionalContact[]]
    $InputObject,

# The unique id of an object to delete
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [long[]]
    $Id
  )
 
  Begin
  { 
    $EntityName = 'TicketAdditionalContact'
    
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

  }

  Process
  {
    If ($Id.Count -gt 0)
    {
      $Filter = 'id -eq {0}' -F ($Id -join ' -or id -eq ')
      $InputObject = Get-AtwsData -Entity $EntityName -Filter $Filter
    }

    If ($InputObject)
    { 
      
      $Caption = $MyInvocation.MyCommand.Name
      $VerboseDescrition = '{0}: About to delete {1} {2}(s). This action cannot be undone.' -F $Caption, $InputObject.Count, $EntityName
      $VerboseWarning = '{0}: About to delete {1} {2}(s). This action cannot be undone. Do you want to continue?' -F $Caption, $InputObject.Count, $EntityName

      If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
        Remove-AtwsData -Entity $InputObject
      }
    }
  }

  End
  {
    Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
  }


}
