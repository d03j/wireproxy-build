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

FROM docker.io/library/alpine:latest
COPY --from=builder /build/wireproxy /usr/local/bin/wireproxy
USER 65534:65534
ENTRYPOINT ["/usr/local/bin/wireproxy", "-c", "/etc/wireproxy.conf"]
