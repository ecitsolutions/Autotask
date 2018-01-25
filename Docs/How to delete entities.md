# Deleting entities

Not all entities in Autotask supports being deleted through the API. We are not sure why, but there is nothing we can do about it. For all entities that do support deletion, our module creates a *Remove-* function. The *Remove* functions all work the same. You pass them an object - or the Id of an object - and the function deletes the object from Autotask. Again, without any support for undo. Remember, if you delete an object you shouldn't have, but still have the object in a variable in PowerShell, then you may try to re-create it. But the object you create will be a new object with a new Id. so any existing objects in Autotask that refers to the old object you deleted will not point to the new one.

## These are the *Remove* functions that are supported by the API

```powershell
Remove-AtwsAccountTeam
Remove-AtwsAccountToDo
Remove-AtwsActionType
Remove-AtwsAppointment
Remove-AtwsChangeRequestLink
Remove-AtwsContractCost
Remove-AtwsContractExclusionAllocationCode
Remove-AtwsContractExclusionRole
Remove-AtwsInstalledProductType
Remove-AtwsInstalledProductTypeUdfAssociation
Remove-AtwsProjectCost
Remove-AtwsQuoteItem
Remove-AtwsServiceBundle
Remove-AtwsServiceBundleService
Remove-AtwsServiceCall
Remove-AtwsServiceCallTask
Remove-AtwsServiceCallTaskResource
Remove-AtwsServiceCallTicket
Remove-AtwsServiceCallTicketResource
Remove-AtwsSubscription
Remove-AtwsTaskPredecessor
Remove-AtwsTaskSecondaryResource
Remove-AtwsTicketAdditionalContact
Remove-AtwsTicketChangeRequestApproval
Remove-AtwsTicketCost
Remove-AtwsTicketSecondaryResource
```