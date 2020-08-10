<#

    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.

#>

Function Get-AtwsPicklistValue {
    <#
        .SYNOPSIS
            This function gets valid fields for an Autotask Entity
        .DESCRIPTION
            This function gets valid fields for an Autotask Entity
        .INPUTS
            None.
        .OUTPUTS
            [Autotask.Field[]]
        .EXAMPLE
            Get-AtwsFieldInfo -Entity Account
            Gets all valid built-in fields and user defined fields for the Account entity.
  #>
	
    [cmdletbinding(
        DefaultParameterSetName = 'by_Entity'
    )]
    Param
    (
        [Parameter(
            ParameterSetName = 'by_Entity'
        )]
        [Parameter(
            ParameterSetName = 'as_Labels'
        )]
        [Parameter(
            ParameterSetName = 'as_Values'
        )]
        [Alias('UDF')]
        [switch]
        $UserDefinedFields, 
        
        [Parameter(
            ParameterSetName = 'as_Labels'
        )]
        [switch]
        $Label, 

        [Parameter(
            ParameterSetName = 'as_Values'
        )]
        [switch]
        $Value, 

        [Parameter(
            Mandatory = $true,
            Position = 0,
            ParameterSetName = 'by_Entity'
        )]
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ParameterSetName = 'as_Labels'
        )]
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ParameterSetName = 'as_Values'
        )]
        [string]
        $Entity,

        [Parameter(
            Mandatory = $true,
            Position = 1,
            ParameterSetName = 'by_Entity'
        )]
        [Parameter(
            Mandatory = $true,
            Position = 1,
            ParameterSetName = 'as_Labels'
        )]
        [Parameter(
            Mandatory = $true,
            Position = 2,
            ParameterSetName = 'as_Values'
        )]
        [string]
        $FieldName
    )
    
    begin { 
    
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
        # Check if we are connected before trying anything
        if (-not($Script:Atws)) {
            throw [ApplicationException] 'Not connected to Autotask WebAPI. Connect with Connect-AtwsWebAPI. For help use "get-help Connect-AtwsWebAPI".'
            return
        }

        # Prepare an empty container for a result
        $picklistValues = @()
    }
  
    process { 

        
        Write-Verbose -Message ('{0}: Looking up detailed Fieldinfo for entity {1}' -F $MyInvocation.MyCommand.Name, $Entity) 
        
        if ($UserDefinedFields.IsPresent -and $script:FieldInfoCache[$Entity].HasUserDefinedFields) {

            $picklistValues = (Get-AtwsFieldInfo -Entity $Entity -FieldName $FieldName -UserDefinedFields).PicklistValues
    
            Write-Debug -Message ('{0}: Entity {1} has userdefined fields and user defined field {2} has {3} picklist values.' -F $MyInvocation.MyCommand.Name, $Entity, $FieldName, $result.count) 
        }
        elseIf ($script:FieldInfoCache[$Entity].HasPicklist) { 
    
            $picklistValues = (Get-AtwsFieldInfo -Entity $Entity -FieldName $FieldName).PicklistValues
    
            Write-Debug -Message ('{0}: Entity {1} has picklists and field {2} has {3} picklist values.' -F $MyInvocation.MyCommand.Name, $Entity, $FieldName, $result.count) 
        }
 

        if ($picklistValues.count -gt 0 ) {
            if ($picklistValues.keys -contains 'byValue') {
                # No parentfieldname
                $result = switch ($PSCmdlet.ParameterSetName) {
                    'by_Entity' {
                        $result = $picklistValues.byValue
                    }
                    'as_Labels' {
                        $picklistValues.byLabel.keys
                    }
                    'as_Values' {
                        $picklistValues.byLabel.values
                    }
                }

            }
            # Take parentfieldname into account
            else {
                $result = switch ($PSCmdlet.ParameterSetName) {
                    'by_Entity' {
                        $result = $picklistValues
                    }
                    'as_Labels' {
                        $picklistValues.Values.byLabel.keys
                    }
                    'as_Values' {
                        $picklistValues.Values.byLabel.values
                    }
                }
            }
        }
    }  
    end {

        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        
        if ($result.count -gt 0) {
            return $result
        }
        
    }
       
}
