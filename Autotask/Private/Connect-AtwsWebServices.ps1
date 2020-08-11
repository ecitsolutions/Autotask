<#
    .COPYRIGHT
        Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
        See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.
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
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [Alias('Configuration')]
        [ValidateNotNullOrEmpty()]
        [pscustomobject]
        $ConfigurationData 
    )
    
    begin { 

        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }

        ## Preparing for a progressbar
        # Prepare parameters for @splatting
        $ProgressParameters = @{
            Activity = 'Creating and importing functions for all Autotask entities.'
            Id       = 4
        }
        Write-AtwsProgress -Status 'Creating connection' -PercentComplete 1 -CurrentOperation 'Locating correct datacenter' @ProgressParameters

        $DefaultUri = 'https://webservices.Autotask.net/atservices/1.6/atws.asmx'

        Write-Debug "Connect-AtwsWebServices: DefaultUri set to $DefaultUri"

        # Unless warning level is specified explicitly - Show warnings!
        if (-not ($WarningAction)) {
            $Global:WarningPreference = 'Continue'
        }

    }
  
    process { 
        
    
        ## SOAP
        # Create a  binding with no authentication
        $anonymousBinding = New-Object ServiceModel.BasicHttpsBinding 

        # Create an endpoint pointing at the default URI
        $endPoint = New-Object System.ServiceModel.EndpointAddress $DefaultUri 

        # First make an unauthenticated call to the DefaultURI to determine correct
        # web services endpoint for the user we are going to authenticate as
        $rootService = New-Object Autotask.ATWSSoapClient  $anonymousBinding, $endPoint 

        Write-Debug "Connect-AtwsWebServices: rootService created successfully"
  
        # Post progress info to console
        Write-Verbose ('{0}: Getting ZoneInfo for user {1} by calling default URI {2}' -F $MyInvocation.MyCommand.Name, $ConfigurationData.UserName, $DefaultUri)

        Write-AtwsProgress -Status 'Creating connection' -PercentComplete 10 -CurrentOperation 'Locating correct datacenter' @ProgressParameters
    
        # Get ZoneInfo for username
        $zoneInfo = $rootService.getZoneInfo($ConfigurationData.UserName)
    
        # If we get an error the username is almost certainly misspelled or nonexistant
        if ($ZoneInfo.ErrorCode -ne 0) {
            Write-AtwsProgress -Status 'Creating connection' -PercentComplete 100 -CurrentOperation 'Operation failed' @ProgressParameters
            
            throw (New-Object System.Data.SyntaxErrorException ('Invalid username "{0}". try again.' -f $ConfigurationData.UserName))
            return
        }
    
        # If we get to here the username exists and we have the information we need to try to authenticate
        Write-Verbose ('{0}: Customer tenant ID: {1}, Web URL: {2}, SOAP endpoint: {3}' -F $MyInvocation.MyCommand.Name, $ZoneInfo.CI, $ZoneInfo.WebUrl, $ZoneInfo.Url)
    
        # Post progress to console
        Write-AtwsProgress -Status 'Datacenter located' -PercentComplete 40 -CurrentOperation 'Authenticating to web service' @ProgressParameters
             
        # Make sure a failure to create this object truly fails the script
        Write-Verbose ('{0}: Creating new SOAP client using URI: {1}' -F $MyInvocation.MyCommand.Name, $ZoneInfo.Url)
        try {
            # Create a new webservice proxy or die trying...
            # First create an endpoint pointing at the correct URI
            $endPoint = New-Object System.ServiceModel.EndpointAddress $zoneInfo.url 

            # Create a new binding with basic authentication
            $binding = New-Object ServiceModel.BasicHttpsBinding 
            $binding.Security.Transport.ClientCredentialType = [ServiceModel.HttpClientCredentialType]::Basic
            $binding.Security.Mode = [ServiceModel.BasicHttpsSecurityMode]::Transport

            # Increase the message size from default
            $binding.MaxReceivedMessageSize = 20000000
            $binding.MaxBufferSize = 20000000
            $binding.MaxBufferPoolSize = 20000000

            # Prepare securestring password to be converted to plaintext
            $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ConfigurationData.SecurePassword)

            # Create a new SOAP client pointing at the correct webservice with authentication
            $Script:Atws = New-Object Autotask.ATWSSoapClient $binding, $endPoint 
            
            # Set username and password immediately as the first two methods to call
            # Username is plaintext, but password as securestring needs another step
            $Script:Atws.ClientCredentials.UserName.UserName = $ConfigurationData.UserName
            $Script:Atws.ClientCredentials.UserName.Password = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($BSTR)
      
            ## Add API Integrations Value 
            # A dedicated object type has been created to store integration values
            $AutotaskIntegrationsValue = New-Object Autotask.AutotaskIntegrations

            # Set the integrationcode property to the API tracking identifier provided by the user
            $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ConfigurationData.SecureTrackingIdentifier)
            $AutotaskIntegrationsValue.IntegrationCode = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($BSTR)

            # Add the integrations value to the Web Service Proxy
            Add-Member -InputObject $Script:Atws -MemberType NoteProperty -Name IntegrationsValue -Value $AutotaskIntegrationsValue -Force
        
            # Add tenant identifier to connection
            Add-Member -InputObject $Script:Atws -MemberType NoteProperty -Name CI -Value $ZoneInfo.CI -Force

            # Add configuration to connection
            Add-Member -InputObject $Script:Atws -MemberType NoteProperty -Name Configuration -Value $ConfigurationData -Force

        }
        catch {
            throw $_   
            return
        }

        ## REST
        $uri = '{0}/zoneInformation?user={1}' -f $DefaultRestUri, $ConfigurationData.UserName
        $restZoneInfo = Invoke-RestMethod -Uri $uri
        if ($restZoneInfo.CI -gt 0) {
            $Script:RestUri = $restZoneInfo.url
            $Script:RestHeader = @{
                'ApiIntegrationcode' = $AutotaskIntegrationsValue.IntegrationCode
                'UserName'           = $ConfigurationData.UserName
                'Secret'             = $Script:Atws.ClientCredentials.UserName.Password 
                'Content-Type'       = 'application/json'
            }
        }
   
        Write-Verbose ('{0}: Running query Get-AtwsData -Entity Resource -Filter "username -eq $UserName"' -F $MyInvocation.MyCommand.Name)
    
        Write-AtwsProgress -Status 'Connected' -PercentComplete 60 -CurrentOperation 'Testing connection' @ProgressParameters
       
        # Get username part of credential
        $UserName = $ConfigurationData.UserName.Split('@')[0]
        $result = Get-AtwsResource -Username $UserName
    
        if ($result) {
    
            # The connection has been verified. Use it to dynamically create functions for all entities
            Write-AtwsProgress -Status 'Connection OK' -PercentComplete 90 -CurrentOperation 'Importing dynamic module' @ProgressParameters
            
            # Clear result variable
            Remove-Variable -Name result -Force
           
        }
        else {
            Remove-Variable -Name Atws -Scope Script
            throw (New-object System.Data.SyntaxErrorException 'Could not complete a query to Autotask WebAPI. Verify your credentials. You seem to have been logged in, but do you have the necessary rights?')   
        }
    }
  
    end {
        Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        Write-AtwsProgress -Status 'Completed' -PercentComplete 100 -CurrentOperation 'Done' @ProgressParameters -Completed
    }
}
