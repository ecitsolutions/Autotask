# New Entities

For every entity in the Autotask that support being created through the API there are created a *New-* function. All New functions support 2 methods for creating new objects: *By parameters* and *by object*. Choose whichever method that suits your coding style, or switch between them as needs dictate.

```powershell
$Account = Get-AtwsAccount -Name 'Hugo Klemmestad'
$Duedate = (Get-Date).AddDays(8)
$Title = 'Testing the API on a ticket'

# Method 1
$Ticket = New-AtwsTicket -AccountID $Account.id -DueDateTime $Duedate -Priority Medium -Status New -Title $Title -QueueID 'Queue Name'

# Method 2
$Ticket = New-Object Autotask.Ticket
$Ticket.AccountId = $Account.id
$Ticket.DueDateTime = $Duedate
$Ticket.Priority = 'Medium'
$Ticket.Status = 'New'
$Ticket.Title = $Title

$NewTicket = New-AtwsTicket -InputObject $Ticket

# Or

$NewTicket = $Ticket | New-AtwsTicket
```

## Method 1: Create by parameters

When you create a new object by specifying parameters you can create a single object at a time. All parameters support **IntelliSense** and performs parameter validation before creating an object immediately through the API. The new object is always returned as output.

## Method 2: Create by object

Any Autotask entity can be created as an object through *New-Object*. The namespace is *Autotask* and supports **IntelliSense**. Using objects you can prepare multiple objects offline and pass them all to the entity's *New* function to create a batch of objects in one go.
