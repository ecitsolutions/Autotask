Import-Module AutotaskWebAPI

$username = 'gmax@office-center.no'
$password = ConvertTo-SecureString 'Alc3511%vol' -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username,$password) 

Connect-AutotaskWebAPI -Credential $credential



New-ATWSQuery ContractServiceUnit startdate equals '01.01.2016'

$Entities = $atws.getEntityInfo()

# Er det mulig å autogenerere cmdlets via informasjon hentet med GetEntity og GetFieldInfo? 
# Slik at connect-AutotaskWebApi lager get/set/new/remove-Entity basert på can create/read/update/delete?
# Det virker besnærende mulig...