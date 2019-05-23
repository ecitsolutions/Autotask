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
    $Mandatory = @{}
    $ParameterSet = @{}
    
    # Add Default PSParameter info to Fields
    Foreach ($Field in $FieldInfo)
    {
      $Mandatory[$Field.Name] = $Field.IsRequired
      $ParameterSet[$Field.Name] = @('By_parameters')
    }
  }

  Process
  { 
    $TypeName = 'Autotask.{0}' -F $Entity.Name
      
    If ($Verb -eq 'Get') {
      # -Filter
      $Comment = 'A filter that limits the number of objects that is returned from the API'
      Get-AtwsPSParameter -Name 'Filter' -SetName 'Filter' -Type 'String' -Mandatory -Remaining -NotNull  -Array -Comment $Comment
      $ReferenceFields = $FieldInfo.Where( {$_.IsReference}).Name | Sort-Object
      # -GetReferenceEntityById, -GetRef
      $Comment = 'Follow this external ID and return any external objects'            
      Get-AtwsPSParameter -Name 'GetReferenceEntityById' -Alias 'GetRef' -SetName 'Filter', 'By_parameters' -Type 'String' -NotNull -ValidateSet $ReferenceFields -Comment $Comment
      # -GetExternalEntityByThisEntityId, -External
      $IncomingReferenceEntities = Get-AtwsFieldInfo -Entity $Entity.Name -ReferencingEntity | Sort-Object
      $Comment = 'Return entities of selected type that are referencing to this entity.'
      Get-AtwsPSParameter -Name 'GetExternalEntityByThisEntityId' -Alias 'External' -SetName 'Filter', 'By_parameters' -Type 'String' -NotNull -ValidateSet $IncomingReferenceEntities -Comment $Comment
      # -All
      $Comment = 'Return all objects in one query'    
      Get-AtwsPSParameter -Name 'All' -SetName 'Get_all' -Type 'Switch' -Comment $Comment
      # -NoPickListLabel
      $Comment = 'Do not add descriptions for all picklist attributes with values'
      Get-AtwsPSParameter -Name 'NoPickListLabel' -SetName 'Filter','Get_all','By_parameters' -Type 'Switch' -Comment $Comment
      If ($Entity.HasUserDefinedFields) {
        # -UserDefinedField
        $Comment = 'A single user defined field can be used pr query'
        Get-AtwsPSParameter -Name 'UserDefinedField' -Alias 'UDF' -SetName 'By_parameters' -Type 'Autotask.UserDefinedField' -NotNull -Comment $Comment
      }
    }    
    ElseIf ($Verb -eq 'Set') {
      # -InputObject
      $Comment = 'An object that will be modified by any parameters and updated in Autotask'
      Get-AtwsPSParameter -Name 'InputObject' -SetName 'Input_Object' -Type $TypeName -Mandatory -Pipeline -NotNull -Array -Comment $Comment
      # -Id
      $Field = $FieldInfo.Where( {$_.Name -eq 'Id'})
      $Comment = 'The object.ids of objects that should be modified by any parameters and updated in Autotask'
      Get-AtwsPSParameter -Name 'Id' -SetName 'By_Id' -Type $Field.Type -Mandatory -NotNull -Array -Comment $Comment
      # -PassThru
      $Comment = 'Return any updated objects through the pipeline'
      Get-AtwsPSParameter -Name 'PassThru' -SetName 'Input_Object','By_parameters' -Type 'Switch' -Comment $Comment
      If ($Entity.HasUserDefinedFields) {
        # -UserDefinedFields
        $Comment = 'User defined fields already setup i Autotask'
        Get-AtwsPSParameter -Name 'UserDefinedFields' -Alias 'UDF' -SetName 'Input_Object','By_parameters' -Type 'Autotask.UserDefinedField' -Array -Comment $Comment
      }
    }
    ElseIf ($Verb -in 'New') {
      # -InputObject
      $Comment = 'An array of objects to create'          
      Get-AtwsPSParameter -Name 'InputObject' -SetName 'Input_Object' -Type $TypeName -Mandatory -Pipeline -NotNull -Array -Comment $Comment
      If ($Entity.HasUserDefinedFields) {
        # -UserDefinedFields
        $Comment = 'User defined fields already setup i Autotask'
        Get-AtwsPSParameter -Name 'UserDefinedFields' -Alias 'UDF' -SetName 'By_parameters' -Type 'Autotask.UserDefinedField' -NotNull -Array -Comment $Comment
      }
    }
    ElseIf ($Verb -eq 'Remove') {
      # -InputObject
      $Comment = 'Any objects that should be deleted'          
      Get-AtwsPSParameter -Name 'InputObject' -SetName 'Input_Object' -Type $TypeName -Mandatory -Pipeline -NotNull -Array -Comment $Comment
      # -Id
      $Field = $FieldInfo.Where( {$_.Name -eq 'Id'})
      $Comment = 'The unique id of an object to delete'
      Get-AtwsPSParameter -Name 'Id' -SetName 'By_parameters' -Type $Field.Type -Mandatory  -NotNull -Array -Comment $Comment
    }
    

    Switch ($Verb)
    {
      'Get' 
      { 
        [array]$Fields = $FieldInfo.Where({
            $_.IsQueryable
        }) | ForEach-Object -Process {
          $Mandatory[$_.Name] = $False
          $_
        }
      }
      'Set' 
      { 
        [array]$Fields = $FieldInfo.Where({
            -Not $_.IsReadOnly
        }) | ForEach-Object -Process {
          $ParameterSet[$_.Name] = @('Input_Object','By_parameters', 'By_Id')
          $_
        }
      }
      'New' 
      {
        [array]$Fields = $FieldInfo.Where({
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
      # Start with native field type
      $Type = $Field.Type

      # Fieldtype for picklists
      If ($Field.IsPickList) {
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
        Mandatory              = $Mandatory[$Field.Name]
        ParameterSetName       = $ParameterSet[$Field.Name]
        ValidateNotNullOrEmpty = $Field.IsRequired
        ValidateLength         = $ValidateLength
        ValidateSet            = $Field.PickListValues.Label | Sort-Object -Unique
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
      [array]$Labels = $Fields | Select-Object -ExpandProperty Name
      If ($Entity.HasUserDefinedFields) {$Labels += 'UserDefinedField'}
      Foreach ($Operator in 'NotEquals', 'IsNull', 'IsNotNull') {
        Get-AtwsPSParameter -Name $Operator -SetName 'By_parameters' -Type 'String' -Array -ValidateSet $Labels
      }

      # These operators work for all fields except boolean (add quote characters here)
      [array]$Labels = $Fields | Where-Object { $_.Type -ne 'boolean' } | Select-Object -ExpandProperty Name
      If ($Entity.HasUserDefinedFields) {$Labels += 'UserDefinedField'}
      Foreach ($Operator in 'GreaterThan', 'GreaterThanOrEquals', 'LessThan', 'LessThanOrEquals') {
        Get-AtwsPSParameter -Name $Operator -SetName 'By_parameters' -Type 'String' -Array -ValidateSet $Labels
      }

      # These operators only work for strings (add quote characters here)
      [array]$Labels = $Fields | Where-Object { $_.Type -eq 'string' } | Select-Object -ExpandProperty Name
      If ($Entity.HasUserDefinedFields) {$Labels += 'UserDefinedField'}
      Foreach ($Operator in 'Like', 'NotLike', 'BeginsWith', 'EndsWith', 'Contains') {
        Get-AtwsPSParameter -Name $Operator -SetName 'By_parameters' -Type 'String' -Array -ValidateSet $Labels
      }
      
      # This operator only work for datetime (add quote characters here)
      [array]$Labels = $Fields | Where-Object { $_.Type -eq 'datetime' } | Select-Object -ExpandProperty Name
      If ($Entity.HasUserDefinedFields) {$Labels += 'UserDefinedField'}
      Foreach ($Operator in 'IsThisDay') {
        Get-AtwsPSParameter -Name $Operator -SetName 'By_parameters' -Type 'String' -Array -ValidateSet $Labels
      }
    }
  }
}
