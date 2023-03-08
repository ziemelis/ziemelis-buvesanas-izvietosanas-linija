FROM node:18-alpine AS base

WORKDIR /app

COPY . .

ENV NODE_ENV production

EXPOSE 3000

CMD [ "yarn", "start" ]
