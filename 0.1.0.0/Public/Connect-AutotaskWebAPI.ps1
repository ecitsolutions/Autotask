<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Connect-AutotaskWebAPI
{
   <#
      .SYNOPSIS
      This function connects to the Autotask Web Services API.
      .DESCRIPTION
      The function takes a credential object and uses it to authenticate and connect to the Autotask
      Web Services API
      .INPUTS
      A PSCredential object. Required. It will prompt for credentials if the object is not provided.
      .OUTPUTS
      A webserviceproxy object is created.
      .EXAMPLE
      Connect-AutotaskWebAPI
      Prompts for a username and password and authenticates to Autotask
      .EXAMPLE
      Connect-AutotaskWebAPI
      .NOTES
      NAME: Connect-AutotaskWebAPI
      .LINK
      Get-AtwsData
      New-AtwsQuery
  #>
	
    [cmdletbinding()]
    Param
    (
        [pscredential]
        $Credential = $(Get-Credential -Message 'Autotask Web Services API login'),
        
        [Switch]
        $Silent = $false
    )
    
    Do
    { 
        # Make sure Windows does not try to add a domain to username
        # Prefix username with a backslash if nobody has added one yet
        If ($($Credential.UserName).Substring(0,1) -ne '\')
        {
            $Credential = New-Object System.Management.Automation.PSCredential("\$($Credential.UserName)",$($Credential.Password))
        }
    
        # Start with a GetZoneInfo()
        $RootService = New-WebServiceProxy -URI https://webservices.Autotask.net/atservices/1.5/atws.wsdl 
        $ZoneInfo = $RootService.getZoneInfo($Credential.UserName)
        If ($ZoneInfo.ErrorCode -ne 0)
        {
            Write-Error ('Invalid username "{0}". Try again.' -f $User)
            $Credential = $(Get-Credential -Message 'Autotask Web Services API login')
        }
    }
    Until ($ZoneInfo.ErrorCode -eq 0 -or $Silent)
    
    $Uri = $ZoneInfo.URL -replace 'atws.asmx','atws.wsdl'
    
    # Make sure a failure to create this object truly fails the script
    $global:atws = New-WebServiceProxy -URI $Uri  -Credential $credential -Namespace 'Autotask' -Class 'AutotaskAPI' -ErrorAction Stop
    
    Return $global:atws
}
