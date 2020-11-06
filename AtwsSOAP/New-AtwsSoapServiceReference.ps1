<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md  for license information.

#>
Function New-AtwsSoapServiceReference {
    <#
        .SYNOPSIS
            This function creates a new Servicereference file for the Autotask Web API.
        .DESCRIPTION
            This function uses dotnet-svcutil to create a new C# service reference file
            from the Autotask web service WSDL file. The file is copied to the private directory
            of the module for inclusion in any module publication.
        .INPUTS
            Nothing.
        .OUTPUTS
            Reference.cs (file)
        .EXAMPLE
            New-AtwsSoapServiceReference
            This function creates a new Servicereference file for the Autotask Web API.
        .NOTES
            NAME: New-AtwsSoapServiceReference
        .LINK
            dotnet-svcutil
    #>

    [CmdLetBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'medium'
    )]
    # The function set to generate, either 'Dynamic' or 'Static'
    Param(
    )
  
    begin {
        # This function is not included in the module export, so it has to run standalone
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }  
              
        Write-Debug -Message ('{0}: Start of function.' -F $MyInvocation.MyCommand.Name)

        $location = $MyInvocation.PSScriptRoot
        $outputDir = Join-Path $location 'Autotask'
        $source = Join-Path $outputDir 'Reference.cs'
        $target = Join-Path $location '../Autotask/Private/Reference.cs'
        # no need for this patch any more
        #$patch = Join-Path $location 'Missing properties on EntityInfo.patch'
        $uri = 'https://webservices.Autotask.net/atservices/1.6/atws.wsdl'

        # Locate command. Should be in .dotnet/tools
        $dotnetsvcutil = Join-Path $HOME '.dotnet/tools/dotnet-svcutil'

        # On windows add .exe
        if (-not($IsMacos -or $IsLinux)) {
            $dotnetsvcutil = $dotnetsvcutil + '.exe'
        }
    }

    process {

        

        if (!(Test-Path $dotnetsvcutil)) {
            if (Get-Command dotnet) {
                dotnet tool install --global dotnet-svcutil
            }
            else {
                throw "dotnet SDK is REQUIRED to build a new service reference file."
                return
            }
        }
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: Generating service reference information based on url {1}' -F $caption, $uri
        $verboseWarning = '{0}: About to generate service reference information based on url {1}. Do you want to continue?' -F $caption, $uri
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
            & $dotnetsvcutil $uri --sync --outputDir $outputDir
        }

        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: Moving service reference file to {1}' -F $caption, $target
        $verboseWarning = '{0}: About to move service reference file to {1} overwriting any pre-existing file. Do you want to continue?' -F $caption, $target
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
            Move-Item $source $target -Force
            # Apply patch, ignore errors
            # Get-Content $patch | git am
        }

    }
    
    end {
        Write-Debug -Message ('{0}: End of function.' -F $MyInvocation.MyCommand.Name)
    }

}

# Run the function if the file is executed.
New-AtwsSoapServiceReference