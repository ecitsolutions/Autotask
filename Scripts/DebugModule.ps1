<#

    Just a script so we have a workbench we can invoke to debug session.
    This is basically a workflow of what we need to write tests for as well.
#>


# $SandBoxDomain = '@ECITSOLUTIONSSB12032021.NO'
$moduleName = 'Autotask'
$RootPath = 'C:\Git\Autotask'
$modulePath = '{0}\{1}' -F $RootPath, $ModuleName
Import-Module $modulePath -Force -ErrorAction Stop

Connect-AtwsWebAPI -ProfileName Production

$Contacts = Get-AtwsContact -FirstName 'Bjørn' -Like FirstName -Active $true
$name = ("All Bears in the hood {0}" -f (New-Guid).Guid.Substring(0, 7))
$ContactGroup = New-AtwsContactGroup -Active $true -Name $name

# $ContactGroup = New-AtwsContactGroup -InputObject ([Autotask.ContactGroup]@{
#         Active = $true;
#         Name   = ("All Bears in the hood {0}" -f (New-Guid).Guid.Substring(0, 7))
#     })


$ContactSelection = [System.Collections.Generic.List[Autotask.ContactGroupContact]]::new()
# $ContactSelection = @()
$Contacts.foreach{
    $tmp = [Autotask.ContactGroupContact]@{
        ContactGroupID = $ContactGroup.id;
        ContactID      = $_.id;
    }
    $ContactSelection.add($tmp)
    # $ContactSelection += $tmp
}

Set-AtwsModuleConfiguration -ErrorLimit 15

$group = New-AtwsContactGroupContact -InputObject $ContactSelection -Verbose


Set-AtwsContactGroup -InputObject $ContactGroup -Active $false
Remove-AtwsContactGroup -InputObject $ContactGroup

#Region UDF Local Property Change testing

$myIds = @(
    29967890
    30065331
    30134371
    30134376
    30168125
    30203575
    30203691
    30217565
    30262369
    30394538
    30394629
)


# $Config = Get-AtwsModuleConfiguration -Name Sandbox
# $Config | Set-AtwsModuleConfiguration -UdfExpansion Hashtable -PickListExpansion LabelField
# Connect-AtwsWebAPI -AtwsModuleConfiguration $Config
# Save-AtwsModuleConfiguration -Configuration $Config -Name Sandbox
Connect-AtwsWebAPI -ProfileName Sandbox

# Get-AtwsAccount -id 0 | Select-Object udf -ExpandProperty UDF | gm

$Devices = Get-AtwsInstalledProduct -id $myIds
# $Devices[0].UDF | gm
# $Devices[0].UDF.Contains('Maskin navn')
# $Devices[0].UDF['Maskin navn'] = 'test'

$udfs = @()
$Devices.foreach{
    $udf = $_.UserDefinedFields.where{$_.Name -eq 'Maskin navn'}
    $udfs += [Autotask.UserDefinedField]@{Name = 'Maskin navn'; Value = "test $($_.id)" }
    "$($_.ID) udfValue $("test $($_.id)")"
}

<#
    29967890 udfValue test 29967890
    30065331 udfValue test 30065331
    30134371 udfValue test 30134371
    30134376 udfValue test 30134376
    30168125 udfValue test 30168125
    30203575 udfValue test 30203575
    30203691 udfValue test 30203691
    30217565 udfValue test 30217565
    30262369 udfValue test 30262369
    30394538 udfValue test 30394538
    30394629 udfValue test 30394629
#>

# Set-AtwsInstalledProduct -InputObject $Devices[0] -UserDefinedFields @{Name = 'Maskin navn'; Value = $Devices[0].UDF['Maskin navn'] } -Verbose -PassThru | Select-Object -ExpandProperty UDF
Set-AtwsInstalledProduct -InputObject $Devices -UserDefinedFields $udfs
$ModifiedDevices = Get-AtwsInstalledProduct -id $Devices.id
$ModifiedDevices.foreach{
    "{0} ModifiedUDFValue {1}" -f $_.ID, $_.UserDefinedFields.where{ $_.Name -eq 'Maskin navn' }.Value
}

<#
    29967890 ModifiedUDFValue test 30394629
    30065331 ModifiedUDFValue test 30394629
    30134371 ModifiedUDFValue test 30394629
    30134376 ModifiedUDFValue test 30394629
    30168125 ModifiedUDFValue test 30394629
    30203575 ModifiedUDFValue test 30394629
    30203691 ModifiedUDFValue test 30394629
    30217565 ModifiedUDFValue test 30394629
    30262369 ModifiedUDFValue test 30394629
    30394538 ModifiedUDFValue test 30394629
    30394629 ModifiedUDFValue test 30394629
#>

$Devices.ForEach{
    $_.UserDefinedFields = $_.Notes + '      ' + (New-Guid).Guid
}


#EndRegion

#Region test bulk changlog local var and passing this to set-atwsinstalledproduct. the module/api is supposed to set the new property and detect change automatically.
Connect-AtwsWebAPI -ProfileName Sandbox

Get-AtwsAccount -id 0 | select accountname

$Devices = Get-AtwsInstalledProduct -Type Server -Active $true -Notes ' ' -NotEquals Notes

$myIds = @(
    29967890
    30065331
    30134371
    30134376
    30168125
    30203575
    30203691
    30217565
    30262369
    30394538
    30394629
)

$Devices = Get-AtwsInstalledProduct -id $myIds
($Devices | group Notes).Name
<# Output: Before:
    Microsoft Windows Server 2008 R2 Standard 6.1.7601 SP Service Pack 1
    Microsoft Windows Server 2012 R2 Standard 6.3.9600
    Microsoft Windows Server 2012 Standard 6.2.9200
#>

# Make changes to a collection of devices Properties
$Devices.ForEach{
    $_.Notes = $_.Notes + '      ' + (New-Guid).Guid
}

#Send these changes into the soap API that should handle these changes as we set them.
$ChangedDevices = Set-AtwsInstalledProduct -InputObject $Devices -PassThru
($ChangedDevices | Group-Object Notes).Name
<#  returned Output: 
    Microsoft Windows Server 2008 R2 Standard 6.1.7601 SP Service Pack 1      1ceb02cf-0d21-4e3d-a4be-b3b5aff412f0        
    Microsoft Windows Server 2008 R2 Standard 6.1.7601 SP Service Pack 1      4462d0cb-c491-4e20-9491-3190840c2d14        
    Microsoft Windows Server 2008 R2 Standard 6.1.7601 SP Service Pack 1      5670cccf-b066-404f-9365-c7287f57c4fa        
    Microsoft Windows Server 2008 R2 Standard 6.1.7601 SP Service Pack 1      59cb4e5a-52fb-47a9-a1e8-fe3ef8bf1036        
    Microsoft Windows Server 2008 R2 Standard 6.1.7601 SP Service Pack 1      88b4522f-b403-4fcd-b42d-d893872251f3        
    Microsoft Windows Server 2008 R2 Standard 6.1.7601 SP Service Pack 1      92ee0ea9-08b9-4b63-ad5a-1e5777fda04e        
    Microsoft Windows Server 2008 R2 Standard 6.1.7601 SP Service Pack 1      be6ca660-95a3-4b9d-a10c-57f1af9955bd        
    Microsoft Windows Server 2008 R2 Standard 6.1.7601 SP Service Pack 1      cebd3d4b-7ce1-45c9-b74b-b066a56fdfd7        
    Microsoft Windows Server 2012 R2 Standard 6.3.9600       17f9ff25-d085-4de3-8aee-d428c7895efa
    Microsoft Windows Server 2012 R2 Standard 6.3.9600       69e2c59f-9b6b-4399-bbeb-1345121372e1
    Microsoft Windows Server 2012 Standard 6.2.9200       f0d76741-c243-4c47-b0c9-027e189f0822
#>

#Retrieve the same collection of devices again to check that we got the same information back again. 
the module should handle this and return the correct properties with -PassThru
$ChangedDevices = Get-AtwsInstalledProduct -id $myIds
($ChangedDevices | Group-Object Notes).Name
<#

    Microsoft Windows Server 2008 R2 Standard 6.1.7601 SP Service Pack 1      1ceb02cf-0d21-4e3d-a4be-b3b5aff412f0
    Microsoft Windows Server 2008 R2 Standard 6.1.7601 SP Service Pack 1      4462d0cb-c491-4e20-9491-3190840c2d14
    Microsoft Windows Server 2008 R2 Standard 6.1.7601 SP Service Pack 1      5670cccf-b066-404f-9365-c7287f57c4fa        
    Microsoft Windows Server 2008 R2 Standard 6.1.7601 SP Service Pack 1      59cb4e5a-52fb-47a9-a1e8-fe3ef8bf1036        
    Microsoft Windows Server 2008 R2 Standard 6.1.7601 SP Service Pack 1      88b4522f-b403-4fcd-b42d-d893872251f3        
    Microsoft Windows Server 2008 R2 Standard 6.1.7601 SP Service Pack 1      92ee0ea9-08b9-4b63-ad5a-1e5777fda04e        
    Microsoft Windows Server 2008 R2 Standard 6.1.7601 SP Service Pack 1      be6ca660-95a3-4b9d-a10c-57f1af9955bd        
    Microsoft Windows Server 2008 R2 Standard 6.1.7601 SP Service Pack 1      cebd3d4b-7ce1-45c9-b74b-b066a56fdfd7        
    Microsoft Windows Server 2012 R2 Standard 6.3.9600       17f9ff25-d085-4de3-8aee-d428c7895efa
    Microsoft Windows Server 2012 R2 Standard 6.3.9600       69e2c59f-9b6b-4399-bbeb-1345121372e1
    Microsoft Windows Server 2012 Standard 6.2.9200       f0d76741-c243-4c47-b0c9-027e189f0822
#>

#EndRegion

