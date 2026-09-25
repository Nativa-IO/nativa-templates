# PROD: imagen inmutable con el venv horneado. Solo la usa el deploy;
# las sesiones corren sobre la imagen del runner (ver docker-compose.dev.yml).
#
# bookworm, misma libc que el runner: un uv.lock resuelto en la sesión
# instala las mismas ruedas aquí.
FROM python:3.12-slim-bookworm

WORKDIR /app

COPY --from=ghcr.io/astral-sh/uv:0.7.12 /uv /uvx /bin/

# Solo el lockfile primero: la capa de dependencias no se invalida al tocar
# código. --no-dev: sin pytest ni herramientas de desarrollo en producción.
COPY pyproject.toml uv.lock ./
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev --no-install-project

COPY . .
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev

ENV PATH="/app/.venv/bin:${PATH}"

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
