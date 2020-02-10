#Requires -Version 4.0
#Version 1.6.4.1
<#

.COPYRIGHT
Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.

#>
Function Set-AtwsClientPortalUser
{


<#
.SYNOPSIS
This function sets parameters on the ClientPortalUser specified by the -InputObject parameter or pipeline through the use of the Autotask Web Services API. Any property of the ClientPortalUser that is not marked as READ ONLY by Autotask can be speficied with a parameter. You can specify multiple paramters.
.DESCRIPTION
This function one or more objects of type [Autotask.ClientPortalUser] as input. You can pipe the objects to the function or pass them using the -InputObject parameter. You specify the property you want to set and the value you want to set it to using parameters. The function modifies all objects and updates the online data through the Autotask Web Services API. The function supports all properties of an [Autotask.ClientPortalUser] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values.

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
[Autotask.ClientPortalUser[]]. This function takes one or more objects as input. Pipeline is supported.
.OUTPUTS
Nothing or [Autotask.ClientPortalUser]. This function optionally returns the updated objects if you use the -PassThru parameter.
.EXAMPLE
Set-AtwsClientPortalUser -InputObject $ClientPortalUser [-ParameterName] [Parameter value]
Passes one or more [Autotask.ClientPortalUser] object(s) as a variable to the function and sets the property by name 'ParameterName' on ALL the objects before they are passed to the Autotask Web Service API and updated.
 .EXAMPLE
$ClientPortalUser | Set-AtwsClientPortalUser -ParameterName <Parameter value>
Same as the first example, but now the objects are passed to the funtion through the pipeline, not passed as a parameter. The end result is identical.
 .EXAMPLE
Get-AtwsClientPortalUser -Id 0 | Set-AtwsClientPortalUser -ParameterName <Parameter value>
Gets the instance with Id 0 directly from the Web Services API, modifies a parameter and updates Autotask. This approach works with all valid parameters for the Get function.
 .EXAMPLE
Get-AtwsClientPortalUser -Id 0,4,8 | Set-AtwsClientPortalUser -ParameterName <Parameter value>
Gets multiple instances by Id, modifies them all and updates Autotask.
 .EXAMPLE
$result = Get-AtwsClientPortalUser -Id 0,4,8 | Set-AtwsClientPortalUser -ParameterName <Parameter value> -PassThru
Gets multiple instances by Id, modifies them all, updates Autotask and returns the updated objects.

.LINK
New-AtwsClientPortalUser
 .LINK
Get-AtwsClientPortalUser

#>

  [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName='InputObject', ConfirmImpact='Low')]
  Param
  (
# An object that will be modified by any parameters and updated in Autotask
    [Parameter(
      ParametersetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.ClientPortalUser[]]
    $InputObject,

# The object.ids of objects that should be modified by any parameters and updated in Autotask
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [long[]]
    $Id,

# Return any updated objects through the pipeline
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [switch]
    $PassThru,

# Security Level
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [string]
    $SecurityLevel,

# Date Format
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [string]
    $DateFormat,

# Time Format
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [string]
    $TimeFormat,

# Number Format
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [string]
    $NumberFormat,

# User Name
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,200)]
    [string]
    $UserName,

# Password
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ValidateLength(0,50)]
    [string]
    $Password,

# Client Portal Active
    [Parameter(
      ParametersetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [Parameter(
      ParametersetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean]]
    $ClientPortalActive
  )
 
    begin { 
        $entityName = 'ClientPortalUser'
    
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {
            $DebugPreference = 'Continue'
        }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
           
        
        
        $ModifiedObjects = @()
    }

    process {
        # Collect fresh copies of InputObject if passed any IDs
        # Has to collect in batches, or we are going to get the 
        # dreaded 'too nested SQL' error
        If ($Id.count -gt 0) { 
            for ($i = 0; $i -lt $Id.count; $i += 200) {
                $j = $i + 199
                if ($j -ge $Id.count) {
                    $j = $Id.count - 1
                } 
            
                # Create a filter with the current batch
                $Filter = 'Id -eq {0}' -F ($Id[$i .. $j] -join ' -or Id -eq ')
            
                $InputObject += Get-AtwsData -Entity $entityName -Filter $Filter
            }

            # Remove the ID parameter so we do not try to set it on every object
            $null = $PSBoundParameters.Remove('id')
        }

        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to modify {1} {2}(s). This action cannot be undone.' -F $caption, $InputObject.Count, $entityName
        $verboseWarning = '{0}: About to modify {1} {2}(s). This action cannot be undone. Do you want to continue?' -F $caption, $InputObject.Count, $entityName

        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
            
            Write-Verbose $verboseDescription

            # Process parameters and update objects with their values
            $processObject = $InputObject | Update-AtwsObjectsWithParameters -BoundParameters $PSBoundParameters -EntityName $EntityName
            
            # If using pipeline this block (process) will run once pr item in the pipeline. make sure to return them all
            $ModifiedObjects += Set-AtwsData -Entity $processObject
        
        }
    
    }

    end {
        Write-Debug ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $ModifiedObjects.count, $entityName)
        if ($PassThru.IsPresent) { 
            Return $ModifiedObjects
        }
    }

}
