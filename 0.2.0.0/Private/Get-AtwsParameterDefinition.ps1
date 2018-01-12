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
      
  }

  Process
  { 
    $TypeName = 'Autotask.{0}' -F $Entity.Name
      
    If ($Verb -eq 'Get')
    {
      Get-AtwsPSParameter -Name 'Filter' -SetName 'Filter' -Type 'String' -Mandatory -Remaining -NotNull  -Array 
      $ReferenceFields = $FieldInfo.Where({$_.IsReference}).Name
      Get-AtwsPSParameter -Name 'GetReferenceEntityById' -Alias 'GetRef' -SetName 'Filter','By_parameters' -Type 'String' -NotNull -ValidateSet $ReferenceFields
    }    
    ElseIf ($Verb -eq 'Set')
    {
      Get-AtwsPSParameter -Name 'InputObject' -SetName 'Input_Object' -Type $TypeName -Mandatory -Pipeline -NotNull -Array 
      Get-AtwsPSParameter -Name 'PassThru' -SetName 'Input_Object' -Type 'Switch'
    }
    ElseIf ($Verb -in 'New')
    {
      Get-AtwsPSParameter -Name 'InputObject' -SetName 'Input_Object' -Type $TypeName -Mandatory -Pipeline -NotNull
    }
    ElseIf ($Verb -eq 'Remove')
    {
      Get-AtwsPSParameter -Name 'InputObject' -SetName 'Input_Object' -Type $TypeName -Mandatory -Pipeline -NotNull -Array
      Get-AtwsPSParameter -Name 'Id' -SetName 'By_parameters' -Type $TypeName -Mandatory  -NotNull -Array
    }
    

    Switch ($Verb)
    {
      'Get' 
      { 
        $Fields = $FieldInfo.Where({
            $_.IsQueryable
        }) | ForEach-Object -Process {
          $_.Mandatory = $False
          $_
        }
      }
      'Set' 
      { 
        $Fields = $FieldInfo.Where({
            -Not $_.IsReadOnly
        }) | ForEach-Object -Process {
          $_.ParameterSet = 'Input_Object'
          $_
        }
      }
      'New' 
      {
        $Fields = $FieldInfo.Where({
            $_.Name -ne 'Id'
        })
      }
      default 
      {
        Return
      }

    }
    
    # Add Name alias for EntityName parameters
    $EntityNameParameter = '{0}Name' -f $Entity.Name
    Foreach ($Field in $Fields )
    {
      $Type = Switch ($Field.Type) 
      {
        'Integer' 
        {
          'Int'
        }
        'Short'   
        {
          'Int16'
        }
        default   
        {
          $Field.Type
        }
      }

      # Fieldtype for picklists
      If ($Field.IsPickList -and $Field.PicklistValues.Count -gt 0)
      {
        $Type = 'String'
      }
      
      $Alias = @() 
      If ($Field.Name -eq $EntityNameParameter)
      {
        $Alias += 'Name'
      }

      $ParameterOptions = @{
        Mandatory              = $Field.Mandatory
        ParameterSetName       = $Field.ParameterSet
        ValidateNotNullOrEmpty = $(($Field.IsRequired -and $Verb -in @('New', 'Set')))
        ValidateLength         = $Field.Length
        ValidateSet            = $Field.PickListValues.Label
        Array                  = $(($Verb -eq 'Get'))
        Name                   = $Field.Name
        Alias                  = $Alias
        Type                   = $Type
      }

      Get-AtwsPSParameter @ParameterOptions
    }
    
    
    # Make modifying operators possible
    If ($Verb -eq 'Get')
    {
      # These operators work for all fields (add quote characters here)
      $Labels = $Fields | ForEach-Object -Process {
        $_ = "'{0}'" -F $_
      }
      Foreach ($Operator in 'NotEquals', 'GreaterThan', 'GreaterThanOrEqual', 'LessThan', 'LessThanOrEquals')
      {
        Get-AtwsPSParameter -Name $Operator -SetName 'By_parameters' -Type 'String' -Array -ValidateSet $Labels.Name
      }

      # These operators only work for strings (add quote characters here)
      $Labels = $Fields |
      Where-Object -FilterScript {
        $_.Type -eq 'string'
      } |
      ForEach-Object -Process {
        $_ = "'{0}'" -F $_
      }
      Foreach ($Operator in 'Like', 'NotLike', 'BeginsWith', 'EndsWith', 'Contains')
      {
        Get-AtwsPSParameter -Name $Operator -SetName 'By_parameters' -Type 'String' -Array -ValidateSet $Labels.Name
      }
    }
  }
}
