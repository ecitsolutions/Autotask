# How to connect

To connect to the Autotask API you need the **username and password of type API user** and an **API security key**. The security key is created on the user object in the Autotask GUI.

## Connect automatically

To connect automatically you need a default connection profile. If you save a connection profile without explicitly giving it a name with `-Name` or `-ProfileName` it will be saved as default. Whenever you call a cmdlet from the module it will check for an already established connection. If you aren't connected already it will call `Connect-AtwsWebApi` without any parameters.

## Connection profiles

To make it easier to connect to the API and have the PowerShell module behave more like a normal PowerShell module we use connection profiles. When you load the module and execute a commandlet it will check for a stored connection profile and use it to connect. To create a new connection profile you may just call any command and have it prompt you for credentials and offer to save it for you.

```terminal
PowerShell credential request
Your Autotask API user
User: username@domain.com
Password for user username@domain.com: ***************
API Tracking Identifier: ***************************
WARNING: Do you want to save these credentials as your Default connection profile? It will be encrypted using SecureString and encoded in CliXML. See Get-Help Set-AtwsModuleConfiguration for how to modify it.
Save connection credentials
Is it OK to save your credentials to your $Profile folder?
[Y] Yes [N] No [S] Suspend [?] Help (default is "Yes"): ?
```

To do this programatically or to have a bit more control you can also create it with PowerShell.

```powershell
$User = "username@domain.com"
$PWord = ConvertTo-SecureString -String "password" -AsPlainText -Force
$Credential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $User, $PWord
$ApiTrackingIdentifier = ConvertTo-SecureString -String 'xxxxxxxxxxxxxxxxxxxxxxxxxxx' -AsPlainText -Force

$configuration = New-AtwsModuleConfiguration -Credential $Credential -SecureTrackingIdentifier $ApiTrackingIdentifier

Save-AtwsModuleConfiguration -Configuration $configuration
```

If you have more than 1 API user, a separate sandbox implementation or work with multiple Autotask instances you may create multiple profiles with separate names.

```powershell
$User = "username@DOMAINSB15022021.com"
$PWord = ConvertTo-SecureString -String "password" -AsPlainText -Force
$Credential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $User, $PWord
$ApiTrackingIdentifier = ConvertTo-SecureString -String 'xxxxxxxxxxxxxxxxxxxxxxxxxxx' -AsPlainText -Force

$configuration = New-AtwsModuleConfiguration -Credential $Credential -SecureTrackingIdentifier $ApiTrackingIdentifier

Save-AtwsModuleConfiguration -Name Sandbox -Configuration $configuration
```

You may switch between profiles quickly when ever you like without reloading the module. You just call Connect-AtwsWebApi with the right profile name.

```powershell
Connect-AtwsWebAPI
Get-AtwsAccount -id 0 | Select-Object AccountName

Connect-AtwsWebAPI -Name Sandbox
Get-AtwsAccount -id 0 | Select-Object AccountName

AccountName
-----------
Company Name
Company Name Sandbox
```

## Connect-AtwsWebApi

From `Get-Help Connect-AtwsWebApi`:

```text
NAME
    Connect-AtwsWebAPI
    
SYNOPSIS
    This function connects to the Autotask Web Services API, authenticates a user and creates a 
    SOAP webservices proxy object.
    
    
SYNTAX
    Connect-AtwsWebAPI [-ProfilePath <FileInfo>] [-ProfileName <String>] [-WhatIf] [-Confirm] [<CommonPara
    meters>]
    
    Connect-AtwsWebAPI -Credential <PSCredential> -ApiTrackingIdentifier <String> [-ConvertPicklistIdToLab
    el] [-Prefix <String>] [-RefreshCache] [-NoDiskCache] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    Connect-AtwsWebAPI -AtwsModuleConfiguration <PSObject> [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    The function takes a credential object and uses it to authenticate and connect to the Autotask
    Web Services API. This is done by creating a webservices proxy. The proxy object imports the SOAP 
    WSDL definition file, creates all entity classes in PowerShell and exposes the basic methods
    (query(), create(), update(), remove(), GetEntityInfo(), GetFieldInfo() and a few more).
    

PARAMETERS
    -Credential <PSCredential>
        The username and password for your Autotask API user
        
    -ApiTrackingIdentifier <String>
        The API tracking identifier from your Autotask API user
        
    -ConvertPicklistIdToLabel [<SwitchParameter>]
        Have the module substitute all picklist ids for their textlabel at runtime
        
    -Prefix <String>
        It can be empty, but if it isn't it should be max 8 characters and only letters and numbers
        Not used. Kept for backwards compatility. Will be removed soon.
        
    -RefreshCache [<SwitchParameter>]
        Not used. Kept for backwards compatility. Will be removed soon.
        
    -NoDiskCache [<SwitchParameter>]
        Not used. Kept for backwards compatility. Will be removed soon.
        
    -AtwsModuleConfiguration <PSObject>
        A module configuration object created with New-AtwsModuleConfiguration
        
    -ProfilePath <FileInfo>
        The path to an alternate clixml file with connection profiles
        
    -ProfileName <String>
        Name of the Configuration inside the Config file.
        The name for the connection profile you want to use. Default is "Default".
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > Connect-AtwsWebAPI
    If there doesn't exist any saved Default connection profile it prompts for a username and password and authenticates to Autotask. Otherwise it loads the connection profile named "Default" and connects.

    -------------------------- EXAMPLE 2 --------------------------
    
    PS > Connect-AtwsWebAPI -ProfileName Sandbox
    Loads the connection profile named 'Sandbox' and connects. If there are no saved connection profile called 'Sandbox' it throws an exception and exits.
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS > Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $ApiKey
    Connects to Autotask using the credentials passed as parameters
   
    -------------------------- EXAMPLE 4 --------------------------
    
    PS > New-AtwsModuleConfiguration -Credential $Credential -ApiTrackingIdentifier $ApiKey -Dateconversion Disabled | Connect-AtwsWebAPI
    Creates a new module configuration object with date conversion between EST (the Autotask API always uses EST no matter which data center you are connected to) and local time disabled.
    
REMARKS
    To see the examples, type: "Get-Help Connect-AtwsWebAPI -Examples"
    For more information, type: "Get-Help Connect-AtwsWebAPI -Detailed"
    For technical information, type: "Get-Help Connect-AtwsWebAPI -Full"
    For online help, type: "Get-Help Connect-AtwsWebAPI -Online"
```