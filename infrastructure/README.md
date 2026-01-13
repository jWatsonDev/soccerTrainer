# Soccer Trainer Infrastructure

This directory contains the Infrastructure-as-Code (IaC) for the Soccer Trainer application using Azure Bicep.

## Components

- **Azure Storage Account**: For storing training data and blobs
- **Azure Functions (Consumption Plan)**: Serverless Python FastAPI backend
- **Easy Auth**: Azure App Service Authentication with Azure AD integration
- **CORS Configuration**: Pre-configured for local development (localhost:4200 for Angular)

## Deployment

### Prerequisites

- Azure CLI installed
- Authenticated to Azure (`az login`)
- An Azure Resource Group created

### Deploy to Azure

```bash
# Set variables
RESOURCE_GROUP="soccertrainer-rg"
LOCATION="eastus"

# Create resource group (if not exists)
az group create --name $RESOURCE_GROUP --location $LOCATION

# Deploy infrastructure
az deployment group create \
  --resource-group $RESOURCE_GROUP \
  --template-file main.bicep \
  --parameters parameters.json \
  --parameters location=$LOCATION
```

### Get Deployment Outputs

```bash
az deployment group show \
  --resource-group $RESOURCE_GROUP \
  --name main \
  --query properties.outputs
```

## Configuring Easy Auth

Easy Auth is parameterized in `main.bicep`. Provide Azure AD values and redeploy:

1. Register Azure AD app (for the API):
  - Azure Portal → Azure Active Directory → App registrations → New registration
  - Name: `soccertrainer-api`
  - Supported account types: As desired
  - Redirect URI (Web): `https://<functionAppName>.azurewebsites.net/.auth/login/aad/callback`
  - Copy `Application (client) ID` and create a `Client secret`
  - Find your `Tenant ID` (Azure AD overview)

2. Update parameters in `parameters.json`:
  - `tenantId`: your Azure AD Tenant ID (GUID)
  - `aadClientId`: the API app's client ID
  - `aadClientSecret`: the client secret value
  - `requireAuthentication`: set `false` to allow anonymous during integration; set `true` when front-end auth is ready

3. Redeploy:

```bash
RESOURCE_GROUP="soccertrainer-rg"
LOCATION="eastus"

az group create --name $RESOURCE_GROUP --location $LOCATION

az deployment group create \
  --resource-group $RESOURCE_GROUP \
  --template-file main.bicep \
  --parameters @parameters.json \
  --parameters location=$LOCATION
```

4. Verify Authentication (Easy Auth):
  - Browse `https://<functionAppName>.azurewebsites.net/health`
  - If `requireAuthentication` is `true`, you should be redirected to Microsoft login
  - If `false`, endpoint remains publicly accessible

## Local Development

CORS is pre-configured to allow:
- `http://localhost:4200` (Angular dev server)
- `http://localhost:3000` (Alternative dev server)

To update, modify the `cors` resource in `main.bicep`.

### Notes
- Allowed audiences are set to your `aadClientId` and `api://<aadClientId>`.
- Client secret is stored in app setting `MICROSOFT_PROVIDER_AUTHENTICATION_SECRET`.
- Frontend MSAL setup lives in `ui/src/app/app.config.ts`. Replace `YOUR_AZURE_AD_CLIENT_ID` and configure scopes.
