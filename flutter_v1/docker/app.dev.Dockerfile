# DEV: flutter run -d web-server con el código bind-mounteado (hot reload).
# El SDK vive en la imagen; las fuentes llegan por volumen desde el worktree.
FROM ghcr.io/cirruslabs/flutter:stable
WORKDIR /app
# Deps precalentadas con el pubspec del template; el volumen las re-resuelve
# al vuelo si la sesión agrega paquetes (pub get en el arranque).
COPY pubspec.yaml pubspec.lock* ./
RUN flutter pub get || true
EXPOSE 3000
CMD ["sh", "-c", "flutter pub get && flutter run -d web-server --web-port 3000 --web-hostname 0.0.0.0 --no-version-check"]
