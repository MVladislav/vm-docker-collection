ARG VERSION_NODE=24.10.0
ARG VERSION_NGNIX=1.29-alpine

FROM node:$VERSION_NODE AS build

ARG DOMAIN=
ARG DOMAIN_ROOM=
ARG DOMAIN_STORAGE=localhost

ARG CACHE_INVALIDATOR=
ARG PUBLIC_URL=https://${DOMAIN}
ARG VITE_APP_PORTAL_URL=https://${DOMAIN}

ARG VITE_APP_WS_SERVER_URL=https://${DOMAIN_ROOM}

ARG VITE_APP_BACKEND_V2_GET_URL=https://${DOMAIN_STORAGE}/api/v2/
ARG VITE_APP_BACKEND_V2_POST_URL=https://${DOMAIN_STORAGE}/api/v2/post/

ARG VITE_APP_AI_BACKEND=https://oss-ai.excalidraw.com
ARG VITE_APP_FIREBASE_CONFIG='{}'

ARG VITE_APP_ENABLE_TRACKING=false
ARG VITE_APP_DEBUG_ENABLE_TEXT_CONTAINER_BOUNDING_BOX=false
ARG VITE_APP_COLLAPSE_OVERLAY=false
ARG VITE_APP_ENABLE_ESLINT=false

ARG VITE_APP_LIBRARY_URL=https://libraries.excalidraw.com
ARG VITE_APP_LIBRARY_BACKEND=https://us-central1-excalidraw-room-persistence.cloudfunctions.net/libraries
ARG VITE_APP_PLUS_LP=https://plus.excalidraw.com
ARG VITE_APP_PLUS_APP=https://app.excalidraw.com
ARG VITE_APP_PLUS_EXPORT_PUBLIC_KEY=''

ARG VERSION_EXCALIDRAW=v0.18.0
RUN \
  rm -rf /opt/node_app && \
  mkdir -p /opt/node_app && \
  git clone https://github.com/excalidraw/excalidraw.git /opt/node_app --branch "$VERSION_EXCALIDRAW" && \
  echo "CACHE_INVALIDATOR=$CACHE_INVALIDATOR" >.env.production && \
  echo "PUBLIC_URL=$PUBLIC_URL" >>.env.production && \
  echo "VITE_APP_PORTAL_URL=$VITE_APP_PORTAL_URL" >>.env.production && \
  echo "VITE_APP_WS_SERVER_URL=$VITE_APP_WS_SERVER_URL" >>.env.production && \
  echo "VITE_APP_BACKEND_V2_GET_URL=$VITE_APP_BACKEND_V2_GET_URL" >>.env.production && \
  echo "VITE_APP_BACKEND_V2_POST_URL=$VITE_APP_BACKEND_V2_POST_URL" >>.env.production && \
  echo "VITE_APP_AI_BACKEND=$VITE_APP_AI_BACKEND" >>.env.production && \
  echo "VITE_APP_FIREBASE_CONFIG=$VITE_APP_FIREBASE_CONFIG" >>.env.production && \
  echo "VITE_APP_ENABLE_TRACKING=$VITE_APP_ENABLE_TRACKING" >>.env.production && \
  echo "VITE_APP_DEBUG_ENABLE_TEXT_CONTAINER_BOUNDING_BOX=$VITE_APP_DEBUG_ENABLE_TEXT_CONTAINER_BOUNDING_BOX" >>.env.production && \
  echo "VITE_APP_COLLAPSE_OVERLAY=$VITE_APP_COLLAPSE_OVERLAY" >>.env.production && \
  echo "VITE_APP_ENABLE_ESLINT=$VITE_APP_ENABLE_ESLINT" >>.env.production && \
  echo "VITE_APP_LIBRARY_URL=$VITE_APP_LIBRARY_URL" >>.env.production && \
  echo "VITE_APP_LIBRARY_BACKEND=$VITE_APP_LIBRARY_BACKEND" >>.env.production && \
  echo "VITE_APP_PLUS_LP=$VITE_APP_PLUS_LP" >>.env.production && \
  echo "VITE_APP_PLUS_APP=$VITE_APP_PLUS_APP" >>.env.production && \
  echo "VITE_APP_PLUS_EXPORT_PUBLIC_KEY=$VITE_APP_PLUS_EXPORT_PUBLIC_KEY" >>.env.production

WORKDIR /opt/node_app

RUN yarn --network-timeout 600000
ARG NODE_ENV=production
RUN yarn build:app:docker

FROM nginx:$VERSION_NGNIX
COPY --from=build /opt/node_app/excalidraw-app/build /usr/share/nginx/html
HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
