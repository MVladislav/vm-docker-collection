"use strict";

// Excalidraw HTTP storage backend - the service the patched client speaks to.
// The contract is derived from excalidraw v0.18.1 source, never from a
// third-party server:
//   POST {prefix}/scenes      data/index.ts:307, body is compressData(...); a 413
//                             body must carry {"error_class":"RequestTooLargeError"}
//                             or the client shows a generic failure
//   GET  {prefix}/scenes/{id} data/index.ts:204 - string-concatenated with the id,
//                             so this base URL keeps its trailing slash
//   GET/PUT {prefix}/rooms/{id} data/httpStorage.ts; the PUT body is a 4-byte
//                             big-endian sceneVersion || 12-byte IV || AES-GCM
//   GET/PUT {prefix}/files/{id} data/httpStorage.ts, payload from
//                             data/FileManager.ts:222
// Bodies are read as raw bytes whatever Content-Type was sent. There is
// deliberately no body parser here: the previous generation of this service had
// one, and a single urlencoded PUT handed the handler a string instead of a
// Buffer and killed the container on the next GET.

const http = require("node:http");
const { Store, StoreError, newId } = require("./store");

const VERSION = "1.0.0";
const LOG_LEVELS = { silent: 0, error: 1, warn: 2, info: 3, debug: 4 };

const PORT = Number(process.env.PORT || 8080);
const DATA_DIR = process.env.DATA_DIR || "/data";
const GLOBAL_PREFIX = normalizePrefix(process.env.GLOBAL_PREFIX || "/api/v2");
const BODY_LIMIT = parseSize(process.env.BODY_LIMIT || "50mb");
const LOG_LEVEL = LOG_LEVELS[process.env.LOG_LEVEL] ?? LOG_LEVELS.info;
const DRAIN_MS = Number(process.env.DRAIN_TIMEOUT_MS || 10000);

const started = Date.now();

function normalizePrefix(value) {
  let prefix = value.trim();
  if (!prefix.startsWith("/")) prefix = "/" + prefix;
  while (prefix.length > 1 && prefix.endsWith("/"))
    prefix = prefix.slice(0, -1);
  return prefix;
}

/** `50mb` / `512kb` / `1gb` / a plain byte count. Returns 0 for anything odd. */
function parseSize(value) {
  const match = /^\s*(\d+(?:\.\d+)?)\s*(b|kb|mb|gb)?\s*$/i.exec(String(value));
  if (!match) return 0;
  const units = { b: 1, kb: 1024, mb: 1024 ** 2, gb: 1024 ** 3 };
  return Math.floor(Number(match[1]) * units[(match[2] || "b").toLowerCase()]);
}

function log(level, message, fields) {
  if (LOG_LEVELS[level] > LOG_LEVEL) return;
  const line = { ts: new Date().toISOString(), level, msg: message, ...fields };
  process.stdout.write(JSON.stringify(line) + "\n");
}

// --- routing -----------------------------------------------------------------

// Segments are taken from the RAW request target and are never percent-decoded.
// A legitimate id is `[0-9A-Za-z_-]`, which needs no encoding, so decoding here
// would only add a way in: `%2e%2e%2f` must fail the allowlist, not become
// `../` after decoding.
function segments(url) {
  return url
    .split("?", 1)[0]
    .split("/")
    .filter((part) => part.length > 0);
}

const PREFIX_SEGMENTS = segments(GLOBAL_PREFIX);

/** Everything after GLOBAL_PREFIX, or null when the prefix does not match. */
function stripPrefix(parts) {
  if (PREFIX_SEGMENTS.length > parts.length) return null;
  for (let i = 0; i < PREFIX_SEGMENTS.length; i++) {
    if (parts[i] !== PREFIX_SEGMENTS[i]) return null;
  }
  return parts.slice(PREFIX_SEGMENTS.length);
}

const store = new Store(DATA_DIR);

/** Blob collections and the methods the client actually uses. */
const COLLECTIONS = {
  scenes: { get: ["GET", "HEAD"] },
  rooms: { get: ["GET", "HEAD"], put: ["PUT"] },
  files: { get: ["GET", "HEAD"], put: ["PUT"] },
};

function sendJson(res, status, payload, extraHeaders, callback) {
  const body = Buffer.from(JSON.stringify(payload) + "\n");
  res.writeHead(status, {
    "content-type": "application/json; charset=utf-8",
    "content-length": body.length,
    ...extraHeaders,
  });
  res.end(body, callback);
}

function sendError(res, status, message, extraHeaders) {
  sendJson(res, status, { error: message }, extraHeaders);
}

/**
 * Refuse without draining the body, then tear the socket down once the response
 * is flushed - a hostile upload must not be read just to be thrown away.
 */
function refuseAndClose(req, res, status, payload) {
  sendJson(res, status, payload, { connection: "close" }, () => req.destroy());
}

async function serveBlob(req, res, kind, rawId) {
  let id;
  try {
    id = Store.assertId(rawId);
  } catch {
    return sendError(res, 400, "invalid id");
  }

  const allowed = COLLECTIONS[kind];
  const method = req.method === "HEAD" ? "GET" : req.method;
  if (method !== "GET" && method !== "PUT") {
    return sendError(res, 405, "method not allowed", {
      allow: [...allowed.get, ...(allowed.put || [])].join(", "),
    });
  }

  if (method === "PUT") {
    try {
      const { existed, size } = await store.putFromRequest(
        req,
        kind,
        id,
        BODY_LIMIT,
      );
      log("info", "stored blob", { kind, id, bytes: size, existed });
      // 201 when this request created the blob, 200 when it replaced one
      return sendJson(res, existed ? 200 : 201, {
        id,
        status: existed ? "updated" : "created",
      });
    } catch (err) {
      if (err instanceof StoreError && err.status === 413) {
        return refuseAndClose(req, res, 413, {
          error: "payload too large",
          error_class: "RequestTooLargeError",
          limit: BODY_LIMIT,
        });
      }
      if (err instanceof StoreError && err.status === 400) {
        return refuseAndClose(req, res, 400, { error: err.message });
      }
      if (err instanceof StoreError && err.status === 499) {
        return; // peer went away mid-upload; there is nobody left to answer
      }
      log("error", "store write failed", { kind, id, error: err.message });
      return refuseAndClose(req, res, err.status || 500, {
        error: "write failed",
      });
    }
  }

  let blob;
  try {
    blob = await store.open(kind, id);
  } catch (err) {
    log("error", "store open failed", { kind, id, error: err.message });
    return sendError(res, err.status || 500, "read failed");
  }
  if (!blob) {
    return sendError(res, 404, "not found");
  }

  res.writeHead(200, {
    "content-type": "application/octet-stream",
    "content-length": blob.size,
    // The blob is client-encrypted and deflated; letting a browser or an
    // intermediate proxy try to sniff it would only corrupt it.
    "x-content-type-options": "nosniff",
  });
  if (req.method === "HEAD") {
    blob.stream.destroy();
    return res.end();
  }
  blob.stream.on("error", () => res.destroy());
  blob.stream.pipe(res);
}

async function createScene(req, res) {
  if (req.method !== "POST") {
    return sendError(res, 405, "method not allowed", { allow: "POST" });
  }
  const id = newId();
  try {
    const { size } = await store.putFromRequest(req, "scenes", id, BODY_LIMIT);
    log("info", "created scene", { id, bytes: size });
    return sendJson(res, 201, { id });
  } catch (err) {
    if (err instanceof StoreError && err.status === 413) {
      // The client branches on exactly this class name to show its
      // "shareable link too big" message (data/index.ts:326).
      return refuseAndClose(req, res, 413, {
        error: "payload too large",
        error_class: "RequestTooLargeError",
        limit: BODY_LIMIT,
      });
    }
    if (err instanceof StoreError && err.status === 499) return;
    if (err instanceof StoreError && err.status === 400) {
      return refuseAndClose(req, res, 400, { error: err.message });
    }
    log("error", "scene write failed", { id, error: err.message });
    return refuseAndClose(req, res, err.status || 500, {
      error: "write failed",
    });
  }
}

async function health(res) {
  const writable = await store.isWritable();
  sendJson(res, writable ? 200 : 503, {
    status: writable ? "ok" : "degraded",
    service: "excalidraw-storage",
    version: VERSION,
    writable,
    uptime_s: Math.round((Date.now() - started) / 1000),
  });
}

async function router(req, res) {
  const startedAt = process.hrtime.bigint();
  const parts = segments(req.url);
  res.on("finish", () => {
    const ms = Number(process.hrtime.bigint() - startedAt) / 1e6;
    log("info", "request", {
      method: req.method,
      path: req.url.split("?", 1)[0],
      status: res.statusCode,
      ms: Math.round(ms * 10) / 10,
    });
  });

  if (parts.length === 1 && parts[0] === "health") return health(res);

  const rest = stripPrefix(parts);
  if (rest === null) return sendError(res, 404, "not found");
  if (rest.length === 1 && rest[0] === "health") return health(res);

  if (rest.length === 1 && rest[0] === "scenes") return createScene(req, res);
  if (rest.length === 2 && rest[0] === "scenes") {
    if (req.method !== "GET" && req.method !== "HEAD") {
      return sendError(res, 405, "method not allowed", { allow: "GET, HEAD" });
    }
    return serveBlob(req, res, "scenes", rest[1]);
  }
  if (rest.length === 2 && (rest[0] === "rooms" || rest[0] === "files")) {
    return serveBlob(req, res, rest[0], rest[1]);
  }

  return sendError(res, 404, "not found");
}

// --- lifecycle ---------------------------------------------------------------

async function main() {
  if (!Number.isInteger(PORT) || PORT < 1 || PORT > 65535) {
    log("error", "invalid PORT", { port: PORT });
    process.exit(1);
  }
  if (BODY_LIMIT <= 0) {
    log("error", "invalid BODY_LIMIT", { body_limit: BODY_LIMIT });
    process.exit(1);
  }

  await store.init();

  const server = http.createServer((req, res) => {
    router(req, res).catch((err) => {
      log("error", "unhandled", { error: err && err.message });
      if (!res.headersSent) sendError(res, 500, "internal error");
      else res.destroy();
    });
  });
  server.on("clientError", (err, socket) => {
    if (socket.writable)
      socket.end("HTTP/1.1 400 Bad Request\r\nConnection: close\r\n\r\n");
  });

  let draining = false;
  const shutdown = (signal) => {
    if (draining) return;
    draining = true;
    log("warn", "draining", { signal });
    server.close(() => process.exit(0));
    // Keep-alive sockets would otherwise hold the close() open for their full
    // idle timeout, long past the orchestrator's stop grace period.
    if (server.closeIdleConnections) server.closeIdleConnections();
    setTimeout(() => {
      log("warn", "drain timeout, exiting");
      process.exit(0);
    }, DRAIN_MS).unref();
  };
  process.on("SIGTERM", () => shutdown("SIGTERM"));
  process.on("SIGINT", () => shutdown("SIGINT"));

  server.listen(PORT, () => {
    log("info", "listening", {
      port: PORT,
      prefix: GLOBAL_PREFIX,
      data_dir: store.root,
      body_limit: BODY_LIMIT,
      version: VERSION,
      node: process.version,
      pid: process.pid,
    });
  });
}

main().catch((err) => {
  log("error", "startup failed", { error: err && err.message });
  process.exit(1);
});
