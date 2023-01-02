ARG ALPINE_VERSION=3.16
ARG GO_VERSION=1.19
ARG TIER_DEBUG=0

######################################
FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION} as builder

ARG TIER_VERSION
ENV TIER_VERSION=${TIER_VERSION}
ENV CGO_ENABLED=0

WORKDIR /go/tier

RUN apk add git alpine-sdk
RUN set -ex \
  && git clone https://github.com/tierrun/tier.git /go/tier \
  && git checkout $TIER_VERSION \
  && go build -ldflags "-linkmode external -extldflags -static" -a ./cmd/tier

######################################
FROM alpine:${ALPINE_VERSION} as dev

ENV TIER_DEBUG=${TIER_DEBUG}

RUN addgroup -S tier \
  && adduser -S tier -G tier

USER tier
COPY --from=builder --chown=tier:tier /go/tier/tier /usr/bin/tier

ENTRYPOINT ["tier"]

############################################################
FROM busybox:musl as release

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /go/tier/tier /usr/bin/tier

EXPOSE 80
ENTRYPOINT ["tier", "--live", "-v", "serve", "--addr=:80"]
