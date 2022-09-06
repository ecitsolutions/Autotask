<#
    .COPYRIGHT
        Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
        See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.
#>

Function Connect-AtwsWebServices {
    <#
        .SYNOPSIS
            This function connects to the Autotask Web Services API, authenticates a user and validates
            the current credentials are working with the REST API.
        .DESCRIPTION
            The function takes a configuration object and uses it to authenticate and connect to the Autotask
            Web Services API.
        .INPUTS
            A PSCustom object created using other functions. Required. 
        .OUTPUTS
            Authentication properties are stored in variables in the script: namespace.
        .EXAMPLE
            Connect-AtwsRestServices
        .NOTES
            NAME: Connect-AtwsRestServices

  #>

    [cmdletbinding()]
    #[Alias('Connect-AutotaskWebAPI')]
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

        $DefaultUri = 'https://webservices.Autotask.net/atservicesrest/V1.0/zoneInformation?user={0}'

        Write-Debug "Connect-AtwsWebServices: DefaultUri set to $DefaultUri"

        # Unless warning level is specified explicitly - Show warnings!
        if (-not ($WarningAction)) {
            $Global:WarningPreference = 'Continue'
        }

    }

    process {

        # Post progress info to console
        Write-Verbose ('{0}: Getting ZoneInfo for user {1} by calling default URI {2}' -F $MyInvocation.MyCommand.Name, $ConfigurationData.UserName, $DefaultUri)

        Write-AtwsProgress -Status 'Creating connection' -PercentComplete 10 -CurrentOperation 'Locating correct datacenter' @ProgressParameters

        # Get ZoneInfo for username
        
        try { 
            $zoneInfo = Invoke-RestMethod -Uri ($DefaultUri -F $ConfigurationData.UserName)
        }
        catch {
            # If we get an error the username is almost certainly misspelled or nonexistant
            Write-AtwsProgress -Status 'Creating connection' -PercentComplete 100 -CurrentOperation 'Operation failed' @ProgressParameters

            throw $_
            return
        }

        # If we get to here the username exists and we have the information we need to try to authenticate
        Write-Verbose ('{0}: Customer tenant ID: {1}, Web URL: {2}, REST endpoint: {3}' -F $MyInvocation.MyCommand.Name, $ZoneInfo.CI, $ZoneInfo.WebUrl, $ZoneInfo.Url)

        # Post progress to console
        Write-AtwsProgress -Status 'Datacenter located' -PercentComplete 40 -CurrentOperation 'Authenticating to web service' @ProgressParameters

        # Make sure a failure to create this object truly fails the script
        Write-Verbose ('{0}: Creating new SOAP client using URI: {1}' -F $MyInvocation.MyCommand.Name, $ZoneInfo.Url)
        try {
            
            # Prepare securestring password to be converted to plaintext
            $PwdBSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ConfigurationData.SecurePassword)
            
            # Set the integrationcode property to the API tracking identifier provided by the user
            $ApiBSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ConfigurationData.SecureTrackingIdentifier)
 
            # Save data to script: namespace (module namespace)
            $Script:Atws = [pscustomobject]@{
                'AuthHeader'    = @{
                    'ApiIntegrationCode' = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ApiBSTR)
                    'UserName'           = $ConfigurationData.UserName
                    'Secret'             = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($PwdBSTR)
                    'Content-Type'       = 'application/json'
                }
                'CI'            = $zoneInfo.CI
                'Configuration' = $ConfigurationData
            }

        }
        catch {
            throw $_
            return
        }

        Write-Verbose ('{0}: Running query Get-AtwsData -Entity Resource -Filter "username -eq $UserName"' -F $MyInvocation.MyCommand.Name)

        Write-AtwsProgress -Status 'Connected' -PercentComplete 60 -CurrentOperation 'Testing connection' @ProgressParameters

        # Get username part of credential
        $UserName = $ConfigurationData.UserName.Split('@')[0]
        $result = Get-AtwsResource -UserName $UserName

        if ($result) {

            # The connection has been verified. Use it to dynamically create functions for all entities
            Write-AtwsProgress -Status 'Connection OK' -PercentComplete 90 -CurrentOperation 'Importing dynamic module' @ProgressParameters

            # Clear result variable
            Remove-Variable -Name result -Force

        }
        else {
            Remove-Variable -Name Atws -Scope Script
            throw (New-Object System.Data.SyntaxErrorException 'Could not complete a query to Autotask WebAPI. Verify your credentials. You seem to have been logged in, but do you have the necessary rights?')
        }
    }

    end {
        Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        Write-AtwsProgress -Status 'Completed' -PercentComplete 100 -CurrentOperation 'Done' @ProgressParameters -Completed
    }
}
