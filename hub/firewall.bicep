param location string
param hubname string
param subnetafwid string
param loganalyticsid string

resource pipFirewall 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: 'pip-afw-${hubname}-prod-${location}-01'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource firewall 'Microsoft.Network/azureFirewalls@2020-05-01' = {
  name: 'afw-${hubname}-prod-${location}-01'
  location: location
  properties: {
    sku: {
      name: 'AZFW_VNet'
      tier: 'Standard'
    }
    threatIntelMode: 'Alert'
    ipConfigurations: [
      {
        name: 'afwipconfig'
        properties: {
          publicIPAddress: {
            id: pipFirewall.id
          }
          subnet: {
            id: subnetafwid
          }
        }
      }
    ]
  }
}
