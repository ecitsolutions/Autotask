Function Get-AtwsFunctionDefinition
{
  [CmdLetBinding()]
  [OutputType([PSObject[]])]
  Param
  (
    [Parameter(Mandatory = $True)]
    [Autotask.EntityInfo]
    $Entity,
    
    [Parameter(Mandatory = $True)]
    [Autotask.Field[]]
    $FieldInfo
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

    

    Foreach ($Verb in $Verbs)
    {
      $FunctionName = '{0}-{1}' -F $Verb, $Entity.Name

      Write-Verbose ('{0}: Creating Function {1}' -F $MyInvocation.MyCommand.Name, $FunctionName)
    
      $ConfirmImpact = Switch ($Verb)
      {
        'New'    {'Medium'}
        'Remove' {'Low'}
        'Get'    {'None'}
        'Set'    {'Medium'}
      }
      
      $DefaultParameterSetName = Switch ($Verb)
      {
        'New'    {'By_parameters'}
        'Remove' {'Input_Object'}
        'Get'    {'Filter'}
        'Set'    {'InputObject'}
      }
     
      $AtwsFunction = New-Object -TypeName PSObject -Property @{
        FunctionName = $FunctionName
        Copyright = Get-Copyright
        HelpText = Get-AtwsHelpText -Entity $Entity -Verb $Verb -FieldInfo $FieldInfo -FunctionName $FunctionName
        DefaultParameterSetName = $DefaultParameterSetName 
        ConfirmImpact = $ConfirmImpact
        Parameters = Get-AtwsParameterDefinition -Entity $Entity -Verb $Verb -FieldInfo $FieldInfo
        Definition = (Get-Command ('{0}-AtwsDefinition' -F $Verb)).Definition -replace '#EntityName',$($Entity.Name)
      }
    
      $FunctionDefinition[$FunctionName] = Convert-AtwsFunctionToText -AtwsFunction $AtwsFunction
   
    }
  }
  
  End 
  { 
    Return $FunctionDefinition
  }
}
