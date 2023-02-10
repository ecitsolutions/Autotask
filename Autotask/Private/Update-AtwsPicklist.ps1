<#

    .COPYRIGHT
    Copyright (c) Hugo Klemmestad. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.

#>
Function Update-AtwsPickList {
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
        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter({
            param($Cmd, $Param, $Word, $Ast, $FakeBound)
            $script:FieldInfoCache.keys
        })]
        [string]
        $Entity,

        [switch]
        $UserDefinedFields
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

        # GEt entityinfo without touching the API
        $entityInfo = Get-AtwsFieldInfo -Entity $Entity -EntityInfo -CacheOnly

        # Normal request 
        if (-not ($UserDefinedFields.IsPresent)) { 
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
            foreach ($field in $result) {
                # Skip fields without picklists
                if ($entityInfo['PicklistFields'] -notcontains $field.Name) { continue }

                $picklistValues = @{}

                # Convert array of name/value pairs to hashtables with direct lookup
                if ($field.PickListParentValueField) {
                    foreach ($p in $field.PicklistValues) { 
                        if ($p.IsActive) {
                            if (-not ($picklistValues.ContainsKey($p.ParentValue))) {
                                $picklistValues[$p.ParentValue] = @{
                                    byValue = @{}
                                    byLabel = @{}
                                }
                            }
                            $picklistValues[$p.ParentValue]['byValue'][$p.Value] = $p.Label 
                            $picklistValues[$p.ParentValue]['byLabel'][$p.Label] = $p.Value
                        }
                    }
                    
                }
                else {
                    $picklistValues['byValue'] = @{}
                    $picklistValues['byLabel'] = @{}
                    foreach ($p in $field.PicklistValues) { 
                        if ($p.IsActive) { 
                            $picklistValues['byValue'][$p.Value] = $p.Label 
                            $picklistValues['byLabel'][$p.Label] = $p.Value
                        }
                    }
                }

                $script:FieldInfoCache[$Entity]['FieldInfo'][$field.Name]['PicklistValues'] = $picklistValues
            }

        }
        # We have userdefinedfields.ispresent
        elseIf ($script:FieldInfoCache[$Entity].HasUserDefinedFields) { 

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

            foreach ($field in $UDF) {
                # A per field hashtable with info 
                $picklistValues = @{}

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
                    $script:FieldInfoCache[$Entity]['UDFInfo'][$field.Name]['PicklistValues'] = @{
                        byValue = $byValue
                        byLabel = $byLabel
                    }
                }

            }
        }
        $script:FieldInfoCache[$Entity]['RetrievalTime'] = Get-Date
    }

    end {
    }
}