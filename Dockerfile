FROM node:latest

RUN mkdir -p /usr/src/goof

RUN --mount-type=cache,target=./package.json \
    npm install --legacy-peer-deps
EXPOSE 3001
EXPOSE 9229
ENTRYPOINT ["npm", "start"]