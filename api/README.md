# Soccer Trainer API

Python backend with two local run modes:
- Azure Functions (HTTP triggers in `function_app.py`)
- FastAPI (ASGI app in `api_app.py`)

## Development Setup

### Prerequisites

- Python 3.11+
- Azure Functions Core Tools (for Functions mode)
- Virtual environment

### Install Dependencies

```bash
cd api
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

## Run Locally

### Option A: Azure Functions (port 7071)

```bash
cd api
source .venv/bin/activate
func start
```

With `routePrefix` set to empty in host.json, endpoints are:
- http://localhost:7071/health
- http://localhost:7071/training

### Option B: FastAPI via Uvicorn (port 8000)

```bash
cd api
source .venv/bin/activate
uvicorn api_app:app --reload --port 8000
```

Endpoints:
- http://localhost:8000/api/health
- http://localhost:8000/api/training

## Implemented Endpoints

### Health Check
- **GET** `/health` (Functions) / **GET** `/api/health` (FastAPI)

### Training Sessions
- **GET** `/training` (Functions) / **GET** `/api/training` (FastAPI) — list sessions
- **POST** `/training` (Functions) / **POST** `/api/training` (FastAPI) — create session

> Note: `/{id}` GET/PUT/DELETE are not yet implemented.

## Testing

### Functions mode

```bash
# Health check
curl http://localhost:7071/health

# Get trainings
curl http://localhost:7071/training

# Create training
curl -X POST http://localhost:7071/training \
  -H "Content-Type: application/json" \
  -d '{"name": "Shooting Drills", "duration": 30}'
```

### FastAPI mode

```bash
# Health check
curl http://localhost:8000/api/health

# Get trainings
curl http://localhost:8000/api/training

# Create training
curl -X POST http://localhost:8000/api/training \
  -H "Content-Type: application/json" \
  -d '{"name": "Shooting Drills", "duration": 30}'
```

## Deployment (Azure Functions)

```bash
# Publish to Azure
func azure functionapp publish <functionAppName>
```
