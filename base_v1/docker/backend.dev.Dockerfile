# DEV: deps horneadas en la imagen, código por bind-mount (uvicorn --reload).
FROM python:3.12-slim

WORKDIR /app

# Solo el pyproject: instala dependencias (incluye extras de dev para que la
# sesión pueda correr pytest) sin hornear el código, que llega por volumen.
COPY pyproject.toml .
RUN pip install --no-cache-dir .[dev]

CMD ["uvicorn", "app.main:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]
