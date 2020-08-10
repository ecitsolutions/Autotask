<#

.COPYRIGHT
Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.

#>

Function Get-AtwsfunctionDefinition {
     <#
      .SYNOPSIS

      .DESCRIPTION

      .INPUTS

      .OUTPUTS

      .EXAMPLE

      .NOTES
      NAME: 
      .LINK

  #>
    [CmdLetBinding()]
    [OutputType([PSObject[]])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [PSObject]
        $Entity
    )
   
    begin {

        # Hashtable for storing all function properties
        $functionDefinition = @{ }
        
        # A container for all valid verbs for a function
        $verbs = @()

        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

    }

    process { 
    
        # Collect valid verbs based on Autotask.EntityInfo for the current entity
        if ($Entity.CanCreate) {
            $verbs += 'New'
        }
        if ($Entity.CanDelete) {
            $verbs += 'Remove'
        }
        if ($Entity.CanQuery) {
            $verbs += 'Get'
        }
        if ($Entity.CanUpdate) {
            $verbs += 'Set'
        }

    
        # Loop through the valid verbs and generate functions for each of them
        foreach ($verb in $verbs) {
            $functionName = '{0}-Atws{1}' -F $verb, $Entity.Name

            Write-Verbose ('{0}: Creating Function {1}' -F $MyInvocation.MyCommand.Name, $functionName)
    
            $confirmImpact = switch ($verb) {
                'New' { 'Low' }
                'Remove' { 'Low' }
                'Get' { 'None' }
                'Set' { 'Low' }
            }
      
            $defaultParameterSetName = switch ($verb) {
                'New' { 'By_parameters' }
                'Remove' { 'Input_Object' }
                'Get' { 'Filter' }
                'Set' { 'InputObject' }
            }
     
            $atwsFunction = New-Object -TypeName PSObject -Property @{
                FunctionName            = $functionName
                Copyright               = Get-Copyright
                HelpText                = Get-AtwsHelpText -Entity $Entity -verb $verb -functionName $functionName
                DefaultParameterSetName = $defaultParameterSetName 
                ConfirmImpact           = $confirmImpact
                Parameters              = Get-AtwsParameterDefinition -Entity $Entity -verb $verb
                Definition              = (Get-Command ('{0}-AtwsDefinition' -F $verb)).Definition -replace '#EntityName', $($Entity.Name)
            }
    
            $functionDefinition[$functionName] = Convert-AtwsFunctionToText -AtwsFunction $atwsFunction
   
        }
    }
  
    end { 
        Return $functionDefinition
    }
}
