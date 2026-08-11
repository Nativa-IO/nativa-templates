# PROD: build web → nginx. El código va horneado (sin volumes), igual que
# base_v1 — por eso el promote rebuildea.
FROM ghcr.io/cirruslabs/flutter:stable AS build
WORKDIR /src
COPY pubspec.yaml pubspec.lock* ./
RUN flutter pub get
COPY . .
RUN flutter build web --release

FROM nginx:alpine
COPY --from=build /src/build/web /usr/share/nginx/html
# SPA: cualquier ruta cae al index (el router de Flutter resuelve).
RUN printf 'server {\n  listen 3000;\n  root /usr/share/nginx/html;\n  location / {\n    try_files $uri $uri/ /index.html;\n  }\n}\n' \
    > /etc/nginx/conf.d/default.conf \
    && rm -f /etc/nginx/conf.d/default.conf.bak
EXPOSE 3000
