targetScope = 'subscription'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'alfran-spark-rg'
  location: deployment().location
}

module dScript 'deploymentscript.bicep' = {
  scope: rg
  name: 'dscript-deploy'
  params: {
    passphrase: 'alfran'
  }
}

// use getSecret() to get existing secret
resource kv 'Microsoft.KeyVault/vaults@2021-04-01-preview' existing = {
  name: 'adotfrank-kv'
  scope: resourceGroup('brittle-hollow')
}

module aks 'aks.bicep' = {
  scope: rg
  name: 'aks-deploy'
  params: {
    dnsPrefix: 'alfran'
    linuxAdminUsername: 'alfran'
    servicePrincipalClientId: '15ee966e-f2cd-4016-8181-4671f1d95c8e'
    servicePrincipalClientSecret: kv.getSecret('alfranTestingSpnPassword')
    sshRSAPublicKey: dScript.outputs.sshkey
  }
}
