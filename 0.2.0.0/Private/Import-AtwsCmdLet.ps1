
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
      If ($Entity.CanUpdate) 
      {
        $Verbs += 'Update'
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
            $Description = 'This function creates a query based on any parameters you give and returns any resulting 
              objects from the Autotask Web Services Api. By default the function returns any objects with properties 
              that are Equal (-eq) to the value of the parameter. To give you more flexibility you can modify the operator
              by using -NotEquals [ParameterName[]], -LessThan [ParameterName[]] and so on. 
            Use Get-help {0} for all possible operators.' -F $FunctionName
            $Inputs = 'Nothing. This function only takes parameters.'
            $Outputs = '[Autotask.{0}[]]. This function outputs the Autotask.{1} that was returned by the API.' -F $Entity.Name, $Entity.Name
            $Examples = '{0}  -Parameter1 [Parameter1 value] -Parameter2 [Parameter2 Value] -GreaterThan Parameter2
              Returns all objects where a property by name of "Parameter1" is equal to [Parameter1 value] and where a property
            by name of "Parameter2" is greater than [Parameter2 Value].' -F $FunctionName
            $DefaultParameterSetName = 'Filter'
          }
          'Set' 
          {
            $Synopsis = 'This function sets parameters on the {0} specified by the -id parameter through the Autotask Web Services API.' -F $Entity.Name
            $Description = $Synopsis
            $Inputs = 'Nothing. This function only takes parameters.'
            $Outputs = '[Autotask.{0}]. This function returns the updated Autotask.{1} that was returned by the API.' -F $Entity.Name, $Entity.Name
            $Examples = '{0}  [-ParameterName] [Parameter value]' -F $FunctionName          
            $DefaultParameterSetName = 'By_parameters'
          }
          'Update' 
          {
            $Synopsis = 'This function updates a {0} through the Autotask Web Services API.' -F $Entity.Name
            $Description = $Synopsis
            $Inputs = '[Autotask.{0}[]]. This function takes objects as input. Pipeline is supported.' -F $Entity.Name
            $Outputs = '[Autotask.{0}[]]. This function returns the updated Autotask.{1} that was returned by the API.' -F $Entity.Name, $Entity.Name
            $Examples = @"
            `n
            {0} -InputObject `${1}`n
            Updates an [Autotask.{2}] from the variable passed as `${3}.
            `${4} | {5}`n
            Updates the [Autotask.{6}] object passed through the pipeline.`n
"@          -F $FunctionName, $Entity.Name, $Entity.Name, $Entity.Name, $Entity.Name, $FunctionName, $Entity.Name
            $DefaultParameterSetName = 'Input_Object'
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



        $(Get-AtwsFunctionLogic -Verb $Verb -Entity $Entity)


        
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
        [ValidateSet('Get', 'Set', 'New', 'Remove','Update')]
        [String]
        $Verb,
        
        [Parameter(Mandatory)]
        [Autotask.Field[]]
        $FieldInfo
      )
    

      If ($Verb -eq 'Get')
      {
        @"
        [Parameter(
          Mandatory = `$true,
          ValueFromRemainingArguments = `$true,
          ParameterSetName = 'Filter')]
        [ValidateNotNullOrEmpty()]
        [String[]]
        `$Filter
"@ 
      }    
      ElseIf ($Verb -eq 'Set')
      {
        @"
        [Parameter(
          Mandatory = `$true,
          ValueFromPipeLineByPropertyName = `$true,
          ParameterSetName = 'By_parameters')]
        [ValidateNotNullOrEmpty()]
        [Int[]]
        `$Id
"@ 
      }
      ElseIf ($Verb -in 'Update','New')
      {
        @"
        [Parameter(
          Mandatory = `$True,
          ParameterSetName = 'Input_Object',
          ValueFromPipeline = `$True
        )]
        [ValidateNotNullOrEmpty()]
        [Autotask.$($Entity.Name)[]]
        `$InputObject
"@
      }
      ElseIf ($Verb -eq 'Remove')
      {
        @"
        [Parameter(
          Mandatory = `$True,
          ParameterSetName = 'Input_Object',
          ValueFromPipeline = `$True
        )]
        [ValidateNotNullOrEmpty()]
        [Autotask.$($Entity.Name)]
        `$InputObject,

        [Parameter(
          Mandatory = `$True,
          ParameterSetName = 'By_parameters'
        )]
        [ValidateNotNullOrEmpty()]
        [Int[]]
        `$Id        
"@
      }
    
      Switch ($Verb)
      {
        'Get' 
        { 
          $Fields = $FieldInfo.Where({$_.IsQueryable})| ForEach-Object -Process {
            $_.Mandatory = $False
            $_
          }
        }
        'Set' 
        { 
          $Fields = $FieldInfo.Where({-Not $_.IsReadOnly})
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
        @"
,`n
        [Parameter(
          Mandatory = `$$($Field.Mandatory),
          ParameterSetName = '$($Field.ParameterSet)'
        )]`n
"@
        # ValidateSet for picklists
        If ($Field.IsRequired -and $Verb -in @('New', 'Set'))
        {
          @"
        [ValidateNotNullOrEmpty()]`n
"@
        }
        # ValidateSet for picklists and Fieldtype
        If ($Field.IsPickList -and $Field.PicklistValues.Count -gt 0)
        {
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
          @"
        [ValidateSet({0})]`n
        [String
"@      -f ($Labels -join ',')
        } 
        ElseIf ($Field.Type -eq 'Integer')
        {
          @"
        [Int
"@
        }
        ElseIf ($Field.Type -eq 'short')
        {
          @"
        [Int16
"@
        }
        Else
        {
          @"
        [{0}
"@      -f $Field.Type      
        }
        # Array permitted if GET, else single value
        If ($Verb -eq 'Get')
        {"[]]`n"}
        Else
        {"]`n"}
        # Parametername
        @"
        `${0}`n
"@       -f $Field.Name 
      }
    
    
      # Make modifying operators possible
      If ($Verb -eq 'Get')
      {
        $Labels = $Fields 
        Foreach ($Operator in 'NotEquals', 'GreaterThan', 'GreaterThanOrEqual', 'LessThan', 'LessThanOrEquals')
        {
          @"
,        `n
        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('{0}')]
        [String[]]
        `$$Operator
"@     -F ($Labels.Name -join "','")
        }

        $Labels = $Fields | Where-Object -FilterScript {
          $_.Type -eq 'string'
        }
        Foreach ($Operator in 'Like', 'NotLike', 'BeginsWith', 'EndsWith', 'Contains')
        {
          @"
,        `n
        [Parameter(
          ParameterSetName = 'By_parameters'
        )]
        [ValidateSet('{0}')]
        [String[]]
        `$$Operator
"@     -F ($Labels.Name -join "','")
        }
      }
    }

    Function Get-AtwsFunctionLogic
    {
      [CmdLetBinding()]
      Param
      (
        [Parameter(Mandatory = $True)]
        [Autotask.EntityInfo]
        $Entity,
        
        [Parameter(Mandatory)]
        [ValidateSet('Get', 'Set', 'New', 'Remove','Update')]
        [String]
        $Verb
        
      )
      # Common
      Begin
      { 
  
        @"
  `n
  Begin
  { 
    If (`$Verbose)
    {
      # Make sure the -Verbose parameter is inherited
      `$VerbosePreference = 'Continue'
    }
    If (-not(`$global:atws.Url))
    {
      Throw [ApplicationException] 'Not connected to Autotask WebAPI. Run Connect-AutotaskWebAPI first.'
    }
    Write-Verbose ('{0}: Begin of function' -F `$MyInvocation.MyCommand.Name)

  }
"@
      }
  
      Process
      {
        @"
  `n
  Process
  {
"@
    
        Switch ($Verb)
        {
          'Get' 
          {
            @"
    `n
    If (-not(`$Filter))
    {
        `$Fields = `$Atws.GetFieldInfo('$($Entity.Name)')
        
        Foreach (`$Parameter in `$PSBoundParameters.GetEnumerator())
        {
            `$Field = `$Fields | Where-Object {`$_.Name -eq `$Parameter.Key}
            If (`$Field)
            { 
              If (`$Parameter.Value.Count -gt 1)
              {
                `$Filter += '-begin'
              }
              Foreach (`$ParameterValue in `$Parameter.Value)
              {   
                `$Operator = '-or'
                If (`$Field.IsPickList)
                {
                  `$PickListValue = `$Field.PickListValues | Where-Object {`$_.Label -eq `$ParameterValue}
                  `$Value = `$PickListValue.Value
                }
                Else
                {
                  `$Value = `$ParameterValue
                }
                `$Filter += `$Parameter.Key
                If (`$Parameter.Key -in `$NotEquals)
                { 
                  `$Filter += '-ne'
                  `$Operator = '-and'
                }
                ElseIf (`$Parameter.Key -in `$GreaterThan)
                { `$Filter += '-gt'}
                ElseIf (`$Parameter.Key -in `$GreaterThanOrEqual)
                { `$Filter += '-ge'}
                ElseIf (`$Parameter.Key -in `$LessThan)
                { `$Filter += '-lt'}
                ElseIf (`$Parameter.Key -in `$LessThanOrEquals)
                { `$Filter += '-le'}
                ElseIf (`$Parameter.Key -in `$Like)
                { 
                  `$Filter += '-like'
                  `$Value = `$Value -replace '*','%'
                }
                ElseIf (`$Parameter.Key -in `$NotLike)
                { 
                  `$Filter += '-notlike'
                  `$Value = `$Value -replace '*','%'
                }
                ElseIf (`$Parameter.Key -in `$BeginsWith)
                { `$Filter += '-beginswith'}
                ElseIf (`$Parameter.Key -in `$EndsWith)
                { `$Filter += '-endswith'}
                ElseIf (`$Parameter.Key -in `$Contains)
                { `$Filter += '-contains'}
                Else
                { `$Filter += '-eq'}
                `$Filter += `$Value
                If (`$Parameter.Value.Count -gt 1 -and `$ParameterValue -ne `$Parameter.Value[-1])
                {
                  `$Filter += `$Operator
                }
                ElseIf (`$Parameter.Value.Count -gt 1)
                {
                  `$Filter += '-end'
                }
              }
            
            }
        }
        
    } #'NotEquals','GreaterThan','GreaterThanOrEqual','LessThan','LessThanOrEquals','Like','NotLike','BeginsWith','EndsWith

    Get-AtwsData -Entity $($Entity.Name) -Filter `$Filter
"@
          }

          'Set'
          {
            @"
  `n
    `$Filter = '{{id -eq {0}}}' -F `$(`$Id -join ' -or id -eq ')
    `$InputObject =  Get-AtwsData -Entity $($Entity.Name) -Filter `$Filter
    `$Fields = `$Atws.GetFieldInfo('$($Entity.Name)')
    
    Foreach (`$Parameter in `$PSBoundParameters.GetEnumerator())
    {
      `$Field = `$Fields | Where-Object {`$_.Name -eq `$Parameter.Key}
      If (`$Field)
      { 
          If (`$Field.IsPickList)
          {
            `$PickListValue = `$Field.PickListValues | Where-Object {`$_.Label -eq `$Parameter.Value}
            `$Value = `$PickListValue.Value
          }
          Else
          {
            `$Value = `$Parameter.Value
          }  
          `$InputObject.`$(`$Parameter.Key) = `$Value
      }
    }

    
    Set-AtwsData -Entity `$InputObject
"@ 
          }        
          'Update'
          {
            @"
  `n
    
    Set-AtwsData -Entity `$InputObject
"@
          }

          'New'
          {
            @"
  `n
    If (`$InputObject)
    {
      Write-Verbose ('{0}: Duplicate Object mode: Setting ID property to zero' -F `$MyInvocation.MyCommand.Name)  
      Foreach (`$Object in `$InputObject) 
      { 
        `$Object.Id = 0
      }   
    }
    Else
    {
       Write-Verbose ('{0}: Creating empty [Autotask.$($Entity.Name)] object' -F `$MyInvocation.MyCommand.Name) 
      `$InputObject = New-Object Autotask.$($Entity.Name)      
    }

    `$Fields = `$Atws.GetFieldInfo('$($Entity.Name)')
    
    Foreach (`$Parameter in `$PSBoundParameters.GetEnumerator())
    {
      `$Field = `$Fields | Where-Object {`$_.Name -eq `$Parameter.Key}
      If (`$Field)
      { 
          If (`$Field.IsPickList)
          {
            `$PickListValue = `$Field.PickListValues | Where-Object {`$_.Label -eq `$Parameter.Value}
            `$Value = `$PickListValue.Value
          }
          Else
          {
            `$Value = `$Parameter.Value
          }  
          Foreach (`$Object in `$InputObject) 
          { 
            `$Object.`$(`$Parameter.Key) = `$Value
          }
      }
    }
    New-AtwsData -Entity `$InputObject

"@
          }

          'Remove'
          {
            @"
  `n
    If (`$Id.Count -gt 0)
    {
      `$Filter = 'id -eq {0}' -F (`$Id -join ' -or id -eq ')
      `$InputObject = Get-AtwsData -Entity $($Entity.Name) -Filter `$Filter
    }
    If (`$InputObject)
    { 
      Remove-AtwsData -Entity `$Object 
    }

"@
          }

        }
        @"
}
"@
      }
      End
      { 
        @"
  `n
  End
  {
    Write-Verbose ('{0}: End of function' -F `$MyInvocation.MyCommand.Name)

  }
"@
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

    $Activity = 'Importing Autotask Powershell CmdLets'
    $ModuleFunctions = @()
    Foreach ($Entity in $Entities)
    { 
      Write-Verbose -Message ('{0}: Creating functions for Entity {1}' -F $MyInvocation.MyCommand.Name, $Entity.Name) 
      
      
      $FunctionDefinition = Get-AtwsFunctionDefinition -Entity $Entity -Prefix $Prefix
     
      
      # Calculating progress percentage and displaying it
      $PercentComplete = $Entities.IndexOf($Entity) / $Entities.Count * 100
      $Status = 'Importing {0}' -F $Entity.Name
      Write-Progress -Activity $Activity -Status $Status -PercentComplete $PercentComplete
      
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
    
    $ModuleName = 'AutotaskCI{0}' -F $($atws.getZoneInfo($atws.Credentials.UserName).CI)
    $FunctionScriptBlock = [ScriptBlock]::Create($($ModuleFunctions))
        
    New-Module -Name $ModuleName -ScriptBlock $FunctionScriptBlock  | Import-Module -Global
    
  }
}
