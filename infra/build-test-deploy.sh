# 1. Executar os testes unitários
pytest -v tests/

# 2. Build da imagem local
docker build -t hello-world-python:latest .

# 3. Testar container localmente
docker run -p 8000:8000 -e ENVIRONMENT=local hello-world-python:latest

# 4. Registrar nova Task Definition na AWS
aws ecs register-task-definition --cli-input-json file://task-definition.json

# 5. Atualizar o serviço ECS (Fargate)
aws ecs update-service \
  --cluster my-ecs-cluster \
  --service hello-world-service \
  --task-definition hello-world-task \
  --force-new-deployment