import azure.functions as func
import json

app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)

@app.route(route="health", methods=["GET"])
def health(req: func.HttpRequest) -> func.HttpResponse:
    return func.HttpResponse(
        json.dumps({"status": "healthy"}),
        mimetype="application/json",
        status_code=200
    )

@app.route(route="training", methods=["GET", "POST"])
def training(req: func.HttpRequest) -> func.HttpResponse:
    if req.method == "GET":
        return func.HttpResponse(
            json.dumps({
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
            }),
            mimetype="application/json",
            status_code=200
        )
    elif req.method == "POST":
        try:
            req_body = req.get_json()
            return func.HttpResponse(
                json.dumps({
                    "id": 3,
                    "created": True,
                    "training": req_body
                }),
                mimetype="application/json",
                status_code=201
            )
        except ValueError:
            return func.HttpResponse(
                json.dumps({"error": "Invalid JSON"}),
                mimetype="application/json",
                status_code=400
            )
