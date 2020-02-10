#Requires -Version 4.0
#Version 1.6.4.1
<#

.COPYRIGHT
Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.

#>
Function New-AtwsHolidaySet
{


<#
.SYNOPSIS
This function creates a new HolidaySet through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.HolidaySet] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the HolidaySet with Id number 0 you could write 'New-AtwsHolidaySet -Id 0' or you could write 'New-AtwsHolidaySet -Filter {Id -eq 0}.

'New-AtwsHolidaySet -Id 0,4' could be written as 'New-AtwsHolidaySet -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new HolidaySet you need the following required fields:
 -HolidaySetName

Entities that have fields that refer to the base entity of this CmdLet:

BusinessLocation
 Holiday

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.HolidaySet]. This function outputs the Autotask.HolidaySet that was created by the API.
.EXAMPLE
$result = New-AtwsHolidaySet -HolidaySetName [Value]
Creates a new [Autotask.HolidaySet] through the Web Services API and returns the new object.
 .EXAMPLE
$result = Get-AtwsHolidaySet -Id 124 | New-AtwsHolidaySet 
Copies [Autotask.HolidaySet] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsHolidaySet -Id 124 | New-AtwsHolidaySet | Set-AtwsHolidaySet -ParameterName <Parameter Value>
Copies [Autotask.HolidaySet] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsHolidaySet to modify the object.
 .EXAMPLE
$result = Get-AtwsHolidaySet -Id 124 | New-AtwsHolidaySet | Set-AtwsHolidaySet -ParameterName <Parameter Value> -Passthru
Copies [Autotask.HolidaySet] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsHolidaySet to modify the object and returns the new object.

.LINK
Remove-AtwsHolidaySet
 .LINK
Get-AtwsHolidaySet
 .LINK
Set-AtwsHolidaySet

#>

  [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName='By_parameters', ConfirmImpact='Low')]
  Param
  (
# An array of objects to create
    [Parameter(
      ParametersetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.HolidaySet[]]
    $InputObject,

# Holiday Set Name
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [Alias('Name')]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,64)]
    [string]
    $HolidaySetName,

# Holiday Set Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,512)]
    [string]
    $HolidaySetDescription
  )
 
    begin { 
        $entityName = 'HolidaySet'
           
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
        Write-Debug -Message ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
        $processObject = @()
    }

    process {
    
        if ($InputObject) {
            Write-Verbose -Message ('{0}: Copy Object mode: Setting ID property to zero' -F $MyInvocation.MyCommand.Name)  

            $fields = Get-AtwsFieldInfo -Entity $entityName
      
            $CopyNo = 1

            foreach ($object in $InputObject) { 
                # Create a new object and copy properties
                $newObject = New-Object -TypeName Autotask.$entityName
        
                # Copy every non readonly property
                $fieldNames = $fields.Where( { $_.Name -ne 'id' }).Name

                if ($PSBoundParameters.ContainsKey('UserDefinedFields')) { 
                    $fieldNames += 'UserDefinedFields' 
                }

                foreach ($field in $fieldNames) { 
                    $newObject.$field = $object.$field 
                }

                if ($newObject -is [Autotask.Ticket]) {
                    Write-Verbose -Message ('{0}: Copy Object mode: Object is a Ticket. Title must be modified to avoid duplicate detection.' -F $MyInvocation.MyCommand.Name)  
                    $title = '{0} (Copy {1})' -F $newObject.Title, $CopyNo
                    $copyNo++
                    $newObject.Title = $title
                }
                $processObject += $newObject
            }   
        }
        else {
            Write-Debug -Message ('{0}: Creating empty [Autotask.{1}]' -F $MyInvocation.MyCommand.Name, $entityName) 
            $processObject += New-Object -TypeName Autotask.$entityName    
        }
        
        # Prepare shouldProcess comments
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to create {1} {2}(s). This action cannot be undone.' -F $caption, $processObject.Count, $entityName
        $verboseWarning = '{0}: About to create {1} {2}(s). This action may not be undoable. Do you want to continue?' -F $caption, $processObject.Count, $entityName

        # Lets don't and say we did!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
            
            # Process parameters and update objects with their values
            $processObject = $processObject | Update-AtwsObjectsWithParameters -BoundParameters $PSBoundParameters -EntityName $EntityName
            
            $result = Set-AtwsData -Entity $processObject -Create
        }
    }

    end {
        Write-Debug -Message ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $result.count, $entityName)
        Return $result
    }

}
