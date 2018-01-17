# Deleting entities

Not all entities in Autotask supports being deleted through the API. We are not sure why, but there is nothing we can do about it. For all entities that do support deletion, our module creates a *Remove-* function. The *Remove* functions all work the same. You pass them an object - or the Id of an object - and the function deletes the object from Autotask. Again, without any support for undo. Remember, if you delete an object you shouldn't have, but still have the object in a variable in PowerShell, then you may try to re-create it. But the object you create will be a new object with a new Id. so any existing objects in Autotask that refers to the old object you deleted will not point to the new one. 

## These are the *Remove* functions that are supported by the API

```powershell
Remove-AtwsAccountTeam.ps1
Remove-AtwsAccountToDo.ps1
Remove-AtwsActionType.ps1
Remove-AtwsAppointment.ps1
Remove-AtwsChangeRequestLink.ps1
Remove-AtwsContractCost.ps1
Remove-AtwsContractExclusionAllocationCode.ps1
Remove-AtwsContractExclusionRole.ps1
Remove-AtwsInstalledProductType.ps1
Remove-AtwsInstalledProductTypeUdfAssociation.ps1
Remove-AtwsProjectCost.ps1
Remove-AtwsQuoteItem.ps1
Remove-AtwsServiceBundle.ps1
Remove-AtwsServiceBundleService.ps1
Remove-AtwsServiceCall.ps1
Remove-AtwsServiceCallTask.ps1
Remove-AtwsServiceCallTaskResource.ps1
Remove-AtwsServiceCallTicket.ps1
Remove-AtwsServiceCallTicketResource.ps1
Remove-AtwsSubscription.ps1
Remove-AtwsTaskPredecessor.ps1
Remove-AtwsTaskSecondaryResource.ps1
Remove-AtwsTicketAdditionalContact.ps1
Remove-AtwsTicketChangeRequestApproval.ps1
Remove-AtwsTicketCost.ps1
Remove-AtwsTicketSecondaryResource.ps1
```