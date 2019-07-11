Function Convert-AtwsFunctionToText
{
  [CmdLetBinding()]
  Param
  (   
    [Parameter(Mandatory = $True)]
    [PSObject]
    $AtwsFunction
  )
  Begin 
  { 
    $RequiredVersion = '4.0'
    $ModuleVersion = $MyInvocation.MyCommand.Module.Version
    $TextFrame = "#Requires -Version {0}`n#Version {1}`n{2}`nFunction {3}`n{{`n{4}`n  [CmdLetBinding(SupportsShouldProcess = `$True, DefaultParameterSetName='{5}', ConfirmImpact='{6}')]`n  Param`n  (`n{7}`n  )`n{8}`n}}"
  }
  
  Process
  {
    $FunctionText = $TextFrame -F
      $RequiredVersion,
      $ModuleVersion,
      $AtwsFunction.Copyright,
      $AtwsFunction.FunctionName,
      $AtwsFunction.HelpText,
      $AtwsFunction.DefaultParameterSetName,
      $AtwsFunction.ConfirmImpact,
      $($AtwsFunction.Parameters -join ",`n`n"),
      $AtwsFunction.Definition
  }
  
  End
  {
    Return $FunctionText
  }
  
}
