Function Copy-PSObject {
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