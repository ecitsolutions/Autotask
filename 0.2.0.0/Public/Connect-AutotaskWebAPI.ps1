<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Connect-AutotaskWebAPI
{
  <#
      .SYNOPSIS
      This function connects to the Autotask Web Services API, authenticates a user and creates a 
      SOAP webservices proxy object. The connection object is cached on a per Prefix basis.
      .DESCRIPTION
      The function takes a credential object and uses it to authenticate and connect to the Autotask
      Web Services API. This is done by creating a webservices proxy. The proxy object imports the SOAP 
      WSDL definition file, creates all entity classes in PowerShell and exposes the basic methods
      (query(), create(), update(), remove(), GetEntityInfo(), GetFieldInfo() and a few more). 

      Using private functions this module continues to import information about entities and which fields
      each entity has. It uses this information to create and import a dynamic module pr Prefix. 
      Each module contains a complete set of PowerShell functions pr enntity. All entities gets a
      Get-PrefixEntity function. Any updateable entities gets a Set-PrefixEntity function. All 
      creatable entities gets a New-PrefixEntity function and all deletable objects gets a 
      Remove-PrefixEntity function.

      The per Prefix structure is important. It allows you to connect to Autotask with two or more 
      different user accounts from two or more different Autotask tenants. This will allow you to 
      automate between tenants. You can import and export data between tenants, transfer tickets, 
      updates tickets in tenant2 from tickets in tenant1 and so on.
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
  #>
	
  [cmdletbinding()]
  Param
  (
    [ValidateNotNullOrEmpty()]    
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
    
    If (-not($global:AtwsConnection))
    {
      $global:AtwsConnection = @{}
    }
  }
  
  Process
  { 
       
    
    # Make sure Windows does not try to add a domain to username
    # Prefix username with a backslash if nobody has added one yet
    # And make sure we stick to the local scope - important when debugging...
    If ($($local:Credential.UserName).Substring(0,1) -ne '\')
    {
      $local:Credential = New-Object System.Management.Automation.PSCredential("\$($local:Credential.UserName)",$($local:Credential.Password))
    }
    
    Write-Verbose ('{0}: Getting ZoneInfo for user {1} by calling default URI {2}' -F $MyInvocation.MyCommand.Name, $local:Credential.UserName, $DefaultUri)

    $RootService = New-WebServiceProxy -URI $DefaultUri
    $ZoneInfo = $RootService.getZoneInfo($local:Credential.UserName)
    If ($ZoneInfo.ErrorCode -ne 0)
    {
      Write-Error ('Invalid username "{0}". Try again.' -f $User)
      Return
    }
    
    Write-Verbose ('{0}: Customer tenant ID: {1}, Web URL: {2}, SOAP endpoint: {3}' -F $MyInvocation.MyCommand.Name, $ZoneInfo.CI, $ZoneInfo.WebUrl, $ZoneInfo.Url)
    
    $ModuleName = '{0}CI{1}' -F $Prefix, $ZoneInfo.CI    
    
    Write-Verbose ('{0}: Checking cached connections for Connection {1}' -F $MyInvocation.MyCommand.Name, $Prefix)
    
    If ($global:AtwsConnection.ContainsKey($Prefix))
    {
      Write-Verbose ('{0}: Cached connection {1} found. Checking credentials' -F $MyInvocation.MyCommand.Name, $Prefix)
      $SameUser = (('\{0}' -F $global:AtwsConnection[$Prefix].Credentials.Username) -eq $local:Credential.Username)
      $ModuleLoaded = Get-Module -Name $ModuleName
      If ($SameUser -and ($global:AtwsConnection[$Prefix].Credentials.Password -ne $local:Credential.GetNetworkCredential().Password))
      {
        Write-Verbose ('{0}: Password for connection {1} updated. Re-authenticating.' -F $MyInvocation.MyCommand.Name, $Prefix)
        $global:AtwsConnection.Remove($Prefix)
      }
      ElseIf($SameUser -and -not $NoFunctionImport -and -not ($ModuleLoaded))
      {
        Write-Verbose ('{0}: Credentials for connection {1} validated, but no dynamic module loaded. Loading module.' -F $MyInvocation.MyCommand.Name, $Prefix)  
      }
      ElseIf($SameUser)
      {
        Write-Verbose ('{0}: Credentials for connection {1} cached. Using cached connection.' -F $MyInvocation.MyCommand.Name, $Prefix)  
        Return
      }
      Else
      {
        Write-Verbose ('{0}: New credentials for connection {1} speficied. Creating new connection.' -F $MyInvocation.MyCommand.Name, $Prefix)  
        $global:AtwsConnection.Remove($Prefix)
      }

          
    }
    
    $Uri = $ZoneInfo.URL -replace 'atws.asmx','atws.wsdl'
    
    # Make sure a failure to create this object truly fails the script
    Write-Verbose ('{0}: Creating New-WebServiceProxy against URI: {1}' -F $MyInvocation.MyCommand.Name, $Uri)
    Try
    {
      # Create a new webservice proxy or die trying...
      $WebServiceProxy = New-WebServiceProxy -URI $Uri  -Credential $local:Credential -Namespace 'Autotask' -Class 'AutotaskAPI' -ErrorAction Stop
    }
    Catch
    {
      Throw [ApplicationException] 'Could not connect to Autotask WebAPI. Verify your credentials. If you are sure you have the rights - maybe you typed your password wrong?'    
    }
    <#
        If ($WebServiceProxy.Credentials.SecurePassword.Length -lt $local:Credential.Password.Length)
        {
        Write-Verbose ('{0}: Setting credential object of New-WebServiceProxy (when did this become necessary??)' -F $MyInvocation.MyCommand.Name)
        $WebServiceProxy.Credentials = $local:Credential
        }
    #>
    Write-Verbose ('{0}: Running query Get-AtwsData -Entity Account -Filter {{id -eq 0}}' -F $MyInvocation.MyCommand.Name)
    
    $global:AtwsConnection[$Prefix] = $WebServiceProxy
        
    $Result = Get-AtwsData -Connection $Prefix -Entity Account -Filter {id -eq 0}
    
    If ($Result)
    {
      If (-not $NoFunctionImport.IsPresent)
      {
                      
        Import-AtwsCmdLet -ModuleName $ModuleName -ExportToDisk:$ExportToDisk -Prefix $Prefix
      }
    }
    Else
    {
      $global:AtwsConnection.Remove($Prefix)
      Throw [ApplicationException] 'Could not complete a query to Autotask WebAPI. Verify your credentials. You seem to have been logged in, but do you have the necessary rights?'    
    }
  }
  
  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
  }
    
    
}
