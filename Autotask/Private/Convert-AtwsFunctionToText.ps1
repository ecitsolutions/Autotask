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
    $TextFrame = "#Requires -Version {0}`n{1}`nFunction {2}`n{{`n{3}`n  [CmdLetBinding(DefaultParameterSetName='{4}', ConfirmImpact='{5}')]`n  Param`n  (`n{6}`n  )`n{7}`n}}"
  }
  
  Process
  {
    $FunctionText = $TextFrame -F
      $RequiredVersion,
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
