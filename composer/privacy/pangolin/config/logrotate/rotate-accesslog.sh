#!/bin/sh
# Cap traefik's access.log: it sits on a volume that neither traefik nor the
# docker log driver can rotate. Truncating in place (not mv + create) keeps the
# inode, which matters because crowdsec tails that path with an open fd.
# Drops the history - crowdsec archives what it needs to the console.
set -eu

LOG=/var/log-traefik/access.log
MAX_BYTES=52428800 # 50 MB

while :; do
  sleep 3600
  [ -f "$LOG" ] || continue
  size=$(stat -c %s "$LOG" 2>/dev/null || echo 0)
  if [ "$size" -gt "$MAX_BYTES" ]; then
    : >"$LOG"
    echo "truncated ${LOG} (was ${size} bytes)"
  fi
done
