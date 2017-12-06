<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Get-AtwsTicketChangeRequestApproval
{
  <#
      .SYNOPSIS
      This function get a TicketChangeRequestApproval through the Autotask Web Services API.
      .DESCRIPTION
      This function get a TicketChangeRequestApproval through the Autotask Web Services API.
      .EXAMPLE
      Get-AtwsTicketChangeRequestApproval [-ParameterName] [Parameter value]
      Use Get-Help Get-AtwsTicketChangeRequestApproval
      .NOTES
      NAME: Get-AtwsTicketChangeRequestApproval
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
         $TicketID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $ResourceID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $ContactID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $ApproveRejectDateTime
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $ApproveRejectNote
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [boolean]
         $IsApproved
 ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','TicketID','ResourceID','ContactID','ApproveRejectDateTime','ApproveRejectNote','IsApproved')]
        [String[]]
        $NotEquals ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','TicketID','ResourceID','ContactID','ApproveRejectDateTime','ApproveRejectNote','IsApproved')]
        [String[]]
        $GreaterThan ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','TicketID','ResourceID','ContactID','ApproveRejectDateTime','ApproveRejectNote','IsApproved')]
        [String[]]
        $GreaterThanOrEqual ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','TicketID','ResourceID','ContactID','ApproveRejectDateTime','ApproveRejectNote','IsApproved')]
        [String[]]
        $LessThan ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','TicketID','ResourceID','ContactID','ApproveRejectDateTime','ApproveRejectNote','IsApproved')]
        [String[]]
        $LessThanOrEquals ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('ApproveRejectNote')]
        [String[]]
        $Like ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('ApproveRejectNote')]
        [String[]]
        $NotLike ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('ApproveRejectNote')]
        [String[]]
        $BeginsWith ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('ApproveRejectNote')]
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
        $Fields = $Atws.GetFieldInfo('TicketChangeRequestApproval')
        
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

    Get-AtwsData -Entity TicketChangeRequestApproval -Filter $Filter }   

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

  }


        
}
