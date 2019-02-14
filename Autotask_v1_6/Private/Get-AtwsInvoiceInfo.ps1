<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md  for license information.

#>

Function Get-AtwsInvoiceInfo {
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
    [Parameter(
        Mandatory = $True,
        ValueFromPipeLine = $True,
        ParameterSetName = 'Input_Object'
    )]
    [Autotask.Invoice[]]
    $InputObject,

    [Parameter(
        Mandatory = $True,
        ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $InvoiceId
  )
  
  Begin {
    # We replace #Prefix with the dynamic module prefix when this function is imported
    $Prefix = '#Prefix'
    
    # Input was by object. Extract invoice ids into an array and proceed 
    If ($PSCmdlet.ParameterSetName -eq 'Input_Object') {
      $InvoiceId = $InputObject.id
    }

  }

  Process {
    # Empty container to return with results
    $Result = @()
  
    # Get detailed invoice info through special API call. Have to call
    # API once for each invoice. Second parameter says we want the result
    # as XML. Actually we don't, but the alternative (HTML) is worse.
    
    Write-Verbose ('{0}: Asking for details on Invoice IDs {1}' -F $MyInvocation.MyCommand.Name, ($InvoiceId -join ', '))
       
    ForEach ($Id in $InvoiceId) {
           
      # The API call. Make sure to query the correct WebServiceProxy object
      # specified by the $Prefix name. If the Id does not exist we get a
      # SOAP exception for some inexplicable reason
      Try { 
        [Xml]$InvoiceInfo = $AtwsConnection[$Prefix].GetInvoiceMarkup($Id, 'XML')
      }
      Catch {
        Write-Warning ('{0}: FAILED on Invoice ID {1}. No data returned.' -F $MyInvocation.MyCommand.Name, $Id)
              
        # Try the next ID
        Continue
      }
      
      Write-Verbose ('{0}: Converting Invoice ID {1} to a PSObject' -F $MyInvocation.MyCommand.Name, $Id)
           
      $Result += $InvoiceInfo.invoice_batch_generic | ConvertTo-PSObject
    }
  }

  End {
    Return $Result
  }
}