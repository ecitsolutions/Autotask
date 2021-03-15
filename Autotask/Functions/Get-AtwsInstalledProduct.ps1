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
    [Collections.Generic.List[string]]
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

# Client
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[Int]]]
    $AccountID,

# Account Physical Location
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $AccountPhysicalLocationID,

# Product Active
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[boolean]]]
    $Active,

# API Vendor ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName ApiVendorID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InstalledProduct -FieldName ApiVendorID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $ApiVendorID,

# Contact Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $ContactID,

# Contract ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $ContractID,

# Contract Service Bundle Id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $ContractServiceBundleID,

# Contract Service Id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $ContractServiceID,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[datetime]]]
    $CreateDate,

# Created By Person ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $CreatedByPersonID,

# Configuration Item Daily Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $DailyCost,

# Datto Available Kilobytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[long]]]
    $DattoAvailableKilobytes,

# Datto Device Memory Megabytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $DattoDeviceMemoryMegabytes,

# Datto Drives Errors
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[boolean]]]
    $DattoDrivesErrors,

# Datto Hostname
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [Collections.Generic.List[string]]
    $DattoHostname,

# Datto Internal IP
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [Collections.Generic.List[string]]
    $DattoInternalIP,

# Datto Kernel Version ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName DattoKernelVersionID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InstalledProduct -FieldName DattoKernelVersionID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $DattoKernelVersionID,

# Datto Last Check In Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[datetime]]]
    $DattoLastCheckInDateTime,

# Datto NIC Speed Kilobits Per Second
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $DattoNICSpeedKilobitsPerSecond,

# Datto Number Of Agents
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $DattoNumberOfAgents,

# Datto Number Of Drives
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $DattoNumberOfDrives,

# Datto Number Of Volumes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $DattoNumberOfVolumes,

# Datto Offsite Used Bytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[long]]]
    $DattoOffsiteUsedBytes,

# Datto OS Version ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName DattoOSVersionID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InstalledProduct -FieldName DattoOSVersionID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $DattoOSVersionID,

# Datto Percentage Used
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $DattoPercentageUsed,

# Datto Protected Kilobytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[long]]]
    $DattoProtectedKilobytes,

# Datto Remote IP
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [Collections.Generic.List[string]]
    $DattoRemoteIP,

# Datto Serial Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [Collections.Generic.List[string]]
    $DattoSerialNumber,

# Datto Uptime Seconds
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $DattoUptimeSeconds,

# Datto Used Kilobytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[long]]]
    $DattoUsedKilobytes,

# Datto ZFS Version ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName DattoZFSVersionID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InstalledProduct -FieldName DattoZFSVersionID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $DattoZFSVersionID,

# Device Networking ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [Collections.Generic.List[string]]
    $DeviceNetworkingID,

# Configuration Item Hourly Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $HourlyCost,

# Configuration Item ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[long]]]
    $id,

# Impersonator Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $ImpersonatorCreatorResourceID,

# Install Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[datetime]]]
    $InstallDate,

# Installed By Contact ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $InstalledByContactID,

# Installed By Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $InstalledByID,

# Installed Product Category ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $InstalledProductCategoryID,

# Last Activity Person ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $LastActivityPersonID,

# Last Modified Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[datetime]]]
    $LastModifiedTime,

# Location
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [Collections.Generic.List[string]]
    $Location,

# Configuration Item Monthly Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $MonthlyCost,

# Configuration Item Notes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,5000)]
    [Collections.Generic.List[string]]
    $Notes,

# Configuration Item Number of Users
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $NumberOfUsers,

# Parent Configuration Item
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $ParentInstalledProductID,

# Configuration Item Per Use Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $PerUseCost,

# Product ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Collections.Generic.List[Nullable[Int]]]
    $ProductID,

# Reference Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [Collections.Generic.List[string]]
    $ReferenceNumber,

# Reference Title
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,200)]
    [Collections.Generic.List[string]]
    $ReferenceTitle,

# RMM Device Audit Antivirus Status ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditAntivirusStatusID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditAntivirusStatusID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $RMMDeviceAuditAntivirusStatusID,

# RMM Device Audit Architecture ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditArchitectureID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditArchitectureID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $RMMDeviceAuditArchitectureID,

# RMM Device Audit Backup Status ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditBackupStatusID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditBackupStatusID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $RMMDeviceAuditBackupStatusID,

# RMM Device Audit Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [Collections.Generic.List[string]]
    $RMMDeviceAuditDescription,

# RMM Device Audit Device Type ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditDeviceTypeID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditDeviceTypeID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $RMMDeviceAuditDeviceTypeID,

# RMM Device Audit Display Adaptor ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditDisplayAdaptorID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditDisplayAdaptorID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $RMMDeviceAuditDisplayAdaptorID,

# RMM Device Audit Domain ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditDomainID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditDomainID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $RMMDeviceAuditDomainID,

# RMM Device Audit External IP Address
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [Collections.Generic.List[string]]
    $RMMDeviceAuditExternalIPAddress,

# RMM Device Audit Hostname
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [Collections.Generic.List[string]]
    $RMMDeviceAuditHostname,

# RMM Device Audit IP Address
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [Collections.Generic.List[string]]
    $RMMDeviceAuditIPAddress,

# RMM Device Audit Last User
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [Collections.Generic.List[string]]
    $RMMDeviceAuditLastUser,

# RMM Device Audit Mac Address
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [Collections.Generic.List[string]]
    $RMMDeviceAuditMacAddress,

# RMM Device Audit Manufacturer ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditManufacturerID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditManufacturerID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $RMMDeviceAuditManufacturerID,

# RMM Device Audit Memory Bytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[long]]]
    $RMMDeviceAuditMemoryBytes,

# RMM Device Audit Missing Patch Count
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $RMMDeviceAuditMissingPatchCount,

# RMM Device Audit Mobile Network Operator ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditMobileNetworkOperatorID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditMobileNetworkOperatorID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $RMMDeviceAuditMobileNetworkOperatorID,

# RMM Device Audit Mobile Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [Collections.Generic.List[string]]
    $RMMDeviceAuditMobileNumber,

# RMM Device Audit Model ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditModelID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditModelID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $RMMDeviceAuditModelID,

# RMM Device Audit Motherboard ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditMotherboardID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditMotherboardID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $RMMDeviceAuditMotherboardID,

# RMM Device Audit Patch Status ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditPatchStatusID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditPatchStatusID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $RMMDeviceAuditPatchStatusID,

# RMM Device Audit Processor ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditProcessorID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditProcessorID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $RMMDeviceAuditProcessorID,

# RMM Device Audit Service Pack ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditServicePackID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditServicePackID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $RMMDeviceAuditServicePackID,

# RMM Device Audit SNMP Contact
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [Collections.Generic.List[string]]
    $RMMDeviceAuditSNMPContact,

# RMM Device Audit SNMP Location
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [Collections.Generic.List[string]]
    $RMMDeviceAuditSNMPLocation,

# RMM Device Audit SNMP Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [Collections.Generic.List[string]]
    $RMMDeviceAuditSNMPName,

# RMM Device Audit Software Status ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditSoftwareStatusID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InstalledProduct -FieldName RMMDeviceAuditSoftwareStatusID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $RMMDeviceAuditSoftwareStatusID,

# RMM Device Audit Storage Bytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[long]]]
    $RMMDeviceAuditStorageBytes,

# RMM Device ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[long]]]
    $RMMDeviceID,

# RMM Device UID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [Collections.Generic.List[string]]
    $RMMDeviceUID,

# RMM Open Alert Count
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $RMMOpenAlertCount,

# Serial Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [Collections.Generic.List[string]]
    $SerialNumber,

# Service Bundle ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $ServiceBundleID,

# Service ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $ServiceID,

# Service Level Agreement
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName ServiceLevelAgreementID -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InstalledProduct -FieldName ServiceLevelAgreementID -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $ServiceLevelAgreementID,

# Configuration Item Setup Fee
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[double]]]
    $SetupFee,

# Source Cost ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $SourceCostID,

# Source Cost Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName SourceCostType -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InstalledProduct -FieldName SourceCostType -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $SourceCostType,

# Configuration Item Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName Type -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InstalledProduct -FieldName Type -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [Collections.Generic.List[string]]
    $Type,

# Vendor Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[Int]]]
    $VendorID,

# Warranty Expiration Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Collections.Generic.List[Nullable[datetime]]]
    $WarrantyExpirationDate,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('RMMDeviceAuditSNMPContact', 'RMMDeviceAuditModelID', 'LastActivityPersonID', 'Notes', 'RMMDeviceAuditDisplayAdaptorID', 'ReferenceNumber', 'RMMDeviceAuditServicePackID', 'RMMDeviceAuditMobileNetworkOperatorID', 'RMMDeviceAuditIPAddress', 'DattoUsedKilobytes', 'DattoZFSVersionID', 'InstalledProductCategoryID', 'CreatedByPersonID', 'RMMDeviceAuditDomainID', 'RMMDeviceAuditMemoryBytes', 'RMMDeviceAuditBackupStatusID', 'RMMDeviceAuditHostname', 'RMMDeviceAuditPatchStatusID', 'InstalledByID', 'RMMDeviceAuditArchitectureID', 'SerialNumber', 'DattoHostname', 'RMMDeviceAuditAntivirusStatusID', 'ImpersonatorCreatorResourceID', 'RMMDeviceAuditSNMPName', 'HourlyCost', 'RMMDeviceAuditProcessorID', 'ContractID', 'NumberOfUsers', 'DeviceNetworkingID', 'CreateDate', 'RMMDeviceID', 'DattoNumberOfVolumes', 'Active', 'DattoOSVersionID', 'VendorID', 'DattoLastCheckInDateTime', 'DattoUptimeSeconds', 'DattoAvailableKilobytes', 'AccountPhysicalLocationID', 'DattoOffsiteUsedBytes', 'DailyCost', 'InstallDate', 'LastModifiedTime', 'ProductID', 'ServiceBundleID', 'SourceCostType', 'MonthlyCost', 'DattoDrivesErrors', 'DattoNumberOfAgents', 'SetupFee', 'DattoProtectedKilobytes', 'DattoRemoteIP', 'RMMDeviceAuditDescription', 'PerUseCost', 'Location', 'ContactID', 'WarrantyExpirationDate', 'RMMDeviceAuditDeviceTypeID', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMacAddress', 'DattoInternalIP', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditExternalIPAddress', 'ApiVendorID', 'RMMDeviceAuditMissingPatchCount', 'DattoKernelVersionID', 'id', 'RMMDeviceAuditStorageBytes', 'RMMDeviceAuditManufacturerID', 'ContractServiceID', 'DattoNumberOfDrives', 'InstalledByContactID', 'DattoNICSpeedKilobitsPerSecond', 'ParentInstalledProductID', 'RMMDeviceAuditOperatingSystem', 'AccountID', 'DattoPercentageUsed', 'DattoSerialNumber', 'ServiceLevelAgreementID', 'ContractServiceBundleID', 'RMMDeviceAuditMotherboardID', 'RMMDeviceUID', 'Type', 'LastActivityPersonType', 'RMMDeviceAuditMobileNumber', 'SourceCostID', 'RMMOpenAlertCount', 'ServiceID', 'RMMDeviceAuditSoftwareStatusID', 'ReferenceTitle', 'DattoDeviceMemoryMegabytes', '')]
    [Collections.Generic.List[string]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('RMMDeviceAuditSNMPContact', 'RMMDeviceAuditModelID', 'LastActivityPersonID', 'Notes', 'RMMDeviceAuditDisplayAdaptorID', 'ReferenceNumber', 'RMMDeviceAuditServicePackID', 'RMMDeviceAuditMobileNetworkOperatorID', 'RMMDeviceAuditIPAddress', 'DattoUsedKilobytes', 'DattoZFSVersionID', 'InstalledProductCategoryID', 'CreatedByPersonID', 'RMMDeviceAuditDomainID', 'RMMDeviceAuditMemoryBytes', 'RMMDeviceAuditBackupStatusID', 'RMMDeviceAuditHostname', 'RMMDeviceAuditPatchStatusID', 'InstalledByID', 'RMMDeviceAuditArchitectureID', 'SerialNumber', 'DattoHostname', 'RMMDeviceAuditAntivirusStatusID', 'ImpersonatorCreatorResourceID', 'RMMDeviceAuditSNMPName', 'HourlyCost', 'RMMDeviceAuditProcessorID', 'ContractID', 'NumberOfUsers', 'DeviceNetworkingID', 'CreateDate', 'RMMDeviceID', 'DattoNumberOfVolumes', 'Active', 'DattoOSVersionID', 'VendorID', 'DattoLastCheckInDateTime', 'DattoUptimeSeconds', 'DattoAvailableKilobytes', 'AccountPhysicalLocationID', 'DattoOffsiteUsedBytes', 'DailyCost', 'InstallDate', 'LastModifiedTime', 'ProductID', 'ServiceBundleID', 'SourceCostType', 'MonthlyCost', 'DattoDrivesErrors', 'DattoNumberOfAgents', 'SetupFee', 'DattoProtectedKilobytes', 'DattoRemoteIP', 'RMMDeviceAuditDescription', 'PerUseCost', 'Location', 'ContactID', 'WarrantyExpirationDate', 'RMMDeviceAuditDeviceTypeID', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMacAddress', 'DattoInternalIP', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditExternalIPAddress', 'ApiVendorID', 'RMMDeviceAuditMissingPatchCount', 'DattoKernelVersionID', 'id', 'RMMDeviceAuditStorageBytes', 'RMMDeviceAuditManufacturerID', 'ContractServiceID', 'DattoNumberOfDrives', 'InstalledByContactID', 'DattoNICSpeedKilobitsPerSecond', 'ParentInstalledProductID', 'RMMDeviceAuditOperatingSystem', 'AccountID', 'DattoPercentageUsed', 'DattoSerialNumber', 'ServiceLevelAgreementID', 'ContractServiceBundleID', 'RMMDeviceAuditMotherboardID', 'RMMDeviceUID', 'Type', 'LastActivityPersonType', 'RMMDeviceAuditMobileNumber', 'SourceCostID', 'RMMOpenAlertCount', 'ServiceID', 'RMMDeviceAuditSoftwareStatusID', 'ReferenceTitle', 'DattoDeviceMemoryMegabytes', '')]
    [Collections.Generic.List[string]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('RMMDeviceAuditSNMPContact', 'RMMDeviceAuditModelID', 'LastActivityPersonID', 'Notes', 'RMMDeviceAuditDisplayAdaptorID', 'ReferenceNumber', 'RMMDeviceAuditServicePackID', 'RMMDeviceAuditMobileNetworkOperatorID', 'RMMDeviceAuditIPAddress', 'DattoUsedKilobytes', 'DattoZFSVersionID', 'InstalledProductCategoryID', 'CreatedByPersonID', 'RMMDeviceAuditDomainID', 'RMMDeviceAuditMemoryBytes', 'RMMDeviceAuditBackupStatusID', 'RMMDeviceAuditHostname', 'RMMDeviceAuditPatchStatusID', 'InstalledByID', 'RMMDeviceAuditArchitectureID', 'SerialNumber', 'DattoHostname', 'RMMDeviceAuditAntivirusStatusID', 'ImpersonatorCreatorResourceID', 'RMMDeviceAuditSNMPName', 'HourlyCost', 'RMMDeviceAuditProcessorID', 'ContractID', 'NumberOfUsers', 'DeviceNetworkingID', 'CreateDate', 'RMMDeviceID', 'DattoNumberOfVolumes', 'Active', 'DattoOSVersionID', 'VendorID', 'DattoLastCheckInDateTime', 'DattoUptimeSeconds', 'DattoAvailableKilobytes', 'AccountPhysicalLocationID', 'DattoOffsiteUsedBytes', 'DailyCost', 'InstallDate', 'LastModifiedTime', 'ProductID', 'ServiceBundleID', 'SourceCostType', 'MonthlyCost', 'DattoDrivesErrors', 'DattoNumberOfAgents', 'SetupFee', 'DattoProtectedKilobytes', 'DattoRemoteIP', 'RMMDeviceAuditDescription', 'PerUseCost', 'Location', 'ContactID', 'WarrantyExpirationDate', 'RMMDeviceAuditDeviceTypeID', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMacAddress', 'DattoInternalIP', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditExternalIPAddress', 'ApiVendorID', 'RMMDeviceAuditMissingPatchCount', 'DattoKernelVersionID', 'id', 'RMMDeviceAuditStorageBytes', 'RMMDeviceAuditManufacturerID', 'ContractServiceID', 'DattoNumberOfDrives', 'InstalledByContactID', 'DattoNICSpeedKilobitsPerSecond', 'ParentInstalledProductID', 'RMMDeviceAuditOperatingSystem', 'AccountID', 'DattoPercentageUsed', 'DattoSerialNumber', 'ServiceLevelAgreementID', 'ContractServiceBundleID', 'RMMDeviceAuditMotherboardID', 'RMMDeviceUID', 'Type', 'LastActivityPersonType', 'RMMDeviceAuditMobileNumber', 'SourceCostID', 'RMMOpenAlertCount', 'ServiceID', 'RMMDeviceAuditSoftwareStatusID', 'ReferenceTitle', 'DattoDeviceMemoryMegabytes', '')]
    [Collections.Generic.List[string]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'AccountID', 'DailyCost', 'HourlyCost', 'id', 'InstallDate', 'MonthlyCost', 'Notes', 'NumberOfUsers', 'PerUseCost', 'ProductID', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'SetupFee', 'WarrantyExpirationDate', 'ContractID', 'ServiceID', 'ServiceBundleID', 'Type', 'Location', 'ContactID', 'VendorID', 'InstalledByID', 'InstalledByContactID', 'ParentInstalledProductID', 'LastModifiedTime', 'ContractServiceID', 'ContractServiceBundleID', 'ServiceLevelAgreementID', 'AccountPhysicalLocationID', 'RMMDeviceID', 'RMMDeviceUID', 'RMMDeviceAuditArchitectureID', 'RMMDeviceAuditDisplayAdaptorID', 'RMMDeviceAuditDomainID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditManufacturerID', 'RMMDeviceAuditMemoryBytes', 'RMMDeviceAuditModelID', 'RMMDeviceAuditMotherboardID', 'RMMDeviceAuditOperatingSystem', 'RMMDeviceAuditProcessorID', 'RMMDeviceAuditServicePackID', 'RMMDeviceAuditStorageBytes', 'RMMDeviceAuditDeviceTypeID', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNetworkOperatorID', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMOpenAlertCount', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMissingPatchCount', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'DattoProtectedKilobytes', 'DattoUsedKilobytes', 'DattoAvailableKilobytes', 'DattoPercentageUsed', 'DattoOffsiteUsedBytes', 'DattoOSVersionID', 'DattoZFSVersionID', 'DattoKernelVersionID', 'DattoNICSpeedKilobitsPerSecond', 'DattoDeviceMemoryMegabytes', 'DattoUptimeSeconds', 'DattoNumberOfAgents', 'DattoNumberOfDrives', 'DattoNumberOfVolumes', 'DattoLastCheckInDateTime', 'RMMDeviceAuditAntivirusStatusID', 'RMMDeviceAuditBackupStatusID', 'RMMDeviceAuditPatchStatusID', 'RMMDeviceAuditSoftwareStatusID', 'LastActivityPersonID', 'LastActivityPersonType', 'CreatedByPersonID', 'ApiVendorID', 'DeviceNetworkingID', 'InstalledProductCategoryID', 'SourceCostID', 'SourceCostType', 'ImpersonatorCreatorResourceID', 'UserDefinedField')]
    [Collections.Generic.List[string]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'AccountID', 'DailyCost', 'HourlyCost', 'id', 'InstallDate', 'MonthlyCost', 'Notes', 'NumberOfUsers', 'PerUseCost', 'ProductID', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'SetupFee', 'WarrantyExpirationDate', 'ContractID', 'ServiceID', 'ServiceBundleID', 'Type', 'Location', 'ContactID', 'VendorID', 'InstalledByID', 'InstalledByContactID', 'ParentInstalledProductID', 'LastModifiedTime', 'ContractServiceID', 'ContractServiceBundleID', 'ServiceLevelAgreementID', 'AccountPhysicalLocationID', 'RMMDeviceID', 'RMMDeviceUID', 'RMMDeviceAuditArchitectureID', 'RMMDeviceAuditDisplayAdaptorID', 'RMMDeviceAuditDomainID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditManufacturerID', 'RMMDeviceAuditMemoryBytes', 'RMMDeviceAuditModelID', 'RMMDeviceAuditMotherboardID', 'RMMDeviceAuditOperatingSystem', 'RMMDeviceAuditProcessorID', 'RMMDeviceAuditServicePackID', 'RMMDeviceAuditStorageBytes', 'RMMDeviceAuditDeviceTypeID', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNetworkOperatorID', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMOpenAlertCount', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMissingPatchCount', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'DattoProtectedKilobytes', 'DattoUsedKilobytes', 'DattoAvailableKilobytes', 'DattoPercentageUsed', 'DattoOffsiteUsedBytes', 'DattoOSVersionID', 'DattoZFSVersionID', 'DattoKernelVersionID', 'DattoNICSpeedKilobitsPerSecond', 'DattoDeviceMemoryMegabytes', 'DattoUptimeSeconds', 'DattoNumberOfAgents', 'DattoNumberOfDrives', 'DattoNumberOfVolumes', 'DattoLastCheckInDateTime', 'RMMDeviceAuditAntivirusStatusID', 'RMMDeviceAuditBackupStatusID', 'RMMDeviceAuditPatchStatusID', 'RMMDeviceAuditSoftwareStatusID', 'LastActivityPersonID', 'LastActivityPersonType', 'CreatedByPersonID', 'ApiVendorID', 'DeviceNetworkingID', 'InstalledProductCategoryID', 'SourceCostID', 'SourceCostType', 'ImpersonatorCreatorResourceID', 'UserDefinedField')]
    [Collections.Generic.List[string]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'AccountID', 'DailyCost', 'HourlyCost', 'id', 'InstallDate', 'MonthlyCost', 'Notes', 'NumberOfUsers', 'PerUseCost', 'ProductID', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'SetupFee', 'WarrantyExpirationDate', 'ContractID', 'ServiceID', 'ServiceBundleID', 'Type', 'Location', 'ContactID', 'VendorID', 'InstalledByID', 'InstalledByContactID', 'ParentInstalledProductID', 'LastModifiedTime', 'ContractServiceID', 'ContractServiceBundleID', 'ServiceLevelAgreementID', 'AccountPhysicalLocationID', 'RMMDeviceID', 'RMMDeviceUID', 'RMMDeviceAuditArchitectureID', 'RMMDeviceAuditDisplayAdaptorID', 'RMMDeviceAuditDomainID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditManufacturerID', 'RMMDeviceAuditMemoryBytes', 'RMMDeviceAuditModelID', 'RMMDeviceAuditMotherboardID', 'RMMDeviceAuditOperatingSystem', 'RMMDeviceAuditProcessorID', 'RMMDeviceAuditServicePackID', 'RMMDeviceAuditStorageBytes', 'RMMDeviceAuditDeviceTypeID', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNetworkOperatorID', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMOpenAlertCount', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMissingPatchCount', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'DattoProtectedKilobytes', 'DattoUsedKilobytes', 'DattoAvailableKilobytes', 'DattoPercentageUsed', 'DattoOffsiteUsedBytes', 'DattoOSVersionID', 'DattoZFSVersionID', 'DattoKernelVersionID', 'DattoNICSpeedKilobitsPerSecond', 'DattoDeviceMemoryMegabytes', 'DattoUptimeSeconds', 'DattoNumberOfAgents', 'DattoNumberOfDrives', 'DattoNumberOfVolumes', 'DattoLastCheckInDateTime', 'RMMDeviceAuditAntivirusStatusID', 'RMMDeviceAuditBackupStatusID', 'RMMDeviceAuditPatchStatusID', 'RMMDeviceAuditSoftwareStatusID', 'LastActivityPersonID', 'LastActivityPersonType', 'CreatedByPersonID', 'ApiVendorID', 'DeviceNetworkingID', 'InstalledProductCategoryID', 'SourceCostID', 'SourceCostType', 'ImpersonatorCreatorResourceID', 'UserDefinedField')]
    [Collections.Generic.List[string]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'AccountID', 'DailyCost', 'HourlyCost', 'id', 'InstallDate', 'MonthlyCost', 'Notes', 'NumberOfUsers', 'PerUseCost', 'ProductID', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'SetupFee', 'WarrantyExpirationDate', 'ContractID', 'ServiceID', 'ServiceBundleID', 'Type', 'Location', 'ContactID', 'VendorID', 'InstalledByID', 'InstalledByContactID', 'ParentInstalledProductID', 'LastModifiedTime', 'ContractServiceID', 'ContractServiceBundleID', 'ServiceLevelAgreementID', 'AccountPhysicalLocationID', 'RMMDeviceID', 'RMMDeviceUID', 'RMMDeviceAuditArchitectureID', 'RMMDeviceAuditDisplayAdaptorID', 'RMMDeviceAuditDomainID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditManufacturerID', 'RMMDeviceAuditMemoryBytes', 'RMMDeviceAuditModelID', 'RMMDeviceAuditMotherboardID', 'RMMDeviceAuditOperatingSystem', 'RMMDeviceAuditProcessorID', 'RMMDeviceAuditServicePackID', 'RMMDeviceAuditStorageBytes', 'RMMDeviceAuditDeviceTypeID', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNetworkOperatorID', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMOpenAlertCount', 'RMMDeviceAuditLastUser', 'RMMDeviceAuditMissingPatchCount', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'DattoProtectedKilobytes', 'DattoUsedKilobytes', 'DattoAvailableKilobytes', 'DattoPercentageUsed', 'DattoOffsiteUsedBytes', 'DattoOSVersionID', 'DattoZFSVersionID', 'DattoKernelVersionID', 'DattoNICSpeedKilobitsPerSecond', 'DattoDeviceMemoryMegabytes', 'DattoUptimeSeconds', 'DattoNumberOfAgents', 'DattoNumberOfDrives', 'DattoNumberOfVolumes', 'DattoLastCheckInDateTime', 'RMMDeviceAuditAntivirusStatusID', 'RMMDeviceAuditBackupStatusID', 'RMMDeviceAuditPatchStatusID', 'RMMDeviceAuditSoftwareStatusID', 'LastActivityPersonID', 'LastActivityPersonType', 'CreatedByPersonID', 'ApiVendorID', 'DeviceNetworkingID', 'InstalledProductCategoryID', 'SourceCostID', 'SourceCostType', 'ImpersonatorCreatorResourceID', 'UserDefinedField')]
    [Collections.Generic.List[string]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Notes', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'Location', 'RMMDeviceUID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditOperatingSystem', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMDeviceAuditLastUser', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'DeviceNetworkingID', 'UserDefinedField')]
    [Collections.Generic.List[string]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Notes', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'Location', 'RMMDeviceUID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditOperatingSystem', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMDeviceAuditLastUser', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'DeviceNetworkingID', 'UserDefinedField')]
    [Collections.Generic.List[string]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Notes', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'Location', 'RMMDeviceUID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditOperatingSystem', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMDeviceAuditLastUser', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'DeviceNetworkingID', 'UserDefinedField')]
    [Collections.Generic.List[string]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Notes', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'Location', 'RMMDeviceUID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditOperatingSystem', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMDeviceAuditLastUser', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'DeviceNetworkingID', 'UserDefinedField')]
    [Collections.Generic.List[string]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Notes', 'ReferenceNumber', 'ReferenceTitle', 'SerialNumber', 'Location', 'RMMDeviceUID', 'RMMDeviceAuditExternalIPAddress', 'RMMDeviceAuditHostname', 'RMMDeviceAuditIPAddress', 'RMMDeviceAuditMacAddress', 'RMMDeviceAuditOperatingSystem', 'RMMDeviceAuditSNMPLocation', 'RMMDeviceAuditSNMPName', 'RMMDeviceAuditSNMPContact', 'RMMDeviceAuditMobileNumber', 'RMMDeviceAuditDescription', 'RMMDeviceAuditLastUser', 'DattoSerialNumber', 'DattoInternalIP', 'DattoRemoteIP', 'DattoHostname', 'DeviceNetworkingID', 'UserDefinedField')]
    [Collections.Generic.List[string]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate', 'InstallDate', 'WarrantyExpirationDate', 'LastModifiedTime', 'DattoLastCheckInDateTime', 'UserDefinedField')]
    [Collections.Generic.List[string]]
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

           
            # Count the values of the first parameter passed. We will not try do to this on more than 1 parameter, nor on any 
            # other parameter than the first. This is lazy, but efficient.
            $count = $PSBoundParameters.Values[0].count

            # If the count is less than or equal to 200 we pass PSBoundParameters as is
            if ($count -le 200) {
                [collections.generic.list[string]]$Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $entityName
                $iterations.Add($Filter)
            }
            # More than 200 values. This will cause a SQL query nested too much. Break a single parameter
            # into segments and create multiple queries with max 200 values
            else {
                # Deduplicate the value list or the same ID may be included in more than 1 query
                $outerLoop = $PSBoundParameters.Values[0] | Sort-Object -Unique

                Write-Verbose ('{0}: Received {1} objects containing {2} unique values for parameter {3}' -f $MyInvocation.MyCommand.Name, $count, $outerLoop.Count, $param)

                # Make a writable copy of PSBoundParameters
                $BoundParameters = $PSBoundParameters
                for ($i = 0; $i -lt $outerLoop.count; $i += 200) {
                    $j = $i + 199
                    if ($j -ge $outerLoop.count) {
                        $j = $outerLoop.count - 1
                    }

                    # make a selection
                    $BoundParameters[$param] = $outerLoop[$i .. $j]

                    Write-Verbose ('{0}: Asking for {1} values {2} to {3}' -f $MyInvocation.MyCommand.Name, $param, $i, $j)

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
                    write-host "ERROR: " -ForegroundColor Red -NoNewline
                    write-host $_.Exception.Message
                    write-host ("{0}: {1}" -f $_.CategoryInfo.Category,$_.CategoryInfo.Reason) -ForegroundColor Cyan
                    $_.ScriptStackTrace -split '\n' | ForEach-Object {
                        Write-host "  |  " -ForegroundColor Cyan -NoNewline
                        Write-host $_
                    }
                }
                # Add response to result
                $result.AddRange($response)

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
