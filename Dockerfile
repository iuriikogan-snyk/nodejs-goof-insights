FROM --platform=arm64 node:18 AS build
WORKDIR /app

COPY ./package.json ./
COPY . .
RUN npm install --legacy-peer-deps --force

FROM --platform=arm64 node:18-bookworm-slim AS run
COPY --from=build --chown=node:node ./app ./
EXPOSE 3001
EXPOSE 9229
ENTRYPOINT ["npm", "start"]