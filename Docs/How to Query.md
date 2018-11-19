# Query Syntax

Every *Get* function supports two different ways of composing a query to the Autotask API: *By parameters* and using a *Filter*. Any entitytype supported by the Autotask SOAP API, such as Accounts, Tickets, Contacts or Contracts, gets their own *Get* function:

```powershell
Get-AtwsAccount -Name 'Company name 1', 'Company Name 2'
Get-AtwsTicket -TicketNumber 'T20180116.0140'
Get-AtwsContact -FirstName Hugo -LastName Klemmestad
Get-AtwsContract -ContractType 'Recurring Service'
Get-AtwsInstalledProduct -UserDefinedField @{name='udf_name'; value='udf_value'}

# Equivalent -Filter expressions
Get-AtwsAccount -Filter {AccountName -eq 'Company name 1' -or AccountName -eq 'Company Name 2'}
Get-AtwsTicket -Filter {TicketNumber -eq 'T20180116.0140'}
Get-AtwsContact -Filter {FirstName -eq Hugo -and LastName -eq Klemmestad}
Get-AtwsContract -Filter {ContractType -eq 7}
Get-AtwsInstalledProduct -Filter {-udf 'udf_name' -eq 'udf_value'}
```
**Note:** See separate document [User Defined Fields](./User%20Defined%20Fields.md) for using UDFs in queries.

## Query by parameters

For *Get* functions all parameters support multiple values. Multiple values for the same parameter is treated as a logical OR query. Any entity matching either value is returned. In the code sample the *Get-AtwsAccount* function will return any company named either 'Company name 1' or 'Company Name 2'.

By default any parameter will only return exact matches, altough any strings are always matched case insensitive by the API. If you look at *Get-AtwsTicket* in the code sample, only a ticket matching the exact ticket number will be returned. Please note: if your query does not match anything, you will not get an error. You will get an empty result.

Any *Get* function also support multiple parameters. When you use more than one parameter, all parameters are combined with a logical AND. When I use *Get-AtwsContact* with both -Firstname and -Lastname, a contact must match both parameters to be returned.

When a property is a *picklist*, such as *ContractType* is for the **Contract** entity, a *Get* function works with the picklist *labels*, not the picklist index. When your dynamic Autotask module is generated, any picklist values are downloaded and included in the function definitions as *ValidateSet*. We consider this a useful behavior, as labels (in this case 'Recurring Service', 'Time & Materials', 'Block Hours' etc) are much easier to remember than their numeric values.

## Query by reference

Most Autotask entities reference other entities. Consider a *contract*. A contract is connected to an account by *AccountID*. If you want to know the name of the account you would have to get the contract first and the account second. Enter *-GetEntityByReferenceId*:

```powershell
$Contract = Get-AtwsContract -Name 'A Contract Name' -ContractType 'Recurring Service'
$Account = Get-AtwsAccount -Id $Contract.AccountId
# Or you can do
$Account = Get-AtwsContract -Name 'A Contract Name' -ContractType 'Recurring Service' -GetEntityByReferenceId AccountId
```

We added this feature out of our own frustration. Working with entity objects that consist mostly of meaningless, uniqe ID values is difficult on the command line. Being able to quickly get at the connected objects can save a bit of time.

## Modifying Query by parameters with operators

```powershell
Get-AtwsAccount -AccountName 'Company name 1' -NotEquals AccountName
Get-AtwsAccount -AccountName 'Company name 1', 'Company name 2' -NotEquals AccountName
Get-AtwsAccount -AccountName *Company* -Like AccountName
Get-AtwsAccount -AccountName *Company* -NotLike AccountName
Get-AtwsAccount -AccountName Company -BeginsWith AccountName
```

**Note:** See separate document [Null values](./Null%20values.md) for using null values in queries.

Sometimes you do not want exact matches. Any *Get* function has several operator parameters you can use to modify the matching behavior of any parameter. The operator parameters takes the name of any parameter you wish to modify the behavior of. In the first example *Get-AtwsAccount* will return any account wich accountname is NOT EQUAL to 'Company name 1'.

When you pass more than one value to a parameter and then use -NotEquals, the query will exclude all values from the result. There are many different operators that are supported by the API. In the *Get* functions we have included support for NotEquals, GreaterThan, GreaterThanOrEqual, LessThan, LessThanOrEquals, Like, NotLike, BeginsWith, EndsWith and Contains.

## -Filter supports more advanced queries

Query by parameter is useful and quite readable. But if you need to write more advanced queries parameters cannot help you. Consider this query:

```powershell
$DueFrom = Get-Date
$DueTo = $DueFrom.AddDays(3)
$Tickets = Get-AtwsTicket -Filter {DueDateTime -gt $DueFrom -and DueDateTime -lt $DueTo}

# Please note that picklist values are not expanded in custom filters, see Status in this query
$OtherTickets = Get-AtwsTicket -Filter {Status -eq 1 -and (DueDateTime -gt $DueFrom -and DueDateTime -lt $DueTo)}
```

We have tried to make the *Filter* syntax as familiar as possible for PowerShell users. As every query needs to be translated to QueryXML and posted to the Autotask API we have had to make some adaptions, but every operator supported by the API at time of writing is supported. With Filter you should be able to make any query you can't specify by using parameters.

See the [Autotask Web API documentation][1], section about *QueryXML* for å complete list of possible operators in a query.

[1]: https://ww4.autotask.net/help/Content/LinkedDOCUMENTS/WSAPI/T_WebServicesAPIv1_5.pdf
