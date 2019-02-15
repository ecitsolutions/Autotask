<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md  for license information.

#>

Function Connect-AutotaskWebAPI {
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
    
    [Parameter(Mandatory = $true)]
    [String]
    $ApiTrackingIdentifier,
    
    [ValidatePattern('[a-zA-Z0-9]')]
    [ValidateLength(1, 8)]
    [String]
    $Prefix = 'Atws',

    [Switch]
    $NoDiskCache,

    [Switch]
    $RefreshCache
  )
    
  Begin { 
    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
    $DefaultUri = 'https://webservices.Autotask.net/atservices/1.6/atws.wsdl'
    
    If (-not($script:AtwsConnection)) {
      $script:AtwsConnection = @{}
    }

    # Unless warning level is specified explicitly - Show warnings!
    If (-not ($WarningAction)) {
      $Global:WarningPreference = 'Continue'
    }

    # Load support for TLS 1.2 if the Service Point Manager haven't loaded it yet
    # This is now a REQUIREMENT to talk to the API endpoints
    $Protocol = [System.Net.ServicePointManager]::SecurityProtocol
    If ($Protocol.ToString() -notlike '*Tls12*') { 
        [System.Net.ServicePointManager]::SecurityProtocol += 'tls12'
    }
  }
  
  Process { 
    # Preparing for a progressbar
    $ProgressActivity = 'Connecting to Autotask Web Services API'
    $ProgressID = 1
       
    # Make sure Windows does not try to add a domain to username
    # Prefix username with a backslash if nobody has added one yet
    # And make sure we stick to the local scope - important when debugging...
    If ($($local:Credential.UserName).Substring(0, 1) -ne '\') {
      $local:Credential = New-Object System.Management.Automation.PSCredential("\$($local:Credential.UserName)", $($local:Credential.Password))
    }
    
    # Post progress info to console
    Write-Verbose ('{0}: Getting ZoneInfo for user {1} by calling default URI {2}' -F $MyInvocation.MyCommand.Name, $local:Credential.UserName, $DefaultUri)
    Write-Progress -Id $ProgressID -Activity $ProgressActivity -Status 'Creating connection' -PercentComplete 1 -CurrentOperation 'Locating correct datacenter'
    
    # First make an unauthenticated call to the DefaultURI to determine correct
    # web services endpoint for the user we are going to authenticate as
    $RootService = New-WebServiceProxy -URI $DefaultUri
    
    # Get ZoneInfo for username
    $ZoneInfo = $RootService.getZoneInfo($local:Credential.UserName)
    
    # If we get an error the username is almost certainly misspelled or nonexistant
    If ($ZoneInfo.ErrorCode -ne 0) {
      Write-Progress -Id $ProgressID -Activity $ProgressActivity -Status 'Creating connection' -PercentComplete 100 -CurrentOperation 'Operation failed' 
            
      Write-Error ('Invalid username "{0}". Try again.' -f $local:Credential.UserName)
      Return
    }
    
    # If we get to here the username exists and we have the information we need to try to authenticate
    Write-Verbose ('{0}: Customer tenant ID: {1}, Web URL: {2}, SOAP endpoint: {3}' -F $MyInvocation.MyCommand.Name, $ZoneInfo.CI, $ZoneInfo.WebUrl, $ZoneInfo.Url)
    
    # First check if we are already authenticated, the user may just wish to refresh entity and/or fieldinfo
    Write-Verbose ('{0}: Checking cached connections for Connection {1}' -F $MyInvocation.MyCommand.Name, $Prefix)
    
    # Post progress to console
    Write-Progress -Id $ProgressID -Activity $ProgressActivity -Status 'Datacenter located' -PercentComplete 20 -CurrentOperation 'Checking for cached connections'
        
    # If we already have a connection and noone has asked to refresh the cache
    If ($script:AtwsConnection.ContainsKey($Prefix) -and -not $RefreshCache.IsPresent) {
      
      # Maybe the user is trying to connect with a different set of credentials?
      Write-Verbose ('{0}: Cached connection {1} found. Checking credentials' -F $MyInvocation.MyCommand.Name, $Prefix)
      
      # Make a boolean of the username test. We are reusing this test in multiple IF conditions
      $SameUser = (('\{0}' -F $script:AtwsConnection[$Prefix].Credentials.Username) -eq $local:Credential.Username)
      
      # Trying to connect using a different password. Remove the connection object and try again. 
      # Unfortunately this is a bit hit or miss due to .NET caching outside of PowerShell
      If ($SameUser -and ($script:AtwsConnection[$Prefix].Credentials.Password -ne $local:Credential.GetNetworkCredential().Password)) {
        Write-Verbose ('{0}: Password for connection {1} updated. Re-authenticating.' -F $MyInvocation.MyCommand.Name, $Prefix)
        $script:AtwsConnection.Remove($Prefix)
      }
      # The credentials are the same. Skip authentication and reuse the existing webproxy object. Dunno why
      # this function is run again, but we should assume there is a valid reason.
      ElseIf ($SameUser) {
        Write-Verbose ('{0}: Credentials for connection {1} cached. Using cached connection.' -F $MyInvocation.MyCommand.Name, $Prefix)  
        
        Write-Progress -Id $ProgressID -Activity $ProgressActivity -Status 'Cached connection found' -PercentComplete 100 -CurrentOperation 'Using cached connection'
      }
      # A different username. The user may need to reauthenticate due to access rights. No matter,
      # remove the existing connection and create a new one, authentication with the new credentials.
      Else {
        Write-Verbose ('{0}: New credentials for connection {1} speficied. Creating new connection.' -F $MyInvocation.MyCommand.Name, $Prefix)  
        $script:AtwsConnection.Remove($Prefix)
      }

          
    }
    
    If (-not $script:AtwsConnection.ContainsKey($Prefix) ) { 
      # If we get here we need to create a new connection. Either this is the first time the user connects in this PowerShell
      # session or the credentials have been changed.
      Write-Progress -Id $ProgressID -Activity $ProgressActivity -Status 'No re-usable, cached connection' -PercentComplete 40 -CurrentOperation 'Authenticating to web service'
    
      # Pick the correct web services endpoint for the current username
      # and change it to point at the WSDL definitoin
      $Uri = $ZoneInfo.URL -replace 'atws.asmx', 'atws.wsdl'
    
      # Make sure a failure to create this object truly fails the script
      Write-Verbose ('{0}: Creating New-WebServiceProxy against URI: {1}' -F $MyInvocation.MyCommand.Name, $Uri)
      Try {
        # Create a new webservice proxy or die trying...
        $WebServiceProxy = New-WebServiceProxy -URI $Uri  -Credential $local:Credential -Namespace 'Autotask' -Class 'AutotaskAPI' -ErrorAction Stop
        # Make sure the webserviceproxy authenticates every time (saves a webconnection and a few milliseconds)
        $WebServiceProxy.PreAuthenticate = $True
      
        # Add API Integrations Value if API version is 1.6
      
        # A dedicated object type has been created to store integration values
        $AutotaskIntegrationsValue = New-Object Autotask.AutotaskIntegrations

        # Set the integrationcode property to the API tracking identifier provided by the user
        $AutotaskIntegrationsValue.IntegrationCode = $ApiTrackingIdentifier

        # Add the integrations value to the Web Service Proxy
        $WebServiceProxy.AutotaskIntegrationsValue = $AutotaskIntegrationsValue

      }
      Catch {
        Throw [ApplicationException] 'Could not connect to Autotask WebAPI. Verify your credentials. If you are sure you have the rights - maybe you typed your password wrong?'    
      }
    }
    Write-Verbose ('{0}: Testing Credential object of WebServiceProxy against a .NET bug that will reuse earlier connection attempts.' -F $MyInvocation.MyCommand.Name)

    # This is a bug that sometimes crop up if you have made a connection attempt using wrong or misspelled passwords.
    # Make sure the right (newest) password is used when calling the Web Service Proxy.
    If ($WebServiceProxy.Credentials.Password -ne $local:Credential.GetNetworkCredential().Password) {
      Write-Verbose ('{0}: Overwriting WebServiceProxy password "manually".' -F $MyInvocation.MyCommand.Name)
      $WebServiceProxy.Credentials = $local:Credential
    }
    
    Write-Verbose ('{0}: Running query Get-AtwsData -Entity Resource -Filter "username -eq $UserName"' -F $MyInvocation.MyCommand.Name)
    
    Write-Progress -Id $ProgressID -Activity $ProgressActivity -Status 'Connected' -PercentComplete 60 -CurrentOperation 'Testing connection'
       
    $script:AtwsConnection[$Prefix] = $WebServiceProxy
    
    # Get username part of credential
    $UserName = $Credential.UserName.Split('@')[0].Trim('\')
    $Result = Get-AtwsData -Connection $Prefix -Entity Resource -Filter "username -eq $UserName"
    
    If ($Result) {
    
      # The connection has been verified. Use it to dynamically create functions for all entities
      Write-Progress -Id $ProgressID -Activity $ProgressActivity -Status 'Connection OK' -PercentComplete 80 -CurrentOperation 'Importing dynamic module'
        
      Write-Verbose ('{0}: Calling Import-AtwsCmdLet with Prefix {1}' -F $MyInvocation.MyCommand.Name, $Prefix)
                    
      Import-AtwsCmdLet -Prefix $Prefix -NoDiskCache:$NoDiskCache.IsPresent -RefreshCache:$RefreshCache.IsPresent -Verbose:$Verbose.IsPresent
      
      
      # Check date and time formats and warn if the are different. This will affect how dates as text will be converted to datetime objects

      $CultureInfo = ([CultureInfo]::CurrentCulture).DateTimeFormat

      If ($Result.DateFormat -ne $CultureInfo.ShortDatePattern -and $Result.TimeFormat -ne $CultureInfo.ShortTimePattern) {
        Write-host 'WARNING: DATE and TIME format of the current Autotask user should be updated to match local computer. Otherwise you risk that the API interprets your date and time entries wrong.' -ForegroundColor DarkYellow
        Write-Host ('Log on to Autotask and edit resource {0}. Change Date format to "{1}" and Time format to "{2}"' -F $username, $CultureInfo.ShortDatePattern, $CultureInfo.ShortTimePattern) -ForegroundColor DarkYellow
      }
      ElseIf ($Result.DateFormat -ne $CultureInfo.ShortDatePattern) {
        Write-host 'WARNING: DATE format of the current Autotask user should be updated to match local computer. Otherwise you risk that the API interprets your date entries wrong.' -ForegroundColor DarkYellow
        Write-Host ('Log on to Autotask and edit resource {0}. Change Date format to "{1}"' -F $username, $CultureInfo.ShortDatePattern) -ForegroundColor DarkYellow
      }

      ElseIf ($Result.TimeFormat -ne $CultureInfo.ShortTimePattern) {
        Write-host 'WARNING: TIME format of the current Autotask user should be updated to match local computer. Otherwise you risk that the API interprets your time entries wrong.' -ForegroundColor DarkYellow
        Write-Host ('Log on to Autotask and edit resource {0}. Change Time format to "{1}"' -F $username, $CultureInfo.ShortTimePattern) -ForegroundColor DarkYellow
      }
    }
    Else {
      $script:AtwsConnection.Remove($Prefix)
      Throw [ApplicationException] 'Could not complete a query to Autotask WebAPI. Verify your credentials. You seem to have been logged in, but do you have the necessary rights?'    
    }
  }
  
  End {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    Write-Progress -Id $ProgressID -Activity $ProgressActivity -Status 'Completed' -PercentComplete 100 -CurrentOperation 'Done' 
    Write-Progress -Id $ProgressID -Activity $ProgressActivity -Status 'Completed' -PercentComplete 100 -CurrentOperation 'Done'  -Completed 
        
        
  }
    
    
}
