
#$Credentials = Get-Credential
$User = "username@domain"
$PWord = ConvertTo-SecureString -String "password" -AsPlainText -Force
$Credentials = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $User, $PWord

# Add .NET support for TLS 1.2 if missing
$Protocol = [System.Net.ServicePointManager]::SecurityProtocol
If ($Protocol.ToString() -notlike '*Tls12*') { 
  [System.Net.ServicePointManager]::SecurityProtocol += 'tls12'
}

# Modify for correct services URI
$atws = New-WebServiceProxy -URI https://webservices4.Autotask.net/atservices/1.5/atws.wsdl -Credential $credentials

$QueryXML = @"
<queryxml>
  <entity>Account</entity>
  <query>
    <field>id
      <expression op="Equals">0</expression>
    </field>
  </query>
</queryxml>
"@

$Result = $Atws.query($QueryXML)

If ($Result.ReturnCode -eq 1) {
  Write-Output "Account query returned no errors, connection seems fine."
}

Foreach ($Err in $Result.Errors) {
  Write-Output $Err.message
}

# Get username part of credential
$UserName = $Credentials.UserName.Split('@')[0].Trim('\')

Write-Output "Username: $Username "

$QueryXML = @"
<queryxml>
  <entity>Resource</entity>
  <query>
    <field>username
      <expression op="Equals">$UserName</expression>
    </field>
  </query>
</queryxml>
"@

$Result = $Atws.query($QueryXML)

If ($Result.ReturnCode -eq 1) {
  Write-Output "Username query returned no errors, connection seems fine."
}

Foreach ($Err in $Result.Errors) {
  Write-Output $Err.message
}

