# Nativa Flutter V1

Template para apps Flutter en Nativa. Flujo recortado a propósito:
**sesiones + preview** — sin Deployments/Publicar (el "deploy" de una app
Flutter son sus builds, no un servidor).

## Cómo corre

- **Sesión (dev)**: `flutter run -d web-server` con el worktree
  bind-mounteado — hot reload real, servido por caddy en el host de la
  sesión. El "emulador" es la app web con viewport móvil: Nativa Desktop
  la envuelve en un marco de teléfono.
- **Validación**: `flutter analyze` + `flutter test`, corriendo dentro del
  runner de la sesión (toolchain instalado por mise, declarado en
  `runner.toolchains`).
- **Build prod**: `flutter build web --release` → nginx (imagen estática).
- **Export**: el repo es tuyo en GitHub desde el día uno; `build.apk` está
  declarado en el manifiesto para el export de Android.

## Estructura

```
app/            # la app Flutter (lib/, test/, web/)
docker/         # Dockerfiles dev (web-server) y prod (build → nginx)
docker-compose.yml       # base: build horneado + caddy labels
docker-compose.dev.yml   # capa de sesión: bind-mount + hot reload
nativa.json     # el contrato: kind, toolchains, validate, comandos
```
