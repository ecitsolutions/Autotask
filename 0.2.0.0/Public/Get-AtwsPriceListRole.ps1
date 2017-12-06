﻿<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Get-AtwsPriceListRole
{
  <#
      .SYNOPSIS
      This function get a PriceListRole through the Autotask Web Services API.
      .DESCRIPTION
      This function get a PriceListRole through the Autotask Web Services API.
      .EXAMPLE
      Get-AtwsPriceListRole [-ParameterName] [Parameter value]
      Use Get-Help Get-AtwsPriceListRole
      .NOTES
      NAME: Get-AtwsPriceListRole
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
         [Int]
         $RoleID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $CurrencyID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [boolean]
         $UsesInternalCurrencyPrice
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [decimal]
         $HourlyRate
 ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','RoleID','CurrencyID','UsesInternalCurrencyPrice','HourlyRate')]
        [String[]]
        $NotEquals ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','RoleID','CurrencyID','UsesInternalCurrencyPrice','HourlyRate')]
        [String[]]
        $GreaterThan ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','RoleID','CurrencyID','UsesInternalCurrencyPrice','HourlyRate')]
        [String[]]
        $GreaterThanOrEqual ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','RoleID','CurrencyID','UsesInternalCurrencyPrice','HourlyRate')]
        [String[]]
        $LessThan ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','RoleID','CurrencyID','UsesInternalCurrencyPrice','HourlyRate')]
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
        $Fields = $Atws.GetFieldInfo('PriceListRole')
        
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

    Get-AtwsData -Entity PriceListRole -Filter $Filter }   

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

  }


        
}
