# Using legacy alpine:
# https://hub.docker.com/layers/library/node/6-alpine/images/sha256-37a1e687d3153e4980ee584b7b0f9ce0a0c3f9fa7ea08647c74422afbf889ff7?context=explore

FROM node:6-alpine

# Expose port 3000 - the port the app uses as per dev requirements.
EXPOSE 3000

RUN apk add --no-cache tini
RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

COPY package.json package.json

RUN npm install && npm cache clean --force

#COPY app.js app.js
#COPY bin bin
#COPY routes §routes
#COPY views views
#COPY public public

COPY . .

CMD ["/sbin/tini", "--", "node", "./bin/www"]