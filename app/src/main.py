import os

from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI(
    title="Hello World Microservice",
    version="1.0.0"
)


class HelloResponse(BaseModel):
    message: str
    environment: str
    status: str


@app.get("/health", status_code=200)
def health_check() -> dict[str, str]:
    """Endpoint essencial para o ALB (Target Group) e ECS Health Checks."""
    return {"status": "healthy"}


@app.get("/", response_model=HelloResponse)
def read_root() -> HelloResponse:
    env = os.getenv("ENVIRONMENT", "development")
    return HelloResponse(
        message="Hello, World from AWS ECS!",
        environment=env,
        status="UP"
    )
