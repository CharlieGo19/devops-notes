# I searched on Dockerhub for a 'node:6-alpine', but could not find one. Goodluck if you can.
FROM node:18-alpine

# Added update to this - from solutions
RUN apk add --update --no-cache tini 

# Create working directory for the node app.
WORKDIR /user/src/app

# Copy node package.json so we can download dependencies.
COPY package.json package.json

# Install dependencies.
RUN npm install \
    && npm cache clean --force

# Copy over application files and directories.
COPY . /user/src/app
#COPY bin bin
#COPY public public
#COPY routes routes
#COPY views views


# The assignment said that app listens on port 3000, but the container port should listen on port 80 of the Docker
# host, i.e. it will respond to http://localhost:80, therefore, we should be exposing 3000 and then doing 
# --port 3000:80 when we spin up the container, if I've understood the assignement correctly.
EXPOSE 3000

CMD ["/sbin/tini", "--", "node", "./bin/www"]
