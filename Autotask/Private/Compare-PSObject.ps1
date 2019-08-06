<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Compare-PSObject {
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
    Param
    (   
        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [PSObject[]]
        $ReferenceObject,
    
        [Parameter(
            Mandatory = $true,
            ValueFromPipeLine = $true,
            Position = 1
        )]
        [PSObject[]]
        $DifferenceObject
    )
  
    begin {

        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

        # A bright hope for an identical future
        $identical = $true
    }
  
    process { 

        
        Write-Verbose ('{0}: Comparing collection of {1} objects to  calling default URI {2}' -F $MyInvocation.MyCommand.Name, $ReferenceObject.Count, $DefaultUri)

        # Both objects must have the same number of items
        if ($ReferenceObject.Count -eq $DifferenceObject.Count) {

            # Compare collections both ways, any object in one should exist in the other
            foreach ($object in $ReferenceObject) {
                # Get the index of the current object
                $index = $ReferenceObject.IndexOf($object)

                # Is it a system.<type>?
                if ($object.GetType().Fullname -match 'System\.\w+$' -and $object -ne $DifferenceObject[$index]) { 
                    $identical = $false
                    break
                }
                else { 
                    # Get the names of the properties
                    $propertyList = $object | Get-Member -MemberType Property, NoteProperty | ForEach-Object Name

                    # Compare all properties with the object with same index in other collection
                    $difference = Compare-Object -ReferenceObject $object -DifferenceObject $DifferenceObject[$index] -Property $propertyList
                    if ($difference) {
                        $identical = $false
                        break
                    }
                    
                }

                
            }            
        }
        else {
            $identical = $false
        }
    
    }
  
    end {
        
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

        Return $identical
    }
}