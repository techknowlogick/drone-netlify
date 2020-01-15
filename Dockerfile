FROM node:10-slim

LABEL maintainer="techknowlogick <techknowlogick@gitea.io>"
LABEL org.label-schema.version=latest
LABEL org.label-schema.vcs-url="https://github.com/techknowlogick/drone-netlify"
LABEL org.label-schema.name="drone-netlify"
LABEL org.label-schema.description="Deploying to netlify with Drone CI"
LABEL org.label-schema.vendor="techknowlogick"
LABEL org.label-schema.schema-version="2.0"

RUN npm install -g netlify-cli

ADD script.sh /bin/
RUN chmod +x /bin/script.sh

ENTRYPOINT /bin/script.sh
