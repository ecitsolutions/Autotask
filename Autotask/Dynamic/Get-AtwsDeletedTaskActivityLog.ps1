#Requires -Version 4.0
#Version 1.6.12
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsDeletedTaskActivityLog
{


<#
.SYNOPSIS
This function get one or more DeletedTaskActivityLog through the Autotask Web Services API.
.DESCRIPTION
This function creates a query based on any parameters you give and returns any resulting objects from the Autotask Web Services Api. By default the function returns any objects with properties that are Equal (-eq) to the value of the parameter. To give you more flexibility you can modify the operator by using -NotEquals [ParameterName[]], -LessThan [ParameterName[]] and so on.

Possible operators for all parameters are:
 -NotEquals
 -GreaterThan
 -GreaterThanOrEqual
 -LessThan
 -LessThanOrEquals 

Additional operators for [string] parameters are:
 -Like (supports * or % as wildcards)
 -NotLike
 -BeginsWith
 -EndsWith
 -Contains

Properties with picklists are:

TypeID
 

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.DeletedTaskActivityLog[]]. This function outputs the Autotask.DeletedTaskActivityLog that was returned by the API.
.EXAMPLE
Get-AtwsDeletedTaskActivityLog -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsDeletedTaskActivityLog -DeletedTaskActivityLogName SomeName
Returns the object with DeletedTaskActivityLogName 'SomeName', if any.
 .EXAMPLE
Get-AtwsDeletedTaskActivityLog -DeletedTaskActivityLogName 'Some Name'
Returns the object with DeletedTaskActivityLogName 'Some Name', if any.
 .EXAMPLE
Get-AtwsDeletedTaskActivityLog -DeletedTaskActivityLogName 'Some Name' -NotEquals DeletedTaskActivityLogName
Returns any objects with a DeletedTaskActivityLogName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsDeletedTaskActivityLog -DeletedTaskActivityLogName SomeName* -Like DeletedTaskActivityLogName
Returns any object with a DeletedTaskActivityLogName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsDeletedTaskActivityLog -DeletedTaskActivityLogName SomeName* -NotLike DeletedTaskActivityLogName
Returns any object with a DeletedTaskActivityLogName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsDeletedTaskActivityLog -T <PickList Label>
Returns any DeletedTaskActivityLogs with property T equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsDeletedTaskActivityLog -T <PickList Label> -NotEquals T 
Returns any DeletedTaskActivityLogs with property T NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsDeletedTaskActivityLog -T <PickList Label1>, <PickList Label2>
Returns any DeletedTaskActivityLogs with property T equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsDeletedTaskActivityLog -T <PickList Label1>, <PickList Label2> -NotEquals T
Returns any DeletedTaskActivityLogs with property T NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsDeletedTaskActivityLog -Id 1234 -DeletedTaskActivityLogName SomeName* -T <PickList Label1>, <PickList Label2> -Like DeletedTaskActivityLogName -NotEquals T -GreaterThan Id
An example of a more complex query. This command returns any DeletedTaskActivityLogs with Id GREATER THAN 1234, a DeletedTaskActivityLogName that matches the simple pattern SomeName* AND that has a T that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.


#>

  [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName='Filter', ConfirmImpact='None')]
  Param
  (
# A filter that limits the number of objects that is returned from the API
    [Parameter(
      Mandatory = $true,
      ValueFromRemainingArguments = $true,
      ParametersetName = 'Filter'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Filter,

# Follow this external ID and return any external objects
    [Parameter(
      ParametersetName = 'Filter'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('GetRef')]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('CreatedByResourceID', 'DeletedByResourceID', 'TaskID')]
    [string]
    $GetReferenceEntityById,

# Return entities of selected type that are referencing to this entity.
    [Parameter(
      ParametersetName = 'Filter'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('External')]
    [ValidateNotNullOrEmpty()]
    [string]
    $GetExternalEntityByThisEntityId,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# Deleted Task Activity Log ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Type ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $TypeID,

# Task ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $TaskID,

# Task Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,50)]
    [string[]]
    $TaskNumber,

# Note Or Attachment Title
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,255)]
    [string[]]
    $NoteOrAttachmentTitle,

# Created By Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $CreatedByResourceID,

# Activity Date/Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $ActivityDateTime,

# Start Date/Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $StartDateTime,

# End Date/Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $EndDateTime,

# Hours Worked
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[decimal][]]
    $HoursWorked,

# Deleted By Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int][]]
    $DeletedByResourceID,

# Deleted Date/Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime][]]
    $DeletedDateTime,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TypeID', 'TaskID', 'TaskNumber', 'NoteOrAttachmentTitle', 'CreatedByResourceID', 'ActivityDateTime', 'StartDateTime', 'EndDateTime', 'HoursWorked', 'DeletedByResourceID', 'DeletedDateTime')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TypeID', 'TaskID', 'TaskNumber', 'NoteOrAttachmentTitle', 'CreatedByResourceID', 'ActivityDateTime', 'StartDateTime', 'EndDateTime', 'HoursWorked', 'DeletedByResourceID', 'DeletedDateTime')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TypeID', 'TaskID', 'TaskNumber', 'NoteOrAttachmentTitle', 'CreatedByResourceID', 'ActivityDateTime', 'StartDateTime', 'EndDateTime', 'HoursWorked', 'DeletedByResourceID', 'DeletedDateTime')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TypeID', 'TaskID', 'TaskNumber', 'NoteOrAttachmentTitle', 'CreatedByResourceID', 'ActivityDateTime', 'StartDateTime', 'EndDateTime', 'HoursWorked', 'DeletedByResourceID', 'DeletedDateTime')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TypeID', 'TaskID', 'TaskNumber', 'NoteOrAttachmentTitle', 'CreatedByResourceID', 'ActivityDateTime', 'StartDateTime', 'EndDateTime', 'HoursWorked', 'DeletedByResourceID', 'DeletedDateTime')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TypeID', 'TaskID', 'TaskNumber', 'NoteOrAttachmentTitle', 'CreatedByResourceID', 'ActivityDateTime', 'StartDateTime', 'EndDateTime', 'HoursWorked', 'DeletedByResourceID', 'DeletedDateTime')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TypeID', 'TaskID', 'TaskNumber', 'NoteOrAttachmentTitle', 'CreatedByResourceID', 'ActivityDateTime', 'StartDateTime', 'EndDateTime', 'HoursWorked', 'DeletedByResourceID', 'DeletedDateTime')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('TaskNumber', 'NoteOrAttachmentTitle')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('TaskNumber', 'NoteOrAttachmentTitle')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('TaskNumber', 'NoteOrAttachmentTitle')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('TaskNumber', 'NoteOrAttachmentTitle')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('TaskNumber', 'NoteOrAttachmentTitle')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ActivityDateTime', 'StartDateTime', 'EndDateTime', 'DeletedDateTime')]
    [string[]]
    $IsThisDay
  )

    begin { 
        $entityName = 'DeletedTaskActivityLog'
    
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
    
    }


    process {
        # Parameterset Get_All has a single parameter: -All
        # Set the Filter manually to get every single object of this type 
        if ($PSCmdlet.ParameterSetName -eq 'Get_all') { 
            $Filter = @('id', '-ge', 0)
        }
        # So it is not -All. If Filter does not exist it has to be By_parameters
        elseif (-not ($Filter)) {
    
            Write-Debug ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)
      
            # Convert named parameters to a filter definition that can be parsed to QueryXML
            [string[]]$Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $entityName
        }
        # Not parameters, nor Get_all. There are only three parameter sets, so now we know
        # that we were passed a Filter
        else {
      
            Write-Debug ('{0}: Query based on manual filter, parsing' -F $MyInvocation.MyCommand.Name)
            
            # Parse the filter string and expand variables in _this_ scope (dot-sourcing)
            # or the variables will not be available and expansion will fail
            $Filter = . Update-AtwsFilter -Filterstring $Filter
        } 

        # Prepare shouldProcess comments
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to query the Autotask Web API for {1}(s).' -F $caption, $entityName
        $verboseWarning = '{0}: About to query the Autotask Web API for {1}(s). Do you want to continue?' -F $caption, $entityName
    
        # Lets do it and say we didn't!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
    
            # Make the query and pass the optional parameters to Get-AtwsData
            $result = Get-AtwsData -Entity $entityName -Filter $Filter `
                -NoPickListLabel:$NoPickListLabel.IsPresent `
                -GetReferenceEntityById $GetReferenceEntityById `
                -GetExternalEntityByThisEntityId $GetExternalEntityByThisEntityId
    
            Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $result.Count)

        }
    }

    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        if ($result) {
            Return $result
        }
    }


}
