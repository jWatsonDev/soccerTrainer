# Azure Easy Auth Configuration

This directory contains configuration for Easy Auth (App Service Authentication) in the Soccer Trainer application.

## Overview

Easy Auth provides built-in authentication and authorization without requiring code changes. The application is configured with Azure AD as the identity provider.

## Setup Steps

### 1. Create Azure AD App Registration

```bash
# Using Azure CLI
az ad app create --display-name "Soccer Trainer API"
```

Record the **Application (client) ID** - you'll need this in the Bicep template.

### 2. Update Bicep Configuration

Edit `infrastructure/main.bicep` and update the `identityProviders.azureActiveDirectory` section:

```bicep
clientId: '<your-app-id>'  // From step 1
clientSecretSettingName: 'MICROSOFT_PROVIDER_AUTHENTICATION_SECRET'
openIdIssuer: 'https://login.microsoftonline.com/<tenant-id>/v2.0'
```

### 3. Configure Redirect URI

In Azure Portal:
1. Go to Azure AD → App registrations
2. Find "Soccer Trainer API"
3. Go to Authentication
4. Add Redirect URI: `https://<functionAppName>.azurewebsites.net/.auth/login/aad/callback`

### 4. Create Client Secret

1. In the app registration, go to Certificates & secrets
2. Create a new client secret
3. In Azure Portal, add this as an application setting on your Function App:
   - Name: `MICROSOFT_PROVIDER_AUTHENTICATION_SECRET`
   - Value: The client secret value

## Authentication in Angular UI

The Angular app should use `@azure/msal-browser` to handle authentication.

### Setup MSAL in Angular

```typescript
import { MsalModule, MsalBrowserConfiguration, MsalInterceptor } from '@azure/msal-angular';
import { PublicClientApplication } from '@azure/msal-browser';

const msalConfig = {
  auth: {
    clientId: 'your-client-id',
    authority: 'https://login.microsoftonline.com/common',
    redirectUri: 'http://localhost:4200'
  }
};
```

### Making Authenticated API Calls

Include the access token in requests to the Function App:

```typescript
import { HttpClient, HTTP_INTERCEPTORS } from '@angular/common/http';
import { MsalInterceptor } from '@azure/msal-angular';

// Configure HTTP_INTERCEPTORS to include MsalInterceptor
// This automatically adds Authorization headers to requests
```

## Scopes

For your Python API, define the scope in Azure AD and request it in your Angular app:

```typescript
scopes: ['api://<your-client-id>/access_as_user']
```

## Testing Easy Auth Locally

When testing locally, you can disable Easy Auth or use a different authentication method. The `function_app.py` can be updated to handle local vs. production authentication.

## References

- [Easy Auth Documentation](https://learn.microsoft.com/en-us/azure/app-service/overview-authentication-authorization)
- [Azure AD Integration](https://learn.microsoft.com/en-us/azure/app-service/configure-authentication-provider-aad)
- [MSAL Angular Documentation](https://github.com/AzureAD/microsoft-authentication-library-for-js)
