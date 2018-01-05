#######################################################
# Script file for testing of module and functionality #
#######################################################
Remove-Module Autotask
Import-Module -Name "C:\Git\Autotask" -RequiredVersion 0.2.0.0

Connect-AutotaskWebAPI
$entities = $atws.getEntityInfo()

New-ATWSQuery ContractServiceUnit startdate equals '01.01.2016'

$atws | gm
$entities | gm

$contracts = Get-AtwsContract -ContractCategory 'Ikke Oppdatert' -Status Active
$contracts = Get-AtwsContract -ContractCategory Oppdatert -Status Inactive
$contracts.Count
foreach ($contract in $contracts) {
    $contract.ContractCategory = 18 
    Set-AtwsData $contract
}
$contracts.Contractcategory
($contracts[0..199]).count

$atws.GetFieldInfo('Contract.Contractcategory').name