<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Set-AtwsResourceSkill
{
  <#
      .SYNOPSIS
      This function sets parameters on a specific ResourceSkill through the Autotask Web Services API.
      .DESCRIPTION
      This function sets parameters on a specific ResourceSkill through the Autotask Web Services API.
      .EXAMPLE
      Set-AtwsResourceSkill [-ParameterName] [Parameter value]
      Use Get-Help Set-AtwsResourceSkill
      .NOTES
      NAME: Set-AtwsResourceSkill
  #>
	  [CmdLetBinding(DefaultParameterSetName='By_parameters')]
    Param
    (
                [Parameter(
          Mandatory = $true,
          ValueFromRemainingArguments = $true,
          ParameterSetName = 'By_parameters')]
        [ValidateNotNullOrEmpty()]
        [Int]
        $Id ,

        [Parameter(
          Mandatory = $True,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateNotNullOrEmpty()]
         [ValidateSet('0 - none','1 - novice','2 - junior','3 - intermediate','4 - senior','5 - expert')]

        [String]
         $SkillLevel
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $SkillDescription

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

    $InputObject =  Get-AtwsData -Entity ResourceSkill -Filter {id -eq $Id}

    Foreach ($Parameter in $PSBoundParameters.GetEnumerator())
    {
        $InputObject.$($Parameter.Key) = $Parameter.Value
    }
        
    
    Set-AtwsData -Entity $InputObject }   

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

  }


        
}
