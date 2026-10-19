#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
backend=$(docker compose ps -q backend)
if [[ -z "$backend" ]]; then
  printf '%s\n' 'Start the local backend and database first.' >&2
  exit 1
fi

host_directory=''
container_directory=''
tools_container=''
cleanup() {
  status=$?
  trap - EXIT
  set +e
  if [[ "$container_directory" =~ ^/tmp/tqce-restore-tools\.[[:alnum:]]+$ ]]; then
    docker exec "$backend" rm -rf -- "$container_directory"
  fi
  if [[ -n "$tools_container" ]]; then docker rm "$tools_container" >/dev/null; fi
  if [[ -n "$host_directory" ]]; then rm -rf -- "$host_directory"; fi
  exit "$status"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

# Reuse the official image without running a second server or rebuilding the app.
tools_container=$(docker create --pull=never postgres:16 /bin/true)
host_directory=$(mktemp -d "${TMPDIR:-/tmp}/tqce-restore-tools.XXXXXXXX")
chmod 700 "$host_directory"
docker cp "$tools_container:/usr/lib/postgresql/16/bin/pg_dump" "$host_directory/pg_dump"
docker cp "$tools_container:/usr/lib/postgresql/16/bin/pg_restore" "$host_directory/pg_restore"
container_directory=$(docker exec "$backend" mktemp -d /tmp/tqce-restore-tools.XXXXXXXX)
if [[ ! "$container_directory" =~ ^/tmp/tqce-restore-tools\.[[:alnum:]]+$ ]]; then
  printf '%s\n' 'Unexpected temporary tool directory.' >&2
  exit 1
fi
docker cp "$host_directory/." "$backend:$container_directory/"
docker exec --workdir /app "$backend" env RAILS_ENV=test \
  "PATH=$container_directory:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
  bin/rails operations:restore_drill
