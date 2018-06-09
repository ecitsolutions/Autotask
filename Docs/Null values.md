# Null values

Null values and PowerShell parameters can be a pain. PowerShell functions do not accept a null value to any parameter, built-in or custom. The issue: Get all tickets that have NOT been assigned to anyone yet. It would be tempting to try:

```powershell
Get-AtwsTicket -AssignedResourceId $null
```

This will not work. Even if you could pass this as a parameter, any parameter is passed to the script code as variables. My code would not be able to tell the difference between an explicitly passed null value and a parameter that has not been used. Any unused parameter also has the value null. The syntax we have chosen is the same for all operators that the Autotask API supports: _-Operator Fieldname_. Example:

```powershell
Get-AtwsTicket -IsNull AssignedResourceId
Get-AtwsTicket -IsNotNull AssignedResourceId
```

We have added all parameters that support the operators IsNull and IsNotNull to the ValidateSet attribute.

## A more advanced example

[AlexHeylin](https://github.com/AlexHeylin) made us aware of how difficult it was to figure out how to handle null values in queries and shared this example query with us. It gets unassigned tickets in his "1st line support" queue that have not been updated in two hours (set on line 2):

```powershell
$AtDbUtcOffset = -4.0
$LastUpdateDateTimeEST = (get-date).AddHours(+$AtDbUTCOffset).AddHours(-2)
$Tickets1stLine = Get-AtwsTicket -Filter { AssignedResourceID -isnull -and  QueueID -eq 29682833 -and (Status -eq 1 -or Status -eq 8 ) -and LastActivityDate -lt $LastUpdateDateTimeEST }
$Tickets1stLine | ft AssignedResourceID , QueueID , TicketNumber, Title, LastActivityDate
```

This works and it works well. Writing manual filters is very powerful and gives you granular control over grouping of complex and/or sequences. But in this case Alex just wanted to get tickets with no assigned resource. With _-IsNull_ you can write this query like this:

```powershell
$AtDbUtcOffset = -4.0
$LastUpdateDateTimeEST = (get-date).AddHours(+$AtDbUTCOffset).AddHours(-2)
# Replace <queuename>, status 1> and <status 8> whith the text labels for the same statuses in your own Autotask tenant
$Tickets1stLine = Get-AtwsTicket -IsNull AssignedResourceID -QueueID <queuename> -Status <status 1>,<status 8> -LastActivityDate $LastUpdateDateTimeEST -LessThan LastActivityDate
$Tickets1stLine | ft AssignedResourceID , QueueID , TicketNumber, Title, LastActivityDate
```

### -LastActivityDate $LastUpdateDateTimeEST -LessThan LastActivityDate

```powershell
# Equivalent -Filter expression
Get-AtwsTicket -Filter {LastActivityDate -lt $LastUpdateDateTimeEST}
```

While **-IsNull AssignedResourceID** is quite readable, even if a bit backwards, the use of **-LessThan** is worth an explanation. By default any _Get-Atws<Entity>_ function will search for any entities where the fieldname equals the value. But in this case Alex wants tickets older than 2 hours. To change the operator for a field we have chosen a syntax where you pass the fieldname to a parameter with the same name as the operator you want. In this case **-LessThan**.

### -Status <status 1>,<status 8>

**Get** functions will accept both single values and arrays for any parameter. If you pass an array, any value will be combined with a logical OR. If you want all values EXCEPT the ones you pass, you do:

```powershell
Get-AtwsTicket -Status <status 1>,<status 8> -NotEquals Status
# Equivalent -Filter expression
Get-AtwsTicket -Filter {Status -ne 1 -and Status -ne 8}
```

That inverts the operator and combines the values with a logical a logical AND.