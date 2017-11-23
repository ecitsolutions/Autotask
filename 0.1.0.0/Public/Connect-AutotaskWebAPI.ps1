Function Connect-AutotaskWebAPI
{
    [cmdletbinding()]
    Param
    (
        [pscredential]
        $Credential = $(Get-Credential -Message 'Autotask Web Services API login')
    )
    
    Do
    { 
        # Make sure Windows does not try to add a domain to username
        # Prefix username with a backslash if nobody has added one yet
        $User = $Credential.UserName
        If ($User.Substring(0,1) -ne '\')
        {
            $Credential = New-Object System.Management.Automation.PSCredential("\$($Credential.UserName)",$($Credential.Password))
        }
    
        # Start with a GetZoneInfo()
        $RootService = New-WebServiceProxy -URI https://webservices.Autotask.net/atservices/1.5/atws.wsdl 
        $ZoneInfo = $RootService.getZoneInfo($Credential.UserName)
        If ($ZoneInfo.ErrorCode -ne 0)
        {
            Write-Error 'Invalid username "{0}". Try again.' -f $User
            $Credential = $(Get-Credential -Message 'Autotask Web Services API login')
        }
    }
    Until ($ZoneInfo.ErrorCode -eq 0)
    
    $Uri = $ZoneInfo.URL -replace 'atws.asmx','atws.wsdl'
    
    # Make sure a failure to create this object truly fails the script
    #$PreviousPreference = $ErrorActionPreference
    #$ErrorActionPreference = 'STOP'
    $global:atws = New-WebServiceProxy -URI $Uri  -Credential $credential -Namespace 'Autotask' -Class 'AutotaskAPI' -ErrorAction Stop
    
    # Return the user to his preference
    #$ErrorActionPreference = $PreviousPreference
    
}
$Credential = Get-Credential
$usern = "\$($Credential.UserName)"