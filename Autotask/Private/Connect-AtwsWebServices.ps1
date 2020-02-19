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
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
        
    
        $DefaultUri = 'https://webservices.Autotask.net/atservices/1.6/atws.asmx'
    
        # Unless warning level is specified explicitly - Show warnings!
        if (-not ($WarningAction)) {
            $Global:WarningPreference = 'Continue'
        }

        # Load support for TLS 1.2 if the Service Point Manager haven't loaded it yet
        # This is now a REQUIREMENT to talk to the API endpoints
        $Protocol = [System.Net.ServicePointManager]::SecurityProtocol
        if ($Protocol.Tostring() -notlike '*Tls12*') { 
            [System.Net.ServicePointManager]::SecurityProtocol += 'tls12'
        }
    
        # Path to web service reference
        $code = '{0}\Private\Reference.cs' -f $My['ModuleBase']

        # List of needed assemblies for Powershell 5.1
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
        # For Powershell versions 6 and higher, add these assemblies
        if ($PSVersionTable.PSVersion.Major -ge 6) { 
            $assemblies += @( 
                'netstandard'
                'System.Xml.XmlSerializer'
                'System.Runtime.Serialization.Xml'
                'System.ServiceModel.Primitives'
                'System.Private.ServiceModel'
                'System.Diagnostics.Tools'
            )
        }
    }
  
    process { 
        ## Preparing for a progressbar
        # Prepare parameters for @splatting
        $ProgressParameters = @{
            Activity = 'Creating and importing functions for all Autotask entities.'
            Id       = 4
        }
    
        # Compile webserviceinfo (Reference.cs) and instantiate a SOAP client
        Add-Type -TypeDefinition (Get-Content -raw $code) -ReferencedAssemblies $assemblies
        
        # Create a  binding with no authentication
        $anonymousBinding = New-Object ServiceModel.BasicHttpsBinding 

        # Create an endpoint pointing at the default URI
        $endPoint = New-Object System.ServiceModel.EndpointAddress $DefaultUri 

        # First make an unauthenticated call to the DefaultURI to determine correct
        # web services endpoint for the user we are going to authenticate as
        $rootService = New-Object Autotask.ATWSSoapClient  $anonymousBinding, $endPoint 
  
        # Post progress info to console
        Write-Verbose ('{0}: Getting ZoneInfo for user {1} by calling default URI {2}' -F $MyInvocation.MyCommand.Name, $ConfigurationData.UserName, $DefaultUri)
        Write-AtwsProgress -Status 'Creating connection' -PercentComplete 1 -CurrentOperation 'Locating correct datacenter' @ProgressParameters
    
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
        Write-AtwsProgress -Status 'Datacenter located' -PercentComplete 30 -CurrentOperation 'Authenticating to web service' @ProgressParameters
             
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
            $Script:Atws.ClientCredentials.UserName.Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
      
            ## Add API Integrations Value 
            # A dedicated object type has been created to store integration values
            $AutotaskIntegrationsValue = New-Object Autotask.AutotaskIntegrations

            # Set the integrationcode property to the API tracking identifier provided by the user
            $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ConfigurationData.SecureTrackingIdentifier)
            $AutotaskIntegrationsValue.IntegrationCode = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

            # Add the integrations value to the Web Service Proxy
            Add-Member -InputObject $Script:Atws -MemberType NoteProperty -Name IntegrationsValue -Value $AutotaskIntegrationsValue -Force
        
            # Add tenant identifier to connection
            Add-Member -InputObject $Script:Atws -MemberType NoteProperty -Name CI -Value $ZoneInfo.CI -Force

            # Add configuration to connection
            Add-Member -InputObject $Script:Atws -MemberType NoteProperty -Name Configuration -Value $ConfigurationData -Force

            # Add empty hashtable as placeholder for in memory cache - will be populated from disk later
            Add-Member -InputObject $Script:Atws -MemberType NoteProperty -Name Cache -Value @{ } -Force
            
            # Add empty string as placeholder for cache path - will be populated later
            Add-Member -InputObject $Script:Atws -MemberType NoteProperty -Name DynamicCache -Value '' -Force

        }
        catch {
            throw $_   
            return
        }
    
   
        Write-Verbose ('{0}: Running query Get-AtwsData -Entity Resource -Filter "username -eq $UserName"' -F $MyInvocation.MyCommand.Name)
    
        Write-AtwsProgress -Status 'Connected' -PercentComplete 60 -CurrentOperation 'Testing connection' @ProgressParameters
       
        # Get username part of credential
        $UserName = $ConfigurationData.UserName.Split('@')[0]
        $result = Get-AtwsData -Entity Resource -Filter "username -eq $UserName"
    
        if ($result) {
    
            # The connection has been verified. Use it to dynamically create functions for all entities
            Write-AtwsProgress -Status 'Connection OK' -PercentComplete 90 -CurrentOperation 'Importing dynamic module' @ProgressParameters
        
            # Load the entity cache to memory
            Write-Verbose ('{0}: Loading disk cache' -F $MyInvocation.MyCommand.Name)
            Import-AtwsDiskCache
        
        }
        else {
            Remove-Variable -Name Atws -Scope Script
            throw (New-object System.Data.SyntaxErrorException 'Could not complete a query to Autotask WebAPI. Verify your credentials. You seem to have been logged in, but do you have the necessary rights?')   
        }
    }
  
    end {
        Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        Write-AtwsProgress -Status 'Completed' -PercentComplete 100 -CurrentOperation 'Done' @ProgressParameters   
    }
}
