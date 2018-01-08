
Function Import-AtwsCmdLet
{
  [CmdLetBinding(
      SupportsShouldProcess = $True,
      ConfirmImpact = 'Medium'
  )]
  Param
  (
    [Switch]
    $ExportToDisk,
    
    [String]
    $Prefix = 'Atws'
  )
  
  Begin
  { 

    Function Get-AtwsFunctionDefinition
    {
      [CmdLetBinding()]
      Param
      (
        [Parameter(Mandatory = $True)]
        [Autotask.EntityInfo]
        $Entity,
    
        [String]
        $Prefix = 'Atws'
      )
    
      $FunctionDefinition = @{}
    
      $Verbs = @()
    
      If ($Entity.CanCreate) 
      {
        $Verbs += 'New'
      }
      If ($Entity.CanDelete) 
      {
        $Verbs += 'Remove'
      }
      If ($Entity.CanQuery)  
      {
        $Verbs += 'Get'
      }
      If ($Entity.CanUpdate) 
      {
        $Verbs += 'Set'
      }

      Write-Verbose ('{0}: Getting FieldInfo() for Entity [Autotask.{1}]' -F $MyInvocation.MyCommand.Name, $Entity.Name)
      $FieldInfo = $Atws.GetFieldInfo($Entity.Name)
      Foreach ($Field in $FieldInfo)
      {
        Add-Member -InputObject $Field -MemberType NoteProperty -Name 'ParameterSet' -Value 'By_parameters'
        Add-Member -InputObject $Field -MemberType NoteProperty -Name 'Mandatory' -Value $Field.IsRequired
      }

      Foreach ($Verb in $Verbs)
      {
        $FunctionName = '{0}-{1}{2}' -F $Verb, $Prefix, $Entity.Name

        Write-Verbose ('{0}: Creating Function {1}' -F $MyInvocation.MyCommand.Name, $FunctionName)
      
        # Start function and get parameter definition 
        Switch ($Verb) {
          'New' 
          {
            $Synopsis = 'This function creates a new {0} through the Autotask Web Services API.' -F $Entity.Name
            $RequiredParameters = $FieldInfo.Where({$_.IsRequired -and $_.Name -ne 'id'}).Name
            $Description = "To create a new {0} you need the following required fields:`n -{1}" -F $Entity.Name, $($RequiredParameters -join "`n -")
            $Inputs = 'Nothing. This function only takes parameters.'
            $Outputs = '[Autotask.{0}]. This function outputs the Autotask.{1} that was created by the API.' -F $Entity.Name, $Entity.Name
            $Examples = "{0} -{1} [Value]" -F $FunctionName, $($RequiredParameters -join ' [Value] -')
            $DefaultParameterSetName = 'By_parameters'
          }
          'Remove' 
          {
            $Synopsis = 'This function deletes a {0} through the Autotask Web Services API.' -F $Entity.Name
            $Description = $Synopsis
            $Inputs = '[Autotask.{0}[]]. This function takes objects as input. Pipeline is supported.' -F $Entity.Name
            $Outputs = 'Nothing. This fuction just deletes the Autotask.{0} that was passed to the function.' -F $Entity.Name
            $Examples = '{0}  [-ParameterName] [Parameter value]' -F $FunctionName          
            $DefaultParameterSetName = 'Input_Object'
          }
          'Get' 
          {
            $Synopsis = 'This function get one or more {0} through the Autotask Web Services API.' -F $Entity.Name
            $Description = "This function creates a query based on any parameters you give and returns any resulting objects from the Autotask Web Services Api. By default the function returns any objects with properties that are Equal (-eq) to the value of the parameter. To give you more flexibility you can modify the operator by using -NotEquals [ParameterName[]], -LessThan [ParameterName[]] and so on.`n`nPossible operators for all parameters are:`n -NotEquals`n -GreaterThan`n -GreaterThanOrEqual`n -LessThan`n -LessThanOrEquals `n`nAdditional operators for [String] parameters are:`n -Like (supports * or % as wildcards)`n -NotLike`n -BeginsWith`n -EndsWith`n -Contains" 
            $Inputs = 'Nothing. This function only takes parameters.'
            $Outputs = '[Autotask.{0}[]]. This function outputs the Autotask.{1} that was returned by the API.' -F $Entity.Name, $Entity.Name
            $Examples = "{0}  -Parameter1 [Parameter1 value] -Parameter2 [Parameter2 Value] -GreaterThan Parameter2`nReturns all objects where a property by name of ""Parameter1"" is equal to [Parameter1 value] and where a property by name of ""Parameter2"" is greater than [Parameter2 Value]." -F $FunctionName
            $DefaultParameterSetName = 'Filter'
          }
          'Set' 
          {
            $Synopsis = 'This function sets parameters on the {0} specified by the -InputObject parameter through the Autotask Web Services API.' -F $Entity.Name
            $Description = 'This function one or more objects of type [Autotask.{0}] as input. You can pipe the objects to the function or pass them using the -InputObject parameter. You specify the property you want to set and the value you want to set it to using parameters. The function modifies all objects and updates the online
            data through the Autotask Web Services API.' -F $Entity.Name
            $Inputs = '[Autotask.{0}[]]. This function takes objects as input. Pipeline is supported.' -F $Entity.Name
            $Outputs = 'Nothing or [Autotask.{0}]. This function optionally returns the updated objects if you use the -PassThru parameter.' -F $Entity.Name, $Entity.Name
            $Examples = '{0}  [-ParameterName] [Parameter value]' -F $FunctionName          
            $DefaultParameterSetName = 'InputObject'
          }
        }
      
        $FunctionDefinition[$FunctionName] = @"
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function $FunctionName
{
  <#
      .SYNOPSIS
      $Synopsis
      .DESCRIPTION
      $Description
      .INPUTS
      $Inputs
      .OUTPUTS
      $Outputs
      .EXAMPLE
      $Examples
      For parameters, use Get-Help $FunctionName
      .NOTES
      NAME: $FunctionName
  #>
	  [CmdLetBinding(DefaultParameterSetName='$DefaultParameterSetName')]
    Param
    (
        $(Get-AtwsParameterDefinition -Entity $Entity -Verb $Verb -FieldInfo $FieldInfo)
    )

       $FunctionDefinition = '{0}-AutotaskDefinition' -F $Verb
       (Get-Command $FunctionDefinition).Definition -replace '#EntityName',${Entity.Name}
      


        
}
"@
      }
    
      Return $FunctionDefinition
    }

    Function Get-AtwsParameterDefinition
    {
      [CmdLetBinding()]
      Param
      (   
        [Parameter(Mandatory)]
        [Autotask.EntityInfo]
        $Entity,
        
        [Parameter(Mandatory)]
        [ValidateSet('Get', 'Set', 'New', 'Remove')]
        [String]
        $Verb,
        
        [Parameter(Mandatory)]
        [Autotask.Field[]]
        $FieldInfo
      )
    Begin
    {
      Function Get-Parameter
      {
        [CmdLetBinding()]
        Param
        (
          [Switch]$Mandatory,

          [Alias('Remaining')]
          [Switch]$ValueFromRemainingArguments,

          [Alias('SetName')]
          [String]$ParameterSetName,

          [Alias('Pipeline')]
          [Switch]$ValueFromPipeline,

          [Alias('NotNull')]
          [Switch]$ValidateNotNullOrEmpty,

          [String[]]$ValidateSet,

          [Parameter(Mandatory = $True)]
          [String]$Type,

          [Switch]$Array,

          [Parameter(Mandatory = $True)]
          [String]$Name,

          [Switch]$First
          
        )

        If ($First.IsPresent)                       {$Text = "`t[Parameter(`n"}
        Else                                        {$Text = ",`n`n`t[Parameter(`n"}
        
        If ($Mandatory.IsPresent)                   { $Text += "`t`tMandatory = `$true`n"  }
        If ($ValueFromRemainingArguments.IsPresent) { $Text += "`t`tValueFromRemainingArguments = `$true`n" } 
        If ($ParameterSetName)                      { $Text += "`t`tParameterSetName = '$ParameterSetName'`n" }
        If ($ValueFromPipeline.IsPresent)           { $Text += "`t`tValueFromPipeline = `$true`n" }
        $Text += "`t)]`n"
        If ($ValidateNotNullOrEmpty.IsPresent)      { $Text += "`t[ValidateNotNullOrEmpty()]`n" }
        If ($ValidateSet.Count -gt 0)               { $Text += "`t[ValidateSet($($ValidateSet -join ','))]`n" }

        $Text += "`t[$Type"
        If ($Array.IsPresent)                       {$Text += "[]"}
        $Text += "]`n`t`$$Name"
        
        Return $Text
      }
    }

    Process
    { 
    $TypeName = 'Autotask.{0}' -F $Entity.Name
      
    If ($Verb -eq 'Get')
      {
        Get-Parameter -Name 'Filter' -SetName 'Filter' -Type 'String'-Mandatory -Remaining -NotNull  -Array -First
      }    
      ElseIf ($Verb -eq 'Set')
      {
        Get-Parameter -Name 'InputObject' -SetName 'Input_Object' -Type $TypeName -Mandatory -Pipeline -NotNull -Array -First
        Get-Parameter -Name 'PassThru' -SetName 'Input_Object' -Type 'Switch'
      }
      ElseIf ($Verb -in 'New')
      {
        Get-Parameter -Name 'InputObject' -SetName 'Input_Object' -Type $TypeName -Mandatory -Pipeline -NotNull -First
      }
      ElseIf ($Verb -eq 'Remove')
      {
        Get-Parameter -Name 'InputObject' -SetName 'Input_Object' -Type $TypeName -Mandatory -Pipeline -NotNull -Array -First   
        Get-Parameter -Name 'Id' -SetName 'By_parameters' -Type $TypeName -Mandatory  -NotNull -Array
      }
    

      Switch ($Verb)
      {
        'Get' 
        { 
          $Fields = $FieldInfo.Where({$_.IsQueryable}) | ForEach-Object -Process {
            $_.Mandatory = $False
            $_
          }
        }
        'Set' 
        { 
          $Fields = $FieldInfo.Where({-Not $_.IsReadOnly}) | ForEach-Object -Process {
            $_.ParameterSet = 'Input_Object'
          }
        }
        'New' 
        { 
          $Fields = $FieldInfo.Where({$_.Name -ne 'Id'})
        }
        default 
        {
          Return
        }

      }
    

      Foreach ($Field in $Fields )
      {
        $Type = Switch ($Field.Type) 
        {
          'Integer' {'Int'}
          'Short'   {'Int16'}
          default   {$Field.Type}
        }

        # ValidateSet for picklists and Fieldtype
        If ($Field.IsPickList -and $Field.PicklistValues.Count -gt 0)
        {
          $Type = 'String'
          $Labels = Foreach ($Label in $Field.PickListValues.Label)
          {
            If ($Label -match "['’]")
            {
              '"{0}"' -F $Label
            }
            Else
            {
              "'{0}'" -F $Label
            }
          }
        }

        $ParameterOptions = @{
          Mandatory = $Field.Mandatory
          ParameterSetName = $Field.ParameterSet
          ValidateNotNullOrEmpty = $(($Field.IsRequired -and $Verb -in @('New', 'Set')))
          ValidateSet = $Labels
          Array = $(($Verb -eq 'Get'))
          Name = $Field.Name 
        }

        Get-Parameter @ParameterOptions

      }
    
    
      # Make modifying operators possible
      If ($Verb -eq 'Get')
      {
        # These operators work for all fields
        $Labels = $Fields 
        Foreach ($Operator in 'NotEquals', 'GreaterThan', 'GreaterThanOrEqual', 'LessThan', 'LessThanOrEquals')
        {
          Get-Parameter -Name $Operator -SetName 'By_parameters' -Type 'String' -Array -ValidateSet $Labels.Name
        }

        # These operators only work for strings
        $Labels = $Fields | Where-Object {$_.Type -eq 'string'}
        Foreach ($Operator in 'Like', 'NotLike', 'BeginsWith', 'EndsWith', 'Contains')
        {
          Get-Parameter -Name $Operator -SetName 'By_parameters' -Type 'String' -Array -ValidateSet $Labels.Name

        }
      }
    }
  }

    If (-not($global:atws.Url))
    {
      Throw [ApplicationException] 'Not connected to Autotask WebAPI. Run Connect-AutotaskWebAPI first.'
    }
    Write-Verbose -Message ('{0}: Calling  atws.EntityInfo() to get list over available entities.' -F $MyInvocation.MyCommand.Name)

    $Caption = 'Import-AtwsCmdLet'
    $VerboseDescrition = '{0}: Calling atws.EntityInfo()' -F $Caption
    $VerboseWarning = '{0}: About to call atws.EntityInfo(). Do you want to continue?' -F $Caption

    If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption))
    {
      $Entities = $Atws.getEntityInfo()
    }
    Else
    {
      $Entities = @()
    }
    
  } 
  
  Process
  {
    $ModuleName = 'AutotaskCI{0}' -F $($atws.getZoneInfo($atws.Credentials.UserName).CI)    
    $Activity = 'Importing Autotask Powershell CmdLets as module {0}' -F $ModuleName
    $ModuleFunctions = @()
    Foreach ($Entity in $Entities)
    { 
      Write-Verbose -Message ('{0}: Creating functions for Entity {1}' -F $MyInvocation.MyCommand.Name, $Entity.Name) 
      
      
      $FunctionDefinition = Get-AtwsFunctionDefinition -Entity $Entity -Prefix $Prefix
     
      
      # Calculating progress percentage and displaying it
      $Index = $Entities.IndexOf($Entity) +1
      $PercentComplete = $Index / $Entities.Count * 100
      $Status = 'Entity {0}/{1} ({2:n0}%)' -F $Index, $Entities.Count, $PercentComplete
      $CurrentOperation = 'Importing {0}' -F $Entity.Name
      Write-Progress -Activity $Activity -Status $Status -PercentComplete $PercentComplete -CurrentOperation $CurrentOperation
      
      $Caption = 'Import-AtwsCmdLet'
      $VerboseDescrition = '{0}: Creating and Invoking functions for entity {1}' -F $Caption, $Entity.Name
      $VerboseWarning = '{0}: About to create and Invoke functions for entity {1}. Do you want to continue?' -F $Caption, $Entity.Name

      If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption))
      { 
        Foreach ($Function in $FunctionDefinition.GetEnumerator())
        {
  
          If ($ExportToDisk)
          {
            Write-Verbose -Message ('{0}: Writing file for function  {1}' -F $MyInvocation.MyCommand.Name, $Function.Key)
                        
            $FilePath = '{0}\{1}.ps1' -F $PSScriptRoot, $Function.Key
          
            $Caption = 'Import-AtwsCmdLet'
            $VerboseDescrition = '{0}: Overwriting {1}' -F $Caption, $FilePath
            $VerboseWarning = '{0}: About to overwrite {1}. Do you want to continue?' -F $Caption, $FilePath

            If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption))
            {
              Set-Content -Path $FilePath -Value $Function.Value -Force -Encoding UTF8
            }
          }
                 
          $ModuleFunctions += $Function.Value
        }
      }
    }
  }
  End
  {
    Write-Verbose -Message ('{0}: Importing Autotask Dynamic Module' -F $MyInvocation.MyCommand.Name)
    
    $FunctionScriptBlock = [ScriptBlock]::Create($($ModuleFunctions))
        
    New-Module -Name $ModuleName -ScriptBlock $FunctionScriptBlock  | Import-Module -Global
    
  }
}
