@description('Location for all resources.')
param location string = resourceGroup().location

@description('Container image to deploy')
param containerImage string = 'ghcr.io/collinsrj/demodeployment:0.0.1-SNAPSHOT'

@description('Container registry server')
param containerRegistryServer string = 'ghcr.io'

@description('Name for the container app')
param containerAppName string = 'demo-deployment'

@description('Log Analytics workspace name')
param logAnalyticsWorkspaceName string = 'demo-logs-${uniqueString(resourceGroup().id)}'

// Log Analytics workspace for container app insights
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
    workspaceCapping: {
      dailyQuotaGb: '0.1' // Setting a low quota to minimize costs
    }
  }
}

// Container App Environment
resource containerAppEnvironment 'Microsoft.App/managedEnvironments@2022-10-01' = {
  name: '${containerAppName}-env'
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsWorkspace.properties.customerId
        sharedKey: logAnalyticsWorkspace.listKeys().primarySharedKey
      }
    }
    zoneRedundant: false // Setting to false to minimize costs
  }
}

// Container App
resource containerApp 'Microsoft.App/containerApps@2022-10-01' = {
  name: containerAppName
  location: location
  properties: {
    managedEnvironmentId: containerAppEnvironment.id
    configuration: {
      ingress: {
        external: true
        targetPort: 8080 // Adjust if your Spring Boot app uses a different port
        allowInsecure: false
      }
      secrets: []
    }
    template: {
      containers: [
        {
          name: containerAppName
          image: containerImage
          resources: {
            cpu: '0.25' // Low CPU allocation to minimize costs
            memory: '0.5Gi' // Low memory allocation to minimize costs
          }
          env: [
            {
              name: 'SPRING_PROFILES_ACTIVE'
              value: 'prod'
            }
          ]
        }
      ]
      scale: {
        minReplicas: 0 // Scale to zero when no traffic
        maxReplicas: 1 // Maximum of one instance
        rules: [
          {
            name: 'http-rule'
            http: {
              metadata: {
                concurrentRequests: '10'
              }
            }
          }
        ]
      }
    }
  }
}

output containerAppFQDN string = containerApp.properties.configuration.ingress.fqdn 
