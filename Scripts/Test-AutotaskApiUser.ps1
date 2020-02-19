<#

    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

#>

Function Test-AutotaskApiUser {
  <#
      .SYNOPSIS
      This functions logs on to the API with your credentials for testing purposes only. No module is imported.
      .DESCRIPTION
      This functions takes a credential and an ApiTracking code and test them against the version 1.6 API
      endpoint of the Autotask Web Api. The script is only meant as a test of your credentials and to make 
      sure they work with PowerShell access to the API.

      Note of warning: A successfully created Web Service Proxy object is created in the .NET environment
      outside of PowerShell. During testing I have not yet been able to delete preexisting objects entirely
      and they seem to be connected to the URI. As soon as you have created an object successfully with a set
      of credentials you will be unable to recreate it completely with a different set of credentials. I.E.
      this test only works reliably the first time you run it.
      .INPUTS
      A PSCredential object. Required. 
      A string used as ApiTrackingIdentifier. Required. 
      .OUTPUTS
      Text.
      .EXAMPLE
      Test-AutotaskApiUser -Credential $Credential -ApiTrackingIdentifier $String
      .NOTES
      NAME: Test-AutotaskApiUser
  #>
	
  [cmdletbinding()]

  Param
  (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]    
    [pscredential]
    $Credential,
    
    [Parameter(Mandatory = $true)]
    [String]
    $ApiTrackingIdentifier,
    
    [String]
    $NameSpace = "TestAutotask$PID" # Unique namespace to avoid .NET confusion
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

      Write-Output ('{0}: Adding slash prefix for user {1} to avoid Windows adding a SMB authentication domain' -F $MyInvocation.MyCommand.Name, $local:Credential.UserName)

      $local:Credential = New-Object System.Management.Automation.PSCredential("\$($local:Credential.UserName)", $($local:Credential.Password))
    }
    
    # Post progress info to console
    Write-Output ('{0}: Getting ZoneInfo for user {1} by calling default URI {2}' -F $MyInvocation.MyCommand.Name, $local:Credential.UserName, $DefaultUri)
    Write-AtwsProgress -Status 'Creating connection' -PercentComplete 1 -CurrentOperation 'Locating correct datacenter' @ProgressParameters
    
    # First make an unauthenticated call to the DefaultURI to determine correct
    # web services endpoint for the user we are going to authenticate as
    $RootService = New-WebServiceProxy -URI $DefaultUri
    
    # Get ZoneInfo for username
    $ZoneInfo = $RootService.getZoneInfo($local:Credential.UserName)
    
    # If we get an error the username is almost certainly misspelled or nonexistant
    If ($ZoneInfo.ErrorCode -ne 0) {
      Write-AtwsProgress -Status 'Creating connection' -PercentComplete 100 -CurrentOperation 'Operation failed' @ProgressParameters
            
      Throw [ApplicationException] ('Invalid username "{0}". Try again.' -f $local:Credential.UserName)
      
    }
    
    # If we get to here the username exists and we have the information we need to try to authenticate
    Write-Output ('{0}: Customer tenant ID: {1}, Web URL: {2}, SOAP endpoint: {3}' -F $MyInvocation.MyCommand.Name, $ZoneInfo.CI, $ZoneInfo.WebUrl, $ZoneInfo.Url)
    
    # Post progress to console
    Write-AtwsProgress -Status 'Datacenter located' -PercentComplete 30 -CurrentOperation 'Authenticating to web service' @ProgressParameters
          
    # Pick the correct web services endpoint for the current username
    # and change it to point at the WSDL definitoin
    $Uri = $ZoneInfo.URL -replace 'atws.asmx', 'atws.wsdl'
    
    # Make sure a failure to create this object truly fails the script
    Write-Output ('{0}: Creating New-WebServiceProxy against URI: {1}' -F $MyInvocation.MyCommand.Name, $Uri)
    Try {
      # Create a new webservice proxy or die trying...
      Write-Output ('{0}: New-WebServiceProxy -URI {1}  -Credential {2} -Namespace {3} -Class "AutotaskAPI" -ErrorAction Stop' -F $MyInvocation.MyCommand.Name, $Uri, $Credential.Username, $NameSpace)

      $Atws = New-WebServiceProxy -URI $Uri  -Credential $local:Credential -Namespace $NameSpace -Class 'AutotaskAPI' -ErrorAction Stop

      If ($Atws.Url) {
        Write-Output ('{0}: SUCCESS: WebServiceProxy object created without error' -F $MyInvocation.MyCommand.Name)
      }

      # Make sure the webserviceproxy authenticates every time (saves a webconnection and a few milliseconds)
      $Atws.PreAuthenticate = $True
      
      ## Add API Integrations Value

      Write-Output ('{0}: Adding API integration code to the WebServiceProxy object' -F $MyInvocation.MyCommand.Name)
       
      # A dedicated object type has been created to store integration values
      $AutotaskIntegrationsValue = New-Object "$NameSpace.AutotaskIntegrations"

      # Set the integrationcode property to the API tracking identifier provided by the user
      $AutotaskIntegrationsValue.IntegrationCode = $ApiTrackingIdentifier

      # Add the integrations value to the Web Service Proxy
      $Atws.AutotaskIntegrationsValue = $AutotaskIntegrationsValue
   

    }
    Catch {
      Throw $_    
    }
    
   
    Write-Output ('{0}: Testing hardcoded query for Account with ID 0 (exists in every Autotask tenant)' -F $MyInvocation.MyCommand.Name)
    
    Write-AtwsProgress -Status 'Connected' -PercentComplete 60 -CurrentOperation 'Testing Connection' @ProgressParameters

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
    Try { 
      $Result = $Atws.query($QueryXML)
    }
    Catch {
      If ($_.Exception.InnerException.Message -match '.*Invalid Username or password.*') {
        Write-Error 'Invalid Username or Password'
        Return
      }
    }

    If ($Result.ReturnCode -eq 1) {
      Write-Output $Result.EntityResults[0]
    }

    If ($Result.Errors.Count -gt 0) { 
      Foreach ($Err in $Result.Errors) {
        Write-Error $Err.message
      }
      Return
    }

    # Get username part of credential
    $UserName = $Credential.UserName.Split('@')[0].Trim('\')

    Write-Output ('{0}: Testing hardcoded query for a user with name {1}' -F $MyInvocation.MyCommand.Name, $Username)

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

    Try { 
      $Result = $Atws.query($QueryXML)
    }
    Catch {
      If ($_.Exception.InnerException.Message -match '.*Invalid Username or password.*') {
        Write-Error 'Invalid Username or Password'
        Return
      }
    }

    If ($Result.ReturnCode -eq 1) {
      Write-Output $Result.EntityResults[0]
    }
    
    If ($Result.Errors.Count -gt 0) { 
      Foreach ($Err in $Result.Errors) {
        Write-Error $Err.message
      }
      Return
    }
  }
  End {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    Write-AtwsProgress -Status 'Completed' -PercentComplete 100 -CurrentOperation 'Done' @ProgressParameters
       
  }
}
