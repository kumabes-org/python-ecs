# python-ecs

## Criando virtual environment
```
py -3.12 -m venv .venv
python -m venv .venv
source .venv/Scripts/activate
pip install -r requirements.txt
```

## Configurar
- secrets.ROLE_TO_ASSUME
- secrets.EXECUTION_ROLE_ARN


## 1. Build da Imagem
```bash
docker build -t python-ecs:1.0.0 .
```

## 2. Rodar o Container
```bash
docker run --rm -p 8000:8000 python-ecs:1.0.0
```