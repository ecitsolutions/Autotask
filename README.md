# Autotask

# Summary

This module consists of 2 parts: A normal script module and a nested, dynamic module that is created when you authenticate to the Autotask Web Services API. The base module queries the API for detailed information about all available Autotask entities and creates functions that let you write PowerShell scripts in PowerShell ISE or Visual Studio Code with full IntelliSense support. Dynamic functions are cached to disk and updated whenever the base module or the API version changes.

## An Autotask Web Services Powershell module

This is our first public release of an internal module we have developed. We use [Autotask][1], a SaaS software suite for ITSPs and MSPs. Autotask has a well documented SOAP API that we use quite extensively for automation. The [API Documentation is available online][2].

While working with the API we noted that a detailed definition of all entities and fields of entities is available programatically through the API. In this module we use this information to generate a dynamic PowerShell module with **IntelliSense** support in both ISE and Visual Studio Code. We also generate inline, comment based help to make working with the API in PowerShell as easy as possible.

All entities that can be queried from the API has a *Get* function, all entities that can be updated has a *Set* function, all entities that can be created has a *New* function and all entities that can be deleted has a *Remove* function. If you cannot find a remove function for an entity, for instance *Ticket*, it is because the API does not permit deleting Tickets through the API.

The module is generated dynamically, directly from the API information. All functions are cached to disk to speed up later use. All functions will be recreated if we update this module or Autotask releases a new version of the API. Should Autotask update the API to permit deleting of Tickets through the API in the future, your dynamic module will be recreated and a *Remove-AtwsTicket* will be made availble to you.

Use Get-Help *functionname* a lot. You will find information such as required parameters, any entities that the current entity have connections to, other entities that have connections to your current entity and a lot more. Possible values for *picklists* are included both in the help text and in **IntelliSense** autocomplete.

## Documentation

[How to *Get* data from the API](Docs\How to Query.md)

## Disclaimer and Warning

**Be careful!** This module exposes all the Autotask Web Services API entities and methods as PowerShell functions. This makes it very easy to make a lot of changes very quickly. **But there is no undo!** If you use this module to destroy or delete anything in your Autotask tenant you did not intend to - you are entirely on your own! This module is provided "as is", without warranty of any kind, express or implied. In **no event** shall the authors or copyright holders be liable for any claim, damages or other liability ([see the license][3]). If this is not acceptable to you - do not use it!

[1]: https://www.autotask.com
[2]: https://ww4.autotask.net/help/Content/LinkedDOCUMENTS/WSAPI/T_WebServicesAPIv1_5.pdf
[3]: https://github.com/officecenter/Autotask/blob/master/LICENSE.md
