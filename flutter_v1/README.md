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

## El health de cada servicio

`.nativa/manifest.json` (versión 2) declara cómo sabe el agente que un servicio está
listo y sigue vivo. El sondeo corre **dentro de la red de compose**, contra el
nombre del servicio (`http://backend:8000/health`) — nunca contra el dominio
público, para que el health no dependa de Caddy, DNS ni del túnel.

```json
"health": {
  "type": "http",
  "port": 8000,
  "path": "/health",
  "method": "GET",
  "expect_status": [200],
  "timeout_ms": 2000,
  "interval_ms": 3000,
  "retries": 3,
  "start_period_ms": 120000
}
```

Cuatro tipos, como en Kubernetes y Docker:

| `type` | Campos propios | Sano cuando |
|---|---|---|
| `http` | `port`, `path`, `method`, `scheme`, `headers`, `expect_status` | El status está en `expect_status` (default 200–399) |
| `tcp` | `port` | El socket abre |
| `exec` | `command` (arreglo, sin shell) | El código de salida es 0 |
| `none` | — | No se sondea: listo al arrancar |

Los tiempos son iguales para todos los tipos:

| Campo | Default | Qué significa |
|---|---|---|
| `timeout_ms` | 2000 | Cuánto espera una prueba antes de contarla fallida |
| `interval_ms` | 3000 | Cada cuánto se repite |
| `retries` | 3 | Fallos seguidos para declararlo caído |
| `start_period_ms` | 60000 | Gracia inicial: los fallos no cuentan, solo retrasan el "listo" |
| `success_threshold` | 1 | Éxitos seguidos para volver a sano |

Reglas del endpoint:

- **Sin auth y barato.** Nada de tocar la base en cada sondeo; para eso usa
  otro endpoint (`/health?deep=1`), no el del sondeo.
- **Falla cerrada.** Un `type` desconocido o un campo inválido es error de
  manifiesto: el servicio queda en error, nunca en verde.
- **Compatibilidad.** Un `health` viejo (`{port, path}`) se lee como
  `type: "http"` con los defaults.

## Estructura

```
app/            # la app Flutter (lib/, test/, web/)
docker/         # Dockerfiles dev (web-server) y prod (build → nginx)
docker-compose.yml       # base: build horneado + caddy labels
docker-compose.dev.yml   # capa de sesión: bind-mount + hot reload
.nativa/manifest.json    # el contrato: kind, toolchains, validate, comandos
```
