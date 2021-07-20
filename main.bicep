targetScope = 'subscription'

// create rg
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'alfran-spark-rg'
  location: deployment().location
}

// declare dscript module
module dScript 'deploymentscript.bicep' = {
  scope: rg
  name: 'dscript-deploy'
}
