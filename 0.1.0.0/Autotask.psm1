<#
        # Kort beskrivelse av modulen.
           "Modul for � kople seg til og utf�re operasjoner p� Autotask sitt web-API."
        # Lang beskrivelse av modulen.
           
        # Dato for opprettelse av modulen.
           09/04/2017 16:01:56
#>
[CmdletBinding()]
$PublicFunction  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue ) # Public functions can be called by user after module import
# $PrivateFunction = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue ) # Not in use # Private functions can only be called internally in other functions in the module 
# $Templates = @( Get-ChildItem -Path $PSScriptRoot\Templates\* -ErrorAction SilentlyContinue ) # Not in use 

foreach ($Import in @($PublicFunction + $PrivateFunction))
{
    Write-Verbose "Importing $Import"
    if ($Import.Name -like "*test*") { continue }
    try
    {
        . $Import.fullname
    }
    catch
    {
        throw "Could not import function $($Import.fullname): $_"
    }
}

Export-ModuleMember -Function $PublicFunction.Basename