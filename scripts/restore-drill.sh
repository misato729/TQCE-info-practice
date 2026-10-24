#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
frontend=$(docker compose ps -q frontend)
if [[ -z "$frontend" ]]; then
  printf '%s\n' 'Start the local Nuxt frontend/API and nuxt-db first.' >&2
  exit 1
fi

# The Node development image includes matching PostgreSQL 16 tools. The drill
# ignores the application's database name and creates two disposable databases.
# Never load a backup into the normal development or production database.
docker exec --workdir /workspace/frontend \
  -e APP_ENV=test -e DATABASE_URL= \
  -e NODE_OPTIONS=--max-old-space-size=384 \
  -e PGHOST=nuxt-db -e DB_HOST=nuxt-db -e PGPORT=5432 \
  -e PAID_MEMBERSHIP_ENABLED=false -e ERROR_NOTIFICATIONS_ENABLED=false \
  "$frontend" npm run operations -- operations:restore_drill
