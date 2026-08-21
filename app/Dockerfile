# Estágio 1: Builder
FROM python:3.12-slim AS builder

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Estágio 2: Imagem final para execução
FROM python:3.12-slim

WORKDIR /app

# Cria usuário não-root para segurança
RUN useradd -m -u 1000 appuser

# Copia dependências do builder
COPY --from=builder /root/.local /home/appuser/.local
COPY src/ /app/src/

ENV PATH=/home/appuser/.local/bin:$PATH
ENV PYTHONUNBUFFERED=1
ENV ENVIRONMENT=production

USER appuser

EXPOSE 8000

# Executa Uvicorn escutando em todas as interfaces
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]