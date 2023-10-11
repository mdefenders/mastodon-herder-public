#!/usr/bin/env bash

BACKUP_SLEEP_BEFORE="${BACKUP_SLEEP_BEFORE:-43200}"
BACKUP_SLEEP_AFTER="${BACKUP_SLEEP_AFTER:-43200}"

while true
do
  echo "Sleeping ${BACKUP_SLEEP_BEFORE}c before ..."
  sleep "${BACKUP_SLEEP_BEFORE}"

  echo "Backing up Mastodon Public"
  rclone sync -v /mastodon/public/system gdrive:/backup/$(date +%a)/mastodon/system

  echo "Backing up Redis db"
  redis-cli -u redis://redis --rdb /home/mastodon/backups/redis_dump.rdb
  gzip -f /home/mastodon/backups/redis_dump.rdb
  rclone sync -v /home/mastodon/backups/redis_dump.rdb.gz gdrive:/backup/$(date +%a)/redis

  echo "Cleaning up Docker system"
  docker system prune -af

  echo "Cleaning up Mastodon"
  tootctl media remove
  tootctl preview_cards remove

  set -e
  set -o pipefail
  
  echo "Backing up Postgres db"
  PGPASSWORD="${DB_PASS}" pg_dump -h "${DB_HOST}" -p "${DB_PORT}" -d "${DB_NAME}" -U "${DB_USER}" | gzip -c > /home/mastodon/backups/postgres_dump.sql.gz
  rclone sync -v /home/mastodon/backups/postgres_dump.sql.gz gdrive:/backup/$(date +%a)/postgres

  echo "Sleeping ${BACKUP_SLEEP_AFTER}c after..."
  sleep "${BACKUP_SLEEP_AFTER}"


done
