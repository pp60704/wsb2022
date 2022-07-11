param location string
param hubname string
param subnetbastionid string
param loganalyticsid string

resource publicIp 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name: 'pip-bastion-${hubname}-prod-${location}-01'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource BastionHost 'Microsoft.Network/bastionHosts@2022-01-01' = {
  name: 'bas-${hubname}-prod-${location}-01'
  location: location
  properties:{
    ipConfigurations:[
      {
        name: 'bastionIpconf'
        properties:{
          subnet:{
            id: subnetbastionid
          }
          publicIPAddress:{
            id: publicIp.id
          }
        }
      }
    ]
  }
}
