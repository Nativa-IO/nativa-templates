# Next.js with Node
FROM node:22-alpine

WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm install

EXPOSE 3000

# docker-compose overrides with npm install && npm run dev.
CMD ["npm", "run", "dev"]
