<#

    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.

#>

Function Set-AtwsData {
    <#
      .SYNOPSIS
      This function creates or updates one or more Autotask entities with new or modified properties.
      .DESCRIPTION
      This function creates or updates one or more Autotask entities with new or modified properties
      .INPUTS
      [PSObject[]]. One or more Autotask entities to update
      .OUTPUTS
      [PSObject[]]. The updated entities are re-downloaded from the API.
      .EXAMPLE
      Set-AtwsData -Entity $Entity
      Passes all Autotask entities in $Entity to the Autotask webservices API using the .update() method
      .EXAMPLE
      Set-AtwsData -Entity $Entity -Create
      Passes all Autotask entities in $Entity to the Autotask webservices API using the .create() method
      .NOTES
      NAME: Set-AtwsData
      .LINK
      Get-AtwsData
      Remove-AtwsData
  #>

    [cmdletbinding()]
    [OutputType([Collections.Generic.List[psobject]])]
    param
    (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Collections.Generic.List[psobject]]
        $Entity,

        [switch]
        $Create
    )


    begin {
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {
            $DebugPreference = 'Continue'
        }

        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

        if (-not($Script:Atws.integrationsValue)) {
            Throw [ApplicationException] 'Not connected to Autotask WebAPI. Connect with Connect-AtwsWebAPI. For help use "get-help Connect-AtwsWebAPI".'
        }

        # reset errorcounter
        $errorCount = 0
    }

    process {
        If ($Create.IsPresent) {
            Write-Verbose ('{0}: Calling .Create() for {1} objects of type {2}' -F $MyInvocation.MyCommand.Name, $Entity.Count, $Entity[0].GetType().Name)
        }
        Else {
            Write-Verbose ('{0}: Calling .Update() for {1} objects of type {2}' -F $MyInvocation.MyCommand.Name, $Entity.Count, $Entity[0].GetType().Name)
        }

        # Convert from local time and label settings
        $Entity = $Entity | ConvertFrom-LocalObject

        # update() function can take up to 200 objects at a time
        for ($i = 0; $i -lt $Entity.count; $i += 200) {
            $j = $i + 199
            if ($j -ge $Entity.count) {
                $j = $Entity.count - 1
            }
            Write-Debug -Message ('{0}: Creating chunk from index {1} to index {2}' -F $MyInvocation.MyCommand.Name, $i, $j)

            # Explicit selection of list type. Generic lists supports .remove()
            $workingSet = [Collections.Generic.List[psobject]]::new()
            if($Entity[$i .. $j].Count -gt 1){
                $workingSet.AddRange($Entity[$i .. $j])
            }else {
                $workingSet.Add($Entity[0])
            }

            # We are going to try multiple times if the first attempt fails
            Do {
                # Reset error list
                $errors = @()

                # Are we creating or updating?
                if ($Create.IsPresent) {
                    # We are creating. i.e. New-
                    $result = $atws.create($Script:Atws.integrationsValue, $workingSet)

                    # Check for duplicates
                    $duplicates = $result.EntityReturnInfoResults | Where-Object { $_.DuplicateStatus.Found -and -not $_.DuplicateStauts.Ignored }

                    foreach ($duplicate in $duplicates) {
                        Write-Warning ('{0}: Duplicate found for Object Id {1} on {2}' -F $MyInvocation.MyCommand.Name, $duplicate.EntityId, $duplicate.DuplicateStatus.MatchInfo)
                    }
                }
                else {
                    # We are updating
                    $result = $atws.update($Script:Atws.integrationsValue, $workingSet)
                }

                for ($t = 0; $t -lt $result.errors.Count; $t += 2) {
                    # Count the errors, we have a limit
                    $errorCount++

                    # First line is the error message
                    $message = $result.errors[$t].Message

                    if ($result.errors.Count -gt $t) {
                        # Next line may include the element index, first element = 1
                        if ($result.errors[$t + 1].Message -match '\[(\d+)\]') {

                            [int]$index = $Matches[1]
                        }
                        else {
                            $index = 1
                        }
                    }

                    # Powershell arrays has first element = 0
                    $index--

                    # Get the element
                    $element = $workingSet[$index]

                    # Remove element from Workingset
                    $errors += $element

                    # Notify caller of skipped element
                    Write-Warning ('Element with index {0} of type {1} with Id {2} was skipped because {3}' -F $Entity.IndexOf($element), $element.GetType().Name, $element.id, $message)
                }

                # .remove() any errors from the workingSet
                foreach ($element in $errors) {
                    $workingSet.Remove($element)
                }

                # Keep on trying until there are no errors, the workingSet is empty (every element failed)
                # or the error limit has been reached
            } Until ($result.errors.Count -eq 0 -or $workingSet.Count -eq 0 -or $errorCount -ge $Script:Atws.Configuration.ErrorLimit)


            # We have tried multiple times! Still errors?
            if ($result.errors.Count -eq 0) {
                # The API documentation explicitly states that you can only use the objects returned
                # by the .create()  or .set() function to get the new objects ID.
                # so to return objects with accurately represents what has been created we have to
                # get them again by id

                # But not all objects support queries, for instance service adjustments,
                # so we need the entity info to determine if we can make a query
                $EntityInfo = Get-AtwsFieldInfo -Entity $result.EntityResultType -EntityInfo

                if ($result.EntityResults.Count -gt 0 -and $EntityInfo.CanQuery) {
                    $newObjectFilter = 'id -eq {0}' -F ($result.EntityResults.Id -join ' -or id -eq ')

                    $endResult += Get-AtwsData -Entity $result.EntityResultType -Filter $newObjectFilter
                }
            }
            else {
                # Still errors. Throw an exception.
                throw ($result.errors.Message -join "`n")
                Break
            }
        }
    }
    end {
        if ($endResult.count -gt 0) {

            Write-Debug ('{0}: End of function, returning {1} updated {2}(s)' -F $MyInvocation.MyCommand.Name, $result.count, $result[0].GetType().Name)
            Return $endResult
        }
        else {
            Write-Debug ('{0}: End of function, no objects to return.' -F $MyInvocation.MyCommand.Name, $result.count)
        }
    }
}

