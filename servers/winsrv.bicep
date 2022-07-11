param location string
param hostname string
param subnetid string
param adminUsername string
param adminPassword string


resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: 'st${toLower(hostname)}${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
}

// resource publicIp 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
//   name: 'pip-${hostname}-${location}-PIP01'
//   location: location
//   sku: {
//     name: 'Basic'
//   }
//   properties: {
//     publicIPAllocationMethod: 'Dynamic'
//   }
// }

resource securityGroup 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-${hostname}-01'
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-allow-3389'
        properties: {
          priority: 1000
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '3389'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
  // dependsOn: [
  //   publicIp
  // ]
}

resource nic 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: 'nic-${hostname}-${location}-01'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig11'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          // publicIPAddress: {
          //   id: publicIp.id
          // }
          subnet: {
            id: subnetid
          }
        }
      }
    ]
  }
}

resource virtualMachine 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: 'vm-${hostname}-prod-${location}-01'
  location: location
  properties:{
    hardwareProfile: {
      vmSize: 'Standard_D2as_v5'
    }
    osProfile: {
      computerName: hostname
      adminPassword: adminPassword
      adminUsername: adminUsername
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-smalldisk-g2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
      // dataDisks: [
      //   {
      //     diskSizeGB: 128
      //     lun: 0
      //     createOption: 'Empty'
      //   }
      // ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}
