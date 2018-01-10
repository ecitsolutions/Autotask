Function Get-AtwsPSParameter
{
  [CmdLetBinding()]
  Param
  (
    [Switch]$Mandatory,

    [Alias('Remaining')]
    [Switch]$ValueFromRemainingArguments,

    [Alias('SetName')]
    [String[]]$ParameterSetName,

    [Alias('Pipeline')]
    [Switch]$ValueFromPipeline,

    [Alias('NotNull')]
    [Switch]$ValidateNotNullOrEmpty,

    [String[]]$ValidateSet,

    [Alias('Length')]
    [int]$ValidateLength,

    [Parameter(Mandatory = $True)]
    [String]$Type,

    [Switch]$Array,

    [Parameter(Mandatory = $True)]
    [String]$Name
          
  )
   
  Foreach ($SetName in $ParameterSetName)
  { 
    # Make an array of properties that goes inside the Parameter clause
    $ParamProperties = @()
    If ($Mandatory.IsPresent)                   
    {
      $ParamProperties += "      Mandatory = `$true"  
    }
    If ($ValueFromRemainingArguments.IsPresent) 
    {
      $ParamProperties += "      ValueFromRemainingArguments = `$true" 
    } 
    If ($ParameterSetName)                      
    {
      $ParamProperties += "      ParameterSetName = '$SetName'" 
    }
    If ($ValueFromPipeline.IsPresent)           
    {
      $ParamProperties += "      ValueFromPipeline = `$true" 
    }

    # Create the [Parameter()] clause
    If ($ParamProperties.Count -gt 0)
    {
      $Text += "    [Parameter(`n"
      $Text += $ParamProperties -join ",`n"
      $Text += "`n    )]`n"
    }
  }
  # Add validate not null if present
  If ($ValidateNotNullOrEmpty.IsPresent)      
  {
    $Text += "    [ValidateNotNullOrEmpty()]`n" 
  }

  # Add validate length if present
  If ($ValidateLength -gt 0)      
  {
    $Text += "    [ValidateLength(1,$ValidateLength)]`n" 
  }
        
  # Add Validateset if present
  If ($ValidateSet.Count -gt 0)               
  { 
    # Fix quote characters for labels
    $Labels = Foreach ($Label in  $ValidateSet)
    {
      If ($Label -match ("['{0}]" -F [Char]8217))
      {
        '"{0}"' -F $Label
      }
      Else
      {
        "'{0}'" -F $Label
      }
    }          
    $Text += "    [ValidateSet($($Labels -join ', '))]`n" 
  }

  # Add the correct variable type for the parameter
  $Text += "    [$Type"
  If ($Array.IsPresent) 
  {
    $Text += '[]'
  }
  $Text += "]`n`    `$$Name"
        
  Return $Text
}
