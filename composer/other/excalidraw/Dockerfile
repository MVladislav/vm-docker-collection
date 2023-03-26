FROM node:14-alpine AS build

WORKDIR /opt/node_app

RUN \
  echo "**** install git ****" \
  && apk add --no-cache git

RUN mkdir -p /tmp/excalidraw \
  && git clone https://github.com/excalidraw/excalidraw.git /tmp/excalidraw
RUN ls /tmp/excalidraw
RUN cp /tmp/excalidraw/package.json /tmp/excalidraw/yarn.lock ./

RUN yarn --ignore-optional --network-timeout 600000
ARG NODE_ENV=production

RUN cp -r \
  /tmp/excalidraw/.env.development \
  /tmp/excalidraw/.env.production \
  /tmp/excalidraw/.eslintrc.json \
  /tmp/excalidraw/.npmrc \
  # /tmp/excalidraw/.prettierrc \
  /tmp/excalidraw/package.json \
  /tmp/excalidraw/public/ \
  /tmp/excalidraw/src/ \
  /tmp/excalidraw/tsconfig.json \
  /tmp/excalidraw/yarn.lock \
  .

RUN yarn build:app:docker

FROM nginx:1.21-alpine
COPY --from=build /opt/node_app/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
