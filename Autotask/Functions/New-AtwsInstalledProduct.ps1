#Requires -Version 5.0
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function New-AtwsInstalledProduct
{


<#
.SYNOPSIS
This function creates a new InstalledProduct through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.InstalledProduct] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the InstalledProduct with Id number 0 you could write 'New-AtwsInstalledProduct -Id 0' or you could write 'New-AtwsInstalledProduct -Filter {Id -eq 0}.

'New-AtwsInstalledProduct -Id 0,4' could be written as 'New-AtwsInstalledProduct -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new InstalledProduct you need the following required fields:
 -AccountID
 -Active
 -ProductID

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.InstalledProduct]. This function outputs the Autotask.InstalledProduct that was created by the API.
.EXAMPLE
$result = New-AtwsInstalledProduct -AccountID [Value] -Active [Value] -ProductID [Value]
Creates a new [Autotask.InstalledProduct] through the Web Services API and returns the new object.
 .EXAMPLE
$result = Get-AtwsInstalledProduct -Id 124 | New-AtwsInstalledProduct 
Copies [Autotask.InstalledProduct] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsInstalledProduct -Id 124 | New-AtwsInstalledProduct | Set-AtwsInstalledProduct -ParameterName <Parameter Value>
Copies [Autotask.InstalledProduct] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsInstalledProduct to modify the object.
 .EXAMPLE
$result = Get-AtwsInstalledProduct -Id 124 | New-AtwsInstalledProduct | Set-AtwsInstalledProduct -ParameterName <Parameter Value> -Passthru
Copies [Autotask.InstalledProduct] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsInstalledProduct to modify the object and returns the new object.

.LINK
Get-AtwsInstalledProduct
 .LINK
Set-AtwsInstalledProduct

#>

  [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName='By_parameters', ConfirmImpact='Low')]
  Param
  (
# An array of objects to create
    [Parameter(
      ParametersetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.InstalledProduct[]]
    $InputObject,

# User defined fields already setup i Autotask
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('UDF')]
    [ValidateNotNullOrEmpty()]
    [Autotask.UserDefinedField[]]
    $UserDefinedFields,

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
    [string]
    $DattoZFSVersionID,

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
    [string]
    $RMMDeviceAuditPatchStatusID,

# RMM Device Audit Memory Bytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
    $RMMDeviceAuditMemoryBytes,

# Source Cost ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $SourceCostID,

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
    [string]
    $RMMDeviceAuditManufacturerID,

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
    [string]
    $RMMDeviceAuditBackupStatusID,

# Contract ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ContractID,

# Contact Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ContactID,

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
    [string]
    $RMMDeviceAuditModelID,

# Datto Hostname
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string]
    $DattoHostname,

# Datto Drives Errors
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $DattoDrivesErrors,

# Datto Available Kilobytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
    $DattoAvailableKilobytes,

# RMM Device Audit Storage Bytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
    $RMMDeviceAuditStorageBytes,

# RMM Open Alert Count
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $RMMOpenAlertCount,

# Installed By Contact ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $InstalledByContactID,

# RMM Device ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
    $RMMDeviceID,

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
    [string]
    $DattoKernelVersionID,

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
    [string]
    $DattoOSVersionID,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $CreateDate,

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
    [string]
    $RMMDeviceAuditSoftwareStatusID,

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
    [string]
    $RMMDeviceAuditDeviceTypeID,

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
    [string]
    $RMMDeviceAuditDomainID,

# Vendor Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $VendorID,

# Contract Service Id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ContractServiceID,

# Installed By Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $InstalledByID,

# RMM Device Audit Hostname
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string]
    $RMMDeviceAuditHostname,

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
    [string]
    $SourceCostType,

# Datto Device Memory Megabytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $DattoDeviceMemoryMegabytes,

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
    [string]
    $ServiceLevelAgreementID,

# Datto Percentage Used
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $DattoPercentageUsed,

# Client
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $AccountID,

# RMM Device Audit Mac Address
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string]
    $RMMDeviceAuditMacAddress,

# Parent Configuration Item
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ParentInstalledProductID,

# Datto Remote IP
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string]
    $DattoRemoteIP,

# Install Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $InstallDate,

# RMM Device UID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string]
    $RMMDeviceUID,

# Warranty Expiration Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $WarrantyExpirationDate,

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
    [string]
    $RMMDeviceAuditAntivirusStatusID,

# RMM Device Audit Missing Patch Count
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $RMMDeviceAuditMissingPatchCount,

# Reference Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $ReferenceNumber,

# Account Physical Location
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $AccountPhysicalLocationID,

# Datto Number Of Agents
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $DattoNumberOfAgents,

# Service ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ServiceID,

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
    [string]
    $ApiVendorID,

# Datto Last Check In Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $DattoLastCheckInDateTime,

# Installed Product Category ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $InstalledProductCategoryID,

# Configuration Item Notes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,5000)]
    [string]
    $Notes,

# Configuration Item Number of Users
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $NumberOfUsers,

# RMM Device Audit External IP Address
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string]
    $RMMDeviceAuditExternalIPAddress,

# Configuration Item Daily Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $DailyCost,

# Datto NIC Speed Kilobits Per Second
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $DattoNICSpeedKilobitsPerSecond,

# Configuration Item Per Use Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $PerUseCost,

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
    [string]
    $RMMDeviceAuditProcessorID,

# Datto Uptime Seconds
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $DattoUptimeSeconds,

# Impersonator Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ImpersonatorCreatorResourceID,

# Product ID
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $ProductID,

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
    [string]
    $Type,

# Service Bundle ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ServiceBundleID,

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
    [string]
    $RMMDeviceAuditServicePackID,

# RMM Device Audit Operating System
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string]
    $RMMDeviceAuditOperatingSystem,

# Configuration Item Setup Fee
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $SetupFee,

# Created By Person ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $CreatedByPersonID,

# RMM Device Audit Mobile Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string]
    $RMMDeviceAuditMobileNumber,

# Last Activity Person Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ArgumentCompleter({
      param($Cmd, $Param, $Word, $Ast, $FakeBound)
      Get-AtwsPicklistValue -Entity InstalledProduct -FieldName LastActivityPersonType -Label
    })]
    [ValidateScript({
      $set = Get-AtwsPicklistValue -Entity InstalledProduct -FieldName LastActivityPersonType -Label
      if ($_ -in $set) { return $true}
      else {
        Write-Warning ('{0} is not one of {1}' -f $_, ($set -join ', '))
        Return $false
      }
    })]
    [string]
    $LastActivityPersonType,

# Datto Used Kilobytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
    $DattoUsedKilobytes,

# Datto Number Of Volumes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $DattoNumberOfVolumes,

# RMM Device Audit SNMP Location
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string]
    $RMMDeviceAuditSNMPLocation,

# RMM Device Audit SNMP Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string]
    $RMMDeviceAuditSNMPName,

# Datto Serial Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string]
    $DattoSerialNumber,

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
    [string]
    $RMMDeviceAuditMotherboardID,

# Last Modified Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $LastModifiedTime,

# Datto Protected Kilobytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
    $DattoProtectedKilobytes,

# Reference Title
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,200)]
    [string]
    $ReferenceTitle,

# RMM Device Audit IP Address
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string]
    $RMMDeviceAuditIPAddress,

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
    [string]
    $RMMDeviceAuditMobileNetworkOperatorID,

# RMM Device Audit Last User
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $RMMDeviceAuditLastUser,

# Product Active
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [boolean]
    $Active,

# Datto Offsite Used Bytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
    $DattoOffsiteUsedBytes,

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
    [string]
    $RMMDeviceAuditArchitectureID,

# RMM Device Audit SNMP Contact
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string]
    $RMMDeviceAuditSNMPContact,

# Device Networking ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string]
    $DeviceNetworkingID,

# Configuration Item Hourly Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $HourlyCost,

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
    [string]
    $RMMDeviceAuditDisplayAdaptorID,

# Serial Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string]
    $SerialNumber,

# Datto Internal IP
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string]
    $DattoInternalIP,

# Location
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string]
    $Location,

# Contract Service Bundle Id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ContractServiceBundleID,

# RMM Device Audit Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string]
    $RMMDeviceAuditDescription,

# Configuration Item Monthly Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $MonthlyCost,

# Datto Number Of Drives
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $DattoNumberOfDrives,

# Last Activity Person ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $LastActivityPersonID
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
        
        $processObject = @()
    }

    process {
    
        if ($InputObject) {
            Write-Verbose -Message ('{0}: Copy Object mode: Setting ID property to zero' -F $MyInvocation.MyCommand.Name)  

            $fields = Get-AtwsFieldInfo -Entity $entityName
      
            $CopyNo = 1

            foreach ($object in $InputObject) { 
                # Create a new object and copy properties
                $newObject = New-Object -TypeName Autotask.$entityName
        
                # Copy every non readonly property
                $fieldNames = $fields.Where( { $_.Name -ne 'id' }).Name

                if ($PSBoundParameters.ContainsKey('UserDefinedFields')) { 
                    $fieldNames += 'UserDefinedFields' 
                }

                foreach ($field in $fieldNames) { 
                    $newObject.$field = $object.$field 
                }

                if ($newObject -is [Autotask.Ticket]) {
                    Write-Verbose -Message ('{0}: Copy Object mode: Object is a Ticket. Title must be modified to avoid duplicate detection.' -F $MyInvocation.MyCommand.Name)  
                    $title = '{0} (Copy {1})' -F $newObject.Title, $CopyNo
                    $copyNo++
                    $newObject.Title = $title
                }
                $processObject += $newObject
            }   
        }
        else {
            Write-Debug -Message ('{0}: Creating empty [Autotask.{1}]' -F $MyInvocation.MyCommand.Name, $entityName) 
            $processObject += New-Object -TypeName Autotask.$entityName    
        }
        
        # Prepare shouldProcess comments
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to create {1} {2}(s). This action cannot be undone.' -F $caption, $processObject.Count, $entityName
        $verboseWarning = '{0}: About to create {1} {2}(s). This action may not be undoable. Do you want to continue?' -F $caption, $processObject.Count, $entityName

        # Lets don't and say we did!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
            
            # Process parameters and update objects with their values
            $processObject = $processObject | Update-AtwsObjectsWithParameters -BoundParameters $PSBoundParameters -EntityName $EntityName
            
            $result = Set-AtwsData -Entity $processObject -Create
        }
    }

    end {
        Write-Debug -Message ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $result.count, $entityName)
        Return $result
    }

}
