# DEV: flutter run -d web-server con el código bind-mounteado (hot reload).
# El SDK vive en la imagen; las fuentes llegan por volumen desde el worktree.
FROM ghcr.io/cirruslabs/flutter:stable
WORKDIR /app
# Deps precalentadas con el pubspec del template; el volumen las re-resuelve
# al vuelo si la sesión agrega paquetes (pub get en el arranque).
COPY pubspec.yaml pubspec.lock* ./
RUN flutter pub get || true
EXPOSE 3000
# --profile y no debug: el cliente de debug que inyecta el modo debug espera
# conectarse de vuelta al dev server y detras del tunel esa espera deja la
# pantalla en blanco antes del primer frame. Profile compila real (dart2js),
# pinta al primer frame y carga mas rapido; el hot reload automatico se
# cambia por restart — trade correcto para un preview detras de cloudflared.
# rm -rf build/web: un preview nunca debe servir artefactos de un build
# anterior — cadaveres de debug (o un flutter_service_worker.js rancio)
# convivien con el build nuevo y el fallback del dev server los sirve como
# 200, envenenando caches y service workers rio abajo. Siempre desde cero.
# (--pwa-strategy none seria lo ideal pero flutter run no lo acepta, 3.44.)
CMD ["sh", "-c", "flutter pub get && rm -rf build/web && flutter run -d web-server --profile --web-port 3000 --web-hostname 0.0.0.0 --no-version-check"]
