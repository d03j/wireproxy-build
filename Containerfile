ARG GO_VERSION=alpine
FROM docker.io/library/golang:${GO_VERSION} AS builder

RUN apk add --no-cache git make
WORKDIR /build

ARG WIREPROXY_TAG=latest
RUN if [ "$WIREPROXY_TAG" = "latest" ]; then \
      git clone --depth 1 https://github.com/windtf/wireproxy.git . ; \
    else \
      git clone --depth 1 --branch "$WIREPROXY_TAG" https://github.com/windtf/wireproxy.git . ; \
    fi

RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o wireproxy ./cmd/wireproxy

# --- Runtime Stage ---
FROM docker.io/library/alpine:latest

# Install su-exec to handle dropping privileges safely
RUN apk add --no-cache su-exec

COPY --from=builder /build/wireproxy /usr/local/bin/wireproxy
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Must start as root to allow entrypoint.sh to map the user IDs dynamically
USER root

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
