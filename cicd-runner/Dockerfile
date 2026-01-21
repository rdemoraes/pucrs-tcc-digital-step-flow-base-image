ARG REGISTRY_URL="dhi.io"
ARG ALPINE_BASE_VERSION="3.23-alpine3.23-dev"
ARG GID="1000"
ARG UID="1000"

FROM ${REGISTRY_URL}/alpine-base:${ALPINE_BASE_VERSION} AS cicd_runner

ARG GID
ARG UID

# Create non-root user
RUN addgroup --gid "$GID" appuser && \
    adduser --disabled-password \
            --gecos "" \
            --ingroup "appuser" \
            --uid "${UID}" appuser

# Install CI/CD tools
RUN apk add --upgrade --no-cache \
      bash \
      curl \
      git \
      jq \
      yq \
      docker-cli \
      ca-certificates \
      openssh-client \
      && \
    rm -rf /var/cache/apk/*

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/kubectl || \
    echo "kubectl installation skipped"

# Install kustomize
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash && \
    mv kustomize /usr/local/bin/kustomize || \
    echo "kustomize installation skipped"

# Install Docker Buildx
RUN mkdir -p ~/.docker/cli-plugins/ && \
    curl -SL https://github.com/docker/buildx/releases/latest/download/buildx-v0.12.1.linux-amd64 -o ~/.docker/cli-plugins/docker-buildx && \
    chmod +x ~/.docker/cli-plugins/docker-buildx || \
    echo "Docker Buildx installation skipped"

# Install Trivy (security scanner)
RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | \
    sh -s -- -b /usr/local/bin || \
    echo "Trivy installation skipped"

# Install Argo CD CLI
RUN curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64 && \
    chmod +x /usr/local/bin/argocd || \
    echo "Argo CD CLI installation skipped"

# Install GitHub CLI (gh) - Alpine version
RUN apk add --no-cache github-cli || \
    (curl -fsSL https://github.com/cli/cli/releases/latest/download/gh_$(curl -s https://api.github.com/repos/cli/cli/releases/latest | grep tag_name | cut -d '"' -f 4 | sed 's/v//')_linux_amd64.tar.gz | \
     tar -xz && \
     mv gh_*_linux_amd64/bin/gh /usr/local/bin/gh && \
     chmod +x /usr/local/bin/gh) || \
    echo "GitHub CLI installation skipped"

# Switch to non-root user
USER appuser

WORKDIR /workspace
