
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsParameterDefinition {
    <#
        .SYNOPSIS
            This function returns a complete parameter set for a given entity and verb.
        .DESCRIPTION
            This function takes an entity as EntityInfo, an array of FieldInfo and a verb.
            It creates a set of default parameters and then loops through all fields in
            FieldInfo and adds them as parameters with validation sets for picklists, 
            correct type and help texts.
        .INPUTS
            Autotask.EntityInfo
            String, validateset get, set, new, remove
        .OUTPUTS
            Text
        .EXAMPLE
            Get-AtwsParameterDefinition -Entity $EntityInfo -FieldInfo $FieldInfo -Verb Get

        .NOTES
            NAME: Get-AtwsParameterDefinition
        .LINK
            Get-AtwsPSParameter
  #>
    [CmdLetBinding()]
    Param
    (   
        [Parameter(Mandatory)]
        [PSObject]
        $Entity,
        
        [Parameter(Mandatory)]
        [ValidateSet('Get', 'Set', 'New', 'Remove')]
        [string]
        $Verb
    )
    
    begin {

        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
        
        $Mandatory = @{ }
        $parameterSet = @{ }
    }

    process { 
        $TypeName = 'Autotask.{0}' -F $Entity.Name

        # Add Default PSParameter info to Fields
        foreach ($field in $Entity['FieldInfo'].GetEnumerator()) {
            $Mandatory[$field.key] = $field.Value.IsRequired
            $parameterSet[$field.key] = @('By_parameters')
        }

        if ($Verb -eq 'Get') {
            # -Filter
            $Comment = 'A filter that limits the number of objects that is returned from the API'
            Get-AtwsPSParameter -Name 'Filter' -SetName 'Filter' -Type 'string' -Mandatory -Remaining -NotNull  -Array -Comment $Comment
            $ReferenceFields = $Entity['ExternalReferences'].Values
            # -GetReferenceEntityById, -GetRef
            $Comment = 'Follow this external ID and return any external objects'            
            Get-AtwsPSParameter -Name 'GetReferenceEntityById' -Alias 'GetRef' -SetName 'Filter', 'By_parameters' -Type 'string' -NotNull -ValidateSet $ReferenceFields -Comment $Comment
            # -GetExternalEntityByThisEntityId, -External
            $IncomingReferenceEntities = $Entity['IncomingReferences'].Keys
            $Comment = 'Return entities of selected type that are referencing to this entity.'
            Get-AtwsPSParameter -Name 'GetExternalEntityByThisEntityId' -Alias 'External' -SetName 'Filter', 'By_parameters' -Type 'string' -NotNull -ValidateSet $IncomingReferenceEntities -Comment $Comment
            # -All
            $Comment = 'Return all objects in one query'    
            Get-AtwsPSParameter -Name 'All' -SetName 'Get_all' -Type 'switch' -Comment $Comment
            if ($Entity.HasUserDefinedFields) {
                # -UserDefinedField
                $Comment = 'A single user defined field can be used pr query'
                Get-AtwsPSParameter -Name 'UserDefinedField' -Alias 'UDF' -SetName 'By_parameters' -Type 'Autotask.UserDefinedField' -NotNull -Comment $Comment
            }
        }    
        elseif ($Verb -eq 'Set') {
            # -InputObject
            $Comment = 'An object that will be modified by any parameters and updated in Autotask'
            Get-AtwsPSParameter -Name 'InputObject' -SetName 'Input_Object' -Type $TypeName -Mandatory -Pipeline -NotNull -Array -Comment $Comment
            # -Id
            $field = $Entity['FieldInfo']['Id']
            $Comment = 'The object.ids of objects that should be modified by any parameters and updated in Autotask'
            Get-AtwsPSParameter -Name 'Id' -SetName 'By_Id' -Type $field.Type -Mandatory -NotNull -Array -Comment $Comment
            # -PassThru
            $Comment = 'Return any updated objects through the pipeline'
            Get-AtwsPSParameter -Name 'PassThru' -SetName 'Input_Object', 'By_parameters' -Type 'switch' -Comment $Comment
            if ($Entity.HasUserDefinedFields) {
                # -UserDefinedFields
                $Comment = 'User defined fields already setup i Autotask'
                Get-AtwsPSParameter -Name 'UserDefinedFields' -Alias 'UDF' -SetName 'Input_Object', 'By_parameters' -Type 'Autotask.UserDefinedField' -Array -Comment $Comment
            }
        }
        elseif ($Verb -in 'New') {
            # -InputObject
            $Comment = 'An array of objects to create'          
            Get-AtwsPSParameter -Name 'InputObject' -SetName 'Input_Object' -Type $TypeName -Mandatory -Pipeline -NotNull -Array -Comment $Comment
            if ($Entity.HasUserDefinedFields) {
                # -UserDefinedFields
                $Comment = 'User defined fields already setup i Autotask'
                Get-AtwsPSParameter -Name 'UserDefinedFields' -Alias 'UDF' -SetName 'By_parameters' -Type 'Autotask.UserDefinedField' -NotNull -Array -Comment $Comment
            }
        }
        elseif ($Verb -eq 'Remove') {
            # -InputObject
            $Comment = 'Any objects that should be deleted'          
            Get-AtwsPSParameter -Name 'InputObject' -SetName 'Input_Object' -Type $TypeName -Mandatory -Pipeline -NotNull -Array -Comment $Comment
            # -Id
            $field = $Entity['FieldInfo']['Id']
            $Comment = 'The unique id of an object to delete'
            Get-AtwsPSParameter -Name 'Id' -SetName 'By_parameters' -Type $field.Type -Mandatory  -NotNull -Array -Comment $Comment
        }
    

        switch ($Verb) {
            'Get' { 
                [array]$fields = $Entity['QueryableFields'] | ForEach-Object {
                    $Mandatory[$_] = $false
                    $Entity['FieldInfo'][$_]
                }
            }
            'Set' { 
                if (($Entity.ContainsKey('WriteableFields'))) {
                    [array]$fields = $Entity['WriteableFields'] | ForEach-Object {
                        $parameterSet[$_] = @('Input_Object', 'By_parameters', 'By_Id')
                        $Entity['FieldInfo'][$_]
                    }
                }
            }
            'New' {
                [array]$fields = $Entity['FieldInfo'].GetEnumerator()  | ForEach-Object {
                    if ($_.Key -ne 'id') { $_.Value }
                }
            }
            default {
                return
            }

        }
    
        # Add Name alias for EntityName parameters
        $entityNameParameter = '{0}Name' -f $Entity.Name
        foreach ($field in $fields | sort-object -property name) {
            # Start with native field type
            $Type = $field.Type

            # Fieldtype for picklists
            if ($field.IsPickList) {
                $Type = 'string'
                $ValidateLength = 0
            }
            else {
                $ValidateLength = $field.Length
            }

      
            $Alias = @() 
            if ($field.Name -eq $entityNameParameter) {
                $Alias += 'Name'
            }

            $parameterOptions = @{
                Mandatory              = $Mandatory[$field.Name]
                ParameterSetName       = $parameterSet[$field.Name]
                ValidateNotNullOrEmpty = $field.IsRequired
                ValidateLength         = $ValidateLength
                ValidateSet            = @()
                isPicklist             = $field.IsPickList
                PickListParentValueField = $field.PickListParentValueField
                Array                  = $(($Verb -eq 'Get'))
                Name                   = $field.Name
                EntityName             = $Entity.Name
                Alias                  = $Alias
                Type                   = $Type
                Comment                = $field.Label
                Nullable               = $Verb -ne 'New' -and $Type -ne 'string'
            }

            Get-AtwsPSParameter @ParameterOptions
        }
    
    
        # Make modifying operators possible
        if ($Verb -eq 'Get') {
            # These operators work for all fields (add quote characters here)
            [array]$Labels = $Entity['FieldInfo'].keys
            if ($Entity.HasUserDefinedFields) { $Labels += $Entity['UserDefinedFields'].keys }
            foreach ($Operator in 'NotEquals', 'IsNull', 'IsNotNull') {
                Get-AtwsPSParameter -Name $Operator -SetName 'By_parameters' -Type 'string' -Array -ValidateSet $Labels
            }

            # These operators work for all fields except boolean (add quote characters here)
            [array]$Labels = $Entity['NotBooleanFields']
            if ($Entity.HasUserDefinedFields) { $Labels += 'UserDefinedField' }
            foreach ($Operator in 'GreaterThan', 'GreaterThanOrEquals', 'LessThan', 'LessThanOrEquals') {
                Get-AtwsPSParameter -Name $Operator -SetName 'By_parameters' -Type 'string' -Array -ValidateSet $Labels
            }

            # These operators only work for strings (add quote characters here)
            [array]$Labels = $Entity['StringFields']
            if ($Entity.HasUserDefinedFields) { $Labels += 'UserDefinedField' }
            foreach ($Operator in 'Like', 'NotLike', 'BeginsWith', 'EndsWith', 'Contains') {
                Get-AtwsPSParameter -Name $Operator -SetName 'By_parameters' -Type 'string' -Array -ValidateSet $Labels
            }
      
            # This operator only work for datetime (add quote characters here)
            [array]$Labels = $Entity['DateTimeFields']
            if ($Entity.HasUserDefinedFields) { $Labels += 'UserDefinedField' }
            foreach ($Operator in 'IsThisDay') {
                Get-AtwsPSParameter -Name $Operator -SetName 'By_parameters' -Type 'string' -Array -ValidateSet $Labels
            }
        }
    }

    end {
        return
    }
}
