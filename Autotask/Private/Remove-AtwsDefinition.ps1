Function Remove-AtwsDefinition { 
    begin { 
        $entityName = '#EntityName'
    
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

        # Collect copies of InputObject if passed any IDs
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

        }

        Write-Verbose ('{0}: Deleting {1} object(s) from Autotask' -F $MyInvocation.MyCommand.Name, $InputObject.Count)

        if ($InputObject) { 
      
            $caption = $MyInvocation.MyCommand.Name
            $verboseDescription = '{0}: About to delete {1} {2}(s). This action cannot be undone.' -F $caption, $InputObject.Count, $entityName
            $verboseWarning = '{0}: About to delete {1} {2}(s). This action cannot be undone. Do you want to continue?' -F $caption, $InputObject.Count, $entityName

            if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
                Remove-AtwsData -Entity $InputObject
            }
        }
    }

    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    }

}