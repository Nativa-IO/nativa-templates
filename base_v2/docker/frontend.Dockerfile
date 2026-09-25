# PROD: imagen inmutable con el build horneado. Solo la usa el deploy;
# las sesiones corren sobre la imagen del runner (ver docker-compose.dev.yml).
#
# bookworm y no alpine: misma libc (glibc) que el runner, así un lockfile
# resuelto en la sesión produce los mismos binarios nativos aquí.
FROM node:22-bookworm-slim AS build

WORKDIR /app

# pnpm fijado por corepack: la versión la manda package.json (packageManager),
# no la imagen. Store en caché de BuildKit: rebuilds sin re-descargar.
RUN corepack enable

ARG VITE_API_URL=""
ENV VITE_API_URL=${VITE_API_URL}

COPY package.json pnpm-lock.yaml ./
RUN --mount=type=cache,id=pnpm-store,target=/root/.local/share/pnpm/store \
    pnpm install --frozen-lockfile

COPY . .
RUN pnpm run build

# Sirve dist/ como estáticos. Sin node_modules del proyecto: vite es
# devDependency y no hace falta para servir archivos ya compilados.
# `serve` con -s: SPA fallback a index.html para las rutas del router.
FROM node:22-bookworm-slim

WORKDIR /app
RUN npm install -g serve@14

COPY --from=build /app/dist ./dist

EXPOSE 3000

CMD ["serve", "-s", "dist", "-l", "3000"]
