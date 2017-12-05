#######################################################
# Script file for testing of module and functionality #
#######################################################

Import-Module -Name "C:\Git\Autotask"

Connect-AutotaskWebAPI
$entities = $atws.getEntityInfo()

New-ATWSQuery ContractServiceUnit startdate equals '01.01.2016'

$atws | gm
$entities | gm

$contracts = $atws.getEntity()