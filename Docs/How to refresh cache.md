# How to refresh or ignore cached functions

By default the dynamic module is cached to disk. The Autotask module creates a cache per [Prefix][1]. If the current user has write permissions to the **%ProgramFiles%\WindowsPowerShell\Modules** the module will create the cache there. If not, then the cache will be created in the **WindowsPowerShell\Modules** folder in the current users *Documents* folder.

By default the cache is created the first time you [connect using a particular Prefix][1]. The cache is refreshed whenever you connect and the Autotask module version or the Autotask Web services API version has been updated. The cache is also refreshed if you suddenly connect to a different Autotask tenant with a previously used Prefix.

## About Picklists

When the disk cache is created or refreshed, all entities and the fields of entities are downloaded from the Autotask API. This includes tenant specific Picklists, such as Queue names, Product categories and a host of other things. Any picklist is included in functions as a way to provide **IntelliSense** information and parameter validation. So whenever you have made a change to Autotask that involves a picklist being changed or updated you will have to refresh the disk cache.

## Refreshing or ignoring the disk cache

```powershell
# Force refresh the disk cache
Connect-AutotaskWebAPI -Credential $Credential -RefreshCache

# Run without using a disk cache - recreate all functions on every connect
Connect-AutotaskWebAPI -Credential $Credential -NoDiskCache

# Limit yourself to loading just authenticating the base module - no dynamic module at all
Connect-AutotaskWebAPI -Credential $Credential -NoDynamicModule

# Without the dynamic module you only have access to the four base functions:
Get-AtwsData
Set-AtwsData
New-AtwsData
Remove-AtwsData
```

While we recommend using our dynamic module for better IntelliSense support and parameter validation, you do not have to. The four base functions can do everything the dynamic module can, but working with them demands a deeper working knowledge of the API. While in some cases you may consider it a strength that the base functions do not need to be updated if the API is updated or Picklists are changed, we still think the dynamic module is what most people should use.

[1]: https://github.com/officecenter/Autotask/blob/master/Docs/Prefixes%20and%20multiple%20connections.md