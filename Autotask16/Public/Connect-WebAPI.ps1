<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md  for license information.

#>

Function Connect-WebAPI {
  <#
      .SYNOPSIS
      This function connects to the Autotask Web Services API, authenticates a user and creates a 
      SOAP webservices proxy object. The connection object is cached on a per Prefix basis.
      .DESCRIPTION
      The function takes a credential object and uses it to authenticate and connect to the Autotask
      Web Services API. This is done by creating a webservices proxy. The proxy object imports the SOAP 
      WSDL definition file, creates all entity classes in PowerShell and exposes the basic methods
      (query(), create(), update(), remove(), GetEntityInfo(), GetFieldInfo() and a few more). 

      Using private functions this module continues to import information about entities and which fields
      each entity has. It uses this information to create and import a dynamic module pr Prefix. 
      Each module contains a complete set of PowerShell functions pr enntity. All entities gets a
      Get-PrefixEntity function. Any updateable entities gets a Set-PrefixEntity function. All 
      creatable entities gets a New-PrefixEntity function and all deletable objects gets a 
      Remove-PrefixEntity function.

      The per Prefix structure is important. It allows you to connect to Autotask with two or more 
      different user accounts from two or more different Autotask tenants. This will allow you to 
      automate between tenants. You can import and export data between tenants, transfer tickets, 
      updates tickets in tenant2 from tickets in tenant1 and so on.
      .INPUTS
      A PSCredential object. Required. It will prompt for credentials if the object is not provided.
      .OUTPUTS
      A webserviceproxy object is created.
      .EXAMPLE
      Connect-AtwsWebAPI
      Prompts for a username and password and authenticates to Autotask
      .EXAMPLE
      Connect-AtwsWebAPI
      .NOTES
      NAME: Connect-AtwsWebAPI
      .LINK
      Get-AtwsData
  #>
	
  [cmdletbinding()]
  Param
  (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]    
    [pscredential]
    $Credential,
    
    [Parameter(Mandatory = $true)]
    [String]
    $ApiTrackingIdentifier
  )
    
  Begin { 
    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
    $ModuleName = $MyInvocation.MyCommand.Module.Name
    
    $Global:AtwsCredential = $Credential
    $Global:AtwsApiTrackingIdentifier = $ApiTrackingIdentifier
  }
  
  Process { 
    Try 
    { 
      Import-Module -Name $ModuleName -Global -Force -Variable $Global:Credential, $Global:ApiTrackingIdentifier -ErrorAction Stop
    }
    Catch 
    {
      $Module = Get-Module -Name $ModuleName
      $ModulePath = $Module.ModuleBase
      Import-Module $ModulePath -Global -Force -Variable $Global:AtwsCredential, $Global:AtwsApiTrackingIdentifier
    }
  }
  
  End {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
  }
    
    
}
