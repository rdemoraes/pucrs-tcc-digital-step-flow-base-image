variable "REGISTRY_URL" {
  default = "dhi.io"
}

variable "DOCKER_HUB_USERNAME" {
  default = "raphaelmoraes"
}

variable "ALPINE_BASE_VERSION" {
  default = "3.23-alpine3.23-dev"
}

# Semantic Versioning (SemVer): MAJOR.MINOR.PATCH
# Example: 1.0.0, 1.2.3, 2.0.0
# See: https://semver.org/
variable "CICD_RUNNER_VERSION" {
  default = ""
}

function "major" {
  params = [version]
  result = length(split(".", version)) > 0 ? split(".", version)[0] : version
}

function "minor" {
  params = [version]
  result = length(split(".", version)) >= 2 ? join(".", slice(split(".", version), 0, 2)) : version
}

group "default" {
  targets = [
    "cicd_runner"
  ]
}

target "_common_cicd" {
  labels = {
    "org.opencontainers.image.authors": "Digital Step Flow Team",
    "org.opencontainers.image.created": timestamp(),
    "org.opencontainers.image.title": "digital-step-flow-cicd-runner",
    "org.opencontainers.image.vendor": "Digital Step Flow",
    "org.opencontainers.image.version": CICD_RUNNER_VERSION
  }
}

target "cicd_runner" {
  inherits = ["_common_cicd"]
  args = {
    REGISTRY_URL = REGISTRY_URL
    ALPINE_BASE_VERSION = ALPINE_BASE_VERSION
    GID = "1000"
    UID = "1000"
  }
  tags = [
    "${DOCKER_HUB_USERNAME}/digital-step-flow-cicd-runner:${CICD_RUNNER_VERSION}",
    "${DOCKER_HUB_USERNAME}/digital-step-flow-cicd-runner:${major(CICD_RUNNER_VERSION)}",
    "${DOCKER_HUB_USERNAME}/digital-step-flow-cicd-runner:${minor(CICD_RUNNER_VERSION)}"
  ]
  target = "cicd_runner"
  pull = true
  dockerfile = "Dockerfile"
  context = "cicd-runner"
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}

