FROM node:10-slim

LABEL maintainer="techknowlogick <techknowlogick@gitea.io>"
LABEL org.label-schema.description="Deploying to netlify with Drone CI"

RUN npm install -g netlify-cli

ADD script.sh /bin/
RUN chmod +x /bin/script.sh

ENTRYPOINT /bin/script.sh
