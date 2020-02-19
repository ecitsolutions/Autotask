#Requires -Version 4.0
#Version 1.6.5
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsInstalledProduct
{


<#
.SYNOPSIS
This function get one or more InstalledProduct through the Autotask Web Services API.
.DESCRIPTION
This function creates a query based on any parameters you give and returns any resulting objects from the Autotask Web Services Api. By default the function returns any objects with properties that are Equal (-eq) to the value of the parameter. To give you more flexibility you can modify the operator by using -NotEquals [ParameterName[]], -LessThan [ParameterName[]] and so on.

Possible operators for all parameters are:
 -NotEquals
 -GreaterThan
 -GreaterThanOrEqual
 -LessThan
 -LessThanOrEquals 

Additional operators for [string] parameters are:
 -Like (supports * or % as wildcards)
 -NotLike
 -BeginsWith
 -EndsWith
 -Contains

Properties with picklists are:

Type
 

ServiceLevelAgreementID
 

RMMDeviceAuditArchitectureID
 

RMMDeviceAuditDisplayAdaptorID
 

RMMDeviceAuditDomainID
 

RMMDeviceAuditManufacturerID
 

RMMDeviceAuditModelID
 

RMMDeviceAuditMotherboardID
 

RMMDeviceAuditProcessorID
 

RMMDeviceAuditServicePackID
 

RMMDeviceAuditDeviceTypeID
 

RMMDeviceAuditMobileNetworkOperatorID
 

DattoOSVersionID
 

DattoZFSVersionID
 

DattoKernelVersionID
 

RMMDeviceAuditAntivirusStatusID
 

RMMDeviceAuditBackupStatusID
 

RMMDeviceAuditPatchStatusID
 

RMMDeviceAuditSoftwareStatusID
 

LastActivityPersonType
 

ApiVendorID
 

Entities that have fields that refer to the base entity of this CmdLet:

BillingItem
 InstalledProduct
 InstalledProductBillingProductAssociation
 InstalledProductNote
 Subscription
 Ticket
 TicketAdditionalInstalledProduct

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.InstalledProduct[]]. This function outputs the Autotask.InstalledProduct that was returned by the API.
.EXAMPLE
Get-AtwsInstalledProduct -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsInstalledProduct -InstalledProductName SomeName
Returns the object with InstalledProductName 'SomeName', if any.
 .EXAMPLE
Get-AtwsInstalledProduct -InstalledProductName 'Some Name'
Returns the object with InstalledProductName 'Some Name', if any.
 .EXAMPLE
Get-AtwsInstalledProduct -InstalledProductName 'Some Name' -NotEquals InstalledProductName
Returns any objects with a InstalledProductName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsInstalledProduct -InstalledProductName SomeName* -Like InstalledProductName
Returns any object with a InstalledProductName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsInstalledProduct -InstalledProductName SomeName* -NotLike InstalledProductName
Returns any object with a InstalledProductName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsInstalledProduct -Type <PickList Label>
Returns any InstalledProducts with property Type equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsInstalledProduct -Type <PickList Label> -NotEquals Type 
Returns any InstalledProducts with property Type NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsInstalledProduct -Type <PickList Label1>, <PickList Label2>
Returns any InstalledProducts with property Type equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsInstalledProduct -Type <PickList Label1>, <PickList Label2> -NotEquals Type
Returns any InstalledProducts with property Type NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsInstalledProduct -Id 1234 -InstalledProductName SomeName* -Type <PickList Label1>, <PickList Label2> -Like InstalledProductName -NotEquals Type -GreaterThan Id
An example of a more complex query. This command returns any InstalledProducts with Id GREATER THAN 1234, a InstalledProductName that matches the simple pattern SomeName* AND that has a Type that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsInstalledProduct
 .LINK
Set-AtwsInstalledProduct

#>

  [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName='Filter', ConfirmImpact='None')]
  Param
  (
# A filter that limits the number of objects that is returned from the API
    [Parameter(
      Mandatory = $true,
      ValueFromRemainingArguments = $true,
      ParametersetName = 'Filter'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Filter,

# Follow this external ID and return any external objects
    [Parameter(
      ParametersetName = 'Filter'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('GetRef')]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('AccountID', 'AccountPhysicalLocationID', 'ContactID', 'ContractID', 'ContractServiceBundleID', 'ContractServiceID', 'CreatedByPersonID', 'InstalledByContactID', 'InstalledByID', 'LastActivityPersonID', 'ParentInstalledProductID', 'ProductID', 'ServiceBundleID', 'ServiceID', 'VendorID')]
    [string]
    $GetReferenceEntityById,

# Return entities of selected type that are referencing to this entity.
    [Parameter(
      ParametersetName = 'Filter'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('External')]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('BillingItem:InstalledProductID', 'InstalledProduct:ParentInstalledProductID', 'InstalledProductBillingProductAssociation:InstalledProductID', 'InstalledProductNote:InstalledProductID', 'Subscription:InstalledProductID', 'Ticket:InstalledProductID', 'TicketAdditionalInstalledProduct:InstalledProductID')]
    [string]
    $GetExternalEntityByThisEntityId,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# A single user defined field can be used pr query
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('UDF')]
    [ValidateNotNullOrEmpty()]
    [Autotask.UserDefinedField]
    $UserDefinedField,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CreateDate,

# Client
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $AccountID,

# Product Active
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $Active,

# Configuration Item Daily Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $DailyCost,

# Configuration Item Hourly Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $HourlyCost,

# Configuration Item ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Install Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $InstallDate,

# Configuration Item Monthly Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $MonthlyCost,

# Configuration Item Notes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,5000)]
    [string[]]
    $Notes,

# Configuration Item Number of Users
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $NumberOfUsers,

# Configuration Item Per Use Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $PerUseCost,

# Product ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $ProductID,

# Reference Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $ReferenceNumber,

# Reference Title
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,200)]
    [string[]]
    $ReferenceTitle,

# Serial Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $SerialNumber,

# Configuration Item Setup Fee
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $SetupFee,

# Warranty Expiration Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $WarrantyExpirationDate,

# Contract ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ContractID,

# Service ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ServiceID,

# Service Bundle ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ServiceBundleID,

# Configuration Item Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $Type,

# Location
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $Location,

# Contact Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ContactID,

# Vendor Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $VendorID,

# Installed By Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $InstalledByID,

# Installed By Contact ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $InstalledByContactID,

# Parent Configuration Item
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ParentInstalledProductID,

# Last Modified Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LastModifiedTime,

# Contract Service Id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ContractServiceID,

# Contract Service Bundle Id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ContractServiceBundleID,

# Service Level Agreement
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $ServiceLevelAgreementID,

# Account Physical Location
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $AccountPhysicalLocationID,

# RMM Device ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $RMMDeviceID,

# RMM Device UID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string[]]
    $RMMDeviceUID,

# RMM Device Audit Architecture ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $RMMDeviceAuditArchitectureID,

# RMM Device Audit Display Adaptor ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $RMMDeviceAuditDisplayAdaptorID,

# RMM Device Audit Domain ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $RMMDeviceAuditDomainID,

# RMM Device Audit External IP Address
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string[]]
    $RMMDeviceAuditExternalIPAddress,

# RMM Device Audit Hostname
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string[]]
    $RMMDeviceAuditHostname,

# RMM Device Audit IP Address
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string[]]
    $RMMDeviceAuditIPAddress,

# RMM Device Audit Mac Address
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string[]]
    $RMMDeviceAuditMacAddress,

# RMM Device Audit Manufacturer ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $RMMDeviceAuditManufacturerID,

# RMM Device Audit Memory Bytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $RMMDeviceAuditMemoryBytes,

# RMM Device Audit Model ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $RMMDeviceAuditModelID,

# RMM Device Audit Motherboard ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $RMMDeviceAuditMotherboardID,

# RMM Device Audit Processor ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $RMMDeviceAuditProcessorID,

# RMM Device Audit Service Pack ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $RMMDeviceAuditServicePackID,

# RMM Device Audit Storage Bytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $RMMDeviceAuditStorageBytes,

# RMM Device Audit Device Type ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $RMMDeviceAuditDeviceTypeID,

# RMM Device Audit SNMP Location
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string[]]
    $RMMDeviceAuditSNMPLocation,

# RMM Device Audit SNMP Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string[]]
    $RMMDeviceAuditSNMPName,

# RMM Device Audit SNMP Contact
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string[]]
    $RMMDeviceAuditSNMPContact,

# RMM Device Audit Mobile Network Operator ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $RMMDeviceAuditMobileNetworkOperatorID,

# RMM Device Audit Mobile Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string[]]
    $RMMDeviceAuditMobileNumber,

# RMM Device Audit Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string[]]
    $RMMDeviceAuditDescription,

# RMM Open Alert Count
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $RMMOpenAlertCount,

# RMM Device Audit Last User
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string[]]
    $RMMDeviceAuditLastUser,

# RMM Device Audit Missing Patch Count
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $RMMDeviceAuditMissingPatchCount,

# Datto Serial Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $DattoSerialNumber,

# Datto Internal IP
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string[]]
    $DattoInternalIP,

# Datto Remote IP
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string[]]
    $DattoRemoteIP,

# Datto Hostname
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string[]]
    $DattoHostname,

# Datto Protected Kilobytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $DattoProtectedKilobytes,

# Datto Used Kilobytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $DattoUsedKilobytes,

# Datto Available Kilobytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $DattoAvailableKilobytes,

# Datto Percentage Used
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $DattoPercentageUsed,

# Datto Offsite Used Bytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $DattoOffsiteUsedBytes,

# Datto OS Version ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $DattoOSVersionID,

# Datto ZFS Version ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $DattoZFSVersionID,

# Datto Kernel Version ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $DattoKernelVersionID,

# Datto NIC Speed Kilobits Per Second
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $DattoNICSpeedKilobitsPerSecond,

# Datto Device Memory Megabytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $DattoDeviceMemoryMegabytes,

# Datto Uptime Seconds
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $DattoUptimeSeconds,

# Datto Number Of Agents
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $DattoNumberOfAgents,

# Datto Number Of Drives
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $DattoNumberOfDrives,

# Datto Drives Errors
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $DattoDrivesErrors,

# Datto Number Of Volumes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $DattoNumberOfVolumes,

# Datto Last Check In Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $DattoLastCheckInDateTime,

# RMM Device Audit Antivirus Status ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $RMMDeviceAuditAntivirusStatusID,

# RMM Device Audit Backup Status ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $RMMDeviceAuditBackupStatusID,

# RMM Device Audit Patch Status ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $RMMDeviceAuditPatchStatusID,

# RMM Device Audit Software Status ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $RMMDeviceAuditSoftwareStatusID,

# Last Activity Person ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $LastActivityPersonID,

# Created By Person ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CreatedByPersonID,

# API Vendor ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $ApiVendorID,

# Device Networking ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $DeviceNetworkingID,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'AccountID', 'Active', 'DailyCost', 'HourlyCost', 'id', 'InstallDate', 'MonthlyCost', 'Notes', 'NumberOfUsers', 'PerUseCost', 'ProductID', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'SetupFee', 'WarrantyExpirationDate', 'ContractID', 'ServiceID', 'ServiceBundleID', 'Type', 'Location', 'ContactID', 'VendorID', 'InstalledByID', 'InstalledByContactID', 'ParentInstalledProductID', 'LastModifiedTime', 'ContractServiceID', 'ContractServiceBundleID', 'ServiceLevelAgreementID', 'AccountPhysicalLocationID', 'RMMDeviceID', 'RMMDeviceUID', 'RMMDeviceAuditArchitectureID', 'RMMDeviceAuditDisplayAdaptorID', 'RMMDeviceAuditDomainID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditManufacturerID', 'RMMDeviceAuditMemoryBytes', 'RMMDeviceAuditModelID', 'RMMDeviceAuditMotherboardID', 'RMMDeviceAuditProcessorID', 'RMMDeviceAuditServicePackID', 'RMMDeviceAuditStorageBytes', 'RMMDeviceAuditDeviceTypeID', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNetworkOperatorID', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMOpenAlertCount', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMissingPatchCount', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'DattoProtectedKilobytes', 'DattoUsedKilobytes', 'DattoAvailableKilobytes', 'DattoPercentageUsed', 'DattoOffsiteUsedBytes', 'DattoOSVersionID', 'DattoZFSVersionID', 'DattoKernelVersionID', 'DattoNICSpeedKilobitsPerSecond', 'DattoDeviceMemoryMegabytes', 'DattoUptimeSeconds', 'DattoNumberOfAgents', 'DattoNumberOfDrives', 'DattoDrivesErrors', 'DattoNumberOfVolumes', 'DattoLastCheckInDateTime', 'RMMDeviceAuditAntivirusStatusID', 'RMMDeviceAuditBackupStatusID', 'RMMDeviceAuditPatchStatusID', 'RMMDeviceAuditSoftwareStatusID', 'LastActivityPersonID', 'CreatedByPersonID', 'ApiVendorID', 'DeviceNetworkingID', 'UserDefinedField')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'AccountID', 'Active', 'DailyCost', 'HourlyCost', 'id', 'InstallDate', 'MonthlyCost', 'Notes', 'NumberOfUsers', 'PerUseCost', 'ProductID', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'SetupFee', 'WarrantyExpirationDate', 'ContractID', 'ServiceID', 'ServiceBundleID', 'Type', 'Location', 'ContactID', 'VendorID', 'InstalledByID', 'InstalledByContactID', 'ParentInstalledProductID', 'LastModifiedTime', 'ContractServiceID', 'ContractServiceBundleID', 'ServiceLevelAgreementID', 'AccountPhysicalLocationID', 'RMMDeviceID', 'RMMDeviceUID', 'RMMDeviceAuditArchitectureID', 'RMMDeviceAuditDisplayAdaptorID', 'RMMDeviceAuditDomainID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditManufacturerID', 'RMMDeviceAuditMemoryBytes', 'RMMDeviceAuditModelID', 'RMMDeviceAuditMotherboardID', 'RMMDeviceAuditProcessorID', 'RMMDeviceAuditServicePackID', 'RMMDeviceAuditStorageBytes', 'RMMDeviceAuditDeviceTypeID', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNetworkOperatorID', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMOpenAlertCount', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMissingPatchCount', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'DattoProtectedKilobytes', 'DattoUsedKilobytes', 'DattoAvailableKilobytes', 'DattoPercentageUsed', 'DattoOffsiteUsedBytes', 'DattoOSVersionID', 'DattoZFSVersionID', 'DattoKernelVersionID', 'DattoNICSpeedKilobitsPerSecond', 'DattoDeviceMemoryMegabytes', 'DattoUptimeSeconds', 'DattoNumberOfAgents', 'DattoNumberOfDrives', 'DattoDrivesErrors', 'DattoNumberOfVolumes', 'DattoLastCheckInDateTime', 'RMMDeviceAuditAntivirusStatusID', 'RMMDeviceAuditBackupStatusID', 'RMMDeviceAuditPatchStatusID', 'RMMDeviceAuditSoftwareStatusID', 'LastActivityPersonID', 'CreatedByPersonID', 'ApiVendorID', 'DeviceNetworkingID', 'UserDefinedField')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'AccountID', 'Active', 'DailyCost', 'HourlyCost', 'id', 'InstallDate', 'MonthlyCost', 'Notes', 'NumberOfUsers', 'PerUseCost', 'ProductID', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'SetupFee', 'WarrantyExpirationDate', 'ContractID', 'ServiceID', 'ServiceBundleID', 'Type', 'Location', 'ContactID', 'VendorID', 'InstalledByID', 'InstalledByContactID', 'ParentInstalledProductID', 'LastModifiedTime', 'ContractServiceID', 'ContractServiceBundleID', 'ServiceLevelAgreementID', 'AccountPhysicalLocationID', 'RMMDeviceID', 'RMMDeviceUID', 'RMMDeviceAuditArchitectureID', 'RMMDeviceAuditDisplayAdaptorID', 'RMMDeviceAuditDomainID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditManufacturerID', 'RMMDeviceAuditMemoryBytes', 'RMMDeviceAuditModelID', 'RMMDeviceAuditMotherboardID', 'RMMDeviceAuditProcessorID', 'RMMDeviceAuditServicePackID', 'RMMDeviceAuditStorageBytes', 'RMMDeviceAuditDeviceTypeID', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNetworkOperatorID', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMOpenAlertCount', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMissingPatchCount', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'DattoProtectedKilobytes', 'DattoUsedKilobytes', 'DattoAvailableKilobytes', 'DattoPercentageUsed', 'DattoOffsiteUsedBytes', 'DattoOSVersionID', 'DattoZFSVersionID', 'DattoKernelVersionID', 'DattoNICSpeedKilobitsPerSecond', 'DattoDeviceMemoryMegabytes', 'DattoUptimeSeconds', 'DattoNumberOfAgents', 'DattoNumberOfDrives', 'DattoDrivesErrors', 'DattoNumberOfVolumes', 'DattoLastCheckInDateTime', 'RMMDeviceAuditAntivirusStatusID', 'RMMDeviceAuditBackupStatusID', 'RMMDeviceAuditPatchStatusID', 'RMMDeviceAuditSoftwareStatusID', 'LastActivityPersonID', 'CreatedByPersonID', 'ApiVendorID', 'DeviceNetworkingID', 'UserDefinedField')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'AccountID', 'DailyCost', 'HourlyCost', 'id', 'InstallDate', 'MonthlyCost', 'Notes', 'NumberOfUsers', 'PerUseCost', 'ProductID', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'SetupFee', 'WarrantyExpirationDate', 'ContractID', 'ServiceID', 'ServiceBundleID', 'Type', 'Location', 'ContactID', 'VendorID', 'InstalledByID', 'InstalledByContactID', 'ParentInstalledProductID', 'LastModifiedTime', 'ContractServiceID', 'ContractServiceBundleID', 'ServiceLevelAgreementID', 'AccountPhysicalLocationID', 'RMMDeviceID', 'RMMDeviceUID', 'RMMDeviceAuditArchitectureID', 'RMMDeviceAuditDisplayAdaptorID', 'RMMDeviceAuditDomainID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditManufacturerID', 'RMMDeviceAuditMemoryBytes', 'RMMDeviceAuditModelID', 'RMMDeviceAuditMotherboardID', 'RMMDeviceAuditProcessorID', 'RMMDeviceAuditServicePackID', 'RMMDeviceAuditStorageBytes', 'RMMDeviceAuditDeviceTypeID', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNetworkOperatorID', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMOpenAlertCount', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMissingPatchCount', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'DattoProtectedKilobytes', 'DattoUsedKilobytes', 'DattoAvailableKilobytes', 'DattoPercentageUsed', 'DattoOffsiteUsedBytes', 'DattoOSVersionID', 'DattoZFSVersionID', 'DattoKernelVersionID', 'DattoNICSpeedKilobitsPerSecond', 'DattoDeviceMemoryMegabytes', 'DattoUptimeSeconds', 'DattoNumberOfAgents', 'DattoNumberOfDrives', 'DattoNumberOfVolumes', 'DattoLastCheckInDateTime', 'RMMDeviceAuditAntivirusStatusID', 'RMMDeviceAuditBackupStatusID', 'RMMDeviceAuditPatchStatusID', 'RMMDeviceAuditSoftwareStatusID', 'LastActivityPersonID', 'CreatedByPersonID', 'ApiVendorID', 'DeviceNetworkingID', 'UserDefinedField')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'AccountID', 'DailyCost', 'HourlyCost', 'id', 'InstallDate', 'MonthlyCost', 'Notes', 'NumberOfUsers', 'PerUseCost', 'ProductID', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'SetupFee', 'WarrantyExpirationDate', 'ContractID', 'ServiceID', 'ServiceBundleID', 'Type', 'Location', 'ContactID', 'VendorID', 'InstalledByID', 'InstalledByContactID', 'ParentInstalledProductID', 'LastModifiedTime', 'ContractServiceID', 'ContractServiceBundleID', 'ServiceLevelAgreementID', 'AccountPhysicalLocationID', 'RMMDeviceID', 'RMMDeviceUID', 'RMMDeviceAuditArchitectureID', 'RMMDeviceAuditDisplayAdaptorID', 'RMMDeviceAuditDomainID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditManufacturerID', 'RMMDeviceAuditMemoryBytes', 'RMMDeviceAuditModelID', 'RMMDeviceAuditMotherboardID', 'RMMDeviceAuditProcessorID', 'RMMDeviceAuditServicePackID', 'RMMDeviceAuditStorageBytes', 'RMMDeviceAuditDeviceTypeID', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNetworkOperatorID', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMOpenAlertCount', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMissingPatchCount', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'DattoProtectedKilobytes', 'DattoUsedKilobytes', 'DattoAvailableKilobytes', 'DattoPercentageUsed', 'DattoOffsiteUsedBytes', 'DattoOSVersionID', 'DattoZFSVersionID', 'DattoKernelVersionID', 'DattoNICSpeedKilobitsPerSecond', 'DattoDeviceMemoryMegabytes', 'DattoUptimeSeconds', 'DattoNumberOfAgents', 'DattoNumberOfDrives', 'DattoNumberOfVolumes', 'DattoLastCheckInDateTime', 'RMMDeviceAuditAntivirusStatusID', 'RMMDeviceAuditBackupStatusID', 'RMMDeviceAuditPatchStatusID', 'RMMDeviceAuditSoftwareStatusID', 'LastActivityPersonID', 'CreatedByPersonID', 'ApiVendorID', 'DeviceNetworkingID', 'UserDefinedField')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'AccountID', 'DailyCost', 'HourlyCost', 'id', 'InstallDate', 'MonthlyCost', 'Notes', 'NumberOfUsers', 'PerUseCost', 'ProductID', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'SetupFee', 'WarrantyExpirationDate', 'ContractID', 'ServiceID', 'ServiceBundleID', 'Type', 'Location', 'ContactID', 'VendorID', 'InstalledByID', 'InstalledByContactID', 'ParentInstalledProductID', 'LastModifiedTime', 'ContractServiceID', 'ContractServiceBundleID', 'ServiceLevelAgreementID', 'AccountPhysicalLocationID', 'RMMDeviceID', 'RMMDeviceUID', 'RMMDeviceAuditArchitectureID', 'RMMDeviceAuditDisplayAdaptorID', 'RMMDeviceAuditDomainID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditManufacturerID', 'RMMDeviceAuditMemoryBytes', 'RMMDeviceAuditModelID', 'RMMDeviceAuditMotherboardID', 'RMMDeviceAuditProcessorID', 'RMMDeviceAuditServicePackID', 'RMMDeviceAuditStorageBytes', 'RMMDeviceAuditDeviceTypeID', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNetworkOperatorID', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMOpenAlertCount', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMissingPatchCount', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'DattoProtectedKilobytes', 'DattoUsedKilobytes', 'DattoAvailableKilobytes', 'DattoPercentageUsed', 'DattoOffsiteUsedBytes', 'DattoOSVersionID', 'DattoZFSVersionID', 'DattoKernelVersionID', 'DattoNICSpeedKilobitsPerSecond', 'DattoDeviceMemoryMegabytes', 'DattoUptimeSeconds', 'DattoNumberOfAgents', 'DattoNumberOfDrives', 'DattoNumberOfVolumes', 'DattoLastCheckInDateTime', 'RMMDeviceAuditAntivirusStatusID', 'RMMDeviceAuditBackupStatusID', 'RMMDeviceAuditPatchStatusID', 'RMMDeviceAuditSoftwareStatusID', 'LastActivityPersonID', 'CreatedByPersonID', 'ApiVendorID', 'DeviceNetworkingID', 'UserDefinedField')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'AccountID', 'DailyCost', 'HourlyCost', 'id', 'InstallDate', 'MonthlyCost', 'Notes', 'NumberOfUsers', 'PerUseCost', 'ProductID', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'SetupFee', 'WarrantyExpirationDate', 'ContractID', 'ServiceID', 'ServiceBundleID', 'Type', 'Location', 'ContactID', 'VendorID', 'InstalledByID', 'InstalledByContactID', 'ParentInstalledProductID', 'LastModifiedTime', 'ContractServiceID', 'ContractServiceBundleID', 'ServiceLevelAgreementID', 'AccountPhysicalLocationID', 'RMMDeviceID', 'RMMDeviceUID', 'RMMDeviceAuditArchitectureID', 'RMMDeviceAuditDisplayAdaptorID', 'RMMDeviceAuditDomainID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditManufacturerID', 'RMMDeviceAuditMemoryBytes', 'RMMDeviceAuditModelID', 'RMMDeviceAuditMotherboardID', 'RMMDeviceAuditProcessorID', 'RMMDeviceAuditServicePackID', 'RMMDeviceAuditStorageBytes', 'RMMDeviceAuditDeviceTypeID', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNetworkOperatorID', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMOpenAlertCount', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMissingPatchCount', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'DattoProtectedKilobytes', 'DattoUsedKilobytes', 'DattoAvailableKilobytes', 'DattoPercentageUsed', 'DattoOffsiteUsedBytes', 'DattoOSVersionID', 'DattoZFSVersionID', 'DattoKernelVersionID', 'DattoNICSpeedKilobitsPerSecond', 'DattoDeviceMemoryMegabytes', 'DattoUptimeSeconds', 'DattoNumberOfAgents', 'DattoNumberOfDrives', 'DattoNumberOfVolumes', 'DattoLastCheckInDateTime', 'RMMDeviceAuditAntivirusStatusID', 'RMMDeviceAuditBackupStatusID', 'RMMDeviceAuditPatchStatusID', 'RMMDeviceAuditSoftwareStatusID', 'LastActivityPersonID', 'CreatedByPersonID', 'ApiVendorID', 'DeviceNetworkingID', 'UserDefinedField')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Notes', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'Location', 'RMMDeviceUID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMDeviceAuditLastUser', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'DeviceNetworkingID', 'UserDefinedField')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Notes', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'Location', 'RMMDeviceUID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMDeviceAuditLastUser', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'DeviceNetworkingID', 'UserDefinedField')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Notes', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'Location', 'RMMDeviceUID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMDeviceAuditLastUser', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'DeviceNetworkingID', 'UserDefinedField')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Notes', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'Location', 'RMMDeviceUID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMDeviceAuditLastUser', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'DeviceNetworkingID', 'UserDefinedField')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Notes', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'Location', 'RMMDeviceUID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMDeviceAuditLastUser', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'DeviceNetworkingID', 'UserDefinedField')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'InstallDate', 'WarrantyExpirationDate', 'LastModifiedTime', 'DattoLastCheckInDateTime', 'UserDefinedField')]
    [string[]]
    $IsThisDay
  )

    begin { 
        $entityName = 'InstalledProduct'
    
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {
            $DebugPreference = 'Continue' 
        }
        else {
            # Respect configured preference
            $DebugPreference = $Script:Atws.Configuration.DebugPref
        }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

        if (!($PSCmdlet.MyInvocation.BoundParameters['Verbose'].IsPresent)) {
            # No local override of central preference. Load central preference
            $VerbosePreference = $Script:Atws.Configuration.VerbosePref
        }
    
    }


    process {
        # Parameterset Get_All has a single parameter: -All
        # Set the Filter manually to get every single object of this type 
        if ($PSCmdlet.ParameterSetName -eq 'Get_all') { 
            $Filter = @('id', '-ge', 0)
        }
        # So it is not -All. If Filter does not exist it has to be By_parameters
        elseif (-not ($Filter)) {
    
            Write-Debug ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)
      
            # Convert named parameters to a filter definition that can be parsed to QueryXML
            [string[]]$Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $entityName
        }
        # Not parameters, nor Get_all. There are only three parameter sets, so now we know
        # that we were passed a Filter
        else {
      
            Write-Debug ('{0}: Query based on manual filter, parsing' -F $MyInvocation.MyCommand.Name)
            
            # Parse the filter string and expand variables in _this_ scope (dot-sourcing)
            # or the variables will not be available and expansion will fail
            $Filter = . Update-AtwsFilter -Filterstring $Filter
        } 

        # Prepare shouldProcess comments
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to query the Autotask Web API for {1}(s).' -F $caption, $entityName
        $verboseWarning = '{0}: About to query the Autotask Web API for {1}(s). Do you want to continue?' -F $caption, $entityName
    
        # Lets do it and say we didn't!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
    
            # Make the query and pass the optional parameters to Get-AtwsData
            $result = Get-AtwsData -Entity $entityName -Filter $Filter `
                -NoPickListLabel:$NoPickListLabel.IsPresent `
                -GetReferenceEntityById $GetReferenceEntityById `
                -GetExternalEntityByThisEntityId $GetExternalEntityByThisEntityId
    
            Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $result.Count)

        }
    }

    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        if ($result) {
            Return $result
        }
    }


}
