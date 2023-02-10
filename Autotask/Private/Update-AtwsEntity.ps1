<#

    .COPYRIGHT
    Copyright (c) Hugo Klemmestad. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.

#>
Function Update-AtwsEntity {
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
    [CmdLetBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Low',
        DefaultParameterSetName = 'by_Entity'
    )]
    Param
    (
        [Parameter(
            Mandatory = $true
        )]
        [string]
        $Entity
    )

    begin { 
        Write-Verbose ('{0}: Begin of function' -f $MyInvocation.MyCommand.Name)

        # Check if we are connected before trying anything
        if (-not($Script:Atws)) {
            throw [ApplicationException] 'Not connected to Autotask WebAPI. Connect with Connect-AtwsWebAPI. For help use "get-help Connect-AtwsWebAPI".'
            return
        }
    }

    process {
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to get built-in fields for {1}s' -F $caption, $Entity
        $verboseWarning = '{0}: About to get built-in fields for {1}s. Do you want to continue?' -F $caption, $Entity

        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
        
            Write-Verbose -Message ("{0}: Calling .GetFieldInfo('{1}')" -f $MyInvocation.MyCommand.Name,$Entity) 
          
            try { 
                $result = $Script:Atws.GetFieldInfo($Script:Atws.IntegrationsValue, $Entity)
            }
            catch {
                Throw $_
                Return
            }
                 
            if ($result.Errors.Count -gt 0) {
                foreach ($AtwsError in $result.Errors) {
                    Write-Error $AtwsError.Message
                }
                Return
            }
        }
      
        # Store result in fieldinfocache
        Write-Verbose ('{0}: Save or update FieldInfo cache for entity {1}' -f $MyInvocation.MyCommand.Name,$Entity)

        # Create hashtable for faster lookup
        $fieldInfo = @{}
        $requiredFields = [Collections.Generic.list[string]]::new()
        $queryableFields = [Collections.Generic.list[string]]::new()
        $writableFields = [Collections.Generic.list[string]]::new()
        $picklistFields = [Collections.Generic.list[string]]::new()
        $externalReferences = @{}
        $notBooleanFields = [Collections.Generic.list[string]]::new()
        $stringFields = [Collections.Generic.list[string]]::new()
        $datetimeFields = [Collections.Generic.list[string]]::new()
        $HasPickList = $false
        foreach ($field in $result) {
            $fieldTable = @{}
            
            # Collect required fields
            if ($field.name -ne 'id' -and $field.IsRequired) {
                $requiredFields.add($field.name)
            }

            # Collect queryable fields
            if ($field.IsQueryable) {
                $queryableFields.add($field.name)
            }

            # Collect all writable fields
            if (-not ($field.IsReadOnly)) {
                $writableFields.add($field.name)
            }

            # Collect external references
            if ($field.IsReference) {
                $externalReferences[$field.name] = $field.ReferenceEntityType
            }

            # Collect all fields but boolean for -gt, -ge, -lt and -le queries
            if ($field.Type -ne 'Boolean') {
                $notBooleanFields.add($field.name)
            }

            # Collect string fields for -like, -beginswith and -endswith
            if ($field.Type -eq 'String') {
                $stringFields.add($field.name)
            }

            # Collect datetime fields
            if ($field.Type -eq 'Datetime') {
                $datetimeFields.add($field.name)
            }

            # Add all properties to hashtable
            foreach ($property in $field.psobject.properties) {
                $fieldTable[$property.Name] = $property.Value
            }

            # Convert array of name/value pairs to hashtables with direct lookup
            if ($field.IsPickList) {
                $HasPickList = $true
                $picklistFields += $field.name
                $fieldTable['PicklistValues'] = @{}
                if ($field.PickListParentValueField) {
                    foreach ($p in $field.PicklistValues) { 
                        if ($p.IsActive) {
                            if (-not ($fieldTable['PicklistValues'].ContainsKey($p.ParentValue))) {
                                $fieldTable['PicklistValues'][$p.ParentValue] = @{
                                    byValue = @{}
                                    byLabel = @{}
                                }
                            }
                            $fieldTable['PicklistValues'][$p.ParentValue]['byValue'][$p.Value] = $p.Label 
                            $fieldTable['PicklistValues'][$p.ParentValue]['byLabel'][$p.Label] = $p.Value
                        }
                    }
                    
                }
                else {
                    $fieldTable['PicklistValues']['byValue'] = @{}
                    $fieldTable['PicklistValues']['byLabel'] = @{}
                    foreach ($p in $field.PicklistValues) { 
                        if ($p.IsActive) { 
                            $fieldTable['PicklistValues']['byValue'][$p.Value] = $p.Label 
                            $fieldTable['PicklistValues']['byLabel'][$p.Label] = $p.Value
                        }
                    }
                }
            }
            $fieldInfo[$field.Name] = $fieldTable
        }
        $script:FieldInfoCache[$Entity]['FieldInfo'] = $fieldInfo
        $script:FieldInfoCache[$Entity]['HasPicklist'] = $HasPickList
        $script:FieldInfoCache[$Entity]['RequiredFields'] = $requiredFields
        $script:FieldInfoCache[$Entity]['QueryableFields'] = $queryableFields
        $script:FieldInfoCache[$Entity]['WriteableFields'] = $writableFields
        $script:FieldInfoCache[$Entity]['PicklistFields'] = $picklistFields
        $script:FieldInfoCache[$Entity]['ExternalReferences'] = $externalReferences
        $script:FieldInfoCache[$Entity]['NotBooleanFields'] = $notBooleanFields
        $script:FieldInfoCache[$Entity]['StringFields'] = $stringFields
        $script:FieldInfoCache[$Entity]['DatetimeFields'] = $datetimeFields

        
        if ($script:FieldInfoCache[$Entity].HasUserDefinedFields) { 
            $caption = $MyInvocation.MyCommand.Name
            $verboseDescription = '{0}: About to get userdefined fields for {1}s' -F $caption, $Entity
            $verboseWarning = '{0}: About to get userdefined fields for {1}s. Do you want to continue?' -F $caption, $Entity

            if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
                $UDF = $Script:Atws.GetUDFInfo($Script:Atws.IntegrationsValue, $Entity)
                 
                if ($result.Errors.Count -gt 0) {
                    foreach ($AtwsError in $result.Errors) {
                        Write-Error $AtwsError.Message
                    }
                    Return
                }
            }
          
            # Store result
            Write-Verbose ('{0}: Save or update UDF cache for entity {1}' -f $MyInvocation.MyCommand.Name,$Entity)
                    
            # Convert UDF info to hashtable for quick lookup
            $udfInfo = @{}
            foreach ($field in $UDF) {
                # A per field hashtable with info 
                $fieldTable = @{}

                # Add all properties
                foreach ($property in $field.psobject.properties) {
                    $fieldTable[$property.Name] = $property.Value
                }

                # Convert array of name/value pairs to hashtables with direct lookup
                if ($field.IsPickList) {
                    $byValue = @{}
                    $byLabel = @{}
                    foreach ($p in $field.PicklistValues) { 
                        if ($p.IsActive) { 
                            $byValue[$p.Value] = $p.Label 
                            $byLabel[$p.Label] = $p.Value
                        }
                    }
                    $fieldTable['PicklistValues'] = @{
                        byValue = $byValue
                        byLabel = $byLabel
                    }
                }
                $udfInfo[$field.Name] = $fieldTable  

            }
            $script:FieldInfoCache[$Entity]['UDFInfo'] = $udfInfo
        }
        $script:FieldInfoCache[$Entity]['RetrievalTime'] = Get-Date
    }

    end {
    }
}