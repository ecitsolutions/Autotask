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
    $TextFrame = "{0}`nFunction {1}`n{{`n{2}`n  [CmdLetBinding(DefaultParameterSetName='{3}', ConfirmImpact='{4}')]`n  Param`n  (`n{5}`n  )`n{6}`n}}"
  }
  
  Process
  {
    $FunctionText = $TextFrame -F
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
