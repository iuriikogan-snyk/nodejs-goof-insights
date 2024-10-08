FROM node:6-slim

COPY . /usr/src/goof
WORKDIR /usr/src/goof

RUN npm install --legacy-peer-deps
EXPOSE 3001
EXPOSE 9229
ENTRYPOINT ["npm", "start"]