FROM node:6-slim

RUN mkdir -p /usr/src/goof
COPY . /usr/src/goof
WORKDIR /usr/src/goof

RUN npm install --legacy-peer-deps
EXPOSE 3001
EXPOSE 9229
ENTRYPOINT ["npm", "start"]