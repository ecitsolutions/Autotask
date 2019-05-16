#Requires -Version 4.0
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

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

Additional operators for [String] parameters are:
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
 

Entities that have fields that refer to the base entity of this CmdLet:

BillingItem
 InstalledProduct
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

  [CmdLetBinding(DefaultParameterSetName='Filter', ConfirmImpact='None')]
  Param
  (
# A filter that limits the number of objects that is returned from the API
    [Parameter(
      Mandatory = $true,
      ValueFromRemainingArguments = $true,
      ParameterSetName = 'Filter'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $Filter,

# Follow this external ID and return any external objects
    [Parameter(
      ParameterSetName = 'Filter'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Alias('GetRef')]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('AccountID', 'ProductID', 'ContractID', 'ServiceID', 'ServiceBundleID', 'ContactID', 'VendorID', 'InstalledByID', 'InstalledByContactID', 'ParentInstalledProductID', 'ContractServiceID', 'ContractServiceBundleID', 'AccountPhysicalLocationID', 'LastActivityPersonID')]
    [String]
    $GetReferenceEntityById,

# Return entities of selected type that are referencing to this entity.
    [Parameter(
      ParameterSetName = 'Filter'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Alias('External')]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('InstalledProduct:ParentInstalledProductID', 'Ticket:InstalledProductID', 'Subscription:InstalledProductID', 'BillingItem:InstalledProductID', 'TicketAdditionalInstalledProduct:InstalledProductID')]
    [String]
    $GetExternalEntityByThisEntityId,

# Return all objects in one query
    [Parameter(
      ParameterSetName = 'Get_all'
    )]
    [Switch]
    $All,

# Do not add descriptions for all picklist attributes with values
    [Parameter(
      ParameterSetName = 'Filter'
    )]
    [Parameter(
      ParameterSetName = 'Get_all'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Switch]
    $NoPickListLabel,

# A single user defined field can be used pr query
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Alias('UDF')]
    [ValidateNotNullOrEmpty()]
    [Autotask.UserDefinedField]
    $UserDefinedField,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime[]]
    $CreateDate,

# Client
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int[]]
    $AccountID,

# Product Active
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [boolean[]]
    $Active,

# Configuration Item Daily Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double[]]
    $DailyCost,

# Configuration Item Hourly Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double[]]
    $HourlyCost,

# Configuration Item ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [long[]]
    $id,

# Install Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime[]]
    $InstallDate,

# Configuration Item Monthly Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double[]]
    $MonthlyCost,

# Configuration Item Notes
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,5000)]
    [string[]]
    $Notes,

# Configuration Item Number of Users
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double[]]
    $NumberOfUsers,

# Configuration Item Per Use Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double[]]
    $PerUseCost,

# Product ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int[]]
    $ProductID,

# Reference Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string[]]
    $ReferenceNumber,

# Reference Title
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,200)]
    [string[]]
    $ReferenceTitle,

# Serial Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,100)]
    [string[]]
    $SerialNumber,

# Configuration Item Setup Fee
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double[]]
    $SetupFee,

# Warranty Expiration Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime[]]
    $WarrantyExpirationDate,

# Contract ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $ContractID,

# Service ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $ServiceID,

# Service Bundle ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $ServiceBundleID,

# Configuration Item Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $Type,

# Location
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,100)]
    [string[]]
    $Location,

# Contact Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $ContactID,

# Vendor Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $VendorID,

# Installed By Resource ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $InstalledByID,

# Installed By Contact ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $InstalledByContactID,

# Parent Configuration Item
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $ParentInstalledProductID,

# Last Modified Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime[]]
    $LastModifiedTime,

# Contract Service Id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $ContractServiceID,

# Contract Service Bundle Id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $ContractServiceBundleID,

# Service Level Agreement
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $ServiceLevelAgreementID,

# Account Physical Location
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $AccountPhysicalLocationID,

# RMM Device ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long[]]
    $RMMDeviceID,

# RMM Device UID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string[]]
    $RMMDeviceUID,

# RMM Device Audit Architecture ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $RMMDeviceAuditArchitectureID,

# RMM Device Audit Display Adaptor ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $RMMDeviceAuditDisplayAdaptorID,

# RMM Device Audit Domain ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $RMMDeviceAuditDomainID,

# RMM Device Audit External IP Address
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string[]]
    $RMMDeviceAuditExternalIPAddress,

# RMM Device Audit Hostname
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string[]]
    $RMMDeviceAuditHostname,

# RMM Device Audit IP Address
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string[]]
    $RMMDeviceAuditIPAddress,

# RMM Device Audit Mac Address
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string[]]
    $RMMDeviceAuditMacAddress,

# RMM Device Audit Manufacturer ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $RMMDeviceAuditManufacturerID,

# RMM Device Audit Memory Bytes
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long[]]
    $RMMDeviceAuditMemoryBytes,

# RMM Device Audit Model ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $RMMDeviceAuditModelID,

# RMM Device Audit Motherboard ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $RMMDeviceAuditMotherboardID,

# RMM Device Audit Processor ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $RMMDeviceAuditProcessorID,

# RMM Device Audit Service Pack ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $RMMDeviceAuditServicePackID,

# RMM Device Audit Storage Bytes
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long[]]
    $RMMDeviceAuditStorageBytes,

# RMM Device Audit Device Type ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $RMMDeviceAuditDeviceTypeID,

# RMM Device Audit SNMP Location
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string[]]
    $RMMDeviceAuditSNMPLocation,

# RMM Device Audit SNMP Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string[]]
    $RMMDeviceAuditSNMPName,

# RMM Device Audit SNMP Contact
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string[]]
    $RMMDeviceAuditSNMPContact,

# RMM Device Audit Mobile Network Operator ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $RMMDeviceAuditMobileNetworkOperatorID,

# RMM Device Audit Mobile Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string[]]
    $RMMDeviceAuditMobileNumber,

# RMM Device Audit Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string[]]
    $RMMDeviceAuditDescription,

# RMM Open Alert Count
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $RMMOpenAlertCount,

# RMM Device Audit Last User
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string[]]
    $RMMDeviceAuditLastUser,

# RMM Device Audit Missing Patch Count
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $RMMDeviceAuditMissingPatchCount,

# Datto Serial Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,100)]
    [string[]]
    $DattoSerialNumber,

# Datto Internal IP
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string[]]
    $DattoInternalIP,

# Datto Remote IP
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string[]]
    $DattoRemoteIP,

# Datto Hostname
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string[]]
    $DattoHostname,

# Datto Protected Kilobytes
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long[]]
    $DattoProtectedKilobytes,

# Datto Used Kilobytes
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long[]]
    $DattoUsedKilobytes,

# Datto Available Kilobytes
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long[]]
    $DattoAvailableKilobytes,

# Datto Percentage Used
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double[]]
    $DattoPercentageUsed,

# Datto Offsite Used Bytes
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long[]]
    $DattoOffsiteUsedBytes,

# Datto OS Version ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $DattoOSVersionID,

# Datto ZFS Version ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $DattoZFSVersionID,

# Datto Kernel Version ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $DattoKernelVersionID,

# Datto NIC Speed Kilobits Per Second
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $DattoNICSpeedKilobitsPerSecond,

# Datto Device Memory Megabytes
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $DattoDeviceMemoryMegabytes,

# Datto Uptime Seconds
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $DattoUptimeSeconds,

# Datto Number Of Agents
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $DattoNumberOfAgents,

# Datto Number Of Drives
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $DattoNumberOfDrives,

# Datto Drives Errors
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean[]]
    $DattoDrivesErrors,

# Datto Number Of Volumes
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $DattoNumberOfVolumes,

# Datto Last Check In Date Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime[]]
    $DattoLastCheckInDateTime,

# RMM Device Audit Antivirus Status ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $RMMDeviceAuditAntivirusStatusID,

# RMM Device Audit Backup Status ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $RMMDeviceAuditBackupStatusID,

# RMM Device Audit Patch Status ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $RMMDeviceAuditPatchStatusID,

# RMM Device Audit Software Status ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $RMMDeviceAuditSoftwareStatusID,

# Last Activity Person ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int[]]
    $LastActivityPersonID,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'AccountID', 'Active', 'DailyCost', 'HourlyCost', 'id', 'InstallDate', 'MonthlyCost', 'Notes', 'NumberOfUsers', 'PerUseCost', 'ProductID', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'SetupFee', 'WarrantyExpirationDate', 'ContractID', 'ServiceID', 'ServiceBundleID', 'Type', 'Location', 'ContactID', 'VendorID', 'InstalledByID', 'InstalledByContactID', 'ParentInstalledProductID', 'LastModifiedTime', 'ContractServiceID', 'ContractServiceBundleID', 'ServiceLevelAgreementID', 'AccountPhysicalLocationID', 'RMMDeviceID', 'RMMDeviceUID', 'RMMDeviceAuditArchitectureID', 'RMMDeviceAuditDisplayAdaptorID', 'RMMDeviceAuditDomainID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditManufacturerID', 'RMMDeviceAuditMemoryBytes', 'RMMDeviceAuditModelID', 'RMMDeviceAuditMotherboardID', 'RMMDeviceAuditProcessorID', 'RMMDeviceAuditServicePackID', 'RMMDeviceAuditStorageBytes', 'RMMDeviceAuditDeviceTypeID', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNetworkOperatorID', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMOpenAlertCount', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMissingPatchCount', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'DattoProtectedKilobytes', 'DattoUsedKilobytes', 'DattoAvailableKilobytes', 'DattoPercentageUsed', 'DattoOffsiteUsedBytes', 'DattoOSVersionID', 'DattoZFSVersionID', 'DattoKernelVersionID', 'DattoNICSpeedKilobitsPerSecond', 'DattoDeviceMemoryMegabytes', 'DattoUptimeSeconds', 'DattoNumberOfAgents', 'DattoNumberOfDrives', 'DattoDrivesErrors', 'DattoNumberOfVolumes', 'DattoLastCheckInDateTime', 'RMMDeviceAuditAntivirusStatusID', 'RMMDeviceAuditBackupStatusID', 'RMMDeviceAuditPatchStatusID', 'RMMDeviceAuditSoftwareStatusID', 'LastActivityPersonID', 'UserDefinedField')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'AccountID', 'Active', 'DailyCost', 'HourlyCost', 'id', 'InstallDate', 'MonthlyCost', 'Notes', 'NumberOfUsers', 'PerUseCost', 'ProductID', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'SetupFee', 'WarrantyExpirationDate', 'ContractID', 'ServiceID', 'ServiceBundleID', 'Type', 'Location', 'ContactID', 'VendorID', 'InstalledByID', 'InstalledByContactID', 'ParentInstalledProductID', 'LastModifiedTime', 'ContractServiceID', 'ContractServiceBundleID', 'ServiceLevelAgreementID', 'AccountPhysicalLocationID', 'RMMDeviceID', 'RMMDeviceUID', 'RMMDeviceAuditArchitectureID', 'RMMDeviceAuditDisplayAdaptorID', 'RMMDeviceAuditDomainID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditManufacturerID', 'RMMDeviceAuditMemoryBytes', 'RMMDeviceAuditModelID', 'RMMDeviceAuditMotherboardID', 'RMMDeviceAuditProcessorID', 'RMMDeviceAuditServicePackID', 'RMMDeviceAuditStorageBytes', 'RMMDeviceAuditDeviceTypeID', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNetworkOperatorID', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMOpenAlertCount', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMissingPatchCount', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'DattoProtectedKilobytes', 'DattoUsedKilobytes', 'DattoAvailableKilobytes', 'DattoPercentageUsed', 'DattoOffsiteUsedBytes', 'DattoOSVersionID', 'DattoZFSVersionID', 'DattoKernelVersionID', 'DattoNICSpeedKilobitsPerSecond', 'DattoDeviceMemoryMegabytes', 'DattoUptimeSeconds', 'DattoNumberOfAgents', 'DattoNumberOfDrives', 'DattoDrivesErrors', 'DattoNumberOfVolumes', 'DattoLastCheckInDateTime', 'RMMDeviceAuditAntivirusStatusID', 'RMMDeviceAuditBackupStatusID', 'RMMDeviceAuditPatchStatusID', 'RMMDeviceAuditSoftwareStatusID', 'LastActivityPersonID', 'UserDefinedField')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'AccountID', 'Active', 'DailyCost', 'HourlyCost', 'id', 'InstallDate', 'MonthlyCost', 'Notes', 'NumberOfUsers', 'PerUseCost', 'ProductID', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'SetupFee', 'WarrantyExpirationDate', 'ContractID', 'ServiceID', 'ServiceBundleID', 'Type', 'Location', 'ContactID', 'VendorID', 'InstalledByID', 'InstalledByContactID', 'ParentInstalledProductID', 'LastModifiedTime', 'ContractServiceID', 'ContractServiceBundleID', 'ServiceLevelAgreementID', 'AccountPhysicalLocationID', 'RMMDeviceID', 'RMMDeviceUID', 'RMMDeviceAuditArchitectureID', 'RMMDeviceAuditDisplayAdaptorID', 'RMMDeviceAuditDomainID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditManufacturerID', 'RMMDeviceAuditMemoryBytes', 'RMMDeviceAuditModelID', 'RMMDeviceAuditMotherboardID', 'RMMDeviceAuditProcessorID', 'RMMDeviceAuditServicePackID', 'RMMDeviceAuditStorageBytes', 'RMMDeviceAuditDeviceTypeID', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNetworkOperatorID', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMOpenAlertCount', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMissingPatchCount', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'DattoProtectedKilobytes', 'DattoUsedKilobytes', 'DattoAvailableKilobytes', 'DattoPercentageUsed', 'DattoOffsiteUsedBytes', 'DattoOSVersionID', 'DattoZFSVersionID', 'DattoKernelVersionID', 'DattoNICSpeedKilobitsPerSecond', 'DattoDeviceMemoryMegabytes', 'DattoUptimeSeconds', 'DattoNumberOfAgents', 'DattoNumberOfDrives', 'DattoDrivesErrors', 'DattoNumberOfVolumes', 'DattoLastCheckInDateTime', 'RMMDeviceAuditAntivirusStatusID', 'RMMDeviceAuditBackupStatusID', 'RMMDeviceAuditPatchStatusID', 'RMMDeviceAuditSoftwareStatusID', 'LastActivityPersonID', 'UserDefinedField')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'AccountID', 'DailyCost', 'HourlyCost', 'id', 'InstallDate', 'MonthlyCost', 'Notes', 'NumberOfUsers', 'PerUseCost', 'ProductID', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'SetupFee', 'WarrantyExpirationDate', 'ContractID', 'ServiceID', 'ServiceBundleID', 'Type', 'Location', 'ContactID', 'VendorID', 'InstalledByID', 'InstalledByContactID', 'ParentInstalledProductID', 'LastModifiedTime', 'ContractServiceID', 'ContractServiceBundleID', 'ServiceLevelAgreementID', 'AccountPhysicalLocationID', 'RMMDeviceID', 'RMMDeviceUID', 'RMMDeviceAuditArchitectureID', 'RMMDeviceAuditDisplayAdaptorID', 'RMMDeviceAuditDomainID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditManufacturerID', 'RMMDeviceAuditMemoryBytes', 'RMMDeviceAuditModelID', 'RMMDeviceAuditMotherboardID', 'RMMDeviceAuditProcessorID', 'RMMDeviceAuditServicePackID', 'RMMDeviceAuditStorageBytes', 'RMMDeviceAuditDeviceTypeID', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNetworkOperatorID', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMOpenAlertCount', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMissingPatchCount', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'DattoProtectedKilobytes', 'DattoUsedKilobytes', 'DattoAvailableKilobytes', 'DattoPercentageUsed', 'DattoOffsiteUsedBytes', 'DattoOSVersionID', 'DattoZFSVersionID', 'DattoKernelVersionID', 'DattoNICSpeedKilobitsPerSecond', 'DattoDeviceMemoryMegabytes', 'DattoUptimeSeconds', 'DattoNumberOfAgents', 'DattoNumberOfDrives', 'DattoNumberOfVolumes', 'DattoLastCheckInDateTime', 'RMMDeviceAuditAntivirusStatusID', 'RMMDeviceAuditBackupStatusID', 'RMMDeviceAuditPatchStatusID', 'RMMDeviceAuditSoftwareStatusID', 'LastActivityPersonID', 'UserDefinedField')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'AccountID', 'DailyCost', 'HourlyCost', 'id', 'InstallDate', 'MonthlyCost', 'Notes', 'NumberOfUsers', 'PerUseCost', 'ProductID', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'SetupFee', 'WarrantyExpirationDate', 'ContractID', 'ServiceID', 'ServiceBundleID', 'Type', 'Location', 'ContactID', 'VendorID', 'InstalledByID', 'InstalledByContactID', 'ParentInstalledProductID', 'LastModifiedTime', 'ContractServiceID', 'ContractServiceBundleID', 'ServiceLevelAgreementID', 'AccountPhysicalLocationID', 'RMMDeviceID', 'RMMDeviceUID', 'RMMDeviceAuditArchitectureID', 'RMMDeviceAuditDisplayAdaptorID', 'RMMDeviceAuditDomainID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditManufacturerID', 'RMMDeviceAuditMemoryBytes', 'RMMDeviceAuditModelID', 'RMMDeviceAuditMotherboardID', 'RMMDeviceAuditProcessorID', 'RMMDeviceAuditServicePackID', 'RMMDeviceAuditStorageBytes', 'RMMDeviceAuditDeviceTypeID', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNetworkOperatorID', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMOpenAlertCount', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMissingPatchCount', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'DattoProtectedKilobytes', 'DattoUsedKilobytes', 'DattoAvailableKilobytes', 'DattoPercentageUsed', 'DattoOffsiteUsedBytes', 'DattoOSVersionID', 'DattoZFSVersionID', 'DattoKernelVersionID', 'DattoNICSpeedKilobitsPerSecond', 'DattoDeviceMemoryMegabytes', 'DattoUptimeSeconds', 'DattoNumberOfAgents', 'DattoNumberOfDrives', 'DattoNumberOfVolumes', 'DattoLastCheckInDateTime', 'RMMDeviceAuditAntivirusStatusID', 'RMMDeviceAuditBackupStatusID', 'RMMDeviceAuditPatchStatusID', 'RMMDeviceAuditSoftwareStatusID', 'LastActivityPersonID', 'UserDefinedField')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'AccountID', 'DailyCost', 'HourlyCost', 'id', 'InstallDate', 'MonthlyCost', 'Notes', 'NumberOfUsers', 'PerUseCost', 'ProductID', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'SetupFee', 'WarrantyExpirationDate', 'ContractID', 'ServiceID', 'ServiceBundleID', 'Type', 'Location', 'ContactID', 'VendorID', 'InstalledByID', 'InstalledByContactID', 'ParentInstalledProductID', 'LastModifiedTime', 'ContractServiceID', 'ContractServiceBundleID', 'ServiceLevelAgreementID', 'AccountPhysicalLocationID', 'RMMDeviceID', 'RMMDeviceUID', 'RMMDeviceAuditArchitectureID', 'RMMDeviceAuditDisplayAdaptorID', 'RMMDeviceAuditDomainID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditManufacturerID', 'RMMDeviceAuditMemoryBytes', 'RMMDeviceAuditModelID', 'RMMDeviceAuditMotherboardID', 'RMMDeviceAuditProcessorID', 'RMMDeviceAuditServicePackID', 'RMMDeviceAuditStorageBytes', 'RMMDeviceAuditDeviceTypeID', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNetworkOperatorID', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMOpenAlertCount', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMissingPatchCount', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'DattoProtectedKilobytes', 'DattoUsedKilobytes', 'DattoAvailableKilobytes', 'DattoPercentageUsed', 'DattoOffsiteUsedBytes', 'DattoOSVersionID', 'DattoZFSVersionID', 'DattoKernelVersionID', 'DattoNICSpeedKilobitsPerSecond', 'DattoDeviceMemoryMegabytes', 'DattoUptimeSeconds', 'DattoNumberOfAgents', 'DattoNumberOfDrives', 'DattoNumberOfVolumes', 'DattoLastCheckInDateTime', 'RMMDeviceAuditAntivirusStatusID', 'RMMDeviceAuditBackupStatusID', 'RMMDeviceAuditPatchStatusID', 'RMMDeviceAuditSoftwareStatusID', 'LastActivityPersonID', 'UserDefinedField')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'AccountID', 'DailyCost', 'HourlyCost', 'id', 'InstallDate', 'MonthlyCost', 'Notes', 'NumberOfUsers', 'PerUseCost', 'ProductID', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'SetupFee', 'WarrantyExpirationDate', 'ContractID', 'ServiceID', 'ServiceBundleID', 'Type', 'Location', 'ContactID', 'VendorID', 'InstalledByID', 'InstalledByContactID', 'ParentInstalledProductID', 'LastModifiedTime', 'ContractServiceID', 'ContractServiceBundleID', 'ServiceLevelAgreementID', 'AccountPhysicalLocationID', 'RMMDeviceID', 'RMMDeviceUID', 'RMMDeviceAuditArchitectureID', 'RMMDeviceAuditDisplayAdaptorID', 'RMMDeviceAuditDomainID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditManufacturerID', 'RMMDeviceAuditMemoryBytes', 'RMMDeviceAuditModelID', 'RMMDeviceAuditMotherboardID', 'RMMDeviceAuditProcessorID', 'RMMDeviceAuditServicePackID', 'RMMDeviceAuditStorageBytes', 'RMMDeviceAuditDeviceTypeID', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNetworkOperatorID', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMOpenAlertCount', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMissingPatchCount', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'DattoProtectedKilobytes', 'DattoUsedKilobytes', 'DattoAvailableKilobytes', 'DattoPercentageUsed', 'DattoOffsiteUsedBytes', 'DattoOSVersionID', 'DattoZFSVersionID', 'DattoKernelVersionID', 'DattoNICSpeedKilobitsPerSecond', 'DattoDeviceMemoryMegabytes', 'DattoUptimeSeconds', 'DattoNumberOfAgents', 'DattoNumberOfDrives', 'DattoNumberOfVolumes', 'DattoLastCheckInDateTime', 'RMMDeviceAuditAntivirusStatusID', 'RMMDeviceAuditBackupStatusID', 'RMMDeviceAuditPatchStatusID', 'RMMDeviceAuditSoftwareStatusID', 'LastActivityPersonID', 'UserDefinedField')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Notes', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'Location', 'RMMDeviceUID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMDeviceAuditLastUser', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'UserDefinedField')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Notes', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'Location', 'RMMDeviceUID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMDeviceAuditLastUser', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'UserDefinedField')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Notes', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'Location', 'RMMDeviceUID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMDeviceAuditLastUser', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'UserDefinedField')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Notes', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'Location', 'RMMDeviceUID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMDeviceAuditLastUser', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'UserDefinedField')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('Notes', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'Location', 'RMMDeviceUID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMDeviceAuditLastUser', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'UserDefinedField')]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'InstallDate', 'WarrantyExpirationDate', 'LastModifiedTime', 'DattoLastCheckInDateTime', 'UserDefinedField')]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'InstalledProduct'
    
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
        
    # Set up TimeZone offset handling
    If (-not($script:ESTzone)) {
      $script:ESTzone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Eastern Standard Time")
    }
    
    If (-not($script:ESToffset)) {
      $Now = Get-Date
      $ESTtime = [System.TimeZoneInfo]::ConvertTimeFromUtc($Now.ToUniversalTime(), $ESTzone)

      $script:ESToffset = (New-TimeSpan -Start $ESTtime -End $Now).TotalHours
    }
  }


  Process
  {
    If ($PSCmdlet.ParameterSetName -eq 'Get_all')
    { 
      $Filter = @('id', '-ge', 0)
    }
    ElseIf (-not ($Filter)) {
    
      Write-Debug ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)
      
      # Convert named parameters to a filter definition that can be parsed to QueryXML
      $Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $EntityName
    }
    Else {
      
      Write-Debug ('{0}: Query based on manual filter, parsing' -F $MyInvocation.MyCommand.Name)
              
      # $Filter is usually passed as a flat string. Convert it to an array.
      If ($Filter.Count -eq 1 -and $Filter -match ' ' )
      { 
        # First, make sure it is a single string and replace parenthesis with our special operator
        $Filter = $Filter -join ' ' -replace '\(',' -begin ' -replace '\)', ' -end '
    
        # Removing double possible spaces we may have introduced
        Do {$Filter = $Filter -replace '  ',' '}
        While ($Filter -match '  ')

        # Split back in to array, respecting quotes
        $Words = $Filter.Trim().Split(' ')
        [String[]]$Filter = @()
        $Temp = @()
        Foreach ($Word in $Words)
        {
          If ($Temp.Count -eq 0 -and $Word -match '^[\"\'']')
          {
            $Temp += $Word.TrimStart('"''')
          }
          ElseIf ($Temp.Count -gt 0 -and $Word -match "[\'\""]$")
          {
            $Temp += $Word.TrimEnd("'""")
            $Filter += $Temp -join ' '
            $Temp = @()
          }
          ElseIf ($Temp.Count -gt 0)
          {
            $Temp += $Word
          }
          Else
          {
            $Filter += $Word
          }
        }
      }
      
      Write-Debug ('{0}: Checking query for variables that have survived as string' -F $MyInvocation.MyCommand.Name)
      
      $NewFilter = @()
      Foreach ($Word in $Filter)
      {
        $Value = $Word
        # Is it a variable name?
        If ($Word -match '^\$\{?(\w+:)?(\w+)\}?(\.\w[\.\w]+)?$')
        {
          # If present, first group is SCOPE. In the context of this function, the only possible scope
          # is Global; Script = the module, local is internal to this function.
          $Scope = 'Global' # or numbered scope 2
        
          # The variable name MUST be present
          $VariableName = $Matches[2]

          # A property tail CAN be present
          $PropertyTail = $Matches[3]
        
          # Check that the variable exists
          $Variable = Try
          { Get-Variable -Name $VariableName -Scope $Scope -ValueOnly -ErrorAction Stop }
          Catch
          {
            Write-Error ('{0}: Could not find any variable called ${1}. Is it misspelled or has it not been set yet?' -f $MyInvocation.MyCommand.Name, $VariableName)
            # Force stop of calling script, because this will completely break the query
            Return
          }

          # Test if the variable "Variable" has been set
          If (Test-Path Variable:Variable) {
            Write-Debug ('{0}: Substituting {1} for its value' -F $MyInvocation.MyCommand.Name, $Word)
            If ($PropertyTail) {
              # Add properties back 
              $Expression = '$Variable{0}' -F $PropertyTail
  
              # Invoke-Expression is considered risky from an SQL injection kind of perspective. But by only
              # permitting a .dot separated string of [a-zA-Z0-9_] we are PROBABLY safe...
              $Value = Invoke-Expression -Command $Expression
            }
            Else {
              $Value = $Variable
            }
            If ($Value -eq $Null) {
              Write-Error ('{0}: Could not find any variable called {1}. Is it misspelled or has it not been set yet?' -F $MyInvocation.MyCommand.Name, $Expression)
              # Force stop of calling script, because this will completely break the query
              Return
            }
            Else { 
              # Normalize dates. Important to avoid QueryXML problems
              If ($Value.GetType().Name -eq 'DateTime')
              {[String]$Value = ConvertTo-AtwsDate -ParameterName $NewFilter[-2] -DateTime $Value}
            }
          }
        }
        $NewFilter += $Value
      }
    } 

    $Result = Get-AtwsData -Entity $EntityName -Filter $Filter

    Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $Result.Count)
    
    # Datetimeparameters
    $DateTimeParams = $Fields.Where({$_.Type -eq 'datetime'}).Name
    
    # Expand UDFs by default
    Foreach ($Item in $Result)
    {
      # Any userdefined fields?
      If ($Item.UserDefinedFields.Count -gt 0)
      { 
        # Expand User defined fields for easy filtering of collections and readability
        Foreach ($UDF in $Item.UserDefinedFields)
        {
          # Make names you HAVE TO escape...
          $UDFName = '#{0}' -F $UDF.Name
          Add-Member -InputObject $Item -MemberType NoteProperty -Name $UDFName -Value $UDF.Value
        }  
      }
      
      # Adjust TimeZone on all DateTime properties
      Foreach ($DateTimeParam in $DateTimeParams) {
      
        # Get the datetime value
        $ParameterValue = $Item.$DateTimeParam
                
        # Skip if parameter is empty
        If (-not ($ParameterValue)) {
          Continue
        }
        
        $TimePresent = $ParameterValue.Hour -gt 0 -or $ParameterValue.Minute -gt 0 -or $ParameterValue.Second -gt 0 -or $ParameterValue.Millisecond -gt 0 
                
        # If this is a DATE it should not be touched
        If ($DateTimeParam -like "*DateTime" -or $TimePresent) {

          # This is DATETIME 
          # We need to adjust the timezone difference 

          # Yes, you really have to ADD the difference
          $ParameterValue = $ParameterValue.AddHours($script:ESToffset)
            
          # Store the value back to the object (not the API!)
          $Item.$DateTimeParam = $ParameterValue
        }
      }
    }
    
    # Should we return an indirect object?
    if ( ($Result) -and ($GetReferenceEntityById))
    {
      Write-Debug ('{0}: User has asked for external reference objects by {1}' -F $MyInvocation.MyCommand.Name, $GetReferenceEntityById)
      
      $Field = $Fields.Where({$_.Name -eq $GetReferenceEntityById})
      $ResultValues = $Result | Where-Object {$null -ne $_.$GetReferenceEntityById}
      If ($ResultValues.Count -lt $Result.Count)
      {
        Write-Warning ('{0}: Only {1} of the {2}s in the primary query had a value in the property {3}.' -F $MyInvocation.MyCommand.Name, 
          $ResultValues.Count,
          $EntityName,
        $GetReferenceEntityById) -WarningAction Continue
      }
      $Filter = 'id -eq {0}' -F $($ResultValues.$GetReferenceEntityById -join ' -or id -eq ')
      $Result = Get-Atwsdata -Entity $Field.ReferenceEntityType -Filter $Filter
    }
    ElseIf ( ($Result) -and ($GetExternalEntityByThisEntityId))
    {
      Write-Debug ('{0}: User has asked for {1} that are referencing this result' -F $MyInvocation.MyCommand.Name, $GetExternalEntityByThisEntityId)
      $ReferenceInfo = $GetExternalEntityByThisEntityId -Split ':'
      $Filter = '{0} -eq {1}' -F $ReferenceInfo[1], $($Result.id -join (' -or {0}id -eq ' -F $ReferenceInfo[1]))
      $Result = Get-Atwsdata -Entity $ReferenceInfo[0] -Filter $Filter
     }
    # Do the user want labels along with index values for Picklists?
    ElseIf ( ($Result) -and -not ($NoPickListLabel))
    {
      Foreach ($Field in $Fields.Where{$_.IsPickList})
      {
        $FieldName = '{0}Label' -F $Field.Name
        Foreach ($Item in $Result)
        {
          $Value = ($Field.PickListValues.Where{$_.Value -eq $Item.$($Field.Name)}).Label
          Add-Member -InputObject $Item -MemberType NoteProperty -Name $FieldName -Value $Value -Force
          
        }
      }
    }
  }

  End
  {
    Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    If ($Result)
    {
      Return $Result
    }
  }


}
