<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Get-AtwsChangeRequestLink
{
  <#
      .SYNOPSIS
      This function get a ChangeRequestLink through the Autotask Web Services API.
      .DESCRIPTION
      This function get a ChangeRequestLink through the Autotask Web Services API.
      .EXAMPLE
      Get-AtwsChangeRequestLink [-ParameterName] [Parameter value]
      Use Get-Help Get-AtwsChangeRequestLink
      .NOTES
      NAME: Get-AtwsChangeRequestLink
  #>
	  [CmdLetBinding(DefaultParameterSetName='Filter')]
    Param
    (
                [Parameter(
          Mandatory = $true,
          ValueFromRemainingArguments = $true,
          ParameterSetName = 'Filter')]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Filter ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $id
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $ChangeRequestTicketID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $ProblemOrIncidentTicketID
 ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','ChangeRequestTicketID','ProblemOrIncidentTicketID')]
        [String[]]
        $NotEquals ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','ChangeRequestTicketID','ProblemOrIncidentTicketID')]
        [String[]]
        $GreaterThan ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','ChangeRequestTicketID','ProblemOrIncidentTicketID')]
        [String[]]
        $GreaterThanOrEqual ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','ChangeRequestTicketID','ProblemOrIncidentTicketID')]
        [String[]]
        $LessThan ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','ChangeRequestTicketID','ProblemOrIncidentTicketID')]
        [String[]]
        $LessThanOrEquals ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('')]
        [String[]]
        $Like ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('')]
        [String[]]
        $NotLike ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('')]
        [String[]]
        $BeginsWith ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('')]
        [String[]]
        $EndsWith
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

    If (-not($Filter))
    {
        $Fields = $Atws.GetFieldInfo('ChangeRequestLink')
        
        Foreach ($Parameter in $PSBoundParameters.GetEnumerator())
        {
            $Field = $Fields | Where-Object {$_.Name -eq $Parameter.Key}
            If ($Field.IsPickList)
            {
              $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $Parameter.Value}
              $Value = $PickListValue.Value
            }
            Else
            {
              $Value = $Parameter.Value
            }
            $Filter += $Parameter.Key
            $Filter += '-eq'
            $Filter += $Value
        }
        
    }

    Get-AtwsData -Entity ChangeRequestLink -Filter $Filter }   

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

  }


        
}
