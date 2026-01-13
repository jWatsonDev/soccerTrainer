# Soccer Trainer Application

A comprehensive soccer training app built with modern cloud-native technologies: **Azure Functions**, **Azure Storage**, **Angular UI**, and **Easy Auth**.

## 🏗️ Architecture

```
┌─────────────────────┐
│   Angular UI        │  (localhost:4200)
│   (Web Browser)     │
└──────────┬──────────┘
           │ HTTPS
           ▼
┌─────────────────────┐
│  Azure Functions    │  (Python FastAPI)
│  (Consumption Plan) │  Easy Auth Enabled
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Azure Storage      │
│  (Blob & Tables)    │
└─────────────────────┘
```

## 📋 Tech Stack

| Component | Technology | Version |
|-----------|-----------|---------|
| **UI** | Angular | 21.0.0 |
| **Backend** | Python FastAPI | 0.104.0 |
| **Runtime** | Azure Functions | Python 3.11 |
| **Infrastructure** | Bicep | Latest |
| **Authentication** | Azure Easy Auth (AAD) | v2 |
| **Storage** | Azure Storage (LRS) | v2 |

## 🚀 Quick Start

### Prerequisites

- **Node.js** 18+ and npm
- **Python** 3.11+

### 1. Install Dependencies

```bash
# Backend
cd api
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# Frontend
cd ../ui
npm install
```

### 2. Run Locally (Development)

**Terminal 1 - Start the API:**
```bash
cd api
source .venv/bin/activate
uvicorn function_app:app --reload --port 7071
```
API runs at: `http://localhost:7071`

**Terminal 2 - Start the Angular UI:**
```bash
cd ui
npm start
```
UI runs at: `http://localhost:4200`

### 3. Test

Open browser to `http://localhost:4200` - you should see training sessions loaded from the API.

## 📁 Project Structure

```
soccerTrainer/
├── ui/                          # Angular Frontend
│   ├── src/
│   │   ├── app/
│   │   │   ├── app.ts          # Main component (API integration)
│   │   │   ├── app.config.ts   # MSAL auth config
│   │   │   └── app.html        # Template
│   │   └── main.ts
│   └── package.json
│
├── api/                         # Python FastAPI Backend
│   ├── function_app.py          # Main FastAPI app
│   ├── requirements.txt
│   ├── host.json               # Functions runtime config
│   └── HttpTrigger/
│       └── function.json       # HTTP trigger binding
│
├── infrastructure/              # Infrastructure-as-Code (Bicep)
│   ├── main.bicep              # Resource definitions
│   └── parameters.json         # Deployment parameters
│
├── auth/                        # Authentication Configuration
│   ├── README.md
│   └── msal-config.json        # MSAL browser config
│
└── readme.md                    # This file
```

## 🔐 Authentication (MSAL with Azure AD)

### ✅ Implementation Status

Authentication is **fully configured** with:
- ✅ Azure AD App Registration (`soccertrainer-api`)
- ✅ MSAL Angular integration for user login
- ✅ Support for Microsoft organizational and personal accounts
- ✅ Token-based API access with MSAL interceptor

### How It Works

1. User clicks login → redirected to Microsoft login page
2. After authentication → token stored in browser localStorage
3. MSAL interceptor automatically adds Bearer token to API requests
4. API accepts requests with valid tokens

### Configuration

**For Local Development:**
The MSAL authority is set to `/common` to allow both org and personal accounts:
```typescript
authority: 'https://login.microsoftonline.com/common'
```

**For Production (Tenant-Specific):**
Change to your tenant ID for organization-only access:
```typescript
authority: 'https://login.microsoftonline.com/{tenant-id}'
```

### Deployment Details

- **App Registration ID:** `5d444d98-ede8-4d3c-8e52-b8c000f9f8a2`
- **Scope:** `user.read`
- **Redirect URIs:** 
  - SPA: `https://stpvkeip5una.z13.web.core.windows.net`, `http://localhost:4200`
  - Web: `https://soccertrainer-api-dev-pvkeip5unaxek.azurewebsites.net/.auth/login/aad/callback`

### Base URL (Local)
```
http://localhost:7071/api
```

### Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/` | API info |
| `GET` | `/health` | Health check |
| `GET` | `/training` | List all training sessions |
| `POST` | `/training` | Create new training session |
| `PUT` | `/training/{id}` | Update training session |
| `DELETE` | `/training/{id}` | Delete training session |

### Example Requests

```bash
# Get health status
curl http://localhost:7071/api/health

# Get all trainings
curl http://localhost:7071/api/training

# Create training
curl -X POST http://localhost:7071/api/training \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Shooting Drills",
    "duration": 30,
    "difficulty": "intermediate"
  }'
```

## ☁️ Azure Deployment

### ✅ Production Deployment (LIVE)

The application is **live in production** at:
- **UI:** https://stpvkeip5una.z13.web.core.windows.net
- **API:** https://soccertrainer-api-dev-pvkeip5unaxek.azurewebsites.net

### Deployed Resources

| Resource | Name | Type |
|----------|------|------|
| **Function App** | soccertrainer-api-dev-pvkeip5unaxek | Azure Functions (Consumption) |
| **Storage Account** | stpvkeip5una | Azure Storage (Blob + Static Web) |
| **App Service Plan** | soccertrainer-plan-dev | Linux Consumption Plan |
| **Resource Group** | soccertrainer-rg | eastus |

### How to Deploy Updates

**1. Backend (API):**
```bash
cd api
func azure functionapp publish soccertrainer-api-dev-pvkeip5unaxek
```

**2. Frontend (UI):**
```bash
cd ui
npm run build
az storage blob upload-batch \
  --account-name stpvkeip5una \
  --destination '$web' \
  --source dist/ui/browser \
  --overwrite
```

### Infrastructure Deployment

To redeploy/modify infrastructure:

```bash
cd infrastructure

# Validate Bicep template
az bicep validate --file main.bicep

# Deploy changes
az deployment group create \
  --resource-group soccertrainer-rg \
  --template-file main.bicep \
  --parameters parameters.json \
  --parameters location=eastus
```

### Prerequisites
- Azure Resource Group: `az group create --name soccertrainer-rg --location eastus`
- Azure CLI: `az login`

See `infrastructure/README.md` for detailed infrastructure documentation.🛠️ Development Workflow

### Local Development
1. Start the API (`func start`)
2. Start Angular (`npm start`)
3. Edit code - changes auto-reload
4. Test in browser at `http://localhost:4200`

### Code Changes

**Backend Changes:**
- Edit `api/function_app.py`
- Changes auto-reload with `func start` (or restart if needed)

**Frontend Changes:**
- Edit files in `ui/src/app/`
- Angular development server auto-reloads

### Git Workflow

```bash
# Create feature branch
git checkout -b feature/new-training-session

# Make changes and commit
git add .
git commit -m "Add new training session type"

# Push and create PR
git push origin feature/new-training-session
```

## 🧪 Testing

### API Testing
```bash
# Run Python tests (once added)
pytest api/

# Manual testing with curl or Postman
```

### Frontend Testing
```bash
cd ui
npm test  # Run unit tests
ng e2e    # Run e2e tests
```

## 📈 Scaling Considerations

### Azure Functions (Consumption Plan)
- **Auto-scales** based on demand
- Billed per execution
- Default timeout: 5 minutes
- Edit in `api/host.json`: `functionTimeout`

### Storage Account
- Current: **Standard LRS** (Locally Redundant Storage)
- For production: Consider **Standard GRS** (Geo-Redundant)

### Database (Future)
- For training data persistence, add:
  - Azure Cosmos DB, or
  - Azure SQL Database, or
  - Table Storage (built-in)

## 🔒 Security Best Practices

- ✅ HTTPS-only (enforced in Bicep)
- ✅ Easy Auth (Azure AD integration)
- ✅ TLS 1.2 minimum
- ✅ CORS configured for localhost only
- ⚠️ **TODO:** Update CORS origins for production
- ⚠️ **TODO:** Store secrets in Azure Key Vault
- ⚠️ **TODO:** Implement request signing/throttling

## 📝 Environment Variables

### Local Development (.env)

Create `.env` files for configuration:

**ui/.env:**
```
NG_APP_API_URL=http://localhost:7071/api
NG_APP_AZURE_AD_CLIENT_ID=<your-client-id>
```

**api/.env:**
```
AZURE_STORAGE_ACCOUNT_NAME=<storage-account>
AZURE_STORAGE_ACCOUNT_KEY=<storage-key>
```

## 🐛 Troubleshooting

### CORS Issues
- **Problem:** "Cross-Origin Request Blocked"
- **Solution:** Update `cors` resource in `infrastructure/main.bicep`

### API Not Responding
- **Check:** Is `func start` running? (Should see: "Listening on...")
- **Check:** API URL in `app.config.ts` matches function app URL

### Authentication Errors
- **Check:** Azure AD app ID is correct in `app.config.ts`
- **Check:** Redirect URI is configured in Azure AD
- **Check:** Client secret is set in Function App settings

### Build Errors
- **npm install fails:** Delete `node_modules`, `package-lock.json`, then reinstall
- **Python venv fails:** Use `python3` instead of `python`
- **Bicep validation:** `az bicep validate --file main.bicep`

## 📚 Resources

- [Azure Functions Python Developer Guide](https://learn.microsoft.com/en-us/azure/azure-functions/functions-reference-python)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Angular 21 Documentation](https://angular.io/docs)
- [Azure Bicep Documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
- [Easy Auth Documentation](https://learn.microsoft.com/en-us/azure/app-service/overview-authentication-authorization)
- [MSAL Angular Guide](https://github.com/AzureAD/microsoft-authentication-library-for-js/tree/dev/lib/msal-angular)

## 📄 License

MIT

## 👥 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📞 Support

For issues or questions:
1. Check [Troubleshooting](#-troubleshooting)
2. Review resource documentation links
3. Open an issue on GitHub

---

**Last Updated:** January 2026  
**Maintained by:** Soccer Trainer Team
