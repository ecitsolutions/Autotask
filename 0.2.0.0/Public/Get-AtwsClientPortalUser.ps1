<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Global:Get-AtwsClientPortalUser
{
  <#
      .SYNOPSIS
      This function get a ClientPortalUser through the Autotask Web Services API.
      .DESCRIPTION
      This function get a ClientPortalUser through the Autotask Web Services API.
      .EXAMPLE
      Get-AtwsClientPortalUser [-ParameterName] [Parameter value]
      Use Get-Help Get-AtwsClientPortalUser
      .NOTES
      NAME: Get-AtwsClientPortalUser
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
         [long]
         $id
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Basic','Advanced','Manager','Resource','Administrator','Kundetilgang - Kun egne tickets','Kundetilgang - Alle firmaets tickets','Kundetilgang - Alle firmaets tickets plus adm')]

        [String]
         $SecurityLevel
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
         [ValidateSet('MM/dd/yyyy','MM/dd/yy','dd/MM/yyyy','dd/MM/yy','yyyy/MM/dd','yy/MM/dd','MM-dd-yyyy','MM-dd-yy','dd-MM-yyyy','dd-MM-yy','yyyy-MM-dd','yy-MM-dd','MM.dd.yyyy','MM.dd.yy','dd.MM.yyyy','dd.MM.yy','yyyy.MM.dd','yy.MM.dd')]

        [String]
         $DateFormat
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('hh:mm tt','h:mm tt','HH:mm')]

        [String]
         $TimeFormat
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('X,XXX.XX','X.XXX,XX')]

        [String]
         $NumberFormat
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $UserName
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [boolean]
         $ClientPortalActive

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
        $Fields = $Atws.GetFieldInfo('ClientPortalUser')
        
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

    Get-AtwsData -Entity ClientPortalUser -Filter $Filter }   

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

  }


        
}
