param passphrase string

resource stg 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: 'alfran${uniqueString(resourceGroup().id, 'alfran')}'
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource dScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'alfrandscript'
  location: resourceGroup().location
  kind: 'AzureCLI'
  properties: {
    azCliVersion: '2.26.0'
    retentionInterval: 'P1D'
    storageAccountSettings: {
      storageAccountName: stg.name
      storageAccountKey: stg.listKeys().keys[0].value
    }
    scriptContent: loadTextContent('keygen.sh')
    arguments: passphrase
  }
}

output sshkey string = dScript.properties.outputs.keyinfo.publicKey
