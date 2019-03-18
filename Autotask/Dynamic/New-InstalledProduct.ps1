<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function New-InstalledProduct
{


<#
.SYNOPSIS
This function creates a new InstalledProduct through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.InstalledProduct] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the InstalledProduct with Id number 0 you could write 'New-InstalledProduct -Id 0' or you could write 'New-InstalledProduct -Filter {Id -eq 0}.

'New-InstalledProduct -Id 0,4' could be written as 'New-InstalledProduct -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new InstalledProduct you need the following required fields:
 -AccountID
 -Active
 -InstallDate
 -ProductID

Entities that have fields that refer to the base entity of this CmdLet:

BillingItem
 InstalledProduct
 Subscription
 Ticket
 TicketAdditionalInstalledProduct

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.InstalledProduct]. This function outputs the Autotask.InstalledProduct that was created by the API.
.EXAMPLE
$Result = New-InstalledProduct -AccountID [Value] -Active [Value] -InstallDate [Value] -ProductID [Value]
Creates a new [Autotask.InstalledProduct] through the Web Services API and returns the new object.
 .EXAMPLE
$Result = Get-InstalledProduct -Id 124 | New-InstalledProduct 
Copies [Autotask.InstalledProduct] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-InstalledProduct -Id 124 | New-InstalledProduct | Set-InstalledProduct -ParameterName <Parameter Value>
Copies [Autotask.InstalledProduct] by Id 124 to a new object through the Web Services API, passes the new object to the Set-InstalledProduct to modify the object.
 .EXAMPLE
$Result = Get-InstalledProduct -Id 124 | New-InstalledProduct | Set-InstalledProduct -ParameterName <Parameter Value> -Passthru
Copies [Autotask.InstalledProduct] by Id 124 to a new object through the Web Services API, passes the new object to the Set-InstalledProduct to modify the object and returns the new object.

.LINK
Get-InstalledProduct
 .LINK
Set-InstalledProduct

#>

  [CmdLetBinding(DefaultParameterSetName='By_parameters', ConfirmImpact='Medium')]
  Param
  (
# An array of objects to create
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.InstalledProduct[]]
    $InputObject,

# User defined fields already setup i Autotask
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Alias('UDF')]
    [ValidateNotNullOrEmpty()]
    [Autotask.UserDefinedField[]]
    $UserDefinedFields,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $CreateDate,

# Client
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $AccountID,

# Product Active
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [boolean]
    $Active,

# Configuration Item Daily Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $DailyCost,

# Configuration Item Hourly Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $HourlyCost,

# Install Date
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $InstallDate,

# Configuration Item Monthly Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $MonthlyCost,

# Configuration Item Notes
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,5000)]
    [string]
    $Notes,

# Configuration Item Number of Users
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $NumberOfUsers,

# Configuration Item Per Use Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $PerUseCost,

# Product ID
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $ProductID,

# Reference Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string]
    $ReferenceNumber,

# Reference Title
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,200)]
    [string]
    $ReferenceTitle,

# Serial Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,100)]
    [string]
    $SerialNumber,

# Configuration Item Setup Fee
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $SetupFee,

# Warranty Expiration Date
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $WarrantyExpirationDate,

# Contract ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $ContractID,

# Service ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $ServiceID,

# Service Bundle ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $ServiceBundleID,

# Configuration Item Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $Type,

# Location
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,100)]
    [string]
    $Location,

# Contact Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $ContactID,

# Vendor Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $VendorID,

# Installed By Resource ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $InstalledByID,

# Installed By Contact ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $InstalledByContactID,

# Parent Configuration Item
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $ParentInstalledProductID,

# Last Modified Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $LastModifiedTime,

# Contract Service Id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $ContractServiceID,

# Contract Service Bundle Id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $ContractServiceBundleID,

# Service Level Agreement
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $ServiceLevelAgreementID,

# Account Physical Location
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $AccountPhysicalLocationID,

# RMM Device ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long]
    $RMMDeviceID,

# RMM Device UID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string]
    $RMMDeviceUID,

# RMM Device Audit Architecture ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $RMMDeviceAuditArchitectureID,

# RMM Device Audit Display Adaptor ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $RMMDeviceAuditDisplayAdaptorID,

# RMM Device Audit Domain ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $RMMDeviceAuditDomainID,

# RMM Device Audit External IP Address
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string]
    $RMMDeviceAuditExternalIPAddress,

# RMM Device Audit Hostname
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string]
    $RMMDeviceAuditHostname,

# RMM Device Audit IP Address
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string]
    $RMMDeviceAuditIPAddress,

# RMM Device Audit Mac Address
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string]
    $RMMDeviceAuditMacAddress,

# RMM Device Audit Manufacturer ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $RMMDeviceAuditManufacturerID,

# RMM Device Audit Memory Bytes
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long]
    $RMMDeviceAuditMemoryBytes,

# RMM Device Audit Model ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $RMMDeviceAuditModelID,

# RMM Device Audit Motherboard ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $RMMDeviceAuditMotherboardID,

# RMM Device Audit Operating System
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string]
    $RMMDeviceAuditOperatingSystem,

# RMM Device Audit Processor ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $RMMDeviceAuditProcessorID,

# RMM Device Audit Service Pack ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $RMMDeviceAuditServicePackID,

# RMM Device Audit Storage Bytes
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long]
    $RMMDeviceAuditStorageBytes,

# RMM Device Audit Device Type ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $RMMDeviceAuditDeviceTypeID,

# RMM Device Audit SNMP Location
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string]
    $RMMDeviceAuditSNMPLocation,

# RMM Device Audit SNMP Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string]
    $RMMDeviceAuditSNMPName,

# RMM Device Audit SNMP Contact
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string]
    $RMMDeviceAuditSNMPContact,

# RMM Device Audit Mobile Network Operator ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $RMMDeviceAuditMobileNetworkOperatorID,

# RMM Device Audit Mobile Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string]
    $RMMDeviceAuditMobileNumber,

# RMM Device Audit Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string]
    $RMMDeviceAuditDescription,

# RMM Open Alert Count
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $RMMOpenAlertCount,

# RMM Device Audit Last User
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string]
    $RMMDeviceAuditLastUser,

# RMM Device Audit Missing Patch Count
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $RMMDeviceAuditMissingPatchCount,

# Datto Serial Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,100)]
    [string]
    $DattoSerialNumber,

# Datto Internal IP
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string]
    $DattoInternalIP,

# Datto Remote IP
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string]
    $DattoRemoteIP,

# Datto Hostname
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,255)]
    [string]
    $DattoHostname,

# Datto Protected Kilobytes
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long]
    $DattoProtectedKilobytes,

# Datto Used Kilobytes
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long]
    $DattoUsedKilobytes,

# Datto Available Kilobytes
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long]
    $DattoAvailableKilobytes,

# Datto Percentage Used
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $DattoPercentageUsed,

# Datto Offsite Used Bytes
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [long]
    $DattoOffsiteUsedBytes,

# Datto OS Version ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $DattoOSVersionID,

# Datto ZFS Version ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $DattoZFSVersionID,

# Datto Kernel Version ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $DattoKernelVersionID,

# Datto NIC Speed Kilobits Per Second
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $DattoNICSpeedKilobitsPerSecond,

# Datto Device Memory Megabytes
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $DattoDeviceMemoryMegabytes,

# Datto Uptime Seconds
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $DattoUptimeSeconds,

# Datto Number Of Agents
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $DattoNumberOfAgents,

# Datto Number Of Drives
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $DattoNumberOfDrives,

# Datto Drives Errors
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean]
    $DattoDrivesErrors,

# Datto Number Of Volumes
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $DattoNumberOfVolumes,

# Datto Last Check In Date Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [datetime]
    $DattoLastCheckInDateTime,

# RMM Device Audit Antivirus Status ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $RMMDeviceAuditAntivirusStatusID,

# RMM Device Audit Backup Status ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $RMMDeviceAuditBackupStatusID,

# RMM Device Audit Patch Status ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $RMMDeviceAuditPatchStatusID,

# RMM Device Audit Software Status ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $RMMDeviceAuditSoftwareStatusID,

# Last Activity Person ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $LastActivityPersonID,

# Last Activity Person Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $LastActivityPersonType
  )
 
  Begin
  { 
    $EntityName = 'InstalledProduct'
           
    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    $ProcessObject = @()
    
    # Set up TimeZone offset handling
    If (-not($script:ESToffset))
    {
      $Now = Get-Date
      $ESTzone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Eastern Standard Time")
      $ESTtime = [System.TimeZoneInfo]::ConvertTimeFromUtc($Now.ToUniversalTime(), $ESTzone)

      $script:ESToffset = (New-TimeSpan -Start $ESTtime -End $Now).TotalHours
    }

  }

  Process
  {
    $Fields = Get-FieldInfo -Entity $EntityName
    
    If ($InputObject)
    {
      Write-Verbose ('{0}: Copy Object mode: Setting ID property to zero' -F $MyInvocation.MyCommand.Name)  
      
      $CopyNo = 1

      Foreach ($Object in $InputObject) 
      { 
        # Create a new object and copy properties
        $NewObject = New-Object Autotask.$EntityName
        
        # Copy every non readonly property
        Foreach ($Field in $Fields.Where({$_.Name -ne 'id'}).Name)
        {
          $NewObject.$Field = $Object.$Field
        }
        If ($NewObject -is [Autotask.Ticket])
        {
          Write-Verbose ('{0}: Copy Object mode: Object is a Ticket. Title must be modified to avoid duplicate detection.' -F $MyInvocation.MyCommand.Name)  
          $Title = '{0} (Copy {1})' -F $NewObject.Title, $CopyNo
          $CopyNo++
          $NewObject.Title = $Title
        }
        $ProcessObject += $NewObject
      }   
    }
    Else
    {
      Write-Verbose ('{0}: Creating empty [Autotask.{1}]' -F $MyInvocation.MyCommand.Name, $EntityName) 
      $ProcessObject += New-Object Autotask.$EntityName    
    }
    
    Foreach ($Parameter in $PSBoundParameters.GetEnumerator())
    {
      $Field = $Fields | Where-Object {$_.Name -eq $Parameter.Key}
      If ($Field -or $Parameter.Key -eq 'UserDefinedFields')
      { 
        If ($Field.IsPickList)
        {
          If($Field.PickListParentValueField)
          {
            $ParentField = $Fields.Where{$_.Name -eq $Field.PickListParentValueField}
            $ParentLabel = $PSBoundParameters.$($ParentField.Name)
            $ParentValue = $ParentField.PickListValues | Where-Object {$_.Label -eq $ParentLabel}
            $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $Parameter.Value -and $_.ParentValue -eq $ParentValue.Value}                
          }
          Else 
          { 
            $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $Parameter.Value}
          }
          $Value = $PickListValue.Value
        }
        ElseIf ($Field.Type -eq 'datetime')
        {
          # Yes, you really have to ADD the difference
          $Value = $Parameter.Value.AddHours($script:ESToffset)
        }
        Else
        {
          $Value = $Parameter.Value
        } 

        Foreach ($Object in $ProcessObject) 
        { 
          $Object.$($Parameter.Key) = $Value
        }
      }
    }
    $Result = New-AtwsData -Entity $ProcessObject
  }

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

    If ($PSCmdLet.ParameterSetName -eq 'Input_Object')
    {
      # Verify copy mode
      Foreach ($Object in $Result)
      {
        If ($InputObject.Id -contains $Object.Id)
        {
          Write-Verbose ('{0}: Autotask detected new object as duplicate of {1} with Id {2} and tried to update object, not create a new copy. ' -F $MyInvocation.MyCommand.Name, $EntityName, $Object.Id)
        }
      }
    }

    Return $Result
  }


}
