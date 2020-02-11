<#

        .COPYRIGHT
        Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
        See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

#>

Function Test-AtwsModuleConfiguration {
    <#
            .SYNOPSIS
            This function re-loads the module with the correct parameters for full functionality
            .DESCRIPTION
            This function is a wrapper that is included for backwards compatibility with previous module behavior.
            These parameters should be passed to Import-Module -Variable directly, but previously the module 
            consisted of two, nested modules. Now there is a single module with all functionality.
            .INPUTS
            A PSCredential object. Required. 
            A string used as ApiTrackingIdentifier. Required. 
            .OUTPUTS
            Nothing.
            .EXAMPLE
            Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $string
            .NOTES
            NAME: Connect-AtwsWebAPI
    #>
	
    [cmdletbinding(
        ConfirmImpact = 'Low',
        DefaultParameterSetName = 'Default'
    )]
    Param
    (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { 
                $requiredProperties = @('Username', 'Securepassword', 'SecureTrackingIdentifier', 'ConvertPicklistIdToLabel', 'Prefix', 'RefreshCache', 'UseDiskCache')
                $members = Get-Member -InputObject $_ -MemberType NoteProperty
                $missingProperties = Compare-Object -ReferenceObject $requiredProperties -DifferenceObject $members.Name -PassThru -ErrorAction SilentlyContinue
                if (-not($missingProperties)) {
                    $true               
                }
                else {
                    $missingProperties | ForEach-Object {
                        Throw [System.Management.Automation.ValidationMetadataException] "Property: '$_' missing"
                    } 
                }
            })]
        [pscustomobject]
        $Configuration 
    )

    Function Test-AtwsModuleConfigurationByPropertyname {
        <#
                .SYNOPSIS
                This function re-loads the module with the correct parameters for full functionality
                .DESCRIPTION
                This function is a wrapper that is included for backwards compatibility with previous module behavior.
                These parameters should be passed to Import-Module -Variable directly, but previously the module 
                consisted of two, nested modules. Now there is a single module with all functionality.
                .INPUTS
                A PSCredential object. Required. 
                A string used as ApiTrackingIdentifier. Required. 
                .OUTPUTS
                Nothing.
                .EXAMPLE
                Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $string
                .NOTES
                NAME: Connect-AtwsWebAPI
        #>
	
        [cmdletbinding(
            ConfirmImpact = 'Low',
            DefaultParameterSetName = 'Default'
        )]
        Param
        (
            [Parameter(
                Mandatory = $true,
                ValueFromPipelineByPropertyName = $true
            )]
            [ValidateNotNullOrEmpty()] 
            [string]
            $Username,
    
            [Parameter(
                Mandatory = $true,
                ValueFromPipelineByPropertyName = $true
            )]
            [ValidateNotNullOrEmpty()]
            [securestring]
            $SecurePassword,
    
            [Parameter(
                Mandatory = $true,
                ValueFromPipelineByPropertyName = $true
            )]
            [ValidateNotNullOrEmpty()]
            [securestring]
            $SecureTrackingIdentifier,
    
            [Parameter(
                Mandatory = $true,
                ValueFromPipelineByPropertyName = $true
            )]
            [switch]
            $ConvertPicklistIdToLabel,
    
            [Parameter(
                ValueFromPipelineByPropertyName = $true
            )]
            [ValidateScript( {
                    # It can be empty, but if it isn't it should be max 8 characters and only letters and numbers
                    if ($_.length -eq 0 -or ($_ -match '[a-zA-Z0-9]' -and $_.length -gt 0 -and $_.length -le 8)) {
                        $true
                    }
                    else {
                        $false
                    }
                })]
            [string]
            $Prefix,

            [Parameter(
                Mandatory = $true,
                ValueFromPipelineByPropertyName = $true
            )]
            [switch]
            $RefreshCache,

    
            [Parameter(
                Mandatory = $true,
                ValueFromPipelineByPropertyName = $true
            )]
            [switch]
            $UseDiskCache
        )
    
        begin { 
    
            # Enable modern -Debug behavior
            if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
            Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
        }
  
        process {
            Write-Verbose  ('{0}: Configuration validated OK' -F $MyInvocation.MyCommand.Name)
        }
  
        end {
            Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        }
    }
  
    Try {
        $Configuration | Test-AtwsModuleConfigurationByPropertyname -ErrorAction Stop
        return $true
    }
    catch {
        # Any parameter validation error will land us here
        return $false
    }

}