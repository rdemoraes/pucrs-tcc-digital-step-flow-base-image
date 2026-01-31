ARG REGISTRY_URL="dhi.io"
ARG ALPINE_BASE_VERSION="3.23-alpine3.23-dev"
ARG NODEJS_VERSION="24.13.0-r1"
ARG NPM_VERSION="11.6.3-r0"
ARG GID="10001"
ARG UID="10001"

FROM ${REGISTRY_URL}/alpine-base:${ALPINE_BASE_VERSION} AS base

ARG GID
ARG UID
ARG NODEJS_VERSION
ARG NPM_VERSION

# Create non-root user
RUN addgroup --gid "$GID" appuser && \
    adduser --disabled-password \
            --gecos "" \
            --ingroup "appuser" \
            --uid "${UID}" appuser

# Refresh index and upgrade all packages (including libssl/libcrypto from base) to latest security fixes
RUN apk update && apk upgrade --no-cache && rm -rf /var/cache/apk/*

# Install Node.js and npm with specific versions
RUN apk add --upgrade --no-cache \
      nodejs=${NODEJS_VERSION} \
      npm=${NPM_VERSION} \
      busybox \
      perl \
      ca-certificates && \
    rm -rf /var/cache/apk/* && \
    # Verify versions
    NODE_VERSION=$(node --version | sed 's/v//') && \
    NPM_VERSION=$(npm --version) && \
    echo "Installed Node.js: ${NODE_VERSION}" && \
    echo "Installed npm: ${NPM_VERSION}" && \
    # Verify we have Node.js 24.13.0
    if ! echo "${NODE_VERSION}" | grep -q "^24\.13\.0"; then \
      echo "ERROR: Expected Node.js 24.13.0, got ${NODE_VERSION}"; \
      exit 1; \
    fi

FROM base AS base_dev

# Install development tools
RUN apk add --upgrade --no-cache \
      bash \
      curl \
      autoconf \
      automake \
      bzip2-dev \
      diffutils \
      gcc \
      libc-dev \
      libffi-dev \
      libtool \
      shadow \
      make \
      perl \
      wget \
      git \
      jq \
      zlib-dev && \
    rm -rf /var/cache/apk/*

