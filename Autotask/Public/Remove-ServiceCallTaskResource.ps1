<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Remove-ServiceCallTaskResource
{


<#
.SYNOPSIS
This function deletes a ServiceCallTaskResource through the Autotask Web Services API.
.DESCRIPTION
This function deletes a ServiceCallTaskResource through the Autotask Web Services API.

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
[Autotask.ServiceCallTaskResource[]]. This function takes objects as input. Pipeline is supported.
.OUTPUTS
Nothing. This fuction just deletes the Autotask.ServiceCallTaskResource that was passed to the function.
.EXAMPLE
Remove-ServiceCallTaskResource  [-ParameterName] [Parameter value]

.LINK
New-ServiceCallTaskResource
 .LINK
Get-ServiceCallTaskResource

#>

  [CmdLetBinding(DefaultParameterSetName='Input_Object', ConfirmImpact='Low')]
  Param
  (
# Any objects that should be deleted
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.ServiceCallTaskResource[]]
    $InputObject,

# The unique id of an object to delete
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.ServiceCallTaskResource[]]
    $Id
  )
 
  Begin
  { 
    $EntityName = 'ServiceCallTaskResource'
    
    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

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
      Remove-AtwsData -Entity $InputObject
    }
  }

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
  }


}
