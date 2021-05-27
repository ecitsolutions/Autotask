# How to connect on Azure

To connect to the Autotask API on Azure you need the **username and password of type API user** and an **API security key** stored as resources. The `Connect-AtwsWebApi` cmdlet will check if it is running on Azure and look for resources by name if it is. You do not need to connect explicitly. As all other functions will call `Connect-AtwsWebApi` automatically if they aren't already connected you can just use the module as you would any other PowerShell module. Import it and use it.

## Azure Automation - Runbooks

If you are using the module from an Azure PowerShell runbook you should add the following resources to your automation account:

* AtwsDefaultCredential [credential] - Your Autotask API user stored as a credential object
* AtwsDefaultSecureIdentifier [string] - The cleartext tracking identifier from your Autotask API user

## Azure Functions

To connect automatically from an Azure Function you need to create 3 environment variables:

* AtwsUsername [string] - the username for your Autotask API user
* AtwsPassword [string] - the cleartext password for your Autotask API user
* AtwsTrackingIdentifier [string] - the cleartext tracking identifier from your Autotask API user
