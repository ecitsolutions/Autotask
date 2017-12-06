<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Update-AtwsBillingItem
{
  <#
      .SYNOPSIS
      This function updates a BillingItem through the Autotask Web Services API.
      .DESCRIPTION
      This function updates a BillingItem through the Autotask Web Services API.
      .INPUTS
      [Autotask.BillingItem[]]. This function takes objects as input. Pipeline is supported.
      .OUTPUTS
      [Autototask.BillingItem[]]. This function returns the updated Autotask.BillingItem that was returned by the API.
      .EXAMPLE
      Update-AtwsBillingItem  [-ParameterName] [Parameter value]
      For parameters, use Get-Help Update-AtwsBillingItem
      .NOTES
      NAME: Update-AtwsBillingItem
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
        [Autotask.BillingItem]
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
