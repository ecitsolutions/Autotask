#Requires -Version 4.0
#Version 1.6.13
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsUserDefinedFieldDefinition
{


<#
.SYNOPSIS
This function get one or more UserDefinedFieldDefinition through the Autotask Web Services API.
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

UdfType
 

DataType
 

DisplayFormat
 

Entities that have fields that refer to the base entity of this CmdLet:

InstalledProductCategoryUdfAssociation
 UserDefinedFieldListItem

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.UserDefinedFieldDefinition[]]. This function outputs the Autotask.UserDefinedFieldDefinition that was returned by the API.
.EXAMPLE
Get-AtwsUserDefinedFieldDefinition -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsUserDefinedFieldDefinition -UserDefinedFieldDefinitionName SomeName
Returns the object with UserDefinedFieldDefinitionName 'SomeName', if any.
 .EXAMPLE
Get-AtwsUserDefinedFieldDefinition -UserDefinedFieldDefinitionName 'Some Name'
Returns the object with UserDefinedFieldDefinitionName 'Some Name', if any.
 .EXAMPLE
Get-AtwsUserDefinedFieldDefinition -UserDefinedFieldDefinitionName 'Some Name' -NotEquals UserDefinedFieldDefinitionName
Returns any objects with a UserDefinedFieldDefinitionName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsUserDefinedFieldDefinition -UserDefinedFieldDefinitionName SomeName* -Like UserDefinedFieldDefinitionName
Returns any object with a UserDefinedFieldDefinitionName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsUserDefinedFieldDefinition -UserDefinedFieldDefinitionName SomeName* -NotLike UserDefinedFieldDefinitionName
Returns any object with a UserDefinedFieldDefinitionName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsUserDefinedFieldDefinition -UdfType <PickList Label>
Returns any UserDefinedFieldDefinitions with property UdfType equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsUserDefinedFieldDefinition -UdfType <PickList Label> -NotEquals UdfType 
Returns any UserDefinedFieldDefinitions with property UdfType NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsUserDefinedFieldDefinition -UdfType <PickList Label1>, <PickList Label2>
Returns any UserDefinedFieldDefinitions with property UdfType equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsUserDefinedFieldDefinition -UdfType <PickList Label1>, <PickList Label2> -NotEquals UdfType
Returns any UserDefinedFieldDefinitions with property UdfType NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsUserDefinedFieldDefinition -Id 1234 -UserDefinedFieldDefinitionName SomeName* -UdfType <PickList Label1>, <PickList Label2> -Like UserDefinedFieldDefinitionName -NotEquals UdfType -GreaterThan Id
An example of a more complex query. This command returns any UserDefinedFieldDefinitions with Id GREATER THAN 1234, a UserDefinedFieldDefinitionName that matches the simple pattern SomeName* AND that has a UdfType that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.

.LINK
New-AtwsUserDefinedFieldDefinition
 .LINK
Set-AtwsUserDefinedFieldDefinition

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
    [ValidateSet('InstalledProductCategoryUdfAssociation:UserDefinedFieldDefinitionID', 'UserDefinedFieldListItem:UdfFieldId')]
    [string]
    $GetExternalEntityByThisEntityId,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,45)]
    [string[]]
    $Name,

# Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [string[]]
    $Description,

# Udf Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $UdfType,

# Data Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $DataType,

# Default Value
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,1024)]
    [string[]]
    $DefaultValue,

# Field Mapping
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $IsFieldMapping,

# Protected
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $IsProtected,

# Required
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $IsRequired,

# Active
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $IsActive,

# Create Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CreateDate,

# Merge Variable Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $MergeVariableName,

# Crm to Project Udf Id
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $CrmToProjectUdfId,

# Display Format
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string[]]
    $DisplayFormat,

# Sort Order
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $SortOrder,

# Number of Decimal Places
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $NumberOfDecimalPlaces,

# Visible to Client Portal
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $IsVisibleToClientPortal,

# Encrypted
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $IsEncrypted,

# Is Private
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $IsPrivate,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'UdfType', 'DataType', 'DefaultValue', 'IsFieldMapping', 'IsProtected', 'IsRequired', 'IsActive', 'CreateDate', 'MergeVariableName', 'CrmToProjectUdfId', 'DisplayFormat', 'SortOrder', 'NumberOfDecimalPlaces', 'IsVisibleToClientPortal', 'IsEncrypted', 'IsPrivate')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'UdfType', 'DataType', 'DefaultValue', 'IsFieldMapping', 'IsProtected', 'IsRequired', 'IsActive', 'CreateDate', 'MergeVariableName', 'CrmToProjectUdfId', 'DisplayFormat', 'SortOrder', 'NumberOfDecimalPlaces', 'IsVisibleToClientPortal', 'IsEncrypted', 'IsPrivate')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'UdfType', 'DataType', 'DefaultValue', 'IsFieldMapping', 'IsProtected', 'IsRequired', 'IsActive', 'CreateDate', 'MergeVariableName', 'CrmToProjectUdfId', 'DisplayFormat', 'SortOrder', 'NumberOfDecimalPlaces', 'IsVisibleToClientPortal', 'IsEncrypted', 'IsPrivate')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'UdfType', 'DataType', 'DefaultValue', 'CreateDate', 'MergeVariableName', 'CrmToProjectUdfId', 'DisplayFormat', 'SortOrder', 'NumberOfDecimalPlaces')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'UdfType', 'DataType', 'DefaultValue', 'CreateDate', 'MergeVariableName', 'CrmToProjectUdfId', 'DisplayFormat', 'SortOrder', 'NumberOfDecimalPlaces')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'UdfType', 'DataType', 'DefaultValue', 'CreateDate', 'MergeVariableName', 'CrmToProjectUdfId', 'DisplayFormat', 'SortOrder', 'NumberOfDecimalPlaces')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'Name', 'Description', 'UdfType', 'DataType', 'DefaultValue', 'CreateDate', 'MergeVariableName', 'CrmToProjectUdfId', 'DisplayFormat', 'SortOrder', 'NumberOfDecimalPlaces')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'DefaultValue', 'MergeVariableName')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'DefaultValue', 'MergeVariableName')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'DefaultValue', 'MergeVariableName')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'DefaultValue', 'MergeVariableName')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('Name', 'Description', 'DefaultValue', 'MergeVariableName')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDate')]
    [string[]]
    $IsThisDay
  )

    begin { 
        $entityName = 'UserDefinedFieldDefinition'
    
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
