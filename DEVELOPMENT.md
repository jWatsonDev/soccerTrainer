# Development Setup Guide

## Initial Setup (First Time)

### 1. System Requirements

- **macOS/Linux/Windows** with terminal
- **Node.js** 18.x+ and npm
- **Python** 3.11+
- **Azure CLI** (`brew install azure-cli` on macOS)
- **Azure Functions Core Tools** (`npm install -g azure-functions-core-tools@4`)
- **Git**

### 2. Clone Repository

```bash
cd /Users/watsonjamd/src/2026/soccerTrainer
```

### 3. Install Dependencies

#### Backend (Python API)

```bash
cd api

# Create virtual environment
python3 -m venv .venv

# Activate virtual environment
source .venv/bin/activate  # macOS/Linux
# OR
.venv\Scripts\activate     # Windows

# Install dependencies
pip install -r requirements.txt
```

#### Frontend (Angular UI)

```bash
cd ../ui

# Install npm dependencies
npm install

# (Optional) Install Angular CLI globally
npm install -g @angular/cli@21
```

## Running Locally

### Terminal Setup (Recommended)

Open 3 terminals:

**Terminal 1: API Server**
```bash
cd /Users/watsonjamd/src/2026/soccerTrainer/api
source .venv/bin/activate
func start
```
✅ Wait for: "Listening on http://localhost:7071"

**Terminal 2: Angular Dev Server**
```bash
cd /Users/watsonjamd/src/2026/soccerTrainer/ui
npm start
```
✅ Wait for: "✔ Compiled successfully"  
🌐 Opens automatically at http://localhost:4200

**Terminal 3: Optional - Git/Admin Tasks**
```bash
cd /Users/watsonjamd/src/2026/soccerTrainer
```

### Testing the Setup

1. Open browser to **http://localhost:4200**
2. You should see "Soccer Trainer" with training sessions
3. Click "Refresh" to test API connection
4. Verify no CORS errors in browser console

## Project Commands

### Backend (Python)

```bash
# Activate environment
source api/.venv/bin/activate

# Start development server
cd api && func start

# Run tests (once added)
cd api && pytest

# Format code
cd api && black function_app.py

# Lint code
cd api && pylint function_app.py
```

### Frontend (Angular)

```bash
cd ui

# Start development server
npm start

# Build for production
npm run build

# Run unit tests
npm test

# Run e2e tests
npm run e2e

# Lint code
npm run lint
```

## Azure Deployment Workflow

### 1. Authenticate with Azure

```bash
az login
# Browser will open for authentication
```

### 2. Create Resource Group

```bash
az group create \
  --name soccertrainer-rg \
  --location eastus
```

### 3. Deploy Infrastructure

```bash
cd infrastructure

az deployment group create \
  --resource-group soccertrainer-rg \
  --template-file main.bicep \
  --parameters parameters.json
```

### 4. Get Function App Name

```bash
az deployment group show \
  --resource-group soccertrainer-rg \
  --name main \
  --query properties.outputs.functionAppName.value -o tsv
```

### 5. Deploy Function App

```bash
cd ../api

# Using the function app name from step 4
func azure functionapp publish <functionAppName>

# Example:
# func azure functionapp publish soccertrainer-api-dev-abc123
```

### 6. Deploy Frontend (Optional - Azure Static Web Apps)

```bash
cd ../ui

ng build --configuration production

# Deploy using Azure CLI or GitHub Actions
```

## Useful Commands

### Azure CLI

```bash
# List function apps
az functionapp list --resource-group soccertrainer-rg

# View function app logs
az functionapp log tail \
  --name <functionAppName> \
  --resource-group soccertrainer-rg

# View function app settings
az functionapp config appsettings list \
  --name <functionAppName> \
  --resource-group soccertrainer-rg

# Delete resource group (WARNING: Deletes everything)
az group delete --name soccertrainer-rg
```

### Azure Functions Core Tools

```bash
# Initialize new function
func new --name <FunctionName> --template "HTTP trigger"

# List extensions
func extensions list

# Install extensions
func extensions install
```

### npm/Angular

```bash
# Angular CLI help
ng help

# Generate component
ng generate component <ComponentName>

# Generate service
ng generate service <ServiceName>

# Analyze bundle size
ng build --stats-json
ng bundle-report
```

## Debugging

### Angular/Browser DevTools

1. Open browser DevTools: `F12` or `Cmd+Option+I`
2. **Console tab:** Check for errors
3. **Network tab:** Verify API requests to `http://localhost:7071`
4. **Sources tab:** Set breakpoints in TypeScript code

### Python Debugger

Add to `api/function_app.py`:
```python
import pdb
pdb.set_trace()  # Execution pauses here
```

Or use VS Code debugger:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Python: Current File",
      "type": "python",
      "request": "launch",
      "program": "${file}",
      "console": "integratedTerminal"
    }
  ]
}
```

### Azure Functions Emulator

```bash
# Start with detailed logging
func start --verbose

# Enable debug logging
func start --debug
```

## Common Issues

### Issue: "Port 4200 already in use"
```bash
# Kill process on port 4200
lsof -ti:4200 | xargs kill -9

# Or use different port
ng serve --port 4300
```

### Issue: "CORS error when calling API"
- Ensure API is running (`func start`)
- Check CORS config in `infrastructure/main.bicep`
- Verify API URL in `ui/src/app/app.config.ts`

### Issue: "venv activation not working"
```bash
# Use full path
source /Users/watsonjamd/src/2026/soccerTrainer/api/.venv/bin/activate

# Or use . instead of source
. api/.venv/bin/activate
```

### Issue: "npm install fails"
```bash
# Clear npm cache
npm cache clean --force

# Delete node_modules and package-lock.json
rm -rf ui/node_modules ui/package-lock.json

# Reinstall
cd ui && npm install
```

## IDE Setup

### VS Code Extensions (Recommended)

```bash
code --install-extension ms-python.python
code --install-extension Angular.ng-template
code --install-extension ms-azuretools.vscode-azurefunctions
code --install-extension ms-azuretools.vscode-bicep
code --install-extension ms-vscode.azure-account
code --install-extension Debugger.Debugger-for-Chrome
```

### Workspace Settings (`.vscode/settings.json`)

```json
{
  "python.defaultInterpreterPath": "${workspaceFolder}/api/.venv/bin/python",
  "python.linting.enabled": true,
  "python.linting.pylintEnabled": true,
  "editor.formatOnSave": true,
  "[python]": {
    "editor.defaultFormatter": "ms-python.python",
    "editor.formatOnSave": true
  },
  "[typescript]": {
    "editor.defaultFormatter": "ms.vscode-typescript-and-js-language-features",
    "editor.formatOnSave": true
  }
}
```

## Git Workflow

```bash
# Check status
git status

# Create feature branch
git checkout -b feature/new-feature

# Stage changes
git add .

# Commit
git commit -m "feat: add new feature"

# Push to remote
git push origin feature/new-feature

# Create Pull Request on GitHub
```

## Performance Tips

1. **Frontend:**
   - Use `ng build --configuration production` for smaller bundle
   - Enable Angular's OnPush change detection
   - Lazy load routes

2. **Backend:**
   - Use async/await for I/O operations
   - Cache frequently accessed data
   - Monitor cold start times in Application Insights

3. **Azure:**
   - Use Application Insights for monitoring
   - Set up alerts for errors
   - Review consumption plan costs regularly

## Next Steps

1. ✅ Local development working
2. 📝 Implement training session features
3. 🔐 Complete Easy Auth setup
4. ☁️ Deploy to Azure
5. 🚀 Add monitoring and alerts
6. 📊 Set up CI/CD pipeline

---

For more details, see [readme.md](./readme.md)
