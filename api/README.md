# Soccer Trainer API

Python FastAPI backend running on Azure Functions (Consumption Plan).

## Development Setup

### Prerequisites

- Python 3.11+
- Azure Functions Core Tools
- Virtual environment

### Install Dependencies

```bash
cd api
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

### Run Locally

```bash
cd api
source .venv/bin/activate
uvicorn function_app:app --reload --port 7071
```

The API will be available at `http://localhost:7071`

## API Endpoints

### Health Check
- **GET** `/api/health` - Returns health status

### Training Sessions
- **GET** `/api/training` - List all training sessions
- **POST** `/api/training` - Create a new training session
- **GET** `/api/training/{id}` - Get specific training session
- **PUT** `/api/training/{id}` - Update training session
- **DELETE** `/api/training/{id}` - Delete training session

## Deployment

```bash
# Build and deploy to Azure
func azure functionapp publish <functionAppName>
```

## Testing

```bash
# Health check
curl http://localhost:7071/api/health

# Get trainings
curl http://localhost:7071/api/training

# Create training
curl -X POST http://localhost:7071/api/training \
  -H "Content-Type: application/json" \
  -d '{"name": "Shooting Drills", "duration": 30}'
```
