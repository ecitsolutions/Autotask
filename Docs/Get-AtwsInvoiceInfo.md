---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# Get-AtwsInvoiceInfo

## SYNOPSIS
This function collects information about a specific Autotask invoice object and returns a generic
powershell object with all relevant information as a starting point for import into other systems.

## SYNTAX

### By_parameters (Default)
```
Get-AtwsInvoiceInfo -InvoiceId <String[]> [<CommonParameters>]
```

### Input_Object_as_XLSX
```
Get-AtwsInvoiceInfo -InputObject <Invoice[]> [-XLSX] [-OutputFile <String>] [<CommonParameters>]
```

### Input_Object_as_XML
```
Get-AtwsInvoiceInfo -InputObject <Invoice[]> [-XML] [-OutputFile <String>] [<CommonParameters>]
```

### Input_Object
```
Get-AtwsInvoiceInfo -InputObject <Invoice[]> [<CommonParameters>]
```

### By_parameters_as_XLSX
```
Get-AtwsInvoiceInfo -InvoiceId <String[]> [-XLSX] [-OutputFile <String>] [<CommonParameters>]
```

### By_parameters_as_XML
```
Get-AtwsInvoiceInfo -InvoiceId <String[]> [-XML] [-OutputFile <String>] [<CommonParameters>]
```

## DESCRIPTION
The function accepts an invoice object or an invoice id and makes a special API call to get a 
complete invoice description, including billingitems.
For some types of billingitems additional
information may be collected.
All information is collected and stored in a PSObject which is
returned.

## EXAMPLES

### EXAMPLE 1
```
$Invoice | Get-AtwsInvoiceInfo
Gets information about invoices passed through the pipeline
```

### EXAMPLE 2
```
Get-AtwsInvoiceInfo -InvoiceID $Invoice.id
Gets information about invoices based on the ids passed as a parameter
```

## PARAMETERS

### -InputObject
{{ Fill InputObject Description }}

```yaml
Type: Invoice[]
Parameter Sets: Input_Object_as_XLSX, Input_Object_as_XML, Input_Object
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -InvoiceId
{{ Fill InvoiceId Description }}

```yaml
Type: String[]
Parameter Sets: By_parameters, By_parameters_as_XLSX, By_parameters_as_XML
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -XML
{{ Fill XML Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Input_Object_as_XML, By_parameters_as_XML
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -XLSX
{{ Fill XLSX Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Input_Object_as_XLSX, By_parameters_as_XLSX
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputFile
{{ Fill OutputFile Description }}

```yaml
Type: String
Parameter Sets: Input_Object_as_XLSX, Input_Object_as_XML, By_parameters_as_XLSX, By_parameters_as_XML
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### An Autotask invoice object or an invoice id
## OUTPUTS

### A custom PSObject with detailed information about an invoice
## NOTES
NAME: Get-AtwsInvoiceInfo

## RELATED LINKS
