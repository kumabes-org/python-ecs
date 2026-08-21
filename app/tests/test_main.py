import pytest
from fastapi.testclient import TestClient
from src.main import app

client = TestClient(app)


def test_health_check():
    """Valida o endpoint de health check usado pelo ALB do ECS."""
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "healthy"}


def test_read_root_default_env(monkeypatch: pytest.MonkeyPatch):
    """Valida o payload padrão da rota raiz."""
    monkeypatch.delenv("ENVIRONMENT", raising=False)
    response = client.get("/")
    assert response.status_code == 200
    
    payload = response.json()
    assert payload["message"] == "Hello, World from AWS ECS!"
    assert payload["environment"] == "development"
    assert payload["status"] == "UP"


def test_read_root_custom_env(monkeypatch: pytest.MonkeyPatch):
    """Valida a injeção de variável de ambiente (como injetado via ECS Task)."""
    monkeypatch.setenv("ENVIRONMENT", "production")
    response = client.get("/")
    assert response.status_code == 200
    
    payload = response.json()
    assert payload["environment"] == "production"