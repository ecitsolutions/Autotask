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
    
   New-Object -TypeName Autotask.$Entity

}