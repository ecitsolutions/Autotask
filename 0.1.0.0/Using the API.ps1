
Import-Module -name "C:\Git\Autotask"
help import-module
#$username = 'gmax@office-center.no'
#$password = ConvertTo-SecureString 'Alc3511%vol' -AsPlainText -Force
#$credential = New-Object System.Management.Automation.PSCredential($username,$password) 
$ATcredential = Get-Credential kristoffer@office-center.no -Message "Please enter credentials for Autotask!"


Connect-AutotaskWebAPI -Credential $credential



$temp = New-ATWSQuery ContractServiceUnit startdate equals '01.01.2016'

$Entities = $atws.getEntityInfo()

# Er det mulig å autogenerere cmdlets via informasjon hentet med GetEntity og GetFieldInfo? 
# Slik at connect-AutotaskWebApi lager get/set/new/remove-Entity basert på can create/read/update/delete?
# Det virker besnærende mulig...

https://office-center.visualstudio.com/Intern%20lab/_git/InternLab