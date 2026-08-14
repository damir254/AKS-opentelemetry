# syntax=docker/dockerfile:1.8


FROM python:3.13-slim-bookworm AS deps

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    VIRTUAL_ENV=/opt/venv \
    PATH="/opt/venv/bin:$PATH"

WORKDIR /app


RUN python -m venv "${VIRTUAL_ENV}"

COPY ./src/recommendation/requirements.txt ./


RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
      --no-cache-dir \
      --disable-pip-version-check \
      -r requirements.txt


FROM python:3.13-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    VIRTUAL_ENV=/opt/venv \
    PATH="/opt/venv/bin:$PATH"

WORKDIR /app


RUN groupadd --system app && \
    useradd --system --gid app --create-home app

COPY --from=deps /opt/venv /opt/venv


COPY ./src/recommendation/ ./


USER app

ENTRYPOINT ["python", "recommendation_server.py"]