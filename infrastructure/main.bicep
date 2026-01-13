param location string = resourceGroup().location
param appName string = 'soccertrainer'
param environment string = 'dev'
@description('Azure AD Tenant ID (GUID).')
param tenantId string = ''
@description('Azure AD app (client) ID registered for Easy Auth.')
param aadClientId string = ''
@description('Client secret value for the Azure AD app. Used via app setting MICROSOFT_PROVIDER_AUTHENTICATION_SECRET.')
param aadClientSecret string = ''
@description('Require authentication for all requests (set true after frontend wiring).')
param requireAuthentication bool = false

var uniqueSuffix = uniqueString(resourceGroup().id)
var storageName = 'st${substring(uniqueSuffix, 0, 10)}'
var functionAppName = '${appName}-api-${environment}-${uniqueSuffix}'
var appServicePlanName = '${appName}-plan-${environment}'

// Storage Account
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Hot'
    minimumTlsVersion: 'TLS1_2'
  }
}

// App Service Plan for Functions (Consumption)
resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: appServicePlanName
  location: location
  kind: 'linux'
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {
    reserved: true
  }
}

// Function App
resource functionApp 'Microsoft.Web/sites@2021-03-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp,linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'python'
        }
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
        {
          name: 'MICROSOFT_PROVIDER_AUTHENTICATION_SECRET'
          value: aadClientSecret
        }
      ]
      linuxFxVersion: 'PYTHON|3.11'
      ftpsState: 'FtpsOnly'
    }
    httpsOnly: true
  }
}

// Enable Easy Auth (App Service Authentication)
resource authSettings 'Microsoft.Web/sites/config@2021-03-01' = {
  parent: functionApp
  name: 'authsettingsV2'
  properties: {
    platform: {
      enabled: true
    }
    globalValidation: {
      requireAuthentication: requireAuthentication
      unauthenticatedClientAction: requireAuthentication ? 'RedirectToLoginPage' : 'AllowAnonymous'
      redirectToProvider: requireAuthentication ? 'AzureActiveDirectory' : ''
    }
    httpSettings: {
      forwardProxyConvention: 'NoProxy'
    }
    login: {
      tokenStore: {
        enabled: true
        tokenRefreshExtensionHours: 72
      }
      preserveUrlFragmentForLoginProviders: false
      allowedExternalRedirectUrls: []
      cookieExpiration: {
        convention: 'FixedTime'
        timeInMinutes: 1440
      }
      nonce: {
        validateNonce: true
        nonceExpirationInterval: '00:05:00'
      }
    }
    identityProviders: {
      azureActiveDirectory: {
        enabled: true
        registration: {
          openIdIssuer: tenantId == '' ? '' : 'https://login.microsoftonline.com/${tenantId}/v2.0'
          clientId: aadClientId
          clientSecretSettingName: 'MICROSOFT_PROVIDER_AUTHENTICATION_SECRET'
        }
        validation: {
          jwtClaimChecks: {}
          allowedAudiences: [
            aadClientId
            aadClientId == '' ? '' : 'api://${aadClientId}'
          ]
          defaultAuthorizationPolicy: 'AllowAnonymousUsers'
        }
        login: {
          loginParameters: []
        }
      }
    }
    fileBasedConfiguration: {
      enabled: false
    }
  }
}

// CORS configuration for the function app
resource cors 'Microsoft.Web/sites/config@2021-03-01' = {
  parent: functionApp
  name: 'web'
  properties: {
    cors: {
      allowedOrigins: [
        'http://localhost:4200'
        'http://localhost:3000'
        'https://stpvkeip5una.z13.web.core.windows.net'
      ]
      supportCredentials: true
    }
  }
}

output storageAccountName string = storageAccount.name
output functionAppUrl string = 'https://${functionApp.properties.defaultHostName}'
output functionAppName string = functionApp.name
