Function Compare-PSObject {
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
        # Setup objects for use
        $ReferenceStream = New-Object System.IO.MemoryStream
        $DifferenceStream = New-Object System.IO.MemoryStream
        
        $Binary = New-Object System.Runtime.Serialization.Formatters.Binary.BinaryFormatter
        $Algorithm = [Security.Cryptography.HashAlgorithm]::Create("MD5")
    
        $Identical = $true
    }
  
    process { 
        <#
        # Serialize data using BinaryFormatter
        $Binary.Serialize($ReferenceStream, $ReferenceObject)
    
        # Reset Stream position
        $ReferenceStream.Position = 0
    
        $ReferenceHash = -join ($Algorithm.ComputeHash($ReferenceStream) | foreach-Object -process {"{0:x2}" -f $_}) 
    
        # Serialize data using BinaryFormatter
        $Binary.Serialize($DifferenceStream, $DifferenceObject)
      
        # Reset Stream position
        $DifferenceStream.Position = 0
      
        $DifferenceHash = -join ($Algorithm.ComputeHash($DifferenceStream) | foreach-Object -process {"{0:x2}" -f $_}) 
      
        if ($ReferenceHash -ne $DifferenceHash) {
        $Identical = $false
        }
    #>
        $PropertyList = $ReferenceObject[0] | Get-Member -MemberType Property, NoteProperty | ForEach-Object Name

        foreach ($object in $ReferenceObject) {
            $Index = $ReferenceObject.IndexOf($object)
            $Difference = Compare-Object -ReferenceObject $object -DifferenceObject $DifferenceObject[$Index] -Property $PropertyList
            if ($Difference) {
                $Identical = $false
                Break
            }
        }
    
    }
  
    end {
        Return $Identical
    }
}