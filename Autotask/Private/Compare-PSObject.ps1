Function Compare-PSObject {
  [CmdLetBinding()]
  Param
  (   
    [Parameter(
        Mandatory = $True,
        Position = 0
    )]
    [PSObject[]]
    $ReferenceObject,
    
    [Parameter(
        Mandatory = $True,
        ValueFromPipeLine = $True,
        Position = 1
    )]
    [PSObject[]]
    $DifferenceObject
  )
  
  Begin {
    # Setup objects for use
    $ReferenceStream = New-Object System.IO.MemoryStream
    $DifferenceStream = New-Object System.IO.MemoryStream
        
    $Binary = New-Object System.Runtime.Serialization.Formatters.Binary.BinaryFormatter
    $Algorithm = [Security.Cryptography.HashAlgorithm]::Create("MD5")
    
    $Identical = $True
  }
  
  Process 
  { 
    <#
        # Serialize data using BinaryFormatter
        $Binary.Serialize($ReferenceStream, $ReferenceObject)
    
        # Reset Stream position
        $ReferenceStream.Position = 0
    
        $ReferenceHash = -join ($Algorithm.ComputeHash($ReferenceStream) | ForEach-Object -Process {"{0:x2}" -f $_}) 
    
        # Serialize data using BinaryFormatter
        $Binary.Serialize($DifferenceStream, $DifferenceObject)
      
        # Reset Stream position
        $DifferenceStream.Position = 0
      
        $DifferenceHash = -join ($Algorithm.ComputeHash($DifferenceStream) | ForEach-Object -Process {"{0:x2}" -f $_}) 
      
        If ($ReferenceHash -ne $DifferenceHash) {
        $Identical = $False
        }
    #>
    $PropertyList = $ReferenceObject[0] | Get-Member -MemberType Property, NoteProperty | ForEach-Object Name

    Foreach ($Object in $ReferenceObject) {
      $Index = $ReferenceObject.IndexOf($Object)
      $Difference = Compare-Object -ReferenceObject $Object -DifferenceObject $DifferenceObject[$Index] -Property $PropertyList
      If ($Difference) {
        $Identical = $False
        Break
      }
    }
    
  }
  
  End {
    Return $Identical
  }
}