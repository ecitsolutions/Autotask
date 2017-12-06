<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Get-AtwsContact
{
  <#
      .SYNOPSIS
      This function get one or more Contact through the Autotask Web Services API.
      .DESCRIPTION
      This function creates a query based on any parameters you give and returns any resulting 
objects from the Autotask Web Services Api. By default the function returns any objects with properties 
that are Equal (-eq) to the value of the parameter. To give you more flexibility you can modify the operator
by using -NotEquals [ParameterName[]], -LessThan [ParameterName[]] and so on. 
Use Get-help Get-AtwsContact for all possible operators.
      .INPUTS
      Nothing. This function only takes parameters.
      .OUTPUTS
      [Autotask.Contact[]]. This function outputs the Autotask.Contact that was returned by the API.
      .EXAMPLE
      Get-AtwsContact  -Parameter1 [Parameter1 value] -Parameter2 [Parameter2 Value] -GreaterThan Parameter2
Returns all objects where a property by name of "Parameter1" is equal to [Parameter1 value] and where a property
by name of "Parameter2" is greater than [Parameter2 Value].
      For parameters, use Get-Help Get-AtwsContact
      .NOTES
      NAME: Get-AtwsContact
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
         [Int]
         $AccountID
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
         [string]
         $LastName
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $MiddleInitial
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
         [string]
         $AddressLine
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $AddressLine1
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $City
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $State
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $ZipCode
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $Country
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $EMailAddress
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $EMailAddress2
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $EMailAddress3
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [boolean]
         $Notification
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $Phone
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $Extension
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $AlternatePhone
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
         $FaxNumber
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $Note
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
         [string]
         $RoomNumber
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $Active
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
         [datetime]
         $LastModifiedDate
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $AdditionalAddressInformation
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
         [Int]
         $CountryID
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [datetime]
         $BulkEmailOptOutTime
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [ValidateSet('Mr.','Mrs.','Ms.')]

        [String]
         $NamePrefix
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [Int]
         $NameSuffix
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $FacebookUrl
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $TwitterUrl
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [string]
         $LinkedInUrl
 ,

        [Parameter(
          Mandatory = $False,
          ParameterSetName = 'By_parameters'
        )]
         [boolean]
         $PrimaryContact
 ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('id','AccountID','FirstName','LastName','MiddleInitial','Title','AddressLine','AddressLine1','City','State','ZipCode','Country','EMailAddress','EMailAddress2','EMailAddress3','Notification','Phone','Extension','AlternatePhone','MobilePhone','FaxNumber','Note','LastActivityDate','RoomNumber','Active','CreateDate','LastModifiedDate','AdditionalAddressInformation','ExternalID','CountryID','BulkEmailOptOutTime','FacebookUrl','TwitterUrl','LinkedInUrl','PrimaryContact')]
        [String[]]
        $NotEquals ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('id','AccountID','FirstName','LastName','MiddleInitial','Title','AddressLine','AddressLine1','City','State','ZipCode','Country','EMailAddress','EMailAddress2','EMailAddress3','Notification','Phone','Extension','AlternatePhone','MobilePhone','FaxNumber','Note','LastActivityDate','RoomNumber','Active','CreateDate','LastModifiedDate','AdditionalAddressInformation','ExternalID','CountryID','BulkEmailOptOutTime','FacebookUrl','TwitterUrl','LinkedInUrl','PrimaryContact')]
        [String[]]
        $GreaterThan ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('id','AccountID','FirstName','LastName','MiddleInitial','Title','AddressLine','AddressLine1','City','State','ZipCode','Country','EMailAddress','EMailAddress2','EMailAddress3','Notification','Phone','Extension','AlternatePhone','MobilePhone','FaxNumber','Note','LastActivityDate','RoomNumber','Active','CreateDate','LastModifiedDate','AdditionalAddressInformation','ExternalID','CountryID','BulkEmailOptOutTime','FacebookUrl','TwitterUrl','LinkedInUrl','PrimaryContact')]
        [String[]]
        $GreaterThanOrEqual ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('id','AccountID','FirstName','LastName','MiddleInitial','Title','AddressLine','AddressLine1','City','State','ZipCode','Country','EMailAddress','EMailAddress2','EMailAddress3','Notification','Phone','Extension','AlternatePhone','MobilePhone','FaxNumber','Note','LastActivityDate','RoomNumber','Active','CreateDate','LastModifiedDate','AdditionalAddressInformation','ExternalID','CountryID','BulkEmailOptOutTime','FacebookUrl','TwitterUrl','LinkedInUrl','PrimaryContact')]
        [String[]]
        $LessThan ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('id','AccountID','FirstName','LastName','MiddleInitial','Title','AddressLine','AddressLine1','City','State','ZipCode','Country','EMailAddress','EMailAddress2','EMailAddress3','Notification','Phone','Extension','AlternatePhone','MobilePhone','FaxNumber','Note','LastActivityDate','RoomNumber','Active','CreateDate','LastModifiedDate','AdditionalAddressInformation','ExternalID','CountryID','BulkEmailOptOutTime','FacebookUrl','TwitterUrl','LinkedInUrl','PrimaryContact')]
        [String[]]
        $LessThanOrEquals ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('FirstName','LastName','MiddleInitial','Title','AddressLine','AddressLine1','City','State','ZipCode','Country','EMailAddress','EMailAddress2','EMailAddress3','Phone','Extension','AlternatePhone','MobilePhone','FaxNumber','Note','RoomNumber','AdditionalAddressInformation','ExternalID','FacebookUrl','TwitterUrl','LinkedInUrl')]
        [String[]]
        $Like ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('FirstName','LastName','MiddleInitial','Title','AddressLine','AddressLine1','City','State','ZipCode','Country','EMailAddress','EMailAddress2','EMailAddress3','Phone','Extension','AlternatePhone','MobilePhone','FaxNumber','Note','RoomNumber','AdditionalAddressInformation','ExternalID','FacebookUrl','TwitterUrl','LinkedInUrl')]
        [String[]]
        $NotLike ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('FirstName','LastName','MiddleInitial','Title','AddressLine','AddressLine1','City','State','ZipCode','Country','EMailAddress','EMailAddress2','EMailAddress3','Phone','Extension','AlternatePhone','MobilePhone','FaxNumber','Note','RoomNumber','AdditionalAddressInformation','ExternalID','FacebookUrl','TwitterUrl','LinkedInUrl')]
        [String[]]
        $BeginsWith ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('FirstName','LastName','MiddleInitial','Title','AddressLine','AddressLine1','City','State','ZipCode','Country','EMailAddress','EMailAddress2','EMailAddress3','Phone','Extension','AlternatePhone','MobilePhone','FaxNumber','Note','RoomNumber','AdditionalAddressInformation','ExternalID','FacebookUrl','TwitterUrl','LinkedInUrl')]
        [String[]]
        $EndsWith ,        

        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('FirstName','LastName','MiddleInitial','Title','AddressLine','AddressLine1','City','State','ZipCode','Country','EMailAddress','EMailAddress2','EMailAddress3','Phone','Extension','AlternatePhone','MobilePhone','FaxNumber','Note','RoomNumber','AdditionalAddressInformation','ExternalID','FacebookUrl','TwitterUrl','LinkedInUrl')]
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
        $Fields = $Atws.GetFieldInfo('Contact')
        
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

    Get-AtwsData -Entity Contact -Filter $Filter }   

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

  }


        
}
