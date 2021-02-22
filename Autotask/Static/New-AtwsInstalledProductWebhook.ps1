#Requires -Version 4.0
#Version 1.6.14
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function New-AtwsInstalledProductWebhook
{


<#
.SYNOPSIS
This function creates a new InstalledProductWebhook through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.InstalledProductWebhook] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the InstalledProductWebhook with Id number 0 you could write 'New-AtwsInstalledProductWebhook -Id 0' or you could write 'New-AtwsInstalledProductWebhook -Filter {Id -eq 0}.

'New-AtwsInstalledProductWebhook -Id 0,4' could be written as 'New-AtwsInstalledProductWebhook -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new InstalledProductWebhook you need the following required fields:
 -Name
 -WebhookUrl
 -DeactivationUrl
 -SecretKey

Entities that have fields that refer to the base entity of this CmdLet:

InstalledProductWebhookExcludedResource
 InstalledProductWebhookField
 InstalledProductWebhookUdfField
 WebhookEventErrorLog

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.InstalledProductWebhook]. This function outputs the Autotask.InstalledProductWebhook that was created by the API.
.EXAMPLE
$result = New-AtwsInstalledProductWebhook -Name [Value] -WebhookUrl [Value] -DeactivationUrl [Value] -SecretKey [Value]
Creates a new [Autotask.InstalledProductWebhook] through the Web Services API and returns the new object.
 .EXAMPLE
$result = Get-AtwsInstalledProductWebhook -Id 124 | New-AtwsInstalledProductWebhook 
Copies [Autotask.InstalledProductWebhook] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsInstalledProductWebhook -Id 124 | New-AtwsInstalledProductWebhook | Set-AtwsInstalledProductWebhook -ParameterName <Parameter Value>
Copies [Autotask.InstalledProductWebhook] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsInstalledProductWebhook to modify the object.
 .EXAMPLE
$result = Get-AtwsInstalledProductWebhook -Id 124 | New-AtwsInstalledProductWebhook | Set-AtwsInstalledProductWebhook -ParameterName <Parameter Value> -Passthru
Copies [Autotask.InstalledProductWebhook] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsInstalledProductWebhook to modify the object and returns the new object.

.LINK
Remove-AtwsInstalledProductWebhook
 .LINK
Get-AtwsInstalledProductWebhook
 .LINK
Set-AtwsInstalledProductWebhook

#>

  [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName='By_parameters', ConfirmImpact='Low')]
  Param
  (
# An array of objects to create
    [Parameter(
      ParametersetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.InstalledProductWebhook[]]
    $InputObject,

# Webhook GUID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string]
    $WebhookGUID,

# Active
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $Active,

# Name
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,50)]
    [string]
    $Name,

# Webhook Url
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,500)]
    [string]
    $WebhookUrl,

# Is Subscribed To Create Events
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $IsSubscribedToCreateEvents,

# Is Subscribed To Update Events
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $IsSubscribedToUpdateEvents,

# Is Subscribed To Delete Events
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $IsSubscribedToDeleteEvents,

# Deactivation URL
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,500)]
    [string]
    $DeactivationUrl,

# Notification Email Address
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,150)]
    [string]
    $NotificationEmailAddress,

# Send Threshold Exceeded Notification
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $SendThresholdExceededNotification,

# Owner Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $OwnerResourceID,

# Secret Key
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,64)]
    [string]
    $SecretKey,

# Ready
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $Ready
  )
 
    begin { 
        $entityName = 'InstalledProductWebhook'
           
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {
            $DebugPreference = 'Continue' 
        }
        else {
            # Respect configured preference
            $DebugPreference = $Script:Atws.Configuration.DebugPref
        }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

        if (!($PSCmdlet.MyInvocation.BoundParameters['Verbose'].IsPresent)) {
            # No local override of central preference. Load central preference
            $VerbosePreference = $Script:Atws.Configuration.VerbosePref
        }
        
        $processObject = @()
    }

    process {
    
        if ($InputObject) {
            Write-Verbose -Message ('{0}: Copy Object mode: Setting ID property to zero' -F $MyInvocation.MyCommand.Name)  

            $fields = Get-AtwsFieldInfo -Entity $entityName
      
            $CopyNo = 1

            foreach ($object in $InputObject) { 
                # Create a new object and copy properties
                $newObject = New-Object -TypeName Autotask.$entityName
        
                # Copy every non readonly property
                $fieldNames = $fields.Where( { $_.Name -ne 'id' }).Name

                if ($PSBoundParameters.ContainsKey('UserDefinedFields')) { 
                    $fieldNames += 'UserDefinedFields' 
                }

                foreach ($field in $fieldNames) { 
                    $newObject.$field = $object.$field 
                }

                if ($newObject -is [Autotask.Ticket] -and $object.id -gt 0) {
                    Write-Verbose -Message ('{0}: Copy Object mode: Object is a Ticket. Title must be modified to avoid duplicate detection.' -F $MyInvocation.MyCommand.Name)  
                    $title = '{0} (Copy {1})' -F $newObject.Title, $CopyNo
                    $copyNo++
                    $newObject.Title = $title
                }
                $processObject += $newObject
            }   
        }
        else {
            Write-Debug -Message ('{0}: Creating empty [Autotask.{1}]' -F $MyInvocation.MyCommand.Name, $entityName) 
            $processObject += New-Object -TypeName Autotask.$entityName    
        }
        
        # Prepare shouldProcess comments
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to create {1} {2}(s). This action cannot be undone.' -F $caption, $processObject.Count, $entityName
        $verboseWarning = '{0}: About to create {1} {2}(s). This action may not be undoable. Do you want to continue?' -F $caption, $processObject.Count, $entityName

        # Lets don't and say we did!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
            
            # Process parameters and update objects with their values
            $processObject = $processObject | Update-AtwsObjectsWithParameters -BoundParameters $PSBoundParameters -EntityName $EntityName
            
            $result = Set-AtwsData -Entity $processObject -Create
        }
    }

    end {
        Write-Debug -Message ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $result.count, $entityName)
        Return $result
    }

}
