<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Get-AtwsQuoteTemplate
{
  <#
      .SYNOPSIS
      This function get a QuoteTemplate through the Autotask Web Services API.
      .DESCRIPTION
      This function get a QuoteTemplate through the Autotask Web Services API.
      .EXAMPLE
      Get-AtwsQuoteTemplate [-ParameterName] [Parameter value]
      Use Get-Help Get-AtwsQuoteTemplate
      .NOTES
      NAME: Get-AtwsQuoteTemplate
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
         [boolean]
         $Active
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [boolean]
         $CalculateTaxSeparately
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $CreateDate
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $CreatedBy
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
         [string]
         $Description
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [boolean]
         $DisplayTaxCategorySuperscripts
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $LastActivityBy
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $LastActivityDate
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $Name
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
         [ValidateSet('A4: 8.25" x 11.75 (210 mm x 297 mm)','Letter: 8.5" x 11" (215.9 mm x 279.4 mm)')]

        [String]
         $PageLayout
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Bottom Center','Bottom Left','Bottom Right','No')]

        [String]
         $PageNumberFormat
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [boolean]
         $ShowEachTaxInGroup
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [boolean]
         $ShowGridHeader
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [boolean]
         $ShowTaxCategory
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [boolean]
         $ShowVerticalGridLines
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $CurrencyPositiveFormat
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $CurrencyNegativeFormat
 ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','Active','CalculateTaxSeparately','CreateDate','CreatedBy','Description','DisplayTaxCategorySuperscripts','LastActivityBy','LastActivityDate','Name','ShowEachTaxInGroup','ShowGridHeader','ShowTaxCategory','ShowVerticalGridLines','CurrencyPositiveFormat','CurrencyNegativeFormat')]
        [String[]]
        $NotEquals ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','Active','CalculateTaxSeparately','CreateDate','CreatedBy','Description','DisplayTaxCategorySuperscripts','LastActivityBy','LastActivityDate','Name','ShowEachTaxInGroup','ShowGridHeader','ShowTaxCategory','ShowVerticalGridLines','CurrencyPositiveFormat','CurrencyNegativeFormat')]
        [String[]]
        $GreaterThan ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','Active','CalculateTaxSeparately','CreateDate','CreatedBy','Description','DisplayTaxCategorySuperscripts','LastActivityBy','LastActivityDate','Name','ShowEachTaxInGroup','ShowGridHeader','ShowTaxCategory','ShowVerticalGridLines','CurrencyPositiveFormat','CurrencyNegativeFormat')]
        [String[]]
        $GreaterThanOrEqual ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','Active','CalculateTaxSeparately','CreateDate','CreatedBy','Description','DisplayTaxCategorySuperscripts','LastActivityBy','LastActivityDate','Name','ShowEachTaxInGroup','ShowGridHeader','ShowTaxCategory','ShowVerticalGridLines','CurrencyPositiveFormat','CurrencyNegativeFormat')]
        [String[]]
        $LessThan ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','Active','CalculateTaxSeparately','CreateDate','CreatedBy','Description','DisplayTaxCategorySuperscripts','LastActivityBy','LastActivityDate','Name','ShowEachTaxInGroup','ShowGridHeader','ShowTaxCategory','ShowVerticalGridLines','CurrencyPositiveFormat','CurrencyNegativeFormat')]
        [String[]]
        $LessThanOrEquals ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('Description','Name','CurrencyPositiveFormat','CurrencyNegativeFormat')]
        [String[]]
        $Like ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('Description','Name','CurrencyPositiveFormat','CurrencyNegativeFormat')]
        [String[]]
        $NotLike ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('Description','Name','CurrencyPositiveFormat','CurrencyNegativeFormat')]
        [String[]]
        $BeginsWith ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('Description','Name','CurrencyPositiveFormat','CurrencyNegativeFormat')]
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
        $Fields = $Atws.GetFieldInfo('QuoteTemplate')
        
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

    Get-AtwsData -Entity QuoteTemplate -Filter $Filter }   

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

  }


        
}
