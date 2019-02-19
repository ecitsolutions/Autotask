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
      
        If ($Verb -eq 'Get') {
            $Comment = 'A filter that limits the number of objects that is returned from the API'
            Get-AtwsPSParameter -Name 'Filter' -SetName 'Filter' -Type 'String' -Mandatory -Remaining -NotNull  -Array -Comment $Comment
            $ReferenceFields = $FieldInfo.Where( {$_.IsReference}).Name
            $Comment = 'Follow this external ID and return any external objects'            
            Get-AtwsPSParameter -Name 'GetReferenceEntityById' -Alias 'GetRef' -SetName 'Filter', 'By_parameters' -Type 'String' -NotNull -ValidateSet $ReferenceFields -Comment $Comment
            $Comment = 'Return all objects in one query'    
            Get-AtwsPSParameter -Name 'All' -SetName 'Get_all' -Type 'Switch' -Comment $Comment
            $Comment = 'Add descriptions for all picklist attributes with values'
            Get-AtwsPSParameter -Name 'AddPickListLabel' -SetName 'Filter','Get_All','By_parameters' -Type 'Switch' -Comment $Comment
            If ($Entity.HasUserDefinedFields) {
                $Comment = 'A single user defined field can be used pr query'
                Get-AtwsPSParameter -Name 'UserDefinedField' -Alias 'UDF' -SetName 'By_parameters' -Type 'Autotask.UserDefinedField' -NotNull -Comment $Comment
            }
        }    
        ElseIf ($Verb -eq 'Set') {
            $Comment = 'An object that will be modified by any parameters and updated in Autotask'
            Get-AtwsPSParameter -Name 'InputObject' -SetName 'Input_Object' -Type $TypeName -Mandatory -Pipeline -NotNull -Array -Comment $Comment
            $Comment = 'The object.ids of objects that should be modified by any parameters and updated in Autotask'
            Get-AtwsPSParameter -Name 'Id' -SetName 'By_parameters' -Type 'Int' -Mandatory -NotNull -Array -Comment $Comment
            $Comment = 'Return any updated objects through the pipeline'
            Get-AtwsPSParameter -Name 'PassThru' -SetName 'Input_Object','By_parameters' -Type 'Switch' -Comment $Comment
            If ($Entity.HasUserDefinedFields) {
                $Comment = 'User defined fields already setup i Autotask'
                Get-AtwsPSParameter -Name 'UserDefinedFields' -Alias 'UDF' -SetName 'Input_Object','By_parameters' -Type 'Autotask.UserDefinedField' -Array -Comment $Comment
              }
        }
        ElseIf ($Verb -in 'New') {
            $Comment = 'An array of objects to create'          
            Get-AtwsPSParameter -Name 'InputObject' -SetName 'Input_Object' -Type $TypeName -Mandatory -Pipeline -NotNull -Array -Comment $Comment
            If ($Entity.HasUserDefinedFields) {
                $Comment = 'User defined fields already setup i Autotask'
                Get-AtwsPSParameter -Name 'UserDefinedFields' -Alias 'UDF' -SetName 'By_parameters' -Type 'Autotask.UserDefinedField' -NotNull -Array -Comment $Comment
            }
        }
        ElseIf ($Verb -eq 'Remove') {
            $Comment = 'Any objects that should be deleted'          
            Get-AtwsPSParameter -Name 'InputObject' -SetName 'Input_Object' -Type $TypeName -Mandatory -Pipeline -NotNull -Array -Comment $Comment
            $Comment = 'The unique id of an object to delete'
            Get-AtwsPSParameter -Name 'Id' -SetName 'By_parameters' -Type $TypeName -Mandatory  -NotNull -Array -Comment $Comment
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
          $_.ParameterSet = 'Input_Object','By_parameters'
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
        'long' 
        {
          'Int64'
        }
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
      If ($Field.IsPickList -and $Field.PicklistValues.Count -gt 0) {
          $Type = 'String'
          $ValidateLength = 0
      }
      Else {
          $ValidateLength = $Field.Length
      }

      
      $Alias = @() 
      If ($Field.Name -eq $EntityNameParameter)
      {
        $Alias += 'Name'
      }

      $ParameterOptions = @{
        Mandatory              = $Field.Mandatory
        ParameterSetName       = $Field.ParameterSet
        ValidateNotNullOrEmpty = $Field.IsRequired
        ValidateLength         = $ValidateLength
        ValidateSet            = $Field.PickListValues.Label | Select-Object -Unique
        Array                  = $(($Verb -eq 'Get'))
        Name                   = $Field.Name
        Alias                  = $Alias
        Type                   = $Type
        Comment                = $Field.Label
      }

      Get-AtwsPSParameter @ParameterOptions
    }
    
    
    # Make modifying operators possible
    If ($Verb -eq 'Get') {
      # These operators work for all fields (add quote characters here)
      Foreach ($Operator in 'NotEquals', 'IsNull', 'IsNotNull') {
        Get-AtwsPSParameter -Name $Operator -SetName 'By_parameters' -Type 'String' -Array -ValidateSet $Fields.Name
      }

      # These operators work for all fields except boolean (add quote characters here)
      $Labels = $Fields | Where-Object { $_.Type -ne 'boolean' }
      Foreach ($Operator in 'GreaterThan', 'GreaterThanOrEquals', 'LessThan', 'LessThanOrEquals') {
        Get-AtwsPSParameter -Name $Operator -SetName 'By_parameters' -Type 'String' -Array -ValidateSet $Labels.Name
      }

      # These operators only work for strings (add quote characters here)
      $Labels = $Fields | Where-Object { $_.Type -eq 'string' }
      Foreach ($Operator in 'Like', 'NotLike', 'BeginsWith', 'EndsWith', 'Contains') {
        Get-AtwsPSParameter -Name $Operator -SetName 'By_parameters' -Type 'String' -Array -ValidateSet $Labels.Name
      }
      
      # This operator only work for datetime (add quote characters here)
      $Labels = $Fields | Where-Object { $_.Type -eq 'datetime' }
      Foreach ($Operator in 'IsThisDay') {
        Get-AtwsPSParameter -Name $Operator -SetName 'By_parameters' -Type 'String' -Array -ValidateSet $Labels.Name
      }
    }
  }
}
