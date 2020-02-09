Add-Type -Path './bin/Debug/netcoreapp3.1/AtwsSOAP.dll'

$defaultConfig = [ServiceReference.ATWSSoap]::ListSoap
$client = [ServiceReference.]