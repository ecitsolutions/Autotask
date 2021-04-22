# Important upgrade

> From version 2 the module no longer needs to maintain a per tenant disk cache. Any picklists are resolved dynamically using [ArgumentCompleter](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/register-argumentcompleter?view=powershell-7).

## Content

* [Basics](#basics)
* [Disclaimer and Warning](#disclaimer-and-warning)
* [Release Notes](#release-notes)
* [How to connect][8]
* [How to *Get* data from the API][4]
* [How to create *New* entities through the API][5]
* [How to make changes to entities][6]
* [How to delete entities][7]
  
## Basics

Install the module from PowerShell Gallery (the published module version is based on branch "master". Any prerelease version is based on a snapshot of "Development"):

```powershell
# Download and install the module
Install-Module Autotask

# Connect to the Autotask Web Services API
$Credential = Get-Credential # Your Autotask API user and password
$ApiKey = "<the API identifier from your resource in Autotask>"
Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $ApiKey

# Save your credentials locally (NB! Will be exported as SecureString in CliXML)
New-AtwsModuleConfiguration -Credential $Credential -ApiTrackingIdentifier $ApiKey -ProfileName Default

# Module can now load and connect automatically, so you can run any command directly
Get-AtwsAccount -id 0

# New options, can be changed at runtime with Set-AtwsModuleConfiguration
New-AtwsModuleConfiguration -PickListExpansion <String> (Disabled|Inline|Labelfield)
New-AtwsModuleConfiguration -UdfExpansion <String>      (Disabled|Inline|Hashtable)
New-AtwsModuleConfiguration -DateConversion <String>    (Disabled|Local|speficic/timezone)

Get-Help New-AtwsModuleConfiguration
```

## Disclaimer and Warning

**Be careful!** This module exposes all the Autotask Web Services API entities and methods as PowerShell functions. This makes it very easy to make a lot of changes very quickly. **But there is no undo!** If you use this module to destroy or delete anything in your Autotask tenant you did not intend to - you are entirely on your own! This module is provided "as is", without warranty of any kind, express or implied. In **no event** shall the authors or copyright holders be liable for any claim, damages or other liability ([see the license][3]). If this is not acceptable to you - do not use it!

## Release notes

### Version 2.0.0-beta6 - Release candidate 2 (not released yet)

* UPDATE: Running Connect-AtwsWebApi without parameters or a saved profile will prompt for credentials and offer to save them
* BUGFIX: A few more bugs was found and fixed
  
### Version 2.0.0-beta5 - Release candidate 1

* NEW: Module finally supports automatic loading - just install module and run a command to automatically connect (if you do not have a saved profile yet you will be prompted for credentials interactively)
* NEW: Support automatic connection on Azure Automation (runbooks) and Azure Functions without separate connection code
* NEW: A fix for the 'SQL too nested' error has been found that cover most use cases
* NEW: Conversion of datetime to/from local time is now configurable `Set-AtwsModuleConfiguration -DateConversion (Disabled|Local|'specific/timezone')`
* NEW: UserDefinedFields can now be added to return object as separate properties or a hashtable (object.UDF) `Set-AtwsModuleConfiguration -UdfExpansion (Disabled|Inline|Hashtable)`
* NEW: Properties with picklists can now have index values replaced with text labels or have text labels added as extra property `Set-AtwsModuleConfiguration -PicklistExpansion (Disabled|Inline|LabelField)`
* UPDATE: A lot of Pester tests have been added to make sure the new module version still work with old scripts and connection methods
* UPDATE: Pester tests have been added to make sure new features work as advertised
* UPDATE: Better errormessages with more details if you use -verbose
* BUGFIX: Even more bugs have been located and squashed

### Version 2.0.0-beta4

* NEW: Support for named configurations. You can save different credentials to disk (NB! Credentials are only encrypted using SecureString!)
* NEW: Connect-AtwsWebApi can now run without parameters, provided you have saved a Default connection profile
* UPDATE: New parameters for Connect-AtwsWebApi are AtwsModuleConfiguration, AtwsModuleConfigurationName and AtwsModuleConfigurationPath (with short aliases)
* NEW: New function New-AtwsModuleConfiguration, required parameters are Credential and SecureTrackingIdentifier, ProfileName is optional (see Get-Help New-AtwsModuleConfiguration)
* NEW: New function Get-AtwsModuleConfiguration, required parameter is Name (ProfileName)
* NEW: New function Save-AtwsModuleConfiguration, required parameters are none (will save current credentials and settings to disk as Default profile)
* NEW: New function Set-AtwsModuleConfiguration, required parameters are at least one (no point in running it if you don't want to change anything)
* NEW: New function Remove-AtwsModuleConfiguration, required parameter is Name (ProfileName)
* NEW: Errorlimit for bulk updates (default 10) has been exposed
* DEPRECATED: UserDefinedFields as hashtables has been axed. Broke Update().
* UPDATE: New Pester test have been added
* BUGFIX: Numerous bugs have been located and squashed

### Version 2.0.0-beta3

* BUGFIX: Fix for issue #94: Do not add timezone info to queries that uses a date, not a datetime value
* BUGFIX: Fix for issue #93: ArgumentCompleter code parsed parentvalue field the wrong way (it should be looked up by index value, no label)
* BUGFIX: Fixed issues where returned object was of wrong type, and of multiple arrays.
* BUGFIX: Fixed issues where Set-Atws* did not work as the method .Update reference got an array of wrong type. ArrayLists works, but generic lists of correct type does not.

### Version 2.0.0-beta2 - SPEED, SPEED, SPEED; Hashtables all the way down

* NEW: Added function Build-AtwsModule as wrapper for complete refresh of module from API. Can be used when your tenant has received an API upgrade before I have access to the same API version to build an upgrade
* NEW: Added custom mime mapping function Get-AtwsMindMapping. No access to system.web.mimemapping from powershell 7
* UPDATE: Substantial speed improvements in almost all use cases
* UPDATE: Added support for picklist parent fields in `[ArgumentCompleter()]`. Allows for selecting ticket SubIssueType based on value specified by IssueType
* UPDATE: New cache model based nested hashtables. Allows direct lookup of values without need for where-object filtering
* UPDATE: Replaced extensive use of array resizing (slow) with ArrayList and generic lists (fast)
* UPDATE: UserDefinedFields: Converts [Autotask.UserDefinedField[]] to [Hashtable] on Get. Allows direct access to named userdefined fields in your code without cumbersome looping or where clauses
* DEPRECATED: -GetExternalEntityByThisEntityId. It is easier to do `$accounts = Get-AtwsAccount -AccountName AccountName; Get-AtwsContract -AccountId $accounts.id`. You usually need both entities anyway.

### Version 2.0.0-beta1

* NEW: New function Get-AtwsPicklistValue -Entity $entityName -FieldName $fieldName for easy access to picklist values and labels
* UPDATE: Replaced `[ValidateSet()]` with `[ArgumentCompleter()]` for picklist! No longer any need for a personal cache on disk! Just install the module, connect and go!
* DEPRECATED: There is no longer any need to cache files to disk to support intellisense for picklists. Removed code for personal disk cache.
* REQUIREMENT: Moved minimum PowerShell requirement up from 4 to 5.

### Version 1.6.9

* BUGFIX: Updated classes file (Reference.cs). Added missing class ProductNote.

### Version 1.6.8

* UPDATE: New API version. Rebuild to include new and changed entities

### Version 1.6.7

* BUGFIX: Issue #83: Still checking for well known folder My Documents on Windows, even when using -NoDiskCache
* BUGFIX: Issue #61: When passing multiple values for a datetime parameter it was expanded even when it shouldn't be

### Version 1.6.6

* BUGFIX: Issue #79: Contact UDF's Missing. It was missing on all relevant entities, manual fix of Reference.cs
* UPDATE: Automatic build related: Automatic patch for missing properties on EntityInfo
* UPDATE: Minor improvements to Write-AtwsProgress
* UPDATE: Catching and displaying errors from indirect module load

### Version 1.6.5 (GA)

* UPDATE: Support for API version 1.6.5 included
* BUGFIX: Issue #66 and #74: Updating disk cache on every import finally solved

### Version 1.6.5-beta4

* UPDATE: Powershell 7 support

### Version 1.6.5-beta3

* FEATURE: Get-AtwsInvoiceInfo - added support for export to Excel (requires module ImportExcel)
* UPDATE: Uninstall-AtwsOldModuleVersion also cleans out personal cache for the same version
* BUGFIX: Multiplatform fix for Timezone handling

### Version 1.6.5-beta2

* UPDATE: Improved the progressbar
* BUGFIX: Found missing fields in autogenerated .cs code. Added manually.
* BUGFIX: Regression - restored support for -Refreshcache

### Version 1.6.5-beta1 - Multiplatform release

* FEATURE: PowerShell Core support. Now you can use this module from macOS and Linux!
* FEATURE: Rudimentary Write-Progress support under VSCode. Very simple and will be killed when Write-Progress support is released
* UPDATE: Replaced New-WebServiceReference with a auto-generated Reference.cs generated with dotnet-svcutil
* UPDATE: Replaced multiple global and script variables with a single configuration object connected to the SOAP client object
* UPDATE: Several minor changes to make scripts run on all platforms
* UPDATE: Many more changes to make scripts run on all platforms...
* UPDATE: Included help sections in several functions where this was still missing
* UPDATE: Switched to separate cache directories pr module version. Makes it more convenient to switch between module versions
* UPDATE: Changing a few code sections back to v4 compatible code, the difference was mostly cosmetic anyway
* UPDATE: Modified version numbering scheme to enable support for prerelease versions
* DEPRECATED: Removed -NoPickListLabels parameter from individual entity functions

### Version 1.6.4.2 - API update and bugfix release

* UPDATE: Included functions are updated to support API version 1.6.4
* UPDATE: Implemented pester testing to improve QA
* UPDATE: Copyright text updated with new company name after merger
* BUGFIX: Fixed parsing bugs in manual -Filter
* BUGFIX: Issue #59: Unable to set Issue/SubIssue when Subissue is on index 0 - **Fixed**
* BUGFIX: Issue #66: Still getting 'updating disk cache' on every module import - **Fixed**

This version has been delayed a lot by the introduction of pester testing, but I sincerely hope the added QA was worth the wait.

### Version 1.6.2.17 - Bugfix release

* BUGFIX: Issue #43: New-AtwsAttachment adds timezone difference twice - **Fixed**
* BUGFIX: Issue #44: GetEntityByReferenceId documentation - **Fixed**

### Version 1.6.2.15 - Re-release

* BUGFIX: Issue #42: no valid module was found in any module directory - **Fixed** - A git error in my automated build script caused a merge error in the code tree used to build the published module.

### Version 1.6.2.14 - Attachments supported

* UPDATE: Issue #35: How to access API methods directly with 1.6.2.x - **Fixed** with new advanced function `Get-AtwsConnectionObject`
* UPDATE: Issue #37: Feature request: Attachments upload - **Fixed** with new, static functions `Get-AtwsAttachment`, `New-AtwsAttachment` and `Remove-AtwsAttachment`
* UPDATE: Issue #41: Beta-module overwrites personal disk cache for release module - **Fixed** Now you can install and use the beta module without destroying your personal script cache

### Version 1.6.2.13 - Bugfix release

* BUGFIX: Issue #36: Date queries with multiple date fields return 0 objects - **Fixed**
* BUGFIX: Issue #33: Updating Diskcache auto running at every import - **Fixed**
* UPDATE: Issue #32: Suppress DATE and TIME warning - **Fixed**. The code should work with any datetime formats your powershell instance are compatible with.
* UPDATE: Better handling of global variables used by Connect-AtwsApi (Thanks @JsonWud!)

### Version 1.6.2.12 - Bugfix release

* BUGFIX: Issue #29: Set-AtwsContact :: Cannot convert Parameter -id from int64[] to int64. Set functions no longer try to set the ID field when using the -ID parameter.
* BUGFIX: Issue #27: Receiving Confirm prompts with `$global:ConfirmPreference="None"`. Moved ConfirmPreferene to wrapper functions only, enabling support for -Whatif and -Confirm parameters.
* UPDATE: All Get & Set functions now support `$Null` values for parameters. You can null out fields directly: `Set-AtwsTicket -ContactId $Null`

### Version 1.6.2.11 - Bugfix release

* BUGFIX: `Connect-AtwsWebAPI -UsePicklistLabels` should NOT be Mandatory...

### Version 1.6.2.10 - Bugfix and an update

* BUGFIX: The Id field has type Long (64 bit integer), not Int (32 bit integer). Get- functions already knew this. Now Set- and Remove- functions also know. New- doesn't care as Id is a read-only parameter.
* UPDATE: Added wrapper function for .GetThresholdAndUsageInfo() method. Now you can keep an eye on your API threshold usage from within your scripts with Get-AtwsThresholdAndUsageInfo. The function needs no parameters.
* UPDATE: Use Picklist labels with objects. The default is still the numerical values of picklists, but you can set an object picklist to its text label and have the module convert it automatically for you: `$Ticket.Status = 'Complete'; $Ticket | Set-AtwsTicket`
* UPDATE: If you prefer to have all your picklists converted to their text labels when you work with the API you can now use `Connect-AtwsWebAPI -UsePicklistLabels`

### Version 1.6.2.8 - Date improvements

* UPDATE: All datetime fields should be handled more efficiently now. It was a bit of a mess, because the API supposedly only works in CEST. But the .Create() method takes values in local time and converts everything correctly through the API. The .Query() method will likewise accept values in local time for queries, as long as you include timezone info in the formatting of datetime values. But always, *always*, any objects *returned* by the API will have all its datetime fields in CEST.
* UPDATE: Improved and simplifyed the code that return accurate objects directly from the API when you do New- or Set-. Moved a bit of complexity away from the entity wrappers (Get-, Set-, New- and Remove-Atws*Entity*) into the core Get-, Set-, New- and Remove-AtwsData functions.
* UPDATE: Search for any item from a given date with a single parameter. When you pass a date (2019-05-22 00:00:00) as a value, the search filter get automatically expanded to -ge 2019-05-22 00:00:00 -and -le 2019-05-23 00:00:00. In manual filters (-Filter {CreateDate -eq 2019-05-22 00:00:00}) are still used exactly as typed.
* BUGFIX: Personal disk cache is now version checked to make sure you always have correct code when loading from cache.
* BUGFIX: Force object type array for any labels when auto-generating parameters for functions.
* BUGFIX: Force arrays when parsing labels for ValidateSet() for functions. Entities with a single string field AND UserDefinedFields could not use -Like or -NotLike modifiers.

### Version 1.6.2.4 - Run without a personal disk cache (Azure Automation)

* FEATURE: Connect with Connect-AtwsWebApi -Credentials $Credentials -ApiTrackingIdentifier $ApiKey -NoDiskCache to run without either creating or reading from the personal disk cache. This is geared towards making the module compatible with Azure Automation. When you run without a disk cache you do not get Intellisense autocomplete, nor parameter validation for picklists. Picklist labels are still converted to their index values at run-time so any script you have already written should run unmodified.
* CHANGE: The module manifest now breaks best practice and uses a wildcard to specify functions to export. This module is not compatible with Powershell autoload, as an active connection to the Autotask Web API is required to supply the type definitions that are required for parameter validation.

### Version 1.6.2.3 - Bugfix release

* BUGFIX: The API documentation explicitly states that you can only use the objects returned by the .create() function to get the new objects ID. You cannot trust the returned objects to reflect the actual objects in the Autotask database. To work around this any 'New-' function will get all resulting objects by Id to make sure the returned objects are up to date. But not all objects support queries. Now 'New-' functions will only try to 'Get-' if the entity supports .query()

### Version 1.6.2.2 - Bugfix release

* BUGFIX: Set- and New- functions did not update DATE values correctly when using parameters

### Version 1.6.2.1 - New API version

* UPDATE: Static functions have been updated with any changes for API version 1.6.2
* BUGFIX: Fixed Write-Verbose/Write-Debug typo in New-AtwsData. Thanks @cody-chapman!
* UPDATE: If Set-AtwsData is passed multiple entities to update and you get an error, Set-AtwsData will try to tell you wich entity caused a problem

### Version 1.6.1.8 - Bugfix release

* BUGFIX: Did not detect missing dynamic functions (functions related to entities with picklists) during initial module import. Work-around was to connect using -RefreshCache or speficy a wildcard to Import-Module -ArgumentList (see above). This should be fixed now.

### Version 1.6.1.6 - Bugfix release

* BUGFIX: Compare-PSObject rewritten, too strict comparison when trying to use computehash. Using nested Compare-Object now, seems to work well enough.
* BUGFIX: Inverted test-logic for comparing downloaded fieldinfo to cached info.
* BUGFIX: Get-AtwsData: When testing for the existance of a variable, any variable with value 0 (zero) would be presumed to not exist. Fixed.
* Improved module loading to verify that downloaded cache is OK. Needed to fix error caused by earlier bug, but a useful test to do at that time.
* Get-AtwsFieldInfo warns about entity changes only if called in use, no warning during module load.

### Version 1.6.1.5 - New Cache Model

* IMPORTANT: Module structure and load method has changed. Pass Credentials to Import-Module using -Variable: Import-Module Autotask -Variable $Credentials, $ApiKey (Connect-AutotaskWebAPI is still there as a wrapper for backwards compatibility).
* FEATURE: New cache model. The module caches entity info to disk, not functions.
* FEATURE: SPEED! Module load time has improved a LOT! Not all entities change all the time. Entities that does not have any picklist parameters are pre-built and included in the module to speed up module load time.
* NOTE! On first load a complete cache of any entity containing picklists have to be downloaded from your tenant and saved to disk.
* FEATURE: You can use -IsNull and wildcards with UserDefinedFields (Finally!)
* FEATURE: Is is now a single module. You pass your credentials directly to Import-Module to load everything in one go. Old behavior with Connect-AutotaskWebAPI is supported for backwards compatibility using aliases.
* FEATURE: The module now uses built-in prefix support in Import-Module. Import the module multiple times using different credentials and prefixes for complex, cross-tenant work (requires using -Force with Import-Module).
* FEATURE: Get entities that are referring TO any entity. Get AccountLocation by querying for the right Account(s).
* FEATURE: PickList labels are added to any entity by default.
* FEATURE: Reload the module with a different prefix and different credentials to code against two different tenants simultanously.
* Changed version number scheme to follow API version number.
* Minor bugfixes.

### Version 0.2.2.5

* BUGFIX: Parameter ID was typed as Integer when the correct type is Int64. Fixed. Thank you, Harry P.!

### Version 0.2.2.4

* Support for API version 1.6. Parameter ApiTrackingID added to Connect-AutotaskWebAPI.
* New function Get-AtwsInvoiceInfo. Downloads detailed invoice information based on Autotask InvoiceId.

Note: Connecting to API version 1.6 requires a personal API tracking ID code. You can create one on the security tab on the automation user resource that you use to connect to the API. **Warning**: Be aware that from the moment you create an API tracking ID on an automation user, the tracking code is *required*, regardless with API version you try to connect to.

### Version 0.2.2.3

* BUGFIX: Timezone setup in GET functions didn't persist an important value. Fixed.

### Version 0.2.2.2

* IMPORTANT: TLS 1.2 is now the default for all API calls
* Datetime parameter in GET functions are explicitly cast to Sortable Datetime format including UTC offset to ensure local time is interpreted correctly by the API.
* Datetime properties on returned objects are changed to local time for easier coding. No need to handle timezone offsets manually anymore,
* When updating objects the API has a limit of 200 objects per API call. The module now handles this correctly.
* You can now specify object to modify by passing their -Id to SET functions instead of -InputObject
* Expand UserDefinedFields by default in SET functions when using -PassThru

### Version 0.2.2.1

* Fixed WebServiceProxy unauthenticated first call issue. Any API call now touches the API endpoint only once (previously the API was touched once unauthenticated and when that failed .Net automatically tried again with authentication and the call succeeded)
* Added caching of Fieldinfo pr entity. Significantly reduces the number of API calls in loops
* Added UDF expansion by default. Any UDF is added to an entity with a fieldname prefixed by # (hashtag). Udf names are freeform, and at least in our organization has a lot of spaces and punctuation. This way you will not forget to escape your UDF field names in your code. Speed gain: You can filter any collection of entities on UDF using standard Where-Object filters.

### Version 0.2.2.0

* Support TLS 1.2 in New-WebServiceProxy

### Version 0.2.1.9

* New parameter -AddPicklistLabel. Will add a text label to all fieldnames on an object that is a picklist field. Supports Where-Object filtering on textlabels for object collections.
* Parameter -passthru is supported for Set- and New- functions. Will pass any objects from the Autotask API to the PowerShell pipeline after modifying og creating the objects.

## Previous versions

We didn't pay enough attention to changes between releases before this.

[1]: https://www.autotask.com
[2]: https://ww4.autotask.net/help/Content/LinkedDOCUMENTS/WSAPI/T_WebServicesAPIv1_5.pdf
[3]: https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md
[4]: https://github.com/officecenter/Autotask/blob/master/Docs/How%20to%20Query.md
[5]: https://github.com/officecenter/Autotask/blob/master/Docs/How%20to%20create%20new%20entities.md
[6]: https://github.com/officecenter/Autotask/blob/master/Docs/How%20to%20make%20changes%20to%20entities.md
[7]: https://github.com/officecenter/Autotask/blob/master/Docs/How%20to%20delete%20entities.md
[8]: https://github.com/officecenter/Autotask/blob/master/Docs/How%20to%20connect.md
