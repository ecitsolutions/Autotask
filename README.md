# Autotask

# Summary

This module consists of 2 parts: A normal script module and a nested, dynamic module that is created when you authenticate to the Autotask Web Services API. The base module queries the API for detailed information about all available Autotask entities and creates functions that let you write PowerShell scripts in PowerShell ISE or Visual Studio Code with full IntelliSense support. Dynamic functions are cached to disk and updated whenever the base module or the API version changes.

## An Autotask Web Services Powershell module

This is our first public release of an internal module we have developed. We use [Autotask][1], a SaaS software suite for ITSPs and MSPs. Autotask has a well documented SOAP API that we use quite extensively for automation. The [API Documentation is available online][2].

While working with the API we noted that a detailed definition of all entities and fields of entities is available programatically through the API. In this module we use this information to generate a dynamic PowerShell module with **intellisense** support in both ISE and Visual Studio Code. We also generate inline, comment based help to make working with the API in PowerShell as easy as possible.

All entities that can be queried from the API has a *Get* function, all entities that can be updated has a *Set* function, all entities that can be created has a *New* function and all entities that can be deleted has a *Remove* function. If you cannot find a remove function for an entity, for instance *Ticket*, it is because the API does not permit deleting Tickets through the API.

The module is generated dynamically, directly from the API information. All functions are cached to disk to speed up later use. All functions will be recreated if we update this module or Autotask releases a new version of the API. Should Autotask update the API to permit deleting of Tickets through the API in the future, your dynamic module will be recreated and a *Remove-AtwsTicket* will be made availble to you.

Use Get-Help *functionname* a lot. You will find information such as required parameters, any entities that the current entity have connections to, other entities that have connections to your current entity and a lot more. Possible values for *picklists* are included both in the help text and in **intellisense** autocomplete.

## Disclaimer and Warning

**Be careful!** This module exposes all the Autotask Web Services API entities and methods as PowerShell functions. This makes it very easy to make a lot of changes very quickly. **But there is no undo!** If you use this module to destroy or delete anything in your Autotask tenant you did not intend to - you are entirely on your own! This module is provided "as is", without warranty of any kind, express or implied. In **no event** shall the authors or copyright holders be liable for any claim, damages or other liability ([see the license][3]). If this is not acceptable to you - do not use it!

## Query Syntax

Every *Get* function supports two different ways of composing a query to the Autotask API: *By parameters* and using a *Filter*. Any entitytype supported by the Autotask SOAP API, such as Accounts, Tickets, Contacts or Contracts, gets their own *Get* function:

```powershell
Get-AtwsAccount -Name 'Company name 1', 'Company Name 2'
Get-AtwsTicket -TicketNumber 'T20180116.0140'
Get-AtwsContact -FirstName Hugo -LastName Klemmestad
Get-AtwsContract -ContractType 'Recurring Service'
```

### Query by parameters

For *Get* functions all parameters support multiple values. Multiple values for the same parameter is treated as a logical OR query. Any entity matching either value is returned. In the code sample the *Get-AtwsAccount* function will return any company named either 'Company name 1' or 'Company Name 2'.

By default any parameter will only return exact matches, altough any strings are always matched case insensitive by the API. If you look at *Get-AtwsTicket* in the code sample, only a ticket matching the exact ticket number will be returned. Please note: if your query does not match anything, you will not get an error. You only get an empty result.

Any *Get* function also support multiple parameters. When you use more than one parameter, all parameters are combined with a logical AND. When I use *Get-AtwsContact* with both -Firstname and -Lastname, a contact must match both parameters to be returned.

When a property is a *picklist*, such as *ContractType* is for the **Contract** entity, a *Get* function works with the picklist *labels*, not the picklist index. When your dynamic Autotask module is generated, any picklist values are downloaded and included in the function definitions as *ValidateSet*. We consider this a useful behavior, as labels (in this case 'Recurring Service', 'Time & Materials', 'Block Hours' etc) are much easier to remember than their numeric values.

### Query by reference

Most Autotask entities reference other entities. Consider a *contract*. A contract is connected to an account by *AccountID*. If you want to know the name of the account you would have to get the contract first and the account second. Enter *-GetEntityByReferenceId*:
```powershell
$Contract = Get-AtwsContract -Name 'A Contract Name' -ContractType 'Recurring Service'
$Account = Get-AtwsAccount -Id $Contract.AccountId
# Or you can do
$Account = Get-AtwsContract -Name 'A Contract Name' -ContractType 'Recurring Service' -GetEntityByReferenceId AccountId
```
We added this feature out of our own frustration. Working with entity objects that consist mostly of meaningless, uniqe ID values is difficult on the command line. Being able to quickly get at the connected objects can save a bit of time.

### Modifying Query by parameters with operators

```powershell
Get-AtwsAccount -AccountName 'Company name 1' -NotEquals AccountName 
Get-AtwsAccount -AccountName 'Company name 1', 'Company name 2' -NotEquals AccountName 
Get-AtwsAccount -AccountName *Company* -Like AccountName 
Get-AtwsAccount -AccountName *Company* -NotLike AccountName 
Get-AtwsAccount -AccountName Company -BeginsWith AccountName 
```

Sometimes you do not want exact matches. Any *Get* function has several operator parameters you can use to modify the matching behavior of any parameter. The operator parameters takes the name of any parameter you wish to modify the behavior of. In the first example *Get-AtwsAccount* will return any account wich accountname is NOT EQUAL to 'Company name 1'.

When you pass more than one value to a parameter and then use -NotEquals, the query will exclude all values from the result. There are many different operators that are supported by the API. In the *Get* functions we have included support for NotEquals, GreaterThan, GreaterThanOrEqual, LessThan, LessThanOrEquals, Like, NotLike, BeginsWith, EndsWith and Contains.

## -Filter supports more advanced queries

Query by parameter is useful and quite readable. But if you need to write more advanced queries parameters cannot help you. Consider this query:

```powershell
$DueFrom = Get-Date
$DueTo = $DueFrom.AddDays(3)
$Tickets = Get-AtwsTicket -Filter {DueDateTime -gt $DueFrom -and DueDateTime -lt $DueTo}
$OtherTickets = Get-AtwsTicket -Filter {Status -eq New -or (DueDateTime -gt $DueFrom -and DueDateTime -lt $DueTo)}
```
We have tried to make the *Filter* syntax as familiar as possible for PowerShell users. As every query needs to be translated to QueryXML and posted to the Autotask API we have had to make some adaptions, but every operator supported by the API at time of writing is supported. With Filter you should be able to make any query you can't specify by using parameters.

See the [Autotask Web API documentation][2], section about *QueryXML* for å complete list of possible operators in a query.



[1]: https://www.autotask.com
[2]: https://ww4.autotask.net/help/Content/LinkedDOCUMENTS/WSAPI/T_WebServicesAPIv1_5.pdf
[3]: https://github.com/officecenter/Autotask/blob/master/LICENSE.md
