param hubname string
param location string
param subnetgwid string
param publicIPAddresses_vpngw_hub_PIP string = 'pip-vpng-${hubname}-prod-${location}-01'
param virtualNetworkGateways_vpngw_hub string = 'vpng-${hubname}-prod-${location}-01'
param loganalyticsid string

resource publicIPAddresses_vpngw_hub_PIP_resource 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name: publicIPAddresses_vpngw_hub_PIP
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: ''
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}


resource virtualNetworkGateways_vpngw_hub_resource 'Microsoft.Network/virtualNetworkGateways@2022-01-01' = {
  name: virtualNetworkGateways_vpngw_hub
  location: location
  properties: {
    enablePrivateIpAddress: false
    
    ipConfigurations: [
      {
        name: 'default'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_vpngw_hub_PIP_resource.id
          }
          subnet: {
            id: subnetgwid
          }
        }
      }
    ]
    sku: {
      name: 'VpnGw1'
      tier: 'VpnGw1'
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    enableBgp: false
    activeActive: false    
    vpnGatewayGeneration: 'Generation1'
  }
}

resource vpnGatewayAnalytics 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = {
  scope: virtualNetworkGateways_vpngw_hub_resource
  name: '${virtualNetworkGateways_vpngw_hub_resource.name}.lg'
  properties: {
    workspaceId: loganalyticsid
    logs: [
      {
        category: 'GatewayDiagnosticLog'
        enabled: true
      }
      {
        category: 'TunnelDiagnosticLog'
        enabled: true
      }
      {
        category: 'RouteDiagnosticLog'
        enabled: true
      }
      {
        category: 'IKEDiagnosticLog'
        enabled: true
      }
      {
        category: 'P2SDiagnosticLog'
        enabled: true
      }
    ]
  }
}
