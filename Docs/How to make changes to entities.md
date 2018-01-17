# How to make changes to entities

For all entities in the Autotask that supports being changed through the Web Services API, our module creates *Set-* functions. All *Set* functions expects you to pass any objects you want modified through the pipeline or by using the *-InputObject* parameter. So to modify existing entities in Autotask you first have [*Get* them][1].

```powershell
$EndDate = Get-Date 31-12-2018
$NewEndDate = $EndDate.AddYears(1)

$Contracts = Get-AtwsContract -ContractType 'Recurring Service' -EndDate $EndDate

# Method 1
$Contracts | Set-AtwsContract -EndDate $NewEndDate

# Method 2
Set-AtwsContract -InputObject $Contracts -EndDate $NewEndDate

# Method 3 - A one-liner
Get-AtwsContract -ContractType 'Recurring Service' -EndDate $EndDate | Set-AtwsContract -EndDate $NewEndDate
```

The example demonstrates how you can use PowerShell to extend Recurring Service contracts by a year. As you can see, modifying objects is very easy. All the work is in making sure you get the right objects from Autotask in the first place. A *Set* function happily modifies any object you pass to it, as long as it is an object of the right type. *Set-AtwsContract* can only modify contracts. It you try to pass it an object of a different type it will throw an exception. So make sure you [write your queries right][1], because the Autotask Web API does **not** support undo...

[1]: https://github.com/officecenter/Autotask/blob/master/Docs/How%20to%20Query.md
