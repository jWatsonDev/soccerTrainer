import azure.functions as func
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import json

# Create FastAPI app
app = FastAPI(title="Soccer Trainer API", version="0.1.0")

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins for development
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {"message": "Welcome to Soccer Trainer API", "version": "0.1.0"}

@app.get("/api/health")
async def health():
    return {"status": "healthy"}

@app.get("/api/training")
async def get_trainings():
    """Get all training sessions"""
    return {
        "trainings": [
            {
                "id": 1,
                "name": "Dribbling Drills",
                "duration": 30,
                "difficulty": "beginner"
            },
            {
                "id": 2,
                "name": "Passing Accuracy",
                "duration": 45,
                "difficulty": "intermediate"
            }
        ]
    }

@app.post("/api/training")
async def create_training(training: dict):
    """Create a new training session"""
    return {
        "id": 3,
        "created": True,
        "training": training
    }

# Azure Functions entry point
async def main(req: func.HttpRequest, context: func.Context) -> func.HttpResponse:
    """Azure Functions HTTP trigger"""
    return func.AsgiRequest(app).handle(req)
