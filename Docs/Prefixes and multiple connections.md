# Prefixes and multiple connections

By default our PowerShell module uses the prefix *Atws* for all functions. But when you connect to the API you may choose any prefix you want:

```powershell
Connect-AutotaskWebAPI -Credential $Credential -Prefix Company1 -Verbose
```

This will create API functions like *Get-Company1Account* and *Get-Company1Contract*. This makes it possible to connect to either the same Autotask tenant with different users, or even two different Autotask tenants:

```powershell
$Company1Credential = Get-Credential
$Company2Credential = Get-Credential

Connect-AutotaskWebAPI -Credential $Company1Credential -Prefix Company1 -Verbose
Connect-AutotaskWebAPI -Credential $Company2Credential -Prefix Company2 -Verbose
```

This makes it possible to import and export some data between Autotask tenants, or even automate workflows, synchronize prices, synchronize configuration items (installed products) or contacts.