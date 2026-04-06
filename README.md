# LMS Demo (Dockerized)

This project is set up to run with Docker so you do not need to install Ruby, Node, PostgreSQL, or Redis on your host machine.

## Prerequisites

- Docker Engine or Docker Desktop
- Docker Compose (v2)

## Quick Start

Optional: create a local env file you can customize:

```bash
cp .env.example .env
```

Use project-root `.env` (not `config/.env`) for Docker Compose variables.

1. Build and start everything:

```bash
docker compose up --build
```

2. Open the app:

- http://localhost:3000

The `web` container entrypoint automatically:

- seeds gem/node dependency volumes from image cache (offline at runtime)
- retries `rails db:prepare` until Postgres is reachable
- removes stale server PID files

## Useful Commands

Run commands inside the Rails container:

```bash
docker compose exec web bin/rails c
docker compose exec web bin/rails db:migrate
docker compose exec web bin/rails test
```

Stop services:

```bash
docker compose down
```

Reset everything (including database volume):

```bash
docker compose down -v
docker compose up --build
```

If you change `Gemfile`, `Gemfile.lock`, `package.json`, or lock files, rebuild:

```bash
docker compose build web
docker compose up
```

## Environment Overrides

You can override defaults through shell env vars or a `.env` file:

- `APP_PORT` (default: `3000`)
- `DB_HOST` (default: `db`)
- `DB_PORT` (default: `5432`)
- `DB_USERNAME` (default: `postgres`)
- `DB_PASSWORD` (default: `postgres`)
- `DB_NAME` (default: `LMS_development`)
- `DB_TEST_NAME` (default: `LMS_test`)
- `DB_CONNECT_TIMEOUT` (default: `5`)
- `REDIS_URL` (default: `redis://redis:6379/1`)

## Notes

- Source code is bind-mounted (`.:/rails`) for live development.
- Gems and JS dependencies are persisted in Docker volumes and initialized from the image.

## Troubleshooting

If `docker compose down` fails with `permission denied` while stopping a container:

```bash
docker compose kill
docker rm -f lms-demo-web-1
docker compose down -v
```

If it still fails, restart Docker daemon/desktop and retry `docker compose down -v`.

If old containers remain stuck with `could not kill container: permission denied`, run this project with a new compose project name and a different app port:

```bash
COMPOSE_PROJECT_NAME=lms_demo_fresh APP_PORT=3001 docker compose up --build
```

Then open `http://localhost:3001`.
