# Getting Started - Soccer Trainer App

## Current Status ✅

- ✅ Angular 21 UI running on `localhost:4200`
- ✅ Python FastAPI backend running on `localhost:7071`
- ✅ Training sessions API working
- ✅ UI successfully calling backend
- ✅ CORS configured
- ✅ Azure infrastructure templates ready (Bicep)
- ⏳ Authentication (infrastructure ready, implementation pending)

## Running the App

### 1. Start the Backend (Terminal 1)

```bash
cd api
source .venv/bin/activate
uvicorn function_app:app --reload --port 7071
```

You should see:
```
INFO:     Uvicorn running on http://127.0.0.1:7071
INFO:     Application startup complete.
```

### 2. Start the Frontend (Terminal 2)

```bash
cd ui
npm start
```

You should see:
```
✔ Compiled successfully.
➜  Local:   http://localhost:4200/
```

### 3. Open Browser

Navigate to: **http://localhost:4200**

You should see:
- "Soccer Trainer" heading
- Training sessions list with:
  - Dribbling Drills (30 min, beginner)
  - Passing Accuracy (45 min, intermediate)
- Refresh button

## Troubleshooting

### API Not Starting
```bash
# Make sure venv is activated
source api/.venv/bin/activate

# Reinstall dependencies if needed
pip install -r api/requirements.txt
```

### UI Not Starting
```bash
# Clear Angular cache
rm -rf ui/.angular

# Reinstall dependencies if needed
cd ui
rm -rf node_modules package-lock.json
npm install
```

### Port Already in Use
```bash
# Kill process on port 7071 (API)
lsof -ti:7071 | xargs kill -9

# Kill process on port 4200 (UI)
lsof -ti:4200 | xargs kill -9
```

### Data Not Loading in UI
- Check browser console (F12) for errors
- Verify API is running: http://localhost:7071/api/training
- Check CORS configuration in `api/function_app.py`

## Next Steps

1. **Add Authentication** (Azure AD + MSAL)
   - See `auth/README.md` for setup
   - MSAL packages already installed

2. **Deploy to Azure**
   - See `infrastructure/README.md`
   - Bicep templates ready to deploy

3. **Add More Features**
   - Create/Edit/Delete training sessions
   - User profiles
   - Training history
   - Progress tracking

## Project Structure

```
soccerTrainer/
├── api/              # Python FastAPI backend
├── ui/               # Angular 21 frontend
├── infrastructure/   # Azure Bicep templates
└── auth/             # Auth configuration docs
```

## Tech Stack

- **Frontend:** Angular 21, TypeScript, RxJS
- **Backend:** Python 3.11, FastAPI, Uvicorn
- **Cloud:** Azure Functions, Azure Storage, Azure AD
- **IaC:** Bicep

## Questions?

Check the main [readme.md](./readme.md) for comprehensive documentation.

---
**Last Updated:** January 9, 2026
