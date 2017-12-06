<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Get-AtwsResource
{
  <#
      .SYNOPSIS
      This function get one or more Resource through the Autotask Web Services API.
      .DESCRIPTION
      This function creates a query based on any parameters you give and returns any resulting 
objects from the Autotask Web Services Api. By default the function returns any objects with properties 
that are Equal (-eq) to the value of the parameter. To give you more flexibility you can modify the operator
by using -NotEquals [ParameterName[]], -LessThan [ParameterName[]] and so on. 
Use Get-help Get-AtwsResource for all possible operators.
      .INPUTS
      Nothing. This function only takes parameters.
      .OUTPUTS
      [Autotask.Resource[]]. This function outputs the Autotask.Resource that was returned by the API.
      .EXAMPLE
      Get-AtwsResource  -Parameter1 [Parameter1 value] -Parameter2 [Parameter2 Value] -GreaterThan Parameter2
Returns all objects where a property by name of "Parameter1" is equal to [Parameter1 value] and where a property
by name of "Parameter2" is greater than [Parameter2 Value].
      For parameters, use Get-Help Get-AtwsResource
      .NOTES
      NAME: Get-AtwsResource
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
         [boolean]
         $Active
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $Email
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $Email2
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $Email3
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Mobile email service','Pager e-mail address','Primary e-mail address','Secondary e-mail address','SMS text messaging address')]

        [String]
         $EmailTypeCode
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Mobile email service','Pager e-mail address','Primary e-mail address','Secondary e-mail address','SMS text messaging address')]

        [String]
         $EmailTypeCode2
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Mobile email service','Pager e-mail address','Primary e-mail address','Secondary e-mail address','SMS text messaging address')]

        [String]
         $EmailTypeCode3
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $FirstName
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Female','Male')]

        [String]
         $Gender
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Mr.','Mrs.','Ms.')]

        [String]
         $Greeting
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $HomePhone
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
         [string]
         $Initials
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $LastName
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Hvervenmoen')]

        [String]
         $LocationID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $MiddleName
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $MobilePhone
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $OfficeExtension
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $OfficePhone
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Contractor','Employee')]

        [String]
         $ResourceType
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $Suffix
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
         [ValidateSet('0%','up to 100%','up to 25%','up to 50%','up to 75%')]

        [String]
         $TravelAvailabilityPct
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $UserName
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('System Administrator','Manager','Project Manager','Sales','Team Member','Contractor','Service Desk User','Private CRM','Time and Attendance','Full Access','System Administrator (OCH)','Salg (OCH)','Konsulent og tekniker (OCH)','Dashboard User','Minimal Access','Konsulent og tekniker med kontrakter (OCH)','API User')]

        [String]
         $UserType
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('MM/dd/yyyy','MM/dd/yy','MM-dd-yyyy','MM-dd-yy','MM.dd.yyyy','MM.dd.yy','dd/MM/yyyy','dd/MM/yy','dd-MM-yyyy','dd-MM-yy','dd.MM.yyyy','dd.MM.yy','yyyy/MM/dd','yy/MM/dd','yyyy-MM-dd','yy-MM-dd','yyyy.MM.dd','yy.MM.dd')]

        [String]
         $DateFormat
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('hh:mm a','HH:mm','h:mm a')]

        [String]
         $TimeFormat
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Salary','Hourly','Contractor','Salary Non Exempt')]

        [String]
         $PayrollType
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('X,XXX.XX','X.XXX,XX')]

        [String]
         $NumberFormat
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $AccountingReferenceID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [double]
         $InternalCost
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $HireDate
 ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('Active','Email','Email2','Email3','FirstName','HomePhone','id','Initials','LastName','MiddleName','MobilePhone','OfficeExtension','OfficePhone','Title','UserName','AccountingReferenceID','InternalCost','HireDate')]
        [String[]]
        $NotEquals ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('Active','Email','Email2','Email3','FirstName','HomePhone','id','Initials','LastName','MiddleName','MobilePhone','OfficeExtension','OfficePhone','Title','UserName','AccountingReferenceID','InternalCost','HireDate')]
        [String[]]
        $GreaterThan ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('Active','Email','Email2','Email3','FirstName','HomePhone','id','Initials','LastName','MiddleName','MobilePhone','OfficeExtension','OfficePhone','Title','UserName','AccountingReferenceID','InternalCost','HireDate')]
        [String[]]
        $GreaterThanOrEqual ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('Active','Email','Email2','Email3','FirstName','HomePhone','id','Initials','LastName','MiddleName','MobilePhone','OfficeExtension','OfficePhone','Title','UserName','AccountingReferenceID','InternalCost','HireDate')]
        [String[]]
        $LessThan ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('Active','Email','Email2','Email3','FirstName','HomePhone','id','Initials','LastName','MiddleName','MobilePhone','OfficeExtension','OfficePhone','Title','UserName','AccountingReferenceID','InternalCost','HireDate')]
        [String[]]
        $LessThanOrEquals ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('Email','Email2','Email3','EmailTypeCode','EmailTypeCode2','EmailTypeCode3','FirstName','Gender','HomePhone','Initials','LastName','MiddleName','MobilePhone','OfficeExtension','OfficePhone','ResourceType','Suffix','Title','TravelAvailabilityPct','UserName','DateFormat','TimeFormat','NumberFormat','AccountingReferenceID')]
        [String[]]
        $Like ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('Email','Email2','Email3','EmailTypeCode','EmailTypeCode2','EmailTypeCode3','FirstName','Gender','HomePhone','Initials','LastName','MiddleName','MobilePhone','OfficeExtension','OfficePhone','ResourceType','Suffix','Title','TravelAvailabilityPct','UserName','DateFormat','TimeFormat','NumberFormat','AccountingReferenceID')]
        [String[]]
        $NotLike ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('Email','Email2','Email3','EmailTypeCode','EmailTypeCode2','EmailTypeCode3','FirstName','Gender','HomePhone','Initials','LastName','MiddleName','MobilePhone','OfficeExtension','OfficePhone','ResourceType','Suffix','Title','TravelAvailabilityPct','UserName','DateFormat','TimeFormat','NumberFormat','AccountingReferenceID')]
        [String[]]
        $BeginsWith ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('Email','Email2','Email3','EmailTypeCode','EmailTypeCode2','EmailTypeCode3','FirstName','Gender','HomePhone','Initials','LastName','MiddleName','MobilePhone','OfficeExtension','OfficePhone','ResourceType','Suffix','Title','TravelAvailabilityPct','UserName','DateFormat','TimeFormat','NumberFormat','AccountingReferenceID')]
        [String[]]
        $EndsWith ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('Email','Email2','Email3','EmailTypeCode','EmailTypeCode2','EmailTypeCode3','FirstName','Gender','HomePhone','Initials','LastName','MiddleName','MobilePhone','OfficeExtension','OfficePhone','ResourceType','Suffix','Title','TravelAvailabilityPct','UserName','DateFormat','TimeFormat','NumberFormat','AccountingReferenceID')]
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
        $Fields = $Atws.GetFieldInfo('Resource')
        
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

    Get-AtwsData -Entity Resource -Filter $Filter }   

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

  }


        
}
