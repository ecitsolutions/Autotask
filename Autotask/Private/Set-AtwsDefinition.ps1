Function Set-AtwsDefinition { 
    begin { 
        $entityName = '#EntityName'
    
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {
            $DebugPreference = 'Continue'
        }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
           
        # Collect fresh copies of InputObject if passed any IDs
        # Has to collect in batches, or we are going to get the 
        # dreaded 'too nested SQL' error
        If ($Id.count -gt 0) { 
            $InputObject = @()
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
    }

    process {

        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to modify {1} {2}(s). This action cannot be undone.' -F $caption, $InputObject.Count, $entityName
        $verboseWarning = '{0}: About to modify {1} {2}(s). This action cannot be undone. Do you want to continue?' -F $caption, $InputObject.Count, $entityName

        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
            
            Write-Verbose $verboseDescription

            # Process parameters and update objects with their values
            $processObject = $InputObject | Update-AtwsObjectsWithParameters -BoundParameters $PSBoundParameters -EntityName $EntityName
            
            $ModifiedObjects = Set-AtwsData -Entity $processObject
        
        }
    
    }

    end {
        Write-Debug ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $ModifiedObjects.count, $entityName)
        if ($PassThru.IsPresent) { 
            Return $ModifiedObjects
        }
    }
}
