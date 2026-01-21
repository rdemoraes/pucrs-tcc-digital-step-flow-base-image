# Digital Step Flow - Base Images

Repositório para imagens base reutilizáveis do Digital Step Flow.

## Estrutura

Este repositório contém duas imagens base:

### 1. Workload Node.js 24 (`workload/node-24/`)

Imagem base para workloads Node.js 24:
- Node.js v24.13.0
- npm 11.6.3
- Usuário não-root (appuser)

**Imagem Docker**: `raphaelmoraes/digital-step-flow-base:<version>`

### 2. CI/CD Runner (`cicd-runner/`)

Imagem para execução de pipelines CI/CD:
- Docker CLI
- kubectl
- kustomize
- GitHub CLI
- Trivy
- Argo CD CLI
- Git e outras ferramentas

**Imagem Docker**: `raphaelmoraes/digital-step-flow-cicd-runner:<version>`

## Build

### Build Individual

```bash
# Build workload Node 24
docker buildx bake -f workload/node-24/docker-bake.hcl --load

# Build CI/CD runner
docker buildx bake -f cicd-runner/docker-bake.hcl --load
```

### Build Todos

```bash
# Build todas as imagens
docker buildx bake -f docker-bake.hcl --load
```

## Versionamento

Este projeto segue [Semantic Versioning 2.0.0](https://semver.org/).

Para criar uma release:
```bash
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

## CI/CD

O pipeline CI/CD constrói e publica automaticamente ambas as imagens quando:
- Um PR é mergeado para `main` ou `develop`
- Uma tag semântica é criada (ex: `v1.0.0`)

## Documentação

- [Workload Node.js 24](./workload/node-24/README.md)
- [CI/CD Runner](./cicd-runner/README.md)
