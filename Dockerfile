ARG MASTODON_VERSION
FROM ghcr.io/mastodon/mastodon:${MASTODON_VERSION}
ARG DOCKER_GUID=109
USER root
COPY entrypoint.sh /home/mastodon/scripts/entrypoint.sh
RUN apt-get update && apt-get upgrade -y && apt-get install -y curl unzip postgresql-client redis-tools \
    && curl https://rclone.org/install.sh | bash && groupadd -g "${DOCKER_GUID}" docker && usermod -a -G docker mastodon \
    && mkdir /home/mastodon/backups && chown mastodon:mastodon -R /home/mastodon && chmod 755 /home/mastodon/scripts/entrypoint.sh
COPY --from=docker:dind /usr/local/bin/docker /usr/local/bin/
USER mastodon
ENTRYPOINT ["/home/mastodon/scripts/entrypoint.sh"]
