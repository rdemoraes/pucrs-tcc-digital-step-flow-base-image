# Digital Step Flow - Base Image (Node.js 24)

Imagem base reutilizável para workloads Node.js 24 do Digital Step Flow.

## Descrição

Esta imagem base contém:
- Node.js v24.13.0
- npm 11.6.3
- Usuário não-root (appuser)
- Ferramentas de sistema essenciais

## Versões

- **Produção**: `raphaelmoraes/digital-step-flow-base:<version>`
- **Desenvolvimento**: `raphaelmoraes/digital-step-flow-base:<version>-dev`

## Build

```bash
# Build local
docker buildx bake -f docker-bake.hcl --load

# Build com versão específica
docker buildx bake -f docker-bake.hcl --load \
  --set base_image.args.BASE_IMAGE_VERSION=1.0.0
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

