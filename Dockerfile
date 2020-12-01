# When hosting base image in private registry, provide registry URL such as `myregistry.azurecr.io/`
ARG REGISTRY_FROM_URL=
FROM ${REGISTRY_FROM_URL}node:15-alpine

COPY . /src
RUN cd /src && npm install
EXPOSE 80
CMD ["node", "/src/server.js"]
