<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Update-AtwsServiceBundle
{
  <#
      .SYNOPSIS
      This function updates a ServiceBundle through the Autotask Web Services API.
      .DESCRIPTION
      This function updates a ServiceBundle through the Autotask Web Services API.
      .INPUTS
      [Autotask.ServiceBundle[]]. This function takes objects as input. Pipeline is supported.
      .OUTPUTS
      [Autototask.ServiceBundle[]]. This function returns the updated Autotask.ServiceBundle that was returned by the API.
      .EXAMPLE
      Update-AtwsServiceBundle  [-ParameterName] [Parameter value]
      For parameters, use Get-Help Update-AtwsServiceBundle
      .NOTES
      NAME: Update-AtwsServiceBundle
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
        [Autotask.ServiceBundle]
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
