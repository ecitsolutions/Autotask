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
      [System.XML.Xmlelement []]
      .OUTPUTS
      [System.Object[]]
      .EXAMPLE
      $element | ConvertFrom-XML
      Converts variable $element with must contain 1 or more Xml.Xmlelements to custom PSobjects with the
      same content.
      .NOTES
      NAME: ConvertFrom-XML
      
  #>
    [cmdletbinding()]
    Param
    (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeLine = $true,
            ParameterSetName = 'Input_Object'
        )]
        [Xml.Xmlelement[]]
        $InputObject
    )

    begin {
 
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
        
        $result = @()

        # Set up TimeZone offset handling
        if (-not($script:ESTzone)) {
            $script:ESTzone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Eastern Standard Time")
        }
    
        if (-not($script:ESToffset)) {
            $now = Get-Date
            $ESTtime = [System.TimeZoneInfo]::ConvertTimeFromUtc($now.ToUniversalTime(), $ESTzone)

            $script:ESToffset = (New-TimeSpan -Start $now -End $ESTtime).TotalHours 
        }
    }
    process {
        
        foreach ($element in $InputObject) {
            # Get properties 
            $properties = $element | Get-Member -MemberType property 
    
            # Create a new, empty object
            $object = New-Object -TypeName PSObject
    
            # Loop through all properties and add a member for each
            foreach ($property in $properties) {
                # We are accessing property values by dynamic naming. It is a lot easier
                # to reference dynamic property names with a string variable
                $propertyName = $property.Name
            
                # Extract/create a value based on the property definition string
                switch -Wildcard ($property.Definition) {
            
                    # Most properties are returned as strings. We will use a few tests to 
                    # try to recognise other value types
                    'string*' {
                        # Test if it is a date first
                        if ($element.$propertyName -match '([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))') {
                            # Convert to a Datetime object
                            [DateTime]$dateTime = $element.$propertyName
                  
                            # Add timezone difference
                            $value = $dateTime.AddHours($script:ESToffset)
                        }
                        else {
                            # This isn't a date. We'll use a regex to avoid turning integers into doubles
                            switch -regex ($element.$propertyName) { 
                                '^\d+\.\d{4}$' { 
                                    [Double]$double = $element.$propertyName
                                    $value = $double
                                }
                    
                                '^\d+$' { 
                                    [Int]$Integer = $element.$propertyName
                                    $value = $Integer
                                }
                                Default 
                                { $value = $element.$propertyName }
                            }
                        }
                        Add-Member -InputObject $object -MemberType Noteproperty -Name $propertyName -Value $value                                              
                    }
              
                    # For properties that are XML elements; recurse
                    'System.Xml.Xmlelement*' {
                        # A bit of recursive magic here...
                        $value = $element.$propertyName | ConvertFrom-XML
                        Add-Member -InputObject $object -MemberType Noteproperty -Name $propertyName -Value $value                              
                    }
              
                    # Arrays.  Loop through elements and perform recursive magic
                    'System.Object*' {
                        $value = @()
                        foreach ($Item in $element.$propertyName) 
                        { $value += $Item | ConvertFrom-XML }
                        Add-Member -InputObject $object -MemberType Noteproperty -Name $propertyName -Value $value                              
                    }
              
                }
            }
        }

        $result += $object
    }

    end {
        Return $result
    }
}