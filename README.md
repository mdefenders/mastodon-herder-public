# Mastodon Herder
_This repo is a reference clone of the original private docker image repo, which uses self-hosted GitHub Actions runners, 
disabled for public repos._

Maintenance  image for Mastodon dockerized deployment.
It runs in an infinity loop to emulate CronJob's dirty way.
To be used with [myHomeBee home server](https://github.com/mdefenders/myHomeBee.git)

## Image-related Configuration
### Build args
- MASTODON_VERSION - Mastodon version
- DOCKER_GUID - Docker group UID for your host operating system

### Runtime Vars
- BACKUP_SLEEP_BEFORE - seconds to sleep before a maintenance
- BACKUP_SLEEP_BEFORE - seconds to sleep after a maintenance
- DB_PASS, DB_HOST, DB_PORT, DB_NAME, DB_USER - postgres db parameters

*Rclone is configured by compose*

## Features

### Backup
Rclone backup to a free tier Google Drive 
- Mastodon public folder 
- Postgres DB
- Redis dump

### Cleanup
- Mastodon media and previews
- Docker system
