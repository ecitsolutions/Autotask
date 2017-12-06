<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Get-AtwsResourceRole
{
  <#
      .SYNOPSIS
      This function get a ResourceRole through the Autotask Web Services API.
      .DESCRIPTION
      This function get a ResourceRole through the Autotask Web Services API.
      .EXAMPLE
      Get-AtwsResourceRole [-ParameterName] [Parameter value]
      Use Get-Help Get-AtwsResourceRole
      .NOTES
      NAME: Get-AtwsResourceRole
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
         [long]
         $id
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [long]
         $ResourceID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [long]
         $DepartmentID
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
         [long]
         $RoleID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [boolean]
         $Active
 ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','ResourceID','DepartmentID','RoleID','Active')]
        [String[]]
        $NotEquals ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','ResourceID','DepartmentID','RoleID','Active')]
        [String[]]
        $GreaterThan ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','ResourceID','DepartmentID','RoleID','Active')]
        [String[]]
        $GreaterThanOrEqual ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','ResourceID','DepartmentID','RoleID','Active')]
        [String[]]
        $LessThan ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('id','ResourceID','DepartmentID','RoleID','Active')]
        [String[]]
        $LessThanOrEquals ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('')]
        [String[]]
        $Like ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('')]
        [String[]]
        $NotLike ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('')]
        [String[]]
        $BeginsWith ,        

        [Parameter(
          ParameterSetName = 'By_Parameter'
        )]
        [ValidateSet('')]
        [String[]]
        $EndsWith
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
        $Fields = $Atws.GetFieldInfo('ResourceRole')
        
        Foreach ($Parameter in $PSBoundParameters.GetEnumerator())
        {
            $Field = $Fields | Where-Object {$_.Name -eq $Parameter.Key}
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
            $Filter += '-eq'
            $Filter += $Value
        }
        
    }

    Get-AtwsData -Entity ResourceRole -Filter $Filter }   

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

  }


        
}
