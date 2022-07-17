param vnetname string
param location string
param virtualNetworks_vnet_subnets string = 'vnet-${vnetname}-prod-${location}-01'

resource virtualNetworks_vnetsrv_net0_resource 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: virtualNetworks_vnet_subnets
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.18.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-srv01'
        properties: {
          addressPrefix: '172.18.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}
resource virtualNetworks_vnet_name_subnet01 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: virtualNetworks_vnetsrv_net0_resource
  name: 'snet-srv01'
  properties: {
    addressPrefix: '172.18.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

output subnetid string = virtualNetworks_vnet_name_subnet01.id
