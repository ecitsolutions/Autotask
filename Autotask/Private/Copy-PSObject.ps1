<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Copy-PSObject {
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
            ValueFromPipeLine = $true,
            Position = 0
        )]
        [PSObject]
        $InputObject
    )
  
    begin {
        # Setup objects for use
        $Stream = New-Object System.IO.MemoryStream
        $Binary = New-Object System.Runtime.Serialization.Formatters.Binary.BinaryFormatter
    }
  
    Process { 
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
    }
}