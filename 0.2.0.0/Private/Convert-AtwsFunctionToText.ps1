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
    $TextFrame = "{0}`nFunction {1}`n{{`n{2}`n  [CmdLetBinding(DefaultParameterSetName='{3}')]`n  Param`n  (`n{4}`n  )`n{5}`n}}"
  }
  
  Process
  {
    $FunctionText = $TextFrame -F
      $AtwsFunction.Copyright,
      $AtwsFunction.FunctionName,
      $AtwsFunction.HelpText,
      $AtwsFunction.DefaultParameterSetName,
      $($AtwsFunction.Parameters -join ",`n`n"),
      $AtwsFunction.Definition
  }
  
  End
  {
    Return $FunctionText
  }
  
}
