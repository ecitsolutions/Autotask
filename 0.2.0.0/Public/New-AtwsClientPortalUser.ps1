<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Global:New-AtwsClientPortalUser
{
  <#
      .SYNOPSIS
      This function creates a new ClientPortalUser through the Autotask Web Services API.
      .DESCRIPTION
      This function creates a new ClientPortalUser through the Autotask Web Services API.
      .EXAMPLE
      New-AtwsClientPortalUser [-ParameterName] [Parameter value]
      Use Get-Help New-AtwsClientPortalUser
      .NOTES
      NAME: New-AtwsClientPortalUser
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
         [ValidateSet('Basic','Advanced','Manager','Resource','Administrator','Kundetilgang - Kun egne tickets','Kundetilgang - Alle firmaets tickets','Kundetilgang - Alle firmaets tickets plus adm')]

        [String]
         $SecurityLevel
 ,

        [Parameter(
          Mandatory = $True,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateNotNullOrEmpty()]
         [ValidateSet('MM/dd/yyyy','MM/dd/yy','dd/MM/yyyy','dd/MM/yy','yyyy/MM/dd','yy/MM/dd','MM-dd-yyyy','MM-dd-yy','dd-MM-yyyy','dd-MM-yy','yyyy-MM-dd','yy-MM-dd','MM.dd.yyyy','MM.dd.yy','dd.MM.yyyy','dd.MM.yy','yyyy.MM.dd','yy.MM.dd')]

        [String]
         $DateFormat
 ,

        [Parameter(
          Mandatory = $True,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateNotNullOrEmpty()]
         [ValidateSet('hh:mm tt','h:mm tt','HH:mm')]

        [String]
         $TimeFormat
 ,

        [Parameter(
          Mandatory = $True,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateNotNullOrEmpty()]
         [ValidateSet('X,XXX.XX','X.XXX,XX')]

        [String]
         $NumberFormat
 ,

        [Parameter(
          Mandatory = $True,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateNotNullOrEmpty()]
         [string]
         $UserName
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $Password
 ,

        [Parameter(
          Mandatory = $True,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateNotNullOrEmpty()]
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

    $InputObject = New-Object Autotask.ClientPortalUser

    Foreach ($Parameter in $PSBoundParameters.GetEnumerator())
    {
        $InputObject.$($Parameter.Key) = $Parameter.Value
    }

    New-AtwsData -Entity $InputObject
 }   

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

  }


        
}
