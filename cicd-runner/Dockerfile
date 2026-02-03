#
# ---- Docker Multi-stage Builds: Base ----
#
ARG REGISTRY_URL="dhi.io"
ARG ALPINE_BASE_VERSION="3.23-alpine3.23-dev"
ARG GID="1000"
ARG UID="1000"

FROM ${REGISTRY_URL}/alpine-base:${ALPINE_BASE_VERSION} AS base

#
# ---- Build-base: system packages only (single apk layer) ----
#
FROM base AS build-base

RUN apk add --upgrade --no-cache \
      bash \
      curl \
      git \
      github-cli \
      jq \
      yq \
      docker-cli \
      ca-certificates \
      openssh-client \
      && rm -rf /var/cache/apk/*

#
# ---- Downloader: fetch binaries to /downloads ----
#
FROM build-base AS downloader

ARG KUSTOMIZE_VERSION=5.4.2
ARG TRIVY_VERSION=0.68.2

WORKDIR /downloads

# kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl

# kustomize
RUN curl -sSL "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz" | tar -xz && \
    chmod +x kustomize

# trivy (direct download; install script fails in Alpine due to mktemp/curl)
RUN curl -sSL "https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz" -o trivy.tar.gz && \
    tar -xzf trivy.tar.gz && \
    find . -maxdepth 2 -name trivy -type f -exec mv {} . \; && \
    chmod +x trivy && \
    rm -rf trivy.tar.gz trivy_*

# argocd
RUN curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64 && \
    chmod +x argocd

# docker-buildx (CLI plugin; copied to .docker/cli-plugins in final stage)
RUN mkdir -p docker-cli-plugins && \
    curl -sSL https://github.com/docker/buildx/releases/latest/download/buildx-v0.12.1.linux-amd64 -o docker-cli-plugins/docker-buildx && \
    chmod +x docker-cli-plugins/docker-buildx

#
# ---- Final: build-base + binaries + non-root user ----
#
FROM build-base AS cicd_runner

ARG GID
ARG UID

# Copy binaries from downloader stage
COPY --from=downloader /downloads/kubectl /downloads/kustomize /downloads/trivy /downloads/argocd /usr/local/bin/

# Docker Buildx plugin (root and appuser so both work when container runs as root or appuser)
COPY --from=downloader /downloads/docker-cli-plugins /root/.docker/cli-plugins

# Create non-root user
RUN addgroup --gid "$GID" appuser && \
    adduser --disabled-password \
            --gecos "" \
            --ingroup "appuser" \
            --uid "${UID}" appuser

# Buildx for appuser (docker CLI looks under ~/.docker)
RUN mkdir -p /home/appuser/.docker/cli-plugins && \
    cp -a /root/.docker/cli-plugins/* /home/appuser/.docker/cli-plugins/ && \
    chown -R appuser:appuser /home/appuser/.docker

USER appuser
WORKDIR /workspace
