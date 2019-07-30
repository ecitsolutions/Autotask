$Here = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

$Module = 'Autotask'

$Moduledir = '{0}\{1}' -F $Here, $Module
<#
Get-Module $module | Remove-Module -Force

Import-Module $Moduledir\$Module.psm1 -Force
#>
Describe 'Query tests' -Tags 'Unit', 'Acceptance', 'Query' {

  InModuleScope Autotask {

    Context 'Get-AtwsAccount with live' {

      It 'should be an Account with Id 0' {

        $Result = Get-AtwsAccount -Id 0

        $Result.Count | Should -Be 1
        $Result.AccountName | Should -BeOfType String
      }

    }


    Context 'Get-AtwsAccount with mock' {

      Mock Get-AtwsData {
        $Result = @()
        $Account = New-Object -TypeName psobject -Property @{
          Address1                               = 'Hvervenmovn 45'
          Address2                               = $null
          AlternatePhone1                        = $null
          AlternatePhone2                        = $null
          AssetValue                             = $null
          City                                   = 'HØNEFOSS'
          CompetitorID                           = $null
          Country                                = 'Norway'
          CreateDate                             = Get-Date '16.05.2002 12:56:33'
          Fax                                    = $null
          KeyAccountIcon                         = 9
          LastActivityDate                       = Get-Date '12.03.2019 15:52:20'
          MarketSegmentID                        = $null
          AccountName                            = 'OFFICE CLOUD'
          AccountNumber                          = 'SYSTEMKONTO'
          BillToAddressToUse                     = 1
          BillToAttention                        = $null
          BillToAddress1                         = 'Hvervenmovn 45'
          BillToAddress2                         = $null
          BillToCity                             = 'HØNEFOSS'
          BillToState                            = $null
          BillToZipCode                          = 3511
          BillToCountryID                        = 167
          BillToAdditionalAddressInformation     = $null
          InvoiceMethod                          = 2
          InvoiceNonContractItemsToParentAccount = $False
          QuoteTemplateID                        = 1
          QuoteEmailMessageID                    = 1
          InvoiceTemplateID                      = 102
          InvoiceEmailMessageID                  = 1
          CurrencyID                             = 103
          BillToAccountPhysicalLocationID        = $null
          SurveyAccountRating                    = $null
          CreatedByResourceID                    = 29683468
          ApiVendorID                            = $null
          Fields                                 = $null
          id                                     = 0
        }

        # Result should always be an array
        $Result += $Account
        Return $Result
      } -ModuleName Autotask

      It 'should change timezone to localtime' {

        $ESTzone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Eastern Standard Time")

        $Now = Get-Date
        $ESTtime = [System.TimeZoneInfo]::ConvertTimeFromUtc($Now.ToUniversalTime(), $ESTzone)
        $ESToffset = (New-TimeSpan -Start $ESTtime -End $Now).TotalHours

        $Result = Get-AtwsAccount -Id 0

        $Result.CreateDate | Should -Be $((Get-Date '16.05.2002 12:56:33').AddHours($ESToffset))
      }

      It 'Should have called Get-AtwsData' {
        Assert-MockCalled Get-AtwsData -ModuleName Autotask
      }

    }

  }

}