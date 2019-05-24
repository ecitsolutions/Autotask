#Requires -Version 4.0
#Version 1.6.2.11
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function New-AtwsProduct
{


<#
.SYNOPSIS
This function creates a new Product through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.Product] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the Product with Id number 0 you could write 'New-AtwsProduct -Id 0' or you could write 'New-AtwsProduct -Filter {Id -eq 0}.

'New-AtwsProduct -Id 0,4' could be written as 'New-AtwsProduct -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new Product you need the following required fields:
 -Name
 -Active
 -ProductAllocationCodeID
 -Serialized

Entities that have fields that refer to the base entity of this CmdLet:

ContractCost
 InstalledProduct
 InventoryItem
 InventoryTransfer
 Opportunity
 PriceListProduct
 ProductVendor
 ProjectCost
 PurchaseOrderItem
 QuoteItem
 TicketCost

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Product]. This function outputs the Autotask.Product that was created by the API.
.EXAMPLE
$Result = New-AtwsProduct -Name [Value] -Active [Value] -ProductAllocationCodeID [Value] -Serialized [Value]
Creates a new [Autotask.Product] through the Web Services API and returns the new object.
 .EXAMPLE
$Result = Get-AtwsProduct -Id 124 | New-AtwsProduct 
Copies [Autotask.Product] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsProduct -Id 124 | New-AtwsProduct | Set-AtwsProduct -ParameterName <Parameter Value>
Copies [Autotask.Product] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsProduct to modify the object.
 .EXAMPLE
$Result = Get-AtwsProduct -Id 124 | New-AtwsProduct | Set-AtwsProduct -ParameterName <Parameter Value> -Passthru
Copies [Autotask.Product] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsProduct to modify the object and returns the new object.

.LINK
Get-AtwsProduct
 .LINK
Set-AtwsProduct

#>

  [CmdLetBinding(DefaultParameterSetName='By_parameters', ConfirmImpact='Low')]
  Param
  (
# An array of objects to create
    [Parameter(
      ParameterSetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.Product[]]
    $InputObject,

# Product Name
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1,100)]
    [string]
    $Name,

# Product Description
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,2000)]
    [string]
    $Description,

# Product SKU
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string]
    $SKU,

# Product Link
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,500)]
    [string]
    $Link,

# Product Category
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $ProductCategory,

# External ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string]
    $ExternalProductID,

# Unit Cost
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $UnitCost,

# Unit Price
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $UnitPrice,

# MSRP
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $MSRP,

# Vendor Account ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $DefaultVendorID,

# Vendor Product Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string]
    $VendorProductNumber,

# Manufacturer Account Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,100)]
    [string]
    $ManufacturerName,

# Manufacturer Product Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string]
    $ManufacturerProductName,

# Active
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [boolean]
    $Active,

# Period Type
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String]
    $PeriodType,

# Allocation Code ID
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $ProductAllocationCodeID,

# Is Serialized
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [boolean]
    $Serialized,

# Cost Allocation Code ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Int]
    $CostAllocationCodeID,

# Does Not Require Procurement
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [boolean]
    $DoesNotRequireProcurement,

# markup_rate
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [double]
    $MarkupRate,

# Internal Product ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(1,50)]
    [string]
    $InternalProductID
  )
 
  Begin
  { 
    $EntityName = 'Product'
           
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
    $ProcessObject = @()
  }

  Process
  {
    $Fields = Get-AtwsFieldInfo -Entity $EntityName
    
    If ($InputObject)
    {
      Write-Verbose ('{0}: Copy Object mode: Setting ID property to zero' -F $MyInvocation.MyCommand.Name)  
      
      $CopyNo = 1

      Foreach ($Object in $InputObject) 
      { 
        # Create a new object and copy properties
        $NewObject = New-Object Autotask.$EntityName
        
        # Copy every non readonly property
        $FieldNames = $Fields.Where({$_.Name -ne 'id'}).Name
        If ($PSBoundParameters.ContainsKey('UserDefinedFields')) {
          $FieldNames += 'UserDefinedFields'
        }
        Foreach ($Field in $FieldNames)
        {
          $NewObject.$Field = $Object.$Field
        }
        If ($NewObject -is [Autotask.Ticket])
        {
          Write-Verbose ('{0}: Copy Object mode: Object is a Ticket. Title must be modified to avoid duplicate detection.' -F $MyInvocation.MyCommand.Name)  
          $Title = '{0} (Copy {1})' -F $NewObject.Title, $CopyNo
          $CopyNo++
          $NewObject.Title = $Title
        }
        $ProcessObject += $NewObject
      }   
    }
    Else
    {
      Write-Debug ('{0}: Creating empty [Autotask.{1}]' -F $MyInvocation.MyCommand.Name, $EntityName) 
      $ProcessObject += New-Object Autotask.$EntityName    
    }
    
    Foreach ($Parameter in $PSBoundParameters.GetEnumerator())
    {
      $Field = $Fields | Where-Object {$_.Name -eq $Parameter.Key}
      If ($Field -or $Parameter.Key -eq 'UserDefinedFields')
      { 
        If ($Field.IsPickList)
        {
          If($Field.PickListParentValueField)
          {
            $ParentField = $Fields.Where{$_.Name -eq $Field.PickListParentValueField}
            $ParentLabel = $PSBoundParameters.$($ParentField.Name)
            $ParentValue = $ParentField.PickListValues | Where-Object {$_.Label -eq $ParentLabel}
            $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $Parameter.Value -and $_.ParentValue -eq $ParentValue.Value}                
          }
          Else 
          { 
            $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $Parameter.Value}
          }
          $Value = $PickListValue.Value
        }
        Else
        {
          $Value = $Parameter.Value
        } 

        Foreach ($Object in $ProcessObject) 
        { 
          $Object.$($Parameter.Key) = $Value
        }
      }
    }    

    $Result = New-AtwsData -Entity $ProcessObject
  }

  End
  {
    Write-Debug ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $Result.count, $EntityName)
    Return $Result
  }

}
