
$swaggerUrl = 'https://webservices19.autotask.net/ATServicesRest/swagger/docs/v1'
$swagger = Invoke-RestMethod -Uri $swaggerUrl 

<#
namespace Autotask {
    public class ModelName {
        private object propertyNameField;
        public object propertyName {
            get {
                return this.propertyNameField;
            }
            set {
                this.propertyNameField = value;
            }
        }
    }
}
#>

$fileWrapper = @"
namespace Autotask {{
{0}
}}
"@

$classWrapper = @"

    public class {0} {{

{1}  

{2}
    }}

"@

$propertyListWrapper = @"
        private object {0}Field;

"@

$propertyMethodWrapper = @"
        public object {0} {{
            get {{
                return this.{0}Field;
            }}
            set {{
                this.{0}Field = value;
            }}
        }}

"@

$classes = ''
foreach ($model in $swagger.definitions.PSObject.Properties) {
    if ($model.Name -notlike '*`[*' -and $model.Value.properties.PSObject.Properties.count -gt 0) { 
        $propertyList = ''
        $methods = ''
        $modelname = $model.Name -replace 'Model', '' -replace '`2',''
        foreach ($property in $model.Value.properties.PSObject.Properties) {
            $propertyList += ($propertyListWrapper -F $property.Name)
            $methods += ($propertyMethodWrapper -F $property.Name)
        }
        $classes += ($classWrapper -F $modelName, $propertyList, $methods)
    }
}

$code = ($fileWrapper -F $classes)

Add-Type -TypeDefinition $code

$test = new-object Autotask.Company

$swagger.paths.

$test = 'https://webservices19.autotask.net/V1.0/Ticket/EntityInformation'
$response = Invoke-RestMethod -uri $test

