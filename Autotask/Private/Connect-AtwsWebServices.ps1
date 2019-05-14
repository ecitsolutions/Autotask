<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md  for license information.

#>

Function Connect-AtwsWebServices {
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
      Connect-AtwsWebAPI
      Prompts for a username and password and authenticates to Autotask
      .EXAMPLE
      Connect-AtwsWebAPI
      .NOTES
      NAME: Connect-AtwsWebAPI
      .LINK
      Get-AtwsData
  #>
	
  [cmdletbinding()]
  [Alias('Connect-AutotaskWebAPI')]
  Param
  (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]    
    [pscredential]
    $Credential,
    
    [Parameter(Mandatory = $true)]
    [String]
    $ApiTrackingIdentifier,
    
    [Switch]
    $NoDiskCache
  )
    
  Begin { 
    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
    $DefaultUri = 'https://webservices.Autotask.net/atservices/1.6/atws.wsdl'
    
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
    
    If ($NoDiskCache.IsPresent)
    {
      $Script:UseDiskCache = $False
    }
    Else 
    {
      $Script:UseDiskCache = $True    
    }
  }
  
  Process { 
    ## Preparing for a progressbar
    # Prepare parameters for @splatting
    $ProgressParameters = @{
      Activity = 'Creating and importing functions for all Autotask entities.'
      Id = 4
    }
    
    # Make sure Windows does not try to add a domain to username
    # Prefix username with a backslash if nobody has added one yet
    # And make sure we stick to the local scope - important when debugging...
    If ($($local:Credential.UserName).Substring(0, 1) -ne '\') {
      $local:Credential = New-Object System.Management.Automation.PSCredential("\$($local:Credential.UserName)", $($local:Credential.Password))
    }
    
    # Post progress info to console
    Write-Verbose ('{0}: Getting ZoneInfo for user {1} by calling default URI {2}' -F $MyInvocation.MyCommand.Name, $local:Credential.UserName, $DefaultUri)
    Write-Progress -Status 'Creating connection' -PercentComplete 1 -CurrentOperation 'Locating correct datacenter' @ProgressParameters
    
    # First make an unauthenticated call to the DefaultURI to determine correct
    # web services endpoint for the user we are going to authenticate as
    $RootService = New-WebServiceProxy -URI $DefaultUri
    
    # Get ZoneInfo for username
    $ZoneInfo = $RootService.getZoneInfo($local:Credential.UserName)
    
    # If we get an error the username is almost certainly misspelled or nonexistant
    If ($ZoneInfo.ErrorCode -ne 0) {
      Write-Progress -Status 'Creating connection' -PercentComplete 100 -CurrentOperation 'Operation failed' @ProgressParameters
            
      Throw [ApplicationException] ('Invalid username "{0}". Try again.' -f $local:Credential.UserName)
      
    }
    
    # If we get to here the username exists and we have the information we need to try to authenticate
    Write-Verbose ('{0}: Customer tenant ID: {1}, Web URL: {2}, SOAP endpoint: {3}' -F $MyInvocation.MyCommand.Name, $ZoneInfo.CI, $ZoneInfo.WebUrl, $ZoneInfo.Url)
    
    # Post progress to console
    Write-Progress -Status 'Datacenter located' -PercentComplete 30 -CurrentOperation 'Authenticating to web service' @ProgressParameters
          
    # Pick the correct web services endpoint for the current username
    # and change it to point at the WSDL definitoin
    $Uri = $ZoneInfo.URL -replace 'atws.asmx', 'atws.wsdl'
    
    # Make sure a failure to create this object truly fails the script
    Write-Verbose ('{0}: Creating New-WebServiceProxy against URI: {1}' -F $MyInvocation.MyCommand.Name, $Uri)
    Try {
      # Create a new webservice proxy or die trying...
      $script:Atws = New-WebServiceProxy -URI $Uri  -Credential $local:Credential -Namespace 'Autotask' -Class 'AutotaskAPI' -ErrorAction Stop
      # Make sure the webserviceproxy authenticates every time (saves a webconnection and a few milliseconds)
      $script:Atws.PreAuthenticate = $True
      
      ## Add API Integrations Value 
      # A dedicated object type has been created to store integration values
      $AutotaskIntegrationsValue = New-Object Autotask.AutotaskIntegrations

      # Set the integrationcode property to the API tracking identifier provided by the user
      $AutotaskIntegrationsValue.IntegrationCode = $ApiTrackingIdentifier

      # Add the integrations value to the Web Service Proxy
      $script:Atws.AutotaskIntegrationsValue = $AutotaskIntegrationsValue
        
      ## Add tenant identifier to connection
      Add-Member -InputObject $script:Atws -MemberType NoteProperty -Name CI -Value $ZoneInfo.CI -Force

    }
    Catch {
      Throw [ApplicationException] 'Could not connect to Autotask WebAPI. Verify your credentials. If you are sure you have the rights - maybe you typed your password wrong?'    
    }
    
   
    Write-Verbose ('{0}: Running query Get-AtwsData -Entity Resource -Filter "username -eq $UserName"' -F $MyInvocation.MyCommand.Name)
    
    Write-Progress -Status 'Connected' -PercentComplete 60 -CurrentOperation 'Testing connection' @ProgressParameters
       
    # Get username part of credential
    $UserName = $Credential.UserName.Split('@')[0].Trim('\')
    $Result = Get-AtwsData -Entity Resource -Filter "username -eq $UserName"
    
    If ($Result) {
    
      # The connection has been verified. Use it to dynamically create functions for all entities
      Write-Progress -Status 'Connection OK' -PercentComplete 90 -CurrentOperation 'Importing dynamic module' @ProgressParameters
        
      Write-Verbose ('{0}: Loading disk cache' -F $MyInvocation.MyCommand.Name)
      
      Import-AtwsDiskCache
      
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
      Remove-Variable -Name Atws -Scope Script
      Throw [ApplicationException] 'Could not complete a query to Autotask WebAPI. Verify your credentials. You seem to have been logged in, but do you have the necessary rights?'    
    }
  }
  
  End {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    Write-Progress -Status 'Completed' -PercentComplete 100 -CurrentOperation 'Done' @ProgressParameters
       
  }
    
    
}
