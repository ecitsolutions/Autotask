#Requires -Version 4.0
<#

    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

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
            $Invoice | Get-AtwsInvoiceInfo
            Gets information about invoices passed through the pipeline
        .EXAMPLE
            Get-AtwsInvoiceInfo -InvoiceID $Invoice.id
            Gets information about invoices based on the ids passed as a parameter
        .NOTES
            NAME: Get-AtwsInvoiceInfo
      
  #>
	
    [cmdletbinding(
        DefaultParameterSetName = 'By_parameters'
    )]
    Param
    (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeLine = $true,
            ParameterSetName = 'Input_Object'
        )]
        [Parameter(
            Mandatory = $true,
            ValueFromPipeLine = $true,
            ParameterSetName = 'Input_Object_as_XML'
        )]
        [Parameter(
            Mandatory = $true,
            ValueFromPipeLine = $true,
            ParameterSetName = 'Input_Object_as_XLSX'
        )]
        [Autotask.Invoice[]]
        $InputObject,

        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'By_parameters'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'By_parameters_as_XML'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'By_parameters_as_XLSX'
        )]
        [string[]]
        $InvoiceId,

        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Input_Object_as_XML'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'By_parameters_as_XML'
        )]
        [switch]
        $XML,

        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Input_Object_as_XLSX'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'By_parameters_as_XLSX'
        )]
        [switch]
        $XLSX,

        [Parameter(
            ParameterSetName = 'Input_Object_as_XML'
        )]
        [Parameter(
            ParameterSetName = 'Input_Object_as_XLSX'
        )]
        [Parameter(
            ParameterSetName = 'By_parameters_as_XML'
        )]
        [Parameter(
            ParameterSetName = 'By_parameters_as_XLSX'
        )]
        [String]
        $OutputFile
    )
  
  begin {
    
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }

        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
        if (-not($Script:Atws.integrationsValue)) {
            Throw [ApplicationException] 'Not connected to Autotask WebAPI. Re-import module with valid credentials.'
        }    
    
        # Empty container to return with results
        if ($XML.IsPresent) {
            $result = New-Object XML.XmlDocument
            $root = $result.CreateNode('element', 'invoice_batch_generic', $null)
            $null = $result.AppendChild($root) 
        }
        else { 
            $result = @()
        }

        # If $OutputFile is relative, make sure it is relative to $PWD, not module directory
        if ($OutputFile) { 
            if (-not(Split-Path -Path $OutputFile -IsAbsolute)) {
                $OutputFile = Join-Path $PWD -ChildPath $OutputFile
            }
        }
    }

    process {
        
        # Input was by object. Extract invoice ids into an array and proceed 
        if ($PSCmdlet.ParameterSetName -eq 'Input_Object') {
            $InvoiceId = $InputObject.id
        }

        # Get detailed invoice info through special API call. Have to call
        # API once for each invoice. Second parameter says we want the result
        # as XML. Actually we don't, but the alternative (HTML) is worse.
    
    Write-Verbose ('{0}: Asking for details on Invoice IDs {1}' -F $MyInvocation.MyCommand.Name, ($InvoiceId -join ', '))
       
    ForEach ($id in $InvoiceId) {
           
            # The API call. Make sure to query the correct WebServiceProxy object
            # specified by the $Prefix name. If the Id does not exist we get a
            # SOAP exception for some inexplicable reason
            try { 
                [Xml]$invoiceInfo = $Script:Atws.GetInvoiceMarkup($Script:Atws.integrationsValue, $id, 'XML')
            }
            catch {
                Write-Warning ('{0}: FAILED on Invoice ID {1}. No data returned.' -F $MyInvocation.MyCommand.Name, $id)
              
        # try the next ID
        Continue
      }
      
      Write-Verbose ('{0}: Converting Invoice ID {1} to a PSObject' -F $MyInvocation.MyCommand.Name, $id)
           
            if ($XML.IsPresent) { 
                # Import node with deep clone = $true
                $batch = $result.ImportNode($invoiceInfo.invoice_batch_generic.invoice_batch, $true)
                $account = $result.ImportNode($invoiceInfo.invoice_batch_generic.account, $true)
                $null = $batch.LastChild.AppendChild($account)
                $null = $result.FirstChild.AppendChild($batch)
            }
            else { 
                $result += $invoiceInfo.invoice_batch_generic | ConvertFrom-XML
            }

            
        }

    }

    end {

        if ($XLSX.IsPresent) {

            Write-Verbose ('{0}: Output as XLSX has been requested, loading ImportExcel module.' -F $MyInvocation.MyCommand.Name)

            # Import the ImportExcel module or fail
            Import-Module -Name ImportExcel -ErrorAction Stop

            # Make Excel package
            $excelOptions = @{
                PassThru      = ($OutputFile) -xor $true # If ($outputfile), no passthrough
                AutoSize      = $true
                AutoFilter    = $true
                ClearSheet    = $true
                TableName     = 'AutotaskInvoiceInfo'
                WorksheetName = 'AutotaskInvoiceInfo'
            }

            if ($OutputFile) {
                # Add .xlsx file extension if missing
                if (-not($OutputFile -like '*.xlsx')) {
                    $OutputFile = '{0}{1}' -f $OutputFile, '.xlsx'
                }

                $excelOptions['Path'] = $OutputFile
            }
            if ($excelOptions.Passthru) {
                Write-Verbose ('{0}: Returning {1} lines as an Excel Package ' -F $MyInvocation.MyCommand.Name, $result.account.invoice.invoice_item.count)
            }
            else { 
                Write-Verbose ('{0}: Writing output to file {1}' -F $MyInvocation.MyCommand.Name, $OutputFile)
            }

            $result = $result.account.invoice.invoice_item | Export-Excel @excelOptions
        }
        elseif ($OutputFile -and $XML.IsPresent) {
            
            # Add .xml file extension if missing
            if (-not($OutputFile -like '*.xml')) {
                $OutputFile = '{0}{1}' -f $OutputFile, '.xml'
            }

            Write-Verbose ('{0}: Writing output to file {1}' -F $MyInvocation.MyCommand.Name, $OutputFile)


            $result.save($OutputFile)
        }


        
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        If (-not($OutputFile)) { 
            return $result
        }
    }
}