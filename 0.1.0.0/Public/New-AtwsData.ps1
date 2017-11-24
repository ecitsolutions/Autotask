<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function New-AtwsData 
{
  [cmdletbinding()]
  param
  (
    [Parameter(
        Mandatory = $True,
        Position = 0
    )]
    $Entity
  )
   
  Write-Verbose ('{0}: Creating a new object of type Autotask.{1}' -F $MyInvocation.MyCommand.Name, $Entity) 
  New-Object -TypeName Autotask.$Entity

}