# Builds Excalidraw from source with the HTTP storage backend patch applied, then
# serves the static build from nginx. Vite inlines import.meta.env.*, so every
# public URL is decided HERE at build time. One domain, path-routed, same-origin:
#   ${DOMAIN}/api/v2/...    -> excalidraw-storage (scenes / rooms / files)
#   ${DOMAIN}/socket.io/... -> excalidraw-room    (live collaboration)
ARG VERSION_NODE=22.23.3 # https://hub.docker.com/_/node
ARG VERSION_NGINX=1.31.7-alpine # https://hub.docker.com/_/nginx

FROM node:$VERSION_NODE AS build

WORKDIR /opt/node_app

# What the browser uses. NOT traefik's server.scheme (PROTOCOL), always http.
ARG DOMAIN=
ARG PUBLIC_PROTOCOL=https

# Bump to force a rebuild without changing any URL.
ARG CACHE_INVALIDATOR=

ARG VERSION_EXCALIDRAW=v0.18.1
RUN git clone https://github.com/excalidraw/excalidraw.git . --branch "$VERSION_EXCALIDRAW"

# Replace the Firebase storage backend with the self-hosted HTTP one. --check
# first, then assert every symbol the runtime needs: a patch that stops applying
# against a new upstream tag must fail the build, not silently fall back to
# Firebase. The final negated grep guards the other direction.
COPY patches/http-storage.patch /tmp/http-storage.patch
RUN set -eu; \
  git apply --check /tmp/http-storage.patch; \
  git apply /tmp/http-storage.patch; \
  grep -q "export const saveToHttpStorage" excalidraw-app/data/httpStorage.ts; \
  grep -q "export const loadFilesFromHttpStorage" excalidraw-app/data/httpStorage.ts; \
  grep -q 'HTTP_STORAGE_BACKEND_URL}/rooms/' excalidraw-app/data/httpStorage.ts; \
  grep -q 'HTTP_STORAGE_BACKEND_URL}/files/' excalidraw-app/data/httpStorage.ts; \
  grep -q "loadFilesFromHttpStorage" excalidraw-app/App.tsx; \
  grep -q "saveToHttpStorage" excalidraw-app/collab/Collab.tsx; \
  grep -q "saveFilesToHttpStorage" excalidraw-app/data/index.ts; \
  ! grep -qE '(data/firebase|from "\./firebase")' \
    excalidraw-app/App.tsx excalidraw-app/collab/Collab.tsx excalidraw-app/data/index.ts

# --- offline / egress knobs -------------------------------------------------
# Read by a user-initiated action only (link href, window.open, or a fetch after
# a click). Empty by default: the call becomes same-origin and 404s instead of
# handing scene content to a third party.
ARG VITE_APP_AI_BACKEND=
ARG VITE_APP_LIBRARY_URL=
ARG VITE_APP_LIBRARY_BACKEND=
ARG VITE_APP_PLUS_LP=
ARG VITE_APP_PLUS_APP=
# Never reached with the HTTP backend on, but ExportToExcalidrawPlus.tsx still
# imports data/firebase.ts, so this must stay parseable JSON.
ARG VITE_APP_FIREBASE_CONFIG='{}'
# The patch also gates the SimpleAnalytics <script> in index.html on this flag;
# upstream v0.18.1 only checks `PROD`.
ARG VITE_APP_ENABLE_TRACKING=false
ARG VITE_APP_DEBUG_ENABLE_TEXT_CONTAINER_BOUNDING_BOX=false
ARG VITE_APP_COLLAPSE_OVERLAY=false
ARG VITE_APP_ENABLE_ESLINT=false

RUN set -eu; \
  case "$PUBLIC_PROTOCOL" in \
    https) SCHEME=https; WS_SCHEME=wss ;; \
    http) SCHEME=http; WS_SCHEME=ws ;; \
    *) echo "PUBLIC_PROTOCOL must be 'https' or 'http', got '$PUBLIC_PROTOCOL'" >&2; exit 1 ;; \
  esac; \
  if [ -z "$DOMAIN" ]; then echo "DOMAIN must not be empty" >&2; exit 1; fi; \
  ORIGIN="$SCHEME://$DOMAIN"; \
  { \
    echo "CACHE_INVALIDATOR=$CACHE_INVALIDATOR"; \
    echo "PUBLIC_URL=$ORIGIN"; \
    echo "VITE_APP_PORTAL_URL=$ORIGIN"; \
    echo "VITE_APP_WS_SERVER_URL=$WS_SCHEME://$DOMAIN"; \
    # GET is string-concatenated with the scene id (data/index.ts), so it keeps
    # its trailing slash; POST is used verbatim, so it must not have one.
    echo "VITE_APP_BACKEND_V2_GET_URL=$ORIGIN/api/v2/scenes/"; \
    echo "VITE_APP_BACKEND_V2_POST_URL=$ORIGIN/api/v2/scenes"; \
    echo "VITE_APP_HTTP_STORAGE_BACKEND_URL=$ORIGIN/api/v2"; \
    echo "VITE_APP_AI_BACKEND=$VITE_APP_AI_BACKEND"; \
    echo "VITE_APP_FIREBASE_CONFIG=$VITE_APP_FIREBASE_CONFIG"; \
    echo "VITE_APP_ENABLE_TRACKING=$VITE_APP_ENABLE_TRACKING"; \
    echo "VITE_APP_DEBUG_ENABLE_TEXT_CONTAINER_BOUNDING_BOX=$VITE_APP_DEBUG_ENABLE_TEXT_CONTAINER_BOUNDING_BOX"; \
    echo "VITE_APP_COLLAPSE_OVERLAY=$VITE_APP_COLLAPSE_OVERLAY"; \
    echo "VITE_APP_ENABLE_ESLINT=$VITE_APP_ENABLE_ESLINT"; \
    echo "VITE_APP_LIBRARY_URL=$VITE_APP_LIBRARY_URL"; \
    echo "VITE_APP_LIBRARY_BACKEND=$VITE_APP_LIBRARY_BACKEND"; \
    echo "VITE_APP_PLUS_LP=$VITE_APP_PLUS_LP"; \
    echo "VITE_APP_PLUS_APP=$VITE_APP_PLUS_APP"; \
    echo "VITE_APP_PLUS_EXPORT_PUBLIC_KEY="; \
  } > .env.production; \
  cat .env.production

RUN yarn --network-timeout 600000
ARG NODE_ENV=production

# --- keep the shipped build self-hosted --------------------------------------
# `OSS_FONTS_CDN` (scripts/woff2/woff2-vite-plugins.js) is baked into every
# @font-face src, the three font preloads (fetched on EVERY page load) and
# window.EXCALIDRAW_ASSET_PATH. The build emits byte-identical files under
# fonts/<Family>/, so repointing it at our own origin removes all of it.
# index.html also preconnects to fonts.googleapis.com / fonts.gstatic.com
# although no Google font is used.
RUN set -eu; \
  sed -i 's#https://excalidraw\.nyc3\.cdn\.digitaloceanspaces\.com/oss/#/#g' scripts/woff2/woff2-vite-plugins.js; \
  if grep -q 'digitaloceanspaces' scripts/woff2/woff2-vite-plugins.js; then \
    echo "could not repoint the font CDN" >&2; exit 1; fi; \
  sed -i '/rel="preconnect" href="https:\/\/fonts\.g/d' excalidraw-app/index.html; \
  if grep -q 'fonts\.googleapis\.com' excalidraw-app/index.html; then \
    echo "could not drop the Google Fonts preconnect" >&2; exit 1; fi; \
  # Same-origin now, so crossorigin="anonymous" makes the preloads CORS-mode
  # requests the @font-face fetch can never reuse: the font downloads twice and
  # the browser warns. It sits on its own line, so delete the line.
  sed -i '/crossorigin="anonymous"/d' scripts/woff2/woff2-vite-plugins.js; \
  if grep -q 'crossorigin' scripts/woff2/woff2-vite-plugins.js; then \
    echo "could not drop crossorigin from the font preloads" >&2; exit 1; fi; \
  grep -n 'OSS_FONTS_CDN = ' scripts/woff2/woff2-vite-plugins.js

RUN yarn build:app:docker

# The Assistant @font-face block gets two sources per weight: the CDN (our own
# origin since the sed above) and a relative ./Assistant-*.woff2 that vite never
# emits. Upstream ships only public/Assistant-Regular.woff2, so the other three
# 404 on any self-hosted build. Stage all four at both paths the CSS asks for.
RUN set -eu; \
  mkdir -p excalidraw-app/build/fonts/Assistant excalidraw-app/build/assets; \
  cp packages/excalidraw/fonts/Assistant/*.woff2 excalidraw-app/build/fonts/Assistant/; \
  cp packages/excalidraw/fonts/Assistant/*.woff2 excalidraw-app/build/assets/; \
  for w in Regular Medium SemiBold Bold; do \
    test -s "excalidraw-app/build/fonts/Assistant/Assistant-$w.woff2" \
      || { echo "Assistant-$w.woff2 not staged" >&2; exit 1; }; \
  done; \
  echo "staged $(find excalidraw-app/build/fonts/Assistant -name '*.woff2' | wc -l) Assistant weights"

# Nothing fetched or preconnected while a page LOADS may leave this origin.
# Scanned: index.html and the CSS, i.e. what the browser renders unattended.
# JS chunks are NOT scanned - the click-only links (help/blog, publish library)
# live there, and gating them would fail the build for an opted-in feature.
RUN set -eu; \
  cd excalidraw-app/build; \
  FORBIDDEN='digitaloceanspaces|simpleanalyticscdn|fonts\.googleapis\.com|fonts\.gstatic\.com|oss-ai\.excalidraw\.com|us-central1-excalidraw-room-persistence'; \
  if grep -lqE "$FORBIDDEN" ./*.html ./assets/*.css; then \
    echo "BUILD LOADS EXTERNAL HOSTS ON RENDER:" >&2; \
    grep -lE "$FORBIDDEN" ./*.html ./assets/*.css >&2; \
    exit 1; \
  fi; \
  MISSING=$(grep -roh 'url(/\(fonts\|assets\)/[^)]*\.woff2)' ./assets/*.css ./*.html 2>/dev/null \
    | sed 's/^url(//; s/)$//' | sort -u \
    | while read -r u; do [ -f ".${u}" ] || echo "$u"; done); \
  if [ -n "$MISSING" ]; then \
    echo "BUILD REFERENCES FONTS IT DOES NOT SHIP:" >&2; \
    echo "$MISSING" >&2; \
    exit 1; \
  fi; \
  echo "build loads nothing from an external host; every referenced woff2 resolves"

FROM nginx:$VERSION_NGINX
COPY --from=build /opt/node_app/excalidraw-app/build /usr/share/nginx/html
# wget: the busybox applet every nginx alpine variant carries.
HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
