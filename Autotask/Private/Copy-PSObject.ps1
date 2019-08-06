<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Copy-PSObject {
    <#
      .SYNOPSIS
        This function makes a copy of any object by value, not reference.
      .DESCRIPTION
        This function makes a copy of any object by value, not reference. PowerShell by default copies
        any object by reference. Any changes made to the copy is also made to the original as they are
        the same object. This functions makes a copy of the original object by value, leaving the 
        original object unchanged when you modify the copy.

        NB: The copy is made using serialization which may adversely affect some object types.
      .INPUTS
        [PSObject]
      .OUTPUTS
        [PSObject]
      .EXAMPLE
        $NewObject = Copy-PSObject $Object
        Creates a new object with the same value as $Object.      
      .EXAMPLE
        $NewObject = Copy-PSObject -InputObject $Object
        Creates a new object with the same value as $Object.      
      .EXAMPLE
        $Object | $NewObject = Copy-PSObject
        Creates a new object with the same value as $Object.
      .NOTES
      NAME: Copy-PSObject
      .LINK

  #>
    [CmdLetBinding()]
    Param
    (   
        [Parameter(
            Mandatory = $true,
            ValueFromPipeLine = $true,
            Position = 0
        )]
        [PSObject]
        $InputObject
    )
  
    begin {

        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
        # Setup objects for use
        $Stream = New-Object System.IO.MemoryStream
        $Binary = New-Object System.Runtime.Serialization.Formatters.Binary.BinaryFormatter
    }
  
    Process { 
        Write-Verbose ('{0}: Making a copy of a(n) {1} object' -F $MyInvocation.MyCommand.Name, $InputObject.GetType().FullName)

        # Serialize data using BinaryFormatter
        $Binary.Serialize($Stream, $InputObject)
    
        # Reset Stream position
        $Stream.Position = 0
    }
  
    end {

        # Return a copy of the original object
        $Binary.Deserialize($Stream)
    
        # Close the stream
        $Stream.Close()

        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

    }
}