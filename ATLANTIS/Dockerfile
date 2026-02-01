FROM ghcr.io/runatlantis/atlantis:latest
USER root
COPY terragrunt /usr/local/bin/terragrunt
RUN chmod +x /usr/local/bin/terragrunt
COPY certs/gitea-ca.crt /usr/local/share/ca-certificates/gitea-ca.crt
RUN apk update && apk add ca-certificates && update-ca-certificates
RUN mkdir -p /home/atlantis/.atlantis/bin && \
    chown -R atlantis:atlantis /home/atlantis
USER atlantis