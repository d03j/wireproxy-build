#!/bin/sh
set -e

# Default to standard alpine IDs if variables aren't provided
PUID=${PUID:-1000}
PGID=${PGID:-1000}

# Create a dedicated group and user dynamically inside the container namespace
# matching the host UID/GID passed by the user
if ! getent group wireuser >/dev/null; then
    addgroup -g "$PGID" wireuser
fi

if ! getent passwd wireuser >/dev/null; then
    adduser -G wireuser -u "$PUID" -D -H wireuser
fi

echo "Switching execution to user UID: $PUID, GID: $PGID"

# Use su-exec to safely drop from root down to the new unprivileged user
exec su-exec wireuser:wireuser /usr/local/bin/wireproxy -c /etc/wireproxy.conf
