#!/usr/bin/env bash
# Run the CI/CD runner image locally with the same options as GitHub Actions
# (--user root) so you can debug "kustomize: not found" or other tool issues.
#
# Usage:
#   ./run-local.sh                    # interactive shell
#   ./run-local.sh -- kustomize version
#
# Optional: pass a different image tag via CICD_RUNNER_IMAGE env.
set -euo pipefail
IMAGE="${CICD_RUNNER_IMAGE:-raphaelmoraes/digital-step-flow-cicd-runner:0.0.1}"
echo "Running: docker run -it --rm --user root ${IMAGE} $*"
exec docker run -it --rm --user root "$IMAGE" "$@"
