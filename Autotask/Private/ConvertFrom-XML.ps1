<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md  for license information.

#>

Function ConvertFrom-XML {
  <#
      .SYNOPSIS
      This function converts an array of XML elements to a custom psobject for easier parsing and coding.
      .DESCRIPTION
      The function an array of XML elements and recursively converts each element to a custom PowerShell
      object. Each XML property is converted to an object property with a value of datetime, double, 
      integer or string. 
      .INPUTS
      [System.XML.XmlElement []]
      .OUTPUTS
      [System.Object[]]
      .EXAMPLE
      $Element | ConvertTo-PSObject
      Converts variable $Element with must contain 1 or more Xml.XmlElements to custom PSobjects with the
      same content.
      .NOTES
      NAME: ConvertTo-PSObject
      
  #>
  [cmdletbinding()]
  Param
  (
    [Parameter(
      Mandatory = $True,
      ValueFromPipeLine = $True,
      ParameterSetName = 'Input_Object'
    )]
    [Xml.XmlElement[]]
    $InputObject
  )

  Begin {
    $Result = @()

    # Set up TimeZone offset handling
    If (-not($script:ESTzone)) {
      $script:ESTzone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Eastern Standard Time")
    }
    
    If (-not($script:ESToffset)) {
      $Now = Get-Date
      $ESTtime = [System.TimeZoneInfo]::ConvertTimeFromUtc($Now.ToUniversalTime(), $ESTzone)

      $script:ESToffset = (New-TimeSpan -Start $Now -End $ESTtime).TotalHours 
    }
  }
  Process {
        
    Foreach ($Element in $InputObject) {
      # Get properties 
      $Properties = $Element | Get-Member -MemberType Property 
    
      # Create a new, empty object
      $Object = New-Object -TypeName PSObject
    
      # Loop through all properties and add a member for each
      Foreach ($Property in $Properties) {
        # We are accessing property values by dynamic naming. It is a lot easier
        # to reference dynamic property names with a string variable
        $PropertyName = $Property.Name
            
        # Extract/create a value based on the property definition string
        Switch -Wildcard ($Property.Definition) {
            
          # Most properties are returned as strings. We will use a few tests to 
          # try to recognise other value types
          'string*' {
            # Test if it is a date first
            Try {
              # If it isn't a date we'll get an exception
              [DateTime]$DateTime = $Element.$PropertyName
                  
              # If we are here, then we have a date.
              $Value = $DateTime.AddHours($script:ESToffset)
            }
            Catch {
              # This isn't a date. We'll use a regex to avoid turning integers into doubles
              Switch -regex ($Element.$PropertyName) { 
                '^\d+\.\d{4}$' { 
                  [Double]$Double = $Element.$PropertyName
                  $Value = $Double
                }
                    
                '^\d+$' { 
                  [Int]$Integer = $Element.$PropertyName
                  $Value = $Integer
                }
                Default 
                {$Value = $Element.$PropertyName}
              }
            }
            Add-Member -InputObject $Object -MemberType NoteProperty -Name $PropertyName -Value $Value                                              
          }
              
          # For properties that are XML elements; recurse
          'System.Xml.XmlElement*' {
            # A bit of recursive magic here...
            $Value = $Element.$PropertyName | ConvertFrom-XML
            Add-Member -InputObject $Object -MemberType NoteProperty -Name $PropertyName -Value $Value                              
          }
              
          # Arrays.  Loop through elements and perform recursive magic
          'System.Object*' {
            $Value = @()
            Foreach ($Item in $Element.$PropertyName) 
            {$Value += $Item | ConvertFrom-XML}
            Add-Member -InputObject $Object -MemberType NoteProperty -Name $PropertyName -Value $Value                              
          }
              
          # Blatant misuse of the default clause for saving a bit of typing...
        }
      }
    }

    $Result += $Object
  }

  End {
    Return $Result
  }
}
