# Nativa Flutter V2

Template para apps Flutter en Nativa. Flujo recortado a propósito:
**sesiones + preview** — sin Deployments/Publicar (el "deploy" de una app
Flutter son sus builds, no un servidor).

## Qué cambia respecto a V1

V1 construía una imagen propia para el preview (`cirruslabs/flutter`) en
cada promote y bajaba los paquetes de pub en cada arranque. V2 sigue la
receta de `base_v2`:

- **El preview corre sobre la imagen del runner** (`NATIVA_RUNNER_IMAGE`,
  la escribe nativa-agent en el `.env` del preview). Sin build de imagen.
- **El SDK de Flutter lo pone mise** en el volumen compartido
  `nativa-toolchains`: lo instala el runner al nacer la sesión, una vez por
  caja. La versión vive en `app/.mise.toml` (y en `runner.toolchains` del
  manifiesto, que es lo que el runner instala).
- **Los paquetes viven en el store compartido** (`PUB_CACHE=/opt/cache/pub`)
  y `.dart_tool/` en el worktree. El promote solo corre `flutter pub get`
  cuando cambia `pubspec.lock` (huella por servicio).
- **El promote reinicia el dev server** (`reload: restart` en el
  manifiesto): Flutter web no recarga en caliente con el código montado,
  así que cada cambio cuesta una compilación de dart2js (segundos), no un
  build de imagen ni una descarga.

## Cómo corre

- **Sesión (dev)**: `flutter run -d web-server --profile` con el worktree
  bind-mounteado, servido por caddy en el host de la sesión. El "emulador"
  es la app web con viewport móvil: Nativa Desktop la envuelve en un marco
  de teléfono. `--profile` y no debug: el cliente de debug espera conectarse
  de vuelta al dev server y detrás del túnel se queda en blanco.
- **Validación**: `flutter analyze` + `flutter test`, dentro del runner de la
  sesión.
- **Build prod**: `flutter build web --release` → nginx (imagen estática,
  `docker/app.Dockerfile`). Producción no cambia respecto a V1.
- **Export**: el repo es tuyo en GitHub desde el día uno; `build.apk` está
  declarado en el manifiesto para el export de Android.

## El health del servicio

`.nativa/manifest.json` (versión 2) declara cómo sabe el agente que el
servicio está listo y sigue vivo. El sondeo corre **dentro de la red de
compose**, contra el nombre del servicio (`http://app:3000/`) — nunca contra
el dominio público, para que el health no dependa de Caddy, DNS ni del túnel.
`start_period_ms` es largo (180 s) porque el primer arranque compila la app
con dart2js.
