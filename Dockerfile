ARG ALPINE_VERSION=3.16
ARG GO_VERSION=1.19

############################################################
FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION} as builder

ARG TIER_VERSION
ENV TIER_VERSION=${TIER_VERSION}
ENV CGO_ENABLED=0

WORKDIR /go/tier

RUN apk add git alpine-sdk
RUN set -ex \
  && git clone https://github.com/tierrun/tier.git -b $TIER_VERSION /go/tier \
  && go build -ldflags "-linkmode external -extldflags -static" -a ./cmd/tier

############################################################
FROM busybox:musl as release

COPY --from=builder /go/tier/tier /usr/bin/tier

ENTRYPOINT ["tier", "--live", "serve", "--addr=:80"]
