#Requires -Version 5.0
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

.NOTES
Related commands:
Remove-AtwsInstalledProductWebhook
 Get-AtwsInstalledProductWebhook
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

# Active
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $Active,

# Deactivation URL
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,500)]
    [string]
    $DeactivationUrl,

# Is Subscribed To Create Events
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $IsSubscribedToCreateEvents,

# Is Subscribed To Delete Events
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $IsSubscribedToDeleteEvents,

# Is Subscribed To Update Events
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $IsSubscribedToUpdateEvents,

# Name
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,50)]
    [string]
    $Name,

# Notification Email Address
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,150)]
    [string]
    $NotificationEmailAddress,

# Owner Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $OwnerResourceID,

# Ready
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $Ready,

# Secret Key
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,64)]
    [string]
    $SecretKey,

# Send Threshold Exceeded Notification
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $SendThresholdExceededNotification,

# Webhook GUID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string]
    $WebhookGUID,

# Webhook Url
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,500)]
    [string]
    $WebhookUrl
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

        $processObject = [collections.generic.list[psobject]]::new()
        $result = [collections.generic.list[psobject]]::new()
    }

    process {

        if ($InputObject) {
            Write-Verbose -Message ('{0}: Copy Object mode: Setting ID property to zero' -F $MyInvocation.MyCommand.Name)

            # Copy the input array to the processObject collection
            if ($InputObject.count -gt 1) { 
                [collections.generic.list[psobject]]$processObject = $InputObject
            }
            else {
                $processObject.add($InputObject[0])
            }

            # If any objects has the ID property set to a value, the sum of all IDs will be larger than zero
            $sum = ($processObject | Measure-Object -Property Id -Sum).Sum

            # If $sum has value we must reset object IDs or we will modify existing objects, not create new ones
            if ($sum -gt 0) {
                foreach ($object in $processObject) {
                    $object.Id = $null
                }
            }
        }
        else {
            Write-Debug -Message ('{0}: Creating empty [Autotask.{1}]' -F $MyInvocation.MyCommand.Name, $entityName)
            $processObject.add((New-Object -TypeName Autotask.$entityName))
        }

        # Prepare shouldProcess comments
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to create {1} {2}(s). This action cannot be undone.' -F $caption, $processObject.Count, $entityName
        $verboseWarning = '{0}: About to create {1} {2}(s). This action may not be undoable. Do you want to continue?' -F $caption, $processObject.Count, $entityName

        # Lets don't and say we did!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) {

            # Process parameters and update objects with their values
            $processObject = $processObject | Update-AtwsObjectsWithParameters -BoundParameters $PSBoundParameters -EntityName $EntityName

            try {
                # Force list even if result is only 1 object to be compatible with addrange()
                [collections.generic.list[psobject]]$response = Set-AtwsData -Entity $processObject -Create
            }
            catch {
                # Write a debug message with detailed information to developers
                $ex = $_.Exception
                $reason = ("{0}: {1}" -f $_.CategoryInfo.Category, $_.CategoryInfo.Reason)
                $message = "{2}: {0}`r`n`r`nLine:{1}`r`n`r`nScript stacktrace:`r`n{3}" -f $ex.Message, $_.InvocationInfo.Line, $reason, $_.ScriptStackTrace
                while ($ex.InnerException) { 
                    $ex = $ex.InnerException
                    $message = "InnerException: {0}`n{1}" -F $ex.Message, $message
                }

                Write-Debug $message

                # Pass on the error
                $PSCmdlet.ThrowTerminatingError($_)
                return
            }
            # If using pipeline this block (process) will run once pr item in the pipeline. make sure to return them all
            if ($response.Count -gt 0) {
                $result.AddRange($response)
            }
        }
    }

    end {
        Write-Debug -Message ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $result.count, $entityName)
        Return [array]$result
    }

}
