# Best practices

We have tried to make this module behave the PowerShell way and adhere to common best practices for PowerShell. However, there are a few areas where we recommend you break standard PowerShell practices. Everything you do with this module centers around posting and getting data to and from a web services endpoint. That is expensive in terms of time. You will want to limit the number of direct calls you make to the API.

## Bulk GET operations

Sometimes you will want to get a lot of objects in one go. In this example we are going to get all accounts with active block hour contracts. Since we are working with an web services API, not a SQL database, we have to go through several commands. Consider this code:

```powershell
$contracts = Get-AtwsContract -ContractType Block Hours -Status Active

# Alternative 1 - oneliner - takes about 44 seconds with 59 contracts
$accounts = $contracts | foreach-object {Get-AtwsAccount -id $_.AccountId}

# Alternative 2 - multiline and readable - takes about 32 seconds with 59 contracts
$accounts = @()
foreach ($contract in $contracts) {
    $accounts += Get-AtwsAccount -id $contract.AccountId
}

# Alternative 3 - the recommended one - takes about 2 seconds with 59 contracts
$accounts = Get-AtwsAccount -id $contracts.AccountId
```

In the 2 first examples we effectively run Get-AtwsAccount once per contract. It works, but we touch the API 59 times to get our data. This is very expensive in terms of time and resources. The better way is to use alternative 3. Pass all 59 contract ids in a single query. We touch the API only once and Autotask servers get to do their thing. We get a single response containing all the accounts.

### Important

Another thing to consider is that in the first two examples we always get 59 account objects returned _regardless_ of whether two or more contracts belong to the same account. In our database the last query returns 57 accounts, removing two duplicates the other methods include.

## Bulk SET operations

Sometimes you may need to make changes to a lot of objects at once. This is precisely the kind of task this module is supposed to help you to do. Lets pretend you want to use a special ContractCategory on the block hour contracts from the previous example.

```powershell
$contracts = Get-AtwsContract -ContractType Block Hours -Status Active

# Alternative 1 - use the pipeline - takes about 1 minute with 59 contracts
$contracts | Set-AtwsContract -ContractCategory 'a valid category in your tenant'

# Alternative 2 - use -InputObject - takes about 6 seconds with 59 contracts
Set-AtwsContract -InputObject $contracts -ContractCategory 'a valid category in your tenant'
```

Again the most expensive way of doing it is to call the SET function once per change. When you are doing _updates_ this is even more expensive than with queries. The most efficient way is to pass the entire object set to the SET function as **-InputObject**. That lets the function loop through the objects offline and make any changes before all modified objects are passed to the API in a single operation.

### What about invidual changes to each object

In the previous example we wanted the same value for a property (ContractCategory) on all the objects. In quite a lot of cases you may want to make invidual changes on each object. What if we want to make sure all contract names are in upper case?

```powershell
$contracts = Get-AtwsContract -ContractType Block Hours -Status Active

# Alternative 1 - use the pipeline - takes about 1 minute with 59 contracts
$contracts | foreach-object { Set-AtwsContract -InputObject $_ -ContractName $_.ContractName.ToUpper() }

# Alternative 2 - loop and change offline - takes about 5 seconds with 59 contracts
$contracts | foreach-object { $_.ContractName = $_.ContractName.ToUpper()}
Set-AtwsContract -InputObject $contracts 
```

Experience suggest that you make any changes you want to your offline copy of your objects and then pass the whole object collection to a SET function. The API can only accept 200 objects at a time. The module code automatically splits your object sett into sets of 200 and reduces the number of API calls to a minimum.