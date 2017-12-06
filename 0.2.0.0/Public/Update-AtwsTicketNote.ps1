<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Update-AtwsTicketNote
{
  <#
      .SYNOPSIS
      This function updates a TicketNote through the Autotask Web Services API.
      .DESCRIPTION
      This function updates a TicketNote through the Autotask Web Services API.
      .INPUTS
      [Autotask.TicketNote[]]. This function takes objects as input. Pipeline is supported.
      .OUTPUTS
      [Autototask.TicketNote[]]. This function returns the updated Autotask.TicketNote that was returned by the API.
      .EXAMPLE
      Update-AtwsTicketNote  [-ParameterName] [Parameter value]
      For parameters, use Get-Help Update-AtwsTicketNote
      .NOTES
      NAME: Update-AtwsTicketNote
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
        [Autotask.TicketNote]
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
