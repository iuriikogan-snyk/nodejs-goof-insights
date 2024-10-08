FROM node:6-slim

COPY . .
RUN npm install --legacy-peer-deps
EXPOSE 3001
EXPOSE 9229
ENTRYPOINT ["npm", "start"]