import azure.functions as func
import json

app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)

def _cors_headers() -> dict:
    return {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET,POST,OPTIONS",
        "Access-Control-Allow-Headers": "Content-Type, Authorization",
    }

def _json_response(payload: dict, status_code: int = 200) -> func.HttpResponse:
    return func.HttpResponse(
        json.dumps(payload),
        mimetype="application/json",
        status_code=status_code,
        headers=_cors_headers(),
    )

@app.route(route="health", methods=["GET", "OPTIONS"])
def health(req: func.HttpRequest) -> func.HttpResponse:
    if req.method == "OPTIONS":
        return func.HttpResponse("", status_code=204, headers=_cors_headers())
    return _json_response({"status": "healthy"}, 200)

@app.route(route="training", methods=["GET", "POST", "OPTIONS"])
def training(req: func.HttpRequest) -> func.HttpResponse:
    if req.method == "OPTIONS":
        return func.HttpResponse("", status_code=204, headers=_cors_headers())
    if req.method == "GET":
        return _json_response({
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
        }, 200)
    elif req.method == "POST":
        try:
            req_body = req.get_json()
            return _json_response({
                "id": 3,
                "created": True,
                "training": req_body
            }, 201)
        except ValueError:
            return _json_response({"error": "Invalid JSON"}, 400)
