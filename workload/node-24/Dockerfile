ARG REGISTRY_URL="dhi.io"
ARG ALPINE_BASE_VERSION="3.23-alpine3.23-dev"
ARG NODEJS_VERSION="24.13.0-r0"
ARG NPM_VERSION="11.6.3-r0"
ARG GID="1000"
ARG UID="1000"

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

# Install Node.js and npm with specific versions
RUN apk add --upgrade --no-cache \
      nodejs=${NODEJS_VERSION} \
      npm=${NPM_VERSION} \
      busybox \
      perl \
      ca-certificates && \
    rm -rf /var/cache/apk/*

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

