<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Update-AtwsContractBlock
{
  <#
      .SYNOPSIS
      This function updates a ContractBlock through the Autotask Web Services API.
      .DESCRIPTION
      This function updates a ContractBlock through the Autotask Web Services API.
      .INPUTS
      [Autotask.ContractBlock[]]. This function takes objects as input. Pipeline is supported.
      .OUTPUTS
      [Autototask.ContractBlock[]]. This function returns the updated Autotask.ContractBlock that was returned by the API.
      .EXAMPLE
      Update-AtwsContractBlock  [-ParameterName] [Parameter value]
      For parameters, use Get-Help Update-AtwsContractBlock
      .NOTES
      NAME: Update-AtwsContractBlock
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
        [Autotask.ContractBlock]
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
