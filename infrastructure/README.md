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

After deployment, configure Azure AD authentication:

1. Go to Azure Portal → Function App → Authentication
2. Add Microsoft as an identity provider
3. Register the app in Azure AD
4. Configure Redirect URI: `https://<functionAppName>.azurewebsites.net/.auth/login/aad/callback`
5. Update the `clientId` in `main.bicep` with your Azure AD app ID

## Local Development

CORS is pre-configured to allow:
- `http://localhost:4200` (Angular dev server)
- `http://localhost:3000` (Alternative dev server)

To update, modify the `cors` resource in `main.bicep`.
