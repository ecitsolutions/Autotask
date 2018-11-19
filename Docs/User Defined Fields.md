# User Defined Fields

User defined fields are an important Autotask feature and the API supports them fully. The most important difference between normal fields and user defined fields is that user defined fields are referenced indirectly. A normal field has a name and a single valuem but user defined fields are an array of name/value pairs:

```powershell
$Account.AccountName = 'Company Name'
$Account.UserDefinedFields = @(
  @{
    name = 'udf_name'
    value = 'udf_value'
  }
  @{
    name = 'udf_name2'
    value = 123456
  }
)
```

There is a separate entity type [Autotask.UserDefinedField] which you can use, too:

```powershell
$Udf = New-Object [Autotask.UserDefinedField]
$Udf.name = 'udf_name'
$Udf.value = 'udf_value'

$Account.UserDefinedFields = $Udf
```

## Querying User Defined fields

You can only specify a single UDF in a query. This is an API limitation. We do not know of any workarounds. 

```powershell
# Using hashtable splatting
Get-AtwsInstalledProduct -UserDefinedField @{name='udf_name'; value='udf_value'}

# Using an UDF object
$Udf = New-Object Autotask.UserDefinedField
$Udf.name = 'udf_name'
$Udf.value = 'udf_value'
Get-AtwsInstalledProduct -UserDefinedField $Udf

# Equivalent -Filter expressions
Get-AtwsInstalledProduct -Filter {-udf 'udf_name' -eq 'udf_value'}
```

## Filtering on UDFs

Working with an array of name/value pairs is a lot of work in code. So to make things easier we expand all UDFs on returned queries. All UDFs are added as extra properties with a hashtag in front of the field name to mark it clearly as an UDF. It is necessary to separate UDFs from ordinary fields because you are entirely free to create an UDF with the same name as an ordinary field. Another reason is that UDF names are enirely free form. You may use spaces and special characters in their names, so we figured we'd better make it impossible to refer to UDFs in your code without using quotes or escape characters.

```powershell
# Genuine example from our own tenant. Note the horrid UDF name!
Get-AtwsInstalledProduct -UserDefinedField @{name='Klikkpris sort/hvitt (øre)';value=0}

#Faktureringsintervall                : 12
#Pris pr måned                        : 0.0000
#Klikkpris farge (øre)                : 0.0000
#Volum for farge                      : 10000.0000
#Klikkpris sort/hvitt (øre)           : 0.0000
#Volum for sort/hvitt                 : 10000.0000
#Tellerverk farge                     : 80000.0000
#Tellerverk sort/hvitt                : 110000.0000
#Avlesningsintervall                  : 6
#Kontraktsstatus                      : opprettet
#Kontraktstype                        : ingen
CreateDate                            : 20.02.2018 14:32:35
AccountID                             : 0000000
Active                                : True
[...] # OUTPUT ABREVIATED FOR CLARITY
```

To filter on more than one UDF you may use one for the query and then use a standard PowerShell Where clause for the rest. **IMPORTANT** ALL UDFS ARE RETURNED AS STRING FROM THE API! The solution: Use explicit typing in the where clause:

```powershell
# Genuine example from our own tenant. Note the horrid UDF name!
$ConfigurationItems = Get-AtwsInstalledProduct -UserDefinedField @{name='Klikkpris sort/hvitt (øre)';value=0} | 
  Where-Object {[int]$_.'#Tellerverk sort/hvitt' -gt 0}
```