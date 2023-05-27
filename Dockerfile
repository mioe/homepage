FROM node:18-alpine as base
RUN echo "base"
RUN npm i -g pnpm

FROM base AS dependencies
RUN echo "dependencies"
WORKDIR /app
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY packages/backend/package.json ./packages/backend/package.json
COPY packages/frontend/package.json ./packages/frontend/package.json
RUN ls -all
RUN ls -all packages
RUN ls -all packages/backend
RUN pnpm install

FROM base AS build
RUN echo "build"
WORKDIR /app
COPY . .
COPY --from=dependencies /app/node_modules ./node_modules
COPY --from=dependencies /app/packages/backend/node_modules ./packages/backend/node_modules
COPY --from=dependencies /app/packages/frontend/node_modules ./packages/frontend/node_modules

FROM base as deploy
WORKDIR /app
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/packages/backend/node_modules ./packages/backend/node_modules
COPY --from=build /app/packages/frontend/node_modules ./packages/frontend/node_modules
CMD ["pnpm", "dev"]
