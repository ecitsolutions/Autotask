#Requires -Version 4.0
<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md  for license information.

#>

Function Get-AtwsThresholdAndUsageInfo {
  <#
      .SYNOPSIS
      This function collects information about a specific Autotask invoice object and returns a generic
      powershell object with all relevant information as a starting point for import into other systems.
      .DESCRIPTION
      The function accepts an invoice object or an invoice id and makes a special API call to get a 
      complete invoice description, including billingitems. For some types of billingitems additional
      information may be collected. All information is collected and stored in a PSObject which is
      returned.
      .INPUTS
      An Autotask invoice object or an invoice id
      .OUTPUTS
      A custom PSObject with detailed information about an invoice
      .EXAMPLE
      $Invoice | Get-#PrefixInvoiceInfo
      Gets information about invoices passed through the pipeline
      .EXAMPLE
      Get-#PrefixInvoiceInfo -InvoiceID $Invoice.id
      Gets information about invoices based on the ids passed as a parameter
      .NOTES
      NAME: Get-#PrefixInvoiceInfo
      
  #>
	
  [cmdletbinding()]
  Param
  (
  )
  
  begin {
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
    # Enable modern -Debug behavior
    if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    if (-not($Script:Atws.Url))
    {
      Throw [ApplicationException] 'Not connected to Autotask WebAPI. Re-import module with valid credentials.'
    }    
  }

  process {
    try { 
      $result = $Script:Atws.GetThresholdAndUsageInfo()
    }
    catch {
      Write-Warning ('{0}: FAILED on GetThresholdAndUsageInfo(). No data returned.' -F $MyInvocation.MyCommand.Name)
              
      # try the next ID
      Continue
    }


    # Handle any errors
    if ($result.Errors.Count -gt 0)
    {
      foreach ($AtwsError in $result.Errors)
      {
        Write-Error $AtwsError.Message
      }
      Return
    }
    
    $ThresholdInfo = New-Object -TypeName PSObject
    foreach ($string in $result.EntityReturnInfoResults.Message -Split ';') {
      $Substring = $string -split ':'
      if ($Substring[0].length -gt 0) {
        Add-Member -InputObject $ThresholdInfo -MemberType NoteProperty -Name $Substring[0].Trim() -Value $Substring[1].Trim()
      }
    }

  }

  end {
    Return $ThresholdInfo
  }
}