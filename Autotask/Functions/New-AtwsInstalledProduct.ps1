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

# Client
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $AccountID,

# Account Physical Location
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $AccountPhysicalLocationID,

# Product Active
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [boolean]
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
    [string]
    $ApiVendorID,

# Contact Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ContactID,

# Contract ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ContractID,

# Contract Service Bundle Id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ContractServiceBundleID,

# Contract Service Id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ContractServiceID,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $CreateDate,

# Created By Person ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $CreatedByPersonID,

# Configuration Item Daily Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $DailyCost,

# Datto Available Kilobytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
    $DattoAvailableKilobytes,

# Datto Device Memory Megabytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $DattoDeviceMemoryMegabytes,

# Datto Drives Errors
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $DattoDrivesErrors,

# Datto Hostname
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string]
    $DattoHostname,

# Datto Internal IP
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string]
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
    [string]
    $DattoKernelVersionID,

# Datto Last Check In Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $DattoLastCheckInDateTime,

# Datto NIC Speed Kilobits Per Second
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $DattoNICSpeedKilobitsPerSecond,

# Datto Number Of Agents
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $DattoNumberOfAgents,

# Datto Number Of Drives
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $DattoNumberOfDrives,

# Datto Number Of Volumes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $DattoNumberOfVolumes,

# Datto Offsite Used Bytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
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
    [string]
    $DattoOSVersionID,

# Datto Percentage Used
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $DattoPercentageUsed,

# Datto Protected Kilobytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
    $DattoProtectedKilobytes,

# Datto Remote IP
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string]
    $DattoRemoteIP,

# Datto Serial Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string]
    $DattoSerialNumber,

# Datto Uptime Seconds
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $DattoUptimeSeconds,

# Datto Used Kilobytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
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
    [string]
    $DattoZFSVersionID,

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

# Impersonator Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ImpersonatorCreatorResourceID,

# Install Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $InstallDate,

# Installed By Contact ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $InstalledByContactID,

# Installed By Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $InstalledByID,

# Installed Product Category ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $InstalledProductCategoryID,

# Last Activity Person ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $LastActivityPersonID,

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

# Last Modified Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $LastModifiedTime,

# Location
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string]
    $Location,

# Configuration Item Monthly Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $MonthlyCost,

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

# Parent Configuration Item
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ParentInstalledProductID,

# Configuration Item Per Use Cost
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $PerUseCost,

# Product ID
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $ProductID,

# Reference Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string]
    $ReferenceNumber,

# Reference Title
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,200)]
    [string]
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
    [string]
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
    [string]
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
    [string]
    $RMMDeviceAuditBackupStatusID,

# RMM Device Audit Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string]
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
    [string]
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
    [string]
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
    [string]
    $RMMDeviceAuditDomainID,

# RMM Device Audit External IP Address
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string]
    $RMMDeviceAuditExternalIPAddress,

# RMM Device Audit Hostname
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string]
    $RMMDeviceAuditHostname,

# RMM Device Audit IP Address
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string]
    $RMMDeviceAuditIPAddress,

# RMM Device Audit Last User
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $RMMDeviceAuditLastUser,

# RMM Device Audit Mac Address
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string]
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
    [string]
    $RMMDeviceAuditManufacturerID,

# RMM Device Audit Memory Bytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
    $RMMDeviceAuditMemoryBytes,

# RMM Device Audit Missing Patch Count
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
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
    [string]
    $RMMDeviceAuditMobileNetworkOperatorID,

# RMM Device Audit Mobile Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string]
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
    [string]
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
    [string]
    $RMMDeviceAuditMotherboardID,

# RMM Device Audit Operating System
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string]
    $RMMDeviceAuditOperatingSystem,

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

# RMM Device Audit SNMP Contact
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string]
    $RMMDeviceAuditSNMPContact,

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

# RMM Device Audit Storage Bytes
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
    $RMMDeviceAuditStorageBytes,

# RMM Device ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [long]
    $RMMDeviceID,

# RMM Device UID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,255)]
    [string]
    $RMMDeviceUID,

# RMM Open Alert Count
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $RMMOpenAlertCount,

# Serial Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string]
    $SerialNumber,

# Service Bundle ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ServiceBundleID,

# Service ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
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
    [string]
    $ServiceLevelAgreementID,

# Configuration Item Setup Fee
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $SetupFee,

# Source Cost ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
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
    [string]
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
    [string]
    $Type,

# Vendor Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $VendorID,

# Warranty Expiration Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $WarrantyExpirationDate
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

        $processObject = [Collections.ArrayList]::new()
        $result = [Collections.ArrayList]::new()
    }

    process {

        if ($InputObject) {
            Write-Verbose -Message ('{0}: Copy Object mode: Setting ID property to zero' -F $MyInvocation.MyCommand.Name)

            $entityInfo = Get-AtwsFieldInfo -Entity $entityName -EntityInfo

            $CopyNo = 1

            foreach ($object in $InputObject) {
                # Create a new object and copy properties
                $newObject = New-Object -TypeName Autotask.$entityName

                # Copy every non readonly property
                $fieldNames = [collections.ArrayList]::new()
                $WriteableFields = $entityInfo.WriteableFields
                $RequiredFields = $entityInfo.RequiredFields

                if ($WriteableFields.count -gt 1) {   $fieldNames.AddRange($WriteableFields) } else {   $fieldNames.Add($WriteableFields)    }
                if ($RequiredFields.count -gt 1) {   $fieldNames.AddRange($RequiredFields) } else {   $fieldNames.Add($RequiredFields)    }

                if ($PSBoundParameters.ContainsKey('UserDefinedFields')) {
                    $fieldNames += 'UserDefinedFields'
                }

                foreach ($field in $fieldNames) {
                    $newObject.$field = $object.$field
                }

                if ($newObject -is [Autotask.Ticket] -and $object.id -gt 0) {
                    Write-Verbose -Message ('{0}: Copy Object mode: Object is a Ticket. Title must be modified to avoid duplicate detection.' -F $MyInvocation.MyCommand.Name)
                    $title = '{0} (Copy {1})' -F $newObject.Title, $CopyNo
                    $copyNo++
                    $newObject.Title = $title
                }
                [void]$processObject.Add($newObject)
            }
        }
        else {
            Write-Debug -Message ('{0}: Creating empty [Autotask.{1}]' -F $MyInvocation.MyCommand.Name, $entityName)
            [void]$processObject.add((New-Object -TypeName Autotask.$entityName))
        }

        # Prepare shouldProcess comments
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to create {1} {2}(s). This action cannot be undone.' -F $caption, $processObject.Count, $entityName
        $verboseWarning = '{0}: About to create {1} {2}(s). This action may not be undoable. Do you want to continue?' -F $caption, $processObject.Count, $entityName

        # Lets don't and say we did!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) {

            # Process parameters and update objects with their values
            $processObject = $processObject | Update-AtwsObjectsWithParameters -BoundParameters $PSBoundParameters -EntityName $EntityName

            try {
                # If using pipeline this block (process) will run once pr item in the pipeline. make sure to return them all
                $Data = Set-AtwsData -Entity $processObject -Create
                if ($Data.Count -gt 1) {
                    $result.AddRange($Data)
                }else {
                    $result.Add($Data)
                }
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
        }
    }

    end {
        Write-Debug -Message ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $result.count, $entityName)
        Return [array]$result
    }

}
