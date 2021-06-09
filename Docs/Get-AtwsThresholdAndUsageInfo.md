---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# Get-AtwsThresholdAndUsageInfo

## SYNOPSIS
This function collects information about a specific Autotask invoice object and returns a generic
powershell object with all relevant information as a starting point for import into other systems.

## SYNTAX

```
Get-AtwsThresholdAndUsageInfo [<CommonParameters>]
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
Get-AtwsThresholdAndUsageInfo
```

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Nothing
## OUTPUTS

### [String]
## NOTES

## RELATED LINKS
