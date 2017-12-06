<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Update-AtwsActionType
{
  <#
      .SYNOPSIS
      This function updates a ActionType through the Autotask Web Services API.
      .DESCRIPTION
      This function updates a ActionType through the Autotask Web Services API.
      .INPUTS
      [Autotask.ActionType[]]. This function takes objects as input. Pipeline is supported.
      .OUTPUTS
      [Autototask.ActionType[]]. This function returns the updated Autotask.ActionType that was returned by the API.
      .EXAMPLE
      Update-AtwsActionType  [-ParameterName] [Parameter value]
      For parameters, use Get-Help Update-AtwsActionType
      .NOTES
      NAME: Update-AtwsActionType
  #>
	  [CmdLetBinding(DefaultParameterSetName='Input_Object')]
    Param
    (
                [Parameter(
          Mandatory = $True,
          ParameterSetName = 'Input_Object',
          ValueFromPipeline = $True
        )]
        [ValidateNotNullOrEmpty()]
        [Autotask.ActionType]
        $InputObject
    )



          

  Begin
  { 
    If (-not($global:atws.Url))
    {
      Throw [ApplicationException] 'Not connected to Autotask WebAPI. Run Connect-AutotaskWebAPI first.'
    }
    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

  }   

  Process
  {   

    
    Set-AtwsData -Entity $InputObject }   

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

  }


        
}
