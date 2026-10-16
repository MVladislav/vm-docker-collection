"use strict";

// Filesystem blob store behind the excalidraw HTTP storage contract: three flat
// directories of opaque blobs. The service never parses a blob - the client
// encrypts (packages/excalidraw/data/encryption.ts) and deflates
// (…/data/encode.ts) everything before sending it.
//
// The one genuinely dangerous input is the id: it comes straight off the URL and
// becomes a filename. `assertId()` is the single gate and `Store#resolve()`
// re-checks the resolved path, so a bug in the router still cannot walk out of
// the data directory.

const fs = require("node:fs");
const fsp = fs.promises;
const path = require("node:path");
const crypto = require("node:crypto");

const fspPromises = fsp;

// Every id the client generates lands inside this class: room ids (20 hex chars),
// file ids (nanoid) and the scene ids assigned by `newId()`. That is what makes
// `..`, `/`, `\`, `%2f` and NUL impossible - none are in the class, and the test
// is anchored. The segment is never percent-decoded (see server.js).
const ID_RE = /^[0-9A-Za-z_-]{1,128}$/;

// Collections: `scenes` = share-link document, `rooms` = encrypted live-collab
// scene, `files` = the uploads of both. Separate directories keep a room id
// from shadowing a file id.
const KINDS = ["scenes", "rooms", "files"];

class StoreError extends Error {
  constructor(status, message) {
    super(message);
    this.status = status;
  }
}

class Store {
  constructor(root) {
    this.root = path.resolve(root);
    this.dirs = new Map();
  }

  async init() {
    for (const kind of KINDS) {
      const dir = path.join(this.root, kind);
      await fspPromises.mkdir(dir, { recursive: true });
      this.dirs.set(kind, dir);
    }
  }

  /** True when the data root is still writable - used by GET /health. */
  async isWritable() {
    try {
      await fspPromises.access(this.root, fs.constants.W_OK);
      return true;
    } catch {
      return false;
    }
  }

  static assertId(id) {
    if (typeof id !== "string" || !ID_RE.test(id)) {
      throw new StoreError(400, "invalid id");
    }
    return id;
  }

  /** Absolute path of a blob, or a 400. Never resolves outside the collection. */
  resolve(kind, id) {
    const dir = this.dirs.get(kind);
    if (!dir) {
      throw new StoreError(404, "unknown collection");
    }
    Store.assertId(id);
    const file = path.resolve(dir, id);
    // Defence in depth: even if assertId() were relaxed later, a resolved path
    // whose parent is not exactly the collection directory is refused.
    if (path.dirname(file) !== dir) {
      throw new StoreError(400, "invalid id");
    }
    return file;
  }

  /**
   * Stream a request body to disk, enforcing `cap` while streaming, then rename
   * a temp file from the same directory into place so a crash or an oversized
   * upload can never leave a half-written blob where a readable one used to be.
   *
   * Returns {existed, size}. Throws StoreError(413) on an oversized body, after
   * removing the temp file it created.
   */
  async putFromRequest(req, kind, id, cap) {
    const dest = this.resolve(kind, id);

    // Fast path for an honest Content-Length over the cap. The streaming cap
    // below stays authoritative: Content-Length is client-supplied and may be
    // absent or a lie.
    const declared = Number(req.headers["content-length"]);
    if (Number.isFinite(declared) && declared > cap) {
      throw new StoreError(413, "payload too large");
    }

    const tmp = path.join(
      this.dirs.get(kind),
      `.tmp-${crypto.randomBytes(16).toString("hex")}`,
    );

    let existed = false;
    try {
      await fspPromises.access(dest);
      existed = true;
    } catch {
      existed = false;
    }

    let received = 0;
    // `failed` latches an error, `done` latches success - separate flags on
    // purpose: the request ending is NOT the write finishing, and treating the
    // first event as the second deadlocks the upload.
    let failed = false;
    let done = false;

    const out = fs.createWriteStream(tmp, { flags: "wx", mode: 0o600 });

    try {
      await new Promise((resolve, reject) => {
        const fail = (err) => {
          if (failed || done) return;
          failed = true;
          out.destroy();
          reject(err);
        };

        out.on("error", (err) =>
          fail(new StoreError(err.code === "ENOSPC" ? 507 : 500, err.message)),
        );
        req.on("error", (err) => fail(new StoreError(400, err.message)));
        req.on("aborted", () => fail(new StoreError(499, "client aborted")));

        req.on("data", (chunk) => {
          if (failed || done) return;
          received += chunk.length;
          if (received > cap) {
            fail(new StoreError(413, "payload too large"));
            return;
          }
          if (!out.write(chunk)) {
            // Respect backpressure instead of queueing the whole upload in RAM.
            req.pause();
            out.once("drain", () => req.resume());
          }
        });
        req.on("end", () => {
          if (failed || done) return;
          out.end();
        });

        out.on("finish", () => {
          if (failed || done) return;
          done = true;
          resolve();
        });
      });
    } catch (err) {
      await fspPromises.rm(tmp, { force: true }).catch(() => {});
      throw err;
    }

    // Same directory, therefore same filesystem, therefore atomic: a reader
    // sees either the previous blob or the complete new one, never a splice.
    await fspPromises.rename(tmp, dest);
    return { existed, size: received };
  }

  /** Open an existing blob for streaming, or null when it does not exist. */
  async open(kind, id) {
    const file = this.resolve(kind, id);
    let stat;
    try {
      stat = await fspPromises.stat(file);
    } catch (err) {
      if (err.code === "ENOENT") return null;
      throw err;
    }
    if (!stat.isFile()) {
      // A directory or a device node with an id-shaped name is not a blob.
      throw new StoreError(404, "not found");
    }
    return { stream: fs.createReadStream(file), size: stat.size };
  }
}

/**
 * New share-link scene id: a millisecond timestamp plus six random hex
 * characters, the shape upstream's own v2 backend returns. The random tail is
 * what makes two links created in the same millisecond distinct; ids are only
 * ever handed back to a client holding the encryption key, so their entropy is
 * not a security boundary.
 */
function newId() {
  return `${Date.now()}${crypto.randomBytes(6).toString("hex").slice(0, 6)}`;
}

module.exports = { Store, StoreError, ID_RE, KINDS, newId };
