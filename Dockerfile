FROM node:18 AS build
WORKDIR /app

COPY ./package.json ./
COPY . .
RUN --mount=type=cache,target=/app/npm/cache,id=npmcache \
  npm install --legacy-peer-deps --cache /app/npm/cache --loglevel error

FROM node:18-bookworm-slim AS run
COPY --from=build --chown=node:node ./app ./
EXPOSE 3001
EXPOSE 9229
ENTRYPOINT ["npm", "start"]