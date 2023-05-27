FROM node:18-alpine as base
RUN npm i -g pnpm

FROM base AS dependencies
WORKDIR /app
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY packages/backend/package.json ./backend/package.json
COPY packages/frontend/package.json ./frontend/packages.json
RUN pnpm install

FROM base AS build
WORKDIR /app
COPY . .
COPY --from=dependencies /app/node_modules ./node_modules
# COPY --from=dependencies /app/backend/node_modules ./backend/node_modules
# COPY --from=dependencies /app/frontend/node_modules ./frontend/node_modules

FROM base as deploy
WORKDIR /app
COPY --from=build /app/node_modules ./node_modules
# COPY --from=build /app/backend/node_modules ./backend/node_modules
# COPY --from=build /app/frontend/node_modules ./frontend/node_modules
CMD ["pnpm", "dev"]
