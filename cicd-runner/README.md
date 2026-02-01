# Digital Step Flow - CI/CD Runner

Imagem Docker para execução de pipelines CI/CD do Digital Step Flow.

Esta imagem é construída a partir da **imagem base reforçada (hardened image)** [Alpine Base](https://hub.docker.com/hardened-images/catalog/dhi/alpine-base) do catálogo Docker Hardened Images (`dhi.io/alpine-base`). É utilizada nos jobs de GitHub Actions (por exemplo, deploy e atualização de manifests Kubernetes) e contempla a instalação das ferramentas necessárias para CI/CD.

## Descrição

**Base:** `dhi.io/alpine-base` (hardened image). Ferramentas essenciais para pipelines CI/CD:
- Docker CLI
- kubectl
- kustomize
- GitHub CLI (gh)
- Trivy (security scanner)
- Argo CD CLI
- Git
- jq, yq
- Bash, curl

## Versões

- **CI/CD Runner**: `raphaelmoraes/digital-step-flow-cicd-runner:<version>`

## Build

```bash
# Build local
docker buildx bake -f docker-bake.hcl --load

# Build com versão específica
docker buildx bake -f docker-bake.hcl --load \
  --set cicd_runner.args.CICD_RUNNER_VERSION=1.0.0
```

## Versionamento

Este projeto segue [Semantic Versioning 2.0.0](https://semver.org/).

Para criar uma release:
```bash
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

## CI/CD

O pipeline CI/CD constrói e publica automaticamente as imagens quando:
- Um PR é mergeado para `main` ou `develop`
- Uma tag semântica é criada (ex: `v1.0.0`)

## Uso

Esta imagem pode ser usada em GitHub Actions ou outros sistemas CI/CD para executar pipelines que requerem ferramentas como kubectl, kustomize, Docker, etc.

