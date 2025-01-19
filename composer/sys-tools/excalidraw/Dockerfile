ARG VERSION_NODE=18
ARG VERSION_NGNIX=1.21-alpine

FROM node:$VERSION_NODE AS build

WORKDIR /opt/node_app
RUN rm -rf ./*
ARG VERSION_EXCALIDRAW=v0.17.6
RUN git clone https://github.com/excalidraw/excalidraw.git /opt/node_app --branch "$VERSION_EXCALIDRAW"

ARG VITE_APP_BACKEND_V2_GET_URL=https://json.excalidraw.com/api/v2/
ARG VITE_APP_BACKEND_V2_POST_URL=https://json.excalidraw.com/api/v2/post/
ARG VITE_APP_FIREBASE_CONFIG='{}'
ARG VITE_APP_WS_SERVER_URL=
ARG VITE_APP_PORTAL_URL=
ARG VITE_APP_AI_BACKEND=https://oss-ai.excalidraw.com

ARG VITE_APP_ENABLE_TRACKING=false
ARG VITE_APP_DEBUG_ENABLE_TEXT_CONTAINER_BOUNDING_BOX=false
ARG VITE_APP_COLLAPSE_OVERLAY=false
ARG VITE_APP_ENABLE_ESLINT=false

ARG VITE_APP_LIBRARY_URL=https://libraries.excalidraw.com
ARG VITE_APP_LIBRARY_BACKEND=https://us-central1-excalidraw-room-persistence.cloudfunctions.net/libraries
ARG VITE_APP_PLUS_LP=https://plus.excalidraw.com
ARG VITE_APP_PLUS_APP=https://app.excalidraw.com
ARG VITE_APP_PLUS_EXPORT_PUBLIC_KEY=''

RUN echo "VITE_APP_BACKEND_V2_GET_URL=$VITE_APP_BACKEND_V2_GET_URL" > .env.production
RUN echo "VITE_APP_BACKEND_V2_POST_URL=$VITE_APP_BACKEND_V2_POST_URL" >> .env.production
RUN echo "VITE_APP_FIREBASE_CONFIG=$VITE_APP_FIREBASE_CONFIG" >> .env.production
RUN echo "VITE_APP_WS_SERVER_URL=$VITE_APP_WS_SERVER_URL" >> .env.production
RUN echo "VITE_APP_PORTAL_URL=$VITE_APP_PORTAL_URL" >> .env.production
RUN echo "VITE_APP_AI_BACKEND=$VITE_APP_AI_BACKEND" >> .env.production

RUN echo "VITE_APP_ENABLE_TRACKING=$VITE_APP_ENABLE_TRACKING" >> .env.production
RUN echo "VITE_APP_DEBUG_ENABLE_TEXT_CONTAINER_BOUNDING_BOX=$VITE_APP_DEBUG_ENABLE_TEXT_CONTAINER_BOUNDING_BOX" >> .env.production
RUN echo "VITE_APP_COLLAPSE_OVERLAY=$VITE_APP_COLLAPSE_OVERLAY" >> .env.production
RUN echo "VITE_APP_ENABLE_ESLINT=$VITE_APP_ENABLE_ESLINT" >> .env.production

RUN echo "VITE_APP_LIBRARY_URL=$VITE_APP_LIBRARY_URL" >> .env.production
RUN echo "VITE_APP_LIBRARY_BACKEND=$VITE_APP_LIBRARY_BACKEND" >> .env.production
RUN echo "VITE_APP_PLUS_LP=$VITE_APP_PLUS_LP" >> .env.production
RUN echo "VITE_APP_PLUS_APP=$VITE_APP_PLUS_APP" >> .env.production
RUN echo "VITE_APP_PLUS_EXPORT_PUBLIC_KEY=$VITE_APP_PLUS_EXPORT_PUBLIC_KEY" >> .env.production

RUN yarn --ignore-optional --network-timeout 600000
RUN yarn build:app:docker

FROM nginx:$VERSION_NGNIX
COPY --from=build /opt/node_app/build /usr/share/nginx/html
HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
