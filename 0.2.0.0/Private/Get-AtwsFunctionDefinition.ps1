Function Get-AtwsFunctionDefinition
{
  [CmdLetBinding()]
  Param
  (
    [Parameter(Mandatory = $True)]
    [Autotask.EntityInfo]
    $Entity,
    
    [Parameter(Mandatory = $True)]
    [Autotask.Field[]]
    $FieldInfo,
    
    [String]
    $Prefix = 'Atws'
  )
   
  Begin
  {
    $FunctionDefinition = @{}
    
    $Verbs = @()
  }
  Process
  { 
    
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

    # Add Default PSParameter info to Fields
    Foreach ($Field in $FieldInfo)
    {
      Add-Member -InputObject $Field -MemberType NoteProperty -Name 'ParameterSet' -Value 'By_parameters'
      Add-Member -InputObject $Field -MemberType NoteProperty -Name 'Mandatory' -Value $Field.IsRequired
    }

    Foreach ($Verb in $Verbs)
    {
      $FunctionName = '{0}-{1}{2}' -F $Verb, $Prefix, $Entity.Name

      Write-Verbose ('{0}: Creating Function {1}' -F $MyInvocation.MyCommand.Name, $FunctionName)
    
      $DefaultParameterSetName = Switch ($Verb)
      {
        'New'    {'By_parameters' }
        'Remove' {'Input_Object'}
        'Get'    {'Filter'}
        'Set'    {'InputObject' }
      }
     
      $AtwsFunction = New-Object -TypeName PSObject -Property @{
        FunctionName = $FunctionName
        Copyright = Get-Copyright
        HelpText = Get-AtwsHelpText -Entity $Entity -Verb $Verb -FieldInfo $FieldInfo -FunctionName $FunctionName
        DefaultParameterSetName = $DefaultParameterSetName 
        Parameters = Get-AtwsParameterDefinition -Entity $Entity -Verb $Verb -FieldInfo $FieldInfo
        Definition = (Get-Command ('{0}-AutotaskDefinition' -F $Verb)).Definition -replace '#EntityName',$($Entity.Name) -replace '#Prefix',$Prefix
      }
    
      $FunctionDefinition[$FunctionName] = Convert-AtwsFunctionToText -AtwsFunction $AtwsFunction
   
    }
  }
  
  End 
  { 
    Return $FunctionDefinition
  }
}
