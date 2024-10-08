FROM --platform=linux/arm64 node:latest

COPY . /app
WORKDIR /app

RUN npm install --legacy-peer-deps --force
EXPOSE 3001
EXPOSE 9229
ENTRYPOINT ["npm", "start"]