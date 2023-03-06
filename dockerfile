FROM node:16-alpine AS base
RUN  npm install -g pnpm
FROM base as dependencies
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm i --frozen-lockfile
FROM base as build
WORKDIR /app
COPY . .
COPY --from=dependencies /app/node_modules ./node_modules
RUN pnpm build
FROM build as release
WORKDIR /app
COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules
EXPROSE 4001
CMD ["node", "dist/main"]
