Function Get-AtwsData 
{
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory = $True)]
        [String]
        $QueryXmlasText
    )
    
    [xml]$QueryXml = $QueryXmlasText
    
    If (-not($global:atws.Url))
    {
        
        Throw [ApplicationException] 'Not connected to Autotask WebAPI. Run Connect-AutotaskWebAPI first.'
    }
    
    $result = @()
    
    # Native XML is rather tedious...
    $field = $QueryXml.CreateElement('field')
    $expression = $QueryXml.CreateElement('expression')
    $expression.SetAttribute('op','greaterthan')
    $expression.InnerText = 0
    $field.InnerText = 'id'
    [void]$field.AppendChild($expression)
    
    # Insert looping construct into query
    [void]$QueryXml.queryxml.query.AppendChild($field)
    
    Do 
    {
    
        $lastquery = $atws.query($QueryXml.InnerXml)

        If ($lastquery.Errors.Count -gt 0)
        {
            Foreach ($AtwsError in $lastquery.Errors)
            {
                Write-Error $AtwsError.Message
            }
            Return
        }
        $result += $lastquery.EntityResults
        $UpperBound = $lastquery.EntityResults[$lastquery.EntityResults.GetUpperBound(0)].id
        $expression.InnerText = $UpperBound
    }
    Until ($lastquery.EntityResults.Count -lt 500)
    
    $result

}