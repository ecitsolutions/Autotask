#requires -Version 4.0
#requires -Assembly System.ServiceModel

$cs = get-childitem .\Autotask\Reference.cs

$assemblies = @(
    'System.ServiceModel'
    'System.ServiceModel.Duplex' 
    'System.ServiceModel.Http'
    'System.ServiceModel.NetTcp'
    'System.ServiceModel.Security'
    'System.Diagnostics.Debug'
    'System.Xml'
    'System.Xml.ReaderWriter'
    'System.Runtime.Serialization'
)
Add-Type -TypeDefinition (get-content -raw $cs.FullName) -ReferencedAssemblies $assemblies

$defaultConfig = [Autotask.ATWSSoapClient+EndpointConfiguration]::ATWSSoap

$binding = [ServiceModel.BasicHttpsBinding]::new()
$binding.Security.Transport.ClientCredentialType = [ServiceModel.HttpClientCredentialType]::Basic
$binding.Security.Mode = [ServiceModel.BasicHttpsSecurityMode]::Transport

$endPoint = [ServiceModel.EndpointAddress]::new('https://webservices4.Autotask.net/atservices/1.6/atws.asmx')

#$atws = [Autotask.ATWSSoapClient]::new($defaultConfig, $endPoint)
$atws = [Autotask.ATWSSoapClient]::new($binding, $endPoint)

# Set username and password immediately as the first two methods to call
$atws.ClientCredentials.UserName.UserName = $Credential.UserName
$atws.ClientCredentials.UserName.Password = $Credential.GetNetworkCredential().Password

# Turn on authentication
#$atws.Endpoint.Binding.Security.Transport.ClientCredentialType = [ServiceModel.HttpClientCredentialType]::Basic

$atws.getZoneInfo($Credential.UserName)




$integrationsValue = New-Object Autotask.AutotaskIntegrations
$integrationsValue.IntegrationCode = $ApiTrackingIdentifier

$query = @'
<queryxml>
    <entity>Account</entity>
    <query>
        <condition>
            <field>id
                <expression op="equals">0</expression>
            </field>
        </condition>
    </query>
</queryxml>
'@

$result = $atws.query($integrationsValue, $query)