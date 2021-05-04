#Requires -Version 5.0
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
SourceCostType

Entities that have fields that refer to the base entity of this CmdLet:


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
    [ValidateSet('AccountID', 'AccountPhysicalLocationID', 'ContactID', 'ContractID', 'ContractServiceBundleID', 'ContractServiceID', 'CreatedByPersonID', 'ImpersonatorCreatorResourceID', 'InstalledByContactID', 'InstalledByID', 'InstalledProductCategoryID', 'LastActivityPersonID', 'ParentInstalledProductID', 'ProductID', 'ServiceBundleID', 'ServiceID', 'VendorID')]
    [string]
    $GetReferenceEntityById,

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

# Datto Serial Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $DattoSerialNumber,

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

# Datto Hostname
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string[]]
    $DattoHostname,

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

# Datto Available Kilobytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $DattoAvailableKilobytes,

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

# RMM Device Audit Device Type ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditDeviceTypeID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditDeviceTypeID -Label) + (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditDeviceTypeID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $RMMDeviceAuditDeviceTypeID,

# RMM Device Audit SNMP Location
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string[]]
    $RMMDeviceAuditSNMPLocation,

# RMM Device Audit Storage Bytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $RMMDeviceAuditStorageBytes,

# RMM Device Audit Processor ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditProcessorID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditProcessorID -Label) + (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditProcessorID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $RMMDeviceAuditProcessorID,

# RMM Device Audit Service Pack ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditServicePackID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditServicePackID -Label) + (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditServicePackID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $RMMDeviceAuditServicePackID,

# RMM Device Audit SNMP Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string[]]
    $RMMDeviceAuditSNMPName,

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

# RMM Device Audit Mobile Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string[]]
    $RMMDeviceAuditMobileNumber,

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
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditMobileNetworkOperatorID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditMobileNetworkOperatorID -Label) + (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditMobileNetworkOperatorID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $RMMDeviceAuditMobileNetworkOperatorID,

# Datto OS Version ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName DattoOSVersionID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName DattoOSVersionID -Label) + (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName DattoOSVersionID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $DattoOSVersionID,

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

# RMM Device Audit Software Status ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditSoftwareStatusID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditSoftwareStatusID -Label) + (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditSoftwareStatusID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $RMMDeviceAuditSoftwareStatusID,

# RMM Device Audit Backup Status ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditBackupStatusID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditBackupStatusID -Label) + (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditBackupStatusID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $RMMDeviceAuditBackupStatusID,

# RMM Device Audit Patch Status ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditPatchStatusID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditPatchStatusID -Label) + (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditPatchStatusID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $RMMDeviceAuditPatchStatusID,

# API Vendor ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName ApiVendorID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName ApiVendorID -Label) + (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName ApiVendorID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $ApiVendorID,

# Source Cost Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName SourceCostType -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName SourceCostType -Label) + (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName SourceCostType -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $SourceCostType,

# Impersonator Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ImpersonatorCreatorResourceID,

# Source Cost ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $SourceCostID,

# Device Networking ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $DeviceNetworkingID,

# Installed Product Category ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $InstalledProductCategoryID,

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

# Datto NIC Speed Kilobits Per Second
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $DattoNICSpeedKilobitsPerSecond,

# Datto ZFS Version ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName DattoZFSVersionID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName DattoZFSVersionID -Label) + (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName DattoZFSVersionID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $DattoZFSVersionID,

# Datto Kernel Version ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName DattoKernelVersionID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName DattoKernelVersionID -Label) + (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName DattoKernelVersionID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $DattoKernelVersionID,

# Datto Number Of Agents
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $DattoNumberOfAgents,

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
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditAntivirusStatusID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditAntivirusStatusID -Label) + (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditAntivirusStatusID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $RMMDeviceAuditAntivirusStatusID,

# Datto Number Of Volumes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $DattoNumberOfVolumes,

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

# Reference Title
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,200)]
    [string[]]
    $ReferenceTitle,

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
    [ValidateLength(0,100)]
    [string[]]
    $ReferenceNumber,

# Warranty Expiration Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $WarrantyExpirationDate,

# Configuration Item Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName Type -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName Type -Label) + (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName Type -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $Type,

# Location
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $Location,

# Service Bundle ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ServiceBundleID,

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

# Product Active
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $Active,

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

# Configuration Item ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

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

# Configuration Item Notes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,5000)]
    [string[]]
    $Notes,

# Install Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $InstallDate,

# Configuration Item Monthly Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[double][]]
    $MonthlyCost,

# Contact Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ContactID,

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

# RMM Device Audit Domain ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditDomainID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditDomainID -Label) + (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditDomainID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $RMMDeviceAuditDomainID,

# RMM Device Audit Architecture ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditArchitectureID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditArchitectureID -Label) + (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditArchitectureID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $RMMDeviceAuditArchitectureID,

# RMM Device Audit Display Adaptor ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditDisplayAdaptorID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditDisplayAdaptorID -Label) + (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditDisplayAdaptorID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $RMMDeviceAuditDisplayAdaptorID,

# RMM Device Audit IP Address
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string[]]
    $RMMDeviceAuditIPAddress,

# RMM Device Audit Model ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditModelID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditModelID -Label) + (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditModelID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $RMMDeviceAuditModelID,

# RMM Device Audit Motherboard ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditMotherboardID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditMotherboardID -Label) + (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditMotherboardID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $RMMDeviceAuditMotherboardID,

# RMM Device Audit Memory Bytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $RMMDeviceAuditMemoryBytes,

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
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditManufacturerID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditManufacturerID -Label) + (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditManufacturerID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $RMMDeviceAuditManufacturerID,

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

# Installed By Contact ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $InstalledByContactID,

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

# Contract Service Id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ContractServiceID,

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

# Account Physical Location
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $AccountPhysicalLocationID,

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
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName ServiceLevelAgreementID -Label -Quoted
    })]
    [ValidateScript({
      $set = (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName ServiceLevelAgreementID -Label) + (Get-AtwsPicklistValue -Entity InstalledProduct -FieldName ServiceLevelAgreementID -Value)
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string[]]
    $ServiceLevelAgreementID,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AccountPhysicalLocationID', 'Active', 'ApiVendorID', 'ContactID', 'ContractID', 'ContractServiceBundleID', 'ContractServiceID', 'CreateDate', 'CreatedByPersonID', 'DailyCost', 'DattoAvailableKilobytes', 'DattoDeviceMemoryMegabytes', 'DattoDrivesErrors', 'DattoHostname', 'DattoInternalIP', 'DattoKernelVersionID', 'DattoLastCheckInDateTime', 'DattoNICSpeedKilobitsPerSecond', 'DattoNumberOfAgents', 'DattoNumberOfDrives', 'DattoNumberOfVolumes', 'DattoOffsiteUsedBytes', 'DattoOSVersionID', 'DattoPercentageUsed', 'DattoProtectedKilobytes', 'DattoRemoteIP', 'DattoSerialNumber', 'DattoUptimeSeconds', 'DattoUsedKilobytes', 'DattoZFSVersionID', 'DeviceNetworkingID', 'HourlyCost', 'id', 'ImpersonatorCreatorResourceID', 'InstallDate', 'InstalledByContactID', 'InstalledByID', 'InstalledProductCategoryID', 'LastActivityPersonID', 'LastActivityPersonType', 'LastModifiedTime', 'Location', 'MonthlyCost', 'Notes', 'NumberOfUsers', 'ParentInstalledProductID', 'PerUseCost', 'ProductID', 'ReferenceNumber', 'ReferenceTitle', 'RMMDeviceAuditAntivirusStatusID', 'RMMDeviceAuditArchitectureID', 'RMMDeviceAuditBackupStatusID', 'RMMDeviceAuditDescription', 'RMMDeviceAuditDeviceTypeID', 'RMMDeviceAuditDisplayAdaptorID', 'RMMDeviceAuditDomainID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditManufacturerID', 'RMMDeviceAuditMemoryBytes', 'RMMDeviceAuditMissingPatchCount', 'RMMDeviceAuditMobileNetworkOperatorID', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditModelID', 'RMMDeviceAuditMotherboardID', 'RMMDeviceAuditOperatingSystem', 'RMMDeviceAuditPatchStatusID', 'RMMDeviceAuditProcessorID', 'RMMDeviceAuditServicePackID', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSoftwareStatusID', 'RMMDeviceAuditStorageBytes', 'RMMDeviceID', 'RMMDeviceUID', 'RMMOpenAlertCount', 'SerialNumber', 'ServiceBundleID', 'ServiceID', 'ServiceLevelAgreementID', 'SetupFee', 'SourceCostID', 'SourceCostType', 'Type', 'VendorID', 'WarrantyExpirationDate')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AccountPhysicalLocationID', 'Active', 'ApiVendorID', 'ContactID', 'ContractID', 'ContractServiceBundleID', 'ContractServiceID', 'CreateDate', 'CreatedByPersonID', 'DailyCost', 'DattoAvailableKilobytes', 'DattoDeviceMemoryMegabytes', 'DattoDrivesErrors', 'DattoHostname', 'DattoInternalIP', 'DattoKernelVersionID', 'DattoLastCheckInDateTime', 'DattoNICSpeedKilobitsPerSecond', 'DattoNumberOfAgents', 'DattoNumberOfDrives', 'DattoNumberOfVolumes', 'DattoOffsiteUsedBytes', 'DattoOSVersionID', 'DattoPercentageUsed', 'DattoProtectedKilobytes', 'DattoRemoteIP', 'DattoSerialNumber', 'DattoUptimeSeconds', 'DattoUsedKilobytes', 'DattoZFSVersionID', 'DeviceNetworkingID', 'HourlyCost', 'id', 'ImpersonatorCreatorResourceID', 'InstallDate', 'InstalledByContactID', 'InstalledByID', 'InstalledProductCategoryID', 'LastActivityPersonID', 'LastActivityPersonType', 'LastModifiedTime', 'Location', 'MonthlyCost', 'Notes', 'NumberOfUsers', 'ParentInstalledProductID', 'PerUseCost', 'ProductID', 'ReferenceNumber', 'ReferenceTitle', 'RMMDeviceAuditAntivirusStatusID', 'RMMDeviceAuditArchitectureID', 'RMMDeviceAuditBackupStatusID', 'RMMDeviceAuditDescription', 'RMMDeviceAuditDeviceTypeID', 'RMMDeviceAuditDisplayAdaptorID', 'RMMDeviceAuditDomainID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditManufacturerID', 'RMMDeviceAuditMemoryBytes', 'RMMDeviceAuditMissingPatchCount', 'RMMDeviceAuditMobileNetworkOperatorID', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditModelID', 'RMMDeviceAuditMotherboardID', 'RMMDeviceAuditOperatingSystem', 'RMMDeviceAuditPatchStatusID', 'RMMDeviceAuditProcessorID', 'RMMDeviceAuditServicePackID', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSoftwareStatusID', 'RMMDeviceAuditStorageBytes', 'RMMDeviceID', 'RMMDeviceUID', 'RMMOpenAlertCount', 'SerialNumber', 'ServiceBundleID', 'ServiceID', 'ServiceLevelAgreementID', 'SetupFee', 'SourceCostID', 'SourceCostType', 'Type', 'VendorID', 'WarrantyExpirationDate')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AccountPhysicalLocationID', 'Active', 'ApiVendorID', 'ContactID', 'ContractID', 'ContractServiceBundleID', 'ContractServiceID', 'CreateDate', 'CreatedByPersonID', 'DailyCost', 'DattoAvailableKilobytes', 'DattoDeviceMemoryMegabytes', 'DattoDrivesErrors', 'DattoHostname', 'DattoInternalIP', 'DattoKernelVersionID', 'DattoLastCheckInDateTime', 'DattoNICSpeedKilobitsPerSecond', 'DattoNumberOfAgents', 'DattoNumberOfDrives', 'DattoNumberOfVolumes', 'DattoOffsiteUsedBytes', 'DattoOSVersionID', 'DattoPercentageUsed', 'DattoProtectedKilobytes', 'DattoRemoteIP', 'DattoSerialNumber', 'DattoUptimeSeconds', 'DattoUsedKilobytes', 'DattoZFSVersionID', 'DeviceNetworkingID', 'HourlyCost', 'id', 'ImpersonatorCreatorResourceID', 'InstallDate', 'InstalledByContactID', 'InstalledByID', 'InstalledProductCategoryID', 'LastActivityPersonID', 'LastActivityPersonType', 'LastModifiedTime', 'Location', 'MonthlyCost', 'Notes', 'NumberOfUsers', 'ParentInstalledProductID', 'PerUseCost', 'ProductID', 'ReferenceNumber', 'ReferenceTitle', 'RMMDeviceAuditAntivirusStatusID', 'RMMDeviceAuditArchitectureID', 'RMMDeviceAuditBackupStatusID', 'RMMDeviceAuditDescription', 'RMMDeviceAuditDeviceTypeID', 'RMMDeviceAuditDisplayAdaptorID', 'RMMDeviceAuditDomainID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditManufacturerID', 'RMMDeviceAuditMemoryBytes', 'RMMDeviceAuditMissingPatchCount', 'RMMDeviceAuditMobileNetworkOperatorID', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditModelID', 'RMMDeviceAuditMotherboardID', 'RMMDeviceAuditOperatingSystem', 'RMMDeviceAuditPatchStatusID', 'RMMDeviceAuditProcessorID', 'RMMDeviceAuditServicePackID', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSoftwareStatusID', 'RMMDeviceAuditStorageBytes', 'RMMDeviceID', 'RMMDeviceUID', 'RMMOpenAlertCount', 'SerialNumber', 'ServiceBundleID', 'ServiceID', 'ServiceLevelAgreementID', 'SetupFee', 'SourceCostID', 'SourceCostType', 'Type', 'VendorID', 'WarrantyExpirationDate')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AccountPhysicalLocationID', 'ApiVendorID', 'ContactID', 'ContractID', 'ContractServiceBundleID', 'ContractServiceID', 'CreateDate', 'CreatedByPersonID', 'DailyCost', 'DattoAvailableKilobytes', 'DattoDeviceMemoryMegabytes', 'DattoHostname', 'DattoInternalIP', 'DattoKernelVersionID', 'DattoLastCheckInDateTime', 'DattoNICSpeedKilobitsPerSecond', 'DattoNumberOfAgents', 'DattoNumberOfDrives', 'DattoNumberOfVolumes', 'DattoOffsiteUsedBytes', 'DattoOSVersionID', 'DattoPercentageUsed', 'DattoProtectedKilobytes', 'DattoRemoteIP', 'DattoSerialNumber', 'DattoUptimeSeconds', 'DattoUsedKilobytes', 'DattoZFSVersionID', 'DeviceNetworkingID', 'HourlyCost', 'id', 'ImpersonatorCreatorResourceID', 'InstallDate', 'InstalledByContactID', 'InstalledByID', 'InstalledProductCategoryID', 'LastActivityPersonID', 'LastActivityPersonType', 'LastModifiedTime', 'Location', 'MonthlyCost', 'Notes', 'NumberOfUsers', 'ParentInstalledProductID', 'PerUseCost', 'ProductID', 'ReferenceNumber', 'ReferenceTitle', 'RMMDeviceAuditAntivirusStatusID', 'RMMDeviceAuditArchitectureID', 'RMMDeviceAuditBackupStatusID', 'RMMDeviceAuditDescription', 'RMMDeviceAuditDeviceTypeID', 'RMMDeviceAuditDisplayAdaptorID', 'RMMDeviceAuditDomainID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditManufacturerID', 'RMMDeviceAuditMemoryBytes', 'RMMDeviceAuditMissingPatchCount', 'RMMDeviceAuditMobileNetworkOperatorID', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditModelID', 'RMMDeviceAuditMotherboardID', 'RMMDeviceAuditOperatingSystem', 'RMMDeviceAuditPatchStatusID', 'RMMDeviceAuditProcessorID', 'RMMDeviceAuditServicePackID', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSoftwareStatusID', 'RMMDeviceAuditStorageBytes', 'RMMDeviceID', 'RMMDeviceUID', 'RMMOpenAlertCount', 'SerialNumber', 'ServiceBundleID', 'ServiceID', 'ServiceLevelAgreementID', 'SetupFee', 'SourceCostID', 'SourceCostType', 'Type', 'UserDefinedField', 'VendorID', 'WarrantyExpirationDate')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AccountPhysicalLocationID', 'ApiVendorID', 'ContactID', 'ContractID', 'ContractServiceBundleID', 'ContractServiceID', 'CreateDate', 'CreatedByPersonID', 'DailyCost', 'DattoAvailableKilobytes', 'DattoDeviceMemoryMegabytes', 'DattoHostname', 'DattoInternalIP', 'DattoKernelVersionID', 'DattoLastCheckInDateTime', 'DattoNICSpeedKilobitsPerSecond', 'DattoNumberOfAgents', 'DattoNumberOfDrives', 'DattoNumberOfVolumes', 'DattoOffsiteUsedBytes', 'DattoOSVersionID', 'DattoPercentageUsed', 'DattoProtectedKilobytes', 'DattoRemoteIP', 'DattoSerialNumber', 'DattoUptimeSeconds', 'DattoUsedKilobytes', 'DattoZFSVersionID', 'DeviceNetworkingID', 'HourlyCost', 'id', 'ImpersonatorCreatorResourceID', 'InstallDate', 'InstalledByContactID', 'InstalledByID', 'InstalledProductCategoryID', 'LastActivityPersonID', 'LastActivityPersonType', 'LastModifiedTime', 'Location', 'MonthlyCost', 'Notes', 'NumberOfUsers', 'ParentInstalledProductID', 'PerUseCost', 'ProductID', 'ReferenceNumber', 'ReferenceTitle', 'RMMDeviceAuditAntivirusStatusID', 'RMMDeviceAuditArchitectureID', 'RMMDeviceAuditBackupStatusID', 'RMMDeviceAuditDescription', 'RMMDeviceAuditDeviceTypeID', 'RMMDeviceAuditDisplayAdaptorID', 'RMMDeviceAuditDomainID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditManufacturerID', 'RMMDeviceAuditMemoryBytes', 'RMMDeviceAuditMissingPatchCount', 'RMMDeviceAuditMobileNetworkOperatorID', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditModelID', 'RMMDeviceAuditMotherboardID', 'RMMDeviceAuditOperatingSystem', 'RMMDeviceAuditPatchStatusID', 'RMMDeviceAuditProcessorID', 'RMMDeviceAuditServicePackID', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSoftwareStatusID', 'RMMDeviceAuditStorageBytes', 'RMMDeviceID', 'RMMDeviceUID', 'RMMOpenAlertCount', 'SerialNumber', 'ServiceBundleID', 'ServiceID', 'ServiceLevelAgreementID', 'SetupFee', 'SourceCostID', 'SourceCostType', 'Type', 'UserDefinedField', 'VendorID', 'WarrantyExpirationDate')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AccountPhysicalLocationID', 'ApiVendorID', 'ContactID', 'ContractID', 'ContractServiceBundleID', 'ContractServiceID', 'CreateDate', 'CreatedByPersonID', 'DailyCost', 'DattoAvailableKilobytes', 'DattoDeviceMemoryMegabytes', 'DattoHostname', 'DattoInternalIP', 'DattoKernelVersionID', 'DattoLastCheckInDateTime', 'DattoNICSpeedKilobitsPerSecond', 'DattoNumberOfAgents', 'DattoNumberOfDrives', 'DattoNumberOfVolumes', 'DattoOffsiteUsedBytes', 'DattoOSVersionID', 'DattoPercentageUsed', 'DattoProtectedKilobytes', 'DattoRemoteIP', 'DattoSerialNumber', 'DattoUptimeSeconds', 'DattoUsedKilobytes', 'DattoZFSVersionID', 'DeviceNetworkingID', 'HourlyCost', 'id', 'ImpersonatorCreatorResourceID', 'InstallDate', 'InstalledByContactID', 'InstalledByID', 'InstalledProductCategoryID', 'LastActivityPersonID', 'LastActivityPersonType', 'LastModifiedTime', 'Location', 'MonthlyCost', 'Notes', 'NumberOfUsers', 'ParentInstalledProductID', 'PerUseCost', 'ProductID', 'ReferenceNumber', 'ReferenceTitle', 'RMMDeviceAuditAntivirusStatusID', 'RMMDeviceAuditArchitectureID', 'RMMDeviceAuditBackupStatusID', 'RMMDeviceAuditDescription', 'RMMDeviceAuditDeviceTypeID', 'RMMDeviceAuditDisplayAdaptorID', 'RMMDeviceAuditDomainID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditManufacturerID', 'RMMDeviceAuditMemoryBytes', 'RMMDeviceAuditMissingPatchCount', 'RMMDeviceAuditMobileNetworkOperatorID', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditModelID', 'RMMDeviceAuditMotherboardID', 'RMMDeviceAuditOperatingSystem', 'RMMDeviceAuditPatchStatusID', 'RMMDeviceAuditProcessorID', 'RMMDeviceAuditServicePackID', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSoftwareStatusID', 'RMMDeviceAuditStorageBytes', 'RMMDeviceID', 'RMMDeviceUID', 'RMMOpenAlertCount', 'SerialNumber', 'ServiceBundleID', 'ServiceID', 'ServiceLevelAgreementID', 'SetupFee', 'SourceCostID', 'SourceCostType', 'Type', 'UserDefinedField', 'VendorID', 'WarrantyExpirationDate')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('AccountID', 'AccountPhysicalLocationID', 'ApiVendorID', 'ContactID', 'ContractID', 'ContractServiceBundleID', 'ContractServiceID', 'CreateDate', 'CreatedByPersonID', 'DailyCost', 'DattoAvailableKilobytes', 'DattoDeviceMemoryMegabytes', 'DattoHostname', 'DattoInternalIP', 'DattoKernelVersionID', 'DattoLastCheckInDateTime', 'DattoNICSpeedKilobitsPerSecond', 'DattoNumberOfAgents', 'DattoNumberOfDrives', 'DattoNumberOfVolumes', 'DattoOffsiteUsedBytes', 'DattoOSVersionID', 'DattoPercentageUsed', 'DattoProtectedKilobytes', 'DattoRemoteIP', 'DattoSerialNumber', 'DattoUptimeSeconds', 'DattoUsedKilobytes', 'DattoZFSVersionID', 'DeviceNetworkingID', 'HourlyCost', 'id', 'ImpersonatorCreatorResourceID', 'InstallDate', 'InstalledByContactID', 'InstalledByID', 'InstalledProductCategoryID', 'LastActivityPersonID', 'LastActivityPersonType', 'LastModifiedTime', 'Location', 'MonthlyCost', 'Notes', 'NumberOfUsers', 'ParentInstalledProductID', 'PerUseCost', 'ProductID', 'ReferenceNumber', 'ReferenceTitle', 'RMMDeviceAuditAntivirusStatusID', 'RMMDeviceAuditArchitectureID', 'RMMDeviceAuditBackupStatusID', 'RMMDeviceAuditDescription', 'RMMDeviceAuditDeviceTypeID', 'RMMDeviceAuditDisplayAdaptorID', 'RMMDeviceAuditDomainID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditManufacturerID', 'RMMDeviceAuditMemoryBytes', 'RMMDeviceAuditMissingPatchCount', 'RMMDeviceAuditMobileNetworkOperatorID', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditModelID', 'RMMDeviceAuditMotherboardID', 'RMMDeviceAuditOperatingSystem', 'RMMDeviceAuditPatchStatusID', 'RMMDeviceAuditProcessorID', 'RMMDeviceAuditServicePackID', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSoftwareStatusID', 'RMMDeviceAuditStorageBytes', 'RMMDeviceID', 'RMMDeviceUID', 'RMMOpenAlertCount', 'SerialNumber', 'ServiceBundleID', 'ServiceID', 'ServiceLevelAgreementID', 'SetupFee', 'SourceCostID', 'SourceCostType', 'Type', 'UserDefinedField', 'VendorID', 'WarrantyExpirationDate')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('DattoHostname', 'DattoInternalIP', 'DattoRemoteIP', 'DattoSerialNumber', 'DeviceNetworkingID', 'Location', 'Notes', 'ReferenceNumber', 'ReferenceTitle', 'RMMDeviceAuditDescription', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditOperatingSystem', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceUID', 'SerialNumber', 'UserDefinedField')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('DattoHostname', 'DattoInternalIP', 'DattoRemoteIP', 'DattoSerialNumber', 'DeviceNetworkingID', 'Location', 'Notes', 'ReferenceNumber', 'ReferenceTitle', 'RMMDeviceAuditDescription', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditOperatingSystem', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceUID', 'SerialNumber', 'UserDefinedField')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('DattoHostname', 'DattoInternalIP', 'DattoRemoteIP', 'DattoSerialNumber', 'DeviceNetworkingID', 'Location', 'Notes', 'ReferenceNumber', 'ReferenceTitle', 'RMMDeviceAuditDescription', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditOperatingSystem', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceUID', 'SerialNumber', 'UserDefinedField')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('DattoHostname', 'DattoInternalIP', 'DattoRemoteIP', 'DattoSerialNumber', 'DeviceNetworkingID', 'Location', 'Notes', 'ReferenceNumber', 'ReferenceTitle', 'RMMDeviceAuditDescription', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditOperatingSystem', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceUID', 'SerialNumber', 'UserDefinedField')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('DattoHostname', 'DattoInternalIP', 'DattoRemoteIP', 'DattoSerialNumber', 'DeviceNetworkingID', 'Location', 'Notes', 'ReferenceNumber', 'ReferenceTitle', 'RMMDeviceAuditDescription', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditOperatingSystem', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceUID', 'SerialNumber', 'UserDefinedField')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'DattoLastCheckInDateTime', 'InstallDate', 'LastModifiedTime', 'UserDefinedField', 'WarrantyExpirationDate')]
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

        $result = [collections.generic.list[psobject]]::new()
        $iterations = [collections.generic.list[psobject]]::new()
    }


    process {
        # Parameterset Get_All has a single parameter: -All
        # Set the Filter manually to get every single object of this type
        if ($PSCmdlet.ParameterSetName -eq 'Get_all') {
            $Filter = @('id', '-ge', 0)
            $iterations.Add($Filter)
        }
        # So it is not -All. If Filter does not exist it has to be By_parameters
        elseif (-not ($Filter)) {

            Write-Debug ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)

            # What is the highest number of values for a parameter and is it higher than 200?
            $max = $PSBoundParameters.Values[0].length | Measure-Object -Maximum

            # If the count is less than or equal to 200 we pass PSBoundParameters as is
            if ($max.Maximum -le 200) {
                [collections.generic.list[string]]$Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $entityName
                $iterations.Add($Filter)
            }
            # More than 200 values. This will cause a SQL query nested too much error. Break a single parameter
            # into segments and create multiple queries with max 200 values
            else {
                
                # Find the parameter with the $max.Maximum number of items
                foreach ($param in $PSCmdlet.MyInvocation.BoundParameters.GetEnumerator() ) {
                    # When we have found the right parameter, stop iterating
                    if ($param.Value.length -eq $max.Maximum) { break }
                }
     
                # Deduplicate the value list or the same ID may be included in more than 1 query
                $outerLoop = $PSCmdlet.MyInvocation.BoundParameters.$($param.key) | Sort-Object -Unique

                Write-Verbose ('{0}: Received {1} objects containing {2} unique values for parameter {3}' -f $MyInvocation.MyCommand.Name, $count, $outerLoop.Count, $param.key)
                  
                for ($s = 0; $s -lt $outerLoop.count; $s += 200) {
                    $e = $s + 199
                    if ($e -ge $outerLoop.count) {
                        $e = $outerLoop.count - 1
                    }
                  
                    # Make writable of BoundParameters
                    $BoundParameters = $PSCmdlet.MyInvocation.BoundParameters

                    # make a selection
                    $BoundParameters.$($param.key) = $outerLoop[$s .. $e]

                    Write-Verbose ('{0}: Asking for {1} values {2} to {3}' -f $MyInvocation.MyCommand.Name, $param, $s, $e)

                    # Convert named parameters to a filter definition that can be parsed to QueryXML
                    [collections.generic.list[string]]$Filter = ConvertTo-AtwsFilter -BoundParameters $BoundParameters -EntityName $entityName
                    $iterations.Add($Filter)
                }
            }
        }
        # Not parameters, nor Get_all. There are only three parameter sets, so now we know
        # that we were passed a Filter
        else {

            Write-Debug ('{0}: Query based on manual filter, parsing' -F $MyInvocation.MyCommand.Name)

            # Parse the filter string and expand variables in _this_ scope (dot-sourcing)
            # or the variables will not be available and expansion will fail
            $Filter = . Update-AtwsFilter -Filterstring $Filter
            $iterations.Add($Filter)
        }

        # Prepare shouldProcess comments
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to query the Autotask Web API for {1}(s).' -F $caption, $entityName
        $verboseWarning = '{0}: About to query the Autotask Web API for {1}(s). Do you want to continue?' -F $caption, $entityName

        # Lets do it and say we didn't!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) {
            foreach ($Filter in $iterations) {

                try {
                    # Make the query and pass the optional parameters to Get-AtwsData
                    # Force list even if result is only 1 object to be compatible with addrange()
                    [collections.generic.list[psobject]]$response = Get-AtwsData -Entity $entityName -Filter $Filter `
                        -NoPickListLabel:$NoPickListLabel.IsPresent `
                        -GetReferenceEntityById $GetReferenceEntityById
                }
                catch {
                    # Write a debug message with detailed information to developers
                    $reason = ("{0}: {1}" -f $_.CategoryInfo.Category, $_.CategoryInfo.Reason)
                    $message = "{2}: {0}`r`n`r`nLine:{1}`r`n`r`nScript stacktrace:`r`n{3}" -f $_.Exception.Message, $_.InvocationInfo.Line, $reason, $_.ScriptStackTrace
                    Write-Debug $message

                    # Pass on the error
                    $PSCmdlet.ThrowTerminatingError($_)
                    return
                }
                # Add response to result - if there are any response to add
                if ($response.count -gt 0) { 
                    $result.AddRange($response)
                }

                Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $result.Count)
            }
        }
    }

    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        if ($result) {
            Return [array]$result
        }
    }


}
