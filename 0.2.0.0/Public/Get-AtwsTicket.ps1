<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Get-AtwsTicket
{
  <#
      .SYNOPSIS
      This function get one or more Ticket through the Autotask Web Services API.
      .DESCRIPTION
      This function creates a query based on any parameters you give and returns any resulting 
objects from the Autotask Web Services Api. By default the function returns any objects with properties 
that are Equal (-eq) to the value of the parameter. To give you more flexibility you can modify the operator
by using -NotEquals [ParameterName[]], -LessThan [ParameterName[]] and so on. 
Use Get-help Get-AtwsTicket for all possible operators.
      .INPUTS
      Nothing. This function only takes parameters.
      .OUTPUTS
      [Autotask.Ticket[]]. This function outputs the Autotask.Ticket that was returned by the API.
      .EXAMPLE
      Get-AtwsTicket  -Parameter1 [Parameter1 value] -Parameter2 [Parameter2 Value] -GreaterThan Parameter2
Returns all objects where a property by name of "Parameter1" is equal to [Parameter1 value] and where a property
by name of "Parameter2" is greater than [Parameter2 Value].
      For parameters, use Get-Help Get-AtwsTicket
      .NOTES
      NAME: Get-AtwsTicket
  #>
	  [CmdLetBinding(DefaultParameterSetName='Filter')]
    Param
    (
                [Parameter(
          Mandatory = $true,
          ValueFromRemainingArguments = $true,
          ParameterSetName = 'Filter')]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Filter ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $AccountID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $AllocationCodeID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $AssignedResourceID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $AssignedResourceRoleID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $CompletedDate
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $ContactID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $ContractID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $CreateDate
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $CreatorResourceID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $Description
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $DueDateTime
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [double]
         $EstimatedHours
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $ExternalID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [long]
         $id
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $InstalledProductID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Brukeradministrasjon','Leveranse','Akutt feilretting','Brukerstøtte','Konfigurasjon','Service','Managed Services Alert','Feil i leveranse','Endring','Feilretting','Leveranse','Leveransefeil')]

        [String]
         $IssueType
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $LastActivityDate
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Høy','Medium','Lav','Kritisk','Utført')]

        [String]
         $Priority
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Client Portal','Post Sale','Monitoring Alert','Konsulentteam','Utførte tickets','Intern support','S&S - Service','Dokumenthåndtering','ERP produkter','Mekaniske kontormaskiner','Prosjektledere','Overvåkning','Recurring Tickets','Driftssenteret - Vulnerability','S&S - Support','På Vent','Serverdrift - Performance','Driftssenteret - Checkpoint','Driftsteam - Fordeling','Overvåkning - GFI - Antivirus','Driftssenteret - 2.prioritet','Driftssenteret - Venter på salg','Overvåkning - GFI - Backup','Overvåkning - Virtuelt','Driftssenteret - PC','Driftsteam - Nor-Reg','Utviklingsteam','Driftssenteret - VPN','Driftssenteret - VMWare','Driftssenteret - Service','Overvåkning - GFI','S&S - Support - Interne oppgaver','S&S - Workstation Monitoring','Konsulentteam - RiK','Saker til fordeling','Overvåkning - Fordeling','Konsulentteam - Fast oppmøte','Overvåkning - N-able','Overvåkning - N-able Workstations','Overvåkning - Patch','Overvåkning - Event sjekker','Overvåkning - Trend','Overvåkning - Workstations','S&S - Support - Office365','Overvåkning - IDS','OCH Interndrift ','Overvåkning - Continuum')]

        [String]
         $QueueID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Insourced','Client Portal','Other','Phone','Email','Web Portal','In Person/Onsite','Monitoring Alert','Kontrakt','Email2Ticket - Drift','Email2Ticket - Serverdrift','Email2Ticket - Autotask','Overvåkning')]

        [String]
         $Source
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('New','Complete','Waiting Customer','Under arbeid','Venter på utstyr','Akseptert','Eskalert','Venter på 3.part','Må godkjennes','Registrert','Epost mottatt','Venter internt','Til fordeling','Har avtalt tid','Kansellert','Notat mottatt','Gjenåpnet','Kundepleie','Forsøkt ringt','Kundesvar Fra Portal')]

        [String]
         $Status
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Server','Software','Workstation','Backup','PC, klargjøring eller montering','Antivirus','Printer, MFC','Internet','Intranet/LAN','Server, klargjøring eller montering','Brannmur, nettverk','Remote Desktop Services','Overvåking Server','Annet','Server','Apple iOS (iPhone/iPad)','Internet','VPN','Windows','Office','Utskrift/Printer','Rådgivning/Veiledning','Annet','Meldt av bruker','SQL Server','Brannmur/Nettverk','Remote Desktop Services','Antivirus','Backup','SaaS fra oss (Comendo)','Virtualisering','Printer/MFC','Trend Micro Threat Events','Trend Micro System Events','Trend Micro License Events','Trend Micro Other Events','PC leveranse','Prosjekt','Service','Serverleveranse','Annet','Driftssenteret','Garanti','Reparasjon','Vedlikehold','SQL Server','Virtualisering','SaaS fra oss (Comendo)','Annet','Annet','Rådgivning','Mac OS X','Android','Mac, klargjøring eller montering','PC, Windows','Mac OS X','Android enhet','iOS enhet (iPhone/iPad)','Small Business Server','Overvåkning','Overvåking PC','Programvare','Annet','3. partsleverandør','Antivirus','Backup','Brukeradministrasjon','Database','E-posttjenester','Mobil/Nettbrett/Telefoni','Nettverk/Brannmur','Operativsystem','Printer/MFC','Programvare','Servertjenester','Veiledning','Virtualisering','Overvåkning','Annet','3. partsleverandør','Antivirus','Backup','Brukeradministrasjon','Database','E-posttjenester','Mobil/Nettbrett/Telefoni','Nettverk/Brannmur','Operativsystem','Printer/MFC','Programvare','Servertjenester','Veiledning','Virtualisering','Overvåkning','Annet','Antivirus','Backup','Nettverk/Brannmur','Brukeradministrasjon','Database','E-posttjenester','Arbeidsstasjon','Server','Mobil/Nettbrett/Telefoni','Overvåkning','Printer/MFC','Programvare','Rådgivning','Virtualisering','Annet','Antivirus','Backup','Nettverk/Brannmur','Database','E-posttjenester','Mobil/Nettbrett','Printer/MFC','Programvare','Virtualisering','Overvåkning','Brukeradministrasjon','Arbeidsstasjon','Server','Maskinvare','Maskinvare','Fast oppmøte','Dokumentasjon','Pre-Sale','Møteromsutstyr','Møteromsutstyr','Møteromsutstyr')]

        [String]
         $SubIssueType
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $TicketNumber
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $Title
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $FirstResponseDateTime
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $ResolutionPlanDateTime
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $ResolvedDateTime
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $FirstResponseDueDateTime
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $ResolutionPlanDueDateTime
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $ResolvedDueDateTime
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Responstid 8 timer','Responstid 4 timer','Support SLA')]

        [String]
         $ServiceLevelAgreementID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [boolean]
         $ServiceLevelAgreementHasBeenMet
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $Resolution
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $PurchaseOrderNumber
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Service Request','Incident','Problem','Change Request','Alert')]

        [String]
         $TicketType
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $ProblemTicketId
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $OpportunityId
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $ChangeApprovalBoard
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('All approvers must approve','One approver must approve')]

        [String]
         $ChangeApprovalType
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Not Assigned','Assigned','Requested','Partially Approved','Approved','Rejected')]

        [String]
         $ChangeApprovalStatus
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $ChangeInfoField1
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $ChangeInfoField2
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $ChangeInfoField3
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $ChangeInfoField4
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $ChangeInfoField5
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $LastCustomerNotificationDateTime
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $LastCustomerVisibleActivityDateTime
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [long]
         $ContractServiceID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [long]
         $ContractServiceBundleID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('AntivirusMonitor','BackupMonitor','ComponentMonitor','CPUMonitor','DiskUsageMonitor','EventLogMonitor','FileFolderSizeMonitor','HardwareMonitor','MemoryMonitor','NetworkMonitor','NetworkOfflineMonitor','OnlineStatusMonitor','PatchMonitor','PrinterStatusMonitor','ProcessMonitor','SecurityCenterMonitor','SecurityManagementMonitor','ServiceMonitor','SnmpMonitor','SoftwareMonitor','TemperatureSensorMonitor','WindowsPerformanceMonitor','WmiMonitor')]

        [String]
         $MonitorTypeID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $MonitorID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $AEMAlertID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [double]
         $HoursToBeScheduled
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('RMM Alert','Standard','Support')]

        [String]
         $TicketCategory
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $FirstResponseInitiatingResourceID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $FirstResponseAssignedResourceID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $ProjectID
 ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('AccountID','AllocationCodeID','AssignedResourceID','AssignedResourceRoleID','CompletedDate','ContactID','ContractID','CreateDate','CreatorResourceID','Description','DueDateTime','EstimatedHours','ExternalID','id','InstalledProductID','LastActivityDate','TicketNumber','Title','FirstResponseDateTime','ResolutionPlanDateTime','ResolvedDateTime','FirstResponseDueDateTime','ResolutionPlanDueDateTime','ResolvedDueDateTime','ServiceLevelAgreementHasBeenMet','Resolution','PurchaseOrderNumber','ProblemTicketId','OpportunityId','ChangeInfoField1','ChangeInfoField2','ChangeInfoField3','ChangeInfoField4','ChangeInfoField5','LastCustomerNotificationDateTime','LastCustomerVisibleActivityDateTime','ContractServiceID','ContractServiceBundleID','MonitorID','AEMAlertID','HoursToBeScheduled','FirstResponseInitiatingResourceID','FirstResponseAssignedResourceID','ProjectID')]
        [String[]]
        $NotEquals ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('AccountID','AllocationCodeID','AssignedResourceID','AssignedResourceRoleID','CompletedDate','ContactID','ContractID','CreateDate','CreatorResourceID','Description','DueDateTime','EstimatedHours','ExternalID','id','InstalledProductID','LastActivityDate','TicketNumber','Title','FirstResponseDateTime','ResolutionPlanDateTime','ResolvedDateTime','FirstResponseDueDateTime','ResolutionPlanDueDateTime','ResolvedDueDateTime','ServiceLevelAgreementHasBeenMet','Resolution','PurchaseOrderNumber','ProblemTicketId','OpportunityId','ChangeInfoField1','ChangeInfoField2','ChangeInfoField3','ChangeInfoField4','ChangeInfoField5','LastCustomerNotificationDateTime','LastCustomerVisibleActivityDateTime','ContractServiceID','ContractServiceBundleID','MonitorID','AEMAlertID','HoursToBeScheduled','FirstResponseInitiatingResourceID','FirstResponseAssignedResourceID','ProjectID')]
        [String[]]
        $GreaterThan ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('AccountID','AllocationCodeID','AssignedResourceID','AssignedResourceRoleID','CompletedDate','ContactID','ContractID','CreateDate','CreatorResourceID','Description','DueDateTime','EstimatedHours','ExternalID','id','InstalledProductID','LastActivityDate','TicketNumber','Title','FirstResponseDateTime','ResolutionPlanDateTime','ResolvedDateTime','FirstResponseDueDateTime','ResolutionPlanDueDateTime','ResolvedDueDateTime','ServiceLevelAgreementHasBeenMet','Resolution','PurchaseOrderNumber','ProblemTicketId','OpportunityId','ChangeInfoField1','ChangeInfoField2','ChangeInfoField3','ChangeInfoField4','ChangeInfoField5','LastCustomerNotificationDateTime','LastCustomerVisibleActivityDateTime','ContractServiceID','ContractServiceBundleID','MonitorID','AEMAlertID','HoursToBeScheduled','FirstResponseInitiatingResourceID','FirstResponseAssignedResourceID','ProjectID')]
        [String[]]
        $GreaterThanOrEqual ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('AccountID','AllocationCodeID','AssignedResourceID','AssignedResourceRoleID','CompletedDate','ContactID','ContractID','CreateDate','CreatorResourceID','Description','DueDateTime','EstimatedHours','ExternalID','id','InstalledProductID','LastActivityDate','TicketNumber','Title','FirstResponseDateTime','ResolutionPlanDateTime','ResolvedDateTime','FirstResponseDueDateTime','ResolutionPlanDueDateTime','ResolvedDueDateTime','ServiceLevelAgreementHasBeenMet','Resolution','PurchaseOrderNumber','ProblemTicketId','OpportunityId','ChangeInfoField1','ChangeInfoField2','ChangeInfoField3','ChangeInfoField4','ChangeInfoField5','LastCustomerNotificationDateTime','LastCustomerVisibleActivityDateTime','ContractServiceID','ContractServiceBundleID','MonitorID','AEMAlertID','HoursToBeScheduled','FirstResponseInitiatingResourceID','FirstResponseAssignedResourceID','ProjectID')]
        [String[]]
        $LessThan ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('AccountID','AllocationCodeID','AssignedResourceID','AssignedResourceRoleID','CompletedDate','ContactID','ContractID','CreateDate','CreatorResourceID','Description','DueDateTime','EstimatedHours','ExternalID','id','InstalledProductID','LastActivityDate','TicketNumber','Title','FirstResponseDateTime','ResolutionPlanDateTime','ResolvedDateTime','FirstResponseDueDateTime','ResolutionPlanDueDateTime','ResolvedDueDateTime','ServiceLevelAgreementHasBeenMet','Resolution','PurchaseOrderNumber','ProblemTicketId','OpportunityId','ChangeInfoField1','ChangeInfoField2','ChangeInfoField3','ChangeInfoField4','ChangeInfoField5','LastCustomerNotificationDateTime','LastCustomerVisibleActivityDateTime','ContractServiceID','ContractServiceBundleID','MonitorID','AEMAlertID','HoursToBeScheduled','FirstResponseInitiatingResourceID','FirstResponseAssignedResourceID','ProjectID')]
        [String[]]
        $LessThanOrEquals ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('Description','ExternalID','TicketNumber','Title','Resolution','PurchaseOrderNumber','ChangeInfoField1','ChangeInfoField2','ChangeInfoField3','ChangeInfoField4','ChangeInfoField5','AEMAlertID')]
        [String[]]
        $Like ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('Description','ExternalID','TicketNumber','Title','Resolution','PurchaseOrderNumber','ChangeInfoField1','ChangeInfoField2','ChangeInfoField3','ChangeInfoField4','ChangeInfoField5','AEMAlertID')]
        [String[]]
        $NotLike ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('Description','ExternalID','TicketNumber','Title','Resolution','PurchaseOrderNumber','ChangeInfoField1','ChangeInfoField2','ChangeInfoField3','ChangeInfoField4','ChangeInfoField5','AEMAlertID')]
        [String[]]
        $BeginsWith ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('Description','ExternalID','TicketNumber','Title','Resolution','PurchaseOrderNumber','ChangeInfoField1','ChangeInfoField2','ChangeInfoField3','ChangeInfoField4','ChangeInfoField5','AEMAlertID')]
        [String[]]
        $EndsWith ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('Description','ExternalID','TicketNumber','Title','Resolution','PurchaseOrderNumber','ChangeInfoField1','ChangeInfoField2','ChangeInfoField3','ChangeInfoField4','ChangeInfoField5','AEMAlertID')]
        [String[]]
        $Contains
    )



          

  Begin
  { 
    If (-not($global:atws.Url))
    {
      Throw [ApplicationException] 'Not connected to Autotask WebAPI. Run Connect-AutotaskWebAPI first.'
    }
    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

  }   

  Process
  {     

    If (-not($Filter))
    {
        $Fields = $Atws.GetFieldInfo('Ticket')
        
        Foreach ($Parameter in $PSBoundParameters.GetEnumerator())
        {
            $Field = $Fields | Where-Object {$_.Name -eq $Parameter.Key}
            If ($Field)
            { 
                If ($Field.IsPickList)
                {
                  $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $Parameter.Value}
                  $Value = $PickListValue.Value
                }
                Else
                {
                  $Value = $Parameter.Value
                }
                $Filter += $Parameter.Key
                If ($Parameter.Key -in $NotEquals)
                { $Filter += '-ne'}
                ElseIf ($Parameter.Key -in $GreaterThan)
                { $Filter += '-gt'}
                ElseIf ($Parameter.Key -in $GreaterThanOrEqual)
                { $Filter += '-ge'}
                ElseIf ($Parameter.Key -in $LessThan)
                { $Filter += '-lt'}
                ElseIf ($Parameter.Key -in $LessThanOrEquals)
                { $Filter += '-le'}
                ElseIf ($Parameter.Key -in $Like)
                { $Filter += '-like'}
                ElseIf ($Parameter.Key -in $NotLike)
                { $Filter += '-notlike'}
                ElseIf ($Parameter.Key -in $BeginsWith)
                { $Filter += '-beginswith'}
                ElseIf ($Parameter.Key -in $EndsWith)
                { $Filter += '-endswith'}
                ElseIf ($Parameter.Key -in $Contains)
                { $Filter += '-contains'}
                Else
                { $Filter += '-eq'}
                $Filter += $Value
            }
        }
        
    } #'NotEquals','GreaterThan','GreaterThanOrEqual','LessThan','LessThanOrEquals','Like','NotLike','BeginsWith','EndsWith

    Get-AtwsData -Entity Ticket -Filter $Filter }   

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

  }


        
}
