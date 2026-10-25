# wireproxy-build

Automated container build for `windtf/wireproxy`.

## Configuration Mounting Guide

Wireproxy expects **one and only one `[Interface]` section** per running instance. If you use multiple WireGuard profiles, you should split them into separate configuration files and run dedicated container instances for each.

* **Container Mount Path:** `/etc/wireproxy.conf`
* **Host Path Example:** `~/.config/wireproxy/wireproxy.conf`

## Usage Example (`podman run`)

Run the container as an unprivileged user in detached mode, mapping your local configuration file and proxy ports:

```bash
podman run -d \
  --name wireproxy-gateway \
  --label "io.containers.autoupdate=image" \
  -p 1080:1080 \
  -p 8080:8080 \
  -v ~/.config/wireproxy/wireproxy.conf:/etc/wireproxy.conf \
  ghcr.io/d03j/wireproxy-build:latest
```

## Registry Path
```text
ghcr.io/d03j/wireproxy-build:latest
```

## License

Distributed under the ISC License. See the LICENSE file for details.
