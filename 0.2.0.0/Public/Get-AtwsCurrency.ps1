<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Get-AtwsCurrency
{
  <#
      .SYNOPSIS
      This function get a Currency through the Autotask Web Services API.
      .DESCRIPTION
      This function get a Currency through the Autotask Web Services API.
      .EXAMPLE
      Get-AtwsCurrency [-ParameterName] [Parameter value]
      Use Get-Help Get-AtwsCurrency
      .NOTES
      NAME: Get-AtwsCurrency
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
         [string]
         $Name
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
         [ValidateSet('','؋‎','ብር','֏','ናቕፋ','₭','₮','₱','₲','₴','₸','₹','₺','රු','₼','₽','₾','៛','﷼‎','.ރ‎','$','$b','$MN','$T','$U','.ب‎.د‎','/-','£','£E','£S','¥','₡','₦','₩','₪','₫','฿','€','A$','AED','AFL','Afl.','AFN','Afs','ALL','AMD','ANG','AOA','Ar','ARS','AUD','AWG','AZN','B$','B/.','BAM','BBD','BD','BD$','Bds$','BDT','BGN','BHD','BIF','BMD','BND','BOB','BR','Br','BRL','Bs','Bs.','Bs.F.','BSD','BTN','BWP','BYR','BZ$','BZD','C$','CAD','CDF','CF','CFA','CHF','CI$','CLP','CN¥','CNH','CNY','COL$','COP','CRC','CUC','CUC$','CUP','CVE','CZK','D','DA','Db','DH','Dh','Dhs','din.','dinar','DJF','DK','DKK','DOP','DT','DZD','E','E£','EC$','EGP','ERN','ETB','EUR','F','f','ƒ','FBu','FC','FCFA','Fdj','FG','FJ$','FJD','FK£','FKP','Fr','Fr.','FRw','FS','Ft','G','G$','GBP','GEL','GFr','GH₵','GH¢','GHS','GIP','GMD','GNF','Gs','GTQ','GY$','GYD','HK$','HKD','HNL','HRK','HTG','HUF','IDR','Íkr','ILS','IMP','INR','IQD','IRR','ISK','J$','JD','JMD','JOD','JPY','K','K.D.','Kč','KES','KGS','KHR','KM','KMF','KN','kn','KPW','kr','kr.','KRW','Ks','KSh','KWD','KYD','Kz','KZT','L','L$','L.E.','LAK','LBP','LD','LD$','LE','Le','lei','Lek','LKR','LRD','LS','LSL','LYD','M','m','m.','M£','MAD','man.','MDL','MGA','MK','MKD','MMK','MNT','MOP','MOP$','MRf','MRO','MT','MTn','MUR','MVR','MWK','MXN','MYR','MZN','₭N','N$','NAD','NAf','NAƒ','NAFl','Nfk','NGN','NIO','NIS','NOK','NPR','NT$','Nu.','NZ$','NZD','OMR','P','p.','PAB','PEN','PGK','PHP','PhP','Php','PKR','PLN','PT','PYG','Q','QAR','QR','R','R$','R₣','RD$','Re','RF','Rf','RM','RMB','RON','Rp','Rs','RSD','RUB','RWF','S','S$','S/.','SAR','SAT','SBD','SCR','SDG','SEK','SFr.','SGD','Sh','Sh.So.','SHP','SI$','SLL','SLRs','SM','SOS','SR','SRD','SRe','ST','STD','SVC','SYP','SZL','T','T$','TD','THB','TJS','Tk','TMT','TND','TOP','TRY','TSh','TT$','TTD','TV$','TVD','TWD','TZS','UAH','UGX','UM','USD','USh','UYU','UZS','VEF','VND','VT','VUV','WS$','WST','XAF','XCD','XOF','XPF','YER','Z$','ZAR','ZK','zł','ZMW','ZWD','ден','лв','ман','РСД','руб','ج.س.','س‎.ج‎.','ت‎.د‎','ع‎.د‎','م‎.د‎.','دج‎','ع‎.ر‎.','ق‎.ر‎','ك‎','د‎.ل‎','ل‎.ل‎','रू','৳','ლ')]

        [String]
         $DisplaySymbol
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [decimal]
         $ExchangeRate
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $LastModifiedDateTime
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $UpdateResourceId
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [boolean]
         $IsInternalCurrency
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
        [ValidateSet('id','Name','Description','ExchangeRate','LastModifiedDateTime','UpdateResourceId','IsInternalCurrency','Active','CurrencyPositiveFormat','CurrencyNegativeFormat')]
        [String[]]
        $NotEquals ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','Name','Description','ExchangeRate','LastModifiedDateTime','UpdateResourceId','IsInternalCurrency','Active','CurrencyPositiveFormat','CurrencyNegativeFormat')]
        [String[]]
        $GreaterThan ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','Name','Description','ExchangeRate','LastModifiedDateTime','UpdateResourceId','IsInternalCurrency','Active','CurrencyPositiveFormat','CurrencyNegativeFormat')]
        [String[]]
        $GreaterThanOrEqual ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','Name','Description','ExchangeRate','LastModifiedDateTime','UpdateResourceId','IsInternalCurrency','Active','CurrencyPositiveFormat','CurrencyNegativeFormat')]
        [String[]]
        $LessThan ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','Name','Description','ExchangeRate','LastModifiedDateTime','UpdateResourceId','IsInternalCurrency','Active','CurrencyPositiveFormat','CurrencyNegativeFormat')]
        [String[]]
        $LessThanOrEquals ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('Name','Description','CurrencyPositiveFormat','CurrencyNegativeFormat')]
        [String[]]
        $Like ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('Name','Description','CurrencyPositiveFormat','CurrencyNegativeFormat')]
        [String[]]
        $NotLike ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('Name','Description','CurrencyPositiveFormat','CurrencyNegativeFormat')]
        [String[]]
        $BeginsWith ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('Name','Description','CurrencyPositiveFormat','CurrencyNegativeFormat')]
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
        $Fields = $Atws.GetFieldInfo('Currency')
        
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

    Get-AtwsData -Entity Currency -Filter $Filter }   

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

  }


        
}
