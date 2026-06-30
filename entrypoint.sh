#!/bin/sh
set -e

PUID=${PUID:-1000}
PGID=${PGID:-1000}

# --- LINUXSERVER.IO STYLE BYPASS ---
# If the user specifically requests UID 0, skip user creation 
# and run wireproxy directly as container root.
if [ "$PUID" = "0" ] || [ "$PGID" = "0" ]; then
    echo "PUID/PGID is 0. Running directly as container root..."
    exec /usr/local/bin/wireproxy -c /etc/wireproxy.conf
fi

# Otherwise, proceed with custom unprivileged user mapping
if ! getent group wireuser >/dev/null; then
    addgroup -g "$PGID" wireuser
fi

if ! getent passwd wireuser >/dev/null; then
    adduser -G wireuser -u "$PUID" -D -H wireuser
fi

echo "Switching execution to user UID: $PUID, GID: $PGID"
exec su-exec wireuser:wireuser /usr/local/bin/wireproxy -c /etc/wireproxy.conf
