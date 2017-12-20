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
    $NoFunctionImport = $False,
    
    [String]
    $Prefix = 'Atws',

    [Switch]
    $ExportToDisk = $False,
        
    [Switch]
    $Silent = $false
  )
    
  Begin
  { 
    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    $DefaultUri = 'https://webservices.Autotask.net/atservices/1.5/atws.wsdl'
  }
  
  Process
  { 
       
    
    # Make sure Windows does not try to add a domain to username
    # Prefix username with a backslash if nobody has added one yet
    If ($($Credential.UserName).Substring(0,1) -ne '\')
    {
      $Credential = New-Object System.Management.Automation.PSCredential("\$($Credential.UserName)",$($Credential.Password))
    }
    
    Write-Verbose ('{0}: Getting ZoneInfo for user {1} by calling default URI {2}' -F $MyInvocation.MyCommand.Name, $Credential.UserName, $DefaultUri)

    $RootService = New-WebServiceProxy -URI $DefaultUri
    $ZoneInfo = $RootService.getZoneInfo($Credential.UserName)
    If ($ZoneInfo.ErrorCode -ne 0)
    {
      Write-Error ('Invalid username "{0}". Try again.' -f $User)
      Return
    }
    
    Write-Verbose ('{0}: Customer tenant ID: {1}, Web URL: {2}, SOAP endpoint: {3}' -F $MyInvocation.MyCommand.Name, $ZoneInfo.CI, $ZoneInfo.WebUrl, $ZoneInfo.Url)
    
    $Uri = $ZoneInfo.URL -replace 'atws.asmx','atws.wsdl'
    
    # Make sure a failure to create this object truly fails the script
    Write-Verbose ('{0}: Creating New-WebServiceProxy against URI: {1}' -F $MyInvocation.MyCommand.Name, $Uri)
    $global:atws = New-WebServiceProxy -URI $Uri  -Credential $credential -Namespace 'Autotask' -Class 'AutotaskAPI' -ErrorAction Stop
    
    If ($atws.Credentials.SecurePassword.Length -lt $Credential.Password.Length)
    {
      Write-Verbose ('{0}: Setting credential object of New-WebServiceProxy (when did this become necessary??)' -F $MyInvocation.MyCommand.Name)
      $atws.Credentials = $Credential
    }
 
    
    Write-Verbose ('{0}: Running query Get-AtwsData -Entity Account -Filter {{id -eq 0}}' -F $MyInvocation.MyCommand.Name)
    
    $Result = Get-AtwsData -Entity Account -Filter {id -eq 0}
    
    If (($Result) -and -not ($NoFunctionImport))
    {
      Import-AtwsCmdLet -ExportToDisk:$ExportToDisk -Prefix $Prefix
    }

  }
  
  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
  }
    
    
}
