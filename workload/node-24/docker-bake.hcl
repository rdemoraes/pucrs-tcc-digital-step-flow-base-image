variable "REGISTRY_URL" {
  default = "dhi.io"
}

variable "DOCKER_HUB_USERNAME" {
  default = "raphaelmoraes"
}

variable "ALPINE_BASE_VERSION" {
  default = "3.23-alpine3.23-dev"
}

variable "NODEJS_VERSION" {
  default = "24.13.0-r1"
}

variable "NPM_VERSION" {
  default = "11.6.3-r0"
}

# Semantic Versioning (SemVer): MAJOR.MINOR.PATCH
# Example: 1.0.0, 1.2.3, 2.0.0
# See: https://semver.org/
variable "BASE_IMAGE_VERSION" {
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

function "version_tags" {
  params = [username, version]
  result = version != "" && length(split(".", version)) >= 2 ? [
    "${username}/digital-step-flow-base-node:${version}",
    "${username}/digital-step-flow-base-node:${major(version)}",
    "${username}/digital-step-flow-base-node:${minor(version)}"
  ] : []
}

function "version_tags_dev" {
  params = [username, version]
  result = version != "" && length(split(".", version)) >= 2 ? [
    "${username}/digital-step-flow-base-node:${version}-dev",
    "${username}/digital-step-flow-base-node:${major(version)}-dev",
    "${username}/digital-step-flow-base-node:${minor(version)}-dev"
  ] : []
}

group "default" {
  targets = [
    "base_image",
    "base_image_dev"
  ]
}

target "_common_base" {
  labels = {
    "org.opencontainers.image.authors": "Digital Step Flow Team",
    "org.opencontainers.image.created": timestamp(),
    "org.opencontainers.image.title": "digital-step-flow-base",
    "org.opencontainers.image.vendor": "Digital Step Flow",
    "org.opencontainers.image.version": BASE_IMAGE_VERSION
  }
}

target "base_image" {
  inherits = ["_common_base"]
  args = {
    REGISTRY_URL = REGISTRY_URL
    ALPINE_BASE_VERSION = ALPINE_BASE_VERSION
    NODEJS_VERSION = NODEJS_VERSION
    NPM_VERSION = NPM_VERSION
    GID = "1000"
    UID = "1000"
  }
  tags = concat(
    ["${DOCKER_HUB_USERNAME}/digital-step-flow-base-node:${NODEJS_VERSION}"],
    version_tags(DOCKER_HUB_USERNAME, BASE_IMAGE_VERSION)
  )
  target = "base"
  pull = true
  dockerfile = "Dockerfile"
  context = "workload/node-24"
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}

target "base_image_dev" {
  inherits = ["_common_base"]
  args = {
    REGISTRY_URL = REGISTRY_URL
    ALPINE_BASE_VERSION = ALPINE_BASE_VERSION
    NODEJS_VERSION = NODEJS_VERSION
    NPM_VERSION = NPM_VERSION
    GID = "1000"
    UID = "1000"
  }
  tags = concat(
    ["${DOCKER_HUB_USERNAME}/digital-step-flow-base-node:${NODEJS_VERSION}-dev"],
    version_tags_dev(DOCKER_HUB_USERNAME, BASE_IMAGE_VERSION)
  )
  target = "base_dev"
  pull = true
  dockerfile = "Dockerfile"
  context = "workload/node-24"
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}

