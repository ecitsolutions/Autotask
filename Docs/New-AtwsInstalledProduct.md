---
external help file: Autotask-help.xml
Module Name: Autotask
online version:
schema: 2.0.0
---

# New-AtwsInstalledProduct

## SYNOPSIS
This function creates a new InstalledProduct through the Autotask Web Services API.
All required properties are marked as required parameters to assist you on the command line.

## SYNTAX

### By_parameters (Default)
```
New-AtwsInstalledProduct [-UserDefinedFields <UserDefinedField[]>] -AccountID <Int32>
 [-AccountPhysicalLocationID <Int32>] -Active <Boolean> [-ApiVendorID <String>] [-ContactID <Int32>]
 [-ContractID <Int32>] [-ContractServiceBundleID <Int32>] [-ContractServiceID <Int32>] [-CreateDate <DateTime>]
 [-CreatedByPersonID <Int32>] [-DailyCost <Double>] [-DattoAvailableKilobytes <Int64>]
 [-DattoDeviceMemoryMegabytes <Int32>] [-DattoDrivesErrors <Boolean>] [-DattoHostname <String>]
 [-DattoInternalIP <String>] [-DattoKernelVersionID <String>] [-DattoLastCheckInDateTime <DateTime>]
 [-DattoNICSpeedKilobitsPerSecond <Int32>] [-DattoNumberOfAgents <Int32>] [-DattoNumberOfDrives <Int32>]
 [-DattoNumberOfVolumes <Int32>] [-DattoOffsiteUsedBytes <Int64>] [-DattoOSVersionID <String>]
 [-DattoPercentageUsed <Double>] [-DattoProtectedKilobytes <Int64>] [-DattoRemoteIP <String>]
 [-DattoSerialNumber <String>] [-DattoUptimeSeconds <Int32>] [-DattoUsedKilobytes <Int64>]
 [-DattoZFSVersionID <String>] [-DeviceNetworkingID <String>] [-HourlyCost <Double>]
 [-ImpersonatorCreatorResourceID <Int32>] [-InstallDate <DateTime>] [-InstalledByContactID <Int32>]
 [-InstalledByID <Int32>] [-InstalledProductCategoryID <Int32>] [-LastActivityPersonID <Int32>]
 [-LastActivityPersonType <String>] [-LastModifiedTime <DateTime>] [-Location <String>] [-MonthlyCost <Double>]
 [-Notes <String>] [-NumberOfUsers <Double>] [-ParentInstalledProductID <Int32>] [-PerUseCost <Double>]
 -ProductID <Int32> [-ReferenceNumber <String>] [-ReferenceTitle <String>]
 [-RMMDeviceAuditAntivirusStatusID <String>] [-RMMDeviceAuditArchitectureID <String>]
 [-RMMDeviceAuditBackupStatusID <String>] [-RMMDeviceAuditDescription <String>]
 [-RMMDeviceAuditDeviceTypeID <String>] [-RMMDeviceAuditDisplayAdaptorID <String>]
 [-RMMDeviceAuditDomainID <String>] [-RMMDeviceAuditExternalIPAddress <String>]
 [-RMMDeviceAuditHostname <String>] [-RMMDeviceAuditIPAddress <String>] [-RMMDeviceAuditLastUser <String>]
 [-RMMDeviceAuditMacAddress <String>] [-RMMDeviceAuditManufacturerID <String>]
 [-RMMDeviceAuditMemoryBytes <Int64>] [-RMMDeviceAuditMissingPatchCount <Int32>]
 [-RMMDeviceAuditMobileNetworkOperatorID <String>] [-RMMDeviceAuditMobileNumber <String>]
 [-RMMDeviceAuditModelID <String>] [-RMMDeviceAuditMotherboardID <String>]
 [-RMMDeviceAuditOperatingSystem <String>] [-RMMDeviceAuditPatchStatusID <String>]
 [-RMMDeviceAuditProcessorID <String>] [-RMMDeviceAuditServicePackID <String>]
 [-RMMDeviceAuditSNMPContact <String>] [-RMMDeviceAuditSNMPLocation <String>]
 [-RMMDeviceAuditSNMPName <String>] [-RMMDeviceAuditSoftwareStatusID <String>]
 [-RMMDeviceAuditStorageBytes <Int64>] [-RMMDeviceID <Int64>] [-RMMDeviceUID <String>]
 [-RMMOpenAlertCount <Int32>] [-SerialNumber <String>] [-ServiceBundleID <Int32>] [-ServiceID <Int32>]
 [-ServiceLevelAgreementID <String>] [-SetupFee <Double>] [-SourceCostID <Int32>] [-SourceCostType <String>]
 [-Type <String>] [-VendorID <Int32>] [-WarrantyExpirationDate <DateTime>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Input_Object
```
New-AtwsInstalledProduct [-InputObject <InstalledProduct[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The function supports all properties of an \[Autotask.InstalledProduct\] that can be updated through the Web Services API.
The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values.
Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter.
To get the InstalledProduct with Id number 0 you could write 'New-AtwsInstalledProduct -Id 0' or you could write 'New-AtwsInstalledProduct -Filter {Id -eq 0}.

'New-AtwsInstalledProduct -Id 0,4' could be written as 'New-AtwsInstalledProduct -Filter {id -eq 0 -or id -eq 4}'.
For simple queries you can see that using parameters is much easier than the -Filter option.
But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday).
As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new InstalledProduct you need the following required fields:
 -AccountID
 -Active
 -ProductID

Entities that have fields that refer to the base entity of this CmdLet:

## EXAMPLES

### EXAMPLE 1
```
$result = New-AtwsInstalledProduct -AccountID [Value] -Active [Value] -ProductID [Value]
Creates a new [Autotask.InstalledProduct] through the Web Services API and returns the new object.
```

### EXAMPLE 2
```
$result = Get-AtwsInstalledProduct -Id 124 | New-AtwsInstalledProduct 
Copies [Autotask.InstalledProduct] by Id 124 to a new object through the Web Services API and returns the new object.
```

### EXAMPLE 3
```
Copies [Autotask.InstalledProduct] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsInstalledProduct to modify the object.
```

### EXAMPLE 4
```
-Passthru
Copies [Autotask.InstalledProduct] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsInstalledProduct to modify the object and returns the new object.
```

## PARAMETERS

### -InputObject
An array of objects to create

```yaml
Type: InstalledProduct[]
Parameter Sets: Input_Object
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -UserDefinedFields
User defined fields already setup i Autotask

```yaml
Type: UserDefinedField[]
Parameter Sets: By_parameters
Aliases: UDF

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccountID
Client

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccountPhysicalLocationID
Account Physical Location

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Active
Product Active

```yaml
Type: Boolean
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiVendorID
API Vendor ID

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContactID
Contact Name

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContractID
Contract ID

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContractServiceBundleID
Contract Service Bundle Id

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContractServiceID
Contract Service Id

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreateDate
{{ Fill CreateDate Description }}

```yaml
Type: DateTime
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreatedByPersonID
Created By Person ID

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DailyCost
Configuration Item Daily Cost

```yaml
Type: Double
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DattoAvailableKilobytes
Datto Available Kilobytes

```yaml
Type: Int64
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DattoDeviceMemoryMegabytes
Datto Device Memory Megabytes

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DattoDrivesErrors
Datto Drives Errors

```yaml
Type: Boolean
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DattoHostname
Datto Hostname

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DattoInternalIP
Datto Internal IP

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DattoKernelVersionID
Datto Kernel Version ID

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DattoLastCheckInDateTime
Datto Last Check In Date Time

```yaml
Type: DateTime
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DattoNICSpeedKilobitsPerSecond
Datto NIC Speed Kilobits Per Second

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DattoNumberOfAgents
Datto Number Of Agents

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DattoNumberOfDrives
Datto Number Of Drives

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DattoNumberOfVolumes
Datto Number Of Volumes

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DattoOffsiteUsedBytes
Datto Offsite Used Bytes

```yaml
Type: Int64
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DattoOSVersionID
Datto OS Version ID

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DattoPercentageUsed
Datto Percentage Used

```yaml
Type: Double
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DattoProtectedKilobytes
Datto Protected Kilobytes

```yaml
Type: Int64
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DattoRemoteIP
Datto Remote IP

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DattoSerialNumber
Datto Serial Number

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DattoUptimeSeconds
Datto Uptime Seconds

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DattoUsedKilobytes
Datto Used Kilobytes

```yaml
Type: Int64
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DattoZFSVersionID
Datto ZFS Version ID

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceNetworkingID
Device Networking ID

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HourlyCost
Configuration Item Hourly Cost

```yaml
Type: Double
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ImpersonatorCreatorResourceID
Impersonator Creator Resource ID

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstallDate
Install Date

```yaml
Type: DateTime
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstalledByContactID
Installed By Contact ID

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstalledByID
Installed By Resource ID

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstalledProductCategoryID
Installed Product Category ID

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -LastActivityPersonID
Last Activity Person ID

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -LastActivityPersonType
Last Activity Person Type

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LastModifiedTime
Last Modified Time

```yaml
Type: DateTime
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Location
Location

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MonthlyCost
Configuration Item Monthly Cost

```yaml
Type: Double
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Notes
Configuration Item Notes

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NumberOfUsers
Configuration Item Number of Users

```yaml
Type: Double
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentInstalledProductID
Parent Configuration Item

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PerUseCost
Configuration Item Per Use Cost

```yaml
Type: Double
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProductID
Product ID

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReferenceNumber
Reference Number

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReferenceTitle
Reference Title

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceAuditAntivirusStatusID
RMM Device Audit Antivirus Status ID

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceAuditArchitectureID
RMM Device Audit Architecture ID

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceAuditBackupStatusID
RMM Device Audit Backup Status ID

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceAuditDescription
RMM Device Audit Description

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceAuditDeviceTypeID
RMM Device Audit Device Type ID

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceAuditDisplayAdaptorID
RMM Device Audit Display Adaptor ID

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceAuditDomainID
RMM Device Audit Domain ID

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceAuditExternalIPAddress
RMM Device Audit External IP Address

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceAuditHostname
RMM Device Audit Hostname

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceAuditIPAddress
RMM Device Audit IP Address

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceAuditLastUser
RMM Device Audit Last User

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceAuditMacAddress
RMM Device Audit Mac Address

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceAuditManufacturerID
RMM Device Audit Manufacturer ID

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceAuditMemoryBytes
RMM Device Audit Memory Bytes

```yaml
Type: Int64
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceAuditMissingPatchCount
RMM Device Audit Missing Patch Count

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceAuditMobileNetworkOperatorID
RMM Device Audit Mobile Network Operator ID

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceAuditMobileNumber
RMM Device Audit Mobile Number

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceAuditModelID
RMM Device Audit Model ID

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceAuditMotherboardID
RMM Device Audit Motherboard ID

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceAuditOperatingSystem
RMM Device Audit Operating System

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceAuditPatchStatusID
RMM Device Audit Patch Status ID

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceAuditProcessorID
RMM Device Audit Processor ID

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceAuditServicePackID
RMM Device Audit Service Pack ID

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceAuditSNMPContact
RMM Device Audit SNMP Contact

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceAuditSNMPLocation
RMM Device Audit SNMP Location

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceAuditSNMPName
RMM Device Audit SNMP Name

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceAuditSoftwareStatusID
RMM Device Audit Software Status ID

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceAuditStorageBytes
RMM Device Audit Storage Bytes

```yaml
Type: Int64
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceID
RMM Device ID

```yaml
Type: Int64
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMDeviceUID
RMM Device UID

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RMMOpenAlertCount
RMM Open Alert Count

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -SerialNumber
Serial Number

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceBundleID
Service Bundle ID

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceID
Service ID

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceLevelAgreementID
Service Level Agreement

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SetupFee
Configuration Item Setup Fee

```yaml
Type: Double
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourceCostID
Source Cost ID

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourceCostType
Source Cost Type

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
Configuration Item Type

```yaml
Type: String
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VendorID
Vendor Name

```yaml
Type: Int32
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -WarrantyExpirationDate
Warranty Expiration Date

```yaml
Type: DateTime
Parameter Sets: By_parameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Nothing. This function only takes parameters.
## OUTPUTS

### [Autotask.InstalledProduct]. This function outputs the Autotask.InstalledProduct that was created by the API.
## NOTES
Related commands:
Get-AtwsInstalledProduct
 Set-AtwsInstalledProduct

## RELATED LINKS
