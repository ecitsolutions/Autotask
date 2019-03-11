# Prefixes and multiple connections

By default our PowerShell module uses the prefix *Atws* for all functions. But when you connect to the API you may choose any prefix you want:

```powershell
Import-Module Autotask -Prefix Company1 -Verbose -Variable $Credential, $ApiKey 
```

This will create API functions like *Get-Company1Account* and *Get-Company1Contract*. This makes it possible to connect to either the same Autotask tenant with different users, or even two different Autotask tenants:

```powershell
$Company1Credential = Get-Credential
$ApiKey1 = "xxx...x"
$Company2Credential = Get-Credential
$ApiKey2 = "yyy...y"

Import-Module Autotask -Prefix Company1 -Verbose -Variable $Company1Credential, $ApiKey1
# To load the module again using a different prefix, user -Force
Import-Module Autotask -Force -Prefix Company2 -Verbose -Variable $Company2Credential, $ApiKey2
```

This makes it possible to import and export some data between Autotask tenants, or even automate workflows, synchronize prices, synchronize configuration items (installed products) or contacts.