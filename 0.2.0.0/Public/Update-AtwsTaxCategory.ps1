<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Update-AtwsTaxCategory
{
  <#
      .SYNOPSIS
      This function updates a TaxCategory through the Autotask Web Services API.
      .DESCRIPTION
      This function updates a TaxCategory through the Autotask Web Services API.
      .INPUTS
      [Autotask.TaxCategory[]]. This function takes objects as input. Pipeline is supported.
      .OUTPUTS
      [Autototask.TaxCategory[]]. This function returns the updated Autotask.TaxCategory that was returned by the API.
      .EXAMPLE
      Update-AtwsTaxCategory  [-ParameterName] [Parameter value]
      For parameters, use Get-Help Update-AtwsTaxCategory
      .NOTES
      NAME: Update-AtwsTaxCategory
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
        [Autotask.TaxCategory]
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
